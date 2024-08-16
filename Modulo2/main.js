// Configuração da conexão com o banco de dados
import pg from "pg";
const { Client } = pg;

import readlineSync from 'readline-sync';

// Criando uma conexão ao banco de dados PostgreSQL
const client = new Client({
    host: 'localhost',
    user: 'julia-fortunato',
    password: '0352',
    port: 5432,
    database: 'tlou'
});

// Conectando ao banco de dados
client.connect()
    .then(() => {
    })
    .catch(err => {
        console.error('Erro ao conectar ao banco de dados:', err);
    });


// Função para exibir o nome do jogo
async function exibirNomeJogo() {
    console.log(` 
████████ ██   ██ ███████     ██       █████  ███████ ████████      ██████  ███████     ██    ██ ███████ 
   ██    ██   ██ ██          ██      ██   ██ ██         ██        ██    ██ ██          ██    ██ ██      
   ██    ███████ █████       ██      ███████ ███████    ██        ██    ██ █████       ██    ██ ███████ 
   ██    ██   ██ ██          ██      ██   ██      ██    ██        ██    ██ ██          ██    ██      ██ 
   ██    ██   ██ ███████     ███████ ██   ██ ███████    ██         ██████  ██           ██████  ███████ 
                                                                                                        
                                                                                              `);
}

// Função para exibir o texto gradativamente
function escreverTexto(texto, velocidade, callback) {
    let i = 0;
    const intervalo = setInterval(() => {
        process.stdout.write(texto[i]);
        i++;
        if (i >= texto.length) {
            clearInterval(intervalo);
            if (callback) callback();
        }
    }, velocidade);
}

// Função para exibir o texto com uma pausa
function exibirTextoGradativo(texto, velocidade, pausa, callback) {
    escreverTexto(texto, velocidade, () => {
        setTimeout(() => {
            if (callback) callback();
        }, pausa);
    });
}

async function primeiraTela() {
    try {
        console.clear();
        await exibirNomeJogo();

        // Pausa por 5 segundos antes de continuar
        await new Promise(resolve => setTimeout(resolve, 3));

        process.stdout.setEncoding('utf-8');
        console.clear();

        console.log("\n==================================");
        console.log("Bem-vindo ao The Last of Us - MUD!");
        console.log("==================================\n");

        // Exibe o texto gradativamente
        await new Promise(resolve => {
            exibirTextoGradativo(
                "O amanhecer mal começou a iluminar o horizonte quando você, Joel Miller, acorda em seu abrigo.\n",
                1, // velocidade em milissegundos por caractere
                1000, // pausa após o texto
                resolve
            );
        });

        try {
            // Obtém informações do jogador
            const infoJogador = await client.query('SELECT nomePersonagem, estado, vidaAtual FROM PC');
            console.log('\n\nSuas informações:');
            infoJogador.rows.forEach(row => {
                console.log(`Nome: ${row.nomepersonagem}, Estado: ${row.estado}, Vida Atual: ${row.vidaatual}`);
            });
        } catch (err) {
            console.error('Erro ao consultar os dados:', err.stack);

        }

         // Obtém informações da região escolhida
        const regiaoInicial = await client.query(`SELECT descricaoregiao FROM Regiao WHERE nomeregiao = 'Zona de Quarentena de Boston'`);

        // Verifica se há resultados e exibe a descrição da região
        if (regiaoInicial.rows.length > 0) {
            console.log("\n\nDescrição da Região em que você se encontra:", regiaoInicial.rows[0].descricaoregiao);
        } else {
            console.log("\n\nNenhuma região encontrada com o nome 'Zona de Quarentena de Boston'.");
        }

        await new Promise(resolve => {
            exibirTextoGradativo(
                "\n \nAo seu lado, Tess, sua parceira de sobrevivência e amiga de longa data, já está acordada, organizando suas coisas para o que será mais um dia nesse inferno que a Terra se tornou. \n" +
                "O mundo como você conhecia foi devastado há um ano, quando o surto do fungo Cordyceps, mutado por mudanças climáticas, começou a infectar seres humanos, transformando-os em criaturas hostis e extremamente perigosas.\n" +
                "Com um olhar, você e Tess decidem que é hora de sair. Vocês precisam encontrar Mark para discutir os próximos passos, talvez negociar suprimentos ou obter informações sobre a próxima rota segura. \n" +
                "No meio do caminho, porém, algo faz você parar abruptamente. À frente, uma figura familiar surge em meio aos destroços. Uma mulher segura a mão de uma criança e faz uma proposta a você.\n",
                1,
                1000,
                resolve
            );
        });


        // await new Promise(resolve => {
        //     exibirTextoGradativo(
        //         "\n\nCom um olhar, você e Tess decidem que é hora de sair. Vocês precisam encontrar Mark para discutir os próximos passos, talvez negociar suprimentos ou obter informações sobre a próxima rota segura.\n",
        //         1,
        //         1000,
        //         resolve
        //     );
        // });

        const resposta = readlineSync.question("\nDeseja aceitar a missão proposta? (s/n): ").toLowerCase();

        if (resposta !== 's') {
            console.log("Você decidiu não prosseguir.");
            await client.end();
        }

        const missaoAtual = await client.query(
            "SELECT objetivo FROM MissaoExploracaoObterItem",
        );

        // Verificar se a consulta retornou algum resultado
        if (missaoAtual.rows.length > 0) {
            // Exibir o nome da missão
            console.log("\n");
            console.log(`${missaoAtual.rows[0].objetivo.trim()}`);
        } else {
            console.log("Nenhuma missão encontrada.");
        }


        // ADICIONAR MAIS COISAS AQUI 


        // Mostra regioes disponíveis
        const regioes = await client.query("SELECT * FROM Regiao");
        console.log("\n\n\n\nRegiões disponíveis:");
        console.log("===================\n");

        const regiaoAtual = await client.query(
            "SELECT nomeRegiao FROM Regiao",
        );

        let escolhaRegiao = 0;

        // Loop para avançar pelas regiões
        while (escolhaRegiao < regioes.rows.length) {
            const regiaoAtual = regioes.rows[escolhaRegiao];
            console.log(`${escolhaRegiao + 1}. ${regiaoAtual.nomeregiao.trim()} - ${regiaoAtual.descricaoregiao.trim()}`);

            // Perguntar se o jogador deseja prosseguir para a próxima região
            if (escolhaRegiao > 0) { // Só pergunta a partir da segunda região
                const resposta = readlineSync.question("\nDeseja prosseguir para a próxima região? (s/n): ").toLowerCase();

                if (resposta !== 's') {
                    console.log("Você decidiu não prosseguir.");
                    break;
                }
            }

            // Exibir a região escolhida
            console.log(`\nIndo para a região ${regiaoAtual.nomeregiao.trim()}...\n`);

            // Incrementar para a próxima região
            escolhaRegiao += 1;
        }
        //SELECT conteudo FROM dialoga WHERE iddialogo = 1;
        // Fim do jogo ou da escolha
        if (escolhaRegiao >= regioes.rows.length) {
            console.log("Você visitou todas as regiões disponíveis.");
        }

    } catch (error) {
        console.error("\nErro ao executar o início do jogo:", error.message || error);
    } finally {
        console.log("\n----------------------------------------------------------------------");
        console.log("Fechando a conexão com o banco de dados...");
        await client.end();
        console.log("Banco desconectado com sucesso!");
        console.log("----------------------------------------------------------------------\n");
    }
}
primeiraTela();
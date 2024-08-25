import pg from "pg";
import readlineSync from 'readline-sync';

const { Client } = pg;

const client = new Client({
    host: 'localhost',
    user: 'postgres',
    password: 'postgres',
    port: 5432,
    database: 'tlou'
});

async function conectarBanco() {
    try {
        await client.connect();
        console.log("Conectado ao banco de dados com sucesso.");
    } catch (error) {
        console.error("Erro ao conectar ao banco de dados:", error);
    }
}

async function primeiraTela() {
    try {

        console.clear();

        console.log(` 
            ████████ ██   ██ ███████     ██       █████  ███████ ████████      ██████  ███████     ██    ██ ███████ 
               ██    ██   ██ ██          ██      ██   ██ ██         ██        ██    ██ ██          ██    ██ ██      
               ██    ███████ █████       ██      ███████ ███████    ██        ██    ██ █████       ██    ██ ███████ 
               ██    ██   ██ ██          ██      ██   ██      ██    ██        ██    ██ ██          ██    ██      ██ 
               ██    ██   ██ ███████     ███████ ██   ██ ███████    ██         ██████  ██           ██████  ███████ 
                                                                                                                    
                                                                                                          `);

        console.log("Bem-vindo ao The Last of Us - MUD!\n");

        const infoJogador = await client.query('SELECT nomePersonagem, estado, vidaAtual, xp FROM PC');
        if (infoJogador.rows.length > 0) {
            const jogador = infoJogador.rows[0];
            console.log(`Nome: ${jogador.nomepersonagem}, Estado: ${jogador.estado}, Vida Atual: ${jogador.vidaatual}, Experiência: ${jogador.xp}`);
        }

        // Obtém a região atual do jogador e as salas disponíveis
        const regiaoAtual = await client.query(`
            SELECT r.nomeRegiao, r.descricaoRegiao, s.idSala 
            FROM Regiao r 
            JOIN Sala s ON s.idRegiao = r.idRegiao 
            JOIN PC p ON p.sala = s.idSala
        `);

        if (regiaoAtual.rows.length > 0) {
            const regiao = regiaoAtual.rows[0];
            console.log(`\nVocê está na região: ${regiao.nomeregiao}`);
            console.log(`Descrição: ${regiao.descricaoregiao}\n`);

            const salasDaReg = await client.query(`
                SELECT idSala FROM Sala WHERE idRegiao = 1;
            `);
            if (salasDaReg.rows.length > 0) {
                console.log("Salas disponíveis nesta região:");
                salasDaReg.rows.forEach((sala, index) => {
                    console.log(`${index + 1}. Sala ${sala.idsala}`);
                });

                let escolhaSala;

                do {
                    escolhaSala = readlineSync.questionInt("\nEscolha uma sala para explorar: ");
                } while (escolhaSala < 1);

                const query = 'UPDATE PC SET Sala = $1 WHERE IdPersonagem = $2'; // Adapte o WHERE conforme necessário
                const values = [escolhaSala, 1]; // para o id do personagem sendo 1, o joel

                await client.query(query, values);
                console.log("Sala atualizada com sucesso!");


                if (escolhaSala == 1) {
                    await mostrarNPCsDaSala(escolhaSala);

                    const DialogoInicio = 1;
                    const DialogoFim = 6;
                    await mostrarDialogo(DialogoInicio, DialogoFim);

                    await mostrarItensDaSala(escolhaSala);

                }
            } else {
                console.log("Nenhuma sala disponível na região atual.");
            }

        } else {
            console.log("Nenhuma região encontrada para o jogador.");
        }

    } catch (error) {
        console.error("Erro ao executar o início do jogo:", error.message || error);
    } finally {
        console.log("Fechando a conexão com o banco de dados...");
        await client.end();
        console.log("Banco desconectado com sucesso!");
    }
}

// Função para exibir os itens da sala atual
async function mostrarItensDaSala(idSala) {
    try {
        const itens = await client.query(`
    SELECT 
    COALESCE(a.nomeItem, v.nomeItem, c.nomeItem) AS nomeItem,
    COUNT(*) AS quantidade
    FROM InstItem it
    LEFT JOIN Consumivel c ON it.idItem = c.idItem
    LEFT JOIN Arma a ON it.idItem = a.idItem
    LEFT JOIN Vestimenta v ON it.idItem = v.idItem
    WHERE it.Sala = $1
    GROUP BY COALESCE(a.nomeItem, v.nomeItem, c.nomeItem);
`, [idSala]);

        if (itens.rows.length === 0) {
            console.log("Nenhum item encontrado nesta sala.");
        } else {
            console.log("\nItens encontrados na sala atual:");
            itens.rows.forEach(item => {
                console.log(`${item.nomeitem}: ${item.quantidade}`);
            });
        }
    } catch (error) {
        console.error("Erro ao listar os itens da sala:", error.message || error);
    }
}

// Função para exibir os NPCs da sala atual
async function mostrarNPCsDaSala(idSala) {
    try {
        const npcs = await client.query(`
    SELECT nomePersonagem, tipoNPC, eAliado 
    FROM NPC 
    WHERE Sala = $1
`, [idSala]);

        if (npcs.rows.length === 0) {
            console.log("Nenhum NPC encontrado nesta sala.");
        } else {
            console.log("\nNPCs encontrados na sala atual:");
            npcs.rows.forEach(npc => {
                const tipo = npc.ealiado ? "Aliado" : "Inimigo";
                console.log(`- ${npc.nomepersonagem}: ${tipo}`);
            });
        }
    } catch (error) {
        console.error("Erro ao listar os NPCs da sala:", error.message || error);
    }
}

// Função para exibir um dialogo
async function mostrarDialogo(DialogoInicio, DialogoFim) {
    console.log(`\n`);
    try {
        const dialogo = await client.query(`
            SELECT conteudo
            FROM Dialoga
            WHERE idDialogo BETWEEN $1 AND $2
        `, [DialogoInicio, DialogoFim]);

        if (dialogo.rows.length === 0) {
            console.log("Nenhum diálogo encontrado no intervalo de IDs fornecido.");
        } else {
            dialogo.rows.forEach(dialogo => {
                console.log(`${dialogo.conteudo}`);
            });
        }
    } catch (error) {
        console.error("Erro ao listar os diálogos:", error.message || error);
    }
}


async function iniciarJogo() {
    await conectarBanco();
    await primeiraTela();
}

iniciarJogo();

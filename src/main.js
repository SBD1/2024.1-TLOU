import { question } from "readline-sync";
import readlineSync from 'readline-sync';
import Api from "./api.js";

function askAndReturn(texto) {
  return question(texto);
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms * 1000));
}

function separador() {
  console.log("===================================================================================================================\n")
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

    separador();
    console.log("Bem-vindo ao The Last of Us - MUD!\n");
    separador();

    var api = new Api();

    let r = askAndReturn(
      "1- Jogar\n2- Sair\n3- Criar e Popular Tabelas\n"
    );

    if (r == 3) {
      try {
        let table = await api.createTables();
        let popu = await api.populateTables();
        await sleep(1);
        console.clear();
        if (table && popu) {
          console.log("\n\nTabelas criadas e populadas com sucesso");
          separador();
          await sleep(1);
        }
      } catch (error) {
        console.log(error);
      }
      r = askAndReturn("1- Jogar\n2- Sair\n");
    }

    if (r == 2) {
      console.log("Banco desconectado com sucesso!");
      process.exit();
    }

    await segundaTela();

    async function segundaTela() {
      if (r == 1) {
        const infoJogador = await api.client.query('SELECT nomePersonagem, estado, vidaAtual, xp FROM PC');
        if (infoJogador.rows.length > 0) {
          const jogador = infoJogador.rows[0];
          console.log(`Seu nome é: ${jogador.nomepersonagem}, Estado: ${jogador.estado}\nVida Atual: ${jogador.vidaatual}, Experiência: ${jogador.xp}`);
        }

        // Obtém a região atual do jogador e as salas disponíveis
        const regiaoAtual = await api.client.query(`
            SELECT r.nomeRegiao, r.descricaoRegiao
            FROM Regiao r 
            JOIN Sala s ON s.idRegiao = r.idRegiao 
            JOIN PC p ON p.sala = s.idSala
            `);

        if (regiaoAtual.rows.length > 0) {
          const regiao = regiaoAtual.rows[0];
          console.log(`\nVocê está na região: ${regiao.nomeregiao}`);
          console.log(`Descrição: ${regiao.descricaoregiao}\n`);

          const salasDaReg = await api.client.query(`
                SELECT idSala FROM Sala WHERE idRegiao = 1;
                `);
          if (salasDaReg.rows.length > 0) {
            console.log("Salas disponíveis nesta região:");
            salasDaReg.rows.forEach((sala, index) => {
              console.log(`${index + 1}. Sala ${sala.idsala}`);
            });

            console.log("\nC. Craft - Ver receitas disponíveis");

            // VAI DA PROBLEMA SE TIVER MAIS Q 2 SALAS RS
            // while (!['V', 'v'].includes(escolhaReceita) && (isNaN(escolhaReceita) || escolhaReceita < 1 || escolhaReceita > receitas.rows.length));
            let escolhaSalaOuCraft;
            escolhaSalaOuCraft = askAndReturn("\nPressione 'C' para Craft: ");

            if (escolhaSalaOuCraft.toLowerCase() === 'c') {
              await mostrarReceitas();
              async function mostrarReceitas() {
                console.log("\nReceitas de Crafting disponíveis:\n");

                const receitas = await api.client.query('SELECT * FROM Receita');

                if (receitas.rows.length > 0) {
                  receitas.rows.forEach((receita, index) => {
                    console.log(`${index + 1}. Receita: ${receita.nomereceita}, Descrição: ${receita.descricaoreceita}, Ingredientes: ${receita.juncao}`);
                  });

                  let escolhaReceita;
                  do {
                    escolhaReceita = askAndReturn("\nEscolha o número da receita para realizá-la ou pressione 'V' para voltar: ");

                    if (escolhaReceita.toLowerCase() === 'v') {
                      console.log("\n\n");
                      return segundaTela(); // Sai da função mostrarReceitas e volta ao menu principal
                    }

                    if (!isNaN(escolhaReceita) && escolhaReceita >= 1 && escolhaReceita <= receitas.rows.length) {
                      const receitaEscolhida = receitas.rows[parseInt(escolhaReceita) - 1];
                      console.log(`Você escolheu a receita: ${receitaEscolhida.nomereceita}`);

                      await realizarReceita(receitaEscolhida);

                      // Após realizar a receita, continua no loop para permitir escolha de outra receita
                    } else {
                      console.log("Escolha inválida, tente novamente.");
                    }
                  } while (true); // Continua pedindo a escolha até que o usuário decida voltar
                } else {
                  console.log("Nenhuma receita de crafting disponível.");
                }
              }

              async function realizarReceita(receita) {
                try {
                  console.log(`Realizando a receita: ${receita.nomereceita}`);

                  // Aqui vai a lógica para verificar ingredientes, atualizar inventário, etc.
                  // Exemplo:
                  /*const possuiIngredientes = await api.verificarIngredientes(receita.iditem);  Função que verifica se o jogador tem os ingredientes
                  if (possuiIngredientes) {
                    await api.craftarItem(receita);  //Função que realiza o crafting
                    console.log(`Receita ${receita.nomereceita} realizada com sucesso!`);
                  } else {
                    console.log("Você não possui todos os ingredientes necessários para esta receita.");
                  }*/
                } catch (error) {
                  console.error("Erro ao realizar a receita:", error.message || error);
                }
              }
            }


            // Atualiza a sala do jogador para a escolhida
            var sala = await api.getSalaAtual();
            //await sleep(5);
            //console.clear();

            if (sala == 1) {
              await api.mostrarNPCsDaSala(sala);
              await api.evento(sala);
              const DialogoInicio = 1;
              const DialogoFim = 6;
              await api.mostrarDialogo(DialogoInicio, DialogoFim);
              await api.mostrarItensDaSala(sala);

              let choose = askAndReturn("Você encontrou alguns itens na sala. Deseja pegá-los\nS/N\n");
              if (choose.toLowerCase() == 's') {
                await api.adicionarItemAoInventario(1, 1, 18);
                await api.adicionarItemAoInventario(2, 1, 18);
                await api.adicionarItemAoInventario(3, 1, 18);
                await api.adicionarItemAoInventario(4, 1, 18);
                await api.adicionarItemAoInventario(5, 1, 18);
                await api.adicionarItemAoInventario(6, 1, 12);
                await api.adicionarItemAoInventario(7, 1, 12);
                await api.adicionarItemAoInventario(8, 1, 17);
                await api.adicionarItemAoInventario(9, 1, 17);
                await api.updateCapacidadeInventario(1);

                console.log("\nItens adicionados ao inventário com sucesso!\n");
              }
              let escolha = askAndReturn("Deseja ver seu inventário?\nS/N\n");
              if (escolha.toLowerCase() == 's') {
                console.log("Seu inventário atual é:");
                await api.mostrarInventario();
              }
              console.log("\n\nVocê irá agora para sala 2, aguarde...");
              await api.updateSala(sala + 1);
              await sleep(5);
              console.clear();
            }
            sala = await api.getSalaAtual();
            if (sala == 2) {
              await api.mostrarNPCsDaSala(sala);
              const DialogoInicio = 7;
              const DialogoFim = 8;
              await api.mostrarDialogo(DialogoInicio, DialogoFim);
              await api.objetivoExploracao(sala);

              const mis = askAndReturn("\nVocê aceita essa missão?\nS/N\n");
              if (mis.toLowerCase() == 's') {
                console.log("Missão aceita!");

                await api.mostrarInimigoNPC(sala);
                console.log("Proteja Ellie e Tess!");
                await api.mostrarArmas();


              }

              //update no xp(ja ta pronto)
              //matar inimigo
              await api.updateSala(sala + 1);
              await sleep(5);
              console.clear();
            }
            sala = await api.getSalaAtual();
            console.log(sala);
          }
        }
      }
    }
  } catch (error) {
    console.error("Erro ao executar o início do jogo:", error.message || error);
  }
  finally {
    console.log("Fechando a conexão com o banco de dados...");
    console.log("Banco desconectado com sucesso!");
    await api.updateSala(1);
    process.exit();
  }
}

async function iniciarJogo() {
  await primeiraTela();
}

iniciarJogo();

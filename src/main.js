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

    const api = new Api();

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
            do {
              escolhaSalaOuCraft = askAndReturn("\nEscolha uma sala para explorar ou pressione 'C' para Craft: ");
            } while (!['1', '2', 'C', 'c'].includes(escolhaSalaOuCraft));





            if (escolhaSalaOuCraft.toLowerCase() === 'c') {
              await mostrarReceitas();
              async function mostrarReceitas() {
                console.log("\nReceitas de Crafting disponíveis:\n");

                const receitas = await api.client.query('SELECT * FROM Receita');

                if (receitas.rows.length > 0) {
                  receitas.rows.forEach((receita, index) => {
                    console.log(`${index + 1}. Receita: ${receita.nomereceita}, Descrição: ${receita.descricaoreceita}, Ingredientes: ${receita.iditem}`);
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
                  /*const possuiIngredientes = await api.verificarIngredientes(receita.iditem); // Função que verifica se o jogador tem os ingredientes
                  if (possuiIngredientes) {
                    await api.craftarItem(receita); // Função que realiza o crafting
                    console.log(`Receita ${receita.nomereceita} realizada com sucesso!`);
                  } else {
                    console.log("Você não possui todos os ingredientes necessários para esta receita.");
                  }*/
                } catch (error) {
                  console.error("Erro ao realizar a receita:", error.message || error);
                }
              }








            }

            // Atualiza a sala do jogador
            const query = 'UPDATE PC SET Sala = $1 WHERE IdPersonagem = $2'; // Adapte o WHERE conforme necessário
            const values = [escolhaSalaOuCraft, 1]; // para o id do personagem sendo 1, o joel

            await api.client.query(query, values);

            if (escolhaSalaOuCraft == 1) {
              await api.mostrarNPCsDaSala(escolhaSalaOuCraft);
              const DialogoInicio = 1;
              const DialogoFim = 6;
              await api.mostrarDialogo(DialogoInicio, DialogoFim);
              await api.evento(escolhaSalaOuCraft);
              await api.mostrarItensDaSala(escolhaSalaOuCraft);

              console.log("\nVocê encontrou alguns itens! Deseja pegá-los?");
              let choose = askAndReturn("S/N\n");

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
              } else {
                console.log("\nVocê não quis os itens.\n");
              }

              let escolha = askAndReturn("Deseja ver seu inventário?\nS/N\n");
              if (escolha.toLowerCase() == 's') {
                console.log("Seu inventário atual é:");
                await api.mostrarInventario();
              }
              console.log("\n\nVocê irá agora para sala 2, aguarde...");

              escolhaSalaOuCraft = 2;
              await sleep(4);
              console.clear();
            }

            if (escolhaSalaOuCraft == 2) {
              // await api.mostrarNPCsDaSala(escolhaSalaOuCraft);

              const DialogoInicio = 7;
              const DialogoFim = 8;
              await api.mostrarDialogo(DialogoInicio, DialogoFim);

              await api.missaoExploracao(escolhaSalaOuCraft);

              var mis = askAndReturn("\nVocê aceita essa missão?\nS/N\n");

              if (mis.toLowerCase() == 's') {
                console.log("Missão aceita!");
                console.log("Você está saindo da zona de quarentena");

              } else {
                console.log("Missão recusada!");
              }

              //update no xp(ja ta pronto)
              //matar inimigo
            }
          } else {
            console.log("Nenhuma sala disponível na região atual.");
          }

        } else {
          console.log("Nenhuma região encontrada para o jogador.");
        }

      }
    }
  } catch (error) {
    console.error("Erro ao executar o início do jogo:", error.message || error);
  }
  finally {
    console.log("Fechando a conexão com o banco de dados...");
    console.log("Banco desconectado com sucesso!");
    process.exit();
  }
}

async function iniciarJogo() {
  await primeiraTela();
}

iniciarJogo();
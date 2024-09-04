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

          let escolhaSala;
          do {
            escolhaSala = readlineSync.questionInt("\nEscolha uma sala para explorar: ");
          } while (escolhaSala < 1);

          const query = 'UPDATE PC SET Sala = $1 WHERE IdPersonagem = $2'; // Adapte o WHERE conforme necessário
          const values = [escolhaSala, 1]; // para o id do personagem sendo 1, o joel

          await api.client.query(query, values);

          if (escolhaSala == 1) {
            await api.mostrarNPCsDaSala(escolhaSala);
            const DialogoInicio = 1;
            const DialogoFim = 6;
            await api.mostrarDialogo(DialogoInicio, DialogoFim);
            await api.evento(escolhaSala);
            await api.mostrarItensDaSala(escolhaSala);

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

            escolhaSala = 2;
            await sleep(4);
            console.clear();
          }

          if (escolhaSala == 2) {
            // await api.mostrarNPCsDaSala(escolhaSala);

            const DialogoInicio = 7;
            const DialogoFim = 8;
            await api.mostrarDialogo(DialogoInicio, DialogoFim);

            await api.missaoExploracao(escolhaSala);

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
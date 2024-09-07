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
      try {
        const infoJogador = await api.client.query('SELECT nomePersonagem, estado, vidaAtual, xp FROM PC');
        if (infoJogador.rows.length > 0) {
          const jogador = infoJogador.rows[0];
          console.clear();
          console.log(`Seu nome é: ${jogador.nomepersonagem}, Estado: ${jogador.estado}\nVida Atual: ${jogador.vidaatual}, Experiência: ${jogador.xp}`);
        }

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
          const x = await api.getSalaAtual();
          await moverParaSala(x);

          // const salasDaReg = await api.client.query('SELECT idSala FROM Sala WHERE idRegiao = 1');
          // if (salasDaReg.rows.length > 0) {
          //   console.log("Salas disponíveis nesta região:");
          //   salasDaReg.rows.forEach((sala, index) => {
          //     console.log(`${index + 1}. Sala ${sala.idsala}`);
          //   });

          //   console.log("\nC. Craft - Ver receitas disponíveis\nI. Inventário");

          //   let escolhaOp;
          //   do {
          //     escolhaOp = askAndReturn("\nEscolha a opção desejada: ");

          //     if (escolhaOp.toLowerCase() === 'i') {
          //       console.log("Seu inventário atual é:");
          //       await api.mostrarInventario();
          //     } else if (escolhaOp.toLowerCase() === 'c') {
          //       await mostrarReceitas();
          //     } else if (!isNaN(escolhaOp) && escolhaOp >= 1 && escolhaOp <= salasDaReg.rows.length) {
          //       const salaEscolhida = salasDaReg.rows[parseInt(escolhaOp) - 1];
          //       console.log(`Você escolheu a Sala: ${salaEscolhida.idsala}`);

          //       await moverParaSala(salaEscolhida.idsala);

          //       break;  //Sai do loop quando uma sala válida é escolhida necessário??
          //     } else {
          //       console.log("Escolha inválida, tente novamente.");
          //     }
          //   } while (true); // Continua pedindo a escolha até que o usuário decida
          // } else {
          //   console.log("Nenhuma sala disponível nesta região.");
          // }
        }
      } catch (error) {
        console.error("Erro ao executar o início do jogo:", error.message || error);
      }
    }

    //Função para mostrar receitas
    // async function mostrarReceitas() {
    //   console.log("\nReceitas de Crafting disponíveis:\n");

    //   const receitas = await api.client.query('SELECT * FROM Receita');

    //   if (receitas.rows.length > 0) {
    //     receitas.rows.forEach((receita, index) => {
    //       console.log(`${index + 1}. Receita: ${receita.nomereceita}, Descrição: ${receita.descricaoreceita}, Ingredientes: ${receita.juncao}`);
    //     });

    //     let escolhaReceita;
    //     do {
    //       escolhaReceita = askAndReturn("\nEscolha o número da receita para realizá-la ou pressione 'V' para voltar: ");

    //       if (escolhaReceita.toLowerCase() === 'v') {
    //         console.log("\n\n");
    //         return segundaTela();  //Sai da função mostrarReceitas e volta ao menu principal
    //       }

    //       if (!isNaN(escolhaReceita) && escolhaReceita >= 1 && escolhaReceita <= receitas.rows.length) {
    //         const receitaEscolhida = receitas.rows[parseInt(escolhaReceita) - 1];
    //         console.log(`Você escolheu a receita: ${receitaEscolhida.nomereceita}`);

    //         await realizarReceita(receitaEscolhida);

    //       } else {
    //         console.log("Escolha inválida, tente novamente.");
    //       }
    //     } while (true);  //Continua pedindo a escolha até que o usuário decida voltar
    //   } else {
    //     console.log("Nenhuma receita de crafting disponível.");
    //   }
    // }

    //Função para realizar a receita
    // async function realizarReceita(receita) {
    //   try {
    //     console.log(`Realizando a receita: ${receita.nomereceita}`);
    //     const idReceitaNovo = receita.idreceita;

    //     const itemRecebido = await api.client.query(`
    //        SELECT idItem
    //        FROM Receita
    //        WHERE idReceita = $1`, [idReceitaNovo]
    //     );
    //     if (itemRecebido === 0) {
    //       console.log("nao recebeu item");
    //     } else {
    //       itemRecebido.rows.forEach(item => {
    //         console.log(`id correto do item: ${item.iditem}`);
    //       });
    //     }
    //     const itemRecebidoCount = parseInt(itemRecebido.rows[0].iditem, 10);

    //     if (!itemRecebido) {
    //       console.log("Não foi possível encontrar o idItem para a receita fornecida.");
    //     } else {
    //       console.log("ID do item escolhido:", itemRecebidoCount);
    //     }

    //     //Verifica se o jogador tem todos os ingredientes necessários
    //     const temIngredientes = await verificarIngredientes(idReceitaNovo);

    //     if (!temIngredientes) {
    //       console.log("Você não tem todos os ingredientes necessários para esta receita.");
    //       return;
    //     }

    //     //Vê quais ingredientes foram usados na receita para remover depois
    //     const ingredientes = await api.client.query(`
    //        SELECT IdItem, quantidadeIngre
    //        FROM Ingrediente
    //        WHERE IdReceita = $1;
    //        `, [idReceitaNovo]);

    //     api.mostrarInventario();
    //     //Remove os ingredientes entes.rows) {
    //     for (const ingr of ingredientes.rows) {
    //       await api.client.query(`
    //           UPDATE Inventario
    //           SET capacidade = capacidade + 2 
    //           WHERE idInventario = 1;
    //         `);

    //       await api.client.query(`
    //            WITH item_to_delete AS (
    //              SELECT idInstItem
    //              FROM InstItem
    //              WHERE idItem = $1 AND IdInventario = 1
    //              LIMIT 1
    //            )
    //            DELETE FROM InstItem
    //            USING item_to_delete
    //            WHERE InstItem.idInstItem = item_to_delete.idInstItem;
    //          `, [ingr.iditem]);
    //     }

    //     //Chama a função para executar a consulta
    //     const instanciaItem = await api.client.query(`
    //        SELECT MAX(idInstItem) as total
    //        FROM InstItem
    //      `);

    //     const itemnovo1 = parseInt(instanciaItem.rows[0].total, 10);
    //     const idItemMaisNovo = itemnovo1 + 1;

    //     // adicionando o item da receita
    //     await api.client.query(`z
    //         INSERT INTO InstItem (idInstItem, IdItem, Sala, IdInventario)
    //         VALUES ($1, $2, null, 1);`, [idItemMaisNovo, itemRecebidoCount]);

    //     api.mostrarInventario();
    //     console.log("EUASODUFHAISDUF");

    //     console.log("\n\nverificar se entrou o kit no inventário:\n\n");

    //     await api.client.query(`
    //        UPDATE Inventario
    //        SET capacidade = GREATEST(capacidade - 1, 0)
    //        WHERE idInventario = 1;
    //        `);

    //     console.log(`Você criou com sucesso: ${receita.nomereceita}`);

    //   } catch (error) {
    //     console.error("Erro ao realizar a receita:", error.message || error);
    //   }
    // }

    // async function verificarIngredientes(idReceita) {
    //   try {
    //     // Consulta os ingredientes necessários para a receita escolhida
    //     const ingredientes = await api.client.query(`
    //       SELECT i.IdItem, i.quantidadeIngre
    //       FROM Ingrediente i
    //       WHERE i.IdReceita = $1
    //     `, [idReceita]);

    //     // Consulta o inventário do jogador, contando os itens por IdItem
    //     const inventario = await api.client.query(`
    //       SELECT i.IdItem, COUNT(i.idInstItem) AS totalitens
    //       FROM InstItem i
    //       JOIN Inventario ii ON i.IdInventario = ii.idInventario
    //       LEFT JOIN Arma a ON i.IdItem = a.IdItem
    //       LEFT JOIN Vestimenta v ON i.IdItem = v.IdItem
    //       LEFT JOIN Consumivel c ON i.IdItem = c.IdItem
    //       GROUP BY i.IdItem
    //     `);

    //     // Verifica se o jogador tem todos os ingredientes necessários
    //     for (const ingr of ingredientes.rows) {
    //       const itemInventario = inventario.rows.find(item => item.iditem === ingr.iditem);

    //       if (!itemInventario || itemInventario.totalitens < ingr.quantidadeingre) {
    //         console.log("Ingrediente faltando ou quantidade insuficiente");
    //         return false;
    //       }
    //     }

    //     return true;  // Todos os ingredientes estão presentes
    //   } catch (error) {
    //     console.error('Erro ao verificar ingredientes:', error);
    //     throw error;
    //   }
    // }

    async function moverParaSala(salaEscolhida) {
      try {
        // Atualiza a sala do jogador no banco de dados
        await api.updateSala(salaEscolhida);

        // Obtem a nova sala atual do jogador
        let salaAtual = await api.getSalaAtual();

        if (salaAtual == 1) {
          await api.mostrarInventario();
          await api.mostrarNPCsDaSala(salaAtual);
          await api.evento(salaAtual);
          const DialogoInicio = 1;
          const DialogoFim = 6;
          await api.mostrarDialogo(DialogoInicio, DialogoFim);
          await api.mostrarItensDaSala(salaAtual);

          // let choose = askAndReturn("Você encontrou alguns itens na sala. Deseja pegá-los\nS/N\n");
          // if (choose.toLowerCase() == 's') {
          //   await api.adicionarItemAoInventario(1, 1, 18);
          //   await api.adicionarItemAoInventario(2, 1, 18);
          //   await api.adicionarItemAoInventario(3, 1, 18);
          //   await api.adicionarItemAoInventario(4, 1, 18);
          //   await api.adicionarItemAoInventario(5, 1, 18);
          //   await api.adicionarItemAoInventario(6, 1, 12);
          //   await api.adicionarItemAoInventario(7, 1, 12);
          //   await api.adicionarItemAoInventario(8, 1, 17);
          //   await api.adicionarItemAoInventario(9, 1, 17);
          //   await api.updateCapacidadeInventario(1);

          //   console.log("\nItens adicionados ao inventário com sucesso!\n");
          // }

          let escolha = askAndReturn("Deseja ver seu inventário?\nS/N\n");
          if (escolha.toLowerCase() == 's') {
            console.log("Seu inventário atual é:");
            await api.mostrarInventario();
          }
          console.log("\n\nVocê irá agora para sala 2, aguarde...");
          await api.updateSala(salaAtual + 1);
          await sleep(2);
          console.clear();
        }

        salaAtual = await api.getSalaAtual();

        if (salaAtual == 2) {
          console.log("Você está na Sala 2.");
          await api.mostrarNPCsDaSala(salaAtual);
          await api.mostrarDialogo(7, 8);
          await api.objetivoExploracao(salaAtual);

          const mis = askAndReturn("\nVocê aceita essa missão?\nS/N\n");
          if (mis.toLowerCase() == 's') {
            await api.mostrarInimigoNPC(salaAtual);

            console.log("\nProteja Ellie e Tess!");
            await api.mostrarArmas();
            let armaUsada = askAndReturn("Escolha a arma que deseja usar: ");

            await api.mostrarInimigoNPC(salaAtual);
            await api.atacarNPC(14, armaUsada, salaAtual);
            await api.updateVidaNPC(14);

            await api.atacarNPC(14, armaUsada, salaAtual);
            await api.updateVidaNPC(14);

            console.log("\nParabéns você salvou a Ellie e a Tess, concluindo a missão, você ganhará XP por matar os infectados e concluir a missão!\n");
            await api.updateXPMisJoelExp(1);
            await api.updateXPInfec(14);

            console.log("\nVocê conseguiu sair da Zona de Quarentena");
            await api.mostrarDialogo(38, 48);
            console.log("\nApós a morte da Tess, você decide seguir o caminho com Ellie a fim de salvar o mundo.");

          } else if (mis.toLowerCase() == 'n') {
            console.log("Você tem que aceitar a missão para continuar jogando :)");
            console.log("Banco desconectado com sucesso!");
            process.exit();
          }

          await api.updateSala(salaAtual + 1);
          await sleep(4);
        }
        console.clear();
        //sala 3
        salaAtual = await api.getSalaAtual();

        const regiaoAtual = await api.client.query(`
          SELECT r.nomeRegiao, r.descricaoRegiao
          FROM Regiao r 
          JOIN Sala s ON s.idRegiao = r.idRegiao 
          JOIN PC p ON p.sala = s.idSala`);

        if (regiaoAtual.rows.length > 0) {
          const regiao = regiaoAtual.rows[0];
          console.log(`\nVocê está na região: ${regiao.nomeregiao}`);
          console.log(`Descrição: ${regiao.descricaoregiao}\n`);
        }

        await api.mostrarDialogo(9, 11);
        await api.mostrarItensDaSala(salaAtual);
        await api.updateVidaVestimenta();

        let escolha = askAndReturn("\nDeseja ver seu inventário?\nS/N\n");
        if (escolha.toLowerCase() == 's') {
          console.log("Seu inventário atual é:");
          await api.mostrarInventario();
        }

        await api.updateSala(salaAtual + 1);
        await sleep(4);
        console.clear();

        salaAtual = await api.getSalaAtual();
        //sala4
        console.log("Você está na Sala 4.");

        console.log("Depois de pegar alguns itens na sala, você encontra uma missão.");

        const misprat1 = askAndReturn("\nVocê aceita essa missão?\nS/N\n");
        if (misprat1.toLowerCase() == 's') {
          console.log("Missão aceita!");
          await api.objetivoPatrulha(salaAtual);

          await api.mostrarInimigoNPC(salaAtual);

          console.log("\nMate todos seus inimigos");
          await api.mostrarArmas();
          let armaUsada = askAndReturn("Escolha a arma que deseja usar: ");

          await api.mostrarInimigoNPC(salaAtual);
          await api.atacarNPC(14, armaUsada, salaAtual);
          await api.updateVidaNPC(14);
          console.log("\nVocê matou um Corredor!\n");

          await api.atacarNPC(14, armaUsada, salaAtual);
          await api.updateVidaNPC(14);
          console.log("\nVocê matou outro Corredor!\n");

          await api.atacarNPC(14, armaUsada, salaAtual);
          await api.updateVidaNPC(14);
          console.log("\nVocê matou mais um Corredor!\n");

          await api.atacarNPC(15, armaUsada, salaAtual);
          await api.updateVidaNPC(15);
          console.log("\nVocê matou um Corredor!\n");

          console.log("\nEsses são ESTALADORES, são mais perigosos\n")

          await api.atacarNPC(15, armaUsada, salaAtual);
          await api.updateVidaNPC(15);
          console.log("\nVocê matou um Estalador\n!");

          await api.atacarNPC(15, armaUsada, salaAtual);
          await api.updateVidaNPC(15);
          console.log("\nVocê matou mais um Estalador\n!");

          console.log("Parabéns você matou todos os inimigos, concluindo a missão, você ganhará xp por concluir a missão!\n");
          await api.mostrarInventario();
          await api.updateXPMisJoelPatr(1);
          await api.updateXPInfec(14);
          await api.updateXPInfec(15);

          console.log("Você conseguiu sair da Zona de Quarentena");
          await api.mostrarDialogo(12, 13);
          console.log("Após a morte da Tess, você decide seguir o caminho com Ellie a fim de salvar o mundo!");
        }


        // sala 3 
      } catch (error) {
        console.error("Erro ao mover para a sala:", error.message || error);
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
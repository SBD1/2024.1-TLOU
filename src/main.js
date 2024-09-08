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
    //console.clear();

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
        //console.clear();
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
          //console.clear();
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
          await processarSala1(salaAtual);
        }
        else if (salaAtual == 2) {
          await processarSala2(salaAtual);
        }
        else if (salaAtual == 3) {
          await processarSala3(salaAtual);
        }
        else if (salaAtual == 4) {
          await processarSala4(salaAtual);
        }
        else if (salaAtual == 5) {
          await processarSala5(salaAtual);
        }
        else if (salaAtual == 6) {
          await processarSala6(salaAtual);
        }
        else if (salaAtual == 7) {
          await processarSala7(salaAtual);
        }
        else if (salaAtual == 8) {
          await processarSala8(salaAtual);
        }
        else if (salaAtual == 9) {
          await processarSala9(salaAtual);
        }
        else if (salaAtual == 10) {
          await processarSala10(salaAtual);
        }
        else if (salaAtual == 11) {
          await processarSala11(salaAtual);
        }
        else if (salaAtual == 12) {
          await processarSala12(salaAtual);
        }
        else if (salaAtual == 13) {
          await processarSala13(salaAtual);
        }

        async function processarSala1(salaAtual) {
          await api.mostrarInventario();
          await api.mostrarNPCsDaSala(salaAtual);
          await api.evento(salaAtual);
          const DialogoInicio = 1;
          const DialogoFim = 6;
          await api.mostrarDialogo(DialogoInicio, DialogoFim);
          await api.mostrarItensDaSala(salaAtual);
          await api.verInventario();
          await api.mudarParaProximaSala(2, processarSala2);
        };

        async function processarSala2(salaAtual) {
          await api.infos();
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
            await api.updateXPNPC(14);

            console.log("\nVocê conseguiu sair da Zona de Quarentena");
            await api.mostrarDialogo(38, 48);
            console.log("\nApós a morte da Tess, você decide seguir o caminho com Ellie a fim de salvar o mundo.");

            await api.mudarParaProximaSala(3, processarSala3);

          } else if (mis.toLowerCase() == 'n') {
            console.log("Você tem que aceitar a missão para continuar jogando :)");
            // REMOVA O process.exit() AQUI
            console.log("Reiniciando a missão...");
            await processarSala2(salaAtual); // Reiniciar a missão se o jogador recusar
          }
        };

        async function processarSala3(salaAtual) {
          await api.infos();
          await api.mostrarDialogo(9, 11);
          await api.mostrarItensDaSala(salaAtual);
          await api.updateVidaVestimenta();

          let escolha = askAndReturn("\nDeseja ver seu inventário?\nS/N\n");
          if (escolha.toLowerCase() == 's') {
            console.log("Seu inventário atual é:");
            await api.mostrarInventario();
          }

         await api.mudarParaProximaSala(4, processarSala4);
        };

        async function processarSala4(salaAtual) {
          await api.infos();
          
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
            await api.updateXPNPC(14);
            await api.updateXPNPC(15);

            console.log("Você conseguiu sair da Cidade Infestada");
            await api.mostrarDialogo(12, 13);
            console.log("Após a morte da Tess, você decide seguir o caminho com Ellie a fim de salvar o mundo!");

         await api.mudarParaProximaSala(5, processarSala5);
          } else if (mis.toLowerCase() == 'n') {
            console.log("Você tem que aceitar a missão para continuar jogando :)");
            // REMOVA O process.exit() AQUI
            console.log("Reiniciando a missão...");
            await processarSala4(salaAtual); // Reiniciar a missão se o jogador recusar
          }
        };

        async function processarSala5(salaAtual) {
          await api.infos();
          await api.verInventario();

          //Aumenta  vida de acordo com a vestimenta escolhida
          await api.updateVidaVestimenta();

          //Combate
          console.log("No meio do caminho para a Cidade de Bill, você encontra dois seres desconhecidos na floresta!");
          //mostra os npcs 
          await api.mostrarInimigoNPC(5);
          //Mostra diálogos
          await api.mostrarDialogo(49, 54);

          await api.mostrarArmas();
          let armaUsada = askAndReturn("Escolha a arma que deseja usar: ");

          await api.atacarNPC(3, armaUsada, salaAtual);
          await api.updateVidaNPC(3);

          await api.atacarNPC(4, armaUsada, salaAtual);
          await api.updateVidaNPC(4);

          console.log("Parabéns você matou todos os inimigos\n");
          await api.mostrarInventario();
          await api.updateXPNPC(3);
          await api.updateXPNPC(4);

          await api.adquireItemNPC(6);
          await api.mostrarDialogo(55, 56);

         await api.mudarParaProximaSala(6, processarSala6);
        };

        async function processarSala6(salaAtual) {
          await api.infos(salaAtual);
          await api.verInventario();

          //Aumenta  vida de acordo com a vestimenta escolhida
          await api.updateVidaVestimenta();

          await api.mostrarItensDaSala(salaAtual);
          await api.mostrarDialogo(14, 16);
          await api.objetivoExploracao(salaAtual);
          await api.evento(salaAtual);


          //missao id4
          const misEXP3 = askAndReturn("\nVocê aceita essa missão?\nS/N\n");
          if (misEXP3.toLowerCase() == 's') {
            console.log("Missão aceita!");
            await api.objetivoExploracao(salaAtual);

            await api.mostrarInimigoNPC(salaAtual);

            console.log("No meio do caminho por suprimentos, Joel, Ellie e Bill se deparam com uma escola completa de inimigos!")
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

            console.log("\nEsses são ESTALADORES, são mais perigosos\n");

            await api.atacarNPC(15, armaUsada, salaAtual);
            await api.updateVidaNPC(15);
            console.log("\nVocê matou um Estalador!\n");

            await api.atacarNPC(15, armaUsada, salaAtual);
            await api.updateVidaNPC(15);
            console.log("\nVocê matou um Estalador\n!");

            console.log("Parece não ter mais nada a se preocupar. A sala está limpa e agora está livre para explorar a sala");
            await api.mostrarItensDaSala(salaAtual);

            console.log("Quando você está próximo de sair da escola, é possível ouvir um barulho estrondoso.\nUma criatura ENORME sai de uma salaa das escolas, e ela quer te atacar");
            //Baiacu
            await api.atacarNPC(16, armaUsada, salaAtual);
            await api.updateVidaNPC(16);
            console.log("\nVocê matou  um Baiacu\n!");

            console.log("Parabéns, você acabou de lidar com um Baiacu, uma espécie de infectado rara e muito difícil de abater!\n");
            await api.mostrarInventario();
            await api.updateXPMisJoelExp(4);
            await api.updateXPNPC(14);
            await api.updateXPNPC(15);
            await api.updateXPNPC(16);

            console.log("Você conseguiu sair da escola");
            console.log("Após obter o carro, vocês seguem o caminho até Tommy");
          }

          await api.mudarParaProximaSala(7, processarSala7);
        }

        async function processarSala7(salaAtual) {
          await api.infos(salaAtual);
          await api.verInventario();

          //Aumenta  vida de acordo com a vestimenta escolhida
          await api.updateVidaVestimenta();
          await api.mostrarItensDaSala(salaAtual);
          await api.objetivoExploracao(salaAtual);

          //missao id5
          const misEXP3 = askAndReturn("\nVocê aceita essa missão?\nS/N\n");
          if (misEXP3.toLowerCase() == 's') {
            console.log("Missão aceita!");
            await api.objetivoExploracao(salaAtual);

            await api.mostrarInimigoNPC(salaAtual);

            console.log("\nApós a Perca Total do carro, Joel e Ellie seguem vagando pela cidade de Pittsburgh");
            console.log("Após entrar numa casa para passar a noite, vocês percebem aqui ali também era o abrigo de outras duas pessoas");
            await api.mostrarDialogo(17, 19);

            console.log("\nVocês estão decidem se juntar para passar pelo Esgoto a fim de sair da cidade.E nele vocês encontram alguns inimigos!")
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
            console.log("\nVocê matou outro Corredor!\n");

            console.log("\nEsse ESTALADOR, é mais perigoso\n");

            await api.atacarNPC(15, armaUsada, salaAtual);
            await api.updateVidaNPC(15);
            console.log("\nVocê matou um Estalador!\n");

            console.log("Parabéns você matou todos os inimigos, concluindo a missão, você ganhará xp por concluir a missão!\n");
            await api.mostrarItensDaSala(salaAtual);
            await api.mostrarInventario();
            await api.updateXPMisJoelPatr(1);
            await api.updateXPNPC(14);
            await api.updateXPNPC(15);
            await api.evento(salaAtual);
            await api.mostrarDialogo(20, 22);
          }

         await api.mudarParaProximaSala(8, processarSala8);
              };

        async function processarSala8(salaAtual) {
          await api.infos(salaAtual);
          await api.verInventario();

          //Aumenta  vida de acordo com a vestimenta escolhida
          await api.updateVidaVestimenta();

          console.log("\nApós a morte de Henry e Sam, vocês se encontram sozinhos novamente.");
          await api.objetivoPatrulha(6);

          //missao patrulha id6
          const misPatr2 = askAndReturn("\nVocê aceita essa missão?\nS/N\n");
          if (misPatr2.toLowerCase() == 's') {
            console.log("Missão aceita!");

            await api.mostrarInimigoNPC(salaAtual);

            console.log("\nNa frente de vocês, encontram-se inúmeros infectados e é necessário passar por eles para seguir o caminho");
            await api.mostrarArmas();
            let armaUsada = askAndReturn("Escolha a arma que deseja usar: ");

            await api.mostrarInimigoNPC(salaAtual);
            await api.atacarNPC(14, armaUsada, salaAtual);
            await api.updateVidaNPC(14);
            console.log("\nVocê matou um Corredor!\n");

            await api.atacarNPC(15, armaUsada, salaAtual);
            await api.updateVidaNPC(15);
            console.log("\nVocê matou um Estalador!\n");

            console.log("Agora você se depara com uma criatura também nunca antes vista. Parece um estalador mal formado. Mate-o")

            await api.atacarNPC(17, armaUsada, salaAtual);
            await api.updateVidaNPC(17);
            console.log("\nVocê matou um Espreitador!\n");

            await api.atacarNPC(17, armaUsada, salaAtual);
            await api.updateVidaNPC(17);
            console.log("\nVocê matou outro Espreitador!\n");

            console.log("Parabéns você matou todos os inimigos, concluindo a missão, você ganhará xp por concluir a missão!\n");
            await api.updateXPMisJoelPatr(6);
            await api.updateXPNPC(14);
            await api.updateXPNPC(15);
            await api.updateXPNPC(17);
          }

         await api.mudarParaProximaSala(9, processarSala9);
        };


        async function processarSala9(salaAtual) {
          await api.infos(salaAtual);
          await api.verInventario();

          //Aumenta  vida de acordo com a vestimenta escolhida
          await api.updateVidaVestimenta();

          //Sala 9: Chegada a Jackson e encontro com Tommy (MissaoExploracaoObterItem id 5)
          //Missao(7, 6, 'Joel e Ellie finalmentre chegam ao local onde Tommy está vivendo em uma comunidade segura. Joel considera deixar Ellie com Tommy', 'Represa', 1, 60, false, 13),
          //Evento:(6, 'Pai e Filha', 'Joel e Ellie finalmente chegam à comunidade de Tommy, onde Joel considera deixar Ellie sob os cuidados de seu irmão.', 10, 1),

          console.log("Após uma viagem longa e cansativa, Joel e Ellie finalmente chegam a Jackson, onde seu irmão Tommy mora!");
          await api.mostrarDialogo(23,25);
          await api.evento(6);
          await api.updateXPMisJoelExp(7);
          await api.objetivoExploracao(7);

          console.log("Após encontro com Tommy, Ellie e Joel decidem conversar!");

          await api.mudarParaProximaSala(10, processarSala10);
        };

        async function processarSala10(salaAtual) {
          await api.infos(salaAtual);
          await api.verInventario();

          //Aumenta  vida de acordo com a vestimenta escolhida
          await api.updateVidaVestimenta();
          await api.mostrarDialogo(26,29);
          await api.evento(7);

          //Missao:(8, 7, 'Resgatar Ellie de David.', 'Operação de Reconhecimento', 9, 1, 400, false, 13),
          //1 evento: (7, 'Captura de Ellie', 'Ellie é capturada por David enquanto foge de Jackson após uma discussão com Joel.', 11, 1),
          const misPatr3 = askAndReturn("\nVocê aceita essa missão?\nS/N\n");
          if (misPatr3.toLowerCase() == 's') {
            console.log("Missão aceita!Você deve resgatar Ellie");
                 
            await api.objetivoExploracao(8);
            await api.mostrarInimigoNPC(salaAtual);

            console.log("\nNa frente de vocês, encontram-se inúmeros infectados e é necessário passar por eles para seguir o caminho");
            await api.mostrarArmas();
            let armaUsada = askAndReturn("Escolha a arma que deseja usar: ");

            await api.mostrarInimigoNPC(salaAtual);
            await api.atacarNPC(14, armaUsada, salaAtual);
            await api.updateVidaNPC(14);
            console.log("\nVocê matou um Corredor!\n");

            await api.atacarNPC(15, armaUsada, salaAtual);
            await api.updateVidaNPC(15);
            console.log("\nVocê matou um Estalador!\n");

            console.log("Joel escuta um barulho e decide ir atrás!");

            await api.evento(8);
            await api.updateXPMisJoelPatr(8);
            await api.updateXPNPC(14);
            await api.updateXPNPC(15);
          }

          await api.mudarParaProximaSala(11, processarSala11);
        };

        async function processarSala11(salaAtual) {
          await api.infos(salaAtual);
          await api.mostrarItensDaSala(salaAtual);
          await api.verInventario();

          //Aumenta  vida de acordo com a vestimenta escolhida
          await api.updateVidaVestimenta();

          //Sala 11: Reencontro com Marlene(explicacao de tudo)e encontro de suprimentos E MissaoExploracaoObterItem id 6
          // (9, 'Joel salva Ellie', 'Joel descobre que Ellie será sacrificada no hospital e decide resgatá-la, enfrentando os Vagalumes.', 13, 1);
          // (9, 8, 'Joel e Ellie chegam ao hospital. Joel descobre que Ellie precisa ser sacrificada e a salva', 'Laboratório dos Vagalumes', 1, 30, false, 13),
          //2 18 e 1 13 e 1 7
          await api.mostrarDialogo(57,58);
          await api.mostrarDialogo(32,34);
          await api.objetivoExploracao(9);

          const misPatr3 = askAndReturn("\nVocê vai salvar a Ellie?\nS/N\n");
          if (misPatr3.toLowerCase() == 's') {
            console.log("Missão aceita!Você deve salvar a vida de Ellie");
            await api.evento(9);
                 
            await api.mostrarInimigoNPC(salaAtual);

            console.log("\nNa frente de vocês, encontram-se inúmeros infectados e é necessário passar por eles para seguir o caminho");
            await api.mostrarArmas();
            let armaUsada = askAndReturn("Escolha a arma que deseja usar: ");

            await api.mostrarInimigoNPC(salaAtual);

            await api.atacarNPC(18, armaUsada, salaAtual);
            await api.updateVidaNPC(18);
            console.log("\nVocê matou um Vagalume que estava no hospital!\n");

            await api.atacarNPC(18, armaUsada, salaAtual);
            await api.updateVidaNPC(18);
            console.log("\nVocê matou outro Vagalume que estava no hospital!\n");

            await api.atacarNPC(13, armaUsada, salaAtual);
            await api.updateVidaNPC(13);
            console.log("\nVocê matou o médico que fazia a cirurgia em Ellie e agora ela se encontra desacordada nos seus braços!\n");

            console.log("Você deve levar Ellie parra fora do hospital e voltar para Jackson!");
            console.log("Na garagem do hospital, Marlene te intercepta");
            await api.mostrarDialogo(58,65);

            await api.atacarNPC(7, armaUsada, salaAtual);
            await api.updateVidaNPC(7);
            console.log("\nAcabou, Marlene está morta! n");

           
            await api.updateXPMisJoelPatr(8);
            await api.updateXPNPC(18);
            await api.updateXPNPC(13);
            await api.updateXPNPC(7);
          }

          await api.evento(9);

         await api.mudarParaProximaSala(12, processarSala12);
        };

        async function processarSala12(salaAtual) {
          await api.infos(salaAtual);

          //Aumenta  vida de acordo com a vestimenta escolhida
          await api.updateVidaVestimenta();


          // MissaoPatrulha
          // (10, 9, 'Mate todos os infectados em volta de Jackson para entrar na cidade', 'Defesa do Assentamento', 8, 1, 450, false, 13);
  
          
          const misPatr4 = askAndReturn("\nVocê aceita essa missão?\nS/N\n");
          if (misPatr4.toLowerCase() == 's') {
            console.log("Missão aceita!Você deve matar todos esses infectados");
            await api.objetivoPatrulha(10);
            await api.mostrarInimigoNPC(salaAtual);

            console.log("\nNa frente de vocês, encontram-se inúmeros infectados e é necessário passar por eles para seguir o caminho");
            await api.mostrarArmas();
            let armaUsada = askAndReturn("Escolha a arma que deseja usar: ");

            await api.mostrarInimigoNPC(salaAtual);

            await api.atacarNPC(17, armaUsada, salaAtual);
            await api.updateVidaNPC(17);
            console.log("\nVocê matou um Espreitador que estava rondando por Jackson!\n");

            await api.atacarNPC(17, armaUsada, salaAtual);
            await api.updateVidaNPC(17);
            console.log("\nVocê matou outro Espreitador!\n");

            await api.atacarNPC(17, armaUsada, salaAtual);
            await api.updateVidaNPC(17);
            console.log("\nVocê matou outro Espreitador!\n");

            await api.atacarNPC(15, armaUsada, salaAtual);
            await api.updateVidaNPC(15);
            console.log("\nVocê matou um Estalador que estava ali também");

            await api.atacarNPC(15, armaUsada, salaAtual);
            await api.updateVidaNPC(15);
            console.log("\nVocê matou outro Estalador ");


            console.log("Combate finalizado. Você pode voltar para Jackson em segurança!");

           
            await api.updateXPMisJoelPatr(10);
            await api.updateXPNPC(17);
            await api.updateXPNPC(15);
          }

         await api.mudarParaProximaSala(13, processarSala13);
        };

        async function processarSala13(salaAtual) {
          await api.infos(salaAtual);
          await api.verInventario();

          //Aumenta  vida de acordo com a vestimenta escolhida
          await api.updateVidaVestimenta();

          // Missão Exploração
          // (11, 10, 'Joel e Ellie voltam a Jackson. Ellie confronta Joel', 'Final', 1, 30, false, 13);


          console.log("Joel e Ellie voltam à Jackson. Ellie está um pouco estranha e decide conversar com Joel");
          await api.objetivoExploracao(11);
          await api.mostrarDialogo(35,37);

          await api.updateXPMisJoelExp(11);

          console.log("Você chegou ao fim do MUD. Deixa o like e compartilha com seus amigos!!");
        };

      } catch (error) {
        console.error("Erro ao mover para a sala:", error.message || error);
      }
    } // fechando mover para sala

  } catch (error) { // try primeira tela
    console.error("Erro ao executar o início do jogo:", error.message || error);
  } finally {
    console.log("Fechando a conexão com o banco de dados...");
    console.log("Banco desconectado com sucesso!");
    await api.updateSala(1);
    process.exit();
  }
} // fecha primeira tela

async function iniciarJogo() {
  await primeiraTela();
}

iniciarJogo();
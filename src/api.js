import pg from "pg";
import { readFileSync } from "fs";
import readlineSync from 'readline-sync';

const { Client } = pg;
var sqlTables = readFileSync("../Modulo2/DDL.sql").toString();
var sqlData = readFileSync("../Modulo2/DML.sql").toString();
// var sqlTrg = readFileSync("Modulo3/trigger_stored_procedure.sql").toString();

function separador() {
  console.log("==========================================================================")
}

class Api {
  client = new Client({
    host: "localhost",
    user: "postgres",
    password: "postgres",
    port: 5451,
    database: "tlou",
  });

  constructor() {
    this.client.connect();
  }

  createTables = async () => {
    let response = false;
    console.log(sqlTables);
    await this.client.query(sqlTables).then(() => {
      response = true;
    });
    return response;
  };

  populateTables = async () => {
    let response = false;
    await this.client.query(sqlData).then(() => {
      response = true;
    });
    return response;
  };

  getSalaAtual = async () => {
    try {
      const sala = await this.client.query(`
      SELECT s.idsala
      FROM Regiao r
      JOIN Sala s ON s.idRegiao = r.idRegiao 
      JOIN PC p ON p.sala = s.idSala`);
      if (sala.rows.length === 0) {
        console.log("Nenhuma sala encontrada.");
      } else {
        return sala.rows[0].idsala;
      }
    } catch (error) {
      console.error("Erro ao obter a sala atual:", error.message || error);
    }
  }

  updateSala = async (idSala) => {
    try {
      await this.client.query(`
        UPDATE PC
        SET Sala = $1
        WHERE IdPersonagem = 1;
      `, [idSala]);
    } catch (error) {
      console.error("Erro ao atualizar a sala:", error.message || error);
    }
  }

  // Função para exibir os NPCs da sala atual
  mostrarNPCsDaSala = async (idSala) => {
    try {
      const npcs = await this.client.query(`
        SELECT n.nomePersonagem
        FROM NPC n
        join instnpc i on n.idpersonagem = i.idnpc
        where i.sala = $1
        `, [idSala]);
      if (npcs.rows.length === 0) {
        console.log("Nenhum NPC encontrado nesta sala.");
      } else {
        console.log("\nNPCs encontrados:");
        npcs.rows.forEach(npc => {
          console.log(`- ${npc.nomepersonagem}`);
        });
      }
    } catch (error) {
      console.error("Erro ao listar os NPCs da sala:", error.message || error);
    }
  }

  mostrarInimigoNPC = async (idSala) => {
    try {
      const npcs = await this.client.query(`
        SELECT n.nomePersonagem as nome, n.vidaatual as vida, ii.danoinfectado as dano
        FROM NPC n
        join instnpc i on n.idpersonagem = i.idnpc
		    join infectado ii on ii.idnpc = i.idnpc
		    where i.sala = $1 and i.tiponpc = 'I'
        `, [idSala]);
      if (npcs.rows.length === 0) {
        console.log("Nenhum Infectado encontrado nesta sala.");
      } else {
        console.log("\nInfectados encontrados:");
        npcs.rows.forEach(npc => {
          console.log(`| ${npc.nome} | Vida: ${npc.vida} | Dano: ${npc.dano}`);
        });
      }
    } catch (error) {
      console.error("Erro ao listar os NPCs da sala:", error.message || error);
    }
  }

  // funcao para mostrar os itens da sala
  // mostrarItensDaSala = async (idSala) => {
  //   try {
  //     const itens = await this.client.query(`
  //       SELECT 
  //       COALESCE(a.nomeItem, v.nomeItem, c.nomeItem) AS nomeItem,
  //       COUNT(*) AS quantidade
  //       FROM InstItem it
  //       LEFT JOIN Consumivel c ON it.idItem = c.idItem
  //       LEFT JOIN Arma a ON it.idItem = a.idItem
  //       LEFT JOIN Vestimenta v ON it.idItem = v.idItem
  //       WHERE it.Sala = $1
  //       GROUP BY COALESCE(a.nomeItem, v.nomeItem, c.nomeItem)
  //       ORDER BY nomeItem ASC;
  //       `, [idSala]);

  //     if (itens.rows.length === 0) {
  //       console.log("Nenhum item encontrado nesta sala.");
  //     } else {
  //       console.log("\nItens encontrados na sala atual:");
  //       itens.rows.forEach(item => {
  //         console.log(`|${item.iditem}:${item.nomeitem}: ${item.quantidade}`);
  //       });
  //     }
  //   } catch (error) {
  //     console.error("Erro ao listar os itens da sala:", error.message || error);
  //   }
  // }

  //const readlineSync = require('readline-sync'); 

  adicionarItemAoInventario = async (idInstItem, idInventario, idItem) => {
    try {
      const result = await this.client.query(`
        UPDATE InstItem
        SET IdInventario = $1
        WHERE idInstItem = $2 AND IdItem = $3
        RETURNING *;
      `, [idInventario, idInstItem, idItem]);

      if (result.rows.length === 0) {
        console.log("Erro ao adicionar item ao inventário.");
      } else {
        return result.rows[0]; // Retorna o item atualizado, se necessário
      }
    } catch (error) {
      console.error("Erro ao adicionar o item ao inventário:", error.message || error);
    }
  };


  mostrarItensDaSala = async (idSala) => {
    try {
      const itens = await this.client.query(`
        SELECT 
          COALESCE(a.nomeItem, v.nomeItem, c.nomeItem) AS nomeItem,
          it.idItem,
          COUNT(*) AS quantidade
        FROM InstItem it
        LEFT JOIN Consumivel c ON it.idItem = c.idItem
        LEFT JOIN Arma a ON it.idItem = a.idItem
        LEFT JOIN Vestimenta v ON it.idItem = v.idItem
        WHERE it.Sala = $1
        GROUP BY it.idItem, COALESCE(a.nomeItem, v.nomeItem, c.nomeItem)
        ORDER BY nomeItem ASC;
      `, [idSala]);

      if (itens.rows.length === 0) {
        console.log("Nenhum item encontrado nesta sala.");
        return;
      }

      console.log("\nItens encontrados na sala atual:");
      itens.rows.forEach((item) => {
        console.log(`| ${item.idItem} - ${item.nomeItem}: ${item.quantidade}`);
      });

      let choose = readlineSync.question(
        "Você encontrou alguns itens na sala. Deseja pegá-los? (1 - Todos, 2 - Nenhum, 3 - Especificar)\n"
      );

      switch (choose) {
        case '1': // Pegar todos os itens
          for (const item of itens.rows) {
            await this.adicionarItemAoInventario(item.idItem, idSala, item.idItem);
          }
          console.log("\nTodos os itens foram adicionados ao inventário com sucesso!\n");
          break;

        case '2': // Não pegar nenhum item
          console.log("\nVocê decidiu não pegar nenhum item.\n");
          break;

        case '3': // Pegar itens específicos
          let idItem;
          let quantidade;

          do {
            idItem = readlineSync.question("Digite o ID do item que deseja pegar ou '0' para sair: ");
            if (idItem === '0') break;

            const itemEncontrado = itens.rows.find((item) => item.idItem === parseInt(idItem));
            if (!itemEncontrado) {
              console.log("ID do item inválido. Tente novamente.");
              continue;
            }

            quantidade = readlineSync.questionInt(`Digite a quantidade de '${itemEncontrado.nomeItem}' que deseja pegar (Max: ${itemEncontrado.quantidade}): `);

            if (quantidade > 0 && quantidade <= itemEncontrado.quantidade) {
              await this.adicionarItemAoInventario(itemEncontrado.idItem, idSala, itemEncontrado.idItem);
              console.log(`Adicionado ${quantidade}x '${itemEncontrado.nomeItem}' ao inventário.`);
            } else {
              console.log("Quantidade inválida. Tente novamente.");
            }
          } while (idItem !== '0');

          console.log("\nItens selecionados foram adicionados ao inventário!\n");
          break;

        default:
          console.log("\nOpção inválida.\n");
      }
    } catch (error) {
      console.error("Erro ao listar os itens da sala:", error.message || error);
    }
  };





  mostrarInventario = async () => {
    try {
      const inventario = await this.client.query(`
        SELECT COUNT(i.idInstItem) AS totalitens, COALESCE(a.nomeItem,
        v.nomeItem, c.nomeItem) AS nomeItem  
        FROM InstItem i
        JOIN Inventario ii ON i.IdInventario = ii.idInventario
        LEFT JOIN Arma a ON i.IdItem = a.IdItem
        LEFT JOIN Vestimenta v ON i.IdItem = v.IdItem
        LEFT JOIN Consumivel c ON i.IdItem = c.IdItem
        GROUP BY  a.nomeItem, v.nomeItem, c.nomeItem
        ORDER BY nomeItem;`);
      if (inventario.rows.length === 0) {
        console.log("Seu inventário está vazio");
      } else {
        console.log("Seus itens:");
        inventario.rows.forEach(i => {
          console.log(`|${i.nomeitem} | Quantidade: ${i.totalitens}`);
        });
      }
    } catch (error) {
      console.error("Erro ao mostrar inventario:", error.message || error);
    }
  }

  mostrarArmas = async () => {
    try {
      const armas = await this.client.query(`
        select a.nomeitem AS nome
        from arma a 
        join institem i on i.iditem = a.iditem
        join inventario ii on ii.idinventario = i.idinventario
        where ii.idinventario = 1`);
      if (armas.rows.length === 0) {
        console.log("Você não possui armas.");
      } else {
        console.log("\nSuas armas:\n");
        armas.rows.forEach(arma => {
          console.log(`${arma.nome}`);
        });
      }
    } catch (error) {
      console.error("Erro ao mostrar armas:", error.message || error);
    }
  }

  updateCapacidadeInventario = async (IdPersonagem) => {
    try {
      await this.client.query(`
        UPDATE Inventario SET capacidade = capacidade - 
        (SELECT COUNT(i.idinstitem) AS total
        FROM institem i 
        JOIN inventario ii ON ii.idinventario = i.idinventario)
        WHERE idinventario = $1`, [IdPersonagem]);
    } catch (error) {
      console.error("Erro ao atualizar a capacidade:", error.message || error);
    }
  }

  // Função para exibir um dialogo
  mostrarDialogo = async (DialogoInicio, DialogoFim) => {
    console.log(`\n`);
    try {
      const dialogo = await this.client.query(`
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

  removerItemNoInventario = async (idinstitem, iditem) => {
    try {
      const result = await this.client.query(`
        DELETE InstItem
        WHERE idInstItem = ${idinstitem} AND IdItem = ${iditem}
      `);
      if (result.rows.length === 0) {
        console.log("Erro ao remover item ao inventário.");
      } else {
        return result.rows[0];
      }
    } catch (error) {
      console.error("Erro ao remover o item ao inventário:", error.message || error);
    }
  }

  contarEAtualizarCapacidade = async (idinventario) => {
    try {
      // Contar quantas instâncias foram inseridas no inventário
      const countResult = await this.client.query(`
        SELECT COUNT(*) AS item_count
        FROM InstItem
        WHERE IdInventario = ${idinventario};
      `);

      const itemCount = parseInt(countResult.rows[0].item_count, 10);

      if (itemCount > 0) {
        // Atualizar a capacidade do inventário subtraindo o número de instâncias contadas
        const updateResult = await this.client.query(`
          UPDATE Inventario
          SET capacidade = capacidade - ${itemCount}
          WHERE idInventario = ${idinventario}
          RETURNING capacidade;
        `);
        console.log(`A capacidade do inventário foi atualizada para: ${updateResult.rows[0].capacidade}`);
      } else {
        console.log("Nenhuma instância foi encontrada no inventário.");
      }
    } catch (error) {
      console.error("Erro ao contar instâncias ou atualizar a capacidade do inventário:", error.message || error);
    }
  }

  updateVidaVestimenta = async () => {
    try {
      const roupa = await this.client.query(`
        SELECT COUNT(i.idInstItem) AS totalitens, v.nomeItem AS nomeItem  
        FROM InstItem i
        JOIN Vestimenta v ON i.IdItem = v.IdItem
        GROUP BY  v.nomeItem
        ORDER BY totalitens DESC;`);
      if (roupa.rows.length > 0) {
        await this.client.query(`
            UPDATE pc SET vidaatual = vidaatual + (SELECT SUM(defesa) FROM vestimenta v 
            JOIN institem i ON i.iditem = v.iditem
            JOIN pc p ON p.idinventario = i.idinventario)`);
        console.log("Sua vida foi atualizada");
      }
    } catch (error) {
      console.error("Erro ao atualizar a vida:", error.message || error);
    }
  }

  evento = async (sala) => {
    try {
      const evento = await this.client.query(`
      SELECT descricao, nomeevento 
      FROM Evento 
      WHERE idEvento = $1`, [sala]);
      console.log("\n");
      console.log(evento.rows[0].nomeevento);
      // console.log("\n");
      console.log(evento.rows[0].descricao);
    } catch (error) {
      console.error("Erro ao realizar evento:", error.message || error);
    }
  }

  //funcao para mostrar objetivo da missao exploracao
  objetivoExploracao = async (sala) => {
    try {
      const objetivo = await this.client.query(`
        SELECT objetivo 
        FROM missaoexploracaoobteritem 
        WHERE sala = $1`, [sala]);
      console.log("\n");
      console.log(objetivo.rows[0].objetivo);
    } catch (error) {
      console.error("Erro ao realizar missão:", error.message || error);
    }
  }









  atacarPCPorAnimal = async (idpc, idanimal) => {
    try {
      // Obter os dados do PC
      const pcResult = await this.client.query(`
        SELECT vidaAtual, vidaMax, Sala
        FROM PC
        WHERE IdPersonagem = ${idpc};
        `);

      if (pcResult.rows.length === 0) {
        console.log("PC não encontrado.");
        return;
      }

      let vidaAtualPC = pcResult.rows[0].vidaAtual;
      let vidaMaxPC = pcResult.rows[0].vidaMax;


      // Obter os dados do Animal
      const animalResult = await this.client.query(`
        SELECT danoAnimal
        FROM Animal
        WHERE IdNPC = ${idanimal};
        `);

      if (animalResult.rows.length === 0) {
        console.log("Animal não encontrado.");
        return;
      }

      let danoAnimal = animalResult.rows[0].danoanimal;
      let salaAtual = pcResult.rows[0].sala;

      // Decrementar a vida do PC
      vidaAtualPC -= danoAnimal;

      // Atualizar a vida do PC ou deletá-lo se a vida chegar a 0
      if (vidaAtualPC <= 0) {
        try {

          if (vidaAtualPC <= 0) {
            console.log("Você morreu, tente novamente.");
            // Restaurar a vida do PC para o máximo e voltar para a sala anterior
            await this.client.query(`
              UPDATE PC
              SET vidaAtual = ${vidaMaxPC}, Sala = ${salaAtual}
              WHERE IdPersonagem = ${idpc};
              `);

            console.log(`PC retornou à sala ${salaAtual} com vida completa(${vidaMaxPC}).`);
            console.log("PC eliminado.");
          } else {
            await this.client.query(`
              UPDATE PC
              SET vidaAtual = ${vidaAtualPC}
              WHERE IdPersonagem = ${idpc};
                `);
            console.log(`Vida do PC atualizada para: ${vidaAtualPC}`);
          }

        } catch (error) {
          console.error("Erro ao atacar PC por Animal:", error.message || error);
        }
      }
    } catch (error) {
      console.error("Erro ao atacar PC por Animal:", error.message || error);
    }
  };

  atacarPCPorInfectado = async (idpc, idinfectado) => {
    try {
      // Obter os dados do PC
      const pcResult = await this.client.query(`
        SELECT vidaAtual, vidaMax
        FROM PC
        WHERE IdPersonagem = ${idpc};
        `);

      if (pcResult.rows.length === 0) {
        console.log("PC não encontrado.");
        return;
      }

      let vidaAtualPC = pcResult.rows[0].vidaAtual;

      // Obter os dados do Infectado
      const infectadoResult = await this.client.query(`
        SELECT danoInfectado
        FROM Infectado
        WHERE IdNPC = ${idinfectado};
        `);

      if (infectadoResult.rows.length === 0) {
        console.log("Infectado não encontrado.");
        return;
      }

      let danoInfectado = infectadoResult.rows[0].danoinfectado;

      // Decrementar a vida do PC
      vidaAtualPC -= danoInfectado;

      // Atualizar a vida do PC ou deletá-lo se a vida chegar a 0
      if (vidaAtualPC <= 0) {
        await this.client.query(`
          DELETE FROM PC
          WHERE IdPersonagem = ${idpc};
          `);
        console.log("PC eliminado.");
      } else {
        await this.client.query(`
          UPDATE PC
          SET vidaAtual = ${vidaAtualPC}
          WHERE IdPersonagem = ${idpc};
          `);
        console.log(`Vida do PC atualizada para: ${vidaAtualPC}`);
      }

    } catch (error) {
      console.error("Erro ao atacar PC por Infectado:", error.message || error);
    }
  };


  atacarNPC = async (idnpc, idarma) => {
    try {
      // Obter os dados do NPC
      const npcResult = await this.client.query(`
        SELECT vidaAtual, vidaMax
        FROM NPC
        WHERE IdPersonagem = ${idnpc};
      `);

      console.log("Resultado da consulta:", npcResult.rows);

      if (npcResult.rows.length === 0) {
        console.log("NPC não encontrado.");
        return;
      }

      // Verificar e converter vidaAtual e vidaMax
      console.log("agora vai");
      const { vidaAtual, vidaMax } = npcResult.rows[0];
      console.log(vidaAtual);
      console.log(vidaAtual);

      if (isNaN(vidaAtual) || isNaN(vidaMax)) {
        console.log(`Valores retornados do NPC inválidos: vidaAtual=${npcResult.rows[0].vidaAtual}, vidaMax=${npcResult.rows[0].vidaMax}`);
        return;
      }

      // Obter os dados da arma
      const armaResult = await this.client.query(`
        SELECT dano, municaoAtual, municaoMax
        FROM Arma
        WHERE IdItem = ${idarma};
      `);

      if (armaResult.rows.length === 0) {
        console.log("Arma não encontrada.");
        return;
      }

      // Verificar e converter dano e municaoAtual
      const dano = parseInt(armaResult.rows[0].dano, 10);
      let municaoAtual = parseInt(armaResult.rows[0].municaoAtual, 10);

      if (isNaN(dano) || isNaN(municaoAtual)) {
        console.log(`Valores retornados da arma inválidos: dano=${armaResult.rows[0].dano}, municaoAtual=${armaResult.rows[0].municaoAtual}`);
        return;
      }

      // Verificar se há munição suficiente
      if (municaoAtual <= 0) {
        console.log("Sem munição suficiente para atacar.");
        return;
      }

      // Determinar se o ataque acerta ou erra
      const acerto = Math.random() < 0.7 ? 'errou' : 'acertou';
      console.log(`Resultado do ataque: ${acerto}`);

      if (acerto === 'errou') {
        console.log("O ataque falhou, sem dano causado.");
        // Atualizar munição mesmo se o ataque falhar
        municaoAtual -= 1;
        await this.client.query(`
          UPDATE Arma
          SET municaoAtual = ${municaoAtual}
          WHERE IdItem = ${idarma};
        `);
        console.log(`Munição da arma atualizada para: ${municaoAtual}`);
        return;
      }

      // Se acertou, decrementar a vida do NPC
      let novaVida = vidaAtual - dano;

      // Atualizar a vida do NPC ou deletá-lo se a vida chegar a 0
      if (novaVida <= 0) {
        await this.client.query(`
          DELETE FROM NPC
          WHERE IdPersonagem = ${idnpc};
        `);
        console.log("NPC eliminado.");
      } else {
        await this.client.query(`
          UPDATE NPC
          SET vidaAtual = ${novaVida}
          WHERE IdPersonagem = ${idnpc};
        `);
        console.log(`Vida do NPC atualizada para: ${novaVida}`);
      }

      // Atualizar a munição da arma
      municaoAtual -= 1;
      await this.client.query(`
        UPDATE Arma
        SET municaoAtual = ${municaoAtual}
        WHERE IdItem = ${idarma};
      `);
      console.log(`Munição da arma atualizada para: ${municaoAtual}`);

    } catch (error) {
      console.error("Erro ao atacar NPC:", error.message || error);
    }
  }


}// fechando a api



export default Api;
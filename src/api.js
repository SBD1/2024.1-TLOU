import pg from "pg";
import { readFileSync } from "fs";
import readlineSync from 'readline-sync';
import { question } from "readline-sync";
import { Console } from "console";

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
        where i.sala = $1 AND n.ealiado = true;
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
        SELECT n.nomePersonagem as nome, i.idinstnpc as idinstancia
        FROM NPC n
        JOIN instnpc i ON n.idpersonagem = i.idnpc
		    JOIN infectado ii ON ii.idnpc = i.idnpc
        JOIN faccaohumana h ON h.idnpc = i.idnpc
        JOIN animal a ON a.idnpc = i.idnpc
		    WHERE i.sala = $1 AND i.tiponpc = 'I' OR i.tiponpc = 'A' OR i.tiponpc = 'F' AND ealiado = false
        ORDER BY idinstancia;
        `, [idSala]);
      if (npcs.rows.length === 0) {
        console.log("Nenhum inimigo encontrado nesta sala.");
      } else {
        console.log("\nInimigos encontrados:");
        npcs.rows.forEach(npc => {
          console.log(`| ${npc.nome} ${npc.idinstancia}|`);
        });
      }
    } catch (error) {
      console.error("Erro ao listar os NPCs da sala:", error.message || error);
    }
  }

  adicionarItemAoInventario = async (idInstItem, idItem) => {
    try {
      const result = await this.client.query(`
        UPDATE InstItem
        SET IdInventario = 1
        WHERE idInstItem = $1 AND IdItem = $2
        RETURNING *;
      `, [idInstItem, idItem]);

    } catch (error) {
      console.error("Erro ao adicionar o item ao inventário:", error.message || error);
    }
  };

  mostrarItensDaSala = async (idSala) => {
    try {
      // Buscar e ordenar itens na sala
      const itens = await this.client.query(`
        SELECT 
          it.idinstitem,
          COALESCE(a.nomeItem, v.nomeItem, c.nomeItem) AS nomeItem,
          it.idItem,
          COUNT(*) AS quantidade
        FROM InstItem it
        LEFT JOIN Consumivel c ON it.idItem = c.idItem
        LEFT JOIN Arma a ON it.idItem = a.idItem
        LEFT JOIN Vestimenta v ON it.idItem = v.idItem
        WHERE it.Sala = $1
        GROUP BY it.idinstitem, it.idItem, COALESCE(a.nomeItem, v.nomeItem, c.nomeItem)
        ORDER BY it.idinstitem ASC;  -- Ordenar por idinstitem
      `, [idSala]);

      if (itens.rows.length === 0) {
        console.log("Nenhum item encontrado nesta sala.");
        return;
      }

      console.log("\nItens encontrados na sala atual:");
      itens.rows.forEach((item) => {
        console.log(`| ${item.idinstitem} - ${item.nomeitem}`);
      });

      let choose = readlineSync.question(
        "\nVocê encontrou alguns itens na sala.\nDeseja pegá-los?\n(1 - Todos, 2 - Nenhum, 3 - Especificar)\n"
      );

      switch (choose) {
        case '1': // Pegar todos os itens
          for (const item of itens.rows) {
            await this.adicionarItemAoInventario(item.idinstitem, item.idItem);
            // Atualizar a tabela InstItem para remover o item da sala e adicionar ao inventário
            await this.client.query(`
              UPDATE InstItem
              SET Sala = NULL, IdInventario = 1
              WHERE idinstitem = $1
            `, [item.idinstitem]);
          }
          await this.updateCapacidadeInventario(1);
          console.log("\nTodos os itens foram adicionados ao inventário com sucesso!\n");
          break;

        case '2': // Não pegar nenhum item
          console.log("\nVocê decidiu não pegar nenhum item.\n");
          break;

        case '3': // Pegar itens específicos
          let idItem;
          let itensSelecionados = new Set();  // Usar um Set para manter os IDs únicos

          do {
            idItem = readlineSync.question("Digite o ID do item que deseja pegar ou '0' para sair: ");
            if (idItem === '0') break;

            const itemEncontrado = itens.rows.find((item) => item.idinstitem === parseInt(idItem));

            if (!itemEncontrado) {
              console.log("ID do item inválido. Tente novamente.");
              continue;
            }

            if (itensSelecionados.has(idItem)) {
              console.log("Este item já foi selecionado. Tente outro.");
              continue;
            }

            // Adicionar o item ao inventário
            await this.adicionarItemAoInventario(itemEncontrado.idinstitem, itemEncontrado.idItem);
            await this.updateCapacidadeInventario(1);
            // Atualizar a tabela InstItem para remover o item da sala e adicionar ao inventário
            await this.client.query(`
              UPDATE InstItem
              SET Sala = NULL, IdInventario = 1
              WHERE idinstitem = $1
            `, [itemEncontrado.idinstitem]);

            // Adicionar o ID do item ao Set de itens selecionados
            itensSelecionados.add(idItem);

            console.log(`O item '${itemEncontrado.nomeitem}' foi adicionado ao inventário!\n`);

          } while (idItem !== '0');

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
        ORDER BY totalitens;`);
      if (inventario.rows.length === 0) {
        console.log("Seu inventário está vazio");
      } else {
        console.log("\nSeus itens:");
        inventario.rows.forEach(i => {
          console.log(`|Qtd: ${i.totalitens} | ${i.nomeitem}`);
        });
      }
    } catch (error) {
      console.error("Erro ao mostrar inventario:", error.message || error);
    }
  }

  mostrarArmas = async () => {
    try {
      const armas = await this.client.query(`
        select a.nomeitem AS nome, a.iditem
        from arma a 
        join institem i on i.iditem = a.iditem
        join inventario ii on ii.idinventario = i.idinventario
        where ii.idinventario = 1`);
      if (armas.rows.length === 0) {
        console.log("Você não possui armas.");
      } else {
        console.log("\nSuas armas:\n");
        armas.rows.forEach(arma => {
          console.log(`${arma.nome} Id: ${arma.iditem}`);
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

  objetivoPatrulha = async (sala) => {
    try {
      const objetivo = await this.client.query(`
        SELECT objetivo 
        FROM missaopatrulha 
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
        WHERE IdPersonagem = 1;
        `);

      if (pcResult.rows.length === 0) {
        console.log("PC não encontrado.");
        return;
      }

      let vidaAtualPC = pcResult.rows[0].vidaatual;

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
        console.log(`\nVida do PC atualizada para: ${vidaAtualPC}`);
      }
    } catch (error) {
      console.error("Erro ao atacar PC por Infectado:", error.message || error);
    }
  };

  atacarNPC = async (idnpc, idarma, sala) => {
    try {
      let npcVivo = true;

      while (npcVivo) {
        // Obter os dados do NPC
        const npcResult = await this.client.query(`
          SELECT n.vidaatual, n.vidamax
          FROM instnpc i
          JOIN npc n ON n.idpersonagem = i.idnpc
          WHERE n.idpersonagem = $1 AND i.sala = $2
        `, [idnpc, sala]);

        if (npcResult.rows.length === 0) {
          console.log("NPC não encontrado.");
          return;
        }

        const vidaAtualNpc = npcResult.rows[0].vidaatual;
        const vidaMaxNpc = npcResult.rows[0].vidamax;

        if (isNaN(vidaAtualNpc) || isNaN(vidaMaxNpc)) {
          console.log(`Valores retornados do NPC inválidos: vidaAtual=${vidaAtualNpc}, vidaMax=${vidaMaxNpc}`);
          return;
        }

        if (vidaAtualNpc <= 0) {
          console.log("O NPC já está morto.");
          npcVivo = false;
          return;
        }

        // Obter os dados da arma
        const armaResult = await this.client.query(`
          SELECT a.dano AS danoA, a.municaoAtual AS municaoA, a.municaoMax AS municaoMax
          FROM Arma a
          JOIN institem i ON i.iditem = a.iditem
          WHERE a.IdItem = $1;
        `, [idarma]);

        if (armaResult.rows.length === 0) {
          console.log("Arma não encontrada.");
          return;
        }

        const danoArma = armaResult.rows[0].danoa;
        let municaoAtualPC = armaResult.rows[0].municaoa;

        if (isNaN(danoArma) || isNaN(municaoAtualPC)) {
          console.log(`Valores retornados da arma inválidos: dano=${danoArma}, municaoAtual=${municaoAtualPC}`);
          return;
        }

        // Verificar se há munição suficiente
        if (municaoAtualPC <= 0) {
          console.log("\nRecarregando a arma...\n");
          await this.recarregarArma(idarma);
          municaoAtualPC = armaResult.rows[0].municaomax;
        }

        // Determinar se o ataque acerta ou erra
        const acerto = Math.random() < 0.74 ? 'acertou' : 'errou';
        console.log(`Resultado do ataque: ${acerto}`);

        if (acerto === 'errou') {
          console.log("O ataque falhou e o inimigo te acertou.");
          await this.atacarPCPorInfectado(1, idnpc);
          // Atualizar munição mesmo se o ataque falhar
          municaoAtualPC -= 1;
          await this.client.query(`
            UPDATE Arma
            SET municaoAtual = $1
            WHERE IdItem = $2;
          `, [municaoAtualPC, idarma]);
          console.log(`Munição da arma atualizada para: ${municaoAtualPC}`);
        } else {
          // Se acertou, decrementar a vida do NPC
          let novaVida = vidaAtualNpc - danoArma;
          if (novaVida <= 0) {
            await this.client.query(`
              WITH npc_to_delete AS (
                SELECT idInstNPC
                FROM InstNPC
                WHERE idNPC = $1 AND Sala= $2
                LIMIT 1
            )
                DELETE FROM InstNPC
                USING npc_to_delete
                WHERE InstNPC.idInstNPC = npc_to_delete.idInstNPC;
            `, [idnpc, sala]);
            console.log("Inimigo eliminado.");
            npcVivo = false;
          } else {
            await this.client.query(`
              UPDATE NPC
              SET vidaAtual = $1
              WHERE IdPersonagem = $2;
            `, [novaVida, idnpc]);
            console.log(`\nVida do NPC atualizada para: ${novaVida}`);
          }

          // Atualizar a munição da arma
          municaoAtualPC -= 1;
          await this.client.query(`
            UPDATE Arma
            SET municaoAtual = $1
            WHERE IdItem = $2;
          `, [municaoAtualPC, idarma]);
          console.log(`Munição da arma atualizada para: ${municaoAtualPC}`);
        }

        // Verificar se o NPC foi derrotado para sair do loop
        if (!npcVivo) {
          console.log("Combate finalizado.");
          return;
        }
      }
    } catch (error) {
      console.error("Erro ao atacar NPC:", error.message || error);
    }
  };

  recarregarArma = async (idarma) => {
    try {
      await this.client.query(`
      UPDATE Arma
      SET municaoAtual = municaoMax
      WHERE IdItem = $1;
      `, [idarma]);

    } catch (error) {
      console.error("Erro ao atualizar a munição da arma:", error.message || error);
    }
  }

  updateVidaNPC = async (id) => {
    try {
      await this.client.query(`
      UPDATE NPC
      SET vidaAtual = vidaMax
      where idPersonagem = $1;
      `, [id]);
    } catch (error) {
      console.error("Erro ao atualizar a vida:", error.message || error);
    }
  }

  updateXPMisJoelPatr = async (idMissao) => {
    try {
      // Atualiza o XP do personagem
      const xpMisExp = await this.client.query(`
        UPDATE PC 
        SET xp = xp + (SELECT xpMis FROM MissaoPatrulha WHERE idMissao = $1)
        WHERE IdPersonagem = 1
      `, [idMissao]);

      // Opcional: exibe uma mensagem de sucesso, se necessário
      console.log("XP atualizado com sucesso!");

    } catch (error) {
      console.error("Erro ao atualizar o XP:", error.message || error);
    }
  };

  updateXPMisJoelExp = async (idMissao) => {
    try {
      // Atualiza o XP do personagem
      await this.client.query(`
        UPDATE PC 
        SET xp = xp + (SELECT xpMis FROM MissaoExploracaoObterItem WHERE idMissao = $1)
        WHERE IdPersonagem = 1
      `, [idMissao]);
      // Opcional: exibe uma mensagem de sucesso, se necessário
    } catch (error) {
      console.error("Erro ao atualizar o XP:", error.message || error);
    }
  };

  updateXPNPC = async (idnpc) => {
    try {
      await this.client.query(`
        UPDATE PC SET xp = xp + (SELECT xp FROM NPC WHERE idPersonagem = $1)
        WHERE IdPersonagem = 1
        `, [idnpc]);

      console.log("XP de NPC atualizado com sucesso!");
    } catch (error) {
      console.error("Erro ao atualizar o XP:", error.message || error);
    }
  }

  adquireItemNPC = async (idinventarioNPC) => {
    try {
      // Consulta para obter as instâncias de itens do inventário do NPC
      const institemnpcResult = await this.client.query(`
        SELECT idInstItem    
        FROM InstItem
        WHERE IdInventario = $1`, [idinventarioNPC]);
  
      // Consulta para obter os itens correspondentes às instâncias no inventário do NPC
      const itemnpcResult = await this.client.query(`
        SELECT i.idItem
        FROM InstItem inst
        JOIN Item i ON inst.IdItem = i.idItem
        WHERE inst.IdInventario = $1`, [idinventarioNPC]);
  
      
      const institemnpc = institemnpcResult.rows;
      const itemnpc = itemnpcResult.rows;

      this.adicionarItemAoInventario(institemnpc, itemnpc);
  
      // Mensagem de sucesso
      console.log("Você adquiriu os itens com sucesso!");
    }
    catch (error) {
      // Tratamento de erro
      console.log("Erro ao adquirir item de NPC:", error.message || error);
    }
  }
  

  infos = async (salaAtual) => {
    try {
      // Obtém a sala atual (ou use o valor passado como parâmetro)
      salaAtual = await this.getSalaAtual(); // se necessário
      console.log("CHEGOU NA SALA " + salaAtual);
  
      // Consulta a região atual com base na sala
      const regiaoAtual = await this.client.query(`
        SELECT r.nomeRegiao, r.descricaoRegiao
        FROM Regiao r 
        JOIN Sala s ON s.idRegiao = r.idRegiao 
        JOIN PC p ON p.sala = s.idSala
        WHERE s.idSala = $1
      `, [salaAtual]);
  
      // Verifica se a consulta retornou resultados
      if (regiaoAtual.rows.length > 0) {
        const regiao = regiaoAtual.rows[0];
        console.log(`\nVocê está na região: ${regiao.nomeregiao}`);
        console.log(`Descrição: ${regiao.descricaoregiao}\n`);
        return regiao; // Retorna as informações da região
      } else {
        console.log("Nenhuma informação encontrada para a sala atual.");
        return null; // Retorna null se não houver informações
      }
    } catch (error) {
      console.log("Erro ao mostrar as infos:", error.message);
      return null; // Retorna null em caso de erro
    }
  };

  askAndReturn = async (texto) => {
    return question(texto);
  }
  
  // Função para perguntar e mostrar o inventário
  verInventario = async () => {
    try {
      let escolha = String(this.askAndReturn("\nDeseja ver seu inventário?\nS/N\n"));
  
      if (escolha.toLowerCase() === 's') {
        console.log("Seu inventário atual é:");
        this.mostrarInventario();
      }
    } catch (error) {
      console.error("Erro ao exibir o inventário:", error);
    }
  };
  




}// fechando a api

export default Api;
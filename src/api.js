import pg from "pg";
import { readFileSync } from "fs";
import readlineSync from 'readline-sync';
import { question } from "readline-sync";

const { Client } = pg;
var sqlTables = readFileSync("../Modulo2/DDL.sql").toString();
var sqlTrg = readFileSync("../Modulo3/triggers.sql").toString()
var sqlData = readFileSync("../Modulo2/DML.sql").toString();

class Api {
  client = new Client({
    host: "localhost",
    user: "postgres",
    password: "postgres",
    port: 5451,
    database: "tlou",
  });

  askAndReturn = async (texto) => {
    return question(texto);
  };

  constructor() {
    this.client.connect();
  };

  createTables = async () => {
    let response = false;
    console.log(sqlTables);
    await this.client.query(sqlTables).then(() => {
      response = true;
    });
    return response;
  };

  createTriggers = async () => {
    let response = false;
    await this.client.query(sqlTrg).then(() => {
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
  };

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
  };

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
  };

  mostrarInimigoNPC = async (idSala) => {
    try {
      const npcs = await this.client.query(`
        SELECT n.nomePersonagem as nome, i.idinstnpc as idinstancia
        FROM NPC n
        JOIN instnpc i ON n.idpersonagem = i.idnpc
        LEFT JOIN infectado ii ON ii.idnpc = i.idnpc
        LEFT JOIN faccaohumana h ON h.idnpc = i.idnpc
        LEFT JOIN animal a ON a.idnpc = i.idnpc
        WHERE i.sala = $1 AND (i.tiponpc = 'I' OR i.tiponpc = 'A' OR i.tiponpc = 'F') 
        AND ealiado = false
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
  };

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
  };

  // Função para verificar a capacidade do inventário
  verificarCapacidadeInventario = async () => {
    try {
      const result = await this.client.query(`
      SELECT capacidade - (SELECT COUNT(*) FROM InstItem WHERE IdInventario = 1)
      AS capacidadeDisponivel
      FROM Inventario
      WHERE idinventario = 1;
    `);
      const item = result.rows[0].capacidadedisponivel;
      if (item > 0) {
        console.log(`capacidade é ${item}`);
        return item;
      } else {
        console.log('Capacidade inválida.');
        return 0;
      }
    } catch (error) {
      console.error("Erro ao verificar a capacidade do inventário:", error.message || error);
      return -1;
    }
  };

  //Função para adicionar um item ao inventário
  adicionarItemAoInventario = async (idinstitem) => {
    try {
      // 1. Atualiza a sala do item para NULL
      const resultUpdateSala = await this.client.query(`
        UPDATE InstItem
        SET Sala = NULL, idinventario = 1
        WHERE idInstItem = $1;
        `, [idinstitem]);

      if (resultUpdateSala.rowCount === 0) {
        console.log("Erro ao adicionar o item da sala.");
        return false;
      }
      // Atualiza a capacidade após adicionar o item
      console.log(`O item do id: ${idinstitem} foi adicionado ao inventário!`);

      return true;
    } catch (error) {
      console.error("Erro ao adicionar o item ao inventário:", error.message || error);
      return false;
    }
  };

  //Atualizar capacidade do inventário
  updateCapacidadeInventario = async () => {
    try {
      await this.client.query(`
        UPDATE Inventario
        SET capacidade = capacidade - 
          (SELECT COUNT(*) 
           FROM InstItem 
           WHERE IdInventario = 1)
        WHERE idinventario = 1
      `);
      const capacidadeDepoisUpdate = await this.client.query(`
        SELECT capacidade FROM Inventario WHERE idinventario = 1;
      `);
      // Verifica se a consulta retornou algum resultado
      if (capacidadeDepoisUpdate.rows.length > 0) {
        // Exibe o valor da capacidade
        console.log("Capacidade depois do update:", capacidadeDepoisUpdate.rows[0].capacidade);
      } else {
        console.log("Nenhum dado retornado para o inventário com id 1.");
      }
    } catch (error) {
      console.error("Erro ao atualizar a capacidade:", error.message || error);
    }
  };

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
  };

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
  };

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
  };

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
  };

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
  };

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
  };

  atacarPCPorAnimal = async (idpc, idanimal, salaAtual) => {
    try {
      // Obter os dados do PC
      const pcResult = await this.client.query(`
        SELECT vidaatual, vidamax
        FROM PC
        WHERE IdPersonagem = $1;
      `, [idpc]);

      if (pcResult.rows.length === 0) {
        console.log("PC não encontrado.");
        return;
      }

      let vidaAtualPC = pcResult.rows[0].vidaatual;

      // Obter os dados do Animal
      const animalResult = await this.client.query(`
        SELECT danoAnimal
        FROM Animal
        WHERE IdNPC = $1;
      `, [idanimal]);

      if (animalResult.rows.length === 0) {
        console.log("Animal não encontrado.");
        return;
      }

      let danoAnimal = animalResult.rows[0].danoanimal;

      // Decrementar a vida do PC
      vidaAtualPC -= danoAnimal;
      console.log(`\nVida do PC atualizada para: ${vidaAtualPC}`);

    } catch (error) {
      console.error("Erro ao atacar PC por Animal:", error.message || error);
    }
  };

  getNomeAnimal = async (idnpc) => {
    try {
      const result = await this.client.query(`
        SELECT nomeAnimal
        FROM Animal
        WHERE IdNPC = $1;
      `, [idnpc]);

      if (result.rows.length === 0) {
        console.log("Animal não encontrado.");
        return null;
      }

      const nomeAnimal = result.rows[0].nomeanimal;
      console.log(`Nome do Animal: ${nomeAnimal}`);
      return nomeAnimal;
    } catch (error) {
      console.error("Erro ao buscar nome do animal:", error.message || error);
      return null;
    }
  };

  sleep = async (ms) => {
    return new Promise(resolve => setTimeout(resolve, ms));
  };


  atacarPCPorInfectado = async (idpc, idinfectado, salaAtual) => {
    try {
      // Obter os dados do PC
      const pcResult = await this.client.query(`
        SELECT vidaatual, vidamax
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


      await this.client.query(`
          UPDATE PC
          SET vidaAtual = ${vidaAtualPC}
          WHERE IdPersonagem = ${idpc};
          `);
      console.log(`\nVida do PC atualizada para: ${vidaAtualPC}`);



    } catch (error) {
      console.error("Erro ao atacar PC por Infectado:", error.message || error);
    }
  };

  reiniciarSala = async (salaAtual, idpc) => {
    try {
      if (!salaAtual) {
        console.error("Erro: salaAtual não pode ser NULL.");
        return;
      }
      await this.client.query(`
            UPDATE NPC
            SET vidaAtual = vidaMax
            WHERE IdPersonagem IN (
                SELECT idNPC
                FROM InstNPC
                WHERE Sala = $1
            );
        `, [salaAtual]);

      await this.client.query(`
            UPDATE PC
            SET Sala = $1, vidaAtual = vidaMax
            WHERE IdPersonagem = $2;
        `, [salaAtual, idpc]);

      console.log("Sala reiniciada com sucesso. PC reposicionado e itens limpos.");
    } catch (error) {
      console.error("Erro ao reiniciar a sala:", error.message || error);
    }
  };

  atacarNPC = async (idnpc, idarma, sala, idpc) => {
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

        let vidaAtualNpc = npcResult.rows[0].vidaatual;
        const vidaMaxNpc = npcResult.rows[0].vidamax;

        if (isNaN(vidaAtualNpc) || isNaN(vidaMaxNpc)) {
          console.log(`Valores retornados do NPC inválidos: vidaAtual=${vidaAtualNpc}, vidaMax=${vidaMaxNpc}`);
          return;
        }

        if (vidaAtualNpc <= 0) {
          console.log("O NPC já está morto.");
          npcVivo = false;  // Condição de saída
          break;  // Sair do loop
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
        let municaoMaxPC = armaResult.rows[0].municaomax;

        // Verificar e garantir que a munição está correta
        if (isNaN(danoArma) || isNaN(municaoAtualPC) || isNaN(municaoMaxPC)) {
          console.log(`Valores retornados da arma inválidos: dano=${danoArma}, municaoAtual=${municaoAtualPC}`);
          return;
        }

        while (municaoAtualPC > 0) {
          // Determinar se o ataque acerta ou erra
          const acerto = Math.random() < 0.90 ? 'acertou' : 'errou';
          console.log(`Resultado do ataque: ${acerto}`);

          if (acerto === 'errou') {
            console.log("O ataque falhou e o inimigo te acertou.");
            await this.atacarPCPorInfectado(1, idnpc, sala);
          }

          // Se acertou, decrementar a vida do NPC
          vidaAtualNpc -= danoArma;
          if (vidaAtualNpc <= 0) {
            vidaAtualNpc = 0;
            console.log("Inimigo eliminado.");
            npcVivo = false;  // NPC foi morto, terminar o loop
            await this.client.query(`
                        WITH npc_to_delete AS (
                            SELECT idInstNPC
                            FROM InstNPC
                            WHERE idNPC = $1 AND Sala = $2
                            LIMIT 1
                        )
                        DELETE FROM InstNPC
                        USING npc_to_delete
                        WHERE InstNPC.idInstNPC = npc_to_delete.idInstNPC;
                    `, [idnpc, sala]);
            break;  // Sair do loop
          } else {
            await this.client.query(`
                        UPDATE NPC
                        SET vidaAtual = $1
                        WHERE IdPersonagem = $2;
                    `, [vidaAtualNpc, idnpc]);
            console.log(`\nVida do NPC atualizada para: ${vidaAtualNpc}`);
          }

          // Atualizar munição
          municaoAtualPC -= 1;
          await this.client.query(`
                    UPDATE Arma
                    SET municaoAtual = $1
                    WHERE IdItem = $2;
                `, [municaoAtualPC, idarma]);

          console.log(`Munição da arma atualizada para: ${municaoAtualPC}`);

          // Verificar se precisa recarregar a arma
          if (municaoAtualPC <= 0) {
            console.log("\nRecarregando a arma...\n");
            municaoAtualPC = await this.recarregarArma(idarma);
            console.log(`Munição recarregada: ${municaoAtualPC}`);
          }

          // Verificação de fim do combate
          if (!npcVivo) break;
        }

        // Quebra do loop principal caso NPC esteja morto
        if (!npcVivo) break;
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
      WHERE IdItem = $1
      RETURNING municaoMax;
      `, [idarma]);

      await this.client.query(`
          WITH municao_to_delete AS (
                SELECT idInstItem
                FROM InstItem
                WHERE idItem = 18 and idinventario = 1
                LIMIT 1
                )
                DELETE FROM InstItem
                USING municao_to_delete
                WHERE InstItem.idInstItem = municao_to_delete.idInstItem;
          `);

    } catch (error) {
      console.error("Erro ao atualizar a munição da arma:", error.message || error);
    }
  };

  updateXPMisJoelPatr = async (idMissao) => {
    try {
      // Atualiza o XP do personagem
      await this.client.query(`
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

      console.log("XP do PC atualizado com sucesso!");
    } catch (error) {
      console.error("Erro ao atualizar o XP:", error.message || error);
    }
  };

  adquireItemNPC = async (idinventarioNPC) => {
    try {
      // Consulta para obter as instâncias de itens do inventário do NPC
      const institemnpcResult = await this.client.query(`
        SELECT idInstItem as instancia 
        FROM InstItem
        WHERE IdInventario = $1`, [idinventarioNPC]);

      // Consulta para obter os itens correspondentes às instâncias no inventário do NPC
      const itemnpcResult = await this.client.query(`
        SELECT i.idItem as item
        FROM InstItem inst
        JOIN Item i ON inst.IdItem = i.idItem
        WHERE inst.IdInventario = $1`, [idinventarioNPC]);

      const institemnpc = institemnpcResult.rows[0].instancia;
      const itemnpc = itemnpcResult.rows[0].item;

      this.adicionarItemAoInventario(institemnpc);

      // Mensagem de sucesso
      console.log("Você adquiriu os itens com sucesso!");
    }
    catch (error) {
      // Tratamento de erro
      console.log("Erro ao adquirir item de NPC:", error.message || error);
    }
  };

  infos = async (salaAtual) => {
    try {
      // Obtém a sala atual (ou use o valor passado como parâmetro)
      salaAtual = await this.getSalaAtual(); // se necessário
      console.log("Você chegou na sala " + salaAtual);

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

  mudarParaProximaSala = async (proximaSalaNumero, funcaoProcessamentoProximaSala) => {
    try {
      // Pergunta ao usuário se ele deseja seguir para a próxima sala e aguarda a resposta
      const respostaUsuario = await this.askAndReturn("\nVocê deseja seguir para a próxima sala?\nS/N\n");
      const mis = String(respostaUsuario).trim(); // Garante que o valor seja uma string e remove espaços em branco

      if (mis.toLowerCase() === 's') {
        console.log(`\n\nVocê irá agora para sala ${proximaSalaNumero}, aguarde...`);

        // Atualiza para a próxima sala
        await this.updateSala(proximaSalaNumero);

        console.log("Sala atualizada, esperando 2 segundos...");
        console.clear();

        // Obtém a nova sala atual
        let novaSala = await this.getSalaAtual();

        // Chama a função de processamento para a nova sala
        await funcaoProcessamentoProximaSala(novaSala);
      } else {
        console.log("Usuário escolheu não mudar de sala.");
      }
    } catch (error) {
      console.error("Erro ao mudar para a próxima sala:", error);
    }
  };

  setTrueMissaoPatrulha = async (idMissao) => {
    try {
      await this.client.query(`
        UPDATE MissaoPatrulha SET statusMissao = 'true'
        WHERE idMissao = ${idMissao}`)

    }
    catch (error) {
      console.error("Erro ao atualizar missão: ", error);
    }
  };

  setTrueMissaoExploracao = async (idMissao) => {
    try {
      await this.client.query(`
        UPDATE MissaoExploracao SET statusMissao = 'true'
        WHERE idMissao = ${idMissao}`)

    }
    catch (error) {
      console.error("Erro ao atualizar missão:", error);
    }
  };

  mostrarItensDaSala = async (idSala) => {
    try {
      // Buscar e ordenar itens na sala
      const itens = await this.client.query(`
          SELECT 
          it.idinstitem,
          COALESCE(a.nomeItem, v.nomeItem, c.nomeItem) AS nomeitem,
          it.idItem
          FROM InstItem it
          LEFT JOIN Consumivel c ON it.idItem = c.idItem
          LEFT JOIN Arma a ON it.idItem = a.idItem
          LEFT JOIN Vestimenta v ON it.idItem = v.idItem
          WHERE it.Sala = $1
          ORDER BY it.idinstitem ASC;
      `, [idSala]);

      if (itens.rows.length === 0) {
        console.log("Nenhum item encontrado nesta sala.");
        return;
      }

      // Agrupar itens pelo nome
      const itensAgrupados = itens.rows.reduce((acc, item) => {
        const { nomeitem, idinstitem } = item;
        if (!acc[nomeitem]) {
          acc[nomeitem] = { ids: [], count: 0 };
        }
        acc[nomeitem].ids.push(idinstitem);
        acc[nomeitem].count += 1; // Incrementa 1 para cada ocorrência do item
        return acc;
      }, {});

      console.log("\nItens encontrados na sala:");
      for (const [nomeitem, { ids, count }] of Object.entries(itensAgrupados)) {
        // Ordenar IDs em ordem crescente
        const idsOrdenados = ids.sort((a, b) => a - b);
        console.log(`| Qtd: ${count} | ${nomeitem} | ID: ${idsOrdenados.join(',')}`);
      }

      const escolha = await this.askAndReturn(
        "\nVocê encontrou alguns itens na sala.\nDeseja pegá-los?\n(1 - Todos, 2 - Nenhum, 3 - Especificar)\n"
      );
      // const escolhaTratada = String(escolha).trim().toLowerCase();

      switch (escolha) {
        case '1': // Pegar todos os itens
          for (const item of itens.rows) {
            // Verifique a capacidade antes de adicionar o item
            const capacidadeDisponivel = await this.verificarCapacidadeInventario();

            if (capacidadeDisponivel > 0) {
              const sucesso = await this.adicionarItemAoInventario(item.idinstitem);

              if (!sucesso) {
                console.log(`Erro ao adicionar o item ${item.nomeitem} ao inventário.`);
                return;
              }
            } else {
              console.log("Inventário cheio. Não é possível adicionar mais itens.");
              return;
            }
          }
          //console.log("\nTodos os itens foram adicionados ao inventário com sucesso!\n");
          break;

        case '2': // Não pegar nenhum item
          console.log("\nVocê decidiu não pegar nenhum item.\n");
          break;

        case '3': // Pegar itens específicos
          const idsParaPegar = await this.askAndReturn("Digite o(s) ID(s) dos itens que deseja pegar (separados por vírgula ou espaço):\n");
          const idsSelecionados = idsParaPegar
            .split(/[\s,]+/) // Divide por espaços ou vírgulas
            .map(id => parseInt(id.trim(), 10))
            .filter(id => !isNaN(id)); // Filtra IDs válidos

          if (idsSelecionados.length > 0) {
            const idsInvalidos = [];
            for (const id of idsSelecionados) {
              const itemEncontrado = itens.rows.find(item => item.idinstitem === id);

              if (itemEncontrado) {
                // Adicionar item ao inventário
                await this.adicionarItemAoInventario(itemEncontrado.idinstitem, itemEncontrado.idItem);
                await this.updateCapacidadeInventario(1);
                // Atualizar a tabela InstItem para remover o item da sala e adicionar ao inventário
                await this.client.query(`
                  UPDATE InstItem
                  SET Sala = NULL, IdInventario = 1
                  WHERE idinstitem = $1
                `, [itemEncontrado.idinstitem]);

                console.log(`O item '${itemEncontrado.nomeitem}' foi adicionado ao inventário!\n`);
              } else {
                idsInvalidos.push(id);
              }
            }

            if (idsInvalidos.length > 0) {
              console.log(`IDs de item inválidos: ${idsInvalidos.join(', ')}. Tente novamente.`);
            }
          } else {
            console.log("Nenhum ID de item válido foi fornecido.");
          }
          break;

        default:
          console.log("\nOpção inválida.\n");
      }
    } catch (error) {
      console.error("Erro ao listar os itens da sala:", error.message || error);
    }
  };

  verInventario = async () => {
    try {
      const respostaUsuario = await this.askAndReturn("\nVocê deseja ver seu inventário?\nS/N\n");

      if (respostaUsuario === 's') {
        let removerItem = true;

        while (removerItem) {
          // Mostrar o inventário
          console.log("Seu inventário atual é:");
          const inventario = await this.mostrarInventario();

          // Perguntar se deseja remover um item
          const respostaRemover = await this.askAndReturn("\nVocê deseja remover um item? S/N\n");

          if (respostaRemover === 's') {
            // Perguntar qual item remover
            const idItemRemover = await this.askAndReturn("Digite o(s) ID(s) do item que deseja remover (separados por vírgula ou espaço):\n");
            const idsParaRemover = idItemRemover
              .split(/[\s,]+/) // Divide por espaços ou vírgulas
              .map(id => parseInt(id.trim(), 10))
              .filter(id => !isNaN(id)); // Filtra IDs válidos

            if (idsParaRemover.length > 0) {
              for (const id of idsParaRemover) {
                // Verifica se o item existe
                const inventarioAtual = await this.mostrarInventario();
                const itemExiste = inventarioAtual.some(item => item.idinstitem === id);

                if (itemExiste) {
                  await this.removerItem(id);
                  console.log(`Item com ID ${id} removido com sucesso.`);
                } else {
                  console.log(`ID de item ${id} inválido. Tente novamente.`);
                }
              }
            } else {
              console.log("IDs de item inválidos. Tente novamente.");
            }
          } else if (respostaRemover === 'n') {
            console.log("Continuando...");
            removerItem = false;
          } else {
            console.log("Opção inválida. Por favor, responda com S ou N.");
          }
        }
      }
    } catch (error) {
      console.error("Erro ao exibir o inventário:", error.message || error);
    }
  };

  mostrarInventario = async () => {
    try {
      const inventario = await this.client.query(`
          SELECT i.idInstItem, COALESCE(a.nomeItem, v.nomeItem, c.nomeItem) AS nomeItem
          FROM InstItem i
          JOIN Inventario ii ON i.IdInventario = ii.idInventario
          LEFT JOIN Arma a ON i.IdItem = a.IdItem
          LEFT JOIN Vestimenta v ON i.IdItem = v.IdItem
          LEFT JOIN Consumivel c ON i.IdItem = c.IdItem
          WHERE i.idinventario = 1
          ORDER BY nomeItem;
        `);

      if (inventario.rows.length === 0) {
        console.log("Seu inventário está vazio.");
        return [];
      }

      // Agrupar itens pelo nome
      const itensAgrupados = inventario.rows.reduce((acc, item) => {
        const { nomeitem, idinstitem } = item;
        if (!acc[nomeitem]) {
          acc[nomeitem] = { ids: [], count: 0 };
        }
        acc[nomeitem].ids.push(idinstitem);
        acc[nomeitem].count += 1; // Incrementa 1 para cada ocorrência do item
        return acc;
      }, {});

      console.log("\nSeus itens:");
      for (const [nomeitem, { ids, count }] of Object.entries(itensAgrupados)) {
        // Ordenar IDs em ordem crescente
        const idsOrdenados = ids.sort((a, b) => a - b);
        console.log(`| Qtd: ${count} | ${nomeitem} | ID: ${idsOrdenados.join(',')}`);
      }

      return inventario.rows; // Retorna os itens para que possam ser usados para remoção

    } catch (error) {
      console.error("Erro ao mostrar inventário:", error.message || error);
    }
  };

  removerItem = async (idInstItem) => {
    try {
      await this.client.query(`
          DELETE FROM InstItem
          WHERE idInstItem = $1;
        `, [idInstItem]);

      console.log("Item removido com sucesso.");
    } catch (error) {
      console.error("Erro ao remover item:", error.message || error);
    }
  };

  verMunicao = async () => {
    try {
      const qtdMunicao = await this.client.query(`
          select count (*) as ammo from institem
          where iditem = 18 and idinventario = 1
        `,);

      return qtdMunicao.rows[0].ammo;
    } catch (error) {
      console.error("Erro ao verificar a munição:", error.message || error);
    }
  };

  consumivelDaVida = async (id) => {
    try {
      await this.client.query(`
        UPDATE PC SET vidaAtual = vidaatual + (SELECT c.aumentoVida 
        FROM Consumivel c
        join institem i on i.iditem = c.iditem
        join inventario inv on inv.idinventario = i.idinventario
        WHERE i.IdItem = $1 and inv.idinventario = 1)
        WHERE IdPersonagem = 1;`, [id]);
    } catch (error) {
      console.error("Erro ao consumir item:", error.message || error);
    }
  };

  consumivelDano = async (idinstnpc, iditem) => {
    try {
      await this.client.query(`
        UPDATE NPC
        SET vidaAtual = vidaAtual - c.danoConsumivel
        FROM Consumivel c
        JOIN instnpc i ON NPC.idpersonagem = i.idnpc
        WHERE i.idInstNPC = $1 
        AND c.eAtaque = true   
        AND c.IdItem = $2;     
    `, [idinstnpc, iditem]);
    }
    catch {
      console.error("Erro ao consumir item:", error.message || error);
    }
  };

  mostrarConsumivel = async () => {
    try {
      const consumiveis = await this.client.query(`
        select c.nomeitem AS nome, c.iditem
        from consumivel c 
        join institem i on i.iditem = c.iditem
        join inventario ii on ii.idinventario = i.idinventario
        where ii.idinventario = 1 and danoConsumivel IS NOT NULL`);
      if (consumiveis.rows.length === 0) {
        console.log("Você não possui consumiveis.");
      } else {
        console.log("\nSuas consumiveis:\n");
        consumiveis.rows.forEach(consumivel => {
          console.log(`${consumivel.nome} Id: ${consumivel.iditem}`);
        });
      }
    } catch (error) {
      console.error("Erro ao mostrar consumiveis:", error.message || error);
    }
  };

  mostrarConsumivelVida = async () => {
    try {
      const consumiveis = await this.client.query(`
        select c.nomeitem AS nome, c.iditem
        from consumivel c 
        join institem i on i.iditem = c.iditem
        join inventario ii on ii.idinventario = i.idinventario
        where ii.idinventario = 1 and aumentoVida IS NOT NULL`);
      if (consumiveis.rows.length === 0) {
        console.log("Você não possui consumiveis.");
      } else {
        console.log("\nSeus consumiveis:\n");
        consumiveis.rows.forEach(consumivel => {
          console.log(`Id: ${consumivel.iditem} | ${consumivel.nome}`);
        });
      }
    } catch (error) {
      console.error("Erro ao mostrar consumiveis:", error.message || error);
    }
  };

  verVidaPC = async () => {
    try {
      const qtdVida = await this.client.query(`
          SELECT vidaAtual FROM PC WHERE idPersonagem = 1;
        `,);

      return qtdVida.rows[0].ammo;
    } catch (error) {
      console.error("Erro ao verificar a munição:", error.message || error);
    }
  };

  atacarNPCComConsumivel = async (idnpc, idconsumivel, sala, idpc) => {
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

        let vidaAtualNpc = npcResult.rows[0].vidaatual;
        const vidaMaxNpc = npcResult.rows[0].vidamax;

        if (isNaN(vidaAtualNpc) || isNaN(vidaMaxNpc)) {
          console.log(`Valores retornados do NPC inválidos: vidaAtual=${vidaAtualNpc}, vidaMax=${vidaMaxNpc}`);
          return;
        }

        if (vidaAtualNpc <= 0) {
          console.log("O NPC já está morto.");
          npcVivo = false;
          break;  // Sair do loop
        }

        // Obter os dados do consumível
        const consumivelResult = await this.client.query(`
          SELECT c.danoConsumivel
          FROM Consumivel c
          WHERE c.IdItem = $1
        `, [idconsumivel]);

        if (consumivelResult.rows.length === 0) {
          console.log("Consumível não encontrado.");
          return;
        }

        const danoConsumivel = consumivelResult.rows[0].danoconsumivel;

        if (isNaN(danoConsumivel)) {
          console.log(`Dano do consumível inválido: danoConsumivel=${danoConsumivel}`);
          return;
        }

        // Determinar se o ataque com o consumível acerta ou erra
        const acerto = Math.random() < 0.90 ? 'acertou' : 'errou';
        console.log(`Resultado do ataque com consumível: ${acerto}`);

        if (acerto === 'errou') {
          console.log("O ataque falhou e o inimigo te acertou.");
          await this.atacarPCPorInfectado(1, idnpc, sala);
        } else {
          // Se acertou, decrementar a vida do NPC
          vidaAtualNpc -= danoConsumivel;
          if (vidaAtualNpc <= 0) {
            vidaAtualNpc = 0;
            console.log("Inimigo eliminado.");
            npcVivo = false;  // NPC foi morto, terminar o loop
            await this.client.query(`
              WITH npc_to_delete AS (
                SELECT idInstNPC
                FROM InstNPC
                WHERE idNPC = $1 AND Sala = $2
                LIMIT 1
              )
              DELETE FROM InstNPC
              USING npc_to_delete
              WHERE InstNPC.idInstNPC = npc_to_delete.idInstNPC;
            `, [idnpc, sala]);
            break;  // Sair do loop
          } else {
            await this.client.query(`
              UPDATE NPC
              SET vidaAtual = $1
              WHERE IdPersonagem = $2;
            `, [vidaAtualNpc, idnpc]);
            console.log(`\nVida do NPC atualizada para: ${vidaAtualNpc}`);
          }
        }

        // Verificação de fim do combate
        if (!npcVivo) break;
      }

      console.log("Combate finalizado.");
    } catch (error) {
      console.error("Erro ao atacar NPC com consumível:", error.message || error);
    }
  };

  getPersonagem = async () => {
    try {
      // Executa a consulta para obter o ID do personagem
      const pc = await this.client.query(`
      SELECT idPersonagem FROM PC;
    `);

      // Verifica se há resultados e se o ID do personagem está disponível
      if (pc.rows.length > 0 && pc.rows[0].idpersonagem) {
        return pc.rows[0].idpersonagem;
      } else {
        throw new Error("Nenhum personagem encontrado ou idPersonagem não disponível.");
      }
    } catch (error) {
      console.error("Erro ao obter o personagem:", error.message || error);
      throw error; // Lança o erro para ser tratado em outro lugar, se necessário
    }
  }

}// fechando a api

export default Api;
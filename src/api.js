import pg from "pg";
import { readFileSync } from "fs";

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
    password: "lg2x12345",
    port: 5432,
    database: "tlou",
  });

  constructor() {
    this.client.connect();
  }

  createTables = async () => {
    let response = false;
    console.log(sqlTables);
    await this.client.query(sqlTables).then((results) => {
      response = true;
    });
    return response;
  };

  populateTables = async () => {
    let response = false;
    await this.client.query(sqlData).then((results) => {
      response = true;
    });
    return response;
  };

  // Função para exibir os NPCs da sala atual
  mostrarNPCsDaSala = async (idSala) => {
    try {
      const npcs = await this.client.query(`
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

  // funcao para mostrar os itens da sala
  mostrarItensDaSala = async (idSala) => {
    try {
      const itens = await this.client.query(`
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
        ORDER BY totalitens DESC;`);
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

  adicionarItemAoInventario = async (idinstitem, idinventario, iditem) => {
    try {
      const result = await this.client.query(`
        UPDATE InstItem
        SET IdInventario = ${idinventario}
        WHERE idInstItem = ${idinstitem} AND IdItem = ${iditem}
        RETURNING *;
      `);
      if (result.rows.length === 0) {
        console.log("Erro ao adicionar item ao inventário.");
      } else {
        return result.rows[0]; // Retorna o item atualizado, se necessário
      }
    } catch (error) {
      console.error("Erro ao adicionar o item ao inventário:", error.message || error);
    }
  }

  atualizarCapacidadeInventario = async (id_inventario) => {
    try {
      const result = await this.client.query(`
        UPDATE Inventario
        SET capacidade = capacidade - 1
        WHERE idInventario = ${id_inventario}
        RETURNING capacidade;
      `);
      if (result.rows.length === 0) {
        console.log("Erro ao atualizar a capacidade do inventário.");
      } else {
        console.log("Capacidade do inventário atualizada para:", result.rows[0].capacidade);
      }
    } catch (error) {
      console.error("Erro ao atualizar a capacidade do inventário:", error.message || error);
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

  atacarNPC = async (id_npc, id_arma) => {
    try {
      // Obter os dados do NPC
      const npcResult = await this.client.query(`
        SELECT vidaAtual, vidaMax
        FROM NPC
        WHERE IdPersonagem = ${id_npc};
      `);

      if (npcResult.rows.length === 0) {
        console.log("NPC não encontrado.");
        return;
      }

      let vidaAtual = npcResult.rows[0].vidaAtual;

      // Obter os dados da arma
      const armaResult = await this.client.query(`
        SELECT dano, municaoAtual, municaoMax
        FROM Arma
        WHERE IdItem = ${id_arma};
      `);

      if (armaResult.rows.length === 0) {
        console.log("Arma não encontrada.");
        return;
      }

      let dano = armaResult.rows[0].dano;
      let municaoAtual = armaResult.rows[0].municaoAtual;

      // Verificar se há munição suficiente
      if (municaoAtual <= 0) {
        console.log("Sem munição suficiente para atacar.");
        return;
      }

      // Decrementar a vida do NPC
      vidaAtual -= dano;

      // Atualizar a vida do NPC ou deletá-lo se a vida chegar a 0
      if (vidaAtual <= 0) {
        await this.client.query(`
          DELETE FROM NPC
          WHERE IdPersonagem = ${id_npc};
        `);
        console.log("NPC eliminado.");
      } else {
        await this.client.query(`
          UPDATE NPC
          SET vidaAtual = ${vidaAtual}
          WHERE IdPersonagem = ${id_npc};
        `);
        console.log(`Vida do NPC atualizada para: ${vidaAtual}`);
      }

      // Atualizar a munição da arma
      municaoAtual -= 1;
      await this.client.query(`
        UPDATE Arma
        SET municaoAtual = ${municaoAtual}
        WHERE IdItem = ${id_arma};
      `);
      console.log(`Munição da arma atualizada para: ${municaoAtual}`);

    } catch (error) {
      console.error("Erro ao atacar NPC:", error.message || error);
    }
  }



}

export default Api;
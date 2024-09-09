-- pegar a sala atual
CREATE VIEW get_sala_atual AS 
        SELECT s.idsala
        FROM Regiao r
        JOIN Sala s ON s.idRegiao = r.idRegiao 
        JOIN PC p ON p.sala = s.idSala;

-- NPCs aliados
CREATE VIEW mostrar_npcs_aliados AS 
        SELECT n.nomePersonagem
        FROM NPC n
        JOIN instnpc i ON n.idpersonagem = i.idnpc
        WHERE n.ealiado = true;

-- NPCs que são inimigos
CREATE VIEW mostrar_inimigo_npc AS 
        SELECT n.nomePersonagem as nome, i.idinstnpc as idinstancia
        FROM NPC n
        JOIN instnpc i ON n.idpersonagem = i.idnpc
        LEFT JOIN infectado ii ON ii.idnpc = i.idnpc
        LEFT JOIN faccaohumana h ON h.idnpc = i.idnpc
        LEFT JOIN animal a ON a.idnpc = i.idnpc
        WHERE (i.tiponpc = 'I' OR i.tiponpc = 'A' OR i.tiponpc = 'F') 
        AND ealiado = false
        ORDER BY idinstancia;

-- Capacidade disponível no inventário
CREATE VIEW verificar_capacidade_inventario AS 
        SELECT capacidade - (SELECT COUNT(*) FROM InstItem WHERE IdInventario = 1)
        AS capacidadeDisponivel
        FROM Inventario;

-- Capacidade do inventário do Joel
CREATE VIEW capacidade_depois_update AS 
        SELECT capacidade FROM Inventario WHERE idinventario = 1;

-- Armas
CREATE VIEW mostrar_armas AS 
        SELECT a.nomeitem AS nome, a.iditem
        FROM arma a 
        JOIN institem i ON i.iditem = a.iditem
        JOIN inventario ii ON ii.idinventario = i.idinventario;

-- Conteudo dos dialogos
CREATE VIEW mostrar_dialogo AS
        SELECT conteudo
        FROM Dialoga;

-- Vestimentas
CREATE VIEW update_vida_vestimente AS
        SELECT COUNT(i.idInstItem) AS totalitens, v.nomeItem AS nomeItem  
        FROM InstItem i
        JOIN Vestimenta v ON i.IdItem = v.IdItem
        GROUP BY  v.nomeItem
        ORDER BY totalitens DESC;

-- Nome e descricao de eventos
CREATE VIEW evento_v AS
        SELECT descricao, nomeevento 
        FROM Evento;

-- Objetivos das Missões Exploração
CREATE VIEW objetivo_exploracao AS
        SELECT objetivo 
        FROM missaoexploracaoobteritem;

-- Objetivos das Missões Patrulha
CREATE VIEW objetivo_exploracao AS
        SELECT objetivo 
        FROM missaopatrulha;

-- Dados sobre a vida do PC
CREATE VIEW pc_result AS 
        SELECT vidaAtual, vidaMax
        FROM PC;

-- Dados sobre os danos do infectado
CREATE VIEW infectado_result AS 
        SELECT danoInfectado
        FROM Infectado;

-- Dados sobre a vida do NPC
CREATE VIEW atacar_npc AS
        SELECT n.vidaatual, n.vidamax
        FROM instnpc i
        JOIN npc n ON n.idpersonagem = i.idnpc;

-- Dados sobre dado e munição das armas
CREATE VIEW arma_result AS
        SELECT a.dano AS danoA, a.municaoAtual AS municaoA, a.municaoMax AS municaoMax
        FROM Arma a
        JOIN institem i ON i.iditem = a.iditem;

-- Instancias de item presentes em determidado inventário
CREATE VIEW institemnpc_result AS
        SELECT idInstItem    
        FROM InstItem
        WHERE IdInventario = ;

-- Obter o idItem das instancias de item presentes em determidado inventário
CREATE VIEW itemnpc_result AS
        SELECT i.idItem
        FROM InstItem inst
        JOIN Item i ON inst.IdItem = i.idItem
        WHERE inst.IdInventario = 1;

-- Obtém o nome e descricao da região de todas as salas
CREATE VIEW regiao_atual AS
        SELECT r.nomeRegiao, r.descricaoRegiao
        FROM Regiao r 
        JOIN Sala s ON s.idRegiao = r.idRegiao;

-- Itens vinculados a uma determinada sala
CREATE VIEW mostrar_itens_da_sala AS
        SELECT it.idinstitem, COALESCE(a.nomeItem, v.nomeItem, c.nomeItem) 
        AS nomeitem, it.idItem
        FROM InstItem it
        LEFT JOIN Consumivel c ON it.idItem = c.idItem
        LEFT JOIN Arma a ON it.idItem = a.idItem
        LEFT JOIN Vestimenta v ON it.idItem = v.idItem
        WHERE it.Sala = 1
        ORDER BY it.idinstitem ASC;

-- Mostrar os itens de um determinado inventário
CREATE VIEW mostrar_inventario AS
        SELECT i.idInstItem, COALESCE(a.nomeItem, v.nomeItem, c.nomeItem) AS nomeItem
        FROM InstItem i
        JOIN Inventario ii ON i.IdInventario = ii.idInventario
        LEFT JOIN Arma a ON i.IdItem = a.IdItem
        LEFT JOIN Vestimenta v ON i.IdItem = v.IdItem
        LEFT JOIN Consumivel c ON i.IdItem = c.IdItem
        WHERE i.idinventario = 1
        ORDER BY nomeItem;

-- Quantidade de munições de um determinado item
CREATE VIEW ver_municao AS
          SELECT count (*) AS qtd from instItem
          WHERE idItem = 18;

-- Mostrar os consumíveis do inventário do Joel
CREATE VIEW mostrar_consumivel AS
        SELECT c.nomeitem AS nome, c.iditem
        FROM consumivel c 
        JOIN institem i ON i.iditem = c.iditem
        JOIN inventario ii ON ii.idinventario = i.idinventario
        WHERE ii.idinventario = 1 AND danoConsumivel IS NOT NULL;

-- Danos do consumível
CREATE VIEW consumivel_result AS
        SELECT c.danoConsumivel
        FROM Consumivel c;
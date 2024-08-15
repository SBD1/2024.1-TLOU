--Listar todas as regiões e suas capacidades:
SELECT nomeRegiao, capacidade 
FROM Regiao;

-- Mostrar onde o Joel está (em que sala):
SELECT Sala 
FROM PC 
WHERE idPC = 1;

-- Descrição de uma região de acordo com a sala em que ela está:
SELECT r.descricaoRegiao 
FROM Sala s
JOIN Regiao r
ON s.IdRegiao = r.idRegiao;

--Itens no inventario do Joel:
SELECT I.nomeInstItem 
FROM InventarioItem II
JOIN InstItem I ON II.idItem = I.idItem
WHERE II.idInventario = 1;

--Consultar todas as zonas de quarentena com segurança acima de um certo nível:
SELECT idZona, seguranca, populacaoAtual 
FROM ZonaQuarentena 
WHERE seguranca > 5;

--Quantas salas tem em cada regiao:
SELECT S.idSala, R.nomeRegiao 
FROM Sala S
JOIN Regiao R ON S.IdRegiao = R.idRegiao;

-- Selecionar apenas NPCs:
SELECT idPersonagem 
FROM Personagem 
WHERE tipoPersonagem = 2; -- Por exemplo, 2 pode ser um tipo específico de personagem

--Itens em um inventário específico:
SELECT I.nomeInstItem 
FROM InventarioItem II
JOIN InstItem I ON II.idItem = I.idItem
WHERE II.idInventario = 1;

--Missões que utilizam um determinado tipo de item:
SELECT M.idMissao 
FROM Itens I
JOIN Missao M ON I.IdMissao = M.idMissao
WHERE I.IdItem = 3; -- Considerando que 3 seja um ID de item específico

--Listar todas as regiões com seus detalhes:
SELECT idRegiao, nomeRegiao, descricaoRegiao, capacidade, tipoRegiao 
FROM Regiao;

--Consultar todos os locais abandonados em uma região específica (por exemplo, Cidade Abandonada):
SELECT idLocal, tipo, descricao, nivelPerigo 
FROM LocalAbandonado 
WHERE IdRegiao = 2;  -- Cidade Abandonada

--Obter detalhes dos NPCs em uma sala específica:
SELECT nomePersonagem, xp, vidaMax, vidaAtual, Loot 
FROM NPC 
WHERE Sala = 1;

--Verificar a capacidade e o uso atual do inventário de um NPC específico:
SELECT I.descricao, I.capacidade, SUM(II.quantidade) AS uso_atual
FROM Inventario I
JOIN InventarioItem II ON I.idInventario = II.idInventario
WHERE I.idInventario = (SELECT IdInventario FROM NPC WHERE idNPC = 1)
GROUP BY I.descricao, I.capacidade;

--Missões que utilizam um tipo específico de item:
SELECT M.idMissao, M.tipoMis 
FROM Itens I
JOIN Missao M ON I.IdMissao = M.idMissao
WHERE I.IdItem = 3; -- Por exemplo, uma bomba


-- Listar todas as zonas de quarentena e suas populações:
SELECT ZQ.idZona, R.nomeRegiao, ZQ.populacaoAtual 
FROM ZonaQuarentena ZQ
JOIN Regiao R ON ZQ.IdRegiao = R.idRegiao;

--Consultar todos os acampamentos com seu nível de defesa:
SELECT A.idAcampamento, R.nomeRegiao, A.defesa 
FROM Acampamento A
JOIN Regiao R ON A.IdRegiao = R.idRegiao;

--Encontrar todos os locais abandonados em regiões que são perigosas (com nível de perigo acima de 7):
SELECT LA.idLocal, LA.tipo, LA.descricao, LA.nivelPerigo, R.nomeRegiao 
FROM LocalAbandonado LA
JOIN Regiao R ON LA.IdRegiao = R.idRegiao
WHERE LA.nivelPerigo > 7;

--Obter detalhes de todos os personagens que não são aliados:
SELECT P.idPersonagem, NPC.nomePersonagem, NPC.xp, NPC.vidaMax, NPC.vidaAtual 
FROM Personagem P
JOIN NPC ON P.idPersonagem = NPC.IdPersonagem
WHERE NPC.eAliado = false;

--Listar todos os itens em um inventário específico:
SELECT II.nomeInstItem, I.capacidade, I.descricao 
FROM InventarioItem II
JOIN InstItem IT ON II.idItem = IT.idItem
JOIN Inventario I ON II.idInventario = I.idInventario
WHERE I.idInventario = 1;

--Consultar as regiões que possuem mais de um tipo de estrutura (zona de quarentena, acampamento, etc.):
SELECT R.nomeRegiao, COUNT(DISTINCT ZQ.idZona) AS ZonasQuarentena, COUNT(DISTINCT A.idAcampamento) AS Acampamentos, COUNT(DISTINCT LA.idLocal) AS LocaisAbandonados
FROM Regiao R
LEFT JOIN ZonaQuarentena ZQ ON R.idRegiao = ZQ.IdRegiao
LEFT JOIN Acampamento A ON R.idRegiao = A.IdRegiao
LEFT JOIN LocalAbandonado LA ON R.idRegiao = LA.IdRegiao
GROUP BY R.nomeRegiao
HAVING COUNT(DISTINCT ZQ.idZona) > 0 AND COUNT(DISTINCT A.idAcampamento) > 0 AND COUNT(DISTINCT LA.idLocal) > 0;

--Missões que envolvem zonas de quarentena com alta segurança (acima de 10):
SELECT M.idMissao, M.tipoMis, ZQ.seguranca 
FROM Missao M
JOIN Itens I ON M.idMissao = I.IdMissao
JOIN ZonaQuarentena ZQ ON I.IdItem IN (SELECT idItem FROM InstItem WHERE nomeInstItem = 'Algum item relacionado a segurança')
WHERE ZQ.seguranca > 10;

--Encontrar as regiões com maior capacidade e listar suas zonas de quarentena e acampamentos:
SELECT R.nomeRegiao, R.capacidade, ZQ.idZona AS ZonaQuarentena, A.idAcampamento AS Acampamento
FROM Regiao R
LEFT JOIN ZonaQuarentena ZQ ON R.idRegiao = ZQ.IdRegiao
LEFT JOIN Acampamento A ON R.idRegiao = A.IdRegiao
WHERE R.capacidade > 20;

--Detalhes dos personagens (NPCs) com loot específico:
SELECT NPC.nomePersonagem, NPC.vidaMax, NPC.vidaAtual, NPC.Loot 
FROM NPC 
WHERE NPC.Loot LIKE '%Revólver%'; 

-- Listar missões que envolvem regiões com locais abandonados perigosos (nível de perigo acima de 8):
SELECT M.idMissao, M.tipoMis, LA.descricao, LA.nivelPerigo 
FROM Missao M
JOIN Itens I ON M.idMissao = I.IdMissao
JOIN LocalAbandonado LA ON I.IdItem IN (SELECT idItem FROM InstItem WHERE nomeInstItem = 'Algum item encontrado em locais perigosos')
WHERE LA.nivelPerigo > 8;

-- Conta quantos NPCs existem no banco de dados
SELECT COUNT(*) AS totalNPCs FROM NPC;

-- Soma total de XP ganho em missões de patrulha
SELECT SUM(xpMis) AS xpTotalPatrulha FROM MissaoPatrulha;

-- Consulta que retorna todos os personagens com seus inventários associados
SELECT Personagem.nomePersonagem, Inventario.descricao
FROM Personagem
JOIN Inventario ON Personagem.idInventario = Inventario.idInventario;
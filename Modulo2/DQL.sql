-- Consultas e updates para o jogo

--Listar todas as regiões e suas capacidades:
SELECT nomeRegiao, capacidade 
FROM Regiao;

-- Mostrar onde o Joel está (em que sala):
SELECT Sala 
FROM PC 
WHERE idPC = 1;

--Ver localização de uma região:
SELECT R.nomeRegiao, S.descricaoSala
FROM Regiao R
JOIN Sala S ON R.idRegiao = S.IdRegiao

-- Descrição de uma região de acordo com a sala em que ela está:
SELECT r.descricaoRegiao 
FROM Sala s
JOIN Regiao r
ON s.IdRegiao = r.idRegiao;

--Itens no inventario do Joel:
SELECT I.nomeItem 
FROM Item I 
JOIN Inventario II ON I.IdInventario = II.idInventario 
WHERE II.idInventario = 1; 


--Ver armas do personagem:
SELECT I.idItem AS nome, I.tipoItem AS mult_ataque 
FROM Inventario INV
JOIN Item I ON INV.idInventario = I.idInventario
WHERE INV.idPersonagem = ${id_personagem} AND I.tipoItem = 1;

--Ver vestimentas do personagem:
SELECT I.idItem AS nome, I.tipoItem AS mult_ataque 
FROM Inventario INV
JOIN Item I ON INV.idInventario = I.idInventario
WHERE INV.idPersonagem = ${id_personagem} AND I.tipoItem = 2;

--Ver consumíveis do personagem:
SELECT I.idItem AS nome, I.tipoItem AS mult_ataque 
FROM Inventario INV
JOIN Item I ON INV.idInventario = I.idInventario
WHERE INV.idPersonagem = ${id_personagem} AND I.tipoItem = 3;

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

--Listar todas as regiões com seus detalhes:
SELECT * 
FROM Regiao;

--Consultar todos os locais abandonados em uma região específica (por exemplo, Cidade Abandonada):
SELECT *
FROM LocalAbandonado a JOIN Regiao r
ON a.IdRegiao = r.idRegiao
WHERE r.tipo = 2;  -- Cidade Abandonada

--Obter detalhes importantes dos NPCs em uma sala específica:
SELECT nomePersonagem, xp, vidaMax, vidaAtual 
FROM NPC 
WHERE Sala = 1;

--Verificar a capacidade e o uso atual do inventário de um NPC específico:
SELECT I.descricao, I.capacidade, SUM(II.quantidade) AS uso_atual
FROM Inventario I
JOIN InventarioItem II ON I.idInventario = II.idInventario
WHERE I.idInventario = (SELECT IdInventario FROM NPC WHERE idNPC = 2)
GROUP BY I.descricao, I.capacidade;

--Missões que utilizam um tipo específico de item:
SELECT M.idMissao, M.tipoMis 
FROM Itens I
JOIN Missao M ON I.IdMissao = M.idMissao
WHERE I.IdItem = 3; -- Por exemplo, uma bomba

-- Listar todas as zonas de quarentena e suas populações:
SELECT ZQ.idRegiao, R.nomeRegiao, ZQ.populacaoAtual 
FROM ZonaQuarentena ZQ
JOIN Regiao R ON ZQ.IdRegiao = R.idRegiao;

--Consultar todos os acampamentos com seu nível de defesa:
SELECT A.IdRegiao, R.nomeRegiao, A.defesa 
FROM Acampamento A
JOIN Regiao R ON A.IdRegiao = R.idRegiao;

--Encontrar todos os locais abandonados em regiões que são perigosas (com nível de perigo acima de 7):
SELECT LA.periculosidade, R.nomeRegiao 
FROM LocalAbandonado LA
JOIN Regiao R ON LA.IdRegiao = R.idRegiao
WHERE LA.periculosidade > 7;

--Obter nome de todos os personagens que não são aliados:
SELECT NPC.nomePersonagem
FROM NPC NPC
WHERE NPC.eAliado = false;

--Listar todos os itens em um inventário específico:
SELECT II.nomeItem, I.capacidade, I.descricao 
FROM Item II
JOIN Inventario I ON II.IdInventario = I.idInventario
WHERE I.idInventario = 1; -- 1 seria um inventário específico 

--Consultar as regiões que possuem mais de um tipo de estrutura (zona de quarentena, acampamento, etc.):
SELECT R.nomeRegiao, COUNT(DISTINCT ZQ.IdRegiao) AS ZonasQuarentena, COUNT(DISTINCT A.IdRegiao) 
AS Acampamentos, COUNTmissao(DISTINCT LA.IdRegiao) AS LocaisAbandonados
FROM Regiao R
LEFT JOIN ZonaQuarentena ZQ ON R.idRegiao = ZQ.IdRegiao
LEFT JOIN Acampamento A ON R.idRegiao = A.IdRegiao
LEFT JOIN LocalAbandonado LA ON R.idRegiao = LA.IdRegiao
GROUP BY R.nomeRegiao
HAVING COUNT(DISTINCT ZQ.IdRegiao) > 0 
AND COUNT(DISTINCT A.IdRegiao) > 0 AND COUNT(DISTINCT LA.IdRegiao) > 0;

--Encontrar as regiões com maior capacidade e listar suas zonas de quarentena e acampamentos:
SELECT R.nomeRegiao, R.capacidade
FROM Regiao R
LEFT JOIN ZonaQuarentena ZQ ON R.idRegiao = ZQ.IdRegiao
LEFT JOIN Acampamento A ON R.idRegiao = A.IdRegiao
WHERE R.capacidade > 20;

-- Conta quantos NPCs existem no banco de dados
SELECT COUNT(*) AS totalNPCs 
FROM NPC;

-- Soma total de XP ganho em missões de patrulha
SELECT SUM(xpMis) AS xpTotalPatrulha 
FROM MissaoPatrulha;

-- Soma total de XP ganho em missões de exploracao/obter item
SELECT SUM(xpMis) AS xpTotalExploracao
FROM MissaoExploracaoObterItem;

-- Consulta que retorna todos os personagens com seus inventários associados
SELECT Personagem.nomePersonagem, Inventario.descricao
FROM Personagem
JOIN Inventario ON Personagem.idInventario = Inventario.idInventario;

--Consulta que retorna os NPCs que estão em uma sala
SELECT nomePersonagem 
FROM NPC 
WHERE Sala = {$idSala};

--Consulta que retorna quais NPC estao na mesma sala que Joel
SELECT nomePersonagem 
FROM NPC 
WHERE Sala = (SELECT Sala FROM PC WHERE IdPersonagem = 1);

-- Retorna os itens que pode-se obter em uma de missão de exploração 
SELECT i.*FROM Itens i
JOIN MissaoExploracaoObterItem m ON i.IdMissao = m.idMissao
JOIN Personagem p ON m.IdPersonagem = p.idPersonagem
JOIN PC pc ON p.idPersonagem = pc.IdPersonagem
WHERE pc.Sala = (
    SELECT Sala 
    FROM PC 
    WHERE Idpersonagem = ${id_personagem}
);

-- Retorna os itens que pode-se obter em uma de missão de patrulha
SELECT i.*FROM Itens i
JOIN MissaoPatrulha m ON i.IdMissao = m.idMissao
JOIN Personagem p ON m.IdPersonagem = p.idPersonagem
JOIN PC pc ON p.idPersonagem = pc.IdPersonagem
WHERE pc.Sala = (
    SELECT Sala 
    FROM PC 
    WHERE Idpersonagem = ${id_personagem}
);

-- Dá update na vida de um PC
UPDATE PC SET vidaAtual = $valor
WHERE IdPersonagem = ${id_personagem}

-- Dá update na vida de um NPC
UPDATE NPC SET vidaAtual = $valor
WHERE IdPersonagem = ${id_personagem}

-- Dá update em um inventario 
UPDATE Inventario SET capacidade = capacidade - 1
WHERE IdPersonagem = ${id_personagem} AND IdItem = ${id_item};

-- Dá update na missão patrulha falando que foi concluída
UPDATE MissaoPatrulha SET statusMissao = 'true'
WHERE idMissao = ${id_missao}

-- Dá update na missão de exploração/obter item falando que foi concluída
UPDATE MissaoExploracaoObterItem SET statusMissao = 'true'
WHERE idMissao = ${id_missao}

--Atualiza xp do jogador ao concluir missão de exploracao
UPDATE PC SET xp = xp + (SELECT xpMis FROM MissaoExploracaoObterItem WHERE idMissao = ${id_missao})
WHERE IdPersonagem = ${idPersonagem}

--Atualiza xp do jogador ao concluir missão de patrulha
UPDATE PC SET xp = xp + (SELECT xpMis FROM MissaoPatrulha WHERE idMissao = ${id_missao})
WHERE IdPersonagem = ${idPersonagem}

-- Consulta se a missão pré requisito de obter item foi concluída
SELECT statusMissao
FROM MissaoExploracaoObterItem
WHERE IdMissao = (
    SELECT IdMissaoPre
    FROM MissaoExploracaoObterItem
    WHERE IdMissao = ${id_missao}
) AND statusMissao = 'true';

-- Consulta se a missão pré requisito de patrulha foi concluída
SELECT statusMissao
FROM MissaoPatrulha
WHERE IdMissao = (
    SELECT IdMissaoPre
    FROM MissaoExploracaoObterItem
    WHERE IdMissao = ${id_missao}
) AND statusMissao = 'true';

-- Aumenta a vida de um personagem de acordo com o quanto de vida um consumivel dá
UPDATE PC SET vidaAtual + (SELECT aumentoVida FROM Consumivel WHERE IdItem = ${id_item})
WHERE IdPersonagem = ${idPersonagem};

-- mostrar a quantidade de itens de um tipo disponiveis em uma sala
SELECT 
    COALESCE(a.nomeItem, v.nomeItem, c.nomeItem) AS nomeItem,
    COUNT(*) AS quantidade
FROM InstItem it
LEFT JOIN Consumivel c ON it.idItem = c.idItem
LEFT JOIN Arma a ON it.idItem = a.idItem
LEFT JOIN Vestimenta v ON it.idItem = v.idItem
WHERE it.Sala = $sala
GROUP BY COALESCE(a.nomeItem, v.nomeItem, c.nomeItem);

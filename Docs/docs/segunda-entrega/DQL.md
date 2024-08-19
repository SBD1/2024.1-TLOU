---
sidebar_position: 3
sidebar_label: "Data Query Language"
---

# O que é DQL?
DQL (Data Query Language) é um subconjunto da SQL (Structured Query Language) que é usado para consultar e recuperar dados de um banco de dados. A principal operação em DQL é a instrução SELECT, que permite buscar e retornar dados de uma ou mais tabelas.


# Consultas e Atualizações para o Jogo

Este documento explica as consultas SQL usadas para interagir com o banco de dados de um jogo.

## Consultas

### Listar todas as regiões e suas capacidades
```sql
SELECT nomeRegiao, capacidade 
FROM Regiao;
```
Obtém o nome e a capacidade de todas as regiões no banco de dados.

### Mostrar onde o Joel está (em que sala)
```sql
SELECT Sala 
FROM PC 
WHERE idPC = 1;
```
Retorna a sala atual do personagem com ID 1 (Joel).

### Ver localização de uma região
```sql
SELECT R.nomeRegiao, S.descricaoSala
FROM Regiao R
JOIN Sala S ON R.idRegiao = S.IdRegiao;
```
Mostra o nome da região e a descrição da sala correspondente.

### Descrição de uma região de acordo com a sala em que ela está
```sql
SELECT r.descricaoRegiao 
FROM Sala s
JOIN Regiao r
ON s.IdRegiao = r.idRegiao;
```
Retorna a descrição da região para cada sala.

### Itens no inventário do Joel
```sql
SELECT I.nomeItem 
FROM Item I 
JOIN Inventario II ON I.IdInventario = II.idInventario 
WHERE II.idInventario = 1;
```
Lista os itens no inventário com ID 1, que pertence ao Joel.

### Ver armas do personagem
```sql
SELECT I.idItem AS nome, I.tipoItem AS mult_ataque 
FROM Inventario INV
JOIN Item I ON INV.idInventario = I.idInventario
WHERE INV.idPersonagem = ${id_personagem} AND I.tipoItem = 1;
```
Exibe as armas (tipoItem = 1) do personagem com o ID fornecido.

### Ver vestimentas do personagem
```sql
SELECT I.idItem AS nome, I.tipoItem AS mult_ataque 
FROM Inventario INV
JOIN Item I ON INV.idInventario = I.idInventario
WHERE INV.idPersonagem = ${id_personagem} AND I.tipoItem = 2;
```
Mostra as vestimentas (tipoItem = 2) do personagem com o ID fornecido.

### Ver consumíveis do personagem
```sql
SELECT I.idItem AS nome, I.tipoItem AS mult_ataque 
FROM Inventario INV
JOIN Item I ON INV.idInventario = I.idInventario
WHERE INV.idPersonagem = ${id_personagem} AND I.tipoItem = 3;
```
Retorna os consumíveis (tipoItem = 3) do personagem com o ID fornecido.

### Consultar todas as zonas de quarentena com segurança acima de um certo nível
```sql
SELECT idZona, seguranca, populacaoAtual 
FROM ZonaQuarentena 
WHERE seguranca > 5;
```
Lista as zonas de quarentena cuja segurança é maior que 5.

### Quantas salas tem em cada região
```sql
SELECT S.idSala, R.nomeRegiao 
FROM Sala S
JOIN Regiao R ON S.IdRegiao = R.idRegiao;
```
Mostra a quantidade de salas em cada região.

### Selecionar apenas NPCs
```sql
SELECT idPersonagem 
FROM Personagem 
WHERE tipoPersonagem = 2;
```
Obtém todos os NPCs, onde `tipoPersonagem` é 2.

### Listar todas as regiões com seus detalhes
```sql
SELECT * 
FROM Regiao;
```
Retorna todos os detalhes de cada região.

### Consultar todos os locais abandonados em uma região específica
```sql
SELECT *
FROM LocalAbandonado a 
JOIN Regiao r ON a.IdRegiao = r.idRegiao
WHERE r.tipo = 2;  -- Cidade Abandonada
```
Lista todos os locais abandonados em regiões do tipo "Cidade Abandonada" (tipo = 2).

### Obter detalhes importantes dos NPCs em uma sala específica
```sql
SELECT nomePersonagem, xp, vidaMax, vidaAtual 
FROM NPC 
WHERE Sala = 1;
```
Mostra detalhes dos NPCs localizados na sala com ID 1.

### Verificar a capacidade e o uso atual do inventário de um NPC específico
```sql
SELECT I.descricao, I.capacidade, SUM(II.quantidade) AS uso_atual
FROM Inventario I
JOIN InventarioItem II ON I.idInventario = II.idInventario
WHERE I.idInventario = (SELECT IdInventario FROM NPC WHERE idNPC = 2)
GROUP BY I.descricao, I.capacidade;
```
Mostra a capacidade e o uso atual do inventário do NPC com ID 2.

### Missões que utilizam um tipo específico de item
```sql
SELECT M.idMissao, M.tipoMis 
FROM Itens I
JOIN Missao M ON I.IdMissao = M.idMissao
WHERE I.IdItem = 3; -- Por exemplo, uma bomba
```
Lista as missões que utilizam o item com ID 3.

### Listar todas as zonas de quarentena e suas populações
```sql
SELECT ZQ.idRegiao, R.nomeRegiao, ZQ.populacaoAtual 
FROM ZonaQuarentena ZQ
JOIN Regiao R ON ZQ.IdRegiao = R.idRegiao;
```
Mostra todas as zonas de quarentena e suas populações atuais.

### Consultar todos os acampamentos com seu nível de defesa
```sql
SELECT A.IdRegiao, R.nomeRegiao, A.defesa 
FROM Acampamento A
JOIN Regiao R ON A.IdRegiao = R.idRegiao;
```
Lista os acampamentos e seus níveis de defesa.

### Encontrar todos os locais abandonados em regiões perigosas
```sql
SELECT LA.periculosidade, R.nomeRegiao 
FROM LocalAbandonado LA
JOIN Regiao R ON LA.IdRegiao = R.idRegiao
WHERE LA.periculosidade > 7;
```
Obtém locais abandonados em regiões com periculosidade acima de 7.

### Obter nome de todos os personagens que não são aliados
```sql
SELECT NPC.nomePersonagem
FROM NPC NPC
WHERE NPC.eAliado = false;
```
Lista todos os personagens que não são aliados.

### Listar todos os itens em um inventário específico
```sql
SELECT II.nomeItem, I.capacidade, I.descricao 
FROM Item II
JOIN Inventario I ON II.IdInventario = I.idInventario
WHERE I.idInventario = 1; -- 1 seria um inventário específico
```
Mostra todos os itens no inventário com ID 1.

### Consultar as regiões que possuem mais de um tipo de estrutura
```sql
SELECT R.nomeRegiao, COUNT(DISTINCT ZQ.IdRegiao) AS ZonasQuarentena, 
       COUNT(DISTINCT A.IdRegiao) AS Acampamentos, 
       COUNT(DISTINCT LA.IdRegiao) AS LocaisAbandonados
FROM Regiao R
LEFT JOIN ZonaQuarentena ZQ ON R.idRegiao = ZQ.IdRegiao
LEFT JOIN Acampamento A ON R.idRegiao = A.IdRegiao
LEFT JOIN LocalAbandonado LA ON R.idRegiao = LA.IdRegiao
GROUP BY R.nomeRegiao
HAVING COUNT(DISTINCT ZQ.IdRegiao) > 0 
   AND COUNT(DISTINCT A.IdRegiao) > 0 
   AND COUNT(DISTINCT LA.IdRegiao) > 0;
```
Lista regiões com mais de um tipo de estrutura: zonas de quarentena, acampamentos e locais abandonados.

### Encontrar as regiões com maior capacidade e listar suas zonas de quarentena e acampamentos
```sql
SELECT R.nomeRegiao, R.capacidade
FROM Regiao R
LEFT JOIN ZonaQuarentena ZQ ON R.idRegiao = ZQ.IdRegiao
LEFT JOIN Acampamento A ON R.idRegiao = A.IdRegiao
WHERE R.capacidade > 20;
```
Mostra regiões com capacidade maior que 20, junto com suas zonas de quarentena e acampamentos.

### Conta quantos NPCs existem no banco de dados
```sql
SELECT COUNT(*) AS totalNPCs 
FROM NPC;
```
Retorna a quantidade total de NPCs no banco de dados.

### Soma total de XP ganho em missões de patrulha
```sql
SELECT SUM(xpMis) AS xpTotalPatrulha 
FROM MissaoPatrulha;
```
Calcula a soma total de XP ganho em missões de patrulha.

### Soma total de XP ganho em missões de exploração/obter item
```sql
SELECT SUM(xpMis) AS xpTotalExploracao
FROM MissaoExploracaoObterItem;
```
Calcula a soma total de XP ganho em missões de exploração/obter item.

### Consulta que retorna todos os personagens com seus inventários associados
```sql
SELECT Personagem.nomePersonagem, Inventario.descricao
FROM Personagem
JOIN Inventario ON Personagem.idInventario = Inventario.idInventario;
```
Mostra todos os personagens e suas descrições de inventário.

### Consulta que retorna os NPCs que estão em uma sala
```sql
SELECT nomePersonagem 
FROM NPC 
WHERE Sala = {$idSala};
```
Lista os NPCs localizados na sala especificada por ID.

### Consulta que retorna quais NPCs estão na mesma sala que Joel
```sql
SELECT nomePersonagem 
FROM NPC 
WHERE Sala = (SELECT

 Sala FROM PC WHERE IdPersonagem = 1);
```
Obtém os NPCs que estão na mesma sala que Joel (ID 1).

### Retorna os itens que pode-se obter em uma missão de exploração
```sql
SELECT i.*
FROM Itens i
JOIN MissaoExploracaoObterItem m ON i.IdMissao = m.idMissao
JOIN Personagem p ON m.IdPersonagem = p.idPersonagem
JOIN PC pc ON p.idPersonagem = pc.IdPersonagem
WHERE pc.Sala = (
    SELECT Sala 
    FROM PC 
    WHERE IdPersonagem = ${id_personagem}
);
```
Mostra itens que podem ser obtidos em missões de exploração baseadas na sala atual do personagem.

### Retorna os itens que pode-se obter em uma missão de patrulha
```sql
SELECT i.*
FROM Itens i
JOIN MissaoPatrulha m ON i.IdMissao = m.idMissao
JOIN Personagem p ON m.IdPersonagem = p.idPersonagem
JOIN PC pc ON p.idPersonagem = pc.IdPersonagem
WHERE pc.Sala = (
    SELECT Sala 
    FROM PC 
    WHERE IdPersonagem = ${id_personagem}
);
```
Mostra itens que podem ser obtidos em missões de patrulha baseadas na sala atual do personagem.

### Consulta se a missão pré-requisito de obter item foi concluída
```sql
SELECT statusMissao
FROM MissaoExploracaoObterItem
WHERE IdMissao = (
    SELECT IdMissaoPre
    FROM MissaoExploracaoObterItem
    WHERE IdMissao = ${id_missao}
) AND statusMissao = 'true';
```
Verifica se a missão pré-requisito para a missão de obter item foi concluída.

### Consulta se a missão pré-requisito de patrulha foi concluída
```sql
SELECT statusMissao
FROM MissaoPatrulha
WHERE IdMissao = (
    SELECT IdMissaoPre
    FROM MissaoExploracaoObterItem
    WHERE IdMissao = ${id_missao}
) AND statusMissao = 'true';
```
Verifica se a missão pré-requisito para a missão de patrulha foi concluída.

## Atualizações

### Dá update na vida de um PC
```sql
UPDATE PC SET vidaAtual = $valor
WHERE IdPersonagem = ${id_personagem};
```
Atualiza o valor da vida atual do PC com o ID fornecido.

### Dá update na vida de um NPC
```sql
UPDATE NPC SET vidaAtual = $valor
WHERE IdPersonagem = ${id_personagem};
```
Atualiza o valor da vida atual do NPC com o ID fornecido.

### Dá update em um inventário
```sql
UPDATE Inventario SET capacidade = capacidade - 1
WHERE IdPersonagem = ${id_personagem} AND IdItem = ${id_item};
```
Reduz a capacidade do inventário do personagem especificado pelo ID e item.

### Dá update na missão patrulha falando que foi concluída
```sql
UPDATE MissaoPatrulha SET statusMissao = 'true'
WHERE idMissao = ${id_missao};
```
Marca a missão de patrulha como concluída.

### Dá update na missão de exploração/obter item falando que foi concluída
```sql
UPDATE MissaoExploracaoObterItem SET statusMissao = 'true'
WHERE idMissao = ${id_missao};
```
Marca a missão de exploração/obter item como concluída.

### Atualiza XP do jogador ao concluir missão de exploração
```sql
UPDATE PC SET xp = xp + (SELECT xpMis FROM MissaoExploracaoObterItem WHERE idMissao = ${id_missao})
WHERE IdPersonagem = ${idPersonagem};
```
Adiciona a XP da missão de exploração ao XP do personagem.

### Atualiza XP do jogador ao concluir missão de patrulha
```sql
UPDATE PC SET xp = xp + (SELECT xpMis FROM MissaoPatrulha WHERE idMissao = ${id_missao})
WHERE IdPersonagem = ${idPersonagem};
```
Adiciona a XP da missão de patrulha ao XP do personagem.

### Aumenta a vida de um personagem de acordo com o quanto de vida um consumível dá
```sql
UPDATE PC SET vidaAtual = vidaAtual + (SELECT aumentoVida FROM Consumivel WHERE IdItem = ${id_item})
WHERE IdPersonagem = ${idPersonagem};
```
Aumenta a vida atual do personagem com base na quantidade de vida fornecida pelo item consumível.


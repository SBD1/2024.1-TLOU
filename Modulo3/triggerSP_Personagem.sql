-- sp e trigger para inserir um personagem em uma tabela de PC ou NPC 1 = pc, 2 = npc
CREATE FUNCTION inserirEspecificoPersonagem() RETURNS trigger AS $$
BEGIN 
    -- verificacao se ja existe em alguma tabela das especificas 
    PERFORM * FROM PC WHERE NEW.IdPersonagem = PC.IdPersonagem;
    IF FOUND THEN
        RAISE EXCEPTION 'Este personagem já foi inserido na tabela PC';
    END IF;

    PERFORM * FROM NPC WHERE NEW.IdPersonagem = NPC.IdPersonagem;
    IF FOUND THEN
        RAISE EXCEPTION 'Este personagem já foi inserido na tabela NPC';
    END IF;

    IF (NEW.IdPersonagem IS NOT NULL AND NEW.Sala IS NOT NULL AND NEW.xp IS NOT NULL AND NEW.vidaMax IS NOT NULL AND 
    NEW.nomePersonagem IS NOT NULL NEW.estado IS NOT NULL AND NEW.Evolucao IS NOT NULL AND NEW.IdInventario IS NOT NULL 
    AND Personagem.tipo = 1) -- inserindo um pc
        INSERT INTO PC VALUES (NEW.idPersonagem, NEW.Sala, NEW.xp, NEW.vidaMax, NEW.vidaAtual, NEW.nomePersonagem, 
        NEW.estado, NEW.Evolucao, NEW.IdInventario);

    ELSE IF (NEW.IdPersonagem IS NOT NULL AND NEW.Sala IS NOT NULL AND NEW.xp IS NOT NULL AND NEW.vidaMax IS NOT NULL AND 
    NEW.nomePersonagem IS NOT NULL AND NEW.eAliado IS NOT NULL AND NEW.tipoNPC IS NOT NULL AND Personagem.tipo = 2) -- inserindo um npc
        INSERT INTO NPC VALUES (NEW.idPersonagem, NEW.Sala, NEW.xp, NEW.vidaMax, 
        NEW.vidaAtual, NEW.nomePersonagem, NEW.IdInventario, NEW.eAliado, NEW.tipoNPC);
    END IF;

    RETURN NEW;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER t_inserirPCouNPC 
BEFORE INSERT ON PC OR NPC 
FOR EACH ROW EXECUTE PROCEDURE inserirEspecificoPersonagem();

--------------------------------------------------------------------------------------------------------------------------------

-- sp e trigger para inserir um item em uma tabela especifica (arma, vestimenta ou consumivel), arma = 1, vestimeta = 2, consumivel = 3 
CREATE FUNCTION inserirEspecificoItem() RETURNS trigger AS $$
BEGIN 
    -- verificacao se ja existe em alguma tabela das especificas 
    PERFORM * FROM Arma WHERE NEW.IdItem = Arma.IdItem;
    IF FOUND THEN
        RAISE EXCEPTION 'Este item já foi inserido na tabela Arma';
    END IF;

    PERFORM * FROM Vestimenta WHERE NEW.IdItem = Vestimenta.IdItem;
    IF FOUND THEN
        RAISE EXCEPTION 'Este item já foi inserido na tabela Vestimenta';
    END IF;

    PERFORM * FROM Consumivel WHERE NEW.IdItem = Consumivel.IdItem;
    IF FOUND THEN
        RAISE EXCEPTION 'Este item já foi inserido na tabela Consumivel';
    END IF;

    IF (NEW.IdItem IS NOT NULL AND NEW.nomeItem IS NOT NULL AND NEW.dano IS NOT NULL AND NEW.municaoMax IS NOT NULL AND 
    NEW.eAtaque IS NOT NULL NEW.descricaoItem AND Item.tipo = 1) -- inserindo uma arma
        INSERT INTO Arma VALUES (NEW.IdItem, NEW.nomeItem, NEW.dano, NEW.municaoMax, NEW.municaoAtual, NEW.eAtaque, NEW.descricaoItem);
        
    ELSE IF (NEW.IdItem IS NOT NULL AND NEW.nomeItem IS NOT NULL NEW.eAtaque IS NOT NULL NEW.descricaoItem AND Item.tipo = 2) -- inserindo uma vestimenta
        INSERT INTO Vestimenta VALUES (NEW.IdItem, NEW.nomeItem, NEW.eAtaque, NEW.descricaoItem);

    ELSE IF (NEW.IdItem IS NOT NULL AND NEW.nomeItem IS NOT NULL AND NEW.tipoConsumivel IS NOT NULL AND 
    NEW.eAtaque IS NOT NULL NEW.descricaoItem AND Item.tipo = 3) -- inserindo um consumivel
        INSERT INTO Consumivel VALUES (NEW.IdItem, NEW.nomeItem, NEW.tipoConsumivel, NEW.aumentoVida, NEW.eAtaque, NEW.descricaoItem);
    END IF;

    RETURN NEW;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER t_inserirItemEspecifico
BEFORE INSERT ON Arma OR Vestimenta OR Consumivel
FOR EACH ROW EXECUTE PROCEDURE inserirEspecificoItem ();

--------------------------------------------------------------------------------------------------------------------------------
-- sp e trigger para inserir uma missao em uma tabela especifica, exploracao = 1, patrulha = 2
CREATE FUNCTION inserirEspecificoMissao() RETURNS trigger AS $$
BEGIN 
    -- verificacao se ja existe em alguma tabela das especificas 
    PERFORM * FROM MissaoExploracaoObterItem WHERE NEW.IdMissao = MissaoExploracaoObterItem.IdMissao;
    IF FOUND THEN
        RAISE EXCEPTION 'Esta missão já foi inserida na tabela Missão de Exploração/Obter item';
    END IF;

    PERFORM * FROM MissaoPatrulha WHERE NEW.IdMissao = MissaoPatrulha.IdMissao;
    IF FOUND THEN
        RAISE EXCEPTION 'Esta missão já foi inserida na tabela Missão Patrulha';
    END IF;

    IF (NEW.IdMissao IS NOT NULL AND NEW.objetivo IS NOT NULL AND NEW.nomeMis IS NOT NULL AND NEW.IdPersonagem IS NOT NULL AND 
    NEW.xpMis IS NOT NULL NEW.statusMissao IS NOT NULL AND NEW.Sala IS NOT NULL Missao.tipo = 1) -- inserindo uma missao exploracao
        INSERT INTO MissaoExploracaoObterItem VALUES (NEW.IdMissao, NEW.idMissaoPre, NEW.objetivo, NEW.nomeMis, NEW.IdPersonagem, NEW.xpMis, 
        NEW.statusMissao, NEW.Sala);

    IF (NEW.IdMissao IS NOT NULL AND NEW.objetivo IS NOT NULL AND NEW.nomeMis IS NOT NULL AND NEW.IdPersonagem IS NOT NULL AND 
    NEW.xpMis IS NOT NULL NEW.statusMissao IS NOT NULL AND NEW.Sala IS NOT NULL AND NEW.qtdNPCs IS NOT NULL AND Missao.tipo = 2) -- inserindo uma missao patrulha
        INSERT INTO MissaoPatrulha VALUES (NEW.IdMissao, NEW.idMissaoPre, NEW.objetivo, NEW.nomeMis, NEW.qtdNPCs, NEW.IdPersonagem, NEW.xpMis, 
        NEW.statusMissao, NEW.Sala);
    END IF;

    RETURN NEW;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER t_inserirMissaoEspecifica
BEFORE INSERT ON MissaoExploracaoObterItem OR MissaoPatrulha
FOR EACH ROW EXECUTE PROCEDURE inserirEspecificoMissao();

--------------------------------------------------------------------------------------------------------------------------------

-- Verifica se há espaço no inventário antes de inserir um item
CREATE FUNCTION verificarCapacidadeInventario() 
RETURNS trigger AS $$
DECLARE
    capacidadeAtual INTEGER;
BEGIN
    -- Verifica a capacidade atual do inventário
    SELECT capacidade INTO capacidadeAtual 
    FROM Inventario WHERE idInventario = NEW.IdInventario;

    -- Se a capacidade for maior que 0, permite adicionar o item
    IF capacidade_atual > 0 THEN
    
        -- Adiciona o item ao inventário
        UPDATE Inventario 
        SET capacidade = capacidade - 1 
        WHERE idInventario = NEW.IdInventario;
        RETURN NEW;
    ELSE 
        -- caso contrário impede a inserção do item
        RAISE EXCEPTION 'Seu inventário está cheio!';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger para adicionar itens ao inventário só se estiver espaço
-- Sp = verificarCapacidadeInventario()
CREATE TRIGGER t_verificarCapacidadeInventario
BEFORE UPDATE ON Inventario
FOR EACH ROW
EXECUTE FUNCTION verificarCapacidadeInventario();

--------------------------------------------------------------------------------------------------------------------------------

-- Atualiza a capacidade ao remover um item
CREATE FUNCTION atualizarCapacidadeInventario()
RETURNS trigger AS $$
BEGIN
    -- Atualiza a capacidade do inventário ao remover um item
    UPDATE Inventario 
    SET capacidade = capacidade + 1 
    WHERE idInventario = OLD.IdInventario;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Trigger para remover itens do inventário
-- Sp = atualizarCapacidadeInventario()
CREATE TRIGGER t_atualizarCapacidadeInventario
AFTER UPDATE ON Inventario
FOR EACH ROW
EXECUTE FUNCTION atualizarCapacidadeInventario();

--------------------------------------------------------------------------------------------------------------------------------

CREATE FUNCTION check_regiao() 
RETURNS trigger AS $$
BEGIN

    PERFORM * FROM Regiao WHERE NEW.idRegiao = Regiao.idRegiao;
    IF FOUND THEN
        RAISE EXCEPTION 'Esta Regiao já se encontra na tabela de regiões';
    END IF;

    IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL 
    AND Regiao.tipoRegiao = 1) -- inserindo uma Regiao   
    INSERT INTO Regiao VALUES (NEW.idRegiao, NEW.descricaoRegiao, NEW.nomeRegiao, NEW.capacidade, NEW.tipoRegiao);
        
    ELSE IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL 
    AND NEW.seguranca IS NOT NULL AND NEW.populacaoAtual IS NOT NULL AND Regiao.tipoRegiao = 2) -- inserindo uma ZonaQuarentena     
    INSERT INTO ZonaQuarentena VALUES (NEW.idRegiao, NEW.descricaoRegiao, NEW.nomeRegiao, NEW.capacidade, NEW.tipoRegiao, NEW.seguranca, NEW.populacaoAtual);

    ELSE IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL 
    AND NEW.defesa IS NOT NULL AND Regiao.tipoRegiao = 3) -- inserindo um acampamento
        INSERT INTO Acampamento VALUES (NEW.idRegiao, NEW.descricaoRegiao, NEW.nomeRegiao, NEW.capacidade, NEW.tipoRegiao, NEW.defesa);

    ELSE IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL 
    AND NEW.tipo IS NOT NULL AND NEW.periculosidade IS NOT NULL AND Regiao.tipoRegiao = 4) -- inserindo um local abandonado
        INSERT INTO LocalAbandonado VALUES (NEW.idRegiao, NEW.descricaoRegiao, NEW.nomeRegiao, NEW.capacidade, NEW.tipoRegiao, NEW.tipo, NEW.periculosidade)
    END IF;

    RETURN NEW; -- retorna a tupla para prosseguir com a operação se não tiver encontrado 
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER check_regiao
BEFORE UPDATE OR INSERT ON Regiao OR ZonaQuarentena OR Acampamento OR LocalAbandonado
FOR EACH ROW EXECUTE PROCEDURE check_regiao();
--------------------------------------------------------------------------------------------------------------------------------

-- Verifica se a 'vidaAtual', for maior do que 0 e menor que a 'vidaMax' do NPC
CREATE FUNCTION validarVidaNpc()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se a vida atual é maior que a vida máxima
    IF NEW.vidaAtual > NEW.vidaMax THEN
        RAISE EXCEPTION 'A vida atual não pode ser maior que a vida máxima.';
    END IF;
    
    -- Verifica se a vida atual é menor ou igual a zero
    IF NEW.vidaAtual <= 0 THEN
        RAISE EXCEPTION 'A vida atual deve ser maior que zero para o NPC estar vivo.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria a trigger que chama a função de validação da vida do NPC
-- Sp = validarVidaNpc
CREATE TRIGGER t_validarVidaNpc
BEFORE INSERT OR UPDATE ON NPC
FOR EACH ROW
EXECUTE FUNCTION validarVidaNpc();

--------------------------------------------------------------------------------------------------------------------------------

-- Remover o NPC quando a vida chegar a zero
CREATE FUNCTION npcMorreu()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se a vida atual é zero ou menor
    IF NEW.vidaAtual <= 0 THEN
        DELETE FROM NPC WHERE idNPC = NEW.idNPC;
        RETURN NULL; -- Interrompe a operação, pois o NPC foi removido
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para chamar a função de remoção do NPC
-- SP = npcMorreu()
CREATE TRIGGER t_npcMorreu
BEFORE UPDATE ON NPC
FOR EACH ROW
EXECUTE FUNCTION npcMorreu();

--------------------------------------------------------------------------------------------------------------------------------

-- Verifica se a 'vidaAtual', for maior do que 0 e menor que a 'vidaMax' do Joel
CREATE FUNCTION validarVidaJoel()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se a vida atual é maior que a vida máxima
    IF NEW.vidaAtual > NEW.vidaMax THEN
        RAISE EXCEPTION 'A vida atual não pode ser maior que a vida máxima.';
    END IF;
    
    -- Verifica se a vida atual é menor ou igual a zero
    IF NEW.vidaAtual <= 0 THEN
        RAISE EXCEPTION 'A vida atual deve ser maior que zero para o Joel estar vivo.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria a trigger que chama a função de validação da vida do Joel
-- Sp = validarVidaNpc
CREATE TRIGGER t_validarVidaJoel
BEFORE INSERT OR UPDATE ON PC
FOR EACH ROW
EXECUTE FUNCTION validarVidaJoel();

--------------------------------------------------------------------------------------------------------------------------------

-- Cria a função para atualizar a evolução do Joel, ao atingir um certo valor de XP
CREATEF FUNCTION atualizarEvolucao()
RETURNS TRIGGER AS $$
DECLARE
    novaEvolucao INT;
BEGIN
    -- Define a nova evolução baseada no XP
    SELECT idEvolucao INTO novaEvolucao
    FROM Evolucao
    WHERE xpEvol <= NEW.xp
    ORDER BY xpEvol DESC
    LIMIT 1;

    -- Atualiza a evolução do Joel
    UPDATE PC
    SET Evolucao = novaEvolucao
    WHERE IdPersonagem = NEW.IdPersonagem;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria a trigger para atualizar a evolução
-- SP = atualizarEvolucao()
CREATE TRIGGER t_atualizarEvolucao
AFTER UPDATE OF xp ON PC
FOR EACH ROW
WHEN (NEW.xp > OLD.xp)
EXECUTE FUNCTION atualizarEvolucao();

--------------------------------------------------------------------------------------------------------------------------------

LIGA DA JUSTIÇA ADAPTADO

CREATE FUNCTION consumir_item(id_p int, id_consumivel int) RETURNS void AS $$
DECLARE
  pontos_de_vida int;
  rowItems int;
  personagem RECORD;

BEGIN
  -- Verifica se o item consumível existe no inventário do personagem
  SELECT COUNT(*)
  INTO rowItems
  FROM InstItem ii
  JOIN Item i ON ii.IdItem = i.idItem
  JOIN Inventario inv ON inv.idInventario = ii.Sala
  WHERE inv.idInventario = (SELECT IdInventario FROM NPC WHERE IdPersonagem = id_p)
    AND i.idItem = id_consumivel;

  IF rowItems > 0 THEN
    -- Obtém o valor de vida concedido pelo item consumível
    SELECT i.tipoItem
    INTO pontos_de_vida
    FROM Item i
    WHERE i.idItem = id_consumivel;

    -- Obtém os atributos atuais do personagem
    SELECT * INTO personagem FROM NPC WHERE IdPersonagem = id_p;

    -- Atualiza os pontos de vida do personagem
    personagem.vidaAtual := personagem.vidaAtual + pontos_de_vida;

    -- Persiste as mudanças no banco de dados
    UPDATE NPC
    SET vidaAtual = personagem.vidaAtual
    WHERE IdPersonagem = id_p;

  ELSE
    RAISE NOTICE 'Nenhum item consumível encontrado';
  END IF;
END;
$$ LANGUAGE plpgsql;

--------

GPT DO DE CIMA

-- Consumir um item Consumível
CREATE FUNCTION consumirItem() 
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o item é do tipo Consumível
    IF EXISTS (SELECT 1 FROM Consumivel WHERE NEW.IdItem = Consumivel.IdItem) THEN
        -- Atualiza a vida do personagem
        UPDATE Personagem 
        SET vidaAtual = vidaAtual + (SELECT aumentoVida FROM Consumivel WHERE IdItem = NEW.IdItem)
        WHERE IdPersonagem = NEW.IdPersonagem;

        -- Remove o item do inventário
        DELETE FROM InstItem 
        WHERE IdItem = NEW.IdItem AND IdInventario = NEW.IdInventario;
    ELSE
        RAISE EXCEPTION 'Item não é do tipo Consumível';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria a trigger para Consumir um item Consumível
-- SP = consumirItem()
CREATE TRIGGER t_consumirItem
AFTER UPDATE ON InstItem
FOR EACH ROW
EXECUTE FUNCTION consumirItem();


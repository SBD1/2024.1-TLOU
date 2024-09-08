
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
    SELECT * INTO personagem FROM PC WHERE IdPersonagem = id_p;

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


-- Consumir um item Consumível
CREATE FUNCTION consumirItem() 
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o item é do tipo Consumível
    IF EXISTS (SELECT 1 FROM Consumivel WHERE NEW.IdItem = Consumivel.IdItem) THEN
        -- Atualiza a vida do personagem
        UPDATE PC 
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


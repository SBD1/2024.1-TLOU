--Remove todas as triggers e funções existentes
 DROP TRIGGER IF EXISTS t_verificarCapacidadeInventario ON Inventario;
 DROP FUNCTION IF EXISTS verificarCapacidadeInventario();

 DROP TRIGGER IF EXISTS t_atualizarCapacidadeInventario ON Inventario;
 DROP FUNCTION IF EXISTS atualizarCapacidadeInventario();

 DROP TRIGGER IF EXISTS t_validarVidaNpc ON NPC;
 DROP FUNCTION IF EXISTS validarVidaNpc();

 DROP TRIGGER IF EXISTS t_npcMorreu ON NPC;
 DROP FUNCTION IF EXISTS npcMorreu();

 DROP TRIGGER IF EXISTS t_validarVidaJoel ON PC;
 DROP FUNCTION IF EXISTS validarVidaJoel();

 DROP TRIGGER IF EXISTS t_atualizarEvolucao ON PC;
 DROP FUNCTION IF EXISTS atualizarEvolucao();

 DROP TRIGGER IF EXISTS check_Animal ON Animal;
 DROP FUNCTION IF EXISTS check_Animal();

 DROP TRIGGER IF EXISTS check_Arma ON Arma;
 DROP FUNCTION IF EXISTS check_Arma();

 DROP TRIGGER IF EXISTS check_Consumivel ON Consumivel;
 DROP FUNCTION IF EXISTS check_Consumivel();

 DROP TRIGGER IF EXISTS check_Exploracao ON MissaoExploracaoObterItem;
 DROP FUNCTION IF EXISTS check_Exploracao();

 DROP TRIGGER IF EXISTS check_FaccaoHumana ON FaccaoHumana;
 DROP FUNCTION IF EXISTS check_FaccaoHumana();

 DROP TRIGGER IF EXISTS check_Infectado ON Infectado;
 DROP FUNCTION IF EXISTS check_Infectado();

 DROP TRIGGER IF EXISTS check_Item ON Item;
 DROP FUNCTION IF EXISTS check_Item();

 DROP TRIGGER IF EXISTS check_Missao ON Missao;
 DROP FUNCTION IF EXISTS check_Missao();

 DROP TRIGGER IF EXISTS check_NPC ON NPC;
 DROP FUNCTION IF EXISTS check_NPC();

 DROP TRIGGER IF EXISTS check_Patrulha ON MissaoPatrulha;
 DROP FUNCTION IF EXISTS check_Patrulha();

 DROP TRIGGER IF EXISTS check_PC ON PC;
 DROP FUNCTION IF EXISTS check_PC();

 DROP TRIGGER IF EXISTS check_Personagem ON Personagem;
 DROP FUNCTION IF EXISTS check_Personagem();

 DROP TRIGGER IF EXISTS check_Regiao ON Regiao;
 DROP FUNCTION IF EXISTS check_Regiao();

--Verifica se há espaço no inventário antes de inserir um item
CREATE FUNCTION verificarCapacidadeInventario() 
RETURNS trigger AS $$
DECLARE
    capacidadeAtual INTEGER;
BEGIN
    -- Verifica a capacidade atual do inventário
    SELECT capacidade INTO capacidadeAtual 
    FROM Inventario WHERE idInventario = NEW.IdInventario;

    -- Se a capacidade for maior que 0, permite adicionar o item
    IF capacidadeAtual > 0 THEN
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
BEFORE INSERT ON NPC
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

--------------------------------------------------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS check_Animal ON Animal;
DROP FUNCTION IF EXISTS check_Animal();

CREATE OR REPLACE FUNCTION check_Animal() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM Infectado WHERE IdNPC = NEW.IdNPC) THEN
        RAISE EXCEPTION 'Esse NPC já existe na tabela Infectado e não pode ser inserido em Animal!';
    END IF;

    IF EXISTS (SELECT 1 FROM FaccaoHumana WHERE IdNPC = NEW.IdNPC) THEN
        RAISE EXCEPTION 'Esse NPC já existe na tabela Faccao Humana e não pode ser inserido em Animal!';
    END IF;
    
    IF (SELECT tipoNPC FROM NPC WHERE idPersonagem = NEW.IdNPC) <> 'A' THEN
        RAISE EXCEPTION 'O NPC deve ter o tipo ''A'' para ser inserido em Animal!'; 
    END IF;
    
    IF (NEW.IdNPC IS NOT NULL AND NEW.nomeAnimal IS NOT NULL AND NEW.ameaca IS NOT NULL) THEN       
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_Animal
BEFORE INSERT ON Animal
FOR EACH ROW EXECUTE FUNCTION check_Animal();

--------------------------------------------
DROP TRIGGER IF EXISTS check_Arma ON Arma;
DROP FUNCTION IF EXISTS check_Arma();

CREATE OR REPLACE FUNCTION check_Arma() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM Vestimenta WHERE IdItem = NEW.IdItem) THEN
        RAISE EXCEPTION 'Esse item já existe na tabela Vestimenta e não pode ser inserido em Arma!';
    END IF;

    IF EXISTS (SELECT 1 FROM Consumivel WHERE IdItem = NEW.IdItem) THEN
        RAISE EXCEPTION 'Essa item já existe na tabela Consumível e não pode ser inserido em Arma!';
    END IF;
    
    IF (SELECT tipoItem FROM Item WHERE IdItem = NEW.IdItem) <> 'A' THEN
        RAISE EXCEPTION 'O item deve ter o tipo ''A'' para ser inserida em Arma!'; 
    END IF;

    
    IF (NEW.IdItem IS NOT NULL AND NEW.nomeItem IS NOT NULL AND NEW.dano IS NOT NULL AND NEW.municaoMax IS NOT NULL AND NEW.eAtaque IS NOT NULL
    AND NEW.descricaoItem) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Os atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_Arma
BEFORE INSERT ON Arma
FOR EACH ROW EXECUTE FUNCTION check_Arma();

------------ 
DROP TRIGGER IF EXISTS check_Consumivel ON Consumivel;
DROP FUNCTION IF EXISTS check_Consumivel();

CREATE OR REPLACE FUNCTION check_Consumivel() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM Arma WHERE IdItem = NEW.IdItem) THEN
        RAISE EXCEPTION 'Esse item já existe na tabela Arma e não pode ser inserido em Consumivel!';
    END IF;

    IF EXISTS (SELECT 1 FROM Vestimenta WHERE IdItem = NEW.IdItem) THEN
        RAISE EXCEPTION 'Essa item já existe na tabela Vestimenta e não pode ser inserido em Consumivel!';
    END IF;
    
    IF (SELECT tipoItem FROM Item WHERE IdItem = NEW.IdItem) <> 'C' THEN
        RAISE EXCEPTION 'O item deve ter o tipo ''C'' para ser inserida em Consumivel!'; 
    END IF;

    IF (NEW.IdItem IS NOT NULL AND NEW.nomeItem IS NOT NULL AND NEW.tipoConsumivel IS NOT NULL AND NEW.aumentoVida IS NOT NULL 
    AND NEW.eAtaque IS NOT NULL AND NEW.descricaoItem IS NOT NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_Consumivel
BEFORE INSERT ON Consumivel
FOR EACH ROW EXECUTE FUNCTION check_Consumivel();
----------------
DROP TRIGGER IF EXISTS check_Exploracao ON MissaoExploracaoObterItem;
DROP FUNCTION IF EXISTS check_Exploracao();

CREATE OR REPLACE FUNCTION check_Exploracao() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM MissaoPatrulha WHERE idMissao = NEW.idMissao) THEN
        RAISE EXCEPTION 'Essa missão já existe na tabela Missão Patrulha e não pode ser inserido em Exploração!';
    END IF;
    
    IF (SELECT tipoMis FROM Missao WHERE idMissao = NEW.idMissao) <> 'E' THEN
        RAISE EXCEPTION 'A missão deve ter o tipo ''E'' para ser inserida em Exploração!'; 
    END IF;
    
    IF (NEW.IdMissao IS NOT NULL AND NEW.objetivo IS NOT NULL AND NEW.nomeMis IS NOT NULL AND NEW.IdPersonagem IS NOT NULL AND NEW.xpMis IS NOT NULL
     AND NEW.statusMissao IS NOT NULL AND NEW.Sala IS NOT NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Os atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_Exploracao
BEFORE INSERT ON MissaoExploracaoObterItem
FOR EACH ROW EXECUTE FUNCTION check_Exploracao();

--------------------------
DROP TRIGGER IF EXISTS check_FaccaoHumana ON FaccaoHumana;
DROP FUNCTION IF EXISTS check_FaccaoHumana();

CREATE OR REPLACE FUNCTION check_FaccaoHumana() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM Infectado WHERE IdNPC = NEW.IdNPC) THEN
        RAISE EXCEPTION 'Esse NPC já existe na tabela Infectado e não pode ser inserido em Faccao Humana!';
    END IF;

    IF EXISTS (SELECT 1 FROM Animal WHERE IdNPC = NEW.IdNPC) THEN
        RAISE EXCEPTION 'Esse NPC já existe na tabela Animal e não pode ser inserido em Faccao Humana!';
    END IF;
    
    IF (SELECT tipoNPC FROM NPC WHERE idPersonagem = NEW.IdNPC) <> 'F' THEN
        RAISE EXCEPTION 'O NPC deve ter o tipo ''F'' para ser inserido em FaccaoHumana!'; 
    END IF;
    
    IF (NEW.IdNPC IS NOT NULL AND NEW.nomeFaccao IS NOT NULL) THEN       
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_FaccaoHumana
BEFORE INSERT ON FaccaoHumana
FOR EACH ROW EXECUTE FUNCTION check_FaccaoHumana();

---------------------------------
DROP TRIGGER IF EXISTS check_Infectado ON Infectado;
DROP FUNCTION IF EXISTS check_Infectado();

CREATE OR REPLACE FUNCTION check_Infectado() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM FaccaoHumana WHERE IdNPC = NEW.IdNPC) THEN
        RAISE EXCEPTION 'Esse NPC já existe na tabela Faccao Humana e não pode ser inserido em Infectado!';
    END IF;

    IF EXISTS (SELECT 1 FROM Animal WHERE IdNPC = NEW.IdNPC) THEN
        RAISE EXCEPTION 'Esse NPC já existe na tabela Animal e não pode ser inserido em Infectado!';
    END IF;
    
    IF (SELECT tipoNPC FROM NPC WHERE idPersonagem = NEW.IdNPC) <> 'I' THEN
        RAISE EXCEPTION 'O NPC deve ter o tipo ''I'' para ser inserido em Infectado!'; 
    END IF;
    
    IF (NEW.IdNPC IS NOT NULL AND NEW.comportamentoInfec IS NOT NULL AND NEW.velocidade IS NOT NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_Infectado
BEFORE INSERT ON Infectado
FOR EACH ROW EXECUTE FUNCTION check_Infectado();

------------------------------
DROP TRIGGER IF EXISTS check_Item ON Item;
DROP FUNCTION IF EXISTS check_Item();

-- garante integridade na inserção da tabela item, tipo só podendo ser A, V ou C

CREATE OR REPLACE FUNCTION check_Item() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM Item WHERE idItem = NEW.idItem) THEN
        RAISE EXCEPTION 'Esse Item já existe na base de dados!';
    END IF;

    IF (NEW.idItem IS NOT NULL AND NEW.tipoItem = 'A' OR  NEW.tipoItem = 'V' OR  NEW.tipoItem = 'C') THEN       
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Atributos obrigatórios devem ser preenchidos e tipo do 
        Item deve ser A (Arma) ou V (Vestimenta) ou C (Consumível)!';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_Item
BEFORE INSERT ON Item
FOR EACH ROW EXECUTE FUNCTION check_Item();

-------------------------------------------------
DROP TRIGGER IF EXISTS check_Missao ON Missao;
DROP FUNCTION IF EXISTS check_Missao();

-- garante integridade na inserção da tabela Missao, tipo só podendo ser E ou P

CREATE OR REPLACE FUNCTION check_Missao() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM Missao WHERE idMissao = NEW.idMissao) THEN
        RAISE EXCEPTION 'Essa Missao já existe na base de dados!';
    END IF;

    IF (NEW.idMissao IS NOT NULL AND NEW.tipoMis = 'P' OR  NEW.tipoMis = 'E') THEN       
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Atributos obrigatórios devem ser preenchidos e tipo do 
        Missao deve ser P (Patrulha) ou E (Exploração/ObterItem)!';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_Missao
BEFORE INSERT ON Missao
FOR EACH ROW EXECUTE FUNCTION check_Missao();

------------------------------------------
DROP TRIGGER IF EXISTS check_NPC ON NPC;
DROP FUNCTION IF EXISTS check_NPC();


CREATE FUNCTION check_NPC() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM PC WHERE idPersonagem = NEW.idPersonagem) THEN
        RAISE EXCEPTION 'Esse personagem já existe na tabela PC e não pode ser inserido em NPC!';
    END IF;

   
    IF (SELECT tipoPersonagem FROM Personagem WHERE idPersonagem = NEW.idPersonagem) <> 'N' THEN
        RAISE EXCEPTION 'O personagem deve ter o tipo ''N'' para ser inserida em NPC!'; 
    END IF;

    
    IF (NEW.IdPersonagem IS NOT NULL AND NEW.Sala IS NOT NULL AND NEW.xp IS NOT NULL AND NEW.vidaMax IS NOT NULL AND NEW.nomePersonagem IS NOT NULL
     AND NEW.eAliado IS NOT NULL AND NEW.tipoNPC IS NOT NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Os atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_NPC
BEFORE INSERT ON NPC
FOR EACH ROW EXECUTE FUNCTION check_NPC();

---------------------------------------------------------
DROP TRIGGER IF EXISTS check_Patrulha ON MissaoPatrulha;
DROP FUNCTION IF EXISTS check_Patrulha();

CREATE OR REPLACE FUNCTION check_Patrulha() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM MissaoExploracaoObterItem WHERE idMissao = NEW.idMissao) THEN
        RAISE EXCEPTION 'Essa missão já existe na tabela Missão de Exploração e não pode ser inserido em Patrulha!';
    END IF;
    
    IF (SELECT tipoMis FROM Missao WHERE idMissao = NEW.idMissao) <> 'P' THEN
        RAISE EXCEPTION 'A missão deve ter o tipo ''P'' para ser inserida em Patrulha!'; 
    END IF;
    
    IF (NEW.IdMissao IS NOT NULL AND NEW.objetivo IS NOT NULL AND NEW.nomeMis IS NOT NULL AND NEW.qtdNPCs IS NOT NULL AND NEW.IdPersonagem IS NOT NULL
     AND NEW.xpMis IS NOT NULL AND NEW.statusMissao IS NOT NULL  AND NEW.Sala IS NOT NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Os atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_Patrulha
BEFORE INSERT ON MissaoPatrulha
FOR EACH ROW EXECUTE FUNCTION check_Patrulha();

----------------------------------------------------------------DROP TRIGGER IF EXISTS check_PC ON PC;
DROP FUNCTION IF EXISTS check_PC();

CREATE OR REPLACE FUNCTION check_PC() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM NPC WHERE idPersonagem = NEW.idPersonagem) THEN
        RAISE EXCEPTION 'Esse personagem já existe na tabela NPC e não pode ser inserido em PC!';
    END IF;

   
    IF (SELECT tipoPersonagem FROM Personagem WHERE idPersonagem = NEW.idPersonagem) <> 'P' THEN
        RAISE EXCEPTION 'O personagem deve ter o tipo ''P'' para ser inserida em PC!'; 
    END IF;
    
    IF (NEW.IdPersonagem IS NOT NULL AND NEW.Sala IS NOT NULL AND NEW.xp IS NOT NULL AND NEW.vidaMax IS NOT NULL AND NEW.nomePersonagem IS NOT NULL
     AND NEW.estado IS NOT NULL AND NEW.Evolucao IS NOT NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Os atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_PC
BEFORE INSERT ON PC
FOR EACH ROW EXECUTE FUNCTION check_PC();

-----------------------------------------------
DROP TRIGGER IF EXISTS check_Personagem ON Personagem;
DROP FUNCTION IF EXISTS check_Personagem();

-- garante integridade na inserção da tabela personagem, tipo só podendo ser N ou P

CREATE OR REPLACE FUNCTION check_Personagem() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM Personagem WHERE idPersonagem = NEW.idPersonagem) THEN
        RAISE EXCEPTION 'Esse personagem já existe na base de dados!';
    END IF;

    IF (NEW.idPersonagem IS NOT NULL AND NEW.tipoPersonagem = 'P' OR  NEW.tipoPersonagem = 'N') THEN       
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Atributos obrigatórios devem ser preenchidos e tipo do 
        personagem deve ser P (PC) ou N (NPC)!';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_Personagem
BEFORE INSERT ON Personagem
FOR EACH ROW EXECUTE FUNCTION check_Personagem();

---------------------------------------------
-- Remova triggers existentes, caso existam
DROP TRIGGER IF EXISTS check_Regiao ON Regiao;

-- Função de trigger
CREATE OR REPLACE FUNCTION check_Regiao() RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL 
    AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL AND NEW.tipoRegiao = 'R') THEN
        RETURN NEW;
    ELSE 
        RAISE EXCEPTION 'Preencha os atributos obrigatórios!';
    END IF;
    
    IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL 
    AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL AND 
    NEW.tipoRegiao = 'Z' AND NEW.z_seguranca IS NOT NULL) THEN
        RETURN NEW; 
    ELSE 
        RAISE EXCEPTION 'Preencha os atributos obrigatórios!';
    END IF;

    IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL 
    AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL 
    AND NEW.tipoRegiao = 'A' AND NEW.a_defesa IS NOT NULL) THEN
        RETURN NEW;
    ELSE 
        RAISE EXCEPTION 'Preencha os atributos obrigatórios!';
    END IF;

    IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL 
    AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL AND NEW.tipoRegiao = 'L'
     AND NEW.l_periculosidade IS NOT NULL AND NEW.l_tipo IS NOT NULL)THEN
        RETURN NEW;
    ELSE 
        RAISE EXCEPTION 'Preencha os atributos obrigatórios!';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger para a tabela Regiao
CREATE TRIGGER check_Regiao
AFTER INSERT ON Regiao
FOR EACH ROW
EXECUTE PROCEDURE check_Regiao();

---------------------------------------------
DROP TRIGGER IF EXISTS check_Vestimenta ON Vestimenta;
DROP FUNCTION IF EXISTS check_Vestimenta();

CREATE OR REPLACE FUNCTION check_Vestimenta() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM Arma WHERE IdItem = NEW.IdItem) THEN
        RAISE EXCEPTION 'Esse item já existe na tabela Arma e não pode ser inserido em Vestimenta!';
    END IF;

    IF EXISTS (SELECT 1 FROM Consumivel WHERE IdItem = NEW.IdItem) THEN
        RAISE EXCEPTION 'Essa item já existe na tabela Consumível e não pode ser inserido em Vestimenta!';
    END IF;
    
    IF (SELECT tipoItem FROM Item WHERE IdItem = NEW.IdItem) <> 'V' THEN
        RAISE EXCEPTION 'O item deve ter o tipo ''V'' para ser inserida em Vestimenta!'; 
    END IF;

    -- idRegiao, descricaoRegiao, nomeRegiao, capacidade, tipoRegiao
    IF (NEW.IdItem IS NOT NULL AND NEW.nomeItem IS NOT NULL AND NEW.descricaoItem IS NOT NULL AND NEW.eAtaque AND NEW.defesa) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_Vestimenta
BEFORE INSERT ON Vestimenta
FOR EACH ROW EXECUTE FUNCTION check_Vestimenta();
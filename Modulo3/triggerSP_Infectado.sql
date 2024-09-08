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
BEFORE INSERT OR UPDATE ON Infectado
FOR EACH ROW EXECUTE FUNCTION check_Infectado();

------------ teste 
--INSERT INTO Personagem VALUES (25, 'N');

--INSERT INTO NPC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, eAliado, tipoNPC) 
--VALUES (25, 2, 10, 30, 30, 'Insetos', NULL, false, 'A');

--INSERT INTO Infectado (IdNPC, comportamentoInfec, velocidade) VALUES
--(25, 'Doido', 12);
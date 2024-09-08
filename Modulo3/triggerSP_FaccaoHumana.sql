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
BEFORE INSERT OR UPDATE ON FaccaoHumana
FOR EACH ROW EXECUTE FUNCTION check_FaccaoHumana();

------------ teste 
--INSERT INTO Personagem VALUES (26, 'N');

--INSERT INTO NPC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, eAliado, tipoNPC) 
--VALUES (26, 2, 10, 30, 30, 'Insetos', NULL, false, 'F');

--INSERT INTO FaccaoHumana (IdNPC, nomeFaccao) VALUES
--(26, 'JuliAna');

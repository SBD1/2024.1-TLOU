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
BEFORE INSERT OR UPDATE ON Animal
FOR EACH ROW EXECUTE FUNCTION check_Animal();

------------ teste 
INSERT INTO Personagem VALUES (29, 'N');

INSERT INTO NPC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, eAliado, tipoNPC) 
VALUES (29, 2, 10, 30, 30, 'Insetos', NULL, false, 'H');

INSERT INTO Animal (IdNPC, nomeAnimal, ameaca) VALUES
(29, 'JuliAna', 12);

DROP TRIGGER IF EXISTS check_PC ON PC;
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
BEFORE INSERT OR UPDATE ON PC
FOR EACH ROW EXECUTE FUNCTION check_PC();

------------ teste 
INSERT INTO Personagem (idPersonagem, tipoPersonagem) VALUES (30, 'n');

INSERT INTO PC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, estado, Evolucao, IdInventario)
VALUES (30, 1, 100, 100, NULL, 'Test PC', 'sem twitter:(', 2, 3);

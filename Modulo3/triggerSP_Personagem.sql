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
BEFORE INSERT OR UPDATE ON Personagem
FOR EACH ROW EXECUTE FUNCTION check_Personagem();

------------ teste 
INSERT INTO Personagem VALUES (23, 'N');
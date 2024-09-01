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
BEFORE INSERT OR UPDATE ON Consumivel
FOR EACH ROW EXECUTE FUNCTION check_Consumivel();

------------ teste 
INSERT INTO Item (idItem, tipoItem) VALUES (26, 'A');

INSERT INTO Consumivel (IdItem, nomeItem, tipoConsumivel, aumentoVida, eAtaque, descricaoItem) VALUES
(26, 'Celular', 'Negócio tecnológico', 23,'true', 'Usa')
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
BEFORE INSERT OR UPDATE ON Item
FOR EACH ROW EXECUTE FUNCTION check_Item();

------------ teste 
INSERT INTO Item VALUES (24, 'A');
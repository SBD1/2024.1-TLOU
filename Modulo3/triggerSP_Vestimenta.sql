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
BEFORE INSERT OR UPDATE ON Vestimenta
FOR EACH ROW EXECUTE FUNCTION check_Vestimenta();

------------ teste 
INSERT INTO Item (idItem, tipoItem) VALUES (27, 'A');

INSERT INTO Regiao (idRegiao, descricaoRegiao, nomeRegiao, capacidade, tipoRegiao) VALUES
(27, 'Escudo de Aço', 'Escudo improvisado para defesa contra ataques.', 'true')(27, 'Escudo de Aço', 'Escudo improvisado para defesa contra ataques.', 'true')
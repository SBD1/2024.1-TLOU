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
BEFORE INSERT OR UPDATE ON Arma
FOR EACH ROW EXECUTE FUNCTION check_Arma();

------------ teste 
INSERT INTO Item (idItem, tipoItem) VALUES (26, 'V');

INSERT INTO Arma (IdItem, nomeItem, dano, municaoAtual, municaoMax, eAtaque, descricaoItem)
VALUES (26, 'Faca2Mona', 20, NULL, 10, true, 'Afiada e versátil para combate corpo a corpoGATAH.');

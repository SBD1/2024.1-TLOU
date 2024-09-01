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
BEFORE INSERT OR UPDATE ON Missao
FOR EACH ROW EXECUTE FUNCTION check_Missao();

------------ teste 
INSERT INTO Missao VALUES (14, 'E');
DROP TRIGGER IF EXISTS check_Patrulha ON MissaoPatrulha;
DROP FUNCTION IF EXISTS check_Patrulha();

CREATE OR REPLACE FUNCTION check_Patrulha() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM MissaoExploracaoObterItem WHERE idMissao = NEW.idMissao) THEN
        RAISE EXCEPTION 'Essa missão já existe na tabela Missão de Exploração e não pode ser inserido em Patrulha!';
    END IF;
    
    IF (SELECT tipoMis FROM Missao WHERE idMissao = NEW.idMissao) <> 'P' THEN
        RAISE EXCEPTION 'A missão deve ter o tipo ''P'' para ser inserida em Patrulha!'; 
    END IF;
    
    IF (NEW.IdMissao IS NOT NULL AND NEW.objetivo IS NOT NULL AND NEW.nomeMis IS NOT NULL AND NEW.qtdNPCs IS NOT NULL AND NEW.IdPersonagem IS NOT NULL
     AND NEW.xpMis IS NOT NULL AND NEW.statusMissao IS NOT NULL  AND NEW.Sala IS NOT NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Os atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_Patrulha
BEFORE INSERT OR UPDATE ON MissaoPatrulha
FOR EACH ROW EXECUTE FUNCTION check_Patrulha();

------------ teste 
--INSERT INTO Missao (idMissao, tipoMis) VALUES (18, 'P');

--INSERT INTO MissaoPatrulha (IdMissao, idMissaoPre, objetivo, nomeMis, qtdNPCs, IdPersonagem, xpMis, statusMissao, Sala)
--VALUES (18, 13, 'Nao se matar hoje', 'Sobrevivencia', 2, 10, 30, 'false', 2);

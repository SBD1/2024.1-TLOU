DROP TRIGGER IF EXISTS check_Exploracao ON MissaoExploracaoObterItem;
DROP FUNCTION IF EXISTS check_Exploracao();

CREATE OR REPLACE FUNCTION check_Exploracao() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM MissaoPatrulha WHERE idMissao = NEW.idMissao) THEN
        RAISE EXCEPTION 'Essa missão já existe na tabela Missão Patrulha e não pode ser inserido em Exploração!';
    END IF;
    
    IF (SELECT tipoMis FROM Missao WHERE idMissao = NEW.idMissao) <> 'E' THEN
        RAISE EXCEPTION 'A missão deve ter o tipo ''E'' para ser inserida em Exploração!'; 
    END IF;
    
    IF (NEW.IdMissao IS NOT NULL AND NEW.objetivo IS NOT NULL AND NEW.nomeMis IS NOT NULL AND NEW.IdPersonagem IS NOT NULL AND NEW.xpMis IS NOT NULL
     AND NEW.statusMissao IS NOT NULL AND NEW.Sala IS NOT NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Os atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_Exploracao
BEFORE INSERT OR UPDATE ON MissaoExploracaoObterItem
FOR EACH ROW EXECUTE FUNCTION check_Exploracao();

------------ teste 
INSERT INTO Missao (idMissao, tipoMis) VALUES (16, 'E');

INSERT INTO MissaoExploracaoObterItem (IdMissao, idMissaoPre, objetivo, nomeMis, IdPersonagem, xpMis, statusMissao, Sala)
VALUES (16, 13, 'Nao se matar hoje', 'Sobrevivencia', 2, 34, 'false' , 2);

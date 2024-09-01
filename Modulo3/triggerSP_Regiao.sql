-- Remova triggers existentes, caso existam
DROP TRIGGER IF EXISTS check_Regiao_ZQ ON ZonaQuarentena;
DROP TRIGGER IF EXISTS check_Regiao_A ON Acampamento;
DROP TRIGGER IF EXISTS check_Regiao_LA ON LocalAbandonado;
DROP TRIGGER IF EXISTS check_Regiao ON Regiao;

-- Função de trigger
CREATE OR REPLACE FUNCTION check_Regiao() RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL 
    AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL AND NEW.tipoRegiao = 'R') THEN
        RETURN NEW;
    ELSE 
        RAISE EXCEPTION 'Preencha os atributos obrigatórios!';
    END IF;
    
    IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL 
    AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL AND 
    NEW.tipoRegiao = 'Z' AND NEW.z_seguranca IS NOT NULL) THEN
        RETURN NEW; 
    ELSE 
        RAISE EXCEPTION 'Preencha os atributos obrigatórios!';
    END IF;

    IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL 
    AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL 
    AND NEW.tipoRegiao = 'A' AND NEW.a_defesa IS NOT NULL) THEN
        RETURN NEW;
    ELSE 
        RAISE EXCEPTION 'Preencha os atributos obrigatórios!';
    END IF;

    IF (NEW.idRegiao IS NOT NULL AND NEW.descricaoRegiao IS NOT NULL 
    AND NEW.nomeRegiao IS NOT NULL AND NEW.capacidade IS NOT NULL AND NEW.tipoRegiao = 'L'
     AND NEW.l_periculosidade IS NOT NULL AND NEW.l_tipo IS NOT NULL)THEN
        RETURN NEW;
    ELSE 
        RAISE EXCEPTION 'Preencha os atributos obrigatórios!';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger para a tabela Regiao
CREATE TRIGGER check_Regiao
AFTER INSERT ON Regiao
FOR EACH ROW
EXECUTE PROCEDURE check_Regiao();

CREATE TRIGGER check_Regiao_ZQ
BEFORE INSERT OR UPDATE ON ZonaQuarentena
FOR EACH ROW
EXECUTE PROCEDURE check_Regiao();

CREATE TRIGGER check_Regiao_A
BEFORE INSERT OR UPDATE ON Acampamento
FOR EACH ROW
EXECUTE PROCEDURE check_Regiao();

CREATE TRIGGER check_Regiao_LA
BEFORE INSERT OR UPDATE ON LocalAbandonado
FOR EACH ROW
EXECUTE PROCEDURE check_Regiao();

-----testes 

INSERT INTO Regiao (idRegiao, descricaoRegiao, nomeRegiao, capacidade, tipoRegiao, z_seguranca, z_populacaoAtual, a_defesa, l_tipo, l_periculosidade)
VALUES
(7, 'Nova Zona de Quarentena', 'Zona Nova', 30, 'Z', 8, 500, NULL, NULL, NULL);

INSERT INTO Regiao (idRegiao, descricaoRegiao, nomeRegiao, capacidade, tipoRegiao, z_seguranca, z_populacaoAtual, a_defesa, l_tipo, l_periculosidade)
VALUES
(8, 'Novo Acampamento', 'Acampamento Novo', 50, 'A', NULL, NULL, 15, NULL, NULL);

INSERT INTO Regiao (idRegiao, descricaoRegiao, nomeRegiao, capacidade, tipoRegiao, z_seguranca, z_populacaoAtual, a_defesa, l_tipo, l_periculosidade)
VALUES
(9, 'Novo Local Abandonado', 'Local Abandonado Novo', 20, 'L', NULL, NULL, NULL, 'Cidade Fantasma', 7);

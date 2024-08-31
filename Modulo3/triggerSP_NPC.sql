DROP TRIGGER IF EXISTS check_NPC ON NPC;
DROP FUNCTION IF EXISTS check_NPC();


CREATE FUNCTION check_NPC() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM PC WHERE idPersonagem = NEW.idPersonagem) THEN
        RAISE EXCEPTION 'Esse personagem já existe na tabela PC e não pode ser inserido em NPC!';
    END IF;

   
    IF (SELECT tipoPersonagem FROM Personagem WHERE idPersonagem = NEW.idPersonagem) <> 'N' THEN
        RAISE EXCEPTION 'O personagem deve ter o tipo ''N'' para ser inserida em NPC!'; 
    END IF;

    
    IF (NEW.IdPersonagem IS NOT NULL AND NEW.Sala IS NOT NULL AND NEW.xp IS NOT NULL AND NEW.vidaMax IS NOT NULL AND NEW.nomePersonagem IS NOT NULL
     AND NEW.eAliado IS NOT NULL AND NEW.tipoNPC IS NOT NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Os atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_NPC
BEFORE INSERT OR UPDATE ON NPC
FOR EACH ROW EXECUTE FUNCTION check_NPC();

------------ teste 
INSERT INTO Personagem (idPersonagem, tipoPersonagem) VALUES (25, 'N');

INSERT INTO NPC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, eAliado, tipoNPC)
VALUES (25, 1, 100, 100, 100, 'Test NPC', NULL, 'true', 3);

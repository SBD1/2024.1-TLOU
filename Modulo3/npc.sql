DROP TRIGGER IF EXISTS trg_insere_personagem_npc ON Personagem;
DROP FUNCTION IF EXISTS insere_personagem_npc();

CREATE OR REPLACE FUNCTION insere_personagem_npc()
RETURNS TRIGGER AS $$
BEGIN
  
    IF NEW.tipoPersonagem = 'N' THEN
       
        IF EXISTS (SELECT 1 FROM PC WHERE IdPersonagem = NEW.idPersonagem) THEN
            RAISE EXCEPTION 'Este personagem já está inserido na tabela PC';
        END IF;

        IF (NEW.idPersonagem IS NOT NULL AND NEW.Sala IS NOT NULL AND NEW.xp IS NOT NULL AND NEW.vidaMax IS NOT NULL AND 
            NEW.nomePersonagem IS NOT NULL AND NEW.eAliado IS NOT NULL AND NEW.tipoNPC IS NOT NULL) THEN
            INSERT INTO NPC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, eAliado, tipoNPC)
            VALUES (NEW.idPersonagem, NEW.Sala, NEW.xp, NEW.vidaMax, COALESCE(NEW.vidaAtual, 1), NEW.nomePersonagem, 
                    COALESCE(NEW.IdInventario, NULL), NEW.eAliado, NEW.tipoNPC);
        ELSE
            RAISE EXCEPTION 'Faltam atributos obrigatórios para a inserção na tabela NPC';
        END IF;
    ELSE
        
        RAISE EXCEPTION 'Tipo de personagem inválido para inserção na tabela NPC';
    END IF;

    RETURN NULL; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_insere_personagem_npc
AFTER INSERT ON Personagem
FOR EACH ROW
EXECUTE FUNCTION insere_personagem_npc();



INSERT INTO Personagem (idPersonagem, tipoPersonagem) VALUES (27, 'N');


INSERT INTO NPC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, eAliado, tipoNPC)
VALUES (27, 1, 100, 100, 100, 'Test NPC', NULL, TRUE, 1);

SELECT * FROM NPC WHERE IdPersonagem = 27;

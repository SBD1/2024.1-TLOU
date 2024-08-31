-- Remover o trigger antigo, caso exista
DROP TRIGGER IF EXISTS trg_insere_personagem_pc ON Personagem;

-- Remover a função antiga, caso exista
DROP FUNCTION IF EXISTS insere_personagem_pc();

-- Criar a função para inserir PC
CREATE OR REPLACE FUNCTION insere_personagem_pc()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o tipoPersonagem é 1 (PC)
    IF NEW.tipoPersonagem = 1 THEN
        -- Garante que o Personagem não esteja na tabela NPC
        IF EXISTS (SELECT 1 FROM NPC WHERE IdPersonagem = NEW.idPersonagem) THEN
            RAISE EXCEPTION 'Este personagem já está inserido na tabela NPC';
        END IF;

        IF (NEW.tipoPersonagem = 1) THEN -- inserindo um PC
        INSERT INTO PC (idPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, estado, Evolucao, IdInventario)
        VALUES (NEW.IdPersonagem, COALESCE(NEW.Sala, DEFAULT), COALESCE(NEW.xp, DEFAULT), 
                COALESCE(NEW.vidaMax, DEFAULT), COALESCE(NEW.vidaAtual, NULL), 
                COALESCE(NEW.nomePersonagem, DEFAULT), COALESCE(NEW.estado, DEFAULT), 
                COALESCE(NEW.Evolucao, DEFAULT), COALESCE(NEW.IdInventario, DEFAULT));

    ELSE
        RAISE EXCEPTION 'Tipo de personagem inválido para inserção na tabela PC';
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_insere_personagem_pc
AFTER INSERT ON Personagem
FOR EACH ROW
WHEN (NEW.tipoPersonagem = 1)
EXECUTE FUNCTION insere_personagem_pc();


INSERT INTO Personagem (idPersonagem, tipoPersonagem) VALUES (29, 1);


INSERT INTO PC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, estado, Evolucao, IdInventario)
VALUES (29, 1, 100, 100, 100, 'Test PC', 'Normal', 1, 1);

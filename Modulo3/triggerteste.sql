CREATE OR REPLACE FUNCTION inserirEspecificoPersonagem()
RETURNS trigger AS $inserirEspecificoPersonagem$
BEGIN
    -- Insere o personagem na tabela Personagem
    INSERT INTO Personagem (idPersonagem, tipoPersonagem)
    VALUES (NEW.IdPersonagem, NEW.tipoPersonagem);

    -- Determina o tipo e insere o personagem na tabela correta
    IF (NEW.tipoPersonagem = 1) THEN -- inserindo um PC
        INSERT INTO PC (idPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, estado, Evolucao, IdInventario)
        VALUES (NEW.IdPersonagem, NEW.Sala, NEW.xp, NEW.vidaMax, NEW.vidaAtual, NEW.nomePersonagem, NEW.estado, NEW.Evolucao, NEW.IdInventario);

    ELSIF (NEW.tipoPersonagem = 2) THEN -- inserindo um NPC
        INSERT INTO NPC (idPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, eAliado, tipoNPC)
        VALUES (NEW.IdPersonagem, NEW.Sala, NEW.xp, NEW.vidaMax, NEW.vidaAtual, NEW.nomePersonagem, 
        NEW.IdInventario, NEW.eAliado, NEW.tipoNPC);
    END IF;

    RETURN NULL; -- Retorna NULL para evitar a inserção da linha original
END;
$inserirEspecificoPersonagem$ LANGUAGE plpgsql;

DROP TRIGGER t_inserirPCouNPC ON PC;

-- Criando a trigger
CREATE TRIGGER t_inserirPCouNPC
BEFORE INSERT ON PC
FOR EACH ROW EXECUTE PROCEDURE inserirEspecificoPersonagem();

INSERT INTO Personagem VALUES (24, 1);
INSERT INTO PC VALUES (24, 1, 3, 40, 10,'ole','depressao', 2, 4);

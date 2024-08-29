CREATE FUNCTION inserirEspecificoPersonagem() RETURNS trigger AS $$
BEGIN 
    -- Verificação se já existe em alguma tabela das específicas 
    PERFORM * FROM PC WHERE NEW.IdPersonagem = PC.IdPersonagem;
    IF FOUND THEN
        RAISE EXCEPTION 'Este personagem já foi inserido na tabela PC';
    END IF;

    PERFORM * FROM NPC WHERE NEW.IdPersonagem = NPC.IdPersonagem;
    IF FOUND THEN
        RAISE EXCEPTION 'Este personagem já foi inserido na tabela NPC';
    END IF;

    -- Verificação do tipo de personagem na tabela Personagem
    IF (NEW.IdPersonagem IS NOT NULL AND NEW.Sala IS NOT NULL AND NEW.xp IS NOT NULL AND NEW.vidaMax IS NOT NULL AND 
    NEW.nomePersonagem IS NOT NULL AND NEW.estado IS NOT NULL AND NEW.Evolucao IS NOT NULL AND NEW.IdInventario IS NOT NULL 
    AND (SELECT tipoPersonagem FROM Personagem WHERE IdPersonagem = NEW.IdPersonagem) = 1) THEN -- inserindo um PC
        INSERT INTO PC VALUES (NEW.IdPersonagem, NEW.Sala, NEW.xp, NEW.vidaMax, NEW.vidaAtual, NEW.nomePersonagem, 
        NEW.estado, NEW.Evolucao, NEW.IdInventario);
    ELSIF (NEW.IdPersonagem IS NOT NULL AND NEW.Sala IS NOT NULL AND NEW.xp IS NOT NULL AND NEW.vidaMax IS NOT NULL AND 
    NEW.nomePersonagem IS NOT NULL AND NEW.eAliado IS NOT NULL AND NEW.tipoNPC IS NOT NULL 
    AND (SELECT tipoPersonagem FROM Personagem WHERE IdPersonagem = NEW.IdPersonagem) = 2) THEN -- inserindo um NPC
        INSERT INTO NPC VALUES (NEW.IdPersonagem, NEW.Sala, NEW.xp, NEW.vidaMax, 
        NEW.vidaAtual, NEW.nomePersonagem, NEW.IdInventario, NEW.eAliado, NEW.tipoNPC);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_inserirPCouNPC 
BEFORE INSERT ON PC
FOR EACH ROW EXECUTE FUNCTION inserirEspecificoPersonagem();

-- Inserindo dados de teste
INSERT INTO Personagem (idPersonagem, tipoPersonagem) VALUES 
(24, 1);

INSERT INTO PC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, estado, Evolucao, IdInventario) VALUES
(24, 1, 3, 40, 10, 'ole', 'depressao', 2, 4);

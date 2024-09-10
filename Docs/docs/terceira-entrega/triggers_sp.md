---
sidebar_position: 2
sidebar_label: "Triggers e Storage Procedures"
---

# O que são Triggers e Strorage Procedures?

Triggers e Stored Procedures são técnicas no banco de dados que ajudam a gerenciar e automatizar operações. Triggers são procedimentos automáticos que são executados em resposta a eventos específicos, como inserções, atualizações ou exclusões de dados em uma tabela, sendo por elas acionados. Stored Procedures são blocos de código SQL que são armazenados e podem ser chamados explicitamente para realizar operações complexas, como manter integridade de generalizações e especializações. Em conjunto, são ótimas opções para tornar o banco mais robusto e confiável.

Aqui, apresentamos o os Triggers e SP que mantém a integridade para a generalização/especialização de Personagem. 

```sql
DROP TRIGGER IF EXISTS check_Personagem ON Personagem;
DROP FUNCTION IF EXISTS check_Personagem();

-- garante integridade na inserção da tabela personagem, tipo só podendo ser N ou P

CREATE OR REPLACE FUNCTION check_Personagem() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM Personagem WHERE idPersonagem = NEW.idPersonagem) THEN
        RAISE EXCEPTION 'Esse personagem já existe na base de dados!';
    END IF;

    IF (NEW.idPersonagem IS NOT NULL AND NEW.tipoPersonagem = 'P' OR  NEW.tipoPersonagem = 'N') THEN       
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Atributos obrigatórios devem ser preenchidos e tipo do 
        personagem deve ser P (PC) ou N (NPC)!';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_Personagem
BEFORE INSERT ON Personagem
FOR EACH ROW EXECUTE FUNCTION check_Personagem();
DROP FUNCTION IF EXISTS check_PC();


-- garante integridade na inserção de um PC 
CREATE OR REPLACE FUNCTION check_PC() RETURNS TRIGGER AS $$
BEGIN
  
    IF EXISTS (SELECT 1 FROM NPC WHERE idPersonagem = NEW.idPersonagem) THEN
        RAISE EXCEPTION 'Esse personagem já existe na tabela NPC e não pode ser inserido em PC!';
    END IF;

   
    IF (SELECT tipoPersonagem FROM Personagem WHERE idPersonagem = NEW.idPersonagem) <> 'P' THEN
        RAISE EXCEPTION 'O personagem deve ter o tipo ''P'' para ser inserida em PC!'; 
    END IF;
    
    IF (NEW.IdPersonagem IS NOT NULL AND NEW.Sala IS NOT NULL AND NEW.xp IS NOT NULL AND NEW.vidaMax IS NOT NULL AND NEW.nomePersonagem IS NOT NULL
     AND NEW.estado IS NOT NULL AND NEW.Evolucao IS NOT NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Os atributos obrigatórios devem ser preenchidos!';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_PC
BEFORE INSERT ON PC
FOR EACH ROW EXECUTE FUNCTION check_PC();
```

Dessa forma, muitos outros Triggers e SP foram por nós implementados para garantir o completo funcionamento da base de dados de forma sólida. Todos podem ser encontrados no arquivo [**triggers.sql**](../../../Modulo3/triggers.sql).
-- Removendo tabelas existentes
DROP TABLE IF EXISTS 
      Participacao, Animal, FaccaoHumana, Infectado, InstNPC, Dialoga, Concede, 
      MissaoExploracaoObterItem, MissaoPatrulha, Habilidade, Itinerario, Evento, 
      PC, Evolucao, Ingrediente, Receita, Consumivel, Vestimenta, Arma, NPC, Itens, 
      InstItem, Item, Missao, Inventario, Personagem, Sala, Regiao 
      CASCADE;
    
-- Início da transação
BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS Regiao (
    idRegiao SERIAL NOT NULL,
    descricaoRegiao VARCHAR (400) NOT NULL,
    nomeRegiao VARCHAR (50) NOT NULL,
    capacidade INT,
    tipoRegiao VARCHAR(1) NOT NULL,
    z_seguranca INT, 
    z_populacaoAtual INT,
    a_defesa INT, 
    l_tipo VARCHAR(50),
    l_periculosidade INT,

    CONSTRAINT regiao_pk PRIMARY KEY (idRegiao),
    UNIQUE (nomeRegiao)
);

CREATE TABLE IF NOT EXISTS Sala (
    idSala SERIAL NOT NULL,
    IdRegiao INT NOT NULL, 
    
    CONSTRAINT sala_pk PRIMARY KEY (idSala),
    CONSTRAINT regiao_sala_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);

CREATE TABLE IF NOT EXISTS Personagem (
    idPersonagem SERIAL NOT NULL,
    tipoPersonagem VARCHAR (1) NOT NULL,

    CONSTRAINT personagem_pk PRIMARY KEY (idPersonagem)
);

CREATE TABLE IF NOT EXISTS Inventario (
    idInventario SERIAL NOT NULL,
    capacidade INT NOT NULL,
    descricao VARCHAR (50) NOT NULL,

    CHECK (capacidade >= 0),
    
    CONSTRAINT inventario_pk PRIMARY KEY (idInventario)
);

CREATE TABLE IF NOT EXISTS Missao (
    idMissao SERIAL NOT NULL,
    tipoMis VARCHAR (1) NOT NULL,

    CONSTRAINT missao_pk PRIMARY KEY (idMissao)
);

CREATE TABLE IF NOT EXISTS Item (
    idItem SERIAL NOT NULL,
    tipoItem VARCHAR (1) NOT NULL,

    CONSTRAINT item_pk PRIMARY KEY (idItem)
);

CREATE TABLE IF NOT EXISTS InstItem ( 
    idInstItem SERIAL NOT NULL,
    IdItem INT NOT NULL,
    Sala INT, 
    IdInventario INT,

    CONSTRAINT instItem_pk PRIMARY KEY (idInstItem),
    CONSTRAINT item_inst_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem),
    CONSTRAINT item_sala_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala),
    CONSTRAINT item_inventario_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);

CREATE TABLE IF NOT EXISTS Itens (
    IdMissao INT NOT NULL,
    IdItem INT NOT NULL,
    
    CONSTRAINT itens_pk PRIMARY KEY (IdMissao, IdItem),
    CONSTRAINT missao_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT itens_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);

CREATE TABLE IF NOT EXISTS NPC (
    IdPersonagem INT NOT NULL,
    xp INT NOT NULL,
    vidaMax INT NOT NULL,
    vidaAtual INT,
    nomePersonagem VARCHAR(50) NOT NULL,
    IdInventario INT, 
    eAliado BOOLEAN NOT NULL,
    tipoNPC VARCHAR (1) NOT NULL, 

    CHECK (vidaAtual > 0),
    CHECK (vidaAtual <= vidaMax),

    CONSTRAINT npc_pk PRIMARY KEY (IdPersonagem),
    CONSTRAINT npc_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem),
    CONSTRAINT inventario_npc_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);

CREATE TABLE IF NOT EXISTS Arma (
    IdItem INT NOT NULL,
    nomeItem VARCHAR (50) NOT NULL,
    dano INT NOT NULL,
    municaoAtual INT,
    municaoMax INT NOT NULL, 
    eAtaque BOOLEAN NOT NULL,
    descricaoItem VARCHAR (400) NOT NULL,

    CONSTRAINT arma_pk PRIMARY KEY (IdItem),
    CONSTRAINT item_arma_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);

CREATE TABLE IF NOT EXISTS Vestimenta (
    IdItem INT NOT NULL,
    nomeItem VARCHAR (50) NOT NULL,
    descricaoItem VARCHAR (400) NOT NULL,   
    eAtaque BOOLEAN NOT NULL,
    defesa INT NOT NULL,

    CONSTRAINT vestimenta_pk PRIMARY KEY (IdItem),
    CONSTRAINT item_vest_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);

CREATE TABLE IF NOT EXISTS Consumivel (
    IdItem INT NOT NULL,
    nomeItem VARCHAR (50) NOT NULL,
    tipoConsumivel VARCHAR (40) NOT NULL,
    aumentoVida INT,  
    eAtaque BOOLEAN NOT NULL,
    descricaoItem VARCHAR (400) NOT NULL,
    danoConsumivel INT,

    CONSTRAINT consumivel_pk PRIMARY KEY (IdItem),
    CONSTRAINT item_Consumivel_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);

CREATE TABLE IF NOT EXISTS Receita (
    idReceita SERIAL NOT NULL,
    nomeReceita VARCHAR (50) NOT NULL,
    descricaoReceita VARCHAR (400) NOT NULL,
    tempoCraft INT NOT NULL, 
    IdItem INT NOT NULL,
    juncao VARCHAR (100) NOT NULL,

    CONSTRAINT receita_pk PRIMARY KEY (idReceita),
    CONSTRAINT item_receita_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);

CREATE TABLE IF NOT EXISTS Ingrediente (
    idIngrediente SERIAL NOT NULL,
    IdReceita INT NOT NULL,
    IdItem INT NOT NULL,
    quantidadeIngre INT NOT NULL,

    CONSTRAINT igrediente_pk PRIMARY KEY (idIngrediente),
    CONSTRAINT receita_fk FOREIGN KEY (IdReceita) REFERENCES Receita (idReceita),
    CONSTRAINT item_ingrediente_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);

CREATE TABLE IF NOT EXISTS Evolucao (
    idEvolucao SERIAL NOT NULL,
    requisitoNivel INT NOT NULL,
    xpEvol INT NOT NULL,

    CONSTRAINT evolucao_pk PRIMARY KEY (idEvolucao)
);

CREATE TABLE IF NOT EXISTS PC (
    IdPersonagem SERIAL NOT NULL,
    Sala INT NOT NULL,
    xp INT NOT NULL,
    vidaMax INT NOT NULL,
    vidaAtual INT,
    nomePersonagem VARCHAR (50) NOT NULL,
    estado VARCHAR (20) NOT NULL, 
    Evolucao INT NOT NULL,
    IdInventario INT NOT NULL, 

    CHECK (vidaAtual > 0),
    CHECK (vidaAtual <= vidaMax),

    CONSTRAINT pc_pk PRIMARY KEY (IdPersonagem),
    CONSTRAINT pc_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem),
    CONSTRAINT evolucao_fk FOREIGN KEY (Evolucao) REFERENCES Evolucao (idEvolucao),
    CONSTRAINT inventario_pc_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario),
    CONSTRAINT sala_pc_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala)
);

CREATE TABLE IF NOT EXISTS Evento (
    idEvento SERIAL NOT NULL,
    nomeEvento VARCHAR (400) NOT NULL,
    descricao VARCHAR (400) NOT NULL,
    Sala INT NOT NULL,
    IdPersonagem INT NOT NULL,

    CONSTRAINT evento_pk PRIMARY KEY (idEvento),
    CONSTRAINT personagem_evento_fk FOREIGN KEY (IdPersonagem) REFERENCES PC (IdPersonagem),
    CONSTRAINT sala_evento_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala)
);

CREATE TABLE IF NOT EXISTS Itinerario (
    idItinerario SERIAL NOT NULL,
    horario INT NOT NULL,
    dia DATE NOT NULL, 
    IdEvento INT NOT NULL,

    CONSTRAINT itinerario_pk PRIMARY KEY (idItinerario),
    CONSTRAINT evento_itinerario_fk FOREIGN KEY (IdEvento) REFERENCES Evento (idEvento)
);

CREATE TABLE IF NOT EXISTS Habilidade (
    idHabilidade SERIAL NOT NULL,
    nomeHabilidade VARCHAR (50) NOT NULL,
    tipoHabilidade VARCHAR (50) NOT NULL, 
    efeito VARCHAR (70) NOT NULL,
    duracaoHabilidade INT NOT NULL,
    IdPersonagem INT NOT NULL,

    CONSTRAINT habilidade_pk PRIMARY KEY (idHabilidade),
    CONSTRAINT pc_habilidade_fk FOREIGN KEY (IdPersonagem) REFERENCES PC (IdPersonagem)
);

CREATE TABLE IF NOT EXISTS MissaoExploracaoObterItem (
    IdMissao INT NOT NULL,
    idMissaoPre INT,
    objetivo VARCHAR (400) NOT NULL,
    nomeMis VARCHAR (50) NOT NULL,
    IdPersonagem INT NOT NULL,
    xpMis INT NOT NULL, 
    statusMissao BOOLEAN NOT NULL,
    Sala INT NOT NULL, 
    
    CONSTRAINT missaoExploracao_pk PRIMARY KEY (IdMissao),
    CONSTRAINT missaoObter_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT pc_missaoObter_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem),
    CONSTRAINT sala_exploracao_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala)
);

CREATE TABLE IF NOT EXISTS MissaoPatrulha (
    IdMissao INT NOT NULL,
    idMissaoPre INT,
    objetivo VARCHAR (400) NOT NULL,
    nomeMis VARCHAR (50) NOT NULL,
    qtdNPCs INT NOT NULL,
    IdPersonagem INT NOT NULL,
    xpMis INT NOT NULL,
    statusMissao BOOLEAN NOT NULL, 
    Sala INT NOT NULL,
    
    CONSTRAINT missaoPatrulha_pk PRIMARY KEY (IdMissao),
    CONSTRAINT missaoPatrulha_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT pc_missaoPatrulha_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem),
    CONSTRAINT sala_missaopatrulha_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala)
);

CREATE TABLE IF NOT EXISTS Concede (
    IdEvolucao INT NOT NULL,
    IdConsumivel INT NOT NULL,

    CONSTRAINT concede_pk PRIMARY KEY (IdEvolucao, IdConsumivel),
    CONSTRAINT evolucao_fk FOREIGN KEY (IdEvolucao) REFERENCES Evolucao (idEvolucao),
    CONSTRAINT Consumivel_fk FOREIGN KEY (IdConsumivel) REFERENCES Consumivel (IdItem)
);

CREATE TABLE IF NOT EXISTS Dialoga (
    idDialogo SERIAL NOT NULL,
    IdFalante INT NOT NULL,
    IdOuvinte INT NOT NULL, 
    conteudo VARCHAR (400) NOT NULL,
    duracaoDialogo INT NOT NULL,
    
    CONSTRAINT dialogo_pk PRIMARY KEY (idDialogo),
    CONSTRAINT falante_fk FOREIGN KEY (IdFalante) REFERENCES Personagem (idPersonagem),
    CONSTRAINT ouvinte_fk FOREIGN KEY (IdOuvinte) REFERENCES Personagem (idPersonagem)
);

CREATE TABLE IF NOT EXISTS InstNPC (
    IdInstNPC SERIAL NOT NULL,
    tipoNPC VARCHAR(1) NOT NULL,
    IdNPC INT NOT NULL,
    Sala INT,

    CONSTRAINT idNPC_fk FOREIGN KEY (IdNPC) REFERENCES NPC (IdPersonagem),
    CONSTRAINT sala_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala),
    CONSTRAINT instNPC_pk PRIMARY KEY (IdInstNPC)
);

CREATE TABLE IF NOT EXISTS Infectado (
    IdNPC INT NOT NULL,
    comportamentoInfec VARCHAR (400) NOT NULL,
    velocidade INT NOT NULL, 
    danoInfectado INT NOT NULL,

    CONSTRAINT infectado_pk PRIMARY KEY (IdNPC),
    CONSTRAINT npc_infec_fk FOREIGN KEY (IdNPC) REFERENCES NPC (IdPersonagem)
);

CREATE TABLE IF NOT EXISTS FaccaoHumana (
    IdNPC INT NOT NULL,
    nomeFaccao VARCHAR (50) NOT NULL,

    CONSTRAINT faccao_pk PRIMARY KEY (IdNPC),
    CONSTRAINT npc_facc_fk FOREIGN KEY (IdNPC) REFERENCES NPC (IdPersonagem)
);

CREATE TABLE IF NOT EXISTS Animal (
    IdNPC INT NOT NULL,
    nomeAnimal VARCHAR (50) NOT NULL,
    ameaca VARCHAR (100) NOT NULL,
    danoAnimal INT,

    CONSTRAINT animal_pk PRIMARY KEY (idNPC),
    CONSTRAINT npc_animal_fk FOREIGN KEY (IdNPC) REFERENCES NPC (IdPersonagem)
);

CREATE TABLE IF NOT EXISTS Participacao (
    IdNPC INT NOT NULL,
    Evento INT NOT NULL,
    Missao INT NOT NULL,

    CONSTRAINT participacao_pk PRIMARY KEY (IdNPC, Evento, Missao),
    CONSTRAINT npc_part_fk FOREIGN KEY (IdNPC) REFERENCES NPC (IdPersonagem),
    CONSTRAINT evento_part_fk FOREIGN KEY (Evento) REFERENCES Evento (idEvento),
    CONSTRAINT missao_part_fk FOREIGN KEY (Missao) REFERENCES Missao (idMissao)
);

COMMIT;
/c tloupgdb 

-- definição de tabelas

CREATE TABLE Mundo (
    idMundo SERIAL NOT NULL,
    descricaoMundo VARCHAR (400) NOT NULL,
    nomeMundo VARCHAR (50) NOT NULL,
    
    CONSTRAINT mundo_pk PRIMARY KEY (idMundo),
    UNIQUE (nomeMundo)
);

CREATE TABLE Regiao (
    idRegiao SERIAL NOT NULL,
    descricaoRegiao VARCHAR (400) NOT NULL,
    coordenadaX INT NOT NULL,
    coordenadaY INT NOT NULL,
    nomeRegiao VARCHAR (50) NOT NULL,
    capacidade INT,
    IdMundo NOT NULL,
    tipoRegiao INT,

    CONSTRAINT regiao_pk PRIMARY KEY (idRegiao),
    CONSTRAINT mundo_fk FOREIGN KEY (IdMundo) REFERENCES Mundo (idMundo),
    UNIQUE (nomeRegiao)
);

CREATE TABLE ZonaQuarentena (
    IdRegiao SERIAL NOT NULL,
    idZona SERIAL NOT NULL,
    seguranca INT NOT NULL, 
    populacaoAtual INT,

    CONSTRAINT zonaQuarentena_pk PRIMARY KEY (idZona),
    CONSTRAINT regiao_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);

CREATE TABLE Acampamento (
    IdRegiao SERIAL NOT NULL,
    idAcampamento SERIAL NOT NULL,
    defesa INT NOT NULL, 

    CONSTRAINT acampamento_pk PRIMARY KEY (idAcampamento),
    CONSTRAINT regiao_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);

CREATE TABLE LocalAbandonado (
    IdRegiao SERIAL NOT NULL,
    idLocal SERIAL NOT NULL,
    nivelInfestacao INT, 
    periculosidade	INT NOT NULL,

    CONSTRAINT local_pk PRIMARY KEY (idLocal),
    CONSTRAINT regiao_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);

CREATE TABLE Personagem (
    idPersonagem SERIAL NOT NULL,
    tipoPersonagem INT NOT NULL,

    CONSTRAINT personagem_pk PRIMARY KEY (idPersonagem)
);

CREATE TABLE NPC (
    IdPersonagem SERIAL NOT NULL,
    idNPC SERIAL NOT NULL,
    locEmX INT NOT NULL,
    locEmY INT NOT NULL,
    xp INT NOT NULL,
    vidaMax INT NOT NULL,
    vidaAtual INT,
    nomePersonagem VARCHAR (50) NOT NULL,
    Loot VARCHAR (50), 
    eALiado BOOLEAN NOT NULL, 
    Mundo INT NOT NULL,
    IdInventario INT NOT NULL, 

    CONSTRAINT npc_pk PRIMARY KEY (idNPC),
    CONSTRAINT npc_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem),
    CONSTRAINT mundo_fk FOREIGN KEY (Mundo) REFERENCES Mundo (idMundo),
    CONSTRAINT loot_fk FOREIGN KEY (Loot) REFERENCES InstItem (idItem),
    CONSTRAINT inventario_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);

CREATE TABLE PC (
    IdPersonagem SERIAL NOT NULL,
    idPC SERIAL NOT NULL,
    locEmX INT NOT NULL,
    locEmY INT NOT NULL,
    xp INT NOT NULL,
    vidaMax INT NOT NULL,
    vidaAtual INT,
    nomePersonagem VARCHAR (50) NOT NULL,
    estado VARCHAR (20) NOT NULL, 
    Evolucao INT NOT NULL,
    Mundo INT NOT NULL,
    IdInventario INT NOT NULL, 

    CONSTRAINT pc_pk PRIMARY KEY (idPC),
    CONSTRAINT pc_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem),
    CONSTRAINT mundo_fk FOREIGN KEY (Mundo) REFERENCES Mundo (idMundo),
    CONSTRAINT evolucao_fk FOREIGN KEY (Evolucao) REFERENCES Evolucao (idEvolucao),
    CONSTRAINT inventario_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);

CREATE TABLE Inventario (
    idInventario SERIAL NOT NULL,
    capacidade INT NOT NULL,
    descricao VARCHAR (50) NOT NULL,
    
    CONSTRAINT inventario_pk PRIMARY KEY (idInventario)
);

CREATE TABLE Itens (
    IdMissao INT NOT NULL,
    IdItem INT NOT NULL,
    
    CONSTRAINT itens_pk PRIMARY KEY (IdMissao, IdItem),
    CONSTRAINT missao_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT item_fk FOREIGN KEY (IdItem) REFERENCES InstItem (idItem)
);

CREATE TABLE Missao (
    idMissao SERIAL NOT NULL,
    tipoMis INT NOT NULL,

    CONSTRAINT missao_pk PRIMARY KEY (idMissao)
);

CREATE TABLE MissaoExploracaoObterItem (
    IdMissao INT NOT NULL,
    idMissaoPre INT,
    objetivo VARCHAR (400) NOT NULL,
    nomeMis VARCHAR (50) NOT NULL,
    ItensAdquiridos VARCHAR (50),
    idExploracao SERIAL NOT NULL,
    IdPC INT NOT NULL,
    xpMis INT NOT NULL, 
    
    CONSTRAINT missaoExploracao_pk PRIMARY KEY (idExploracao),
    CONSTRAINT missao_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT missaoItens_fk FOREIGN KEY (ItensAdquiridos) REFERENCES InstItem (idItem),
    CONSTRAINT pc_fk FOREIGN KEY (IdPC) REFERENCES PC (idPC)
);

CREATE TABLE MissaoPatrulha (
    IdMissao INT NOT NULL,
    idMissaoPre INT,
    objetivo VARCHAR (400) NOT NULL,
    nomeMis VARCHAR (50) NOT NULL,
    qtdNPCs INT NOT NULL,
    IdPC INT NOT NULL,
    xpMis INT NOT NULL, 
    idPatrulha SERIAL NOT NULL,
    
    CONSTRAINT missaoPatrulha_pk PRIMARY KEY (idPatrulha),
    CONSTRAINT missao_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT pc_fk FOREIGN KEY (IdPC) REFERENCES PC (idPC)
);

CREATE TABLE Evento (
    idEvento SERIAL NOT NULL,
    nomeEvento INT NOT NULL,
    descricao VARCHAR (400) NOT NULL,
    locEmX INT NOT NULL,
    locEmY INT NOT NULL,
    IdPC INT NOT NULL,

    CONSTRAINT evento_pk PRIMARY KEY (idEvento),
    CONSTRAINT pc_fk FOREIGN KEY (IdPC) REFERENCES PC (idPC)
);

CREATE TABLE Itinerario (
    idItinerario SERIAL NOT NULL,
    horario INT NOT NULL,
    dia DATE NOT NULL, 
    IdEvento INT NOT NULL,

    CONSTRAINT itinerario_pk PRIMARY KEY (idItinerario),
    CONSTRAINT evento_fk FOREIGN KEY (IdEvento) REFERENCES Evento (idEvento)
);

CREATE TABLE Habilidade (
    idHabilidade SERIAL NOT NULL,
    nomeHabilidade VARCHAR (50) NOT NULL,
    tipoHabilidade VARCHAR (50) NOT NULL, 
    efeito VARCHAR (50) NOT NULL,
    duracaoHabilidade INT NOT NULL,
    IdPC INT NOT NULL,

    CONSTRAINT habilidade_pk PRIMARY KEY (idHabilidade),
    CONSTRAINT pc_fk FOREIGN KEY (IdPC) REFERENCES PC (idPC)
);

CREATE TABLE Inventario (
    idInventario SERIAL NOT NULL,
    descricao VARCHAR (400) NOT NULL,
    capacidadeInvent INT NOT NULL, 

    CONSTRAINT inventario_pk PRIMARY KEY (idInventario)
);

CREATE TABLE InstItem (
    idItem SERIAL NOT NULL,
    tipoItem INT NOT NULL,

    CONSTRAINT item_pk PRIMARY KEY (idItem)
);

CREATE TABLE Arma (
    idArma SERIAL NOT NULL,
    IdItem INT NOT NULL,
    nomeArma VARCHAR (50) NOT NULL,
    dano INT NOT NULL,
    municaoAtual INT,
    municaoMax INT NOT NULL,
    IdInventario INT NOT NULL,    
    eAtaque BOOLEAN NOT NULL,

    CONSTRAINT arma_pk PRIMARY KEY (idArma),
    CONSTRAINT item_fk FOREIGN KEY (IdItem) REFERENCES InstItem (idItem),
    CONSTRAINT inventario_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);

CREATE TABLE Vestimenta (
    idVestimenta SERIAL NOT NULL,
    IdItem INT NOT NULL,
    nomeVestimenta VARCHAR (50) NOT NULL,
    descricaoVestimenta VARCHAR (400) NOT NULL,
    IdInventario INT NOT NULL,    
    eAtaque BOOLEAN NOT NULL,

    CONSTRAINT vestimenta_pk PRIMARY KEY (idVestimenta),
    CONSTRAINT item_fk FOREIGN KEY (IdItem) REFERENCES InstItem (idItem),
    CONSTRAINT inventario_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);

CREATE TABLE Alimento (
    idAlimento SERIAL NOT NULL,
    IdItem INT NOT NULL,
    nomeAlimento VARCHAR (50) NOT NULL,
    tipoAlimento VARCHAR (40) NOT NULL,
    aumentoVida INT NOT NULL,  
    IdInventario  INT NOT NULL,
    eAtaque BOOLEAN NOT NULL,

    CONSTRAINT alimento_pk PRIMARY KEY (idAlimento),
    CONSTRAINT item_fk FOREIGN KEY (IdItem) REFERENCES InstItem (idItem),
    CONSTRAINT inventario_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);

CREATE TABLE Receita (
    idReceita SERIAL NOT NULL,
    nomeReceita VARCHAR (50) NOT NULL,
    descricaoReceita VARCHAR (400) NOT NULL,
    tempoCraft INT NOT NULL, 
    IdItem INT NOT NULL,

    CONSTRAINT receita_pk PRIMARY KEY (idReceita),
    CONSTRAINT item_fk FOREIGN KEY (IdItem) REFERENCES InstItem (idItem)
);

CREATE TABLE Ingrediente (
    idIngrediente SERIAL NOT NULL,
    IdReceita INT NOT NULL,
    IdItem INT NOT NULL,
    quatidadeIngre INT NOT NULL,

    CONSTRAINT igrediente_pk PRIMARY KEY (idIngrediente),
    CONSTRAINT receita_fk FOREIGN KEY (IdReceita) REFERENCES Receita (idReceita),
    CONSTRAINT item_fk FOREIGN KEY (IdItem) REFERENCES InstItem (idItem)
);

CREATE TABLE Evolucao (
    idEvolucao SERIAL NOT NULL,
    requisitoNivel INT NOT NULL,
    xpEvol INT NOT NULL,

    CONSTRAINT evolucao_pk PRIMARY KEY (idEvolucao)
);

CREATE TABLE Concede (
    IdEvolucao INT NOT NULL,
    IdAlimento INT NOT NULL,

    CONSTRAINT concede_pk PRIMARY KEY (IdEvolucao, IdAlimento),
    CONSTRAINT evolucao_fk FOREIGN KEY (IdEvolucao) REFERENCES Evolucao (idEvolucao),
    CONSTRAINT alimento_fk FOREIGN KEY (IdAlimento) REFERENCES Alimento (idAlimento)
);

CREATE TABLE Dialoga (
    idDialogo SERIAL NOT NULL,
    IdFalante INT NOT NULL,
    IdOuvinte INT NOT NULL, 
    conteudo VARCHAR (50) NOT NULL,
    duracaoDialogo INT NOT NULL,
    
    CONSTRAINT dialogo_pk PRIMARY KEY (idDialogo),
    CONSTRAINT falante_fk FOREIGN KEY (IdFalante) REFERENCES Personagem (idPersonagem),
    CONSTRAINT ouvinte_fk FOREIGN KEY (IdOuvinte) REFERENCES Personagem (idPersonagem)
);

CREATE TABLE InstNPC (
    IdNPC INT NOT NULL,
    tipoNPC INT NOT NULL,

    CONSTRAINT instNPC_pk PRIMARY KEY (IdNPC),
    CONSTRAINT npc_fk FOREIGN KEY (IdNPC) REFERENCES NPC (idNPC) 
);

CREATE TABLE Infectado (
    IdNPC INT NOT NULL,
    idInfectado SERIAL NOT NULL,
    comportamentoInfec VARCHAR (400) NOT NULL,

    CONSTRAINT infectado_pk PRIMARY KEY (idInfectado),
    CONSTRAINT npc_fk FOREIGN KEY (IdNPC) REFERENCES NPC (idNPC)
);

CREATE TABLE FaccaoHumana (
    IdNPC INT NOT NULL,
    idFaccao SERIAL NOT NULL,
    nomeFaccao VARCHAR (50) NOT NULL,

    CONSTRAINT faccao_pk PRIMARY KEY (idFaccao),
    CONSTRAINT npc_fk FOREIGN KEY (IdNPC) REFERENCES NPC (idNPC)
);

CREATE TABLE Animal (
    IdNPC INT NOT NULL,
    idAnimal SERIAL NOT NULL,
    nomeAnimal VARCHAR (50) NOT NULL,
    ameaca VARCHAR (100) NOT NULL,

    CONSTRAINT animal_pk PRIMARY KEY (idAnimal),
    CONSTRAINT npc_fk FOREIGN KEY (IdNPC) REFERENCES NPC (idNPC)
);

CREATE TABLE Participacao (
    IdNPC INT NOT NULL,
    Evento INT NOT NULL,
    Missao INT NOT NULL,

    CONSTRAINT participacao_pk PRIMARY KEY (IdNPC, Evento, Missao),
    CONSTRAINT npc_fk FOREIGN KEY (IdNPC) REFERENCES NPC (idNPC),
    CONSTRAINT evento_fk FOREIGN KEY (Evento) REFERENCES Evento (idNPC),
    CONSTRAINT missao_fk FOREIGN KEY (Missao) REFERENCES Missao (idMissao)
);

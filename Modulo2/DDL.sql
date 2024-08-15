-- definição de tabelas

CREATE TABLE Regiao (
    idRegiao SERIAL NOT NULL,
    descricaoRegiao VARCHAR (400) NOT NULL,
    nomeRegiao VARCHAR (50) NOT NULL,
    capacidade INT,
    tipoRegiao INT,

    CONSTRAINT regiao_pk PRIMARY KEY (idRegiao),
    UNIQUE (nomeRegiao)
);

CREATE TABLE Sala (
    idSala SERIAL NOT NULL,
    IdRegiao INT NOT NULL, 
    
    CONSTRAINT sala_pk PRIMARY KEY (idSala),
    CONSTRAINT regiao_sala_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);

CREATE TABLE ZonaQuarentena (
    IdRegiao INT NOT NULL,
    idZona SERIAL NOT NULL,
    seguranca INT NOT NULL, 
    populacaoAtual INT,

    CONSTRAINT zonaQuarentena_pk PRIMARY KEY (idZona),
    CONSTRAINT regiao_zona_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);

CREATE TABLE Acampamento (
    IdRegiao INT NOT NULL,
    idAcampamento SERIAL NOT NULL,
    defesa INT NOT NULL, 

    CONSTRAINT acampamento_pk PRIMARY KEY (idAcampamento),
    CONSTRAINT regiao_acamp_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);

CREATE TABLE LocalAbandonado (
    IdRegiao INT NOT NULL,
    idLocal SERIAL NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    periculosidade	INT NOT NULL,

    CONSTRAINT local_pk PRIMARY KEY (idLocal),
    CONSTRAINT regiao_local_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);

CREATE TABLE Personagem (
    idPersonagem SERIAL NOT NULL,
    tipoPersonagem INT NOT NULL,

    CONSTRAINT personagem_pk PRIMARY KEY (idPersonagem)
);

CREATE TABLE Inventario (
    idInventario SERIAL NOT NULL,
    capacidade INT NOT NULL,
    descricao VARCHAR (50) NOT NULL,
    
    CONSTRAINT inventario_pk PRIMARY KEY (idInventario)
);


CREATE TABLE Missao (
    idMissao SERIAL NOT NULL,
    tipoMis INT NOT NULL,

    CONSTRAINT missao_pk PRIMARY KEY (idMissao)
);

CREATE TABLE Item (
    idItem SERIAL NOT NULL,
    tipoItem INT NOT NULL,

    CONSTRAINT item_pk PRIMARY KEY (idItem)
);

CREATE TABLE InstItem ( 
    idInstItem SERIAL NOT NULL,
    IdItem INT NOT NULL,
    nomeInstItem VARCHAR (50) NOT NULL,

    CONSTRAINT instItem_pk PRIMARY KEY (idInstItem),
    CONSTRAINT item_inst_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);

CREATE TABLE Itens (
    IdMissao INT NOT NULL,
    IdItem INT NOT NULL,
    
    CONSTRAINT itens_pk PRIMARY KEY (IdMissao, IdItem),
    CONSTRAINT missao_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT itens_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);

CREATE TABLE NPC (
    IdPersonagem INT NOT NULL,
    idNPC SERIAL NOT NULL,
    Sala INT NOT NULL,
    xp INT NOT NULL,
    vidaMax INT NOT NULL,
    vidaAtual INT,
    nomePersonagem VARCHAR(50) NOT NULL,
    IdInventario INT NOT NULL, 
    tipoNPC INT NOT NULL, 

    CONSTRAINT npc_pk PRIMARY KEY (idNPC),
    CONSTRAINT npc_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem),
    CONSTRAINT sala_npc_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala),
    CONSTRAINT inventario_npc_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
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
    descricaoItem VARCHAR (400) NOT NULL,

    CONSTRAINT arma_pk PRIMARY KEY (idArma),
    CONSTRAINT item_arma_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem),
    CONSTRAINT inventario_arma_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);

CREATE TABLE Vestimenta (
    idVestimenta SERIAL NOT NULL,
    IdItem INT NOT NULL,
    nomeVestimenta VARCHAR (50) NOT NULL,
    descricaoItem VARCHAR (400) NOT NULL,
    IdInventario INT NOT NULL,    
    eAtaque BOOLEAN NOT NULL,

    CONSTRAINT vestimenta_pk PRIMARY KEY (idVestimenta),
    CONSTRAINT item_vest_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem),
    CONSTRAINT inventario_vest_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);

CREATE TABLE Consumivel (
    idConsumivel SERIAL NOT NULL,
    IdItem INT NOT NULL,
    nomeConsumivel VARCHAR (50) NOT NULL,
    tipoConsumivel VARCHAR (40) NOT NULL,
    aumentoVida INT,  
    IdInventario  INT NOT NULL,
    eAtaque BOOLEAN NOT NULL,
    descricaoItem VARCHAR (400) NOT NULL,

    CONSTRAINT consumivel_pk PRIMARY KEY (idConsumivel),
    CONSTRAINT item_Consumivel_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem),
    CONSTRAINT inventario_vest_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);

CREATE TABLE Receita (
    idReceita SERIAL NOT NULL,
    nomeReceita VARCHAR (50) NOT NULL,
    descricaoReceita VARCHAR (400) NOT NULL,
    tempoCraft INT NOT NULL, 
    IdItem INT NOT NULL,

    CONSTRAINT receita_pk PRIMARY KEY (idReceita),
    CONSTRAINT item_receita_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);

CREATE TABLE Ingrediente (
    idIngrediente SERIAL NOT NULL,
    IdReceita INT NOT NULL,
    IdItem INT NOT NULL,
    quantidadeIngre INT NOT NULL,

    CONSTRAINT igrediente_pk PRIMARY KEY (idIngrediente),
    CONSTRAINT receita_fk FOREIGN KEY (IdReceita) REFERENCES Receita (idReceita),
    CONSTRAINT item_ingrediente_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);

CREATE TABLE Evolucao (
    idEvolucao SERIAL NOT NULL,
    requisitoNivel INT NOT NULL,
    xpEvol INT NOT NULL,

    CONSTRAINT evolucao_pk PRIMARY KEY (idEvolucao)
);

CREATE TABLE PC (
    IdPersonagem SERIAL NOT NULL,
    idPC SERIAL NOT NULL,
    Sala INT NOT NULL,
    xp INT NOT NULL,
    vidaMax INT NOT NULL,
    vidaAtual INT,
    nomePersonagem VARCHAR (50) NOT NULL,
    estado VARCHAR (20) NOT NULL, 
    Evolucao INT NOT NULL,
    IdInventario INT NOT NULL, 

    CONSTRAINT pc_pk PRIMARY KEY (idPC),
    CONSTRAINT pc_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem),
    CONSTRAINT evolucao_fk FOREIGN KEY (Evolucao) REFERENCES Evolucao (idEvolucao),
    CONSTRAINT inventario_pc_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario),
    CONSTRAINT sala_pc_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala)
);

CREATE TABLE Evento (
    idEvento SERIAL NOT NULL,
    nomeEvento VARCHAR (400) NOT NULL,
    descricao VARCHAR (400) NOT NULL,
    Sala INT NOT NULL,
    IdPC INT NOT NULL,

    CONSTRAINT evento_pk PRIMARY KEY (idEvento),
    CONSTRAINT pc_evento_fk FOREIGN KEY (IdPC) REFERENCES PC (idPC),
    CONSTRAINT sala_evento_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala)
);

CREATE TABLE Itinerario (
    idItinerario SERIAL NOT NULL,
    horario INT NOT NULL,
    dia DATE NOT NULL, 
    IdEvento INT NOT NULL,

    CONSTRAINT itinerario_pk PRIMARY KEY (idItinerario),
    CONSTRAINT evento_itinerario_fk FOREIGN KEY (IdEvento) REFERENCES Evento (idEvento)
);

CREATE TABLE Habilidade (
    idHabilidade SERIAL NOT NULL,
    nomeHabilidade VARCHAR (50) NOT NULL,
    tipoHabilidade VARCHAR (50) NOT NULL, 
    efeito VARCHAR (70) NOT NULL,
    duracaoHabilidade INT NOT NULL,
    IdPC INT NOT NULL,

    CONSTRAINT habilidade_pk PRIMARY KEY (idHabilidade),
    CONSTRAINT pc_habilidade_fk FOREIGN KEY (IdPC) REFERENCES PC (idPC)
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
    CONSTRAINT missaoPatrulha_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT pc_missaoPatrulha_fk FOREIGN KEY (IdPC) REFERENCES PC (idPC)
);

CREATE TABLE MissaoExploracaoObterItem (
    IdMissao INT NOT NULL,
    idMissaoPre INT,
    objetivo VARCHAR (400) NOT NULL,
    nomeMis VARCHAR (50) NOT NULL,
    idExploracao SERIAL NOT NULL,
    IdPC INT NOT NULL,
    xpMis INT NOT NULL, 
    
    CONSTRAINT missaoExploracao_pk PRIMARY KEY (idExploracao),
    CONSTRAINT missaoObter_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT pc_missaoObter_fk FOREIGN KEY (IdPC) REFERENCES PC (idPC)
);

CREATE TABLE Concede (
    IdEvolucao INT NOT NULL,
    IdConsumivel INT NOT NULL,

    CONSTRAINT concede_pk PRIMARY KEY (IdEvolucao, IdConsumivel),
    CONSTRAINT evolucao_fk FOREIGN KEY (IdEvolucao) REFERENCES Evolucao (idEvolucao),
    CONSTRAINT Consumivel_fk FOREIGN KEY (IdConsumivel) REFERENCES Consumivel (idConsumivel)
);

CREATE TABLE Dialoga (
    idDialogo SERIAL NOT NULL,
    IdFalante INT NOT NULL,
    IdOuvinte INT NOT NULL, 
    conteudo VARCHAR (400) NOT NULL,
    duracaoDialogo INT NOT NULL,
    
    CONSTRAINT dialogo_pk PRIMARY KEY (idDialogo),
    CONSTRAINT falante_fk FOREIGN KEY (IdFalante) REFERENCES Personagem (idPersonagem),
    CONSTRAINT ouvinte_fk FOREIGN KEY (IdOuvinte) REFERENCES Personagem (idPersonagem)
);

CREATE TABLE InstNPC (
    IdInstNPC INT NOT NULL,
    tipoNPC INT NOT NULL,

    CONSTRAINT instNPC_pk PRIMARY KEY (IdInstNPC),
    CONSTRAINT npc_inst_fk FOREIGN KEY (IdInstNPC) REFERENCES NPC (idNPC) 
);

CREATE TABLE Infectado (
    IdNPC INT NOT NULL,
    idInfectado SERIAL NOT NULL,
    comportamentoInfec VARCHAR (400) NOT NULL,
    velocidade INT NOT NULL, 

    CONSTRAINT infectado_pk PRIMARY KEY (idInfectado),
    CONSTRAINT npc_infec_fk FOREIGN KEY (IdNPC) REFERENCES NPC (idNPC)
);

CREATE TABLE FaccaoHumana (
    IdNPC INT NOT NULL,
    idFaccao SERIAL NOT NULL,
    nomeFaccao VARCHAR (50) NOT NULL,

    CONSTRAINT faccao_pk PRIMARY KEY (idFaccao),
    CONSTRAINT npc_facc_fk FOREIGN KEY (IdNPC) REFERENCES NPC (idNPC)
);

CREATE TABLE Animal (
    IdNPC INT NOT NULL,
    idAnimal SERIAL NOT NULL,
    nomeAnimal VARCHAR (50) NOT NULL,
    ameaca VARCHAR (100) NOT NULL,

    CONSTRAINT animal_pk PRIMARY KEY (idAnimal),
    CONSTRAINT npc_animal_fk FOREIGN KEY (IdNPC) REFERENCES NPC (idNPC)
);

CREATE TABLE Participacao (
    IdNPC INT NOT NULL,
    Evento INT NOT NULL,
    Missao INT NOT NULL,

    CONSTRAINT participacao_pk PRIMARY KEY (IdNPC, Evento, Missao),
    CONSTRAINT npc_part_fk FOREIGN KEY (IdNPC) REFERENCES NPC (idNPC),
    CONSTRAINT evento_part_fk FOREIGN KEY (Evento) REFERENCES Evento (idEvento),
    CONSTRAINT missao_part_fk FOREIGN KEY (Missao) REFERENCES Missao (idMissao)
);
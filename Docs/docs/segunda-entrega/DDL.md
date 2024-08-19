---
sidebar_position: 1
sidebar_label: "Data Definition Language"
---

# O que é DDL?

O DDL (Data Definition Language) é um subconjunto da linguagem SQL (Structured Query Language) usado para definir e gerenciar estruturas de dados em bancos de dados relacionais. Ele é responsável pela criação, alteração e exclusão de objetos como tabelas, índices, e esquemas dentro do banco de dados. As operações de DDL não manipulam diretamente os dados, mas sim a estrutura que os organiza.

# Descrição das Tabelas e Entidades


## Regiao
A tabela `Regiao` representa uma região geográfica ou administrativa no sistema.
```sql
CREATE TABLE Regiao (
    idRegiao SERIAL NOT NULL,
    descricaoRegiao VARCHAR (400) NOT NULL,
    nomeRegiao VARCHAR (50) NOT NULL,
    capacidade INT,
    tipoRegiao INT,

    CONSTRAINT regiao_pk PRIMARY KEY (idRegiao),
    UNIQUE (nomeRegiao)
);
```
- **Colunas**:
  - `idRegiao`: Identificador único da região (chave primária).
  - `descricaoRegiao`: Descrição detalhada da região.
  - `nomeRegiao`: Nome da região (deve ser único).
  - `capacidade`: Capacidade da região.
  - `tipoRegiao`: Tipo da região.

## Sala
A tabela `Sala` representa uma sala ou compartimento dentro de uma região.
```sql
CREATE TABLE Sala (
    idSala SERIAL NOT NULL,
    IdRegiao INT NOT NULL, 
    
    CONSTRAINT sala_pk PRIMARY KEY (idSala),
    CONSTRAINT regiao_sala_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);
```
- **Colunas**:
  - `idSala`: Identificador único da sala (chave primária).
  - `IdRegiao`: Identificador da região à qual a sala pertence (chave estrangeira referenciando `Regiao`).

## ZonaQuarentena
A tabela `ZonaQuarentena` representa uma zona de quarentena dentro de uma região.
```sql
CREATE TABLE ZonaQuarentena (
    IdRegiao INT NOT NULL,
    seguranca INT NOT NULL, 
    populacaoAtual INT,

    CONSTRAINT zonaQuarentena_pk PRIMARY KEY (IdRegiao),
    CONSTRAINT regiao_zona_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);
```
- **Colunas**:
  - `IdRegiao`: Identificador da região (chave primária e estrangeira).
  - `seguranca`: Nível de segurança da zona de quarentena.
  - `populacaoAtual`: População atual na zona de quarentena.

## Acampamento
A tabela `Acampamento` representa um acampamento dentro de uma região.
```sql
CREATE TABLE Acampamento (
    IdRegiao INT NOT NULL,
    defesa INT NOT NULL, 

    CONSTRAINT acampamento_pk PRIMARY KEY (IdRegiao),
    CONSTRAINT regiao_acamp_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);
```
- **Colunas**:
  - `IdRegiao`: Identificador da região (chave primária e estrangeira).
  - `defesa`: Nível de defesa do acampamento.

## LocalAbandonado
A tabela `LocalAbandonado` representa um local abandonado dentro de uma região.
```sql
CREATE TABLE LocalAbandonado (
    IdRegiao INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    periculosidade INT NOT NULL,

    CONSTRAINT local_pk PRIMARY KEY (IdRegiao),
    CONSTRAINT regiao_local_fk FOREIGN KEY (IdRegiao) REFERENCES Regiao (idRegiao)
);
```
- **Colunas**:
  - `IdRegiao`: Identificador da região (chave primária e estrangeira).
  - `tipo`: Tipo de local abandonado.
  - `periculosidade`: Nível de periculosidade do local.

## Personagem
A tabela `Personagem` representa um personagem no sistema.
```sql
CREATE TABLE Personagem (
    idPersonagem SERIAL NOT NULL,
    tipoPersonagem INT NOT NULL,

    CONSTRAINT personagem_pk PRIMARY KEY (idPersonagem)
);
```
- **Colunas**:
  - `idPersonagem`: Identificador único do personagem (chave primária).
  - `tipoPersonagem`: Tipo do personagem.

## Inventario
A tabela `Inventario` representa um inventário de itens.
```sql
CREATE TABLE Inventario (
    idInventario SERIAL NOT NULL,
    capacidade INT NOT NULL,
    descricao VARCHAR (50) NOT NULL,

    CHECK (capacidade >= 0),
    
    CONSTRAINT inventario_pk PRIMARY KEY (idInventario)
);
```
- **Colunas**:
  - `idInventario`: Identificador único do inventário (chave primária).
  - `capacidade`: Capacidade do inventário.
  - `descricao`: Descrição do inventário.

## Missao
A tabela `Missao` representa uma missão no sistema.
```sql
CREATE TABLE Missao (
    idMissao SERIAL NOT NULL,
    tipoMis INT NOT NULL,

    CONSTRAINT missao_pk PRIMARY KEY (idMissao)
);
```
- **Colunas**:
  - `idMissao`: Identificador único da missão (chave primária).
  - `tipoMis`: Tipo da missão.

## Item
A tabela `Item` representa um item genérico.
```sql
CREATE TABLE Item (
    idItem SERIAL NOT NULL,
    tipoItem INT NOT NULL,

    CONSTRAINT item_pk PRIMARY KEY (idItem)
);
```
- **Colunas**:
  - `idItem`: Identificador único do item (chave primária).
  - `tipoItem`: Tipo do item.

## InstItem
A tabela `InstItem` representa uma instância específica de um item.
```sql
CREATE TABLE InstItem ( 
    idInstItem SERIAL NOT NULL,
    IdItem INT NOT NULL,

    CONSTRAINT instItem_pk PRIMARY KEY (idInstItem),
    CONSTRAINT item_inst_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);
```
- **Colunas**:
  - `idInstItem`: Identificador único da instância do item (chave primária).
  - `IdItem`: Identificador do item genérico (chave estrangeira referenciando `Item`).

## Itens
A tabela `Itens` representa a associação entre missões e itens.
```sql
CREATE TABLE Itens (
    IdMissao INT NOT NULL,
    IdItem INT NOT NULL,
    
    CONSTRAINT itens_pk PRIMARY KEY (IdMissao, IdItem),
    CONSTRAINT missao_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT itens_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);
```
- **Colunas**:
  - `IdMissao`: Identificador da missão (chave primária e estrangeira).
  - `IdItem`: Identificador do item (chave primária e estrangeira).

## NPC
A tabela `NPC` representa um personagem não jogável no sistema.
```sql
CREATE TABLE NPC (
    IdPersonagem INT NOT NULL,
    Sala INT NOT NULL,
    xp INT NOT NULL,
    vidaMax INT NOT NULL,
    vidaAtual INT,
    nomePersonagem VARCHAR(50) NOT NULL,
    IdInventario INT, 
    tipoNPC INT NOT NULL, 

    CHECK (vidaAtual > 0),

    CONSTRAINT npc_pk PRIMARY KEY (IdPersonagem),
    CONSTRAINT npc_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem),
    CONSTRAINT sala_npc_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala),
    CONSTRAINT inventario_npc_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);
```
- **Colunas**:
  - `IdPersonagem`: Identificador do personagem (chave primária e estrangeira).
  - `Sala`: Identificador da sala onde o NPC está localizado (chave estrangeira).
  - `xp`: Experiência do NPC.
  - `vidaMax`: Vida máxima do NPC.
  - `vidaAtual`: Vida atual do NPC (deve ser maior que 0).
  - `nomePersonagem`: Nome do NPC.
  - `IdInventario`: Identificador do inventário do NPC (chave estrangeira).
  - `tipoNPC`: Tipo de NPC.

## Arma
A tabela `Arma` representa um item do tipo arma no sistema.
```sql
CREATE TABLE Arma (
    IdItem INT NOT NULL,
    nomeItem VARCHAR (50) NOT NULL,
    dano INT NOT NULL,
    municaoAtual INT,
    municaoMax INT NOT NULL,
    IdInventario INT,    
    eAtaque BOOLEAN NOT NULL,
    descricaoItem VARCHAR (400) NOT NULL,

    CONSTRAINT arma_pk PRIMARY KEY (IdItem),
    CONSTRAINT item_arma_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem),
    CONSTRAINT inventario_arma_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);
```
- **Colunas**:
  - `IdItem`: Identificador do item (chave primária e estrangeira).
  - `nomeItem`: Nome da arma.
  - `dano`: Dano causado pela arma.
  - `municaoAtual`: Munição atual disponível na arma.
  - `municaoMax`: Capacidade máxima de munição da arma.
  - `IdInventario`: Identificador do inventário que contém a arma (chave estrangeira).
  - `eAtaque`: Indica se a arma é usada para ataque.
  - `descricaoItem`: Descrição detalhada da arma.

## Vestimenta
A tabela `Vestimenta` representa um item de vestimenta no sistema.
```sql
CREATE TABLE Vestimenta (
    IdItem INT NOT NULL,
    nomeItem VARCHAR (50) NOT NULL,
    descricaoItem VARCHAR (400) NOT NULL

,
    protecao INT NOT NULL,    
    IdInventario INT,
    tipoVestimenta INT NOT NULL,

    CONSTRAINT vestimenta_pk PRIMARY KEY (IdItem),
    CONSTRAINT item_vestimenta_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem),
    CONSTRAINT inventario_vestimenta_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);
```
- **Colunas**:
  - `IdItem`: Identificador do item (chave primária e estrangeira).
  - `nomeItem`: Nome da vestimenta.
  - `descricaoItem`: Descrição detalhada da vestimenta.
  - `protecao`: Nível de proteção oferecido pela vestimenta.
  - `IdInventario`: Identificador do inventário que contém a vestimenta (chave estrangeira).
  - `tipoVestimenta`: Tipo de vestimenta.

## Consumivel
A tabela `Consumivel` representa um item consumível no sistema.
```sql
CREATE TABLE Consumivel (
    IdItem INT NOT NULL,
    nomeItem VARCHAR (50) NOT NULL,
    descricaoItem VARCHAR (400) NOT NULL,
    duracao INT NOT NULL,    
    IdInventario INT,
    tipoConsumivel INT NOT NULL,

    CONSTRAINT consumivel_pk PRIMARY KEY (IdItem),
    CONSTRAINT item_consumivel_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem),
    CONSTRAINT inventario_consumivel_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario)
);
```
- **Colunas**:
  - `IdItem`: Identificador do item (chave primária e estrangeira).
  - `nomeItem`: Nome do consumível.
  - `descricaoItem`: Descrição detalhada do consumível.
  - `duracao`: Duração do efeito do consumível.
  - `IdInventario`: Identificador do inventário que contém o consumível (chave estrangeira).
  - `tipoConsumivel`: Tipo de consumível.


### **Receita**
A tabela `Receita` armazena informações sobre receitas usadas para criar novos itens no sistema.
```sql
CREATE TABLE Receita (
    idReceita SERIAL NOT NULL,
    nomeReceita VARCHAR (50) NOT NULL,
    descricaoReceita VARCHAR (400) NOT NULL,
    tempoCraft INT NOT NULL,
    IdItem INT NOT NULL,

    CONSTRAINT receita_pk PRIMARY KEY (idReceita),
    CONSTRAINT item_receita_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);
```
- **Colunas**:
  - `idReceita`: Identificador da receita (chave primária).
  - `nomeReceita`: Nome da receita.
  - `descricaoReceita`: Descrição detalhada da receita.
  - `tempoCraft`: Tempo necessário para criar o item.
  - `IdItem`: Identificador do item resultante da receita (chave estrangeira).

### **Ingrediente**
A tabela `Ingrediente` representa os ingredientes necessários para criar um item através de uma receita.
```sql
CREATE TABLE Ingrediente (
    idIngrediente SERIAL NOT NULL,
    IdReceita INT NOT NULL,
    IdItem INT NOT NULL,
    quantidadeIngre INT NOT NULL,

    CONSTRAINT ingrediente_pk PRIMARY KEY (idIngrediente),
    CONSTRAINT receita_fk FOREIGN KEY (IdReceita) REFERENCES Receita (idReceita),
    CONSTRAINT item_ingrediente_fk FOREIGN KEY (IdItem) REFERENCES Item (idItem)
);
```
- **Colunas**:
  - `idIngrediente`: Identificador do ingrediente (chave primária).
  - `IdReceita`: Identificador da receita que usa este ingrediente (chave estrangeira).
  - `IdItem`: Identificador do item usado como ingrediente (chave estrangeira).
  - `quantidadeIngre`: Quantidade do ingrediente necessário.

### **Evolucao**
A tabela `Evolucao` armazena os níveis de evolução e a experiência necessária para alcançar cada nível.
```sql
CREATE TABLE Evolucao (
    idEvolucao SERIAL NOT NULL,
    requisitoNivel INT NOT NULL,
    xpEvol INT NOT NULL,

    CONSTRAINT evolucao_pk PRIMARY KEY (idEvolucao)
);
```
- **Colunas**:
  - `idEvolucao`: Identificador da evolução (chave primária).
  - `requisitoNivel`: Nível necessário para alcançar esta evolução.
  - `xpEvol`: Experiência necessária para alcançar esta evolução.

### **PC**
A tabela `PC` armazena informações sobre personagens no jogo.
```sql
CREATE TABLE PC (
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

    CONSTRAINT pc_pk PRIMARY KEY (IdPersonagem),
    CONSTRAINT pc_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem),
    CONSTRAINT evolucao_fk FOREIGN KEY (Evolucao) REFERENCES Evolucao (idEvolucao),
    CONSTRAINT inventario_pc_fk FOREIGN KEY (IdInventario) REFERENCES Inventario (idInventario),
    CONSTRAINT sala_pc_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala)
);
```
- **Colunas**:
  - `IdPersonagem`: Identificador do personagem (chave primária).
  - `Sala`: Sala onde o personagem está localizado (chave estrangeira).
  - `xp`: Experiência do personagem.
  - `vidaMax`: Vida máxima do personagem.
  - `vidaAtual`: Vida atual do personagem.
  - `nomePersonagem`: Nome do personagem.
  - `estado`: Estado atual do personagem.
  - `Evolucao`: Nível de evolução do personagem (chave estrangeira).
  - `IdInventario`: Identificador do inventário do personagem (chave estrangeira).

### **Evento**
A tabela `Evento` representa eventos que ocorrem no jogo.
```sql
CREATE TABLE Evento (
    idEvento SERIAL NOT NULL,
    nomeEvento VARCHAR (400) NOT NULL,
    descricao VARCHAR (400) NOT NULL,
    Sala INT NOT NULL,
    IdPersonagem INT NOT NULL,

    CONSTRAINT evento_pk PRIMARY KEY (idEvento),
    CONSTRAINT personagem_evento_fk FOREIGN KEY (IdPersonagem) REFERENCES PC (IdPersonagem),
    CONSTRAINT sala_evento_fk FOREIGN KEY (Sala) REFERENCES Sala (idSala)
);
```
- **Colunas**:
  - `idEvento`: Identificador do evento (chave primária).
  - `nomeEvento`: Nome do evento.
  - `descricao`: Descrição detalhada do evento.
  - `Sala`: Sala onde o evento ocorre (chave estrangeira).
  - `IdPersonagem`: Identificador do personagem associado ao evento (chave estrangeira).

### **Itinerario**
A tabela `Itinerario` armazena os horários e datas de eventos.
```sql
CREATE TABLE Itinerario (
    idItinerario SERIAL NOT NULL,
    horario INT NOT NULL,
    dia DATE NOT NULL,
    IdEvento INT NOT NULL,

    CONSTRAINT itinerario_pk PRIMARY KEY (idItinerario),
    CONSTRAINT evento_itinerario_fk FOREIGN KEY (IdEvento) REFERENCES Evento (idEvento)
);
```
- **Colunas**:
  - `idItinerario`: Identificador do itinerário (chave primária).
  - `horario`: Hora do evento.
  - `dia`: Data do evento.
  - `IdEvento`: Identificador do evento associado (chave estrangeira).

### **Habilidade**
A tabela `Habilidade` armazena as habilidades dos personagens.
```sql
CREATE TABLE Habilidade (
    idHabilidade SERIAL NOT NULL,
    nomeHabilidade VARCHAR (50) NOT NULL,
    tipoHabilidade VARCHAR (50) NOT NULL,
    efeito VARCHAR (70) NOT NULL,
    duracaoHabilidade INT NOT NULL,
    IdPersonagem INT NOT NULL,

    CONSTRAINT habilidade_pk PRIMARY KEY (idHabilidade),
    CONSTRAINT pc_habilidade_fk FOREIGN KEY (IdPersonagem) REFERENCES PC (IdPersonagem)
);
```
- **Colunas**:
  - `idHabilidade`: Identificador da habilidade (chave primária).
  - `nomeHabilidade`: Nome da habilidade.
  - `tipoHabilidade`: Tipo de habilidade (por exemplo, passiva ou ativa).
  - `efeito`: Efeito da habilidade.
  - `duracaoHabilidade`: Duração da habilidade.
  - `IdPersonagem`: Identificador do personagem que possui a habilidade (chave estrangeira).

### **MissaoPatrulha**
A tabela `MissaoPatrulha` armazena missões de patrulha realizadas pelos personagens.
```sql
CREATE TABLE MissaoPatrulha (
    IdMissao INT NOT NULL,
    idMissaoPre INT,
    objetivo VARCHAR (400) NOT NULL,
    nomeMis VARCHAR (50) NOT NULL,
    qtdNPCs INT NOT NULL,
    IdPersonagem INT NOT NULL,
    xpMis INT NOT NULL,
    statusMissao BOOLEAN NOT NULL,

    CONSTRAINT missaoPatrulha_pk PRIMARY KEY (IdMissao),
    CONSTRAINT missaoPatrulha_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT pc_missaoPatrulha_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem)
);
```
- **Colunas**:
  - `IdMissao`: Identificador da missão (chave primária).
  - `idMissaoPre`: Identificador da missão anterior (chave estrangeira opcional).
  - `objetivo`: Objetivo da missão.
  - `nomeMis`: Nome da missão.
  - `qtdNPCs`: Quantidade de NPCs envolvidos na missão.
  - `IdPersonagem`: Identificador do personagem responsável pela missão (chave estrangeira).
  - `xpMis`: Experiência concedida pela missão.
  - `statusMissao`: Status da missão (completa ou não).

### **MissaoExploracaoObterItem**
A tabela `MissaoExploracaoObterItem` armazena missões de exploração para obter itens.
```sql
CREATE TABLE MissaoExploracaoObterItem(
    IdMissao INT NOT NULL,
    idMissaoPre INT,
    objetivo VARCHAR (400) NOT NULL,
    nomeMis VARCHAR (50) NOT NULL,
    IdPersonagem INT NOT NULL,
    xpMis INT NOT NULL,
    statusMissao BOOLEAN NOT NULL,

    CONSTRAINT missaoExploracao_pk PRIMARY KEY (IdMissao),
    CONSTRAINT missaoObter_fk FOREIGN KEY (IdMissao) REFERENCES Missao (idMissao),
    CONSTRAINT pc_missaoObter_fk FOREIGN KEY (IdPersonagem) REFERENCES Personagem (idPersonagem)
);
```
- **Colunas**:
  - `IdMissao`: Identificador da missão (chave primária).
  - `idMissaoPre`: Identificador da missão anterior (chave estrangeira opcional).
  - `objetivo`: Objetivo da missão.
  - `nomeMis`: Nome da missão.
  - `IdPersonagem`: Identificador do personagem responsável pela missão (chave estrangeira).
  - `xpMis`: Experiência concedida pela missão.
  - `statusMissao`: Status da missão (completa ou não).

### **Concede**
A tabela `Concede` relaciona evoluções com consumíveis que podem ser concedidos durante a evolução.
```sql
CREATE TABLE Concede (
    IdEvolucao INT NOT NULL,
    IdConsumivel INT NOT NULL,

    CONSTRAINT concede_pk PRIMARY KEY (IdEvolucao, IdConsumivel),
    CONSTRAINT evolucao_fk FOREIGN KEY (IdEvolucao) REFERENCES Evolucao (idEvolucao),
    CONSTRAINT Consumivel_fk FOREIGN KEY (IdConsumivel) REFERENCES Consumivel (IdItem)
);
```
- **Colunas**:
  - `IdEvolucao`: Identificador da evolução (chave primária composta).
  - `IdConsumivel`: Identificador do consumível concedido (chave primária composta e chave estrangeira).

### **Dialoga**
A tabela `Dialoga` representa diálogos entre personagens.
```sql
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
```
- **Colunas**:
  - `idDialogo`: Identificador do diálogo (chave primária).
  - `IdFalante`: Identificador do personagem que está falando (chave estrangeira).
  - `IdOuvinte`: Identificador do personagem que está ouvindo (chave estrangeira).
  - `conteudo`: Conteúdo do diálogo.
  - `duracaoDialogo`: Duração do diálogo.

### **InstNPC**
A tabela `InstNPC` representa instâncias de NPCs com tipos específicos.
```sql
CREATE TABLE InstNPC (
    IdInstNPC SERIAL NOT NULL,
    tipoNPC INT NOT NULL,

    CONSTRAINT instNPC_pk PRIMARY KEY (IdInstNPC),
    CONSTRAINT npc_inst_fk FOREIGN KEY (tipoNPC) REFERENCES NPC (IdPersonagem)
);
```
- **Colunas**:
  - `IdInstNPC`: Identificador da instância do NPC (chave primária).
  - `tipoNPC`: Tipo de NPC (chave estrangeira).

### **Infectado**
A tabela `Infectado` armazena informações sobre NPCs infectados.
```sql
CREATE TABLE Infectado (
    IdNPC INT NOT NULL,
    comportamentoInfec VARCHAR (400) NOT NULL,
    velocidade INT NOT NULL,

    CONSTRAINT infectado_pk PRIMARY KEY (IdNPC),
    CONSTRAINT npc_infec_fk FOREIGN KEY (IdNPC) REFERENCES NPC (IdPersonagem)
);
```
- **Colunas**:
  - `IdNPC`: Identificador do NPC infectado (chave primária e chave estrangeira).
  - `comportamentoInfec`: Comportamento do NPC infectado.
  - `velocidade`: Velocidade do NPC infectado.

### **FaccaoHumana**
A tabela `FaccaoHumana` armazena informações sobre facções humanas associadas a NPCs.
```sql
CREATE TABLE FaccaoHumana (
    IdNPC INT NOT NULL,
    nomeFaccao VARCHAR (50) NOT NULL,

    CONSTRAINT faccao_pk PRIMARY KEY (IdNPC),
    CONSTRAINT npc_facc_fk FOREIGN KEY (IdNPC) REFERENCES NPC (IdPersonagem)
);
```
- **Colunas**:
  - `IdNPC`: Identificador do NPC associado à facção (chave primária e chave estrangeira).
  - `nomeFaccao`: Nome da facção humana.

### **Animal**
A tabela `Animal` armazena informações sobre animais NPCs.
```sql
CREATE TABLE Animal (
    IdNPC INT NOT NULL,
    nomeAnimal VARCHAR (50) NOT NULL,
    ameaca VARCHAR (100) NOT NULL,

    CONSTRAINT animal_pk PRIMARY KEY (IdNPC),
    CONSTRAINT npc_animal_fk FOREIGN KEY (IdNPC) REFERENCES NPC (IdPersonagem)
);
```
- **Colunas**:
  - `IdNPC`: Identificador do NPC animal (chave primária e chave estrangeira).
  - `nomeAnimal`: Nome do animal.
  - `ameaca`: Nível de ameaça representado pelo animal.

### **Participacao**
A tabela `Participacao` registra a participação de NPCs em eventos e missões.
```sql
CREATE TABLE Participacao (
    IdNPC INT NOT NULL,
    Evento INT NOT NULL,
    Missao INT NOT NULL,

    CONSTRAINT participacao_pk PRIMARY KEY (IdNPC, Evento, Missao),
    CONSTRAINT npc_part_fk FOREIGN KEY (IdNPC) REFERENCES NPC (IdPersonagem),
    CONSTRAINT evento_part_fk FOREIGN KEY (Evento) REFERENCES Evento (idEvento),
    CONSTRAINT missao_part_fk FOREIGN KEY (Missao) REFERENCES Missao (idMissao)
);
```
- **Colunas**:
  - `IdNPC`: Identificador do NPC (chave primária composta e chave estrangeira).
  - `Evento`: Identificador do evento em que o NPC participa (chave primária composta e chave estrangeira).
  - `Missao`: Identificador da missão em que o NPC participa (chave primária composta e chave estrangeira).



---
sidebar_position: 2
sidebar_label: "Modelo Entidade-Relacionamento"
---

# MER - Modelo Entidade Relacionamento

O Modelo Entidade Relacionamento de um banco de dados é um modelo conceitual que descreve as entidades de um domínio de negócios, com seus atributos e seus relacionamentos.

## 1. Entidades

- **Mundo**
- **Região**
- **Zona de Quarentena**
- **Acampamento**
- **Locais Abandonados**
- **Personagem**
- **PC (Playable Character)**
- **NPC (Non-Playable Character)**
- **Inst_NPC**
  - **Infectados**
  - **Facções Humanas**
  - **Animais**
- **Habilidade**
- **Inventário**
- **Inst_Item**
  - **Armas**
  - **Vestimenta**
  - **Alimento**
- **Receita**
- **Ingrediente**
- **Missão**
  - **Missão Patrulha**
  - **Missão de Exploração/Obter Item**
- **Evento**
- **Itinerário**
- **Evolução**


## 2. Relacionamentos que possuem atributos

- **Concede**
- **Dialoga**
- **Participação**

## 3. Atributos

- **Mundo**: <ins>idMundo</ins>, descricaoMundo, nomeMundo
- **Região**: <ins>idRegiao</ins>, descricaoRegiao, coordenadaX, coordenadaY, nomeRegiao, tipoRegiao, capacidade, idMundo
- **Zona de Quarentena**: <ins>idZona</ins>, idRegiao, seguranca, populacaoAtual
- **Acampamento**: <ins>idAcampamento</ins>, idRegiao, defesa
- **Locais Abandonados**: <ins>idLocal</ins>, idRegiao, periculosidade, nivelInfestacao
- **Personagem**: <ins>idPersonagem</ins>, tipoPersonagem
- **PC (Playable Character)**: <ins>idPC</ins>, idPersonagem, locEmX, locEmY, xp, saude, vidaMax, vidaAtual, nomePersonagem, estado, Evolucao, Mundo, id_Invetario
- **NPC (Non-Playable Character)**: <ins>idNPC</ins>, idPersonagem, locEmX, locEmY, xp, saude, vidaMax, vidaAtual, nomePersonagem, Loot, eAliado, Mundo, id_Inventario
- **Inst_NPC**: <ins>idNP</ins>, tipoNPC,
  - **Infectados**: <ins>idInfectado</ins>, comportamentoInfec, idInfectado,
  - **Facção Humanas**: <ins>idFacção</ins>, idNPC, nomeFacção
  - **Animais**: <ins>idAnimal</ins>, idNPC, nomeAnimal, nomeAnimal, ameaca
- **Habilidade**: <ins>idHabilidade</ins>, nomeHabilidade, tipoHabilidade, efeito, duracaoHabilidade, idPC
- **Inventário**: <ins>idInventario</ins>, descricao, capacidadeInvent
- **Inst_Item**: <ins>idItem</ins>, tipoItem
  - **Armas**: <ins>idArma</ins>, idItem, nomeArma, dano, municaoAtual, municaoMax, idInvetario, eAtaque
  - **Vestimenta**: <ins>idVestimenta</ins>, idItem, nomeVestimenta, descricaoVestimenta, idInventario, eAtaque
  - **Alimento**: <ins>idAlimento</ins>, idItem, nomeAlimento, tipoAlimento, aumentoVida, idIventario, eAtaque
- **Receita**: <ins>idReceita</ins>, nomeReceita, descricaoReceita, tempoCraft, idItem
- **Ingredientes**: <ins>idIngrediente</ins>, idReceita, idItem, quantidadeIngre
- **Missão**: <ins>idMissao</ins>, tipoMis
  - **Missão de Patrulha**:<ins>idPatrulha</ins>, idMissao, idMissaoPre, objetivo, nomeMis, qtdNPCs, idPC, xpMis 
  - **Missão de Expedição/Encontrar Item**:<ins>idExploracao</ins>, idMissao, idMissaoPre, objetivo, nomeMis, ItensAdquiridos, idPc, xpMis
- **Evento**: <ins>idEvento</ins>, nomeEvento, descricao, locEmX, locEmY, idPC
- **Itinerário**: <ins>idItinerario</ins>, horario, dia, idEvento
- **Evolução**: <ins>idEvolucao</ins>, requisitosNivel, xpEvol

#### Atributos de relacionamentos
- **concede**: <ins>idEvolucao, idAlimento</ins>,
- **dialoga**: <ins>idDialogo</ins>, idFalante, idOuvinte, conteudo,  duracaoDialogo,
- **participação**: <ins>idNPC, Evento, Missao</ins>

## 4. Relacionamentos

**Mundo _possui_ Região**

- O mundo possui uma ou várias regiões (1,N)
- A região pertence a um único mundo (1,1)

**Região _classificado como_ Zona de Quarentena**

- Uma região pode ser classificado como uma Zona de Quarentena (0,1)
- A Zona de Quarentena pertence a uma única região (1,1)

**Região _classificado como_ Acampamento**

- Uma região pode ser classificado como um Acampamento (0,1)
- O Acampamento pertence a uma única região (1,1)

**Região _classificado como_ Locais Abandonados**

- Uma região pode ser classificado como um local abandonado (0,1)
- O local abandonado pertence a uma única região (1,1)

**Personagem _se situa_ no Mundo**

- O personagem está em um único mundo (1,1)
- O mundo pode conter nenhum ou vários personagens (0,N)

**PC _possui_ Habilidade**

- O PC possui uma ou várias habilidades (1,N)
- Cada habilidade pertence a um único PC (1,1)

**PC _tem_ Inventário**

- O PC tem um único inventário (1,1)
- Cada inventário pertence a um único PC (1,1)

**PC _tem_ Evolucao**

- O PC tem uma Evolução no decorrer do jogo (1,1)
- Cada Evolução pertence a um único PC (1,1)

**Inventário _contém_ Inst_Item**

- O inventário contém um ou vários itens (1,N)
- Cada item pertence a um único inventário (1,1)

**Inst_Item _classificado como_ Armas**

- Uma instância de item pode ser classificado como uma arma (1,1)
- A arma pertence a uma instância de item(1,1)

**Inst_Item _classificado como_ Vestimenta**

- Uma instância de item pode ser classificado como uma vestimenta (1,1)
- A vestimenta pertence a uma instância de item (1,1)

**Inst_Item _classificado como_ Alimento**

- Uma instância de item pode ser classificado como um alimento (1,1)
- O alimento pertence a uma instância de item (1,1)

**Inst_Item _possui_ Receita**

- Uma instância de item possui uma receita de fabricação (1,1)
- Cada Receita pertence a uma instância de item (1,1)

**Receita _possui_ Ingrediente**

- Cada Receita de item possui vários ingredientes (1,N)
- Cada Ingrediente pertence a uma receita (1,1)

**PC e NPC _realiza_ Missão**

- Um PC e NPC realiza várias missões (1,N)
- Cada missão é realizada por um PCs (1,1)
- Cada missão é realizada por vários NPCs (1,N)

**Missão _classificado em_ Missão Patrulha**

- Uma missão pode ser classificado em Missão de Patrulha (1,1)
- A Missão de Patrulha pertence a uma única Missão (1,1)

**Missão _classificado em_ Missão de Exploração/obter item**

- Uma missão pode ser classificado em Missão de Exploração/obter item (1,1)
- A Missão de Exploração/obter item pertence a uma única Missão (1,1)

**Personagem _fala_ Dialogo**

- Um Personagem fala nenhum ou vários diálogos (0,N)
- Cada diálogo pertence a um único Personagem (1,1)

**Personagem _participa_ em Evento**

- Um Personagem interage com nenhum ou vários eventos (0,N)
- Cada evento é interagido por um ou vários Personagem (1,N)

**Evento _tem_ Itinerário**

- Um evento tem um único itinerário (1,1)
- Cada itinerário pertence a um único evento (1,1)

**Inst_NPC _classificado em_ Infectado**

- Uma instância de NPC pode ser classificado em Infectado (0,1)
- O Infectado pertence a uma única instância de NPC(1,1)

**Inst_NPC _classificado em_ Faccao Humana**

- Uma instância de NPC pode ser classificado em Faccao Humana (0,1)
- A Faccao Humana pertence a uma única instância de NPC(1,1)

**Inst_NPC _classificado em_ Animal**

- Uma instância de NPC pode ser classificado em Animal (0,1)
- O Animal pertence a uma única instância de NPC(1,1)


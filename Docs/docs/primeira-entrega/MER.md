---
sidebar_position: 2
sidebar_label: "Modelo Entidade-Relacionamento"
---

# MER - Modelo Entidade Relacionamento

O Modelo Entidade Relacionamento de um banco de dados é um modelo conceitual que descreve as entidades de um domínio de negócios, com seus atributos e seus relacionamentos.

## 1. Entidades

- **Sala**
- **Região**
- **Personagem**
    - **NPC**
    - **PC (Playable Character)**
- **NPC**
  - **Infectados**
  - **Facções Humanas**
  - **Animais**
  - **InstNPC**
- **Habilidade**
- **Inventário**
- **Item**
    -**InstItem**
    -**Armas**
    -**Vestimenta**
    -**Consumível**
- **Itens**
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

- **Sala**: <ins>idSala</ins>, IdRegiao
- **Região**: <ins>idRegiao</ins>, descricaoRegiao, nomeRegiao, tipoRegiao, capacidade, z_seguranca, z_populacaoAtual, a_defesa, l_tipo, l_periculosidade
- **Personagem**: <ins>idPersonagem</ins>, tipoPersonagem
- **PC (Playable Character)**: <ins>idPersonagem</ins>, xp, vidaMax, vidaAtual, nomePersonagem, estado, Evolucao, IdInventario, Sala
- **NPC (Non-Playable Character)**: <ins>idPersonagem</ins>, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, tipoNPC, eAliado
  - **Infectados**: <ins>idNPC</ins>, comportamentoInfec, danoInfectado, velocidade
  - **Facção Humanas**: <ins>idNPC</ins>, nomeFacção
  - **Animais**: <ins>idNPC</ins>, nomeAnimal, danoAnimal, ameaca
- **InstNPC**: <ins>idInstNPC</ins>, tipoNPC, Sala, idNPC
- **Habilidade**: <ins>idHabilidade</ins>, nomeHabilidade, tipoHabilidade, efeito, duracaoHabilidade, idPersonagem
- **Inventário**: <ins>idInventario</ins>, descricao, capacidadeInvent
- **Item**: <ins>idItem</ins>, tipoItem
  - **Armas**: <ins>idItem</ins>, nomeItem, dano, municaoAtual, municaoMax, descricaoItem, eAtaque
  - **Vestimenta**: <ins>idItem</ins>, nomeItem, descricaoVestimenta, defesa, eAtaque
  - **Consumível**: <ins>idItem</ins>, nomeItem, tipoConsumivel, aumentoVida, descricaoItem, eAtaque, danoConsumivel
- **Receita**: <ins>idReceita</ins>, nomeReceita, descricaoReceita, tempoCraft, idItem, juncao
- **Ingredientes**: <ins>idIngrediente</ins>, idReceita, idItem, quantidadeIngre
- **InstItem**: <ins>idInstItem</ins>, Iditem, Sala, IdInventario
- **Itens** <ins>IdItem</ins>, IdMissao
- **Missão**: <ins>idMissao</ins>, tipoMis
  - **Missão de Patrulha**:<ins>idMissao</ins>, idMissaoPre, objetivo, nomeMis, qtdNPCs, idPersonagem, xpMis, statusMissao, Sala 
  - **Missão de Expedição/Encontrar Item**:<ins>idMissao</ins>, idMissaoPre, objetivo, nomeMis, idPersonagem, xpMis, Sala, statusMissao
- **Evento**: <ins>idEvento</ins>, nomeEvento, descricao, Sala, IdPersonagem
- **Itinerário**: <ins>idItinerario</ins>, horario, dia, idEvento
- **Evolução**: <ins>idEvolucao</ins>, requisitosNivel, xpEvol

#### Atributos de relacionamentos
- **concede**: <ins>idEvolucao, IdConsumivel</ins>,
- **dialoga**: <ins>idDialogo</ins>, idFalante, idOuvinte, conteudo,  duracaoDialogo,
- **participação**: <ins>idNPC, Evento, Missao</ins>

## 4. Relacionamentos

**Sala _possui_ Região**

- O mundo possui uma ou várias regiões (1,N)
- A região pertence a um único mundo (1,1)

**PC _possui_ Habilidade**

- O PC possui uma ou várias habilidades (1,N)
- Cada habilidade pertence a um único PC (1,1)

**PC _tem_ Inventário**

- O PC tem um único inventário (1,1)
- Cada inventário pertence a um único PC (1,1)

**PC _tem_ Evolucao**

- O PC tem uma Evolução no decorrer do jogo (1,1)
- Cada Evolução pertence a um único PC (1,1)

**Inventário _contém_ Item**

- O inventário contém um ou vários itens (1,N)
- Cada item pertence a um único inventário (1,1)

**Item _classificado como_ Armas**

- Um item pode ser classificado como uma arma (1,1)
- A arma pertence a uma instância de item(1,1)

**Item _classificado como_ Vestimenta**

- Um item pode ser classificado como uma vestimenta (1,1)
- A vestimenta pertence a uma instância de item (1,1)

**Item _classificado como_ Consumivel**

- Um item pode ser classificado como um alimento (1,1)
- O alimento pertence a uma instância de item (1,1)

**Item _possui_ InstItem**

- Um item possui uma ou várias instâncias de item (1,N)
- Cada InstItem pertence a um item (1,1)

**Item _possui_ Receita**

- Um item possui uma receita de fabricação (1,1)
- Cada Receita pertence a uma instância de item (1,1)

**Receita _possui_ Ingrediente**

- Cada Receita de item possui vários ingredientes (1,N)
- Cada Ingrediente pertence a uma receita (1,1)

**PC _realiza_ Missão**

- Um PC realiza várias missões (1,N)
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

**NPC _possui_ InstNPC**

- O NPC possui uma ou várias instâncias de NPC (1,N)
- Cada instância de NPC pertence a um único NPC (1,1)

**NPC _classificado em_ Infectado**

- Uma instância de NPC pode ser classificado em Infectado (0,1)
- O Infectado pertence a uma única instância de NPC(1,1)

**NPC _classificado em_ Faccao Humana**

- Uma instância de NPC pode ser classificado em Faccao Humana (0,1)
- A Faccao Humana pertence a uma única instância de NPC(1,1)

**NPC _classificado em_ Animal**

- Uma instância de NPC pode ser classificado em Animal (0,1)
- O Animal pertence a uma única instância de NPC(1,1)


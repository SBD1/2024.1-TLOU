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
- **Áreas Abertas**
- **Personagem**
- **PC (Playable Character)**
- **NPC (Non-Playable Character)**
- **Inst_NPC**
- **Grupo**
- **Habilidade**
- **Inventário**
- **Inst_Item**
 - **Armas**
 - **Vestimenta**
 - **Alimento**
- **Receita**
- **Ingredientes**
- **Missão**
- **Missão de Patrulha**
- **Missão de Expedição/obter Item**
- **Evento**
- **Itinerário**
- **Infectados**
- **Facções Humanas**
- **Animais**
- **Evolução**

## 2. Atributos

- **Mundo**: <ins>idMundo</ins>, descricaoMundo, nomeMundo
- **Região**: <ins>idRegiao</ins>, descricaoRegiao, coordenadaX, coordenadaY, nomeRegiao, tipoRegiao, capacidade, itens?
- **Zona de Quarentena**: <ins>idZona</ins>, seguranca
- **Acampamento**: <ins>idAcamp</ins>, faccaoHumana
- **Locais Abandonados**: <ins>idLocal</ins>, periculosidade
- **Áreas Abertas**: <ins>idArea</ins>, recursoNaturais
- **Personagem**: <ins>idPersonagem</ins>, xp,  tipoPersonagem, locAtual, saude, vidaAtual, vidaMax, nomePersonagem
- **PC (Playable Character)**: <ins>idPC</ins>, missaoAtual
- **NPC (Non-Playable Character)**: <ins>idNPC</ins>, loot, eAliado
- **Inst_NPC**: <ins>tipoNPC</ins>
- **Grupo**: <ins>idGrupo</ins>, descricao, nomeGrupo
- **Habilidade**: <ins>idHabilidade</ins>, nomeHabilidade, tipoHabilidade, efeito, duracaoHabilidade
- **Inventário**: <ins>idInventario</ins>, descricao, receita, capacidadeInvent, duracao
- **Inst_Item**: <ins>idItem</ins>, tipoItem, eAtaque
 - **Armas**: <ins>idArma</ins>, nomeArma, dano, tipoArma, municaoAtual, municaoMax
 - **Vestimenta**: <ins>idVestimenta</ins>, nomeVestimenta, descricaoVest
 - **Alimento**: <ins>idAl</ins>, nomeAli, aumentoVida, tipoAl
- **Receita**: <ins>idReceita</ins>, nomeReceita, descricaoReceita, tempoCraft
- **Missão**: <ins>idMissao</ins>, descricaoMissao, recompensas, tipoMissao
 - **Missão de Patrulha**:<ins> idPatrulha</ins>,vidaAtualNPCs, qntdNPCs
 - **Missão de Expedição/Encontrar Item**:<ins> idExploracao</ins>, itensAdquiridos
- **Evento**: <ins>idEvento</ins>, nomeEvento, descricao, localizacao
- **Itinerário**: <ins>idItinerario</ins>, horario, data
- **Infectados**: <ins>idInfectado</ins>, comportamento
- **Facções Humanas**: <ins>idFac</ins>, nomeFacao, alianca
- **Animais**: <ins>idAnimal</ins>, nomeAnimal, eAmeaca
- **Evolução**: <ins>idEvolucao</ins>, requisitos, xpEvol

## 3. Relacionamentos

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

**Região _classificado como_ Áreas Abertas**

- Uma região pode ser classificado como uma área aberta (0,1)
- A área aberta pertence a uma única região (1,1)

**Personagem _se situa_ no Mundo**

- O personagem está em um único mundo (1,1)
- O mundo pode conter nenhum ou vários personagens (0,N)

**PC _possui_ Habilidade**

- O PC possui uma ou várias habilidades (1,N)
- Cada habilidade pertence a um único PC (1,1)

**PC _tem_ Inventário**

- O PC tem um único inventário (1,1)
- Cada inventário pertence a um único PC (1,1)

**Inventário _contém_ Inst_Item**

- O inventário contém nenhum ou vários itens (0,N)
- Cada item pertence a um único inventário (1,1)

**Inst_Item _classificado como_ Armas**

- Uma instância de item pode ser classificado como uma arma (0,1)
- A arma pertence a uma instância de item(1,1)

**Inst_Item _classificado como_ Vestimenta**

- Uma instância de item pode ser classificado como uma vestimenta (0,1)
- A vestimenta pertence a uma instância de item (1,1)

**Inst_Item _classificado como_ Alimento**

- Uma instância de item pode ser classificado como um alimento (0,1)
- O alimento pertence a uma instância de item (1,1)

**Personagem _participa de_ Grupo**

- Um personagem pode participar de nenhum ou vários grupos (0,N)
- Cada grupo contém um ou vários personagens (1,N)

**PC _realiza_ Missão**

- Um PC realiza nenhuma ou várias missões (0,N)
- Cada missão é realizada por um ou vários PCs (1,N)

**Missão _classificado em_ Missão Patrulha**

- Uma missão pode ser classificado em Missão de Patrulha (0,1)
- A Missão de Patrulha pertence a uma única Missão (1,1)

**Missão _classificado em_ Missão de Exploração/obter item**

- Uma missão pode ser classificado em Missão de Exploração/obter item (0,1)
- A Missão de Exploração/obter item pertence a uma única Missão (1,1)

**Personagem _fala_ Dialogo**

- Um Personagem fala nenhum ou vários diálogos (0,N)
- Cada diálogo pertence a um único Personagem (1,1)

**Inst_Item _tem_ Receita**

- Um Item pode ter nenhuma ou várias receitas (0,N)
- Cada receita pertence a um único item (1,1)

**Receita _possui_ Ingredientes**

- Uma Receita pode ter um ou vários ingredientes (1,N)
- Cada ingrediente pertence a um única receita (1,1)

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

**Personagem _possui_ Evolução**

- Um personagem possui uma ou várias evoluções (1,N)
- Cada evolução pertence a um único personagem (1,1)


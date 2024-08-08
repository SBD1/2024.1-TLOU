---
sidebar_position: 4
sidebar_label: "Dicionário de Dados"
---

# TLOU - Dicionário de Dados

# Entidade: Mundo
A tabela a seguir descreve a entidade `Mundo`, que representa os mundos dentro do sistema, incluindo identificadores, descrições e nomes dos mundos.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| idMundo          | int    | Identificador único para o mundo                                                                      | 1                   | Não                    | Sim. Chave primária  | -                 |
| descricaoMundo   | string [400] |  Breve descrição textual imersiva do mundo em que o jogador está, contando com ambiente e...     | A-Z   <br /> a-z             | Não                    | Não                  | -                 |
| nomeMundo        | string [50]|  Nome do mundo em questão                                                                         | A-Z <br />a-z             | Não                    | Não                  | -                 |

# Entidade: Regiao
A tabela a seguir descreve a entidade `Regiao`, que representa regiões dentro do mundo, incluindo identificadores, descrições, coordenadas, e características específicas da região.

Observação: essa tabela possui chave estrangeira para a tabela `Mundo`.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| idRegiao         | int    | Identificador único para a região                                                                     | 1 - 100             | Não                    | Sim. Chave primária | -                 |
| descricaoRegiao  | string [400]| Breve descrição textual imersiva da região em que o jogador está, contando com ambiente e atmosfera, interatividade e estilo.     | A-Z <br /> a-z             | Não                    | Não                  | -                 |
| coordenadaX      | int    | Coordenada para localização da região dentro do mundo no eixo X.                                      | 1 - 5000            | Não                    | Não                  | -                 |
| coordenadaY      | int    | Coordenada para localização da região dentro do mundo no eixo Y.                                      | 1 - 5000            | Não                    | Não                  | -                 |
| nomeRegiao       | string [50] | Nome da região em questão, no caso, uma zona de quarentena                                       | A-Z <br /> a-z             | Não                    | Não                  | -                 |
| capacidade       | int    | Número de PCs e NPCs que pode ter em uma região                                                       | 0 - 5000            | Sim                    | Não                  | -                 |
| IdMundo          | int    | Identificador único para o mundo em que a região se encontra                                          | 1                   | Não                    | Sim. Chave estrangeira                 | -                 |
| tipoRegiao       | int    | Atributo que define qual o tipo de região (Locais abandonados, acampamento, zona de quarentena ou nenhum desses) por meio de uma enumeração. | 1 - 3               | Sim                    | Não                  | Pode possuir nenhum tipo |

# Entidade: ZonaQuarentena
A tabela a seguir descreve a entidade `Zona_Quarentena`, que representa zonas de quarentena dentro de uma região, incluindo detalhes sobre a segurança, população e identificadores.

Observação: essa tabela possui chave estrangeira para a tabela `Regiao`.


| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| IdRegiao         | int    | Identificador único para a região                                                                     | 1 - 100             | Não                    | Sim. Chave estrangeira | -                 |
| idZona           | int    | Identificador único para a zona                                                                       | 1 - 100             | Não                    | Sim. Chave primária  | -                 |
| seguranca        | int    | Número de guardas (soldados) em uma zona                                                              | 10 - 15             | Não                    | Não                  | -                 |
| populacaoAtual   | int    | Quantidade de PCs e NPCs que estão na zona                                                            | 0 - 100             | Sim                    | Não                  | -                 |

# Entidade: Acampamento
A tabela a seguir descreve a entidade `Acampamento`, que representa acampamentos dentro de uma região, incluindo detalhes sobre a segurança e identificadores.

Observação: essa tabela possui chave estrangeira para a tabela `Regiao`.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| IdRegiao         | int    | Identificador único para a região                                                                     | 1 - 100             | Não                    | Sim. Chave estrangeira | -                 |
| idAcampamento    | int    | Identificador único para o acampamento                                                                | 1 - 100             | Não                    | Sim. Chave primária  | -                 |
| defesa           | int    | Número de guardas (soldados) em um acampamento                                                        | 10 - 15             | Não                    | Não                  | -                 |

# Entidade: LocalAbandonado
A tabela a seguir descreve a entidade `Local_Abandonado`, que representa locais abandonados dentro de uma região, detalhando aspectos como infestação e periculosidade.

Observação: essa tabela possui chave estrangeira para a tabela `Regiao`.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| IdRegiao         | int    | Identificador único para a região                                                                     | 1 - 100             | Não                    | Sim. Chave estrangeira | -                 |
| idLocal          | int    | Identificador único para o local abandonado                                                           | 1 - 100             | Não                    | Sim. Chave primária  | -                 |
| nivelInfestacao  | int    | Indicador se o local está com muitos infectados ou não, indo de 0 (poucos infectados) a 5 (muitos infectados) | 0 - 5               | Sim                    | Não                  | -                 |
| periculosidade   | int    | Grau de risco do local abandonado                                                                     | 1 - 10              | Não                    | Não                  | -                 |

# Entidade: Personagem
A tabela a seguir descreve a entidade `Personagem`, que representa os personagens no jogo, incluindo tanto personagens jogáveis (PCs) quanto não jogáveis (NPCs).

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| idPersonagem     | int    | Identificador único para o personagem                                                                 | 1 - 5000            | Não                    | Sim. Chave primária  | -                 |
| tipoPersonagem   | int    | Atributo que define qual o tipo de personagem (PC ou NPC) por meio de uma enumeração.                  | 1 - 2               | Não                    | Não                  | Permite apenas um atributo de tipo |

# Entidade: NPC
A tabela a seguir descreve a entidade `NPC`, que representa os personagens não jogáveis no jogo. Ela detalha os atributos que definem um NPC, incluindo sua localização, experiência, vida, e inventário.

Observação: essa tabela possui chave estrangeira para as tabelas `Personagem`, `Mundo` e `Inventario` e `Inst_Item`.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| IdPersonagem     | int    | Identificador único para o personagem                                                                 | 1 - 5000            | Não                    | Sim. Chave estrangeira | -                 |
| idNPC             | int    | Identificador único para o PC                                                                         | 1 - 5000            | Não                    | Sim. Chave primária  | -                 |
| locEmX           | int    | Coordenada para localização do PC dentro do mundo/região no eixo X                                    | 1 - 5000            | Não                    | Não                  | -                 |
| locEmY           | int    | Coordenada para localização do PC dentro do mundo/região no eixo Y                                    | 1 - 5000            | Não                    | Não                  | -                 |
| xp               | int    | Quantidade de experiência de um NPC                                                                    | 0 - 100             | Não                    | Não                  | -                 |
| vidaMax          | int    | Quantidade de vida total que um NPC pode ter no nível em que ele está                                  | 0 - 100             | Não                    | Não                  | -                 |
| vidaAtual        | int    | Quantidade de vida que um NPC possui                                                                   | 0 - 100             | Sim                    | Não                  | -                 |
| nomePersonagem   | string [50] | Nome do NPC em questão                                                                            | A-Z <br />a-z             | Não                    | Não                  | -                 |
| Loot           | int | Identificador de qual item está sendo dropado pelo NPC após sua morte                                   | 1 - 100          | Sim                    | Sim. Chave estrangeira                  | Apenas um item deverá ser dropado              |
| eAliado         | boolean    | Indica se o NPC é aliado (true) ou inimigo (false)                                                                              | true - false             | Não                    | Não | -                 |
| Mundo            | int    | Mundo em que o NPC se encontra                                                                         | 1                   | Não                    | Sim. Chave estrangeira | -                 |
| IdInventario    | int    | Indicador único para o inventário que o NPC possui                                                     | 1 - 5000            | Não                    | Sim. Chave estrangeira | -                 |

# Entidade: PC
A tabela a seguir descreve a entidade `PC`, que representa os personagens controlados pelos jogadores no jogo. Ela detalha os atributos que definem um PC, incluindo sua localização, experiência, vida, nome, estado atual, evolução, mundo e inventário.

Observação: essa tabela possui chave estrangeira para as tabelas `Personagem`, `Mundo`, `Inventario` e `Evolucao`.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| IdPersonagem     | int    | Identificador único para o personagem                                                                 | 1 - 5000            | Não                    | Sim. Chave estrangeira | -                 |
| idPC             | int    | Identificador único para o NPC                                                                         | 1 - 5000            | Não                    | Sim. Chave primária  | -                 |
| locEmX           | int    | Coordenada para localização do NPC dentro do mundo/região no eixo X                                    | 1 - 5000            | Não                    | Não                  | -                 |
| locEmY           | int    | Coordenada para localização do NPC dentro do mundo/região no eixo Y                                    | 1 - 5000            | Não                    | Não                  | -                 |
| xp               | int    | Quantidade de experiência de um PC                                                                    | 0 - 100             | Não                    | Não                  | -                 |
| vidaMax          | int    | Quantidade de vida total que um PC pode ter no nível em que ele está                                  | 0 - 100             | Não                    | Não                  | -                 |
| vidaAtual        | int    | Quantidade de vida que um PC possui                                                                   | 0 - 100             | Sim                    | Não                  | -                 |
| nomePersonagem   | string [50] | Nome do PC em questão                                                                            | A-Z <br />a-z             | Não                    | Não                  | -                 |
| estado           | string [20] | Estado atual do personagem (ex: saudável, ferido, infectado).                                    | A-Z <br />a-z             | Não                    | Não                  | -                 |
| Evolucao         | int    | Indicador do nível do PC                                                                              | 1 - 10              | Não                    | Sim. Chave estrangeira | -                 |
| Mundo            | int    | Mundo em que o PC se encontra                                                                         | 1                   | Não                    | Sim. Chave estrangeira | -                 |
| IdInventario    | int    | Indicador único para o inventário que o PC possui                                                     | 1 - 5000            | Não                    | Sim. Chave estrangeira | -                 |

# Entidade: Inventario
A tabela a seguir descreve a entidade `Inventario`, que representa os inventários dos personagens no jogo. Ela detalha os atributos que definem um inventário, incluindo identificadores, tipo, quantidade de slots, peso e relação com o personagem que o possui.

Observação: essa tabela possui chave estrangeira para a tabela `Personagem`.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| idInventario     | int    | Identificador único para o inventário                                                                 | 1 - 5000            | Não                    | Sim. Chave primária  | -                 |
| capacidadeInvent  | int    | Atributo que define a capacidade do inventário                | 1 - 30               | Não                  | Não                  | - |
| descricao         | string [50]    | Campo destinado a fornecer uma descrição detalhada ou identificação do inventário.     | a-z <br />  A-Z            | Não                    | Não                  | -                 |

# Entidade: Itens

A tabela a seguir descreve a entidade `Itens`, que representa os itens associados a uma missão, incluindo identificadores da missão e do item.

Observação: essa tabela possui chave estrangeira para as tabelas `Inst_Item` e `Missao`.

| Variável  | Tipo | Descrição                                             | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|-----------|------|-------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| IdMissao  | int  | Identificador único para a missão                    | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| IdItem    | int  | Identificador único para o item a ser dropado/recebido | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |


# Entidade: Missao

A tabela a seguir descreve a entidade `Missao`, que representa as missões no sistema, incluindo identificadores e o tipo de missão.

| Variável   | Tipo | Descrição                                             | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições           |
|------------|------|-------------------------------------------------------|--------------------|------------------------|----------|------------------------------|
| idMissao   | int  | Identificador único para a missão                    | 1 - 5000           | Não                    | Sim. Chave primária | -                            |
| tipoMis    | int  | Atributo que define o tipo de missão (patrulha ou exploração/obter item) | 1 - 2              | Não                    | Não      | Permite apenas um atributo de tipo |



# Entidade: MissaoExploracaoObterItem

A tabela a seguir descreve a entidade `MissaoExploracao_ObterItem`, que representa missões de exploração para obter itens, incluindo identificadores, objetivos, itens adquiridos e participantes.

Observação: essa tabela possui chave estrangeira para as tabelas `Inst_Item`, `Missao` e `PC`.

| Variável         | Tipo       | Descrição                                                   | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições                       |
|------------------|------------|-------------------------------------------------------------|--------------------|------------------------|----------|----------------------------------------|
| IdMissao         | int        | Identificador único para a missão                          | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                                      |
| idMissaoPre      | int        | Identificador único para a missão que é pré-requisito       | 1 - 5000           | Sim                    | Não      | -                                      |
| objetivo         | string[400]| Breve descrição do objetivo da missão, incluindo motivos, envolvidos e local | a - z <br /> A - Z       | Não                    | Não      | -                                      |
| nomeMis          | string[50] | Nome da missão                                             | a - z <br /> A - Z       | Não                    | Não      | -                                      |
| ItensAdquiridos  | int | Itens adquiridos durante a missão                          | 1 - 100      | Sim                    | Sim. Chave estrangeira | Permite mais de um item                |
| idExploracao     | int        | Identificador único para a exploração a ser realizada      | 1 - 5000           | Não                    | Sim. Chave primária | -                                      |
| IdPC             | int        | Identificador para o PC que participa da missão            | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                                      |
| xpMis            | int        | Quantidade de XP que a missão pode conceder                 | 1 - 5000           | Não                    | Não      | -                                      |



# Entidade: MissaoPatrulha

A tabela a seguir descreve a entidade `Missao_Patrulha`, que representa as missões de patrulha no sistema, incluindo identificadores, objetivos, nomes, quantidades de NPCs inimigos e informações sobre o PC participante.

Observação: essa tabela possui chave estrangeira para as tabelas `Missao` e `PC`.

| Variável      | Tipo       | Descrição                                                   | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|---------------|------------|-------------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| IdMissao      | int        | Identificador único para a missão                          | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| idMissaoPre   | int        | Identificador único para a missão que é pré-requisito       | 1 - 5000           | Sim                    | Não      | -                  |
| objetivo      | string[400]| Breve descrição do objetivo da missão, incluindo motivos, envolvidos e local | a - z <br /> A - Z       | Não                    | Não      | -                  |
| nomeMis       | string[50] | Nome da missão                                             | a - z <br /> A - Z       | Não                    | Não      | -                  |
| qtdNPCs       | int        | Número de NPCs inimigos a serem derrotados na missão        | 1 - 30             | Não                    | Não      | -                  |
| IdPC          | int        | Identificador para o PC que participa da missão            | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| xpMis         | int        | Quantidade de XP que a missão pode conceder                 | 1 - 5000           | Não                    | Não      | -                  |
| idPatrulha    | int        | Identificador único para a patrulha a ser realizada        | 1 - 5000           | Não                    | Sim. Chave primária | -                  |



# Entidade: Evento

A tabela a seguir descreve a entidade `Evento`, que representa os eventos no sistema, incluindo identificadores, nomes, descrições, coordenadas de localização e participantes.

Observação: essa tabela possui chave estrangeira para a tabela `PC`.

| Variável     | Tipo       | Descrição                                             | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|--------------|------------|-------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idEvento     | int        | Identificador único para o evento                    | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| nomeEvento   | int        | Nome do evento em questão                            | 1 - 5000           | Não                    | Não      | -                  |
| descricao    | string[400]        | Breve descrição textual do evento, incluindo local, contexto e atividades | a - z <br /> A - Z           | Não                    | Não      | -                  |
| locEmX       | int        | Coordenada para localização do evento no eixo X       | 1 - 5000           | Não                    | Não      | -                  |
| locEmY       | int        | Coordenada para localização do evento no eixo Y       | 1 - 5000           | Não                    | Não      | -                  |
| IdPC         | int        | Identificador único para o PC participante do evento  | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |



# Entidade: Itinerario

A tabela a seguir descreve a entidade `Itinerario`, que representa os itinerários de eventos, incluindo identificadores, horários, datas e eventos associados.

Observação: essa tabela possui chave estrangeira para a tabela `Evento`.

| Variável     | Tipo       | Descrição                                             | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|--------------|------------|-------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idItinerario | int        | Identificador único para o itinerário                | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| horario      | int        | Horário em que um determinado evento ocorrerá        | A-Z <br />a-z           | Não                    | Não      | -                  |
| dia         | date       | Data em que um determinado evento ocorrerá           | -                  | Não                    | Não      | REGEX para validação: `/^(\d{2})([-\/.]?)(\d{2})\2(\d{4})$/` |
| IdEvento     | int        | Identificador único do evento que o itinerário está atrelado | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |





# Entidade: Habilidade

A tabela a seguir descreve a entidade `Habilidade`, que representa as habilidades disponíveis, incluindo identificadores, nomes, tipos, efeitos e duração.

Observação: essa tabela possui chave estrangeira para a tabela `PC`.

| Variável         | Tipo       | Descrição                                             | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|------------------|------------|-------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idHabilidade     | int        | Identificador único para a habilidade                | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| nomeHabilidade   | string[50] | Nome que identifica não unicamente uma habilidade    | A-Z <br /> a-z           | Não                    | Não      | -                  |
| tipoHabilidade   | string[50] | Descreve se a habilidade é passiva ou ativa          | A-Z <br /> a-z           | Não                    | Não      | -                  |
| efeito           | string[50] | Descreve qual efeito a habilidade aplica sobre o jogador ou entidades que ele interage | A-Z <br /> a-z           | Não                    | Não      | -                  |
| duracaoHabilidade| int        | Descreve o tempo que a habilidade dura no alvo       | 1 - 5000           | Não                    | Não      | -                  |
| IdPC             | int        | PC que possui a habilidade                            | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |




# Entidade: Inventario

A tabela a seguir descreve a entidade `Inventario`, que representa os inventários no sistema, incluindo identificadores, descrições e capacidades.

| Variável           | Tipo       | Descrição                                               | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|--------------------|------------|---------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idInventario       | int        | Identificador único para o inventário                  | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| descricao          | string[400]| Descrição detalhada dos itens contidos no inventário    | A-Z <br /> a-z           | Não                    | Não      | -                  |
| capacidadeInvent   | int        | Capacidade máxima do inventário                        | 1 - 5000           | Não                    | Não      | -                  |




# Entidade: Inst_Item

A tabela a seguir descreve a entidade `Inst_Item`, que representa os itens no inventário, incluindo identificadores e tipos de item.

| Variável   | Tipo      | Descrição                                           | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|------------|-----------|-----------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idItem     | int       | Identificador único para o item do inventário      | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| tipoItem   | int | Tipo do item (ex.: arma, vestimenta ou alimento)   | 1 - 3          | Não                    | Não      | -                  |




# Entidade: Arma

A tabela a seguir descreve a entidade `Arma`, que representa as armas contidas no inventário, incluindo identificadores, nomes, dano, munição e tipo de arma.

Observação: essa tabela possui chave estrangeira para as tabelas `Inst_Item` e `Inventario`.

| Variável       | Tipo       | Descrição                                            | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|----------------|------------|------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idArma         | int        | Identificador único para o item do inventário       | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| IdItem         | int        | Identificador único para o item do inventário       | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| nomeArma       | string[50] | Nome que não identifica unicamente a arma equipada ou encontrada | A-Z <br /> a-z           | Não                    | Não      | -                  |
| dano           | int        | Quantidade de dano que a arma causa                 | 1 - 50             | Não                    | Não      | -                  |
| municaoAtual   | int        | Quantidade atual de munição da arma                 | 0 - 10             | Sim                    | Não      | -                  |
| municaoMax     | int        | Quantidade máxima de munição da arma                | 0 - 10             | Não                    | Não      | -                  |
| IdInventario   | int        | Identificador do inventário ao qual a arma pertence | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| eAtaque        | boolean    | Indica se a arma é de ataque (true) ou defesa (false)| true/false         | Não                    | Não      | -                  |





# Entidade: Vestimenta

A tabela a seguir descreve a entidade `Vestimenta`, que representa as vestimentas contidas no inventário, incluindo identificadores, nomes, descrições e se são de ataque ou defesa.

Observação: essa tabela possui chave estrangeira para as tabelas `Inst_Item` e `Inventario`.

| Variável       | Tipo       | Descrição                                           | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|----------------|------------|-----------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idVestimenta   | int        | Identificador único para a vestimenta no inventário | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| IdItem         | int        | Identificador único para o item do inventário      | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| nomeVestimenta | string[50] | Nome que não identifica unicamente a vestimenta    | A-Z <br /> a-z           | Não                    | Não      | -                  |
| descricaoVestimenta | string[400] | Descrição da vestimenta, incluindo informações como se fornece armadura ou é apenas decorativo | A-Z <br /> a-z           | Não                    | Não      | -                  |
| IdInventario   | int        | Identificador do inventário ao qual a vestimenta pertence | 1 - 5000           | Não                    | Sim. Chave estrangeira      | -                  |
| eAtaque        | boolean    | Indica se a vestimenta é de ataque (true) ou defesa (false) | true/false         | Não                    | Não      | -                  |




# Entidade: Alimento

A tabela a seguir descreve a entidade `Alimento`, que representa os alimentos contidos no inventário, incluindo identificadores, nomes, tipos e efeitos no jogo.

Observação: essa tabela possui chave estrangeira para as tabelas `Inst_Item` e `Inventario`.

| Variável      | Tipo       | Descrição                                           | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|---------------|------------|-----------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idAlimento    | int        | Identificador único para o alimento no inventário  | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| IdItem        | int        | Identificador único para o item do inventário      | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| nomeAlimento  | string[50] | Nome que não identifica unicamente o alimento      | A-Z <br /> a-z           | Não                    | Não      | -                  |
| tipoAlimento  | string[40] | Tipo de alimento (ex.: fruta, carne, bebida, barras, vitaminas) | A-Z <br /> a-z           | Não                    | Não      | -                  |
| aumentoVida   | int        | Quantidade de vida que o alimento aumenta          | 1 - 20             | Não                    | Não      | -                  |
| IdInventario  | int        | Identificador do inventário ao qual o alimento pertence | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| eAtaque       | boolean    | Indica se o alimento é de ataque (true) ou defesa (false) | false              | Não                    | Não      | Como alimento não pode ser classificado como ataque ou defesa, seu valor será sempre falso |





# Entidade: Receita

A tabela a seguir descreve a entidade `Receita`, que representa as receitas disponíveis, incluindo identificadores, nomes, descrições, tempo de preparo e itens resultantes.

Observação: essa tabela possui chave estrangeira para a tabela `Inst_Item`.

| Variável       | Tipo      | Descrição                                         | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|----------------|-----------|---------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idReceita      | int       | Identificador único para a receita                | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| nomeReceita    | string[50]| Nome da receita a ser feita                       | A-Z <br /> a-z           | Não                    | Não      | -                  |
| descricaoReceita | string[400] | Breve descrição textual da receita, incluindo ingredientes e item a ser feito | A-Z <br /> a-z           | Não                    | Não      | -                  |
| tempoCraft     | int       | Tempo, em minutos, necessário para que a receita fique pronta | 1 - 60             | Não                    | Não      | -                  |
| IdItem         | int       | Identificador único para o item resultante da receita | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |







# Entidade: Ingrediente

A tabela a seguir descreve a entidade `Ingrediente`, que representa os ingredientes utilizados em receitas, incluindo identificadores únicos e quantidades.

Observação: essa tabela possui chave estrangeira para as tabelas `Inst_Item` e `Receita`.

| Variável       | Tipo | Descrição                                          | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|----------------|------|----------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idIngrediente  | int  | Identificador único para o ingrediente            | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| IdReceita      | int  | Identificador único para a receita à qual o ingrediente está atrelado | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| IdItem         | int  | Identificador único para o item associado ao ingrediente, de acordo com a receita | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| quantidadeIngre| int  | Quantidade do ingrediente utilizada na receita    | 1 - 30             | Não                    | Não      | -                  |


# Entidade: Evolucao

A tabela a seguir descreve a entidade `Evolucao`, que representa as evoluções dos personagens, incluindo identificadores, requisitos de nível e experiência necessária.


| **Variável**       | **Tipo** | **Descrição**                                      | **Valores permitidos** | **Permite valores nulos?** | **É chave?** | **Outras restrições** |
|----------------|------|------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idEvolucao     | int  | Identificador único para a evolução do personagem | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| requisitoNivel | int  | Requisito de nível necessário para a evolução  | 0 - 5              | Não                    | Não      | -                  |
| xpEvol         | int  | Quantidade de experiência necessária para a evolução | 0 - 100            | Não                    | Não      | -                  |



# Relacionamento: Concede

A tabela a seguir descreve o relacionamento `Concede`, que associa evoluções a alimentos, incluindo identificadores para ambos.

Observação: essa tabela possui chave estrangeira para as tabelas `Evolucao` e `Alimento`.

| **Variável**    | **Tipo** | **Descrição**                                      | **Valores permitidos** | **Permite valores nulos?** | **É chave?**                   | **Outras restrições**                |
|-------------|------|------------------------------------------------|--------------------|------------------------|----------------------------|----------------------------------|
| IdEvolucao  | int  | Identificador único para a evolução            | 1 - 5000           | Não                    | Sim. Chave composta e chave estrangeira | -                                |
| IdAlimento  | int  | Identificador único para o alimento            | 1 - 5000           | Não                    | Sim. Chave composta e chave estrangeira | -                                |



# Relacionamento: Dialoga

A tabela a seguir descreve o relacionamento `Dialoga`, que registra os detalhes dos diálogos entre falantes e ouvintes, incluindo identificadores e conteúdo do diálogo.

Observação: essa tabela possui chave estrangeira para a tabela `Personagem`.

| Variável      | Tipo       | Descrição                                         | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições           |
|---------------|------------|---------------------------------------------------|--------------------|------------------------|----------|------------------------------|
| idDialogo     | int        | Identificador único para o diálogo                | 1 - 5000           | Não                    | Sim. Chave primária | -                            |
| IdFalante     | int        | Identificador único do falante do diálogo         | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                            |
| IdOuvinte     | int        | Identificador único do ouvinte do diálogo         | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                            |
| conteudo      | string[50] | O que foi abordado no diálogo entre os envolvidos | A - Z, a - z        | Não                    | Não      | -                            |
| duracaoDialogo| int        | Tempo de duração do diálogo                       | 1 - 2000           | Não                    | Não      | -                            |



# Entidade: InstNPC

A tabela a seguir descreve a entidade `InstNPC`, que representa os NPCs no sistema, incluindo identificadores únicos e a classificação do tipo de NPC.

Observação: essa tabela possui chave estrangeira para a tabela `NPC`.

| Variável | Tipo | Descrição | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|----------|------|-----------|--------------------|------------------------|----------|--------------------|
| IdNPC    | int  | Identificador único para o NPC | 1 - 5000 | Não | Sim. Chave estrangeira | - |
| tipoNPC  | int  | Atributo que define o tipo de NPC (infectados, facção humana ou animal) por meio de uma enumeração. | 1 - 3 | Não | Não | Permite apenas um atributo de tipo |



# Entidade: Infectado

A tabela a seguir descreve a entidade "Infectado" que contém informações sobre os infectados, incluindo identificadores únicos, comportamentos e características principais.

Observação: essa tabela possui chave estrangeira para a tabela `NPC`.

| **Variável**         | **Tipo**     | **Descrição**                                                                 | **Valores permitidos** | **Permite valores nulos?** | **É chave?** | **Outras restrições**        |
| -------------------- | ------------ | ----------------------------------------------------------------------------- | ---------------------- | ------------------------- | ------------ | ---------------------------- |
| IdNPC                | int          | Identificador único para o NPC                                                | 1 - 5000               | Não                       | Sim          | Chave estrangeira            |
| idInfectado          | int          | Identificador único para o infectado                                          | 1 - 5000               | Não                       | Sim          | Chave primária               |
| comportamentoInfec   | string [400] | Breve descrição do comportamento do infectado, com principais características | a - z, A - Z           | Não                       | Não          | -                            |


# Entidade: FaccaoHumana

A tabela a seguir descreve a entidade "FaccaoHumana" que contém informações sobre as facções humanas, incluindo identificadores únicos, nomes, e relações com NPCs.

Observação: essa tabela possui chave estrangeira para a tabela `NPC`.

| **Variável**   | **Tipo**     | **Descrição**                            | **Valores permitidos** | **Permite valores nulos?** | **É chave?** | **Outras restrições**        |
| -------------- | ------------ | ---------------------------------------- | ---------------------- | ------------------------- | ------------ | ---------------------------- |
| IdNPC          | int          | Identificador único para o NPC           | 1 - 5000               | Não                       | Sim          | Chave estrangeira            |
| idFaccao       | int          | Identificador único para a facção        | 1 - 5000               | Não                       | Sim          | Chave primária               |
| nomeFaccao     | string [50]  | Nome da facção em questão                | a - z, A - Z           | Não                       | Não          | -                            |



# Entidade: Animal

A tabela a seguir descreve a entidade "Animal" que contém informações sobre os animais, incluindo identificadores únicos, nomes, e as ameaças que eles podem apresentar.

Observação: essa tabela possui chave estrangeira para a tabela `NPC`.

| **Variável**  | **Tipo**      | **Descrição**                            | **Valores permitidos** | **Permite valores nulos?** | **É chave?** | **Outras restrições**        |
| ------------- | ------------- | ---------------------------------------- | ---------------------- | ------------------------- | ------------ | ---------------------------- |
| IdNPC         | int           | Identificador único para o NPC           | 1 - 5000               | Não                       | Sim          | Chave estrangeira            |
| idAnimal      | int           | Identificador único para o animal        | 1 - 5000               | Não                       | Sim          | Chave primária               |
| nomeAnimal    | string [50]   | Nome do animal em questão                | a - z, A - Z           | Não                       | Não          | -                            |
| ameaca        | string [100]  | Ameaça que o animal pode apresentar      | a - z, A - Z           | Não                       | Não          | -                            |

# Relacionamento: Participacao

A tabela a seguir descreve o relacionamento "Participacao", que indica a participação de um NPC em eventos e missões. Cada registro na tabela contém identificadores únicos para o NPC, o evento e a missão.

Observação: essa tabela possui chave estrangeira para as tabelas `NPC`, `Evento` e `Missao`.

| **Variável**   | **Tipo**     | **Descrição**                                                    | **Valores permitidos** | **Permite valores nulos?** | **É chave?** | **Outras restrições**                |
| -------------- | ------------ | ---------------------------------------------------------------- | ---------------------- | ------------------------- | ------------ | ------------------------------------ |
| IdNPC          | int          | Identificador único para o NPC                                   | 1 - 5000               | Não                       | Sim          | Chave primária e estrangeira         |
| Evento         | int          | Identificador único para o evento que o NPC participa            | 1 - 5000               | Não                       | Sim          | Chave primária e estrangeira         |
| Missao         | int          | Identificador único para a missão que o NPC participa            | 1 - 5000               | Não                       | Sim          | Chave primária e estrangeira         |

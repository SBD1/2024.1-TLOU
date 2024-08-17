---
sidebar_position: 4
sidebar_label: "Dicionário de Dados"
---

# TLOU - Dicionário de Dados

# Entidade: Sala

A tabela a seguir descreve a entidade `Sala`, que indica uma sala no MUD. Também indica em qual região aquela sala está.

Observação: essa tabela possui chave estrangeira para a tabela `Regiao`.

| **Variável**   | **Tipo**     | **Descrição**                                                    | **Valores permitidos** | **Permite valores nulos?** | **É chave?** | **Outras restrições**                |
| -------------- | ------------ | ---------------------------------------------------------------- | ---------------------- | ------------------------- | ------------ | ------------------------------------ |
| idSala          | int          | Identificador único para a sala                               | 1 - 5000               | Não                       | Sim. Chave primária       |          -                |
| IdRegiao         | int          | Identificador para a região em que a sala está          | 1 - 5000               | Não                       | Sim. Chave estrangeira         |            -              |

# Entidade: Regiao
A tabela a seguir descreve a entidade `Regiao`, que representa regiões dentro do mundo, incluindo identificadores, descrições, coordenadas, e características específicas da região.


| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| idRegiao         | int    | Identificador único para a região                                                                     | 1 - 100             | Não                    | Sim. Chave primária | -                 |
| descricaoRegiao  | string [400]| Breve descrição textual imersiva da região em que o jogador está, contando com ambiente e atmosfera, interatividade e estilo.     | A-Z <br /> a-z             | Não                    | Não                  | -                     |
| nomeRegiao       | string [50] | Nome da região em questão, no caso, uma zona de quarentena                                       | A-Z <br /> a-z             | Não                    | Não                  | -                 |
| capacidade       | int    | Número de PCs e NPCs que pode ter em uma região                                                       | 0 - 5000            | Sim                    | Não                  | -               |
| tipoRegiao       | int    | Atributo que define qual o tipo de região (Locais abandonados, acampamento, zona de quarentena ou nenhum desses) por meio de uma enumeração. | 1 - 3               | Sim                    | Não                  | Pode possuir nenhum tipo |

# Entidade: ZonaQuarentena
A tabela a seguir descreve a entidade `ZonaQuarentena`, que representa zonas de quarentena dentro de uma região, incluindo detalhes sobre a segurança, população e identificadores.

Observação: essa tabela possui chave estrangeira para a tabela `Regiao`.


| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| IdRegiao         | int    | Identificador único para a região                                                                     | 1 - 100             | Não                    | Sim. Chave primária e estrangeira | -                 |
| seguranca        | int    | Número de guardas (soldados) em uma zona                                                              | 10 - 15             | Não                    | Não                  | -                 |
| populacaoAtual   | int    | Quantidade de PCs e NPCs que estão na zona                                                            | 0 - 100             | Sim                    | Não                  | -                 |

# Entidade: Acampamento
A tabela a seguir descreve a entidade `Acampamento`, que representa acampamentos dentro de uma região, incluindo detalhes sobre a segurança e identificadores.

Observação: essa tabela possui chave estrangeira para a tabela `Regiao`.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| IdRegiao         | int    | Identificador único para a região                                                                     | 1 - 100             | Não                    | Sim. Chave primária e estrangeira | -                 |
| defesa           | int    | Número de guardas (soldados) em um acampamento                                                        | 10 - 15             | Não                    | Não                  | -                 |

# Entidade: LocalAbandonado
A tabela a seguir descreve a entidade `LocalAbandonado`, que representa locais abandonados dentro de uma região, detalhando aspectos como infestação e periculosidade.

Observação: essa tabela possui chave estrangeira para a tabela `Regiao`.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| IdRegiao         | int    | Identificador único para a região                                                                     | 1 - 100             | Não                    | Sim. Chave primária e estrangeira | -                 |
| tipo  | string [50]    | Indicador da categoria do local  | A-Z <br />a-z              | Não                    | Não                  | -                 |
| periculosidade   | int    | Grau de risco do local abandonado                                                                     | 1 - 10              | Não                    | Não                  | -                 |

# Entidade: Personagem
A tabela a seguir descreve a entidade `Personagem`, que representa os personagens no jogo, incluindo tanto personagens jogáveis (PCs) quanto não jogáveis (NPCs).

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| idPersonagem     | int    | Identificador único para o personagem                                                                 | 1 - 5000            | Não                    | Sim. Chave primária  | -                 |
| tipoPersonagem   | int    | Atributo que define qual o tipo de personagem (PC ou NPC) por meio de uma enumeração.                  | 1 - 2               | Não                    | Não                  | Permite apenas um atributo de tipo |

# Entidade: NPC
A tabela a seguir descreve a entidade `NPC`, que representa os personagens não jogáveis no jogo. Ela detalha os atributos que definem um NPC, incluindo sua localização, experiência, vida, e inventário.

Observação: essa tabela possui chave estrangeira para as tabelas `Personagem`, `Sala` e `Inventario`.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| IdPersonagem     | int    | Identificador único para o personagem                                                                 | 1 - 5000            | Não                    | Sim. Chave primária e estrangeira | -                 |
| Sala           | int    | Sala em que o NPC se encontra                                    | 1 - 5000            | Não                    | Sim. Chave estrangeira                 | Sim. Chave estrangeira.                |
| xp               | int    | Quantidade de experiência de um NPC                                                                    | 0 - 100             | Não                    | Não                  | -                 |
| vidaMax          | int    | Quantidade de vida total que um NPC pode ter no nível em que ele está                                  | 0 - 100             | Não                    | Não                  | -                 |
| vidaAtual        | int    | Quantidade de vida que um NPC possui                                                                   | 0 - 100             | Sim                    | Não                  | -                 |
| nomePersonagem   | string [50] | Nome do NPC em questão                                                                            | A-Z <br />a-z             | Não                    | Não                  | -                           |
| IdInventario    | int    | Indicador único para o inventário que o NPC possui                                                     | 1 - 5000            | Sim                    | Sim. Chave estrangeira | -                 | 
| tipoNPC    | int    | Indicador de qual tipo o NPC pertence       | 1 - 3            | Não                    | Não | -                 |

# Entidade: PC
A tabela a seguir descreve a entidade `PC`, que representa os personagens controlados pelos jogadores no jogo. Ela detalha os atributos que definem um PC, incluindo sua localização, experiência, vida, nome, estado atual, evolução, mundo e inventário.

Observação: essa tabela possui chave estrangeira para as tabelas `Personagem`, `Sala`, `Inventario` e `Evolucao`.

| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| IdPersonagem     | int    | Identificador único para o personagem                                                                 | 1 - 5000            | Não                    | Sim. Chave primária e estrangeira | -                 |
| Sala           | int    | Sala em que o PC se encontra                                    | 1 - 5000            | Não                    | Sim. Chave estrangeira                 | -                 |
| xp               | int    | Quantidade de experiência de um PC                                                                    | 0 - 100             | Não                    | Não                  | -                 |
| vidaMax          | int    | Quantidade de vida total que um PC pode ter no nível em que ele está                                  | 0 - 100             | Não                    | Não                  | -                 |
| vidaAtual        | int    | Quantidade de vida que um PC possui                                                                   | 0 - 100             | Sim                    | Não                  | -                 |
| nomePersonagem   | string [50] | Nome do PC em questão                                                                            | A-Z <br />a-z             | Não                    | Não                  | -                 |
| estado           | string [20] | Estado atual do personagem (ex: saudável, ferido, infectado).                                    | A-Z <br />a-z             | Não                    | Não                  | -                 |
| Evolucao         | int    | Indicador do nível do PC                                                                              | 1 - 10              | Não                    | Sim. Chave estrangeira | -                 |
| IdInventario    | int    | Indicador único para o inventário que o PC possui                                                     | 1 - 5000            | Não                    | Sim. Chave estrangeira | -                 |

# Entidade: Inventario
A tabela a seguir descreve a entidade `Inventario`, que representa os inventários dos personagens no jogo. Ela detalha os atributos que definem um inventário, incluindo identificadores, tipo, quantidade de slots, peso e relação com o personagem que o possui.


| **Variável**         | **Tipo**   | **Descrição**                                                                                             | **Valores permitidos** | **Permite valores nulos?** | **É chave?**              | **Outras restrições** |
|------------------|--------|-------------------------------------------------------------------------------------------------------|---------------------|------------------------|----------------------|-------------------|
| idInventario     | int    | Identificador único para o inventário                                                                 | 1 - 5000            | Não                    | Sim. Chave primária  | -                 |
| capacidade  | int    | Atributo que define a capacidade do inventário                | 1 - 30               | Não                  | Não                  | - |
| descricao         | string [50]    | Campo destinado a fornecer uma descrição detalhada ou identificação do inventário.     | a-z <br />  A-Z            | Não            | Não  | -

# Entidade: Item

A tabela a seguir descreve a entidade `Item`, que representa os itens associados a uma missão, incluindo identificadores da missão e do item.

| Variável  | Tipo | Descrição                                             | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|-----------|------|-------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idItem  | int  | Identificador único para o item                    | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| tipoItem    | int  | Identificador para saber o tipo do item | 1 - 3   | Não      | Não | -                  |                | -                 |

# Entidade: Itens

A tabela a seguir descreve a entidade `Itens`, que representa os itens associados a uma missão, incluindo identificadores da missão e do item.

Observação: essa tabela possui chave estrangeira para as tabelas `Item` e `Missao`.

| Variável  | Tipo | Descrição                                             | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|-----------|------|-------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| IdMissao  | int  | Identificador único para a missão                    | 1 - 5000           | Não                    | Sim. Chave primária e estrangeira | -                  |
| IdItem    | int  | Identificador único para o item a ser dropado/recebido | 1 - 5000           | Não                    | Sim. Chave primária e estrangeira | -                  |


# Entidade: Missao

A tabela a seguir descreve a entidade `Missao`, que representa as missões no sistema, incluindo identificadores e o tipo de missão.

| Variável   | Tipo | Descrição                                             | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições           |
|------------|------|-------------------------------------------------------|--------------------|------------------------|----------|------------------------------|
| idMissao   | int  | Identificador único para a missão                    | 1 - 5000           | Não                    | Sim. Chave primária | -                            |
| tipoMis    | int  | Atributo que define o tipo de missão (patrulha ou exploração/obter item) | 1 - 2              | Não                    | Não      | Permite apenas um atributo de tipo |



# Entidade: MissaoExploracaoObterItem

A tabela a seguir descreve a entidade `MissaoExploracaoObterItem`, que representa missões de exploração para obter itens, incluindo identificadores, objetivos, itens adquiridos e participantes.

Observação: essa tabela possui chave estrangeira para as tabelas `Missao` e `Personagem`.

| Variável         | Tipo       | Descrição                                                   | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições                       |
|------------------|------------|-------------------------------------------------------------|--------------------|------------------------|----------|----------------------------------------|
| IdMissao         | int        | Identificador único para a missão                          | 1 - 5000           | Não                    | Sim. Chave primaria e estrangeira | -                                      |
| idMissaoPre      | int        | Identificador único para a missão que é pré-requisito       | 1 - 5000           | Sim                    | Não      | -                                      |
| objetivo         | string[400]| Breve descrição do objetivo da missão, incluindo motivos, envolvidos e local | a - z <br /> A - Z       | Não                    | Não      | -                                      |
| nomeMis          | string[50] | Nome da missão                                             | a - z <br /> A - Z       | Não                    | Não      | -                                      |
| IdPersonagem             | int        | Identificador para o PC que participa da missão            | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                                      |
| xpMis            | int        | Quantidade de XP que a missão pode conceder                 | 1 - 5000           | Não                    | Não      | -                                      |
| statusMissao        | boolean      | Mostra se a missão já foi concluída               | true/false         | Não                    | Não      | -                  |



# Entidade: MissaoPatrulha

A tabela a seguir descreve a entidade `MissaoPatrulha`, que representa as missões de patrulha no sistema, incluindo identificadores, objetivos, nomes, quantidades de NPCs inimigos e informações sobre o PC participante.

Observação: essa tabela possui chave estrangeira para as tabelas `Missao` e `Personagem`.

| Variável      | Tipo       | Descrição                                                   | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|---------------|------------|-------------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| IdMissao      | int        | Identificador único para a missão                          | 1 - 5000           | Não                    | Sim. Chave primária e estrangeira | -                  |
| idMissaoPre   | int        | Identificador único para a missão que é pré-requisito       | 1 - 5000           | Sim                    | Não      | -                  |
| objetivo      | string[400]| Breve descrição do objetivo da missão, incluindo motivos, envolvidos e local | a - z <br /> A - Z       | Não                    | Não      | -                  |
| nomeMis       | string[50] | Nome da missão                                             | a - z <br /> A - Z       | Não                    | Não      | -                  |
| qtdNPCs       | int        | Número de NPCs inimigos a serem derrotados na missão        | 1 - 30             | Não                    | Não      | -                  |
| IdPersonagem          | int        | Identificador para o personagem que participa da missão            | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |
| xpMis         | int        | Quantidade de XP que a missão pode conceder                 | 1 - 5000           | Não                    | Não      | -                  |
| statusMissao        | boolean      | Mostra se a missão já foi concluída               | true/false         | Não                    | Não      | -                  |




# Entidade: Evento

A tabela a seguir descreve a entidade `Evento`, que representa os eventos no sistema, incluindo identificadores, nomes, descrições, coordenadas de localização e participantes.

Observação: essa tabela possui chave estrangeira para as tabelas `PC` e `Sala`.

| Variável     | Tipo       | Descrição                                             | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|--------------|------------|-------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idEvento     | int        | Identificador único para o evento                    | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| nomeEvento   | string[400]       | Nome do evento em questão                            | <br /> A - Z           | Não                    | Não      | -                  |
| descricao    | string[400]        | Breve descrição textual do evento, incluindo local, contexto e atividades | a - z <br /> A - Z           | Não                    | Não      | -                  |
| Sala           | int    | Sala em que o evento acontece                                   | 1 - 5000            | Não                    | Sim. Chave estrangeira                 | -                 |
| IdPersonagem         | int        | Identificador único para o personagem participante do evento  | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |



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
| efeito           | string[70] | Descreve qual efeito a habilidade aplica sobre o jogador ou entidades que ele interage | A-Z <br /> a-z           | Não                    | Não      | -                  |
| duracaoHabilidade| int        | Descreve o tempo que a habilidade dura no alvo       | 1 - 5000           | Não                    | Não      | -                  |
| IdPersonagem             | int        | Personagem que possui a habilidade                            | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |




# Entidade: InstItem

A tabela a seguir descreve a entidade `InstItem`, que representa os itens no inventário, incluindo identificadores e tipos de item.

Observação: essa tabela possui chave estrangeira para a tabela `Item`.

| Variável   | Tipo      | Descrição                                           | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|------------|-----------|-----------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idInstItem     | int       | Identificador único para a instância do item do inventário      | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| IdItem     | int       | Identificador único para o item do inventário      | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |





# Entidade: Arma

A tabela a seguir descreve a entidade `Arma`, que representa as armas contidas no inventário, incluindo identificadores, nomes, dano, munição e tipo de arma.

Observação: essa tabela possui chave estrangeira para as tabelas `Item` e `Inventario`.

| Variável       | Tipo       | Descrição                                            | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|----------------|------------|------------------------------------------------------|--------------------|------------------------|----------|--------------------|
| IdItem         | int        | Identificador único para o item do inventário       | 1 - 5000           | Não                    | Sim. Chave primária e estrangeira | -                  |
| nomeItem      | string[50] | Nome que não identifica unicamente a arma equipada ou encontrada | A-Z <br /> a-z           | Não                    | Não      | -                  |
| dano           | int        | Quantidade de dano que a arma causa                 | 1 - 50             | Não                    | Não      | -                  |
| municaoAtual   | int        | Quantidade atual de munição da arma                 | 0 - 10             | Sim                    | Não      | -                  |
| municaoMax     | int        | Quantidade máxima de munição da arma                | 0 - 10             | Não                    | Não      | -                  |
| IdInventario   | int        | Identificador do inventário ao qual a arma pertence | 1 - 5000           | Sim                    | Sim. Chave estrangeira | -                  |
| eAtaque        | boolean    | Indica se a arma é de ataque (true) ou defesa (false)| true/false         | Não                    | Não      | -                  |
| descricaoItem       | string[400]    | Descrição da arma, incluindo informações como cor, tamanho e formato        | Não                    | Não      | -                  |





# Entidade: Vestimenta

A tabela a seguir descreve a entidade `Vestimenta`, que representa as vestimentas contidas no inventário, incluindo identificadores, nomes, descrições e se são de ataque ou defesa.

Observação: essa tabela possui chave estrangeira para as tabelas `Item` e `Inventario`.

| Variável       | Tipo       | Descrição                                           | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|----------------|------------|-----------------------------------------------------|--------------------|------------------------|----------|--------------------|
| IdItem         | int        | Identificador único para o item do inventário      | 1 - 5000           | Não                    | Sim. Chave primária e estrangeira | -                  |
| nomeItem | string[50] | Nome que não identifica unicamente a vestimenta    | A-Z <br /> a-z           | Não                    | Não      | -                  |
| descricaoItem | string[400] | Descrição da vestimenta, incluindo informações como se fornece armadura ou é apenas decorativo | A-Z <br /> a-z           | Não                    | Não      | -                  |
| IdInventario   | int        | Identificador do inventário ao qual a vestimenta pertence | 1 - 5000           | Sim                    | Sim. Chave estrangeira      | -                  |
| eAtaque        | boolean    | Indica se a vestimenta é de ataque (true) ou defesa (false) | true/false         | Não                    | Não      | -                  |




# Entidade: Consumível

A tabela a seguir descreve a entidade `Consumível`, que representa os alimentos contidos no inventário, incluindo identificadores, nomes, tipos e efeitos no jogo.

Observação: essa tabela possui chave estrangeira para as tabelas `Item` e `Inventario`.

| Variável      | Tipo       | Descrição                                           | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|---------------|------------|-----------------------------------------------------|--------------------|------------------------|----------|--------------------|
| IdItem        | int        | Identificador único para o item do inventário      | 1 - 5000           | Não                    | Sim. Chave primária e estrangeira | -                  |
| nomeItem  | string[50] | Nome que não identifica unicamente o alimento      | A-Z <br /> a-z           | Não                    | Não      | -                  |
| tipoConsumivel  | string[40] | Tipo de alimento (ex.: fruta, carne, bebida, barras, vitaminas) | A-Z <br /> a-z           | Não                    | Não      | -                  |
| aumentoVida   | int        | Quantidade de vida que o alimento aumenta          | 1 - 20             | Sim                    | Não      | -                  |
| IdInventario  | int        | Identificador do inventário ao qual o alimento pertence | 1 - 5000           | Sim                    | Sim. Chave estrangeira | -                  |
| eAtaque       | boolean    | Indica se o alimento é de ataque (true) ou defesa (false) | false              | Não                    | Não      | Como alimento não pode ser classificado como ataque ou defesa, seu valor será sempre falso |
| descricaoItem       | string[400]    | Descrição do alimento, incluindo informações como classificação, cor, tamanho etc        | Não                    | Não      | -                  |




# Entidade: Receita

A tabela a seguir descreve a entidade `Receita`, que representa as receitas disponíveis, incluindo identificadores, nomes, descrições, tempo de preparo e itens resultantes.

Observação: essa tabela possui chave estrangeira para a tabela `Item`.

| Variável       | Tipo      | Descrição                                         | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|----------------|-----------|---------------------------------------------------|--------------------|------------------------|----------|--------------------|
| idReceita      | int       | Identificador único para a receita                | 1 - 5000           | Não                    | Sim. Chave primária | -                  |
| nomeReceita    | string[50]| Nome da receita a ser feita                       | A-Z <br /> a-z           | Não                    | Não      | -                  |
| descricaoReceita | string[400] | Breve descrição textual da receita, incluindo ingredientes e item a ser feito | A-Z <br /> a-z           | Não                    | Não      | -                  |
| tempoCraft     | int       | Tempo, em segundos, necessário para que a receita fique pronta | 1 - 60             | Não                    | Não      | -                  |
| IdItem         | int       | Identificador único para o item resultante da receita | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                  |



# Entidade: Ingrediente

A tabela a seguir descreve a entidade `Ingrediente`, que representa os ingredientes utilizados em receitas, incluindo identificadores únicos e quantidades.

Observação: essa tabela possui chave estrangeira para as tabelas `Item` e `Receita`.

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

Observação: essa tabela possui chave estrangeira para as tabelas `Evolucao` e `Consumivel`.

| **Variável**    | **Tipo** | **Descrição**                                      | **Valores permitidos** | **Permite valores nulos?** | **É chave?**                   | **Outras restrições**                |
|-------------|------|------------------------------------------------|--------------------|------------------------|----------------------------|----------------------------------|
| IdEvolucao  | int  | Identificador único para a evolução            | 1 - 5000           | Não                    | Sim. Chave primária composta e chave estrangeira | -                                |
| IdConsumivel  | int  | Identificador único para o alimento            | 1 - 5000           | Não                    | Sim. Chave primária composta e chave estrangeira | -                                |



# Relacionamento: Dialoga

A tabela a seguir descreve o relacionamento `Dialoga`, que registra os detalhes dos diálogos entre falantes e ouvintes, incluindo identificadores e conteúdo do diálogo.

Observação: essa tabela possui chave estrangeira para a tabela `Personagem`.

| Variável      | Tipo       | Descrição                                         | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições           |
|---------------|------------|---------------------------------------------------|--------------------|------------------------|----------|------------------------------|
| idDialogo     | int        | Identificador único para o diálogo                | 1 - 5000           | Não                    | Sim. Chave primária | -                            |
| IdFalante     | int        | Identificador único do falante do diálogo         | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                            |
| IdOuvinte     | int        | Identificador único do ouvinte do diálogo         | 1 - 5000           | Não                    | Sim. Chave estrangeira | -                            |
| conteudo      | string[400] | O que foi abordado no diálogo entre os envolvidos | A - Z, a - z        | Não                    | Não      | -                            |
| duracaoDialogo| int        | Tempo de duração do diálogo em segundos                        | 1 - 2000           | Não                    | Não      | -                            |



# Entidade: InstNPC

A tabela a seguir descreve a entidade `InstNPC`, que representa os NPCs no sistema, incluindo identificadores únicos e a classificação do tipo de NPC.

Observação: essa tabela possui chave estrangeira para a tabela `NPC`.

| Variável | Tipo | Descrição | Valores permitidos | Permite valores nulos? | É chave? | Outras restrições |
|----------|------|-----------|--------------------|------------------------|----------|--------------------|
| IdInstNPC    | int  | Identificador único para a instância do NPC | 1 - 5000 | Não | Sim. Chave primária | - |
| tipoNPC    | int  | Referencia qual filho de NPC a intância é criada | 1 - 5000 | Não | Não | Sim. Chave estrangeira | 


# Entidade: Infectado 

A tabela a seguir descreve a entidade `Infectado` que contém informações sobre os infectados, incluindo identificadores únicos, comportamentos e características principais.

Observação: essa tabela possui chave estrangeira para a tabela `NPC`.

| **Variável**         | **Tipo**     | **Descrição**                                                                 | **Valores permitidos** | **Permite valores nulos?** | **É chave?** | **Outras restrições**        |
| -------------------- | ------------ | ----------------------------------------------------------------------------- | ---------------------- | ------------------------- | ------------ | ---------------------------- |
| IdNPC                | int          | Identificador único para o NPC                                                | 1 - 5000               | Não                       | Sim. Chave primária e estrangeira            | -|
| comportamentoInfec   | string [400] | Breve descrição do comportamento do infectado, com principais características | a - z, A - Z           | Não                       | Não          | -                            |
| velocidade   | int | Medidor da rapidez que um infectado corre | 0 - 10           | Não                       | Não          | -                            |


# Entidade: FaccaoHumana

A tabela a seguir descreve a entidade `FaccaoHumana` que contém informações sobre as facções humanas, incluindo identificadores únicos, nomes, e relações com NPCs.

Observação: essa tabela possui chave estrangeira para a tabela `NPC`.

| **Variável**   | **Tipo**     | **Descrição**                            | **Valores permitidos** | **Permite valores nulos?** | **É chave?** | **Outras restrições**        |
| -------------- | ------------ | ---------------------------------------- | ---------------------- | ------------------------- | ------------ | ---------------------------- |
| IdNPC          | int          | Identificador único para o NPC           | 1 - 5000               | Não                       | Sim. Chave primária e estrangeira        | -      |
| nomeFaccao     | string [50]  | Nome da facção em questão                | a - z, A - Z           | Não                       | Não          | -                            |



# Entidade: Animal

A tabela a seguir descreve a entidade `Animal` que contém informações sobre os animais, incluindo identificadores únicos, nomes, e as ameaças que eles podem apresentar.

Observação: essa tabela possui chave estrangeira para a tabela `NPC`.

| **Variável**  | **Tipo**      | **Descrição**                            | **Valores permitidos** | **Permite valores nulos?** | **É chave?** | **Outras restrições**        |
| ------------- | ------------- | ---------------------------------------- | ---------------------- | ------------------------- | ------------ | ---------------------------- |
| IdNPC         | int           | Identificador único para o NPC           | 1 - 5000               | Não                       | Sim. Chave primária e estrangeira              | -         |
| nomeAnimal    | string [50]   | Nome do animal em questão                | a - z, A - Z           | Não                       | Não          | -                            |
| ameaca        | string [100]  | Ameaça que o animal pode apresentar      | a - z, A - Z           | Não                       | Não          | -                            |

# Relacionamento: Participacao

A tabela a seguir descreve o relacionamento `Participacao`, que indica a participação de um NPC em eventos e missões. Cada registro na tabela contém identificadores únicos para o NPC, o evento e a missão.

Observação: essa tabela possui chave estrangeira para as tabelas `NPC`, `Evento` e `Missao`.

| **Variável**   | **Tipo**     | **Descrição**                                                    | **Valores permitidos** | **Permite valores nulos?** | **É chave?** | **Outras restrições**                |
| -------------- | ------------ | ---------------------------------------------------------------- | ---------------------- | ------------------------- | ------------ | ------------------------------------ |
| IdNPC          | int          | Identificador único para o NPC                                   | 1 - 5000               | Não                       | Sim. Chave primária e estrangeira   |     - |
| Evento         | int          | Identificador único para o evento que o NPC participa            | 1 - 5000               | Não                       | Sim. Chave primária e estrangeira    |   -  |
| Missao         | int          | Identificador único para a missão que o NPC participa            | 1 - 5000               | Não                       | Sim. Chave primária e estrangeira     | -   |


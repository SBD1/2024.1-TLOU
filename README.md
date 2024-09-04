# 2024.1-TLOU
Repositório destinado ao desenvolvimento do projeto The Last Of Us, da disciplina de Sistemas de Banco de Dados 1.

<div align="center"> <img src="./Docs/static/img/tlou_header1.jpg" height="230" width="auto"/> </div>

## Jogo

No sombrio mundo pós-apocalíptico de The Last of Us, você assume o papel de Joel, um sobrevivente endurecido pela perda e pelo desespero. Após uma pandemia devastadora transformar grande parte da humanidade em criaturas hostis e sedentas por carne humana, você se aventura por paisagens urbanas abandonadas e terras selvagens, lutando para sobreviver em um mundo onde os recursos são escassos e o perigo espreita a cada esquina.

## Como o jogo funciona?

The Last of Us é um jogo de ação e sobrevivência que se desenrola em ambientes variados, desde cidades em ruínas até áreas selvagens dominadas pela natureza. Você enfrenta desafios constantes para encontrar suprimentos, evitar ou enfrentar infectados e lidar com outros sobreviventes hostis.

As habilidades de Joel incluem combate corpo a corpo, uso de armas improvisadas e furtividade para evitar confrontos diretos. Materiais encontrados podem ser usados para criar itens úteis como kits de armadura, munição improvisada e coquetéis molotov.

A exploração é fundamental, tanto de áreas urbanas infestadas por infectados quanto de cenários naturais onde recursos preciosos podem ser encontrados. Cada local oferece desafios únicos e recompensas potenciais, incentivando uma abordagem estratégica para a exploração.

Além dos infectados, outros sobreviventes humanos representam uma ameaça constante. Eles podem ser hostis ou aliados em potencial, oferecendo negociações ou ameaças dependendo das interações de Joel com eles.

A narrativa intensa e os personagens complexos enriquecem a experiência, com diálogos profundos e momentos de decisão que moldam o destino de Joel e sua jovem companheira, Ellie.

Em suma, The Last of Us combina ação envolvente, elementos de sobrevivência e uma história emocionalmente cativante, desafiando os jogadores a enfrentar não apenas os perigos físicos do mundo pós-apocalíptico, mas também os dilemas morais de uma sociedade à beira do colapso.

## Como rodar?

Para jogar **The Last of Us - MUD**, siga os passos abaixo:

1. **Requisitos**
   - [Docker](https://www.docker.com/get-started)
   - [Node.js](https://nodejs.org/)

2. **Subir os contêineres em segundo plano:**
   - Abra o terminal e dirija-se até o repositório "2024.1-TLOU" e execute:
     ```bash
     docker compose up -d
     docker compose up --build
     ```

3. **Instalar dependências e rodar o jogo:**
   - Abra um segundo terminal, encontre o repositório "2024.1-TLOU" e execute:
     ```bash
     npm i
     cd src
     node main.js
     ```

## Apresentações

| Módulo | Link da gravação                                                                                             | Data       |
| ------ | ------------------------------------------------------------------------------------------------------------ | ---------- |
| 1      | [Apresentação do Módulo 1](https://www.youtube.com/watch?v=qEP-Pjk8k78)                                   | 22/07/2024 |
| 2      | [Apresentação do Módulo 2](https://youtu.be/pTEGCB_m3H0)                                                   | 19/08/2024 |

## Entregas

- **Módulo 1**
  - [Diagrama Entidade-Relacionamento](./Docs/docs/primeira-entrega/DER.md)
  - [Dicionário de Dados](./Docs/docs/primeira-entrega/DD.md)
  - [Modelo Entidade-Relacionamento](./Docs/docs/primeira-entrega/MER.md)
  - [Modelo Relacional](./Docs/docs/primeira-entrega/MRel.md)

- **Módulo 2**
  - [DDL](./Docs/docs/segunda-entrega/DDL.md)
  - [DML](./Docs/docs/segunda-entrega/DML.md)
  - [DQL](./Docs/docs/segunda-entrega/DQL.md)
  - [Álgebra Relacional](./Docs/docs/segunda-entrega/AR.md)

## Histórico de versões

| Versão |    Data    | Descrição                                      | Autor                                  | Revisão             |
| :----: | :--------: | ---------------------------------------------- | -------------------------------------- | -------------------- |
| `1.0`  | 22/07/2024 | Inclusão das considerações feitas na modelagem | Ana Júlia e Júlia                     | Arthur e Maria Clara |
| `1.1`  | 22/07/2024 | Estruturação do README do projeto              | Arthur e Maria Clara                  | Ana Júlia e Júlia    |
| `2.0`  | 09/08/2024 | Correção da primeira entrega do projeto de acordo com *feedback* do professor | Todos                                  | Todos               |
| `2.1`  | 19/08/2024 | Atualização da documentação para o Módulo 2 e entrega.             | Todos                                  | Todos               |

## Autores

| <a href="https://github.com/ailujana"><img src="https://avatars.githubusercontent.com/u/107697177?v=4" width="150"></img></a> | <a href="https://github.com/Tutzs"><img src="https://avatars.githubusercontent.com/u/110691207?s=400&u=0f285ace4b3188bb274e2531ead3691d7161656a&v=4" width="150"></img></a> | <a href="https://github.com/julia-fortunato"><img src="https://avatars.githubusercontent.com/u/118139107?v=4" width="150"></img></a> | <a href="https://github.com/Oleari19"><img src="https://avatars.githubusercontent.com/u/110275583?v=4" width="150"></img></a> |
|----------|----------|----------|----------|
| [Ana Júlia](https://github.com/ailujana) - 221007798 | [Arthur Sousa](https://github.com/Tutzs) - 21022462 | [Júlia Fortunato](https://github.com/julia-fortunato) - 221022355 | [Maria Clara](https://github.com/Oleari19) - 221008338 |

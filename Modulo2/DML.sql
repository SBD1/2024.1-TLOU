BEGIN TRANSACTION;

INSERT INTO Regiao (idRegiao, descricaoRegiao, nomeRegiao, capacidade, tipoRegiao,z_seguranca, z_populacaoAtual, a_defesa, l_tipo, l_periculosidade) VALUES
(1, 'Zona de quarentena fortemente vigiada, com muros altos e guardas armados.', 'Zona de Quarentena de Boston', 20, 'Z',5 , 10, NULL, NULL, NULL),
(2, 'Área devastada e infestada de infectados.', 'Cidade Abandonada', 15, 'L', NULL, NULL, NULL, 'Cidade Abandonada', 8),
(3, 'Território dominado por um grupo de mercenários.', 'Território Mercenário', 10, 'Z',5 , 10, NULL, NULL, NULL),
(4, 'Esgoto infestado de criaturas perigosas.','Esgoto Abandonado', 15, 'L', NULL, NULL, NULL, 'Esgoto', 5),
(5, 'Jackson: Vilarejo reconstruído, onde os habitantes tentam viver em paz.', 'Vilarejo Pacífico', 35, 'A', NULL,NULL,12,NULL,NULL),
(6, 'Hospital Saint Mary', 'Hospital Saint Mary', 15, 'R', NULL, NULL, NULL, NULL, NULL);

INSERT INTO Sala (idSala, IdRegiao) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 2),
(6, 3),
(7, 3),
(8, 3),
(9, 4),
(10, 4),
(11, 4),
(12, 5),
(13, 5),
(14, 5),
(15, 5),
(16, 6),
(17, 6),
(18, 6);

INSERT INTO Personagem (idPersonagem, tipoPersonagem) VALUES 
(1, 'P'),
(2, 'N'),
(3,  'N'),
(4,  'N'),
(5,  'N'),
(6,  'N'),
(7,  'N'),
(8,  'N'),
(9,  'N'),
(10,  'N'),
(11,  'N'),
(12,  'N'),
(13,  'N'),
(14,  'N'),
(15,  'N'),
(16,  'N'),
(17,  'N'),
(18,  'N'),
(19,  'N'),
(20,  'N'),
(21,  'N'),
(22,  'N'),
(23,  'N');

INSERT INTO Inventario (idInventario, capacidade, descricao) VALUES
(1, 30, 'Inventário do Joel.'),
(2, 30, 'Inventário do Ellie.'),
(3, 15, 'Inventário do Tommy.'),
(4, 15, 'Inventário do Tess.'),
(5, 15, 'Inventário do Henry.');

INSERT INTO Missao(idMissao, tipoMis) VALUES
(1, 'E'),
(2, 'P'),
(3, 'E'),
(4, 'P'),
(5, 'E'),
(6, 'P'),
(7, 'E'),
(8, 'P'),
(9, 'E'),
(10, 'P'),
(11, 'P'),
(12, 'E');

INSERT INTO Item(idItem, tipoItem) VALUES
(1, 'A'),
(2, 'A'),
(3, 'A'),
(4, 'A'),
(5, 'A'),
(6, 'A'),
(7, 'V'),
(8, 'V'),
(9, 'V'),
(10, 'V'),
(11, 'V'),
(12, 'C'),
(13, 'C'),
(14, 'C'),
(15, 'C'),
(16, 'C'),
(17, 'C'),
(18, 'C'),
(19, 'C'),
(20, 'C'),
(21, 'C'),
(22, 'C'),
(23, 'C'),
(24, 'C');


INSERT INTO InstItem(idInstItem, IdItem, Sala, IdInventario) VALUES
(1, 18, 1, NULL),
(2, 18, 1, NULL),
(3, 18, 1, NULL),
(4, 18, 1, NULL),
(5, 18, 1, NULL),
(6, 12, 1, NULL),
(7, 12, 1, NULL),
(8, 17, 1, NULL),
(9, 17, 1, NULL),
(10, 3, 2, NULL),
(11, 23, 3, NULL);

INSERT INTO Itens (IdMissao, IdItem) VALUES
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6);

INSERT INTO NPC (IdPersonagem, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, eAliado, tipoNPC) VALUES
(2, 30, 100, 100, 'Ellie', 2, true, 'F'),
(3, 10, 90, 90, 'Sobrevivente Selvagem', NULL, false, 'F'),
(4, 10, 100, 100, 'Líder de Facção', NULL, false, 'F'),
(5, 10, 100, 100, 'Tess', 4, true, 'F'),
(6, 10, 100, 100, 'Tommy',3, true, 'F'),
(7, 10, 100, 100, 'Marlene', NULL, false, 'F'),
(8, 10, 100, 100, 'Henry', 5, true, 'F'),
(9, 10, 80, 80, 'Sam', NULL, true, 'F'),
(10, 10, 100, 100, 'Bill', NULL, true, 'F'),
(11, 10, 100, 100, 'David', NULL, false, 'F'),
(12, 10, 100, 100, 'Sobrevivente Viajante', NULL, false, 'F'),
(13, 10, 100, 100, 'Médico da Zona Segura', NULL, false, 'F'),
(14, 10, 30, 30, 'Corredor', NULL, false, 'I'),
(15, 10, 45, 45, 'Estalador', NULL, false, 'I'),
(16, 10, 120, 120, 'Baiacu', NULL, false,'I'),
(17, 10, 45, 45, 'Espreitador', NULL, false, 'I'),
(18, 10, 100, 100, 'Vagalumes', NULL, false, 'F'),
(19, 10, 100, 100, 'Serafitas', NULL, false, 'F'),
(20, 10, 30, 30, 'Lobo Selvagem', NULL, false, 'A'),
(21, 10, 45, 45, 'Urso Pardo', NULL, false, 'A'),
(22, 10, 20, 20, 'Peixes', NULL, true, 'A'),
(23, 10, 15, 15, 'Insetos', NULL, false, 'A');


INSERT INTO Arma(IdItem, nomeItem, dano, municaoAtual, municaoMax, eAtaque, descricaoItem) VALUES
(1, 'Revólver', 20, 6, 6, true, 'Uma arma compacta e confiável, eficaz a curta distância.'),
(2, 'Pistola', 10, 14, 14, true, 'Versátil, com bom equilíbrio entre potência e capacidade de munição.'),
(3, 'Rifle', 30, 7, 7, true, 'Alto impacto para disparos de longa distância.'),
(4, 'Escopeta', 25, 4, 4, true, 'Poder de fogo considerável a curta distância.'),
(5, 'Arco', 15, 20, 20, true, 'Silencioso e eficaz para ataques de longo alcance.'),
(6, 'Faca', 8, NULL, 3, true, 'Afiada e versátil para combate corpo a corpo.');

INSERT INTO Vestimenta(IdItem, nomeItem, descricaoItem, eAtaque, defesa) VALUES
(7, 'Jaqueta de Couro', 'Jaqueta resistente a cortes e arranhões.', false, 7),
(8, 'Colete Tático', 'Colete à prova de balas para proteção extra.',false, 20),
(9, 'Calça Canvas', 'Calça muita resistente.', false, 10),
(10, 'Camisa de Combate', 'Camisa resistente para proteção do torso.', false, 9),
(11, 'Escudo de Madeira', 'Escudo robusto para defesa contra inimigos.', false, 17);

INSERT INTO Consumivel(IdItem, nomeItem, tipoConsumivel, aumentoVida, eAtaque, descricaoItem, danoConsumivel) VALUES
(12, 'Barra de Cereal', 'Energético', 10,  false, 'Fornece um aumento leve de energia e vitalidade.', NULL),
(13, 'Pacote de Biscoitos', 'Carboidrato', 1, false, 'Aumenta a energia com um bom nível de carboidratos.', NULL),
(14, 'Garrafa de Água', 'Hidratante', 25,  false, 'Restaura a hidratação e aumenta a resistência.', NULL),
(15, 'Pacote de Salgadinhos', 'Salgado', 1, false, 'Aumenta a vitalidade com um toque salgado.', NULL),
(16, 'Vitaminas de evolução', 'Vitaminas, enzimas', 55, false, 'Potente suplemento de vitaminas e enzimas para grandes melhorias.', NULL),
(17, 'Kit de Primeiros Socorros', 'Kit básico para curativos', 50, false, 'Combinação de álcool e trapos para aumentar vida', NULL);
(18, 'Munição', 'Projétil', NULL, true, 'Munição para uso em armas de fogo.', NULL),
(19, 'Álcool', 'Reagente', NULL, false, 'Reagente útil para criação e improvisação.', NULL),
(20, 'Trapos', 'Material', NULL,false, 'Material básico para reparos e construção.', NULL),
(21, 'Recipiente', 'Contêiner', NULL, false, 'Contêiner versátil para armazenar itens e líquidos.', NULL ),
(22, 'Explosivo', 'Reagente', NULL, true, 'Reagente perigoso para criar explosivos e destruição.', NULL),
(23, 'Fita', 'Material', NULL,false, 'Material adesivo útil para reparos rápidos.', NULL),
(24, 'Lâmina', 'Material', NULL, true, 'Lâmina cortante para combate ou uso em ferramentas.', NULL);
(25, 'Bomba de Fumaça', 'Bomba', NULL, true, 'Bomba que cria uma cortina de fumaça para cobertura.', 25),
(26, 'Mina de Proximidade', 'Granada fixa', NULL, true, 'Mina explosiva que explode ao primeiro contato', 25 ),
(27, 'Coquetel Molotov', 'Projétil explosivo.', NULL, true, 'Garrafa incendiária utilizada para causar danos de fogo em área.', 15),
(28, 'Bomba de Pregos', 'Projétil explosivo', NULL, true, 'Bomba que detona ao contato, causando dano em área com fragmentos de pregos.', 30),
(29, 'Bomba Incendiária', 'Projétil explosivo', NULL, true, 'Bomba que causa uma explosão de fogo ao ser lançada.', 25),
(30, 'Flechas', 'Munição', NULL, true, 'Munição para arco.', NULL);

INSERT INTO Receita(idReceita, nomeReceita, descricaoReceita, tempoCraft, IdItem, juncao) VALUES
(1, 'Kit de Primeiros Socorros', 'Kit básico para curativos e tratamento de ferimentos.', 1, 17, 'Álcool + Trapos'),
(2, 'Bomba de Fumaça', 'Bomba que cria uma cortina de fumaça para cobertura.', 4, 25, 'Recipiente + Explosivo'),
(3, 'Mina de Proximidade', 'Granada explosiva que causa dano em área.', 5, 26, 'Recipiente + Explosivo'),
(4, 'Coquetel Molotov', 'Garrafa incendiária utilizada para causar danos de fogo em área.', 7, 27, 'Álcool + Trapos'), 
(5, 'Faca', 'Ferramenta improvisada que pode ser usada para ataques furtivos e abrir portas trancadas.', 2, 6, 'Lâmina + Trapos'),
(6, 'Bomba de Pregos', 'Explosivo improvisado que detona ao contato, causando dano em área com fragmentos de pregos.', 5, 28, 'Explosivo + Lâmina'),
(7, 'Bomba Incendiária', 'Dispositivo explosivo que causa uma explosão de fogo ao ser lançado.', 4, 29, 'Álcool + Explosivo')
(8, 'Flechas', 'Munição para arco, pode ser craftada utilizando materiais encontrados.', 2, 30, 'Fita + Lâmina');

INSERT INTO Ingrediente(idIngrediente, IdReceita, IdItem, quantidadeIngre) VALUES
(1, 1, 19, 1),
(2, 1, 20, 1),
(3, 2, 21, 1),
(4, 2, 22, 1),
(5, 3, 21, 1),
(6, 3, 22, 1),
(7, 4, 19, 1),
(8, 4, 20, 1),
(9, 5, 24, 1),
(10, 5, 20, 1),
(11, 6, 22, 1),
(12, 6, 24, 1),
(13, 7, 19, 1),
(14, 7, 22, 1),
(15, 8, 23, 1),
(16, 8, 24, 1);

INSERT INTO Evolucao(idEvolucao, requisitoNivel, xpEvol) VALUES
(1, 5, 100),
(2, 6, 150),
(3, 7, 200),
(4, 8, 250),
(5, 9, 300),
(6, 10, 350),
(7, 11, 400),
(8, 12, 450),
(9, 13, 500),
(10, 14, 550);

INSERT INTO PC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, estado, Evolucao, IdInventario) VALUES
(1, 1, 70, 100, 100, 'Joel', 'saudável', 5, 1);

INSERT INTO Evento (idEvento, nomeEvento, descricao, Sala, IdPersonagem) VALUES
(1, 'Primeiro contato com Ellie', 'Ellie é encontrada pela primeira vez, trazida por Marlene na Zona de Quarentena.', 1, 1),
(2, 'Morte de Tess', 'Tess sacrifica sua vida para garantir a segurança do grupo, enfrentando os infectados com coragem e determinação.', 3, 1),
(3, 'Joel descobre que Ellie é imune', 'Joel descobre que Ellie é imune ao vírus após uma conversa com Marlene.', 6, 1),
(4, 'Encontro com Bill', 'Durante a busca por suprimentos, Joel e Ellie encontram Bill, que os ajuda a montar um veículo para continuar a viagem.', 8, 1),
(5, 'Sam se infecta e Henry tira sua própria vida', 'Sam é infectado, e, incapaz de lidar com a perda, Henry tira sua própria vida.', 12, 1),
(6, 'Pai e Filha', 'Joel e Ellie finalmente chegam à comunidade de Tommy, onde Joel considera deixar Ellie sob os cuidados de seu irmão.', 14, 1),
(7, 'Captura de Ellie', 'Ellie é capturada por David enquanto foge de Jackson após uma discussão com Joel.', 15, 1),
(8, 'Ellie mata David', 'Ellie mata David em legítima defesa após ser capturada e quase abusada por ele.', 16, 1),
(9, 'Joel salva Ellie', 'Joel descobre que Ellie será sacrificada no hospital e decide resgatá-la, enfrentando os Vagalumes.', 18, 1);

INSERT INTO Itinerario(idItinerario, horario, dia, idEvento) VALUES
(1, 10, '2024-01-23', 1),  
(2, 12, '2024-01-23', 2),
(3, 14, '2024-01-23', 3), 
(4, 16, '2024-01-23', 4), 
(5, 18, '2024-01-23', 5),  
(6, 08, '2024-08-14', 6),  
(7, 20, '2024-08-14', 7),  
(8, 22, '2024-08-14', 8),  
(9, 19, '2024-08-14', 9);  

INSERT INTO Habilidade(idHabilidade, nomeHabilidade, tipoHabilidade, efeito, duracaoHabilidade, IdPersonagem) VALUES
(1, 'Furtividade', 'Passiva', 'Aumenta a chance de passar despercebido pelos inimigos.', 10, 1),
(2, 'Recuperação Rápida', 'Ativa', 'Recupera uma quantidade moderada de vida durante o combate.', 5, 1),
(3, 'Ataque Furtivo', 'Ativa', 'Causa dano extra em ataques surpresa.', 6, 1),
(4, 'Recarga Rápida', 'Ativa', 'Recarrega a arma mais rapidamente durante o combate.', 10, 1),
(5, 'Ataque Preciso', 'Ativa', 'Aumenta a precisão dos tiros por um curto período.', 10, 1),
(6, 'Esquiva Rápida', 'Ativa', 'Permite esquivar de ataques inimigos com maior facilidade.',  5, 1),
(7, 'Ataque em Grupo', 'Ativa', 'Aumenta o dano causado em ataques conjuntos com aliados.',5, 1),
(8, 'Defesa Reforçada', 'Passiva', 'Diminui o dano recebido em combate.', 5, 1),
(9, 'Ataque Certeiro', 'Ativa', 'Aumenta a chance de acerto crítico em ataques.', 5, 1);

INSERT INTO MissaoExploracaoObterItem (IdMissao, idMissaoPre, objetivo, nomeMis, IdPersonagem, xpMis, statusMissao, Sala) VALUES
(1, NULL, 'Com o pedido de Marlene, leve uma jovem chamada Ellie para fora da cidade', 'Ellie', 1, 15, false, 2),
(3, 2, 'Após a morte de Tess, Joel e Ellie partem em uma missão atrás de Bill, um antigo amigo de Joel', 'Os Arredores', 1, 25, false, 6),
(4, 3, 'Joel e Ellie chegam à cidade de Bill. Esta missão inclui a busca por suprimentos e a montagem de veículo', 'Cidade de Bill', 1, 35, false, 8),
(5, 4, 'Joel e Ellie encontram Henry e Sam em Pittsburgh, dois irmãos sobreviventes. Juntos, eles enfrentam hordas de infectados e tentam encontrar um caminho seguro', 'Henry e Sam', 1, 55, false, 11),
(7, 6, 'Joel e Ellie finalmentre chegam ao local onde Tommy está vivendo em uma comunidade segura. Joel considera deixar Ellie com Tommy', 'Represa', 1, 60, false, 13),
(9, 8, 'Joel e Ellie chegam ao hospital. Joel descobre que Ellie precisa ser sacrificada e a salva', 'Laboratório dos Vagalumes', 1, 30, false, 17),
(12, 11, 'Joel e Ellie voltam a Jackson. Ellie confronta Joel', 'Final', 1, 30, false, 16);

INSERT INTO MissaoPatrulha (IdMissao, idMissaoPre, objetivo, nomeMis, qtdNPCs, IdPersonagem, xpMis, statusMissao, Sala) VALUES
(2, 1, 'Patrulhar a àrea devastada em busca de ameaças.', 'Segurança', 5, 1, 150, false, 4),
(6, 5, 'Neutralizar os infectados próximos ao esgoto.', 'Segurança do Acampamento', 8, 1, 250, false, 12),
(8, 7, 'Resgatar Ellie de David.', 'Operação de Reconhecimento', 9, 1, 400, false, 14),
(10, 9, 'Mate todos os vagalumes do Hospital Saint Mary.', 'Defesa do Assentamento', 8, 1, 450, false, 18),
(11, 10, 'Limpe o caminho para chegar até Jackson.', 'Proteção das Fronteiras', 5, 1, 350, false, 15);


INSERT INTO Concede(IdEvolucao, IdConsumivel) VALUES
(1, 12),
(2, 13),
(3, 14),
(4, 15),
(5, 16),
(6, 17),
(7, 18),
(8, 19),
(9, 21); 

INSERT INTO Dialoga (idDialogo, IdFalante, IdOuvinte, conteudo, duracaoDialogo) VALUES
(1, 1, 5, 'Joel: Tess, qual é a missão de hoje?', 5),
(2, 5, 1, 'Tess: Joel, precisamos resolver a questão com o Mark, ele está causando problemas de novo.', 10),
(3, 1, 5, 'Joel: Não temos tempo a perder. Vamos.', 5),
(4, 7, 1, 'Marlene: Esqueçam o Mark, tenho um trabalho maior. Levem essa garota até o Capitólio, e 100 tickets de comida serão de vocês.', 10),
(5, 1, 2, 'Joel: Como você chegou aqui, garota?', 5),
(6, 2, 1, 'Ellie: Eu não sei! Só estou tentando sobreviver... Será que vamos conseguir?', 8),

(7, 1, 2, 'Joel: "Ellie, mantenha-se atrás de mim e faça o que eu mandar. Não quero problemas."', 10),
(8, 2, 1, 'Ellie: "Eu... Eu ainda não entendo por que vocês estão me ajudando."', 8),

(9, 1, 2, 'Joel: "Ellie, pegue o que puder. Cada bala, cada pedaço de comida... tudo conta."', 10),
(10, 2, 1, 'Ellie: "Joel, por que você continua me protegendo? Eu sou só um fardo para você?"', 10),
(11, 1, 2, 'Joel: "Não é nada disso, Ellie. Apenas faça o que eu digo."', 8),

(12, 1, 2, 'Joel: "Por que não me disse antes? Por que escondemos isso?"', 8),
(13, 2, 1, 'Ellie: "Eu achei que você ia me abandonar, como todos os outros..."', 8),

(14, 10, 2, 'Bill: "Vocês estão ferrados, sabiam? O mundo lá fora... não é um lugar pra amadores."', 10),
(15, 2, 10, 'Ellie: "Bill, você é um cara difícil, sabia? Mas acho que gosta de ter companhia."', 10),
(16, 1, 10, 'Joel: "Bill, só nos ajude a sair daqui vivos. Depois a gente vê quem está certo."', 10),

(17, 8, 8, 'Henry: "Sam, fica perto de mim, tá? Não podemos nos dar ao luxo de nos separarmos."', 8),
(18, 2, 1, 'Ellie: "Joel, esses caras... eles estão com medo, não estão?"', 10),
(19, 1, 2, 'Joel: "Medo é o que nos mantém vivos, Ellie. Mas não deixe que ele te controle."', 10),

(20, 8, 8, 'Henry (desesperado): "Sam... Não... Por quê? Por quê?"', 10),
(21, 2, 8, 'Ellie (chorando): "Henry, não... Não faça isso!"', 8),
(22, 1, 8, 'Joel: "Henry, por favor... Não..."', 10),

(23, 6, 1, 'Tommy: "Joel, o que você está fazendo aqui? Pensei que não fosse mais voltar."', 10),
(24, 1, 6, 'Joel: "Não estou aqui por mim, Tommy. É por ela. Preciso que leve ele até aos Vagalumes"', 10),
(25, 2, 1, 'Ellie: "O que?"', 5),

(26, 2, 1, 'Ellie: "Eu não sou ela, sabe... Eu sou só mais uma pessoa que você vai perder, não é?"', 10),
(27, 1, 2, 'Joel: "Você não sabe do que está falando! Eu não posso continuar perdendo. Não mais."', 10),
(28, 2, 1, 'Ellie: "Todo mundo que eu amei ou morreu ou me deixou... menos você. Então, não me diga que eu estaria mais segura com outra pessoa."', 15),
(29, 1, 2, 'Joel: "Você está certo... você não é minha filha. E eu com certeza não sou seu pai... e vamos nos separar."', 15),

(30, 2, 1, 'Ellie (em pânico): "Você não vai me machucar de novo... Você não vai!"', 10),
(31, 1, 2, 'Joel (tentando acalmá-la): "Ellie... sou eu. Está tudo bem... Está tudo bem."', 10),

(32, 7, 1, 'Marlene: "Joel, você sabe o que está em jogo aqui. Não torne isso mais difícil do que já é."', 10),
(33, 1, 7, 'Joel: "Difícil? Você quer sacrificá-la! Não vou deixar isso acontecer."', 10),
(34, 7, 1, 'Marlene: "Eu não tenho escolha, Joel. Você sabe disso."', 10),

(35, 2, 1, 'Ellie: "Joel... O que aconteceu lá no hospital?"', 8),
(36, 1, 2, 'Joel: "Eu... Eu fiz o que precisava ser feito. Agora estamos a salvo. É tudo o que importa."', 10),
(37, 2, 1, 'Ellie: "Eu só quero acreditar que você está dizendo a verdade..."', 10);

INSERT INTO InstNPC(IdInstNPC, IdNPC, tipoNPC, Sala) VALUES
(1, 1, 1, 1),
(2, 2, 3, 1),
(3, 3, 4, 1),
(4, 4, 1, 1),
(5, 5, 1, 1),
(6, 6, 1, 1),
(7, 7, 1, 1),
(8, 8, 1, 2),
(9, 9, 1, 2),
(10, 10, 1, 3),
(11, 11, 1, 4),
(11, 12, 1, 4),
(11, 13, 1, 4),
(11, 14, 1, 4);

INSERT INTO Infectado(IdNPC, comportamentoInfec, velocidade, danoInfectado) VALUES
(14, 'Corredor', 2, 7),
(15, 'Estalador', 6, 13),
(16, 'Baiacu', 8, 23),
(17, 'Espreitador', 6, 12);

INSERT INTO FaccaoHumana(IdNPC, nomeFaccao) VALUES
(18,'Vagalumes'),
(19, 'Serafitas');

INSERT INTO Animal(IdNPC, nomeAnimal, ameaca, danoAnimal) VALUES
(20, 'Lobo Selvagem', 'Alta', 7),
(21, 'Urso Pardo', 'Alta', 10),
(22, 'Peixes', 'Alta', 1),
(23, 'Insetos', 'Baixa', 2);

INSERT INTO Participacao(IdNPC, Evento, Missao) VALUES
(2, 1, 2),
(5, 2, 2),
(7, 3, 2);

COMMIT;

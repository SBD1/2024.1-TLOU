BEGIN TRANSACTION;

INSERT INTO Regiao (idRegiao, descricaoRegiao, nomeRegiao, capacidade, tipoRegiao) VALUES
(1, 'Zona de quarentena fortemente vigiada, com muros altos e guardas armados.', 'Zona de Quarentena de Boston', 20, 2),
(2, 'Área devastada e infestada de infectados.', 'Cidade Abandonada', 15, 4),
(3, 'Território dominado por um grupo de mercenários.', 'Território Mercenário', 10, 3),
(4, 'Esgoto infestado de criaturas perigosas.','Esgoto Abandonado', 15, 4),
(5, 'Jackson: Vilarejo reconstruído, onde os habitantes tentam viver em paz.', 'Vilarejo Pacífico', 35, 3),
(6, 'Hospital Saint Mary', 'Hospital Saint Mary', 15, 1);

INSERT INTO Sala (idSala, IdRegiao) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 2),
(7, 3),
(8, 3),
(9, 3),
(10, 4),
(11, 4),
(12, 4),
(13, 5),
(14, 5),
(15, 5),
(16, 5),
(17, 6),
(18, 6),
(19, 6);

INSERT INTO ZonaQuarentena (IdRegiao, seguranca, populacaoAtual) VALUES 
(1, 5, 10),
(3, 5, 10);

INSERT INTO Acampamento (IdRegiao, defesa) VALUES 
(5, 12),
(6, 14);

INSERT INTO LocalAbandonado (IdRegiao, tipo, periculosidade) VALUES
(2, 'Cidade Abandonada', 8),
(4, 'Esgoto', 5),
(6, 'Hospital', 10);

INSERT INTO Personagem (idPersonagem, tipoPersonagem) VALUES 
(1, 1),
(2, 2),
(3, 2),
(4, 2),
(5, 2),
(6, 2),
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 2),
(13, 2),
(14, 2),
(15, 2),
(16, 2),
(17, 2),
(18, 2),
(19, 2),
(20, 2),
(21, 2),
(22, 2),
(23, 2);



INSERT INTO Inventario (idInventario, capacidade, descricao) VALUES
(1, 30, 'Inventário do Joel.'),
(2, 30, 'Inventário do Ellie.'),
(3, 15, 'Inventário do Tommy.'),
(4, 15, 'Inventário do Tess.'),
(5, 15, 'Inventário do Henry.');

INSERT INTO Missao(idMissao, tipoMis) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 2),
(12, 2),
(13, 2),
(14, 2),
(15, 2),
(16,2);

INSERT INTO Item(idItem, tipoItem) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 3),
(13, 3),
(14, 3),
(15, 3),
(16, 3),
(17, 3),
(18, 3),
(19, 3),
(20, 3),
(21, 3),
(22, 3),
(23, 3),
(24, 3);


INSERT INTO InstItem(idInstItem, IdItem, Sala) VALUES
(1, 18,1),
(2, 18,1),
(3, 18,1),
(4, 18,1),
(5, 18,1),
(6, 12,1),
(7, 12,1),
(8, 17,1),
(9, 17,1);

INSERT INTO Itens (IdMissao, IdItem) VALUES
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6);

INSERT INTO NPC (IdPersonagem, Sala, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, eAliado, tipoNPC) VALUES
(2, 1, 30, 100, 95, 'Ellie', 2, true, 2),
(3, 3, 10,90, 50, 'Sobrevivente Selvagem', NULL, false, 2),
(4, 2, 10, 85, 80, 'Líder de Facção', NULL, false, 2),
(5, 1, 10, 80, 105, 'Tess', 4, true, 2),
(6, 3,10, 120, 115, 'Tommy',3, true, 2),
(7, 1,10, 130, 125, 'Marlene', NULL, false, 2),
(8, 3, 10, 140, 135, 'Henry', 5, true, 2),
(9, 4, 10, 150, 145, 'Sam', NULL, true, 2),
(10, 5, 10, 160, 155, 'Bill', NULL, true, 2),
(11, 6, 10, 170, 165, 'David', NULL, false, 2),
(12, 5, 10, 100, 95, 'Sobrevivente Viajante', NULL, false, 2),
(13, 5, 10, 110, 105, 'Médico da Zona Segura', NULL, false, 2),
(14, 2, 10, 30, 30, 'Corredor', NULL, false, 3),
(15, 2, 10, 45, 45, 'Estalador', NULL, false, 3),
(16, 2, 10, 60, 60, 'Baiacu', NULL, false, 3),
(17, 2, 10, 45, 45, 'Espreitador', NULL, false, 3),
(18, 2, 10, 30, 30, 'Vagalumes', NULL, false, 3),
(19, 2, 10, 30, 30, 'Serafitas', NULL, false, 3),
(20, 2, 10, 30, 30, 'Lobo Selvagem', NULL, false,3),
(21, 2, 10, 30, 30, 'Urso Pardo', NULL, false, 3),
(22, 2, 10, 30, 30, 'Peixes', NULL, false, 3),
(23, 2, 10, 30, 30, 'Insetos', NULL, false, 3);


INSERT INTO Arma(IdItem, nomeItem, dano, municaoAtual, municaoMax, IdInventario, eAtaque, descricaoItem) VALUES
(1, 'Revólver', 40, 6, 6, 1, true, 'Uma arma compacta e confiável, eficaz a curta distância.'),
(2, 'Pistola', 35, 8, 8, 5, true, 'Versátil, com bom equilíbrio entre potência e capacidade de munição.'),
(3, 'Rifle', 60, 4, 4, 3, true, 'Alto impacto para disparos de longa distância.'),
(4, 'Escopeta', 30, 2, 2, 4, true, 'Poder de fogo considerável a curta distância.'),
(5, 'Arco', 35, 10, 10, 2, true, 'Silencioso e eficaz para ataques de longo alcance.'),
(6, 'Faca', 20, NULL, 10, 1, true, 'Afiada e versátil para combate corpo a corpo.');

INSERT INTO Vestimenta(IdItem, nomeItem, descricaoItem, IdInventario, eAtaque) VALUES
(7, 'Jaqueta de Couro', 'Jaqueta resistente a cortes e arranhões.', 1, false),
(8, 'Colete Tático', 'Colete à prova de balas para proteção extra.', 2, false),
(9, 'Calça de Carga', 'Calça com bolsos para carregar suprimentos.', 3, false),
(10, 'Camisa de Combate', 'Camisa resistente para proteção do torso.', 4, false),
(11, 'Escudo de Madeira', 'Escudo improvisado para defesa contra ataques.', 5, false);

INSERT INTO Consumivel(IdItem, nomeItem, tipoConsumivel, aumentoVida, IdInventario, eAtaque, descricaoItem) VALUES
(12, 'Barra de Cereal', 'Energético', 10, 1, false, 'Fornece um aumento leve de energia e vitalidade.'),
(13, 'Pacote de Biscoitos', 'Carboidrato', 1, 1, false, 'Aumenta a energia com um bom nível de carboidratos.'),
(14, 'Garrafa de Água', 'Hidratante', 25, 2, false, 'Restaura a hidratação e aumenta a resistência.'),
(15, 'Pacote de Salgadinhos', 'Salgado', 1, 1, false, 'Aumenta a vitalidade com um toque salgado.'),
(16, 'Vitaminas de evolução', 'Vitaminas, enzimas', 55, 2, false, 'Potente suplemento de vitaminas e enzimas para grandes melhorias.'),
(17, 'Kit de Primeiros Socorros', 'Cura', 20, 1, false, 'Kit essencial para tratar ferimentos e restaurar saúde.'),
(18, 'Munição', 'Projétil', NULL, 1, true, 'Munição para uso em armas de fogo.'),
(19, 'Álcool', 'Reagente', NULL, 2, false, 'Reagente útil para criação e improvisação.'),
(20, 'Trapos', 'Material', NULL, 1, false, 'Material básico para reparos e construção.'),
(21, 'Recipiente', 'Contêiner', NULL, 2, false, 'Contêiner versátil para armazenar itens e líquidos.'),
(22, 'Explosivo', 'Reagente', NULL, 1, true, 'Reagente perigoso para criar explosivos e destruição.'),
(23, 'Fita', 'Material', NULL, 2, false, 'Material adesivo útil para reparos rápidos.'),
(24, 'Lâmina', 'Material', NULL, 1, true, 'Lâmina cortante para combate ou uso em ferramentas.');

INSERT INTO Receita(idReceita, nomeReceita, descricaoReceita, tempoCraft, IdItem) VALUES
(1, 'Kit de Primeiros Socorros', 'Kit básico para curativos e tratamento de ferimentos.', 1, 3),
(2, 'Bomba de Fumaça', 'Bomba que cria uma cortina de fumaça para cobertura.', 4, 3),
(3, 'Mina de Proximidade', 'Granada explosiva que causa dano em área.', 5, 3),
(4, 'Coquetel Molotov', 'Garrafa incendiária utilizada para causar danos de fogo em área.', 7, 3),
(5, 'Faca', 'Ferramenta improvisada que pode ser usada para ataques furtivos e abrir portas trancadas.', 2, 3),
(6, 'Bomba de Pregos', 'Explosivo improvisado que detona ao contato, causando dano em área com fragmentos de pregos.', 5, 3),
(7, 'Bomba Incendiária', 'Dispositivo explosivo que causa uma explosão de fogo ao ser lançado.', 4, 3),
(8, 'Flechas', 'Munição para arco, pode ser craftada utilizando materiais encontrados.', 2, 3);

INSERT INTO Ingrediente(idIngrediente, IdReceita, IdItem, quantidadeIngre) VALUES
(1, 1, 3, 1),
(2, 1, 3, 1),
(3, 2, 3, 1),
(4, 2, 3, 1),
(5, 3, 3, 1),
(6, 3, 3, 1),
(7, 4, 3, 1),
(8, 4, 3, 1),
(9, 5, 3, 1),
(10, 5, 3, 1),
(11, 6, 3, 1),
(12, 6, 3, 1),
(13, 7, 3, 1),
(14, 7, 3, 1),
(15, 8, 3, 1),
(16, 8, 3, 1);

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

INSERT INTO MissaoPatrulha (IdMissao, idMissaoPre, objetivo, nomeMis, qtdNPCs, IdPersonagem, xpMis, statusMissao, Sala) VALUES
(2, 1, 'Patrulhar a àrea devastada em busca de ameaças.', 'Segurança', 5, 1, 150, false, 4),
(6, 5, 'Neutralizar os infectados próximos ao esgoto.', 'Segurança do Acampamento', 8, 1, 250, false, 12),
(8, 7, 'Resgatar Ellie de David.', 'Operação de Reconhecimento', 9, 1, 400, false, 14),
(10, 9, 'Mate todos os vagalumes do Hospital Saint Mary.', 'Defesa do Assentamento', 8, 1, 450, false, 18),
(11, 10, 'Limpe o caminho para chegar até Jackson.', 'Proteção das Fronteiras', 5, 1, 350, false, 15);

INSERT INTO MissaoExploracaoObterItem (IdMissao, idMissaoPre, objetivo, nomeMis, IdPersonagem, xpMis, statusMissao, Sala) VALUES
(1, NULL, 'Com o pedido de Marlene, leve uma jovem chamada Ellie para fora da cidade', 'Ellie', 1, 15, false, 3),
(3, 2, 'Após a morte de Tess, Joel e Ellie partem em uma missão atrás de Bill, um antigo amigo de Joel', 'Os Arredores', 1, 25, false, 6),
(4, 3, 'Joel e Ellie chegam à cidade de Bill. Esta missão inclui a busca por suprimentos e a montagem de veículo', 'Cidade de Bill', 1, 35, false, 8),
(5, 4, 'Joel e Ellie encontram Henry e Sam em Pittsburgh, dois irmãos sobreviventes. Juntos, eles enfrentam hordas de infectados e tentam encontrar um caminho seguro', 'Henry e Sam', 1, 55, false, 11),
(7, 6, 'Joel e Ellie finalmentre chegam ao local onde Tommy está vivendo em uma comunidade segura. Joel considera deixar Ellie com Tommy', 'Represa', 1, 60, false, 13),
(9, 8, 'Joel e Ellie chegam ao hospital. Joel descobre que Ellie precisa ser sacrificada e a salva', 'Laboratório dos Vagalumes', 1, 30, false, 17),
(12, 11, 'Joel e Ellie voltam a Jackson. Ellie confronta Joel', 'Final', 1, 30, false, 16);

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


INSERT INTO InstNPC(IdInstNPC, tipoNPC) VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(7, 8),
(8, 9),
(9, 10),
(10, 11),
(11, 12);

INSERT INTO Infectado(IdNPC, comportamentoInfec, velocidade) VALUES
(14, 'Corredor', 2),
(15, 'Estalador', 6),
(16, 'Baiacu', 8),
(17, 'Espreitador', 6);

INSERT INTO FaccaoHumana(IdNPC, nomeFaccao) VALUES
(18,'Vagalumes'),
(19, 'Serafitas');

INSERT INTO Animal(IdNPC, nomeAnimal, ameaca) VALUES
(20, 'Lobo Selvagem', 'Alta'),
(21, 'Urso Pardo', 'Alta'),
(22, 'Peixes', 'Alta'),
(23, 'Insetos', 'Baixa');

INSERT INTO Participacao(IdNPC, Evento, Missao) VALUES
(2, 1, 2),
(5, 2, 2),
(7, 3, 2);

COMMIT;
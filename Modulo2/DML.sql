BEGIN TRANSACTION;

INSERT INTO Regiao (idRegiao, descricaoRegiao, nomeRegiao, capacidade, tipoRegiao) VALUES
(1, 'Zona de quarentena fortemente vigiada, com muros altos e guardas armados.', 'Zona de Quarentena de Boston', 20, 2),
(2, 'Área devastada e infestada de infectados.', 'Cidade Abandonada', 15, 4),
(3, 'Território dominado por um grupo de mercenários.', 'Território Mercenário', 10, 3),
(4, 'Esgoto infestado de criaturas perigosas.','Esgoto Abandonado', 15, 4),
(5, 'Vila liderada por David, situada no inverno', 'Silver Lake', 10, 3),
(6, 'Jackson: Vilarejo reconstruído, onde os habitantes tentam viver em paz.', 'Vilarejo Pacífico', 35, 3),
(7, 'Hospital Saint Mary', 'Hospital Saint Mary', 15, 1);

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
(16, 6),
(17, 6),
(18, 6),
(19, 7),
(20, 7),
(21, 7);

INSERT INTO ZonaQuarentena (IdRegiao, seguranca, populacaoAtual) VALUES 
(1, 5, 10),
(3, 5, 10);

INSERT INTO Acampamento (IdRegiao, defesa) VALUES 
(5, 12),
(6, 14);

INSERT INTO LocalAbandonado (IdRegiao, tipo, periculosidade) VALUES
(2, 'Cidade Abandonada', 8),
(4, 'Esgoto', 5),
(7, 'Hospital', 10);

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


INSERT INTO InstItem(idInstItem, IdItem) VALUES
(1, 3),
(2, 3),
(3, 3),
(4, 1),
(5, 3),
(6, 3),
(7, 3),
(8, 3),
(9, 3),
(10, 3),
(11, 3),
(12, 3),
(13, 3),
(14, 3),
(15, 3),
(16, 1),
(17, 1),
(18, 1),
(19, 1),
(20, 1),
(21, 2),
(22, 2),
(23, 2),
(24, 2),
(25, 2);

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


INSERT INTO Arma(IdItem, nomeItem, dano, municaoAtual, municaoMax, IdInventario, eAtaque, descricaoItem, Sala) VALUES
(1, 'Revólver', 40, 6, 6, 1, true, 'Uma arma compacta e confiável, eficaz a curta distância.', 1),
(2, 'Pistola', 35, 8, 8, 5, true, 'Versátil, com bom equilíbrio entre potência e capacidade de munição.', 1),
(3, 'Rifle', 60, 4, 4, 3, true, 'Alto impacto para disparos de longa distância.', 1),
(4, 'Escopeta', 30, 2, 2, 4, true, 'Poder de fogo considerável a curta distância.', 1),
(5, 'Arco', 35, 10, 10, 2, true, 'Silencioso e eficaz para ataques de longo alcance.', 1),
(6, 'Faca', 20, NULL, 10, 1, true, 'Afiada e versátil para combate corpo a corpo.', 1);

INSERT INTO Vestimenta(IdItem, nomeItem, descricaoItem, IdInventario, eAtaque, Sala) VALUES
(7, 'Jaqueta de Couro', 'Jaqueta resistente a cortes e arranhões.', 1, false, 1),
(8, 'Colete Tático', 'Colete à prova de balas para proteção extra.', 2, false, 1),
(9, 'Calça de Carga', 'Calça com bolsos para carregar suprimentos.', 3, false, 1),
(10, 'Camisa de Combate', 'Camisa resistente para proteção do torso.', 4, false, 1),
(11, 'Escudo de Madeira', 'Escudo improvisado para defesa contra ataques.', 5, false, 1);

INSERT INTO Consumivel(IdItem, nomeItem, tipoConsumivel, aumentoVida, IdInventario, eAtaque, descricaoItem, Sala) VALUES
(12, 'Barra de Cereal', 'Energético', 10, 1, false, 'Fornece um aumento leve de energia e vitalidade.', 1),
(13, 'Pacote de Biscoitos', 'Carboidrato', 1, 1, false, 'Aumenta a energia com um bom nível de carboidratos.', 1),
(14, 'Garrafa de Água', 'Hidratante', 25, 2, false, 'Restaura a hidratação e aumenta a resistência.', 1),
(15, 'Pacote de Salgadinhos', 'Salgado', 1, 1, false, 'Aumenta a vitalidade com um toque salgado.', 1),
(16, 'Vitaminas de evolução', 'Vitaminas, enzimas', 55, 2, false, 'Potente suplemento de vitaminas e enzimas para grandes melhorias.', 1),
(17, 'Kit de Primeiros Socorros', 'Cura', 20, 1, false, 'Kit essencial para tratar ferimentos e restaurar saúde.', 1),
(18, 'Munição', 'Projétil', NULL, 1, true, 'Munição para uso em armas de fogo.', 1),
(19, 'Álcool', 'Reagente', NULL, 2, false, 'Reagente útil para criação e improvisação.', 1),
(20, 'Trapos', 'Material', NULL, 1, false, 'Material básico para reparos e construção.', 1),
(21, 'Recipiente', 'Contêiner', NULL, 2, false, 'Contêiner versátil para armazenar itens e líquidos.', 1),
(22, 'Explosivo', 'Reagente', NULL, 1, true, 'Reagente perigoso para criar explosivos e destruição.', 1),
(23, 'Fita', 'Material', NULL, 2, false, 'Material adesivo útil para reparos rápidos.', 1),
(24, 'Lâmina', 'Material', NULL, 1, true, 'Lâmina cortante para combate ou uso em ferramentas.', 1);

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
(1, 'Primeiros Sinais de Perigo', 'Os primeiros infectados começam a aparecer na cidade, causando pânico entre os moradores.', 1, 1),
(2, 'Contrabandista Localizado', 'O contrabandista Mark foi encontrado nas docas, mas não está sozinho. Você precisará neutralizar sua guarda.', 1, 1),
(3, 'A Fuga de Ellie', 'Marlene pediu para Ellie ser levada para fora da cidade. Você precisará enfrentar facções e infectados pelo caminho.', 1, 1),
(4, 'Encontro com Bill', 'Durante a busca por suprimentos, você encontra Bill, que ajuda a montar um veículo para continuar a viagem.', 1, 1),
(5, 'Cidade de Bill Inundada', 'Chuvas torrenciais inundam parte da cidade de Bill, dificultando a busca por suprimentos.', 1, 1),
(6, 'Emboscada dos Caçadores', 'Caçadores emboscaram Joel e Ellie. Eles precisam encontrar um caminho para sair da cidade.', 1, 1),
(7, 'Henry e Sam Resgatados', 'Joel e Ellie resgatam Henry e Sam em meio a um ataque de infectados.', 1, 1),
(8, 'Comunidade Segura', 'Joel e Ellie finalmente chegam à comunidade de Tommy, onde Joel considera deixar Ellie.', 1, 1),
(9, 'Captura de Ellie', 'Ellie é capturada por David enquanto cuida de Joel em recuperação.', 1, 1),
(10, 'Fuga do Hospital', 'Joel descobre que Ellie será sacrificada no hospital e decide resgatá-la, enfrentando os Vagalumes.', 1, 1);

INSERT INTO Itinerario(idItinerario, horario, dia, idEvento) VALUES
(1, 22, '2024-08-14', 1),
(2, 10, '2004-06-19', 2),
(3, 15, '2024-01-23', 3),
(4, 18, '2004-12-13', 4),
(5, 12, '2024-01-23', 5),
(6, 08, '2024-01-23', 6),
(7, 20, '2024-01-23', 7),
(8, 14, '2024-08-14', 8),
(9, 16, '2024-01-23', 9),
(10, 19, '2024-01-23', 10);

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
(8, 7, 'Patrulhar a zona de quarentena em busca de ameaças.', 'Ronda Diária', 5, 1, 150, false, 1),
(9, 8, 'Neutralizar os infectados próximos ao acampamento.', 'Segurança do Acampamento', 8, 1, 250, false, 2),
(10, 9, 'Realizar uma operação de reconhecimento em território inimigo.', 'Operação de Reconhecimento', 9, 1, 400, false, 3),
(11, 10, 'Proteger o assentamento contra ataques de facções rivais.', 'Defesa do Assentamento', 8, 1, 450, false, 3),
(12, 11, 'Patrulhar as fronteiras da cidade fortificada.', 'Proteção das Fronteiras', 5, 1, 350, false, 2);

INSERT INTO MissaoExploracaoObterItem (IdMissao, idMissaoPre, objetivo, nomeMis, IdPersonagem, xpMis, statusMissao, Sala) VALUES
(1, NULL, 'Com o pedido de Marlene, leve uma jovem chamada Ellie para fora da cidade', 'Ellie', 1, 15, false, 1),
(2, 1, 'Após a morte de Tess, Joel e Ellie partem em uma missão atrás de Bill, um antigo amigo de Joel', 'Os Arredores', 1, 250, false, 2),
(3, 2, 'Joel e Ellie chegam à cidade de Bill. Esta missão inclui a busca por suprimentos e a montagem de veículo', 'Cidade de Bill', 1, 350, false, 3),
(4, 3, 'Joel e Ellie encontram Henry e Sam em Pittsburgh, dois irmãos sobreviventes. Juntos, eles enfrentam hordas de infectados e tentam encontrar um caminho seguro', 'Henry e Sam', 1, 550, false, 3),
(5, 4, 'Joel e Ellie finalmentre chegam ao local onde Tommy está vivendo em uma comunidade segura. Joel considera deixar Ellie com Tommy', 'Represa', 1, 600, false, 2),
(6, 5, 'Joel e Ellie chegam ao hospital. Joel descobre que Ellie precisa ser sacrificada e a salva', 'Laboratório dos Vagalumes', 1, 300, false, 1),
(7, 6, 'Joel e Ellie voltam a Jackson. Ellie confronta Joel', 'Final', 1, 300, false, 1);

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

INSERT INTO Dialoga(idDialogo, IdFalante, IdOuvinte, conteudo, duracaoDialogo) VALUES
(1, 1, 1, 'Joel: Tess, qual é a missão de hoje?', 5),
(2, 1, 1, 'Tess: Joel, precisamos resolver a questão com o Mark, ele está causando problemas de novo.', 10),
(3, 1, 2, 'Joel: Não temos tempo a perder. Vamos.', 5),
(4, 1, 2, 'Marlene: Esqueçam o Mark, tenho um trabalho maior. Levem essa garota até o Capitólio, e 100 tickets de comida serão de vocês.', 10),
(5, 1, 2, 'Joel: Como você chegou aqui, garota?', 5),
(6, 2, 1, 'Ellie: Eu não sei! Só estou tentando sobreviver... Será que vamos conseguir?', 8);


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
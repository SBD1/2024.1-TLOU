BEGIN TRANSACTION;

INSERT INTO Regiao (idRegiao, descricaoRegiao, nomeRegiao, capacidade, tipoRegiao) VALUES
(1, 'Zona de quarentena fortemente vigiada, com muros altos e guardas armados.', 'Zona de Quarentena de Boston', 20, 2),
(2, 'Área devastada e infestada de infectados.', 'Cidade Abandonada', 15, 4),
(3, 'Ruínas de uma cidade antiga, agora dominada pela natureza.', 'Ruínas Antigas',  20, 4),
(4, 'Posto avançado de uma facção que controla a região.', 'Posto Avançado', 20, 1),
(5, 'Jackson: Vilarejo reconstruído, onde os habitantes tentam viver em paz.', 'Vilarejo Pacífico', 35, 3),
(6, 'Território dominado por um grupo de mercenários.', 'Território Mercenário', 10, 3),
(7, 'Esgoto infestado de criaturas perigosas.','Esgoto Abandonado', 15, 4),
(8, 'Hospital Saint Mary', 'Hospital Saint Mary', 15, 1);

INSERT INTO Sala (idSala, IdRegiao) VALUES
(1, 2);

INSERT INTO ZonaQuarentena (IdRegiao, idZona, seguranca, populacaoAtual)
VALUES 
(1, 1, 12, 10),
(1, 2, 14, 15),
(1, 3, 10, 20);

INSERT INTO Acampamento (IdRegiao, idAcampamento, defesa)
VALUES 
(5, 3, 12),
(6, 4, 12),
(8, 5, 14);

INSERT INTO LocalAbandonado (IdRegiao, idLocal, tipo, periculosidade) VALUES
(2, 6, 'Fábrica', 8),
(2, 7, 'Hospital', 10),
(3, 8, 'Escola', 5),
(3, 9, 'Loja de conveniência', 3);


INSERT INTO Personagem (idPersonagem, tipoPersonagem)
VALUES 
(1, 1),
(2, 1),
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
(13, 2);

INSERT INTO Inventario (idInventario, capacidade, descricao) VALUES
(1, 20, 'Mochila básica com espaço limitado.'),
(2, 25, 'Bolsa média, adequada para carregar suprimentos.');

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
(2, 2),
(3, 3);

INSERT INTO InstItem(idInstItem, IdItem, nomeInstItem) VALUES
(1, 1, 'Alcool'),
(2, 2, 'Trapos'),
(3, 3, 'Bomba');

INSERT INTO Itens (IdMissao, idItem) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO NPC (IdPersonagem, idNPC, Sala, xp, vidaMax, vidaAtual, nomePersonagem, IdInventario, tipoNPC) VALUES
(3, 1, 1,10,90, 50, 'Sobrevivente Selvagem', 1, 2),
(4, 2, 1,10, 85, 80, 'Líder de Facção', 1, 2),
(5, 3,1,10, 80, 105, 'Tess', 1, 2),
(6, 4, 1,10, 120, 115, 'Tommy',1, 2),
(7, 5, 1,10, 130, 125, 'Marlene', 1, 2),
(8, 6, 1,10, 140, 135, 'Henry', 1, 2),
(9, 7, 1, 10,150, 145, 'Sam', 1, 2),
(10, 8, 1,10, 160, 155, 'Bill', 1, 2),
(11, 9, 1,10, 170, 165, 'David', 1, 2),
(12, 10, 1, 10,100, 95, 'Sobrevivente Viajante', 1, 2),
(13, 11, 1, 10, 110, 105, 'Médica da Zona Segura', 1, 2);

INSERT INTO Arma(idArma, IdItem, nomeArma, dano, municaoAtual, municaoMax, IdInventario, eAtaque, descricaoItem) VALUES
(1, 1, 'Revólver', 40, 6, 6, 1, true, 'Uma arma compacta e confiável, eficaz a curta distância.'),
(2, 1, 'Pistola', 35, 8, 8, 2, true, 'Versátil, com bom equilíbrio entre potência e capacidade de munição.'),
(3, 1, 'Rifle', 60, 4, 4, 1, true, 'Alto impacto para disparos de longa distância.'),
(4, 1, 'Escopeta', 30, 2, 2, 2, true, 'Poder de fogo considerável a curta distância.'),
(5, 1, 'Arco', 35, 10, 10, 1, true, 'Silencioso e eficaz para ataques de longo alcance.'),
(6, 1, 'Faca', 20, NULL, 10, 2, true, 'Afiada e versátil para combate corpo a corpo.'),
(7, 1, 'Machado', 45, NULL, 10, 1, true, 'Uma arma pesada para combate intenso e destruição.'),
(8, 1, 'Machete', 40, NULL, 10, 2, true, 'Lâmina larga ideal para cortar e combate corpo a corpo.'),
(9, 1, 'Lança', 30, NULL, 1, 2, true, 'Arma de longo alcance, eficaz em ataques de distância média.');

INSERT INTO Vestimenta(idVestimenta, IdItem, nomeVestimenta, descricaoItem, IdInventario, eAtaque) VALUES
(1, 2, 'Jaqueta de Couro', 'Jaqueta resistente a cortes e arranhões.', 1, false),
(2, 2, 'Colete Tático', 'Colete à prova de balas para proteção extra.', 2, false),
(3, 2, 'Calça de Carga', 'Calça com bolsos para carregar suprimentos.', 1, false),
(4, 2, 'Camisa de Combate', 'Camisa resistente para proteção do torso.', 2, false),
(5, 2, 'Cinto de Utilidades', 'Cinto com compartimentos para itens essenciais.', 2, false),
(6, 2, 'Escudo de Madeira', 'Escudo improvisado para defesa contra ataques.', 1, false);

INSERT INTO Consumivel(idConsumivel, IdItem, nomeConsumivel, tipoConsumivel, aumentoVida, IdInventario, eAtaque, descricaoItem) VALUES
(1, 3, 'Barra de Cereal', 'Energético', 10, 1, false, 'Fornece um aumento leve de energia e vitalidade.'),
(2, 3, 'Lata de Sardinha', 'Proteína', 15, 2, false, 'Fonte de proteína que ajuda a restaurar energia.'),
(3, 3, 'Pacote de Biscoitos', 'Carboidrato', 1, 1, false, 'Aumenta a energia com um bom nível de carboidratos.'),
(4, 3, 'Garrafa de Água', 'Hidratante', 25, 2, false, 'Restaura a hidratação e aumenta a resistência.'),
(5, 3, 'Pacote de Salgadinhos', 'Salgado', 1, 1, false, 'Aumenta a vitalidade com um toque salgado.'),
(6, 3, 'Frutas Secas', 'Vitaminas', 35, 2, false, 'Restaura energia com um mix nutritivo de vitaminas.'),
(7, 3, 'Barras de Proteína', 'Proteína', 21, 1, false, 'Alta fonte de proteína para recuperação rápida.'),
(8, 3, 'Pacote de Macarrão', 'Carboidrato', 20, 2, false, 'Restaura grande quantidade de energia com carboidratos.'),
(9, 3, 'Lata de Feijão', 'Proteína', 50, 1, false, 'Fornece uma alta quantidade de proteína para recuperação.'),
(10, 3, 'Vitaminas de evolução', 'Vitaminas, enzimas', 55, 2, false, 'Potente suplemento de vitaminas e enzimas para grandes melhorias.'),
(11, 3, 'Kit de Primeiros Socorros', 'Cura', 20, 1, false, 'Kit essencial para tratar ferimentos e restaurar saúde.'),
(12, 3, 'Munição', 'Projétil', NULL, 1, true, 'Munição para uso em armas de fogo.'),
(13, 3, 'Álcool', 'Reagente', NULL, 2, false, 'Reagente útil para criação e improvisação.'),
(14, 3, 'Trapos', 'Material', NULL, 1, false, 'Material básico para reparos e construção.'),
(15, 3, 'Recipiente', 'Contêiner', NULL, 2, false, 'Contêiner versátil para armazenar itens e líquidos.'),
(16, 3, 'Explosivo', 'Reagente', NULL, 1, true, 'Reagente perigoso para criar explosivos e destruição.'),
(17, 3, 'Fita', 'Material', NULL, 2, false, 'Material adesivo útil para reparos rápidos.'),
(18, 3, 'Lâmina', 'Material', NULL, 1, true, 'Lâmina cortante para combate ou uso em ferramentas.');

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

INSERT INTO PC (IdPersonagem, idPC, Sala, xp, vidaMax, vidaAtual, nomePersonagem, estado, Evolucao, IdInventario) VALUES
(1, 1, 1, 70, 100, 100, 'Joel', 'saudável', 5, 1),
(2, 2, 1, 30, 100, 95, 'Ellie', 'saudável', 2, 2);

INSERT INTO Evento (idEvento, nomeEvento, descricao, Sala, IdPC) VALUES
(1, 'Primeiros Sinais de Perigo', 'Os primeiros infectados começam a aparecer na cidade, causando pânico entre os moradores.', 1, 1),
(2, 'Contrabandista Localizado', 'O contrabandista Mark foi encontrado nas docas, mas não está sozinho. Você precisará neutralizar sua guarda.', 1, 1),
(3, 'A Fuga de Ellie', 'Marlene pediu para Ellie ser levada para fora da cidade. Você precisará enfrentar facções e infectados pelo caminho.', 1, 1),
(4, 'Encontro com Bill', 'Durante a busca por suprimentos, você encontra Bill, que ajuda a montar um veículo para continuar a viagem.', 1, 1),
(5, 'Cidade de Bill Inundada', 'Chuvas torrenciais inundam parte da cidade de Bill, dificultando a busca por suprimentos.', 1, 1),
(6, 'Emboscada dos Caçadores', 'Caçadores emboscaram Joel e Ellie. Eles precisam encontrar um caminho para sair da cidade.', 1, 1),
(7, 'Henry e Sam Resgatados', 'Joel e Ellie resgatam Henry e Sam em meio a um ataque de infectados.', 1, 1),
(8, 'Comunidade Segura', 'Joel e Ellie finalmente chegam à comunidade de Tommy, onde Joel considera deixar Ellie.', 1, 1),
(9, 'Captura de Ellie', 'Ellie é capturada por David enquanto cuida de Joel em recuperação.', 1, 2),
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

INSERT INTO Habilidade(idHabilidade, nomeHabilidade, tipoHabilidade, efeito, duracaoHabilidade, idPC) VALUES
(1, 'Furtividade', 'Passiva', 'Aumenta a chance de passar despercebido pelos inimigos.', 10, 1),
(2, 'Recuperação Rápida', 'Ativa', 'Recupera uma quantidade moderada de vida durante o combate.', 5, 1),
(3, 'Ataque Furtivo', 'Ativa', 'Causa dano extra em ataques surpresa.', 6, 1),
(4, 'Resistência a Infecção', 'Passiva', 'Diminui a chance de ser infectado por mordidas de infectados.',5, 2),
(5, 'Recarga Rápida', 'Ativa', 'Recarrega a arma mais rapidamente durante o combate.', 10, 1),
(6, 'Ataque Preciso', 'Ativa', 'Aumenta a precisão dos tiros por um curto período.', 10, 1),
(7, 'Esquiva Rápida', 'Ativa', 'Permite esquivar de ataques inimigos com maior facilidade.',  5, 1),
(8, 'Ataque em Grupo', 'Ativa', 'Aumenta o dano causado em ataques conjuntos com aliados.',5, 1),
(9, 'Defesa Reforçada', 'Passiva', 'Diminui o dano recebido em combate.', 5, 1),
(10, 'Ataque Certeiro', 'Ativa', 'Aumenta a chance de acerto crítico em ataques.', 5, 1);

INSERT INTO MissaoPatrulha (IdMissao, idMissaoPre, objetivo, nomeMis, qtdNPCs, IdPC, xpMis, idPatrulha) VALUES
(12, 11, 'Patrulhar a zona de quarentena em busca de ameaças.', 'Ronda Diária', 5, 1, 150, 1),
(13, 12, 'Neutralizar os infectados próximos ao acampamento.', 'Segurança do Acampamento', 8, 1, 250, 2),
(14, 13, 'Realizar uma operação de reconhecimento em território inimigo.', 'Operação de Reconhecimento', 9, 2, 400, 3),
(15, 14, 'Proteger o assentamento contra ataques de facções rivais.', 'Defesa do Assentamento', 8, 2, 450, 4),
(16, 15, 'Patrulhar as fronteiras da cidade fortificada.', 'Proteção das Fronteiras', 5, 2, 350, 5);

INSERT INTO MissaoExploracaoObterItem (IdMissao, idMissaoPre, objetivo, nomeMis, idExploracao, IdPC, xpMis) VALUES
(1, NULL, 'Sobreviva ao surto do fungo Cordyceps', 'Surto', 1, 1, 200),
(2, 1, 'Vá atrás do contrabandista Mark', 'Docas', 2, 1, 300),
(3, 2, 'Com o pedido de Marlene, leve uma jovem chamada Ellie para fora da cidade', 'Ellie', 3, 1, 500),
(4, 3, 'Após a morte de Tess, Joel e Ellie partem em uma missão atrás de Bill, um antigo amigo de Joel', 'Os Arredores', 4, 1, 250),
(5, 4, 'Joel e Ellie chegam à cidade de Bill. Esta missão inclui a busca por suprimentos e a montagem de veículo', 'Cidade de Bill',5, 1, 350),
(6, 5, 'Joel e Ellie chegam a Pittsburgh, onde são emboscados por caçadores. Eles precisam lutar pela sobrevivência e encontrar um caminho para sair da cidade', 'Pittsburgh', 6, 1, 450),
(7, 6, 'Joel e Ellie encontram Henry e Sam, dois irmãos sobreviventes. Juntos, eles enfrentam hordas de infectados e tentam encontrar um caminho seguro', 'Henry e Sam', 7, 1, 550),
(8, 7, 'Joel e Ellie finalmentre chegam ao local onde Tommy está vivendo em uma comunidade segura. Joel considera deixar Ellie com Tommy', 'Represa', 8, 1, 600),
(9, 8, 'Ellie cuida de Joel enquanto ele se recupera, mas é capturada por David', 'Resort Saltlake', 9, 2, 300),
(10, 9, 'Joel e Ellie chegam ao hospital. Joel descobre que Ellie precisa ser sacrificada e a salva', 'Laboratório dos Vagalumes',10, 1, 300),
(11, NULL, 'Joel e Ellie voltam a Jackson. Ellie confronta Joel', 'Final', 12, 1, 300);

INSERT INTO Concede(IdEvolucao, IdConsumivel) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10); 

INSERT INTO Dialoga(idDialogo, IdFalante, IdOuvinte, conteudo, duracaoDialogo) VALUES
(1, 1, 2, 'Joel: O que você está fazendo aqui?', 1),
(2, 1, 2, 'Guardião da Zona: Estou patrulhando a área. E você?', 2),
(3, 1, 2, 'Sobrevivente Selvagem: Estou procurando suprimentos. Você viu algo?', 3),
(4, 2, 1, 'Mercador: Tenho itens raros para venda. Interessado?', 4),
(5, 2, 1, 'Informante: Ouvi rumores sobre uma base secreta. Vamos investigar.', 5),
(6, 2, 1, 'Líder de Facção: Nossa facção precisa de aliados. O que você acha?', 6),
(7, 2, 1, 'Sobrevivente Isolado: Estou sozinho há muito tempo. Preciso de ajuda.', 7),
(8, 2, 1, 'Guarda Costas: Vamos manter a segurança da região juntos.', 8),
(9, 1, 2, 'Engenheiro: Preciso de materiais para consertar o gerador. Pode ajudar?', 9),
(10, 2, 1, 'Curandeiro: Vamos tratar dos feridos e doentes. Eles precisam de nós.', 10),
(11, 1, 2, 'Estranho Misterioso: Tenho informações valiosas sobre o passado. Quer saber?', 11);

INSERT INTO InstNPC(IdInstNPC, tipoNPC) VALUES
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
(11, 2);

INSERT INTO Infectado(IdNPC, idInfectado, comportamentoInfec, velocidade) VALUES
(2, 1, 'Corredor', 2),
(2, 2, 'Estalador', 6),
(2, 3, 'Baiacu', 8),
(2, 4, 'Corredor', 2),
(1, 5, 'Estalador', 6),
(1, 6, 'Baiacu', 8),
(1, 7, 'Corredor', 2);

INSERT INTO FaccaoHumana(IdNPC, idFaccao, nomeFaccao) VALUES
(1, 1, 'Vagalumes'),
(1, 2, 'Serafitas');

INSERT INTO Animal(IdNPC, idAnimal, nomeAnimal, ameaca) VALUES
(1, 1, 'Lobo Selvagem', 'Alta'),
(1, 2, 'Urso Pardo', 'Alta'),
(1, 3, 'Peixes', 'Alta'),
(1, 4, 'Insetos', 'Baixa');

INSERT INTO Participacao(idNPC, Evento, Missao) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(2, 4, 4),
(2, 5, 5),
(2, 6, 6),
(2, 7, 7),
(1, 8, 8),
(1, 9, 9),
(2, 10, 10);

COMMIT;
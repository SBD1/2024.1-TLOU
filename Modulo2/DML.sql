BEGIN TRANSACTION;

INSERT INTO Mundo (idMundo, descricaoMundo, nomeMundo) VALUES
(1, 'Um mundo pós-apocalíptico devastado por uma infecção fúngica que transforma humanos em monstros.', 'The Last of Us');

INSERT INTO Regiao (idRegiao, descricaoRegiao, coordenadaX, coordenadaY, nomeRegiao, capacidade, IdMundo, tipoRegiao) VALUES
(1, 'Zona de quarentena fortemente vigiada, com muros altos e guardas armados.', 200, 150, 'Zona de Quarentena de Boston', 500, 1, 2),
(2, 'Área devastada e infestada de infectados.', 1500, 2500, 'Cidade Abandonada', NULL, 1, 4),
(3, 'Ruínas de uma cidade antiga, agora dominada pela natureza.', 1200, 3000, 'Ruínas Antigas', NULL, 1, 4),
(4, 'Posto avançado de uma facção que controla a região.', 2400, 1100, 'Posto Avançado', 150, 1, 1),
(5, 'Jackson: Vilarejo reconstruído, onde os habitantes tentam viver em paz.', 1800, 2900, 'Vilarejo Pacífico', 400, 1, 3),
(6, 'Território dominado por um grupo de mercenários.', 3000, 400, 'Território Mercenário', NULL, 1, 3),
(7, 'Esgoto infestado de criaturas perigosas.', 900, 1900, 'Esgoto Abandonado', NULL, 1, 4),
(8, 'Vila do inverno', 3200, 4500, 'Vila do inverno', 200, 1, 1);
(9. 'Hospital Saint Mary', 2100, 3800, 'Hospital Saint Mary', 300, 1, 1);

INSERT INTO ZonaQuarentena (IdRegiao, idZona, seguranca, populacaoAtual)
VALUES 
(1, 1, 12, 10),
(1, 2, 14, 15),
(1, 3, 10, 20);

INSERT INTO Acampamento (IdRegiao, idAcampamento, defesa)
VALUES 
(5, 1, 12),
(6, 2, 14);

INSERT INTO LocalAbandonado (IdRegiao, idLocal, tipo, descricao, nivelPerigo) VALUES
(1, 1, 'Fábrica', 'Antiga fábrica de produtos químicos', 5),
(1, 2, 'Hospital', 'Hospital abandonado com suprimentos médicos', 7),
(2, 3, 'Escola', 'Escola desativada utilizada como abrigo temporário', 3),
(3, 4, 'Loja de conveniência', 'Supermercado saqueado', 6);


INSERT INTO Personagem (idPersonagem, tipoPersonagem)
VALUES 
(1, 'PC'),
(2, 'PC'),
(3, 'NPC'),
(4, 'NPC'),
(5, 'NPC'),
(6, 'NPC'),
(7, 'NPC'),
(8, 'NPC'),
(9, 'NPC'),
(10, 'NPC'),
(11, 'NPC'),
(12, 'NPC');



INSERT INTO NPC (IdPersonagem, idNPC, locEmX, locEmY, xp, vidaMax, vidaAtual, nomePersonagem, Loot, eAliado, Mundo, IdInventario) VALUES
(1, 3, 1600, 2600, 30, 90, 50, 'Sobrevivente Selvagem', 'Item_2', false, 1, 1),
(2, 9, 2400, 1100, 35, 85, 80, 'Líder de Facção', 'Item_5', true, 1, 2),
(3, 5, 1200, 3100, 80, 110, 105, 'Tess', 'cansado', 7, 1, 3),
(4, 6, 1800, 2950, 90, 120, 115, 'Tommy', 'alerta', 8, 1, 4),
(5, 7, 3000, 410, 100, 130, 125, 'Marlene', 'enfurecido', 9, 1, 5),
(6, 8, 2100, 3900, 110, 140, 135, 'Henry', 'determinado', 10, 1, 6),
(7, 9, 1500, 2600, 120, 150, 145, 'Sam', 'cauteloso', 11, 1, 7),
(8, 10, 250, 160, 130, 160, 155, 'Bill', 'resoluto', 12, 1, 8),
(9, 11, 900, 2000, 140, 170, 165, 'David', 'calculista', 13, 1, 9),
(10, 12, 3300, 4700, 150, 180, 175, 'Riley', 'inspirado', 14, 1, 10),
(11, 13, 1200, 2800, 60, 100, 95, 'Sobrevivente Viajante', 'Mapa', false, 1, 11),
(12, 16, 1750, 2450, 90, 110, 105, 'Médica da Zona Segura', 'Antibióticos', true, 1, 12);


INSERT INTO PC (IdPersonagem, idPC, locEmX, locEmY, xp, vidaMax, vidaAtual, nomePersonagem, estado, Evolucao, Mundo, IdInventario) VALUES
(1, 1, 210, 160, 70, 100, 100, 'Joel', 'saudável', 5, 1, 1),
(2, 2, 210, 160, 30, 100, 95, 'Ellie', 'saudável', 6, 2, 2);

INSERT INTO Inventario (idInventario, capacidadeInvent, descricao) VALUES
(1, 20, 'Mochila básica com espaço limitado.'),
(2, 25, 'Bolsa média, adequada para carregar suprimentos.');

INSERT INTO Itens (IdMissao, idItem) VALUES
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

INSERT INTO Missao(idMissao,tipoMis) VALUES
(1, 'Exploração'),
(2, 'Exploração'),
(3, 'Exploração'),
(4, 'Exploração'),
(5, 'Exploração'),
(6, 'Patrulha'),
(7, 'Patrulha'),
(8, 'Patrulha'),
(9, 'Patrulha'),
(10, 'Patrulha');


INSERT INTO MissaoExploracaoObterItem (IdMissao, idMissaoPre, objetivo, nomeMis, ItensAdquiridos, idExploracao, IdPC, xpMis) VALUES
(1, NULL, 'Sobreviva ao surto do fungo Cordyceps', 'Surto', NULL, 1, 1, 200),
(2, 1, 'Vá atrás do contrabandista Mark', 'Docas', NULL, 2, 4, 300),
(3, 2, 'Com o pedido de Marlene, leve uma jovem chamada Ellie para fora da cidade', 'Ellie', NULL, 4, 6, 500),
(4, 3, 'Após a morte de Tess, Joel e Ellie partem em uma missão atrás de Bill, um antigo amigo de Joel', 'Os Arredores', NULL, 5, 7, 250),
(5, 4, 'Joel e Ellie chegam à cidade de Bill. Esta missão inclui a busca por suprimentos e a montagem de veículo', 'Cidade de Bill', NULL, 6, 8, 350),
(6, 5, 'Joel e Ellie chegam a Pittsburgh, onde são emboscados por caçadores. Eles precisam lutar pela sobrevivência e encontrar um caminho para sair da cidade', 'Pittsburgh', NULL, 7, 9, 450),
(7, 6, 'Joel e Ellie encontram Henry e Sam, dois irmãos sobreviventes. Juntos, eles enfrentam hordas de infectados e tentam encontrar um caminho seguro', 'Henry e Sam', NULL, 8, 10, 550),
(8, 7, 'Joel e Ellie finalmentre chegam ao local onde Tommy está vivendo em uma comunidade segura. Joel considera deixar Ellie com Tommy', 'Represa', NULL, 9, 11, 600),
(9, 8, 'Ellie cuida de Joel enquanto ele se recupera, mas é capturada por David', 'Resort Saltlake', NULL, 10, 12, 300),
(10, 9, 'Joel e Ellie chegam ao hospital. Joel descobre que Ellie precisa ser sacrificada e a salva', 'Laboratório dos Vagalumes', NULL, 10, 12, 300),
(10, 9, 'Joel e Ellie voltam a Jackson. Ellie confronta Joel', 'Final', NULL, 10, 12, 300);


INSERT INTO MissaoPatrulha (IdMissao, idMissaoPre, objetivo, nomeMis, qtdNPCs, IdPC, xpMis, idPatrulha) VALUES
(11, NULL, 'Patrulhar a zona de quarentena em busca de ameaças.', 'Ronda Diária', 5, 1, 150, 1),
(12, 11, 'Neutralizar os infectados próximos ao acampamento.', 'Segurança do Acampamento', 8, 4, 250, 2),
(13, 12, 'Realizar uma operação de reconhecimento em território inimigo.', 'Operação de Reconhecimento', 9, 8, 400, 6),
(14, 13, 'Proteger o assentamento contra ataques de facções rivais.', 'Defesa do Assentamento', 8, 9, 450, 7),
(15, 14, 'Patrulhar as fronteiras da cidade fortificada.', 'Proteção das Fronteiras', 5, 10, 350, 8);


INSERT INTO Evento (idEvento, nomeEvento, descricao, locEmX, locEmY, IdPC) VALUES
(1, 'Primeiros Sinais de Perigo', 'Os primeiros infectados começam a aparecer na cidade, causando pânico entre os moradores.', 150, 200, 1),
(2, 'Contrabandista Localizado', 'O contrabandista Mark foi encontrado nas docas, mas não está sozinho. Você precisará neutralizar sua guarda.', 500, 300, 1),
(3, 'A Fuga de Ellie', 'Marlene pediu para Ellie ser levada para fora da cidade. Você precisará enfrentar facções e infectados pelo caminho.', 900, 400, 1),
(4, 'Encontro com Bill', 'Durante a busca por suprimentos, você encontra Bill, que ajuda a montar um veículo para continuar a viagem.', 1200, 600, 1),
(5, 'Cidade de Bill Inundada', 'Chuvas torrenciais inundam parte da cidade de Bill, dificultando a busca por suprimentos.', 1300, 800, 1),
(6, 'Emboscada dos Caçadores', 'Caçadores emboscaram Joel e Ellie. Eles precisam encontrar um caminho para sair da cidade.', 1600, 1000, 1),
(7, 'Henry e Sam Resgatados', 'Joel e Ellie resgatam Henry e Sam em meio a um ataque de infectados.', 1800, 1200, 1),
(8, 'Comunidade Segura', 'Joel e Ellie finalmente chegam à comunidade de Tommy, onde Joel considera deixar Ellie.', 2000, 1400, 1),
(9, 'Captura de Ellie', 'Ellie é capturada por David enquanto cuida de Joel em recuperação.', 2200, 1600, 2),
(10, 'Fuga do Hospital', 'Joel descobre que Ellie será sacrificada no hospital e decide resgatá-la, enfrentando os Vagalumes.', 2400, 1800, 1);



INSERT INTO Itinerario(idItinerario, horario, dia, idEvento) VALUES
(1, '22:00', 'Segunda-feira', 1),
(2, '10:00', 'Terça-feira', 2),
(3, '15:00', 'Quarta-feira', 3),
(4, '18:00', 'Quinta-feira', 4),
(5, '12:00', 'Sexta-feira', 5),
(6, '08:00', 'Sábado', 6),
(7, '20:00', 'Domingo', 7),
(8, '14:00', 'Segunda-feira', 8),
(9, '16:00', 'Terça-feira', 9),
(10, '19:00', 'Quarta-feira', 10);

INSERT INTO Habilidade(idHabilidade,nomeHabilidade,tipoHabilidade,efeito,duracaoHabilidade,idPC) VALUES
(1, 'Furtividade', 'Passiva', 'Aumenta a chance de passar despercebido pelos inimigos.', 'Permanente', 1),
(2, 'Recuperação Rápida', 'Ativa', 'Recupera uma quantidade moderada de vida durante o combate.', 'Temporária', 4),
(3, 'Ataque Furtivo', 'Ativa', 'Causa dano extra em ataques surpresa.', 'Temporária', 5),
(4, 'Resistência a Infecção', 'Passiva', 'Diminui a chance de ser infectado por mordidas de infectados.', 'Permanente', 6),
(5, 'Recarga Rápida', 'Ativa', 'Recarrega a arma mais rapidamente durante o combate.', 'Temporária', 7),
(6, 'Ataque Preciso', 'Ativa', 'Aumenta a precisão dos tiros por um curto período.', 'Temporária', 8),
(7, 'Esquiva Rápida', 'Ativa', 'Permite esquivar de ataques inimigos com maior facilidade.', 'Temporária', 9),
(8, 'Ataque em Grupo', 'Ativa', 'Aumenta o dano causado em ataques conjuntos com aliados.', 'Temporária', 10),
(9, 'Defesa Reforçada', 'Passiva', 'Diminui o dano recebido em combate.', 'Permanente', 11),
(10, 'Ataque Certeiro', 'Ativa', 'Aumenta a chance de acerto crítico em ataques.', 'Temporária', 12);

INSERT INTO Inst_Item(idItem,tipoItem) VALUES
(1, 'Arma de Fogo'),
(2, 'Medicamento'),
(3, 'Equipamento de Sobrevivência'),
(4, 'Ferramenta'),
(5, 'Alimento'),
(6, 'Material de Construção'),
(7, 'Armadura'),
(8, 'Acessório'),
(9, 'Munição'),
(10, 'Mapa'),
(11, 'Kit de Primeiros Socorros');

INSERT INTO Arma(idArma,idItem,nomeArma,dano,municaoAtual,municaoMax,idInventario,eAtaque) VALUES
(1, 1, 'Revólver', 30, 6, 6, 1, true),
(2, 2, 'Pistola', 25, 8, 8, 2, true),
(3, 3, 'Rifle', 40, 4, 4, 3, true),
(4, 4, 'Escopeta', 50, 2, 2, 4, true),
(5, 5, 'Arco', 35, 10, 10, 5, true),
(6, 6, 'Faca', 20, NULL, NULL, 6, true),
(7, 7, 'Machado', 45, NULL, NULL, 7, true),
(8, 8, 'Machete', 40, NULL, NULL, 8, true), 
(9, 9, 'Lança', 30, NULL, NULL, 9, true);

INSERT INTO Vestimenta(idVestimenta,idItem,nomeVestimenta,descricaoVestimenta,idInventario,eAtaque) VALUES
(1, 1, 'Jaqueta de Couro', 'Jaqueta resistente a cortes e arranhões.', 1, false),
(2, 2, 'Colete Tático', 'Colete à prova de balas para proteção extra.', 2, false),
(3, 3, 'Calça de Carga', 'Calça com bolsos para carregar suprimentos.', 6, false),
(4, 4, 'Camisa de Combate', 'Camisa resistente para proteção do torso.', 7, false),
(5, 5, 'Cinto de Utilidades', 'Cinto com compartimentos para itens essenciais.', 8, false);
(6, 6, 'Escudo de Madeira', 'Escudo improvisado para defesa contra ataques.', 9, false);

INSERT INTO Alimento(idAlimento,idItem,nomeAlimento,tipoAlimento,aumentoVida,idInventario,eAtaque) VALUES
(1, 21, 'Barra de Cereal', 'Energético', 10, 1, 1),
(2, 22, 'Lata de Sardinha', 'Proteína', 15, 2, 2),
(3, 23, 'Pacote de Biscoitos', 'Carboidrato', 20, 3, 3),
(4, 24, 'Garrafa de Água', 'Hidratante', 25, 4, 4),
(5, 25, 'Pacote de Salgadinhos', 'Salgado', 30, 5, 5),
(6, 26, 'Frutas Secas', 'Vitaminas', 35, 6, 6),
(7, 27, 'Barras de Proteína', 'Proteína', 40, 7, 7),
(8, 28, 'Pacote de Macarrão', 'Carboidrato', 45, 8, 8),
(9, 29, 'Lata de Feijão', 'Proteína', 50, 9, 9),
(10, 30, 'Vitaminas de evolução', 'Vitaminas, enzimas', 55, 10, 10);

INSERT INTO Receita(idReceita,nomeReceita,descricaoReceita,tempoCraft,idItem) VALUES
(1, 'Kit de Primeiros Socorros', 'Kit básico para curativos e tratamento de ferimentos.', 1, 12),
(2, 'Bomba de Fumaça', 'Bomba que cria uma cortina de fumaça para cobertura.', 4, 4),
(3, 'Mina de Proximidade', 'Granada explosiva que causa dano em área.', 5, 5),
(4, 'Munição', 'Conjunto de balas para armas de fogo.', 6, 6),
(5, 'Coquetel Molotov', 'Garrafa incendiária utilizada para causar danos de fogo em área.', 7, 7);
(6, 'Faca', 'Ferramenta improvisada que pode ser usada para ataques furtivos e abrir portas trancadas.', 2, 8),
(7, 'Bomba de Pregos', 'Explosivo improvisado que detona ao contato, causando dano em área com fragmentos de pregos.', 5, 9),
(8, 'Bomba Incendiária', 'Dispositivo explosivo que causa uma explosão de fogo ao ser lançado.', 4, 10),
(9, 'Kit de Reparos', 'Conjunto de ferramentas utilizado para reparar armas brancas, aumentando sua durabilidade.', 3, 11),
(10, 'Flechas', 'Munição para arco, pode ser craftada utilizando materiais encontrados.', 2, 13);

INSERT INTO Ingrediente(idIngrediente,idReceita,idItem,quantidadeIngre) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 3),
(4, 4, 4, 4),
(5, 5, 5, 5),
(6, 6, 6, 6),
(7, 7, 7, 7),
(8, 8, 8, 8),
(9, 9, 9, 9),
(10, 10, 10, 10);

INSERT INTO Evolucao(idEvolucao,requisitoNivel,xpEvol) VALUES
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

INSERT INTO Concede(idEvolucao,idAlimento) VALUES
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

INSERT INTO Dialoga(idDialogo,idFalante,idOuvinte,conteudo,duracaoDialogo) VALUES
(1, 1, 2, 'Joel: O que você está fazendo aqui?', 1),
(2, 2, 3, 'Guardião da Zona: Estou patrulhando a área. E você?', 2),
(3, 3, 4, 'Sobrevivente Selvagem: Estou procurando suprimentos. Você viu algo?', 3),
(4, 4, 5, 'Mercador: Tenho itens raros para venda. Interessado?', 4),
(5, 5, 6, 'Informante: Ouvi rumores sobre uma base secreta. Vamos investigar.', 5),
(6, 6, 7, 'Líder de Facção: Nossa facção precisa de aliados. O que você acha?', 6),
(7, 7, 8, 'Sobrevivente Isolado: Estou sozinho há muito tempo. Preciso de ajuda.', 7),
(8, 8, 9, 'Guarda Costas: Vamos manter a segurança da região juntos.', 8),
(9, 9, 10, 'Engenheiro: Preciso de materiais para consertar o gerador. Pode ajudar?', 9),
(10, 10, 11, 'Curandeiro: Vamos tratar dos feridos e doentes. Eles precisam de nós.', 10),
(11, 11, 12, 'Estranho Misterioso: Tenho informações valiosas sobre o passado. Quer saber?', 11);

INSERT INTO InstNPC(idNPC, tipoNPC) VALUES
(2, 'Infectado'),
(3, 'Infectado'),
(5, 'Infectado'),
(7, 'Infectado'),
(9, 'Infectado'),
(6, 'Infectado'),
(8, 'Infectado'),
(10, 'Infectado'),
(11, 'Infectado'),
(12, 'Infectado'),
(13, 'FaccaoHumana'),
(16, 'FaccaoHumana'),
(14, 'Animal'),
(15, 'Animal');


INSERT INTO Infectado(idNPC,idInfectado,comportamentoInfec) VALUES
(2, 1, 'Corredor'),
(3, 2, 'Estalador'),
(5, 3, 'Baiacu'),
(7, 4, 'Corredor'),
(9, 5, 'Estalador'),
(6, 6, 'Baiacu'),
(8, 7, 'Corredor');

INSERT INTO FaccaoHumana(idNPC,idFaccao,nomeFaccao) VALUES
(9, 1, 'Vagalumes'),
(10, 2, 'Serafitas');

INSERT INTO Animal(idNPC,idAnimal,nomeAlimento,ameaca) VALUES
(11, 1, 'Lobo Selvagem', 'Alta'),
(12, 2, 'Urso Pardo', 'Alta'),
(13, 3, 'Peixes', 'Alta'),
(14, 4, 'Insetos', 'Baixa');

INSERT INTO Participacao(idNPC,Evento,Missao) VALUES
(2, 1, 1),
(3, 2, 2),
(5, 3, 3),
(7, 4, 4),
(9, 5, 5),
(6, 6, 6),
(8, 7, 7),
(10, 8, 8),
(11, 9, 9),
(12, 10, 10);

COMMIT;

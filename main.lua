-- Controle/Armazenamento do fundo do jogo
Fundo = nil
larg = nil
altu = nil

-- Tabela de parametros do personagem
Jogador = { posx = 0, posy = 0, veloc = 150, img = nil}

-- Timers para sincronização
AtiraMax = 0.2
PodeAtirar = true
TempoTiro = AtiraMax

--Variavel para manipular projetil
ImgProj = nil

-- Tabela de controle dos projetéis
Projeteis = {}

--Temporização dos inimigos
dtMaxCriaInimigo = 0.4
dtAtualInimigo = dtMaxCriaInimigo

-- Estrutura para gerenciar os inimigos
ImgInimigo = nil
Inimigos = {}

-- Controle de estado do jogador e pontuação
Vivo = true
Pontos = 0

-- Função para controlar colisão dos aviões
-- Bouding Box - Caixa Continente
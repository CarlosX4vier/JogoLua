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
function Colisao(x1,y1,l1,h1,x2,y2,l2,h2)
  return x1 < x2 + l2 and x2 < x1 + l1 and y1 < y2 + h2 and y2 < y1 +h1
end

function love.load()
  larg = 480
  altu = 800
  iniciox = (larg - 76) / 2
  inicioy = ((altu - 94) / 2 ) / 2
    
  --Carga da imagem do jogador
  Jogador.img = love.graphics.newImage('assets/aviao.png')
  Jogador.posx = iniciox
  Jogador.posy = inicioy
    
  --Carga das outras imagens do ambiente
  Fundo = love.graphics.newImage('assets/fundo.png')
  ImgProj = love.graphics.newImage('assets/projetil.png')
  ImgInimigo = love.graphics.newImage('assets/inimigo.png')
  
  -- Carga do efeito sonoro do tiro
  Tiro = love.audio.newSource('assets/tiro.wav', 'static')
end

function love.update(dt)
  --Tecla de controle para abandonar o jogo
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  -- Controle da movimentação lateral do personagem
  if love.keyboard.isDown('left', 'a') then
    if Jogador.posx > 0 then
      Jogador.posx = Jogador.posx - (Jogador.veloc * dt)
    end
  elseif love.keyboard.isDown('right', 'd') then
    if Jogador.posx < (love.graphics.getWidth() - Jogador.img:getWidth()) then
      Jogador.posx = Jogador.posx + (Jogador.veloc * dt)
    end
  end

  -- Controle de temporização de tiros
  TempoTiro = TempoTiro - (1*dt)
  if TempoTiro < 0 then 
    PodeAtirar = true
  end

  if love.keyboard.isDown('space', 'rctrl') and PodeAtirar and Vivo then
    nvProj = {x = Jogador.posx + Jogador.img:getWidth()/2, y = Jogador.posy, img = ImgProj}
    table.insert( Projeteis,nvProj )
Tiro:play()
  end 
  
end
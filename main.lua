-- Controle/Armazenamento do fundo do jogo
Fundo = nil
larg = nil
altu = nil

-- Tabela de parametros do personagem
Jogador = { posx = 0, posy = 0, veloc = 300, img = nil}

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
  inicioy = altu - ((altu - 94) / 2 ) / 2
    
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

  if love.keyboard.isDown('space', 'lctrl', 'rctrl') and PodeAtirar and Vivo then
    nvProj = {x = Jogador.posx + Jogador.img:getWidth()/2, y = Jogador.posy, img = ImgProj}
    table.insert( Projeteis,nvProj )
    Tiro:play()
    PodeAtirar = false
    TempoTiro = AtiraMax
  end 
  
  -- Atualizar a lista de projeteis
  for i,proj in ipairs(Projeteis) do
    proj.y = proj.y - (250 * dt)
    if proj.y < 0 then -- remove o projetil que saiu da tela
      table.remove(Projeteis, i)
    end
  end
  
  -- Temporizaçao da onda de inimigos
  dtAtualInimigo = dtAtualInimigo - (1 * dt)
  if dtAtualInimigo < 0 then
    dtAtualInimigo = dtMaxCriaInimigo
    posDinamica = math.random(10, larg - ImgInimigo:getWidth())
    nvInimigo = { x = posDinamica, y = -10, img = ImgInimigo }
    table.insert(Inimigos, nvInimigo)
  end
  
  for i, inimigo in ipairs(Inimigos) do
    inimigo.y = inimigo.y + (200* dt)
    if inimigo.y > 850 then -- remover se ultrapassar o final da tela
      table.remove(Inimigos, i)
    end
  end
  
  -- Controlando colisoes
  -- Tendo como base que devemos ter menos inimigos do que projeteis
  -- vamos processar os inimigos primeiro
  
  for i, inimigo in ipairs(Inimigos) do
    for j, proj in ipairs(Projeteis) do
      if Colisao(inimigo.x, inimigo.y, inimigo.img:getWidth(), inimigo.img:getHeight(), proj.x,proj.y,proj.img:getWidth(), proj.img:getHeight()) then
        table.remove(Projeteis,j)
        table.remove(Inimigos,i)
        Pontos = Pontos + 10
      end
    end
    
    -- Agora colisao com meu personagem
    if Colisao(inimigo.x, inimigo.y, inimigo.img:getWidth(), inimigo.img:getHeight(), Jogador.posx, Jogador.posy, Jogador.img:getWidth(), Jogador.img:getHeight()) and Vivo then
      table.remove(Inimigos, i)
      Vivo = false
    end
  end
  
  --Reiniciar o jogo se R for pressionado
  if not Vivo and love.keyboard.isDown('r') then
    Projeteis = {}
    Inimigos = {} 
    -- Reinicializando os temporizadores 
    TempoTiro = AtiraMax
    dtAtualInimigo = dtMaxCriaInimigo
    --Movimenta o jogador para a posição inicial
    Jogador.posx = iniciox
    Jogador.posy = inicioy
    -- Reinicia o placar e vida
    Pontos = 0
    Vivo = true
  end
end

function love.draw()
  love.graphics.draw(Fundo, 0,0)
  if Vivo then 
    love.graphics.draw(Jogador.img, Jogador.posx,Jogador.posy)
  else
    love.graphics.print("Pressione r para reinicializar ou ESC para sair", love.graphics.getWidth()/2- 50, love.graphics.getHeight()/2 - 10)
  end
  
  --Desenhar a lista de projeteis
  for i, proj in ipairs(Projeteis) do
    love.graphics.draw(proj.img, proj.x,proj.y)
  end
  
  -- Desenhar a lista de inimigos 
  for i, inimigo in ipairs(Inimigos) do
    love.graphics.draw(inimigo.img,inimigo.x,inimigo.y)
  end
  
  --Pontuacao
  love.graphics.setColor(1,1,1)
  love.graphics.print("PONTOS: ".. tostring(Pontos), 10,10)
end

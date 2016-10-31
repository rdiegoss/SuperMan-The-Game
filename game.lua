------------------------------------------------------------
--Introduccion a la programacion de VideoJuegos: Superman
--Aythami Mendoza y Eugenio Mendoza
-- ULPGC 2013
------------------------------------------------------------
--Pantalla de Juego

local fisica = require "physics"
fisica.start()

fisica.setDrawMode("hybrid")
fisica.setGravity(0,9.8)

require "sprite"

local storyboard = require ("storyboard")
local scene = storyboard.newScene()

local sfin = audio.loadSound ("gameover.mp3")

--crear la escena
function scene:createScene(event)

	local screenGroup = self.view

	local fondo = display.newImage("fondo.png")
	screenGroup:insert(fondo)
	
	--techo = display.newRect(0, 0, display.contentWidth, 1 )
	--fisica.addBody(techo, "static", {friction = 1.0})
	--screenGroup:insert(techo)
		
	techo = display.newImage("invisible.png")
	techo:setReferencePoint(display.BottomLeftReferencePoint)
	techo.x = 0
	techo.y = 0
	fisica.addBody(techo, "static", {density=.1, bounce=0.1, friction=.2})
	screenGroup:insert(techo)
	
	suelo = display.newRect (0, display.contentHeight, display.contentWidth,1)
	fisica.addBody(suelo, "static", {friction = 1.0})
	screenGroup:insert(suelo)

    ciudad1 = display.newImage("ciudad1.png")
    ciudad1:setReferencePoint(display.BottomLeftReferencePoint)
    ciudad1.x = 0
    ciudad1.y = 320
    ciudad1.speed = 1
    screenGroup:insert(ciudad1)

    ciudad2 = display.newImage("ciudad1.png")
    ciudad2:setReferencePoint(display.BottomLeftReferencePoint)
    ciudad2.x = 480
    ciudad2.y = 320
    ciudad2.speed = 1
    screenGroup:insert(ciudad2)

    ciudad3 = display.newImage("ciudad2.png")
    ciudad3:setReferencePoint(display.BottomLeftReferencePoint)
    ciudad3.x = 0
    ciudad3.y = 320
    ciudad3.speed = 2
    screenGroup:insert(ciudad3)

    ciudad4 = display.newImage("ciudad2.png")
    ciudad4:setReferencePoint(display.BottomLeftReferencePoint)
    ciudad4.x = 480
    ciudad4.y = 320
    ciudad4.speed = 2
    screenGroup:insert(ciudad4)

    
    supermanSpriteSheet = sprite.newSpriteSheet("superman.png", 100, 34)
    supermanSprites = sprite.newSpriteSet(supermanSpriteSheet, 1, 4)
    sprite.add(supermanSprites, "supermanes", 1, 4, 1000, 0)
    superman = sprite.newSprite(supermanSprites)
    superman.x = 0
    superman.y = 100
    superman:prepare("supermanes")
    superman:play()
    superman.collided = false
    fisica.addBody(superman, "static", {density=.1, bounce=0.1, friction=.2})
	screenGroup:insert(superman)
	supermanIntro = transition.to(superman,{time=1000, x=100, onComplete=supermanReady})
	
	explosionSpriteSheet = sprite.newSpriteSheet("explosion.png", 24, 23)
    explosionSprites = sprite.newSpriteSet(explosionSpriteSheet, 1, 8)
    sprite.add(explosionSprites, "explosions", 1, 8, 2000, 1)
    explosion = sprite.newSprite(explosionSprites)
    explosion.x = 100
    explosion.y = 100
    explosion:prepare("explosions")
    explosion.isVisible = false
	screenGroup:insert(explosion)
	
	cript1 = display.newImage("criptonita.png")
    cript1.x = 300
    cript1.y = 100
    cript1.speed = math.random(1,1)
    cript1.initY = cript1.y
    cript1.amp = math.random(10,40)
    cript1.angle = math.random(1,360)
    fisica.addBody(cript1, "static", {density=.1, bounce=0.1, friction=.2, radius=13})
	screenGroup:insert(cript1)
	
	cript2 = display.newImage("criptonita.png")
    cript2.x = 100
    cript2.y = 200
    cript2.speed = math.random(2,6)
    cript2.initY = cript2.y
    cript2.amp = math.random(20,30)
    cript2.angle = math.random(1,360)
    fisica.addBody(cript2, "static", {density=.1, bounce=0.1, friction=.2, radius=13})
	screenGroup:insert(cript2)
end
---------------------------------------
--funciones propias
function moverCiudad(self,event)
	if self.x < -477 then
		self.x = 480
	else
	self.x = self.x - self.speed
	end
end

function moverCript(self,event)
	if self.x < -50 then
		 self.x = 500
         self.y = math.random(90,220)
         self.speed = math.random(1,3)
         self.amp = math.random(20,100)
         self.angle = math.random(1,360)
	else 
		self.x = self.x - self.speed
		self.angle = self.angle + .1
		self.y = self.amp*math.sin(self.angle)+self.initY
	end
end


--Le decimos que superman es un elemento dinamico
function supermanReady()
	superman.bodyType = "dynamic"
end

--Activamos los cuatro supermanes (efecto de moviento)
function activatesupermanes(self,event)
	self:applyForce(0, -9.5, self.x, self.y)
	print("volando")
end


--evento que recibe el toque de la pantalla
function touchScreen(event)
   -- print("toque")
   if event.phase == "began" then
   	 superman.enterFrame = activatesupermanes
   	 Runtime:addEventListener("enterFrame", superman)
   end
   
   if event.phase == "ended" then
   	 Runtime:removeEventListener("enterFrame", superman)
   end
end

function gameOver()
   storyboard.gotoScene("restart", "fade", 400)
end


function explode()

	explosion.x = superman.x
	explosion.y = superman.y
	explosion.isVisible = true
	explosion:play()
	superman.isVisible = false
	timer.performWithDelay(3000, gameOver, 1)
	
	
end

function onCollision(event)
	if event.phase == "began" then
	  if superman.collided == false then 
	    superman.collided = true
	    superman.bodyType = "static"
	    explode()
		audio.stop()
		audio.play(sfin)
		
	  end
	end
end

----------------------------------------


--Todos los eventos que tenemos en pantalla
function scene:enterScene(event)

	storyboard.purgeScene("start")
	storyboard.purgeScene("restart")

	Runtime:addEventListener("touch", touchScreen)

	ciudad1.enterFrame = moverCiudad
    Runtime:addEventListener("enterFrame", ciudad1)

    ciudad2.enterFrame = moverCiudad
    Runtime:addEventListener("enterFrame", ciudad2)

    ciudad3.enterFrame = moverCiudad
    Runtime:addEventListener("enterFrame", ciudad3)

    ciudad4.enterFrame = moverCiudad
    Runtime:addEventListener("enterFrame", ciudad4)


	cript1.enterFrame = moverCript
    Runtime:addEventListener("enterFrame", cript1)
    
    cript2.enterFrame = moverCript
    Runtime:addEventListener("enterFrame", cript2)
	
	Runtime:addEventListener("collision", onCollision)
	

end

-- Eliminar todos los eventos
function scene:exitScene(event)

	Runtime:removeEventListener("touch", touchScreen)

	Runtime:removeEventListener("enterFrame", ciudad1)
	Runtime:removeEventListener("enterFrame", ciudad2)
	Runtime:removeEventListener("enterFrame", ciudad3)
	Runtime:removeEventListener("enterFrame", ciudad4)

	Runtime:removeEventListener("enterFrame", cript1)
	Runtime:removeEventListener("enterFrame", cript2)
	
	Runtime:removeEventListener("collision", onCollision)


end

--funcion de destruccion de la pantalla
function scene:destroyScene(event)

end

--añadimos todos los eventos
scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene
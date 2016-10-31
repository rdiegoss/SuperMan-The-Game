------------------------------------------------------------
--Introduccion a la programacion de VideoJuegos: Superman
--Aythami Mendoza y Eugenio Mendoza
-- ULPGC 2013
------------------------------------------------------------
--Pantalla de Inicio

local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local sonido = audio.loadSound("BSO.mp3")

function scene:createScene(event)
	local screenGroup = self.view
	 fondo = display.newImage("start.png")
	screenGroup:insert(fondo)
	audio.play(sonido)
end


function start(event)
	if event.phase == "began" then
		storyboard.gotoScene("game", "fade", 400)
	end
end


function scene:enterScene(event)
	fondo:addEventListener("touch", start)
end

function scene:exitScene(event)
	fondo:removeEventListener("touch", start)
end

function scene:destroyScene(event)

end


scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene

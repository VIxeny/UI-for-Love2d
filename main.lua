if arg[2] == "debug" then
    require("lldebugger").start()
end

require "UIManager"
local translateX = 0
local playerX = 0

function love.load()

end

function love.update(dt)
    playerX = playerX + 100*dt
    translateX = -playerX

    UpdateUI()
    
end

function love.draw()
    love.graphics.translate(translateX, 0)
    --love.graphics.rectangle("fill", 800, 200, 100, 50)
    love.graphics.translate(-translateX, 0)
    --love.graphics.circle("fill", love.graphics.getWidth() + playerX, love.graphics.getHeight()/2, 20)
    DrawUI()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        UIOn1Down()
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        UIon1Release()
    end
end

function love.textinput(t)
    UITextInput(t)
end

function love.keypressed(key)
    if key == "backspace" then
        UITextDelete()
    end
end
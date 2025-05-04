require "UILibrary"

local menu

local myText = UI.Text.new({text = "Hello world", color = {1, 1, 1}, font = {30}})
local myImage = UI.Image.new({x = 400, w = 200})
local myButton = UI.Button.new{x = 400, y = 200, trigger = function ()
    ManageUI({menu.firstScreen}, {menu.secondScreen})
end}
local myButton2 = UI.Button.new{x = 450, y = 200, text = UI.Text.new{text = "Hahaha", alignH = "center", alignV = "down"}}

local myImage2 = UI.Image.new{y= 200, image = "Sword.png"}
local textField = UI.TextField.new{y = 300, amountOfLines = 2}

menu = {
    firstScreen = {myText, myImage, myButton, {myButton2}, textField},
    secondScreen = {myImage2}
}

return menu
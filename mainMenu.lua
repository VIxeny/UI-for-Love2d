require "UILibrary"

local menu

local myText = UI.Text.new({text = "Hello world", color = {1, 1, 1}, font = {30}})
local myImage = UI.Image.new({x = 400, w = 200})
local myButton = UI.Button.new{x = 400, y = 200, trigger = function ()
    ManageUI({menu.firstScreen}, {menu.secondScreen})
end}
local myButton2 = UI.Button.new{x = 450, y = 200, text = UI.Text.new{text = "Hahaha No way bro", alignH = "center", alignV = "center"}}

local myImage2 = UI.Image.new{y= 200, image = "Sword.png"}
local textField = UI.TextField.new{y = 300, amountOfLines = 2}

local downText = UI.Text.new{
    w = 300, h = 200, text = "Check no way maybe that", color = {1, 1, 1}, font = {30}, alignV = "down"
}
local myImage3 = UI.Image.new{
    y = 200
}
MyBar = UI.Bar.new{
    x = 400, y = 400, fill = 1
}

menu = {
    firstScreen = {myText, myImage, myButton, {myButton2}, textField, downText, myImage3, MyBar},
    secondScreen = {myImage2}
}

return menu
require "OOP"
utf8 = require "utf8"

local white = { 1, 1, 1 }
local black = { 0, 0, 0 }

UIClass = Class.new()

function UIClass.init(instance, arg)
    instance.x = arg.x or 0
    instance.y = arg.y or 0
    instance.w = arg.w or 100
    instance.h = arg.h or 50
end

function UIClass.draw()
    print("Нет метода draw")
end

UI = {}

UI.Text = Class.new().extends(UIClass)
UI.Button = Class.new().extends(UIClass)
UI.TextField = Class.new().extends(UIClass)
UI.Image = Class.new().extends(UIClass)
UI.Bar = Class.new().extends(UIClass)

function UI.Text.init(instance, arg)
    UIClass.init(instance, arg)
    instance.text = arg.text or ""
    instance.color = arg.color or black
    instance.w = arg.w or 500
    instance.alignH = arg.alignH or "left"
    instance.alignV = arg.alignV or "up"
    if arg.font then
        instance.font = love.graphics.newFont(arg.font[1], arg.font[2])
    else
        instance.font = love.graphics.getFont()
    end
    instance.h = arg.h or instance.font:getHeight()
end

function UI.Text.draw(text)
    love.graphics.setColor(text.color)
    love.graphics.setFont(text.font)
    local hOfFont = text.font:getHeight()
    if text.alignV == "down" then
        love.graphics.printf(text.text, text.x, text.y + (text.h - hOfFont), text.w, text.alignH)
    elseif text.alignV == "center" then
        love.graphics.printf(text.text, text.x, text.y + (text.h - hOfFont) / 2, text.w, text.alignH)
    else
        love.graphics.printf(text.text, text.x, text.y, text.w, text.alignH)
    end
end

function UI.Image.init(instance, arg)
    UIClass.init(instance, arg)
    if arg.image then
        instance.image = love.graphics.newImage(arg.image)
    else
        instance.image = love.graphics.newImage("NoImage.png")
    end
    instance.w = arg.w or instance.image:getWidth()
    instance.h = arg.h or instance.image:getHeight()
    instance.color = arg.color or white
end

function UI.Image.draw(image)
    love.graphics.setColor(image.color)
    love.graphics.draw(image.image, image.x, image.y, 0, image.w / image.image:getWidth(),
        image.h / image.image:getHeight())
end

function UI.Button.init(instance, arg)
    UIClass.init(instance, arg)
    instance.color = arg.color or white
    instance.hoverColor = arg.hoverColor or { 0.7, 0.7, 0.7 }
    instance.clickedColor = arg.clickedColor or { 0.4, 0.4, 0.4 }
    instance.currentColor = instance.color
    if arg.text then
        instance.text = arg.text
        instance.text.x = instance.text.x + instance.x
        instance.text.y = instance.text.y + instance.y
    else
        instance.text = UI.Text.new { x = instance.x, y = instance.y }
    end
    instance.text.w = instance.w
    instance.text.h = instance.h
    instance.trigger = arg.trigger or function() print("Button Pressed") end
    instance.image = arg.image
end

function UI.Button.draw(button)
    love.graphics.setColor(button.currentColor)
    if button.image then
        UI.Image.draw(button.image)
    else
        love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
    end
    UI.Text.draw(button.text)
end

function UI.TextField.init(instance, arg)
    UIClass.init(instance, arg)
    instance.image = arg.image
    instance.color = arg.color or { 0.7, 0.7, 0.7 }
    instance.clickedColor = arg.clickedColor or { 0.4, 0.4, 0.4 }
    instance.currentColor = instance.color
    instance.outlineColor = arg.outlineColor or white
    if arg.text then
        instance.text = arg.text
        instance.text.x = instance.text.x + instance.x
        instance.text.y = instance.text.y + instance.y
    else
        instance.text = UI.Text.new { x = instance.x, y = instance.y }
    end
    instance.text.w = instance.w
    instance.text.h = instance.h
    instance.amountOfCharacters = arg.amountOfCharacters or 10
end

function UI.TextField.draw(textField)
    love.graphics.setColor(textField.currentColor)
    if textField.image then
        textField.image.color = textField.currentColor
        UI.Image.draw(textField.image)
    else
        love.graphics.setColor(textField.currentColor)
        love.graphics.rectangle("fill", textField.x, textField.y, textField.w, textField.h)
        love.graphics.setColor(textField.outlineColor)
        love.graphics.rectangle("line", textField.x, textField.y, textField.w, textField.h)
    end
    UI.Text.draw(textField.text)
end

function ChangeActiveUI(remove, add)
    for index, value in ipairs(remove) do
        for index2, value2 in ipairs(ActiveUI) do
            if value == value2 then
                table.remove(ActiveUI, index2)
                break
            end
        end
    end
    for index, value in ipairs(add) do
        local alreadyHave = false
        for index2, value2 in ipairs(ActiveUI) do
            if value == value2 then
                alreadyHave = true
                break
            end
        end
        if not alreadyHave then
            table.insert(ActiveUI, value)
        end
    end
end

local mX
local mY
local currentElementSelected = nil
local currentElementHovered = nil
function UpdateUI()
    mX = love.mouse.getX()
    mY = love.mouse.getY()
    if not currentElementSelected then
        if currentElementHovered then
            currentElementHovered.currentColor = currentElementHovered.color
            currentElementHovered = nil
        end
        if not love.mouse.isDown(1) then
            UpdateElements(ActiveUI)
        end
    end
end

function UpdateElements(ActiveUI)
    for i = #ActiveUI, 1, -1 do
        if currentElementHovered then
            break
        end
        if ActiveUI[i].isParent then
            if mX > ActiveUI[i].x and mX < ActiveUI[i].x + ActiveUI[i].w and
                mY > ActiveUI[i].y and mY < ActiveUI[i].y + ActiveUI[i].h then
                if ActiveUI[i].isParent(UI.Button) then
                    ActiveUI[i].currentColor = ActiveUI[i].hoverColor
                end
                currentElementHovered = ActiveUI[i]
            end
        else
            UpdateElements(ActiveUI[i])
        end
    end
end

function UIOn1Down()
    UpdateElementsOn1Down(ActiveUI)
end

function UIon1Release()
    if currentElementSelected and currentElementSelected.isParent(UI.Button) then
        currentElementSelected.currentColor = currentElementSelected.color
        currentElementSelected = nil
    end
end

function UpdateElementsOn1Down(ActiveUI)
    if currentElementSelected and currentElementSelected.isParent(UI.TextField) then
        currentElementSelected.currentColor = currentElementSelected.color
        currentElementSelected = nil
    else
        for i = #ActiveUI, 1, -1 do
            if currentElementSelected then
                break
            end
            if ActiveUI[i].isParent then
                if mX > ActiveUI[i].x and mX < ActiveUI[i].x + ActiveUI[i].w and
                    mY > ActiveUI[i].y and mY < ActiveUI[i].y + ActiveUI[i].h then
                    if ActiveUI[i].isParent(UI.Button) then
                        ActiveUI[i].currentColor = ActiveUI[i].clickedColor
                        ActiveUI[i].trigger()
                    elseif ActiveUI[i].isParent(UI.TextField) then
                        ActiveUI[i].currentColor = ActiveUI[i].clickedColor
                    end
                    currentElementSelected = ActiveUI[i]
                end
            else
                UpdateElementsOn1Down(ActiveUI[i])
            end
        end
    end
end

function UITextInput(t)
    if currentElementSelected and currentElementSelected.isParent(UI.TextField) then
        local c = currentElementSelected
        if #(c.text.text .. t) <= c.amountOfCharacters then
            currentElementSelected.text.text = currentElementSelected.text.text .. t
        end
    end
end

function UITextDelete()
    if currentElementSelected and currentElementSelected.isParent(UI.TextField) then
        local byteoffset = utf8.offset(currentElementSelected.text.text, -1)
        if byteoffset then
            currentElementSelected.text.text = string.sub(currentElementSelected.text.text, 1, byteoffset - 1)
        end
    end
end

function DrawUI()
    DrawElements(ActiveUI)
end

function DrawElements(ActiveUI)
    for index, UIElement in ipairs(ActiveUI) do
        if UIElement.isParent then
            if UIElement.isParent(UIClass) then
                UIElement.draw(UIElement)
            end
        else
            DrawElements(UIElement)
        end
    end
end

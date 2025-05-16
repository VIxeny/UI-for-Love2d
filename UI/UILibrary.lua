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
UI.Slider = Class.new().extends(UIClass)
UI.BoxText = Class.new().extends(UIClass)
UI.BoxMenu = Class.new().extends(UIClass)

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
    instance.hOfFont = instance.font:getHeight()
    instance.h = arg.h or instance.hOfFont
    instance.wOfFont = instance.font:getWidth("a")
    instance.amountOfLines = math.ceil(#instance.text / math.floor(instance.w / instance.wOfFont))
    if instance.alignV == "down" then
        instance.finalY = instance.y + (instance.h - instance.hOfFont * instance.amountOfLines)
    elseif instance.alignV == "center" then
        instance.finalY = instance.y + (instance.h - instance.hOfFont * instance.amountOfLines)/2
    else
        instance.finalY = instance.y
    end
end

function UI.Text:textChange(text)
    self.text = text
    self.amountOfLines = math.ceil(#self.text / math.floor(self.w / self.wOfFont))
    if self.alignV == "down" then
        self.finalY = self.y + (self.h - self.hOfFont * self.amountOfLines)
    elseif self.alignV == "center" then
        self.finalY = self.y + (self.h - self.hOfFont * self.amountOfLines)/2
    else
        self.finalY = self.y
    end
end

function UI.Text:alingVChange(alignV)
    if alignV == "down" then
        self.finalY = self.y + (self.h - self.hOfFont * self.amountOfLines)
    elseif alignV == "center" then
        self.finalY = self.y + (self.h - self.hOfFont * self.amountOfLines)/2
    else
        self.finalY = self.y
    end
end

function UI.Text.draw(text)
    love.graphics.setColor(text.color)
    love.graphics.setFont(text.font)
    local hOfFont = text.font:getHeight()
    local wOfFont = text.font:getWidth("a")
    love.graphics.printf(text.text, text.x, text.finalY, text.w, text.alignH)
end

function UI.Image.init(instance, arg)
    UIClass.init(instance, arg)
    if arg.image then
        instance.image = love.graphics.newImage(arg.image)
    else
        instance.image = love.graphics.newImage("UI/NoImage.png")
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
    else
        instance.text = UI.Text.new { x = instance.x, y = instance.y }
    end
    instance.text.x = instance.text.x + instance.x
    instance.text.alignH = instance.alignH or "center"
    instance.text.w = instance.w
    instance.text.h = instance.h
    if instance.alignV then
        instance.text:alingVChange(instance.alignV)
    else
        instance.text:alingVChange("center")
    end
    instance.text.finalY = instance.text.finalY + instance.y
    instance.trigger = arg.trigger or function() print("Button Pressed") end
    instance.image = arg.image
end

function UI.Button.draw(button)
    love.graphics.setColor(button.currentColor)
    if button.image then
        love.graphics.draw(button.image, button.x, button.y, 0, button.w / button.image:getWidth(),
        button.h / button.image:getHeight())
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
        love.graphics.draw(textField.image, textField.x, textField.y, 0, textField.w / textField.image:getWidth(),
        textField.h / textField.image:getHeight())
    else
        love.graphics.rectangle("fill", textField.x, textField.y, textField.w, textField.h)
        love.graphics.setColor(textField.outlineColor)
        love.graphics.rectangle("line", textField.x, textField.y, textField.w, textField.h)
    end
    UI.Text.draw(textField.text)
end

function UI.Bar.init(instance, arg)
    UIClass.init(instance, arg)
    instance.h = 20 or arg.h
    instance.color = arg.color or {1, 0, 0}
    instance.image = arg.image or love.graphics.newImage("UI/NoImage.png")
    instance.fill = arg.fill or 1
end

function UI.Bar:ChangeFill(fill)
    if fill >= 1 then
        self.fill = 1
    elseif fill <= 0 then
        self.fill = 0
    else
        self.fill = fill
    end
end

function UI.Bar.draw(bar)
    love.graphics.setColor(bar.color)
    love.graphics.setScissor(bar.x, bar.y, bar.w * bar.fill ,bar.h)
    love.graphics.draw(bar.image, bar.x, bar.y, 0, bar.w / bar.image:getWidth(),
        bar.h / bar.image:getHeight())
    love.graphics.setScissor()
end

function UI.Slider.init(instance, arg)
    UIClass.init(instance, arg)
    instance.h = 20 or arg.h
    instance.color = arg.color or white
    instance.imageSlider = arg.imageSlider or love.graphics.newImage("UI/Slider.png")
    instance.imageBox = arg.imageBox or love.graphics.newImage("UI/backgroundSlider.png")
    instance.wOfSlider = arg.wOfSlider or instance.imageSlider:getWidth()
    instance.hOfSlider = arg.hOfSlider or instance.imageSlider:getHeight()
    instance.fill = arg.fill or 1
    instance.range = arg.range or 0.8
    instance.xLeft = instance.x - instance.wOfSlider + (1 - instance.range)/2*instance.w
    instance.xRight = instance.x - instance.wOfSlider + (1-(1 - instance.range)/2)*instance.w
    instance.xSlider = instance.xLeft + (instance.xRight - instance.xLeft)*instance.fill
    instance.ySlider = instance.y + (instance.hOfSlider - instance.h) / 2
end

function UI.Slider:ChangePos(adjX)
    if self.xSlider + adjX > self.xLeft and self.xSlider + adjX < self.xRight then
        self.xSlider = self.xSlider + adjX
        self.fill = (self.xSlider - self.xLeft)/(self.xRight - self.xLeft)
    elseif  self.x + adjX <= self.xLeft then
        self.xSlider = self.xLeft
        self.fill = 0
    elseif self.x + adjX >= self.xRight then
        self.xSlider = self.xRight
        self.fill = 1
    end
end

function UI.Slider.draw(slider)
    love.graphics.setColor(slider.color)
    love.graphics.draw(slider.imageBox, slider.x, slider.y, 0, slider.w / slider.imageBox:getWidth(),
    slider.h / slider.imageSlider:getHeight())
    love.graphics.draw(slider.imageSlider, slider.xSlider, slider.ySlider, 0, slider.wOfSlider / slider.imageSlider:getWidth(),
    slider.hOfSlider / slider.imageSlider:getHeight())
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
local previousmX
local currentElementSelected = nil
local currentElementHovered = nil
local previousTextField = nil
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
    if currentElementSelected and currentElementSelected.isParent(UI.Slider) then
        currentElementSelected:ChangePos(mX - previousmX)
    end

    previousmX = love.mouse.getX()
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
    if currentElementSelected and currentElementSelected.isParent(UI.TextField) then
        previousTextField = currentElementSelected
        currentElementSelected.currentColor = currentElementSelected.color
        currentElementSelected = nil
    else
        previousTextField = nil
    end
    FindCurrentElement(ActiveUI)
    if currentElementSelected then
        if currentElementSelected.isParent(UI.Button) then
            currentElementSelected.currentColor = currentElementSelected.clickedColor
            currentElementSelected.trigger()
        elseif currentElementSelected.isParent(UI.TextField) and currentElementSelected ~= previousTextField then
            currentElementSelected.currentColor = currentElementSelected.clickedColor
        elseif currentElementSelected.isParent(UI.Slider) then
            if mX > currentElementSelected.xSlider and mX < currentElementSelected.xSlider + currentElementSelected.wOfSlider and
               mY > currentElementSelected.ySlider and mY < currentElementSelected.ySlider + currentElementSelected.hOfSlider then
            else
                currentElementSelected = nil
            end
        else
            currentElementSelected = nil
        end
    end
end

function UIon1Release()
    if currentElementSelected and currentElementSelected.isParent(UI.Button) then
        currentElementSelected.currentColor = currentElementSelected.color
        currentElementSelected = nil
    elseif currentElementSelected and currentElementSelected.isParent(UI.Slider) then
        currentElementSelected = nil
    end
end

function FindCurrentElement(ActiveUI)
    for i = #ActiveUI, 1, -1 do
        if currentElementSelected then
            break
        end
        if ActiveUI[i].isParent then
            if mX > ActiveUI[i].x and mX < ActiveUI[i].x + ActiveUI[i].w and
                mY > ActiveUI[i].y and mY < ActiveUI[i].y + ActiveUI[i].h then
                    currentElementSelected = ActiveUI[i]
            end
        else
            FindCurrentElement(ActiveUI[i])
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

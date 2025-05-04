require "UILibrary"
local mainMenu = require "mainMenu"
print("XD")

ActiveUI = {mainMenu.firstScreen}

function ManageUI(remove, add)
    ChangeActiveUI(remove, add)
end


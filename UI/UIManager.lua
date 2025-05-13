require "UI.UILibrary"
local mainMenu = require "UI.mainMenu"

ActiveUI = {mainMenu.thirdScreen}

--ChangeActiveUI(remove, add)
function ManageUI(remove, add)
    ChangeActiveUI(remove, add)
end


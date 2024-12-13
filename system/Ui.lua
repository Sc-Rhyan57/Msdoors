local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

if getgenv().ActiveUI then
    getgenv().ActiveUI.Library:Unload()
end

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

Library.ShowCustomCursor = true
Library.NotifySide = "Left"

SaveManager:SetLibrary(Library)
SaveManager:SetFolder('msdoors')
ThemeManager:SetLibrary(Library)

getgenv().ActiveUI = {
    Library = Library,
    ThemeManager = ThemeManager,
    SaveManager = SaveManager
}

return getgenv().ActiveUI

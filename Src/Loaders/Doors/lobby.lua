--[[
                                                                                                                     
     ______  _______            ______       _____           _____            _____         _____            ______  
    |      \/       \       ___|\     \  ___|\    \     ____|\    \      ____|\    \    ___|\    \       ___|\     \ 
   /          /\     \     |    |\     \|    |\    \   /     /\    \    /     /\    \  |    |\    \     |    |\     \
  /     /\   / /\     |    |    |/____/||    | |    | /     /  \    \  /     /  \    \ |    | |    |    |    |/____/|
 /     /\ \_/ / /    /| ___|    \|   | ||    | |    ||     |    |    ||     |    |    ||    |/____/  ___|    \|   | |
|     |  \|_|/ /    / ||    \    \___|/ |    | |    ||     |    |    ||     |    |    ||    |\    \ |    \    \___|/ 
|     |       |    |  ||    |\     \    |    | |    ||\     \  /    /||\     \  /    /||    | |    ||    |\     \    
|\____\       |____|  /|\ ___\|_____|   |____|/____/|| \_____\/____/ || \_____\/____/ ||____| |____||\ ___\|_____|   
| |    |      |    | / | |    |     |   |    /    | | \ |    ||    | / \ |    ||    | /|    | |    || |    |     |   
 \|____|      |____|/   \|____|_____|   |____|____|/   \|____||____|/   \|____||____|/ |____| |____| \|____|_____|   
    \(          )/         \(    )/       \(    )/        \(    )/         \(    )/      \(     )/      \(    )/     
     '          '           '    '         '    '          '    '           '    '        '     '        '    '      
                                                                                                                     
                                        Por Rhyan57 💜
]]--

--[[ APIS E SISTEMAS]]--
---[[ loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Msdoors/refs/heads/main/Src/Loaders/Doors/test/CustomNameWithGpt.lua"))() ]]--
local OrionLib = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Sc-Rhyan57/Msdoors/refs/heads/main/Library/OrionLibrary_msdoors.lua'))()
local Window = OrionLib:MakeWindow({IntroText = "Msdoors | V1",Icon = "rbxassetid://100573561401335", IntroIcon = "rbxassetid://95869322194132", Name = "MsDoors | Lobby", HidePremium = false, SaveConfig = true, ConfigFolder = ".msdoors/places/lobby"})
local MsdoorsNotify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Notification-doorsAPI/refs/heads/main/Msdoors/MsdoorsApi.lua"))()

MsdoorsNotify("Msdoors", "Iniciando...", " ", "rbxassetid://100573561401335", Color3.new(128, 0, 128), 2)

--[[ SERVIÇOS ]]--
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local remotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer


--[[ INICIANDO SCRIPT ]]--
local Script = {
    CurrentBadge = 0,
    Achievements = {
        "SurviveWithoutHiding",
        "SurviveGloombats",
        "SurviveSeekMinesSecond",
        "TowerHeroesGoblino",
        "EscapeBackdoor",
        "SurviveFiredamp",
        "CrucifixDread",
        "EnterRooms",
        "EncounterVoid",
        "Join",
        "DeathAmt100",
        "UseCrucifix",
        "EncounterSpider",
        "SurviveHalt",
        "SurviveRush",
        "DeathAmt10",
        "Revive",
        "PlayFriend",
        "SurviveNest",
        "CrucifixFigure",
        "CrucifixAmbush",
        "PlayerBetrayal",
        "SurviveEyes",
        "KickGiggle",
        "EscapeMines",
        "GlowstickGiggle",
        "DeathAmt1",
        "SurviveSeek",
        "UseRiftMutate",
        "CrucifixGloombatSwarm",
        "SurviveScreech",
        "SurviveDread",
        "SurviveSeekMinesFirst",
        "CrucifixHalt",
        "TowerHeroesVoid",
        "JoinLSplash",
        "CrucifixDupe",
        "EncounterGlitch",
        "JeffShop",
        "CrucifixScreech",
        "SurviveGiggle",
        "EscapeHotelMod1",
        "SurviveDupe",
        "CrucifixRush",
        "EscapeBackdoorHunt",
        "EscapeHotel",
        "CrucifixGiggle",
        "EscapeFools",
        "UseRift",
        "SpecialQATester",
        "EscapeRetro",
        "TowerHeroesHard",
        "EnterBackdoor",
        "EscapeRooms1000",
        "EscapeRooms",
        "EscapeHotelMod2",
        "EncounterMobble",
        "CrucifixGrumble",
        "UseHerbGreen",
        "CrucifixSeek",
        "JeffTipFull",
        "SurviveFigureLibrary",
        "TowerHeroesHotel",
        "CrucifixEyes",
        "BreakerSpeedrun",
        "SurviveAmbush",
        "SurviveHide",
        "JoinAgain"
    }
}

local function LoopAchievements()
    task.spawn(function()
        while OrionLib.Flags["LoopAchievements"].Value do
            if Script.CurrentBadge >= #Script.Achievements then
                Script.CurrentBadge = 0
            end
            Script.CurrentBadge = Script.CurrentBadge + 1
            local randomAchievement = Script.Achievements[Script.CurrentBadge]
            remotesFolder.FlexAchievement:FireServer(randomAchievement)
            task.wait(OrionLib.Flags["LoopAchievementsSpeed"].Value)
        end
    end)
end

--[[ CONQUISTAS TAB ]]--
local AchievementTab = Window:MakeTab({
    Name = "Conquistas",
    Icon = "rbxassetid://7733692043",
    PremiumOnly = false
})

AchievementTab:AddToggle({
    Name = "Conquistas em Loop",
    Default = false,
    Flag = "LoopAchievements",
    Callback = function(Value)
        if Value then
            LoopAchievements()
        end
    end
})

AchievementTab:AddSlider({
    Name = "Loop Speed",
    Min = 0.05,
    Max = 1,
    Default = 0.1,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 0.01,
    Flag = "LoopAchievementsSpeed",
    Callback = function(Value)
    end
})

--// ADDONS \\--
task.spawn(function()

    local AddonTab = Window:MakeTab({Name = "Addons [BETA]", Icon = "rbxassetid://4483345998", PremiumOnly = false})

    if not isfolder(".msdoors/addons") then
        makefolder(".msdoors/addons")
    end

    local function AddAddonElement(Element)
        if not Element or typeof(Element) ~= "table" then return end

        if Element.Type == "Label" then
            AddonTab:AddLabel(Element.Arguments[1])
        elseif Element.Type == "Toggle" then
            AddonTab:AddToggle({
                Name = Element.Name,
                Default = Element.Arguments.Default or false,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "Button" then
            AddonTab:AddButton({
                Name = Element.Arguments.Name,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "Slider" then
            AddonTab:AddSlider({
                Name = Element.Name,
                Min = Element.Arguments.Min,
                Max = Element.Arguments.Max,
                Default = Element.Arguments.Default,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "Input" then
            AddonTab:AddTextbox({
                Name = Element.Name,
                Default = Element.Arguments.Default,
                TextDisappear = true,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "Dropdown" then
            AddonTab:AddDropdown({
                Name = Element.Name,
                Options = Element.Arguments.Options,
                Default = Element.Arguments.Default,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "ColorPicker" then
            AddonTab:AddColorPicker({
                Name = Element.Name,
                Default = Element.Arguments.Default,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "KeyPicker" then
            AddonTab:AddKeybind({
                Name = Element.Name,
                Default = Element.Arguments.Default,
                Callback = Element.Arguments.Callback
            })
        else
            warn("[MsDoors Addons] Elemento '" .. tostring(Element.Name) .. "' não foi carregado: Tipo de elemento inválido.")
        end
    end


    local containAddonsLoaded = false

    for _, file in pairs(listfiles(".msdoors/addons")) do
        print("[MsDoors Addons] Carregando addon '" .. string.gsub(file, ".msdoors/addons/", "") .. "'...")
        if file:sub(-4) ~= ".lua" then continue end

        local success, errorMessage = pcall(function()
            local fileContent = readfile(file)
            local addon = loadstring(fileContent)()

            if typeof(addon.Name) ~= "string" or typeof(addon.Elements) ~= "table" then
                warn("[MsDoors Addons] Addon '" .. string.gsub(file, ".msdoors/addons/", "") .. "' não carregado: Nome/Elementos inválidos.")
                return 
            end

            containAddonsLoaded = true

            AddonTab:AddLabel("Addon: " .. addon.Name)
            AddonTab:AddParagraph("Descrição", addon.Description or "Sem descrição.")

            for _, element in pairs(addon.Elements) do
                AddAddonElement(element)
            end
        end)

        if not success then
            warn("[MsDoors Addons] Falha ao carregar addon '" .. string.gsub(file, ".msdoors/addons/", "") .. "':", errorMessage)
        end
    end
    

    if not containAddonsLoaded then
        AddonTab:AddLabel("A pasta de addons está vazia. Adicione addons na pasta '.msdoors/addons' e reinicie o script.")
    end
end)



local CreditsTab = Window:MakeTab({
    Name = "Creditos",
    Icon = "rbxassetid://14255000409",
    PremiumOnly = false
})
local CdSc = CreditsTab:AddSection({
    Name = "Créditos"
})

CdSc:AddParagraph("Rhyan57", "Criador do Msdoors")
CdSc:AddParagraph("SeekAlegriaFla", "Mentor e criador de Conteúdo do script")
OrionLib:Init()

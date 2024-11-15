--//BACKUP SALVO\\--
local OrionLib = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Giangplay/Script/main/Orion_Library_PE_V2.lua'))()
local Window = OrionLib:MakeWindow({IntroText = "Msdoors | V1",Icon = "rbxassetid://133997875469993", IntroIcon = "rbxassetid://133997875469993", Name = "MsDoors | Lobby", HidePremium = false, SaveConfig = true, ConfigFolder = ".msdoors/places/lobby"})

--[[ APIS ]]--
local MsdoorsNotify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Notification-doorsAPI/refs/heads/main/Msdoors/MsdoorsApi.lua"))()

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://4590656842"
sound.Volume = 2
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
MsdoorsNotify("Msdoors", "Script Inicializado.", "Execução", "rbxassetid://6023426923", Color3.new(128, 0, 128), 5)


MsdoorsNotify("Atualização","Você está usando uma versão desatualizada do Msdoors!","Nova versão disponível no github","rbxassetid://133997875469993", Color3.new(255, 0, 0), 15)

local Oldversion = Window:MakeTab({
    Name = "Atualizar Script",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Oldversion:AddButton({
    Name = "Atualizar",
    Callback = function()
        OrionLib:Destroy() loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Msdoors/refs/heads/main/download/main.lua"))()
    end
})
--//Serviços\\--
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")
local RunService = game:GetService("RunService")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local remotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")
local createElevator = remotesFolder:WaitForChild("CreateElevator")
local createElevator = game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("CreateElevator")
local createElevatorFrame = game:GetService("Players").LocalPlayer.PlayerGui.MainUI.LobbyFrame.CreateElevator
local presetName, destination, maxPlayers, friendsOnly = "", "", 4, true
local data = {}
local lobbyElevators = Workspace:WaitForChild("Lobby"):WaitForChild("LobbyElevators")
-- Serviços
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer
--//New System Sniper\\--
--[[Variáveis]]--
local Toggles = {}
local Options = {}
local playerList = {}

local function updatePlayerList()
    playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerList, player.Name)
        end
    end
    Options.ElevatorSniperTarget:Refresh(playerList)
end

local MainTab = Window:MakeTab({
    Name = "Elevator Sniper",
    Icon = "rbxassetid://7734021047",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "Elevator Sniper",
    Default = false,
    Callback = function(Value)
        Toggles.ElevatorSniper = Value
    end    
})

Options.ElevatorSniperTarget = MainTab:AddDropdown({
    Name = "Selecione o Jogador",
    Options = playerList,
    Callback = function(Value)
        Options.SelectedTarget = Value
    end
})

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

RunService.RenderStepped:Connect(function()
    if Toggles.ElevatorSniper and Options.SelectedTarget then
        local targetCharacter = Workspace:FindFirstChild(Options.SelectedTarget)
        if not targetCharacter then return end

        local targetElevatorID = targetCharacter:GetAttribute("InGameElevator")
        local currentElevatorID = localPlayer.Character:GetAttribute("InGameElevator")
        if currentElevatorID == targetElevatorID then return end

        if targetElevatorID then
            local targetElevator = lobbyElevators:FindFirstChild("LobbyElevator-" .. targetElevatorID)
            if targetElevator then
                remotesFolder.ElevatorJoin:FireServer(targetElevator)
            end
        elseif currentElevatorID then
            remotesFolder.ElevatorExit:FireServer()
        end
    end
end)

updatePlayerList()

--//New System Presets\\--
local PresetManager = {}
PresetManager.PresetData = {}
PresetManager.PresetList = {}

function PresetManager:BuildPresetStructure()
    if not isfolder(".msdoors/places/presets/") then
        makefolder(".msdoors/places/presets/")
    end
end

function PresetManager:CreatePreset(name, data)
    if isfile(".msdoors/places/presets/" .. name .. ".json") then
        return false, "Preset já existe!"
    end

    local presetData = {
        Floor = data.Floor or "Hotel",
        MaxPlayers = data.MaxPlayers or 1,
        Modifiers = data.Modifiers or {},
        FriendsOnly = data.FriendsOnly or true
    }
    
    self:BuildPresetStructure()
    writefile(".msdoors/places/presets/" .. name .. ".json", HttpService:JSONEncode(presetData))
    return true, "Preset criado com sucesso!"
end

function PresetManager:LoadPresets()
    self.PresetList = {}
    self.PresetData = {}

    for _, file in pairs(listfiles(".msdoors/places/presets/")) do
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(file))
        end)

        if success then
            local name = self:GetFileNameFromPath(file)
            self.PresetData[name] = data
            table.insert(self.PresetList, name)
        else
            warn("Failed to load preset: " .. file)
        end
    end

    return self.PresetList
end

function PresetManager:GetFileNameFromPath(path)
    local fileExtension = ".json"
    path = path:gsub("\\", "/")
    local pos = path:find("/[^/]*$")
    
    if pos then
        return path:sub(pos + 1, -#fileExtension - 1)
    end
end
function PresetManager:LoadPreset(name)
    local presetData = self.PresetData[name]
    if not presetData then
        return false, "Preset não encontrado!"
    end
    
    local data = {
        ["FriendsOnly"] = presetData.FriendsOnly,
        ["Destination"] = presetData.Floor,
        ["Mods"] = presetData.Modifiers or {},  -- Modificadores
        ["MaxPlayers"] = tostring(presetData.MaxPlayers)  -- Certifique-se que é uma string
    }


    print("Carregando preset:", HttpService:JSONEncode(data))

    local success, err = pcall(function()
        createElevator:FireServer(data)
    end)

    if success then
        return true, "Preset carregado: " .. name
    else
        return false, "Erro ao carregar preset: " .. err
    end
end

function PresetManager:DeletePreset(name)
    if isfile(".msdoors/places/presets/" .. name .. ".json") then
        delfile(".msdoors/places/presets/" .. name .. ".json")
        self.PresetData[name] = nil
        return true, "Preset deletado: " .. name
    else
        return false, "Preset não encontrado!"
    end
end

function PresetManager:OverridePreset(name, data)
    local presetData = {
        Floor = data.Floor or "Hotel",
        MaxPlayers = data.MaxPlayers or 1,
        Modifiers = data.Modifiers or {},
        FriendsOnly = data.FriendsOnly or true
    }

    writefile(".msdoors/places/presets/" .. name .. ".json", HttpService:JSONEncode(presetData))
    return true, "Preset sobrescrito: " .. name
end

local PresetTab = Window:MakeTab({
    Name = "Presets",
    Icon = "rbxassetid://7743872758",
    PremiumOnly = false
})

PresetTab:AddTextbox({
    Name = "Nome do Preset",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        _G.PresetName = value
    end
})

PresetTab:AddButton({
    Name = "Criar Preset",
    Callback = function()
        if _G.PresetName then
            local success, message = PresetManager:CreatePreset(_G.PresetName, {
                Floor = "Hotel",
                MaxPlayers = 4,
                FriendsOnly = true,
                Modifiers = {""}
            })
                
            OrionLib:MakeNotification({
                Name = success and "Sucesso" or "Erro",
                Content = message,
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            local newOptions = PresetManager:LoadPresets()
            Tab:SetDropdown("Selecione um Preset", newOptions)
        end
    end
})

local PresetDropdown = PresetTab:AddDropdown({
    Name = "Selecione um Preset",
    Default = "",
    Options = PresetManager:LoadPresets(),
    Callback = function(selectedPreset)
        _G.SelectedPreset = selectedPreset
    end
})

PresetTab:AddButton({
    Name = "Carregar Preset",
    Callback = function()
        if _G.SelectedPreset then
            local success, message = PresetManager:LoadPreset(_G.SelectedPreset)
            OrionLib:MakeNotification({
                Name = success and "Sucesso" or "Erro",
                Content = message,
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

PresetTab:AddButton({
    Name = "Deletar Preset",
    Callback = function()
        if _G.SelectedPreset then
            local success, message = PresetManager:DeletePreset(_G.SelectedPreset)
            OrionLib:MakeNotification({
                Name = success and "Sucesso" or "Erro",
                Content = message,
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            local newOptions = PresetManager:LoadPresets()
            PresetDropdown:SetOptions(newOptions)
        end
    end
})

PresetTab:AddButton({
    Name = "Sobrescrever Preset",
    Callback = function()
        if _G.SelectedPreset then
            local success, message = PresetManager:OverridePreset(_G.SelectedPreset, {
                Floor = "Hotel",
                MaxPlayers = 5,
                FriendsOnly = false,
                Modifiers = {"HardMode"}
            })
            OrionLib:MakeNotification({
                Name = success and "Sucesso" or "Erro",
                Content = message,
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

PresetTab:AddButton({
    Name = "Atualizar Presets",
    Callback = function()
        local newOptions = PresetManager:LoadPresets()
        PresetDropdown:SetOptions(newOptions)
        OrionLib:MakeNotification({
            Name = "Atualizado",
            Content = "Lista de presets atualizada!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})


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
--// Elevadores Pages \\--
local function CreateRetroModeElevator()
    data = {
        ["FriendsOnly"] = friendsOnly,
        ["Destination"] = destination,
        ["Mods"] = {"RetroMode"},
        ["MaxPlayers"] = tostring(maxPlayers)
    }

    local success, err = pcall(function()
        createElevator:FireServer(data)
    end)

    if success then
        OrionLib:MakeNotification({
            Name = "Sucesso",
            Content = "Elevador Retro criado com sucesso!",
            Time = 5
        })
    else
        OrionLib:MakeNotification({
            Name = "Erro",
            Content = "Falha ao criar o Elevador Retro: " .. err,
            Time = 5
        })
    end
end

local function CreateElevator()
    data = {
        ["FriendsOnly"] = friendsOnly,
        ["Destination"] = destination,
        ["Mods"] = {},
        ["MaxPlayers"] = tostring(maxPlayers)
    }

    local success, err = pcall(function()
        createElevator:FireServer(data)
    end)

    if success then
        OrionLib:MakeNotification({
            Name = "Sucesso",
            Content = "Elevador criado com sucesso!",
            Time = 5
        })
    else
        OrionLib:MakeNotification({
            Name = "Erro",
            Content = "Falha ao criar o elevador: " .. err,
            Time = 5
        })
    end
end


local function SetupElevatorUI()

local MSoldLobby = Window:MakeTab({
	Name = "Funções",
	Icon = "rbxassetid://7733924046",
	PremiumOnly = false
})

MSoldLobby:AddButton({
	Name = "Teleport to PRE HOTEL LOBBY",
	Callback = function()
		game:GetService("TeleportService"):Teleport(110258689672367)
	end    
})


    local MainTab = Window:MakeTab({
        Name = "Elevadores",
        Icon = "rbxassetid://7743875759",
        PremiumOnly = false
    })

    MainTab:AddParagraph("Elevator Controls", "Gerencie e crie elevadores com as configurações desejadas.")

    -- Input para o nome do preset
    MainTab:AddTextbox({
        Name = "Nome do Preset",
        Default = "",
        TextDisappear = true,
        Callback = function(Value)
            presetName = Value
        end
    })

    MainTab:AddButton({
        Name = "Criar Elevador Retro",
        Callback = function()
            CreateRetroModeElevator()
        end
    })

    MainTab:AddButton({
        Name = "Criar Elevador",
        Callback = function()
            CreateElevator()
        end
    })

    MainTab:AddDropdown({
        Name = "Destino do Elevador",
        Default = "Hotel",
        Options = {"Hotel","RetroMode", "Backdoor"},
        Callback = function(Value)
            destination = Value
        end
    })

    MainTab:AddSlider({
        Name = "Número Máximo de Jogadores",
        Min = 1,
        Max = 12,
        Default = 4,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Jogadores",
        Callback = function(Value)
            maxPlayers = Value
        end    
    })

    MainTab:AddToggle({
        Name = "Somente Amigos",
        Default = true,
        Callback = function(Value)
            friendsOnly = Value
        end
    })

    MainTab:AddToggle({
        Name = "Modo Hard",
        Default = false,
        Callback = function(Value)
            if Value then
                table.insert(data.Mods, "HardMode")
            end
        end
    })
end

SetupElevatorUI()

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
	warn("[MsDoors Addons] A pasta de addons está vazia. Adcione addons na pasta .msdoors/addons e execute novamente.")
	MsdoorsNotify("Msdoors", "A pasta de addons está vazia.", "Addons", "rbxassetid://6023426923", Color3.new(128, 0, 128), 6)
        		
    end
end)

-- Notificação de carregamento completo
OrionLib:MakeNotification({
    Name = "Sistema Carregado",
    Content = "Gerenciador de Elevadores pronto!",
    Time = 5
})

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


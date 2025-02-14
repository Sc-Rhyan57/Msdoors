print("Não mano esse não é o mspaint, esse é o msdoors feito por rhyan57!")
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
--[[ LIBRARY & API]]--


if _G.ObsidianaLib then
    warn("[Msdoors] • Script já carregado!")
    return
end
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/MSESP/refs/heads/main/source.lua"))()
local MsdoorsNotify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Notification-doorsAPI/refs/heads/main/Msdoors/MsdoorsApi.lua"))()

print("[Msdoors] • [✅] Inialização da livraria e apis")
_G.ObsidianaLib = true
--[[ VARIAVEIS GLOBAIS ]]--
_G.msdoors_antia90 = _G.msdoors_antia90 or false
_G.msdoors_antiscreech = _G.msdoors_antiscreech or false
_G.msdoors_antidread = _G.msdoors_antidread or false
_G.msdoors_CurrentlyUsingSGF = false
_G.msdoors_SpeedBypassBeTurned = nil
_G.msdoors_SpeedHackBeTurned = nil
_G.MaxActivationDistance = _G.MaxActivationDistance or 7
_G.PromptClip = _G.PromptClip or false
getgenv().AntiSeekManager = {
    IsEnabled = false
}

--[[ SERVIÇOS ]]--
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Script = { IsFools = false }
local CanJumpEnabled = false

print("[Msdoors] • [✅] Inicialização de Serviços")


local Window = Library:CreateWindow({
    Title = "Msdoors v1",
    Footer = "Build: 0.1.3 | by rhyan57",
    Icon = "95869322194132",
    NotifySide = "Right",
    ShowCustomCursor = true
})

local Tabs = {
    Main = Window:AddTab("Principal", "house"),
    Hotel = Window:AddTab("Hotel", "hotel"),
    Visual = Window:AddTab("Visual", "view"),
    Exploits = Window:AddTab("Exploits", "bomb"),
    Credits = Window:AddTab("Créditos", "axe"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}
local GroupCredits = Tabs.Credits:AddLeftGroupbox("Créditos")

local GroupPlayer = Tabs.Main:AddLeftGroupbox("Player")
local GroupReach = Tabs.Main:AddLeftGroupbox("Alcance")

GroupPlayer:AddLabel('<font color="#00FF56">Funções do jogador</font>')
local GroupAuto = Tabs.Main:AddRightGroupbox("Automoção")

local GroupEsp = Tabs.Visual:AddLeftGroupbox("Esp")
local GroupNotification = Tabs.Visual:AddRightGroupbox("Notifications")
local GroupVPlayer = Tabs.Visual:AddRightGroupbox("Player")

local GroupTroll = Tabs.Exploits:AddLeftGroupbox("Troll")
GroupTroll:AddLabel('<font color="#FF0000">Funções para troll</font>')

local GroupAntiEntity = Tabs.Exploits:AddLeftGroupbox("Anti Entity")
GroupAntiEntity:AddLabel('<font color="#FF0000">remover entidades</font>')

local GroupHotel = Tabs.Hotel:AddLeftGroupbox("Hotel Functions")
GroupHotel:AddLabel('<font color="#00FF56">Funções do floor atual</font>')

local DoorESPConfig = {
    Types = {
        Door = {
            Name = "Porta",
            Color = Color3.fromRGB(241, 196, 15)
        }
    },
    Settings = {
        MaxDistance = 5000,
        UpdateInterval = 5,
        TextSize = 16,
        FillTransparency = 0.75,
        OutlineTransparency = 0,
        TracerStartPosition = "Bottom",
        ArrowCenterOffset = 300
    }
}

local DoorESPManager = {
    ActiveESPs = {},
    IsEnabled = false,
    IsChecking = false,
    CurrentRoom = nil
}

function DoorESPManager:CreateESP(door, config)
    local room = door.Parent.Parent
    local doorNumber = tonumber(room.Name) + 1
    local opened = room.Door:GetAttribute("Opened")
    local locked = room:GetAttribute("RequiresKey")
    
    local doorState = opened and "[Aberta]" or (locked and "[Trancada]" or "")
    local displayName = string.format("%s %d %s", config.Name, doorNumber, doorState)
    
    local espInstance = ESPLibrary.ESP.Highlight({
        Name = displayName,
        Model = door,
        MaxDistance = DoorESPConfig.Settings.MaxDistance,
        
        FillColor = config.Color,
        OutlineColor = config.Color,
        TextColor = config.Color,
        TextSize = DoorESPConfig.Settings.TextSize,
        
        FillTransparency = DoorESPConfig.Settings.FillTransparency,
        OutlineTransparency = DoorESPConfig.Settings.OutlineTransparency,
        
        Tracer = {
            Enabled = true,
            From = DoorESPConfig.Settings.TracerStartPosition,
            Color = config.Color
        },
        
        Arrow = {
            Enabled = true,
            CenterOffset = DoorESPConfig.Settings.ArrowCenterOffset,
            Color = config.Color
        }
    })
    
    return espInstance, displayName
end

function DoorESPManager:AddESP(door)
    if not door or self.ActiveESPs[door] then return end
    
    local config = DoorESPConfig.Types[door.Name]
    if not config then return end
    
    local espInstance, displayName = self:CreateESP(door, table.clone(config))
    if espInstance then
        local room = door.Parent.Parent
        local doorUpdateConnection
        doorUpdateConnection = room.Door:GetAttributeChangedSignal("Opened"):Connect(function()
            if self.ActiveESPs[door] then
                self:RemoveESP(door)
                self:AddESP(door)
            else
                doorUpdateConnection:Disconnect()
            end
        end)
        
        self.ActiveESPs[door] = espInstance
    end
end

function DoorESPManager:RemoveESP(door)
    if self.ActiveESPs[door] then
        self.ActiveESPs[door].Destroy()
        self.ActiveESPs[door] = nil
    end
end

function DoorESPManager:ScanRoom()
    if not self.IsEnabled then return end
    
    local currentRoom = workspace.CurrentRooms:FindFirstChild(game.Players.LocalPlayer:GetAttribute("CurrentRoom"))
    if not currentRoom then return end
    
    if self.CurrentRoom ~= currentRoom then
        self:ClearESPs()
        self.CurrentRoom = currentRoom
    end
    
    for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
        local door = room:FindFirstChild("Door")
        if door and door:FindFirstChild("Door") then
            self:AddESP(door.Door)
        end
    end
end

function DoorESPManager:ClearESPs()
    for door, esp in pairs(self.ActiveESPs) do
        esp.Destroy()
    end
    self.ActiveESPs = {}
end

function DoorESPManager:StartScanning()
    if self.IsChecking then return end
    self.IsChecking = true
    
    spawn(function()
        while self.IsChecking do
            self:ScanRoom()
            wait(DoorESPConfig.Settings.UpdateInterval)
        end
    end)
end

function DoorESPManager:StopScanning()
    self.IsChecking = false
    self:ClearESPs()
end

local EntityESPConfig = {
    Types = {
        RushMoving = {
            Name = "Rush",
            Color = Color3.fromRGB(255, 0, 0)
        },
        AmbushMoving = {
            Name = "Ambush", 
            Color = Color3.fromRGB(0, 255, 0)
        },
        Snare = {
            Name = "Armadilha",
            Color = Color3.fromRGB(255, 0, 0)
        },
        FigureRig = {
            Name = "Figure",
            Color = Color3.fromRGB(255, 0, 0)
        },
        A60 = {
            Name = "A-60",
            Color = Color3.fromRGB(255, 0, 0)
        },
        A120 = {
            Name = "A-120",
            Color = Color3.fromRGB(255, 0, 0)
        },
        GiggleCeiling = {
            Name = "Giggle",
            Color = Color3.fromRGB(255, 0, 0)
        },
        GrumbleRig = {
            Name = "Grumbo",
            Color = Color3.fromRGB(255, 0, 0)
        },
        BackdoorRush = {
            Name = "Blitz",
            Color = Color3.fromRGB(255, 0, 0)
        },
        Entity10 = {
            Name = "Entidade 10",
            Color = Color3.fromRGB(128, 128, 0)
        }
    },
    Settings = {
        MaxDistance = 5000,
        UpdateInterval = 5,
        TextSize = 16,
        FillTransparency = 0.75,
        OutlineTransparency = 0,
        TracerStartPosition = "Bottom",
        ArrowCenterOffset = 300
    }
}

local EntityESPManager = {
    ActiveESPs = {},
    IsEnabled = false,
    IsChecking = false,
    CurrentRoom = nil
}

function EntityESPManager:CreateESP(entity, config)
    if not entity or not entity.PrimaryPart then return nil end
    
    local espInstance = ESPLibrary.ESP.Highlight({
        Name = config.Name,
        Model = entity,
        MaxDistance = EntityESPConfig.Settings.MaxDistance,
        
        FillColor = config.Color,
        OutlineColor = config.Color,
        TextColor = config.Color,
        TextSize = EntityESPConfig.Settings.TextSize,
        
        FillTransparency = EntityESPConfig.Settings.FillTransparency,
        OutlineTransparency = EntityESPConfig.Settings.OutlineTransparency,
        
        Tracer = {
            Enabled = true,
            From = EntityESPConfig.Settings.TracerStartPosition,
            Color = config.Color
        },
        
        Arrow = {
            Enabled = true,
            CenterOffset = EntityESPConfig.Settings.ArrowCenterOffset,
            Color = config.Color
        }
    })
    
    return espInstance
end

function EntityESPManager:AddESP(entity)
    if not entity or self.ActiveESPs[entity] then return end
    
    local config = EntityESPConfig.Types[entity.Name]
    if not config then return end
    
    local espInstance = self:CreateESP(entity, table.clone(config))
    if espInstance then
        self.ActiveESPs[entity] = espInstance
    end
end

function EntityESPManager:RemoveESP(entity)
    if self.ActiveESPs[entity] then
        self.ActiveESPs[entity].Destroy()
        self.ActiveESPs[entity] = nil
    end
end

function EntityESPManager:ScanRoom()
    if not self.IsEnabled then return end
    
    local currentRoom = workspace.CurrentRooms:FindFirstChild(game.Players.LocalPlayer:GetAttribute("CurrentRoom"))
    if not currentRoom then return end
    
    if self.CurrentRoom ~= currentRoom then
        self:ClearESPs()
        self.CurrentRoom = currentRoom
    end
    
    for _, descendant in pairs(workspace:GetDescendants()) do
        if EntityESPConfig.Types[descendant.Name] then
            self:AddESP(descendant)
        end
    end
end

function EntityESPManager:ClearESPs()
    for entity, esp in pairs(self.ActiveESPs) do
        esp.Destroy()
    end
    self.ActiveESPs = {}
end

function EntityESPManager:StartScanning()
    if self.IsChecking then return end
    self.IsChecking = true
    
    spawn(function()
        while self.IsChecking do
            self:ScanRoom()
            wait(EntityESPConfig.Settings.UpdateInterval)
        end
    end)
end

function EntityESPManager:StopScanning()
    self.IsChecking = false
    self:ClearESPs()
end


local ObjectiveESPConfig = {
    Types = {
        KeyObtain = {
            Name = "Chave",
            Color = Color3.fromRGB(0, 255, 0)
        },
        LeverForGate = {
            Name = "Alavanca",
            Color = Color3.fromRGB(0, 255, 0)
        },
        ElectricalKeyObtain = {
            Name = "Chave elétrica",
            Color = Color3.fromRGB(0, 255, 0)
        },
        LiveHintBook = {
            Name = "Livro",
            Color = Color3.fromRGB(0, 255, 0)
        },
        LiveBreakerPolePickup = {
            Name = "Disjuntor",
            Color = Color3.fromRGB(0, 255, 0)
        },
        MinesGenerator = {
            Name = "Gerador",
            Color = Color3.fromRGB(0, 255, 0)
        },
        MinesGateButton = {
            Name = "Botão do portão",
            Color = Color3.fromRGB(0, 255, 0)
        },
        FuseObtain = {
            Name = "Fusível",
            Color = Color3.fromRGB(0, 255, 0)
        },
        MinesAnchor = {
            Name = "Torre",
            Color = Color3.fromRGB(0, 255, 0)
        },
        WaterPump = {
            Name = "Bomba de água",
            Color = Color3.fromRGB(0, 255, 0)
        }
    },
    Settings = {
        MaxDistance = 5000,
        UpdateInterval = 5,
        TextSize = 16,
        FillTransparency = 0.75,
        OutlineTransparency = 0,
        TracerStartPosition = "Bottom",
        ArrowCenterOffset = 300
    }
}

local ObjectiveESPManager = {
    ActiveESPs = {},
    IsEnabled = false,
    IsChecking = false,
    CurrentRoom = nil
}

function ObjectiveESPManager:CreateESP(object, config)
    if not object or not object.PrimaryPart then return nil end
    
    local espInstance = ESPLibrary.ESP.Highlight({
        Name = config.Name,
        Model = object,
        MaxDistance = ObjectiveESPConfig.Settings.MaxDistance,
        
        FillColor = config.Color,
        OutlineColor = config.Color,
        TextColor = config.Color,
        TextSize = ObjectiveESPConfig.Settings.TextSize,
        
        FillTransparency = ObjectiveESPConfig.Settings.FillTransparency,
        OutlineTransparency = ObjectiveESPConfig.Settings.OutlineTransparency,
        
        Tracer = {
            Enabled = true,
            From = ObjectiveESPConfig.Settings.TracerStartPosition,
            Color = config.Color
        },
        
        Arrow = {
            Enabled = true,
            CenterOffset = ObjectiveESPConfig.Settings.ArrowCenterOffset,
            Color = config.Color
        }
    })
    
    return espInstance
end

function ObjectiveESPManager:HandleSpecialCases(object, config)
    if object.Name == "MinesAnchor" then
        local sign = object:WaitForChild("Sign", 5)
        if sign and sign:FindFirstChild("TextLabel") then
            config.Name = string.format("Torre %s", sign.TextLabel.Text)
        end
    elseif object.Name == "WaterPump" then
        local wheel = object:WaitForChild("Wheel", 5)
        local onFrame = object:FindFirstChild("OnFrame", true)
        
        if not (wheel and onFrame and onFrame.Visible) then
            return nil
        end
        
        onFrame:GetPropertyChangedSignal("Visible"):Connect(function()
            self:RemoveESP(object)
        end)
    end
    
    return config
end

function ObjectiveESPManager:AddESP(object)
    if not object or self.ActiveESPs[object] then return end
    
    local config = ObjectiveESPConfig.Types[object.Name]
    if not config then return end
    
    config = self:HandleSpecialCases(object, table.clone(config))
    if not config then return end
    
    local espInstance = self:CreateESP(object, config)
    if espInstance then
        self.ActiveESPs[object] = espInstance
    end
end

function ObjectiveESPManager:RemoveESP(object)
    if self.ActiveESPs[object] then
        self.ActiveESPs[object].Destroy()
        self.ActiveESPs[object] = nil
    end
end

function ObjectiveESPManager:ScanRoom()
    if not self.IsEnabled then return end
    
    local currentRoom = workspace.CurrentRooms:FindFirstChild(game.Players.LocalPlayer:GetAttribute("CurrentRoom"))
    if not currentRoom then return end
    
    if self.CurrentRoom ~= currentRoom then
        self:ClearESPs()
        self.CurrentRoom = currentRoom
    end
    
    for _, asset in pairs(currentRoom:GetDescendants()) do
        if ObjectiveESPConfig.Types[asset.Name] then
            self:AddESP(asset)
        end
    end
end

function ObjectiveESPManager:ClearESPs()
    for object, esp in pairs(self.ActiveESPs) do
        esp.Destroy()
    end
    self.ActiveESPs = {}
end

function ObjectiveESPManager:StartScanning()
    if self.IsChecking then return end
    self.IsChecking = true
    
    spawn(function()
        while self.IsChecking do
            self:ScanRoom()
            wait(ObjectiveESPConfig.Settings.UpdateInterval)
        end
    end)
end

function ObjectiveESPManager:StopScanning()
    self.IsChecking = false
    self:ClearESPs()
end

GroupEsp:AddToggle("Visual-esp-objective", {
	Text = "Esp Objetivo",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(state)
        ObjectiveESPManager.IsEnabled = state
        
        if state then
            ObjectiveESPManager:StartScanning()
        else
            ObjectiveESPManager:StopScanning()
        end
	end,
})

game.Players.LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    if ObjectiveESPManager.IsEnabled then
        ObjectiveESPManager:ScanRoom()
    end
end)

GroupEsp:AddToggle("Visual-esp-entity", {
	Text = "Esp Entidades",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(state)
        ObjectiveESPManager.IsEnabled = state
        EntityESPManager.IsEnabled = state
        
        if state then
            EntityESPManager:StartScanning()
        else
            EntityESPManager:StopScanning()
			end
	end,
})

game.Players.LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    if EntityESPManager.IsEnabled then
        EntityESPManager:ScanRoom()
    end
end)
GroupEsp:AddToggle("Visual-esp-door", {
	Text = "Esp Portas",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(state)
        DoorESPManager.IsEnabled = state
        
        if state then
            DoorESPManager:StartScanning()
        else
            DoorESPManager:StopScanning()
	   end
	end,
})

game.Players.LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    if DoorESPManager.IsEnabled then
        DoorESPManager:ScanRoom()
    end
end)

GroupVPlayer:AddToggle("Visual-no-ambience", {
	Text = "No Ambience",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = true,
	Callback = function(Value)
        if not game.SoundService:FindFirstChild("AmbienceRemove") then
            local ambiencerem = Instance.new("BoolValue")
            ambiencerem.Name = "AmbienceRemove"
            ambiencerem.Parent = game.SoundService
        end
        if Value then
            workspace.Ambience_Dark.Volume = 0
            if workspace:FindFirstChild("AmbienceMines") then
                workspace.AmbienceMines.Volume = 0
            else
                workspace.Ambience_Hotel.Volume = 0
                workspace.Ambience_Hotel2.Volume = 0
                workspace.Ambience_Hotel3.Volume = 0
            end
            game.SoundService.AmbienceRemove.Value = true
            task.wait()
            repeat 
                if workspace.Terrain:FindFirstChildWhichIsA("Attachment") then 
                    workspace.Terrain:FindFirstChildWhichIsA("Attachment"):Destroy()
                end 
                task.wait(0.01) 
            until game.SoundService.AmbienceRemove.Value == false
        else
            workspace.Ambience_Dark.Volume = 0.6
            if workspace:FindFirstChild("AmbienceMines") then
                workspace.AmbienceMines.Volume = 0.4
            else
                workspace.Ambience_Hotel.Volume = 0.2
                workspace.Ambience_Hotel2.Volume = 0.3
                workspace.Ambience_Hotel3.Volume = 0.05
            end
            game.SoundService.AmbienceRemove.Value = false
        end

	end,
})

GroupVPlayer:AddToggle("Visual-No-Wardobre-Vignette", {
	Text = "No Wardrobe Vignette",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        local vignette = game:GetService("Players").LocalPlayer.PlayerGui.MainUI.MainFrame.HideVignette
        if Value then
            vignette.Size = UDim2.new(0,0,0,0)
        else
            vignette.Size = UDim2.new(1,0,1,0)
        end
	end,
})

local EntityTable = {
    ["Names"] = {"BackdoorRush", "BackdoorLookman", "RushMoving", "AmbushMoving", "Eyes", "JeffTheKiller", "A60", "A120"},
    ["NotifyReason"] = {
        ["A60"] = { ["Image"] = "12350986086", ["Title"] = "A-60", ["Description"] = "A-60 SPAWNOU!" },
        ["A120"] = { ["Image"] = "12351008553", ["Title"] = "A-120", ["Description"] = "A-120 SPAWNOU!" },
        ["HaltRoom"] = { ["Image"] = "11331795398", ["Title"] = "Halt", ["Description"] = "Prepare-se para Halt.",  ["Spawned"] = true },
        ["Window_BrokenSally"] = { ["Image"] = "100573561401335", ["Title"] = "Sally", ["Description"] = "Sally SPAWNOU!",  ["Spawned"] = true },
        ["BackdoorRush"] = { ["Image"] = "11102256553", ["Title"] = "Backdoor Blitz", ["Description"] = "Blitz SPAWNOU!" },
        ["RushMoving"] = { ["Image"] = "11102256553", ["Title"] = "Rush", ["Description"] = "Rush SPAWNOU!" },
        ["AmbushMoving"] = { ["Image"] = "10938726652", ["Title"] = "Ambush", ["Description"] = "Ambush SPAWNOU!" },
        ["Eyes"] = { ["Image"] = "10865377903", ["Title"] = "Eyes", ["Description"] = "Não olhe para os olhos!", ["Spawned"] = true },
        ["BackdoorLookman"] = { ["Image"] = "16764872677", ["Title"] = "Backdoor Lookman", ["Description"] = "Olhe para baixo!", ["Spawned"] = true },
        ["JeffTheKiller"] = { ["Image"] = "98993343", ["Title"] = "Jeff The Killer", ["Description"] = "Fuja do Jeff the Killer!" }
    }
}

local notificationsEnabled = false
local initialized = false

function MonitorEntities()
    game:GetService("RunService").Stepped:Connect(function()
        if notificationsEnabled then
            for _, entityName in ipairs(EntityTable.Names) do
                local entity = workspace:FindFirstChild(entityName)
                if entity and not entity:GetAttribute("Notified") then
                    entity:SetAttribute("Notified", true)
                    NotifyEntity(entityName)
                end
            end
        end
    end)
end

function NotifyEntity(entityName)
    local notificationData = EntityTable.NotifyReason[entityName]
    if notificationData then
        MsdoorsNotify(
            notificationData.Title,
            notificationData.Description,
            "",
            "rbxassetid://" .. notificationData.Image,
            Color3.fromRGB(255, 0, 0),
            5
        )
    end
end

MonitorEntities()

GroupNotification:AddToggle("Visual-Notifier-Entities", {
	Text = "Notificar Entidades",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(value)
        if not initialized then
            initialized = true
            return
        end
        notificationsEnabled = value
        MsdoorsNotify(
            "MsDoors",
            value and "Notificações de Entidades ativas!" or "Notificações de Entidades desativadas!",
            "",
            "rbxassetid://100573561401335",
            value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0),
            3
        )
	end,
})


local Toggles = {}
local InstaInteractEnabled = false

local function UpdateProximityPrompts()
    for _, prompt in pairs(workspace.CurrentRooms:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            if InstaInteractEnabled then
                if not prompt:GetAttribute("Hold") then 
                    prompt:SetAttribute("Hold", prompt.HoldDuration)
                end
                prompt.HoldDuration = 0
            else
                prompt.HoldDuration = prompt:GetAttribute("Hold") or 0
            end
        end
    end
end
workspace.CurrentRooms.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
        if InstaInteractEnabled then
            if not descendant:GetAttribute("Hold") then 
                descendant:SetAttribute("Hold", descendant.HoldDuration)
            end
            descendant.HoldDuration = 0
        end
    end
end)

GroupAuto:AddToggle("Main-Insta-Interact", {
	Text = "Instant Interaction",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(value)
        InstaInteractEnabled = value
        UpdateProximityPrompts()
	end,
})


shared = {
    Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait(),
    LocalPlayer = game.Players.LocalPlayer,
    Humanoid = nil,
}

local function InitializeScript()
    shared.Humanoid = shared.Character:WaitForChild("Humanoid")
    game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
        shared.Character = char
        shared.Humanoid = char:WaitForChild("Humanoid")
    end)
end

shared.fireproximityprompt = function(prompt)
    if prompt.ClassName == "ProximityPrompt" then
        fireproximityprompt(prompt)
    end
end

local Script = {
    PromptTable = {
        GamePrompts = {},
        Aura = {
            ["ActivateEventPrompt"] = false,
            ["AwesomePrompt"] = true,
            ["FusesPrompt"] = true,
            ["HerbPrompt"] = false,
            ["LeverPrompt"] = true,
            ["LootPrompt"] = false,
            ["ModulePrompt"] = true,
            ["SkullPrompt"] = false,
            ["UnlockPrompt"] = true,
            ["ValvePrompt"] = false,
            ["PropPrompt"] = true
        },
        AuraObjects = {
            "Lock",
            "Button"
        },
        Clip = {
            "AwesomePrompt",
            "FusesPrompt",
            "HerbPrompt",
            "HidePrompt",
            "LeverPrompt",
            "LootPrompt",
            "ModulePrompt",
            "Prompt",
            "PushPrompt",
            "SkullPrompt",
            "UnlockPrompt",
            "ValvePrompt"
        },
        ClipObjects = {
            "LeverForGate",
            "LiveBreakerPolePickup",
            "LiveHintBook",
            "Button",
        },
        Excluded = {
            Prompt = {
                "HintPrompt",
                "InteractPrompt"
            },
            Parent = {
                "KeyObtainFake",
                "Padlock"
            },
            ModelAncestor = {
                "DoorFake"
            }
        }
    },
    Temp = {
        PaintingDebounce = {}
    }
}

Script.Functions = {
    GetAllPromptsWithCondition = function(condition)
        local prompts = {}
        for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                if condition(v) then
                    table.insert(prompts, v)
                end
            end
        end
        return prompts
    end,

    DistanceFromCharacter = function(object)
        if not shared.Character or not shared.Character:FindFirstChild("HumanoidRootPart") or not object then
            return math.huge
        end
        local objectPosition = object:IsA("BasePart") and object.Position or 
                             object:FindFirstChild("HumanoidRootPart") and object.HumanoidRootPart.Position or
                             object:FindFirstChildWhichIsA("BasePart") and object:FindFirstChildWhichIsA("BasePart").Position
        if not objectPosition then
            return math.huge
        end
        return (shared.Character.HumanoidRootPart.Position - objectPosition).Magnitude
    end,
    
    IsExcluded = function(prompt)
        for _, excludedName in ipairs(Script.PromptTable.Excluded.Prompt) do
            if prompt.Name == excludedName then return true end
        end
        if prompt.Parent then
            for _, excludedParent in ipairs(Script.PromptTable.Excluded.Parent) do
                if prompt.Parent.Name == excludedParent then return true end
            end
        end
        local model = prompt:FindFirstAncestorWhichIsA("Model")
        if model then
            for _, excludedModel in ipairs(Script.PromptTable.Excluded.ModelAncestor) do
                if model.Name == excludedModel then return true end
            end
        end
        return false
    end
}

local AutoInteractEnabled = false
local IgnoreSettings = {
    ["Jeff Items"] = true,
    ["Unlock w/ Lockpick"] = false,
    ["Paintings"] = true,
    ["Gold"] = false,
    ["Light Source Items"] = false,
    ["Skull Prompt"] = false
}

GroupAuto:AddToggle("Auto-interact", {
	Text = "Auto Interact",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        AutoInteractEnabled = Value
	end,
})

--// Este sistema de auto interact é originalmente dá mspaint \\--
GroupAuto:AddDropdown("Auto-interact-drop", {
	Values = {"Jeff Items", "Unlock w/ Lockpick", "Paintings", "Gold", "Light Source Items", "Skull Prompt"},
	Default = 1,
	Multi = true,
	Text = "Ignore list",
	DisabledTooltip = "I am disabled!",
	Searchable = false,
	Callback = function(Value)
        for k, _ in pairs(IgnoreSettings) do
            IgnoreSettings[k] = false
        end
        for _, v in pairs(Value) do
            IgnoreSettings[v] = true
			end
	end,
	Disabled = false,
	Visible = true, 
})


local function AutoInteractLoop()
    while true do
        task.wait()
        if AutoInteractEnabled then
            local prompts = Script.Functions.GetAllPromptsWithCondition(function(prompt)
                if not prompt.Parent then return false end
                if IgnoreSettings["Jeff Items"] and prompt.Parent:GetAttribute("JeffShop") then return false end
                if IgnoreSettings["Unlock w/ Lockpick"] and (prompt.Name == "UnlockPrompt" or prompt.Parent:GetAttribute("Locked")) and shared.Character:FindFirstChild("Lockpick") then return false end
                if IgnoreSettings["Paintings"] and prompt.Name == "PropPrompt" then return false end
                if IgnoreSettings["Gold"] and prompt.Name == "LootPrompt" then return false end
                if IgnoreSettings["Light Source Items"] and prompt.Parent:GetAttribute("Tool_LightSource") and not prompt.Parent:GetAttribute("Tool_CanCutVines") then return false end
                if IgnoreSettings["Skull Prompt"] and prompt.Name == "SkullPrompt" then return false end
                if prompt.Parent:GetAttribute("PropType") == "Battery" and not (shared.Character:FindFirstChildOfClass("Tool") and (shared.Character:FindFirstChildOfClass("Tool"):GetAttribute("RechargeProp") == "Battery" or shared.Character:FindFirstChildOfClass("Tool"):GetAttribute("StorageProp") == "Battery")) then return false end 
                if prompt.Parent:GetAttribute("PropType") == "Heal" and shared.Humanoid and shared.Humanoid.Health == shared.Humanoid.MaxHealth then return false end
                if prompt.Parent.Name == "MinesAnchor" then return false end
                if Script.IsRetro and prompt.Parent.Parent.Name == "RetroWardrobe" then return false end
                return Script.PromptTable.Aura[prompt.Name] ~= nil
            end)

            for _, prompt in pairs(prompts) do
                task.spawn(function()
                    if Script.Functions.DistanceFromCharacter(prompt.Parent) < prompt.MaxActivationDistance and (not prompt:GetAttribute("Interactions" .. shared.LocalPlayer.Name) or Script.PromptTable.Aura[prompt.Name] or table.find(Script.PromptTable.AuraObjects, prompt.Parent.Name)) then
                        if prompt.Parent.Name == "Slot" and prompt.Parent:GetAttribute("Hint") then
                            if Script.Temp.PaintingDebounce[prompt] then return end
                            local currentPainting = shared.Character:FindFirstChild("Prop")
                            local slotPainting = prompt.Parent:FindFirstChild("Prop")
                            local currentHint = (currentPainting and currentPainting:GetAttribute("Hint"))
                            local slotHint = (slotPainting and slotPainting:GetAttribute("Hint"))
                            local promptHint = prompt.Parent:GetAttribute("Hint")
                            if slotHint ~= promptHint and (currentHint == promptHint or slotPainting) then
                                Script.Temp.PaintingDebounce[prompt] = true
                                shared.fireproximityprompt(prompt)
                                task.wait(0.3)
                                Script.Temp.PaintingDebounce[prompt] = false    
                            end
                            return
                        end
                        shared.fireproximityprompt(prompt)
                    end
                end)
            end
        end
    end
end
InitializeScript()
task.spawn(AutoInteractLoop)

GroupPlayer:AddToggle("EnableJump", {
    Text = "Habilitar Pulo",
    Default = false
}):OnChanged(function(value)
    local character = LocalPlayer.Character
    if character then
        character:SetAttribute("CanJump", value)
    end
end)

GroupPlayer:AddSlider("JumpBoost", {
    Text = "Impulso de Pulo",
    Default = 5,
    Min = 0,
    Max = 50,
    Rounding = 0,
    Compact = true
}):OnChanged(function(value)
    local character = LocalPlayer.Character
    if character and Toggles.EnableJump.Value then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpHeight = value
        end
    end
end)

GroupHotel:AddToggle("AntiSeekObstructions", {
    Text = "Anti-Seek Obstructions",
    Default = false,
    Callback = function(state)
        AntiSeekManager.IsEnabled = state
        AntiSeekManager:ScanNearbyRooms(state)
    end
})

function AntiSeekManager:ScanNearbyRooms(state)
    local player = game.Players.LocalPlayer
    local currentRoomNumber = player:GetAttribute("CurrentRoom")

    if not currentRoomNumber then return end

    for i = 0, 2 do
        local room = workspace.CurrentRooms:FindFirstChild(tostring(currentRoomNumber + i))
        if room then
            self:ToggleSeekObstacles(room, state)
        end
    end
end

function AntiSeekManager:ToggleSeekObstacles(room, state)
    for _, v in pairs(room:GetDescendants()) do
        if v.Name == "ChandelierObstruction" or v.Name == "Seek_Arm" then
            for _, obj in pairs(v:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.CanTouch = not state
                end
            end
        end
    end
end
game.Players.LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    if AntiSeekManager.IsEnabled then
        AntiSeekManager:ScanNearbyRooms(true)
    end
end)

--// ANTI ENTITY \\--
local function toggleA90(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    
    if not mainUI then
        return
    end

    local modules = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and 
                    mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener") and 
                    mainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")

    if not modules then
        return
    end

    local a90 = modules:FindFirstChild("A90") or modules:FindFirstChild("A90_MSDOORS_DISABLE")

    if not a90 then
        return
    end

    if enabled then
        if a90.Name == "A90" then
            a90.Name = "A90_MSDOORS_DISABLE"
        end
    else
        if a90.Name == "A90_MSDOORS_DISABLE" then
            a90.Name = "A90"
        end
    end
end

local function toggleScreech(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    
    if not mainUI then
        return
    end

    local modules = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and 
                    mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener") and 
                    mainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")

    if not modules then
        return
    end

    local screech = modules:FindFirstChild("Screech") or modules:FindFirstChild("Screech_MSDOORS_DISABLE")

    if not screech then
        warn("[Msdoors] • Screech não encontrado!")
        return
    end

    if enabled then
        if screech.Name == "Screech" then
            screech.Name = "Screech_MSDOORS_DISABLE"
        end
    else
        if screech.Name == "Screech_MSDOORS_DISABLE" then
            screech.Name = "Screech"
        end
    end
end

local function toggleDread(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    
    if not mainUI then
        return
    end

    local modules = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and 
                    mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener") and 
                    mainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")

    if not modules then
        return
    end

    local dread = modules:FindFirstChild("Dread") or modules:FindFirstChild("Dread_MSDOORS_DISABLE")

    if not dread then
        warn("[Msdoors] • Dread não encontrado!")
        return
    end

    if enabled then
        if dread.Name == "Dread" then
            dread.Name = "Dread_MSDOORS_DISABLE"
        end
    else
        if dread.Name == "Dread_MSDOORS_DISABLE" then
            dread.Name = "Dread"
        end
    end
end


GroupAntiEntity:AddToggle("Anti-A90", {
	Text = "Anti A90",
	DisabledTooltip = "I am disabled!",
	Default = _G.msdoors_antia90,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        _G.msdoors_antia90 = Value
        toggleA90(Value)
	end,
})

GroupAntiEntity:AddToggle("Anti-Dread", {
	Text = "Anti Dread",
	DisabledTooltip = "I am disabled!",
	Default = _G.msdoors_antidread,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        _G.msdoors_antidread = Value
        toggleDread(Value)
	end,
})

GroupAntiEntity:AddToggle("Anti-Screech", {
	Text = "Anti Screech",
	DisabledTooltip = "I am disabled!",
	Default = _G.msdoors_antiscreech,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        _G.msdoors_antiscreech = Value
        toggleScreech(Value)
	end,
})

GroupTroll:AddToggle("Troll-Stunned-animation", {
	Text = "Stunned",
	Tooltip = "Faz seu personagem ficar com uma animação de atordoação.",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        local lplr = game.Players.LocalPlayer
        if Value then
            lplr.Character:SetAttribute('Stunned', true)
            lplr.Character.Humanoid:SetAttribute('Stunned', true)
        else
            lplr.Character:SetAttribute('Stunned', false)
            lplr.Character.Humanoid:SetAttribute('Stunned', false)
        end
	end,
})

GroupTroll:AddToggle("Troll-Thoughts", {
	Text = "Thoughts",
	Tooltip = "Faz seu personagem ficar com uma animação de pensamento.",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        local lplr = game.Players.LocalPlayer
        local thinkanims = {"18885101321", "18885098453", "18885095182"}
        
        if Value then
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://" .. thinkanims[math.random(1, #thinkanims)]
            animtrack = lplr.Character:FindFirstChildWhichIsA("Humanoid"):LoadAnimation(animation)
            animtrack.Looped = true
            animtrack:Play()
        else
            if animtrack then
                animtrack:Stop()
                animtrack:Destroy()
            end
        end
	end,
})

local function UpdateProximityPrompts()
    for _, prompt in pairs(workspace.CurrentRooms:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.RequiresLineOfSight = not _G.PromptClip
        end
    end
end

workspace.CurrentRooms.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
        descendant.RequiresLineOfSight = not _G.PromptClip
    end
end)


GroupReach:AddToggle("Main-PromptClip", {
    Text = "Prompt Clip",
    Default = _G.PromptClip,
    Callback = function(value)
        _G.PromptClip = value
        UpdateProximityPrompts()
    end,
})

local function UpdateProximityPrompts()
    for _, prompt in pairs(workspace.CurrentRooms:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.MaxActivationDistance = _G.MaxActivationDistance
        end
    end
end

workspace.CurrentRooms.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
        descendant.MaxActivationDistance = _G.MaxActivationDistance
    end
end)

GroupReach:AddSlider("Main-MaxActivationDistance", {
    Text = "Prompt Reach Multiplier",
    Min = 7,
    Max = 10,
    Default = _G.MaxActivationDistance,
    Increment = 0.1,
    Callback = function(value)
        _G.MaxActivationDistance = value
        UpdateProximityPrompts()
    end,
})


GroupCredits:AddLabel('<font color="#00FFFF">Créditos</font>')
GroupCredits:AddLabel('• Rhyan57 - <font color="#FFA500">DONO</font>')
GroupCredits:AddLabel('• SeekAlegriaFla - <font color="#FFA500">SUB-DONO</font>')
GroupCredits:AddLabel('<font color="#00FFFF">Redes</font>')
GroupCredits:AddLabel('• Discord: <font color="#9DABFF">https://dsc.gg/msdoors-gg</font>')
GroupCredits:AddButton({
    Text = "Copiar Link",
    Func = function()
        local url = "https://dsc.gg/msdoors-gg"
        if syn then
            syn.request({
                Url = url,
                Method = "GET"
            })
        elseif setclipboard then
            setclipboard(url)
            Library:Notify({
		Title = "Link copiado!",
		Description = "Seu executor não suporta redirecionar. link copiado.",
		Time = 5,
	})

        else
                        Library:Notify({
		Title = "LOL",
		Description = "Seu executor não suporta redirecionar ou copiar links.",
		Time = 5,
	})

        end

    end,
    DoubleClick = false,
    Tooltip = "Fechar Janelas"
})


-- UI Settings
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Notify({
		Title = "Fechando...",
		Description = "Aguarde estamos cuidando de tudo!.",
		Time = 5,
	})
	task.wait(5)
	_G.MsdoorsLoaded = false
	_G.ObsidianaLib = false
	Library:Unload()
	print("[Msdoors] • Até outra hora 😉")
end)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("msdoors")
SaveManager:SetFolder("msdoors/Doors")
SaveManager:SetSubFolder("Hotel")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
_G.MsdoorsLoaded = true


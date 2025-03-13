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
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local floorName = _G.msdoors_floor
----------------------------
--[[ VARIAVEIS GLOBAIS ]]--
_G.msdoors_AntiFlood = false
_G.msdoors_AntiSeekDoor = false
_G.msdoors_anticutscenes = false
_G.msdoors_antijumpscares = false
_G.msdoors_antia90 = _G.msdoors_antia90 or false
_G.msdoors_antiscreech = _G.msdoors_antiscreech or false
_G.msdoors_antidread = _G.msdoors_antidread or false
_G.msdoors_CurrentlyUsingSGF = false
_G.msdoors_SpeedBypassBeTurned = nil
_G.msdoors_SpeedHackBeTurned = nil
_G.MaxActivationDistance = _G.MaxActivationDistance or 7
_G.PromptClip = _G.PromptClip or false
_G.msdoors_antieyes = _G.msdoors_antieyes or false
_G.msdoors_antilag = {
    Enabled = false,
    Connection = nil,
    StoredProperties = {}
}
getgenv().AntiSeekManager = {
    IsEnabled = false
}
_G.ObsidianaLib = true


local Window = Library:CreateWindow({
    Title = "Msdoors v1",
    Footer = "Build: 0.1.3 | Game: Doors",
    Icon = "95869322194132",
    NotifySide = "Right",
    ShowCustomCursor = true
})


local Tabs = {
    Main = Window:AddTab("Principal", "house"),
    Hotel = Window:AddTab("Hotel", "hotel"),
    Visual = Window:AddTab("Visuais", "view"),
    Exploits = Window:AddTab("Exploits", "bomb"),
    Credits = Window:AddTab("Créditos", "axe"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

--// CRÉDITS PAGE \\--
local GroupCredits = Tabs.Credits:AddLeftGroupbox("Créditos")

--// MAIN PAGE \\--
local GroupPlayer = Tabs.Main:AddLeftGroupbox("Player")
local GroupReach = Tabs.Main:AddLeftGroupbox("Alcance")
local GroupAuto = Tabs.Main:AddRightGroupbox("Automoção")
local GroupMisc = Tabs.Main:AddRightGroupbox("Diversos")

--// VISUAL PAGE \\--
local GroupEsp = Tabs.Visual:AddLeftGroupbox("Esp")
local GroupAmbient = Tabs.Visual:AddLeftGroupbox("Ambiente")
local GroupVPlayer = Tabs.Visual:AddRightGroupbox("Player")

local GroupNotification = Tabs.Visual:AddRightTabbox()
local GroupNot = GroupNotification:AddTab('Notificação')
local GroupNotC = GroupNotification:AddTab('Configurações')

local GroupSelf = Tabs.Visual:AddRightTabbox()
local SelfTab = GroupSelf:AddTab('Camera')
local SelfTabE = GroupSelf:AddTab('Efeitos')

--// EXPLOITS PAGE \\--
local GroupAntiEntity = Tabs.Exploits:AddLeftGroupbox("Anti Entity")
local GroupTroll = Tabs.Exploits:AddLeftGroupbox("Troll")
local GroupBypass = Tabs.Exploits:AddRightGroupbox("Byppas")

--// FLOOR PAGE \\--
if _G.msdoors_floor then
    if floorName == "Hotel" then
        print("[ Msdoors ] » Carregando funções da página Hotel para Doors principal.")
        local GroupModifiers = Tabs.Hotel:AddRightGroupbox("Modificadores")
	local GroupHotel = Tabs.Hotel:AddLeftGroupbox("Floor Functions")
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

        --[[ ANTI GIGGLE ]]--
GroupModifiers:AddToggle("Anti-Giggle", {
    Text = "Anti Giggle",
    Default = false,
    Callback = function(state)
        local connection
        if state then
            connection = workspace.CurrentRooms.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "GiggleCeiling" then
                    local hitbox = descendant:WaitForChild("Hitbox", 5)
                    if hitbox then
                        hitbox.CanTouch = false
                    end
                end
            end)
        elseif connection then
            connection:Disconnect()
        end
        
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            for _, giggle in pairs(room:GetDescendants()) do
                if giggle.Name == "GiggleCeiling" then
                    local hitbox = giggle:FindFirstChild("Hitbox")
                    if hitbox then
                        hitbox.CanTouch = not state
                    end
                end
            end
        end
    end
})
		
	--[[ ANTI A-90 ]]--
	local function toggleA90(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    
    if not mainUI then return end

    local modules = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and 
                    mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener") and 
                    mainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")

    if not modules then return end

    local a90 = modules:FindFirstChild("A90") or modules:FindFirstChild("A90_MSDOORS_DISABLE")
    if not a90 then return end

    a90.Name = enabled and "A90_MSDOORS_DISABLE" or "A90"
end

GroupModifiers:AddToggle("Anti-A90", {
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
    elseif floorName == "Super Hard Mode" then
	local GroupHotel = Tabs.Hotel:AddLeftGroupbox("Floor Functions")
        print("[ Msdoors ] » Carregando funções da página Hotel para Fools23.")
	--[[ ANTI BANANA ]]--
_G.msdoors_bananaOGproperties = {}

local function modifyBanana(child, enable)
    if enable then
        _G.msdoors_bananaOGproperties[child] = {
            Transparency = child.Transparency,
            Material = child.Material,
            CanTouch = child.CanTouch,
            CanCollide = child.CanCollide,
            CanQuery = child.CanQuery
        }

        child.Transparency = 0.7
        child.Material = Enum.Material.Neon
        child.CanTouch = false
        child.CanCollide = false
        child.CanQuery = false

        for _, descendant in ipairs(child:GetDescendants()) do
            if descendant:IsA("TouchTransmitter") or descendant:IsA("Constraint") then
                descendant:Destroy()
            elseif descendant:IsA("Script") or descendant:IsA("LocalScript") then
                descendant.Disabled = true
            end
        end
    else
        if _G.msdoors_bananaOGproperties[child] then
            child.Transparency = _G.msdoors_bananaOGproperties[child].Transparency
            child.Material = _G.msdoors_bananaOGproperties[child].Material
            child.CanTouch = _G.msdoors_bananaOGproperties[child].CanTouch
            child.CanCollide = _G.msdoors_bananaOGproperties[child].CanCollide
            child.CanQuery = _G.msdoors_bananaOGproperties[child].CanQuery
            _G.msdoors_bananaOGproperties[child] = nil -- Liberar memória
        end
    end
end

local function destroyAllBananaPeel()
    for _, child in ipairs(workspace:GetChildren()) do
        if child.Name == "BananaPeel" then
            modifyBanana(child, _G.msdoors_AntiBanana)
        end
    end
end

workspace.ChildAdded:Connect(function(child)
    if _G.msdoors_AntiBanana and child.Name == "BananaPeel" then
        task.wait(0.1)
        destroyAllBananaPeel()
    end
end)

GroupHotel:AddToggle("AntiBanana", {
    Text = "Anti Banana",
    DisabledTooltip = "I am disabled!",
    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,
    Callback = function(value)
        _G.msdoors_AntiBanana = value
        destroyAllBananaPeel()
    end
})
		
    elseif floorName == "Retro Mode" then
        print("[ Msdoors ] » Carregando funções da página Hotel para Fools24.")
        
    elseif floorName == "Backdoor" then
        print("[ Msdoors ] » Carregando funções da página Hotel para The Backdoors.")

    elseif floorName == "Mines" then
        print("[ Msdoors ] » Carregando funções da página Hotel para The Mines.")
        local GroupModifiers = Tabs.Hotel:AddRightGroupbox("Modificadores")
	local GroupHotel = Tabs.Hotel:AddLeftGroupbox("Floor Functions")

	--[[ ANTI A-90 ]]--
	local function toggleA90(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    
    if not mainUI then return end

    local modules = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and 
                    mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener") and 
                    mainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")

    if not modules then return end

    local a90 = modules:FindFirstChild("A90") or modules:FindFirstChild("A90_MSDOORS_DISABLE")
    if not a90 then return end

    a90.Name = enabled and "A90_MSDOORS_DISABLE" or "A90"
end

GroupModifiers:AddToggle("Anti-A90", {
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


local ProcessedGloomEggs = {}
local GloomEggConnection = nil

GroupHotel:AddToggle("AntiGloomEgg", {
    Text = "Anti Gloom Egg",
    Default = false,
    Callback = function(value)
        local function processGloomEgg(gloomEgg)
            if value then
                if not ProcessedGloomEggs[gloomEgg] then
                    ProcessedGloomEggs[gloomEgg] = gloomEgg.CanTouch
                end
                gloomEgg.CanTouch = false
            else
                if ProcessedGloomEggs[gloomEgg] ~= nil then
                    gloomEgg.CanTouch = ProcessedGloomEggs[gloomEgg]
                    ProcessedGloomEggs[gloomEgg] = nil
                end
            end
        end
        
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            for _, gloomPile in pairs(room:GetChildren()) do
                if gloomPile.Name == "GloomPile" then
                    for _, gloomEgg in pairs(gloomPile:GetDescendants()) do
                        if gloomEgg.Name == "Egg" then
                            processGloomEgg(gloomEgg)
                        end
                    end
                end
            end
        end
        
        if value and not GloomEggConnection then
            GloomEggConnection = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                room.ChildAdded:Connect(function(child)
                    if child.Name == "GloomPile" then
                        for _, gloomEgg in pairs(child:GetDescendants()) do
                            if gloomEgg.Name == "Egg" then
                                processGloomEgg(gloomEgg)
                            end
                        end
                        
                        child.DescendantAdded:Connect(function(descendant)
                            if descendant.Name == "Egg" and value then
                                processGloomEgg(descendant)
                            end
                        end)
                    end
                end)
            end)
        elseif not value and GloomEggConnection then
            GloomEggConnection:Disconnect()
            GloomEggConnection = nil
        end
    end
})
		
GroupModifiers:AddToggle("Anti-Snare", {
    Text = "Anti Snare",
    Default = false,
    Callback = function(state)
        local connection
        if state then
            connection = workspace.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "Snare" then
                    local hitbox = descendant:FindFirstChild("Hitbox")
                    if hitbox then
                        hitbox.CanTouch = false
                    end
                end
            end)
        elseif connection then
            connection:Disconnect()
        end
        for _, snare in pairs(workspace:GetDescendants()) do
            if snare.Name == "Snare" then
                local hitbox = snare:FindFirstChild("Hitbox")
                if hitbox then
                    hitbox.CanTouch = not state
                end
            end
        end
    end
})
		
        local TempBridges = {}
        local Connection = nil
        local function ProtectBridges(room)
    if not room:FindFirstChild("Parts") then return end

    for _, bridge in pairs(room.Parts:GetChildren()) do
        if bridge.Name == "Bridge" then
            for _, barrier in pairs(bridge:GetChildren()) do
                if not (barrier.Name == "PlayerBarrier" and barrier.Size.Y == 2.75 and (barrier.Rotation.X == 0 or barrier.Rotation.X == 180)) then continue end
                
                local clone = barrier:Clone()
                clone.CFrame = clone.CFrame * CFrame.new(0, 0, -5)
                clone.Color = Color3.new(1, 1, 1)
                clone.Name = "AntiBridge"
                clone.Size = Vector3.new(clone.Size.X, clone.Size.Y, 11)
                clone.Transparency = 0
                clone.Parent = bridge
                
                table.insert(TempBridges, clone)
            end
        end
    end
end
GroupHotel:AddToggle("AntiSeekObstructions", {
    Text = "Anti Bridge Fall",
    Default = false,
    Callback = function(value)
        if value then
            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                ProtectBridges(room)
            end
            Connection = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                ProtectBridges(room)
            end)
        else
            for _, bridge in pairs(TempBridges) do
                if bridge and bridge.Parent then
                    bridge:Destroy()
                end
            end
            TempBridges = {}
            if Connection then
                Connection:Disconnect()
                Connection = nil
            end
        end
		
    end
})   

--[[ ANTI SEEK DOOR ]]--
local SeekDoorConnection = nil
local ModifiedDoors = {}

local function HandleSeekDoors(instance)
    if instance.Name == "SewerRingBreakable" then
        for _, child in pairs(instance:GetDescendants()) do
            if child:IsA("BasePart") and (child.Name == "DoorPart" or (string.find(child.Name, "Door") and string.find(child.Name, "[Pp]art"))) then
                if _G.msdoors_AntiSeekDoor then
                    if not ModifiedDoors[child] then
                        ModifiedDoors[child] = {
                            CanCollide = child.CanCollide
                        }
                    end
                    child.CanCollide = false
                end
            end
        end
    end
end

local function RestoreSeekDoors()
    for part, data in pairs(ModifiedDoors) do
        if part and part.Parent then
            part.CanCollide = data.CanCollide
        end
    end
    ModifiedDoors = {}
end

GroupHotel:AddToggle("antikickdoor", {
    Text = "Anti Kickdoor",
    DisabledTooltip = "I am disabled!",
    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,
    Callback = function(value)
        _G.msdoors_AntiSeekDoor = value
        
        if value then
            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                for _, instance in pairs(room:GetDescendants()) do
                    HandleSeekDoors(instance)
                end
            end
            
            if not SeekDoorConnection then
                SeekDoorConnection = workspace.DescendantAdded:Connect(function(instance)
                    HandleSeekDoors(instance)
                end)
            end
        else
            RestoreSeekDoors()

            if SeekDoorConnection then
                SeekDoorConnection:Disconnect()
                SeekDoorConnection = nil
            end
        end
    end,
})
		

--[[ ANTI FLOOD ]]--
_G.msdoors_OriginalFloodState = {}
local SeekFloodConnection

GroupHotel:AddToggle("antiFlood", {
    Text = "Anti Flood",
    DisabledTooltip = "I am disabled!",
    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,
    Callback = function(value)
        _G.msdoors_AntiFlood = value

        local function HandleSeekFlood(instance)
            if instance:IsA("BasePart") and instance.Name == "SeekFloodline" then
                if _G.msdoors_OriginalFloodState[instance] == nil then
                    _G.msdoors_OriginalFloodState[instance] = instance.CanCollide
                end
                instance.CanCollide = value
            end
        end

        if value then
            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                local damHandler = room:FindFirstChild("_DamHandler")
                if damHandler then
                    for _, instance in pairs(damHandler:GetDescendants()) do
                        HandleSeekFlood(instance)
                    end
                end
            end

            SeekFloodConnection = game.Workspace.DescendantAdded:Connect(function(instance)
                HandleSeekFlood(instance)
            end)
        else
            for instance, originalState in pairs(_G.msdoors_OriginalFloodState) do
                if instance and instance.Parent then
                    instance.CanCollide = originalState
                end
            end
            _G.msdoors_OriginalFloodState = {}

            if SeekFloodConnection then
                SeekFloodConnection:Disconnect()
                SeekFloodConnection = nil
            end
        end
    end,
})
		
    else
        print(floorName .. ": N")
    end
else
    warn("[ Msdoors ] » o jogo atual não está na lista, nada será adicionando na página Hotel!")
end


GroupMisc:AddButton({
    Text = "Reviver",
    Func = function()
        game:GetService("ReplicatedStorage").RemotesFolder.Revive:FireServer()
    end,
    DoubleClick = true
})

GroupMisc:AddButton({
    Text = "Jogar novamente",
    Func = function()
        game:GetService("ReplicatedStorage").RemotesFolder.PlayAgain:FireServer()
    end,
    DoubleClick = true
})

GroupMisc:AddButton({
    Text = "Retornar ao lobby",
    Func = function()
        game:GetService("ReplicatedStorage").RemotesFolder.Lobby:FireServer()
    end,
    DoubleClick = true
})

local EntityTable = {
    ["Names"] = {"BackdoorRush", "BackdoorLookman", "RushMoving", "AmbushMoving", "Eyes", "JeffTheKiller", "A60", "A120"},
    ["NotifyReason"] = {
        ["A60"] = { ["Image"] = "12350986086", ["Title"] = "A-60", ["Description"] = "A-60 SPAWNOU!" },
        ["A120"] = { ["Image"] = "12351008553", ["Title"] = "A-120", ["Description"] = "A-120 SPAWNOU!" },
        ["BackdoorRush"] = { ["Image"] = "11102256553", ["Title"] = "Blitz", ["Description"] = "Blitz spawnou!" },
        ["RushMoving"] = { ["Image"] = "11102256553", ["Title"] = "Rush", ["Description"] = "Rush SPAWNOU!" },
        ["AmbushMoving"] = { ["Image"] = "10938726652", ["Title"] = "Ambush", ["Description"] = "Ambush spawnou!" },
        ["Eyes"] = { ["Image"] = "10865377903", ["Title"] = "Eyes", ["Description"] = "Não olhe para os olhos!" },
        ["BackdoorLookman"] = { ["Image"] = "16764872677", ["Title"] = "Backdoor Lookman", ["Description"] = "Olhe para baixo!" },
        ["JeffTheKiller"] = { ["Image"] = "98993343", ["Title"] = "Jeff The Killer", ["Description"] = "Fuja do Jeff the Killer!" }
    }
}

local RoomTable = {
    ["HaltHallway"] = { ["Image"] = "11331795398", ["Title"] = "Halt", ["Description"] = "Prepare-se para Halt!" },
    ["Hotel_SeekIntro"] = { ["Image"] = "11043368229", ["Title"] = "Seek", ["Description"] = "Prepare-se para Seek!" }
}

local notificationsEnabled = false
local chatEnabled = false
local notifiedRooms = {}

_G.msdoors_chatActive = false

local function TrySendChatMessage(message)
    if _G.msdoors_chatActive then
        local TextChatService = game:GetService("TextChatService")

        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local textChannel = TextChatService.TextChannels.RBXGeneral
            textChannel:SendAsync(message)
        else
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        end
    end
end

function MonitorEntities()
    game:GetService("RunService").Stepped:Connect(function()
        if notificationsEnabled then
            for _, entityName in ipairs(EntityTable.Names) do
                local entities = workspace:GetChildren()
                for _, entity in pairs(entities) do
                    if entity.Name == entityName then
                        if not entity:GetAttribute("Msdoors_notificada") then
                            entity:SetAttribute("Msdoors_notificada", true)
                            NotifyEntity(entityName)
                        end
                    end
                end
            end
        end
    end)
end

function NotifyEntity(entityName)
    local notificationData = EntityTable.NotifyReason[entityName]
    if notificationData then
        task.spawn(function()
            MsdoorsNotify(
                notificationData.Title,
                notificationData.Description,
                "",
                "rbxassetid://" .. notificationData.Image,
                Color3.fromRGB(255, 0, 0),
                5
            )

            if _G.msdoors_chatActive then
                TrySendChatMessage("[" .. notificationData.Title .. "] - " .. notificationData.Description)
            end
        end)
    end
end

function MonitorRooms()
    game.Players.LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
        local currentRoom = game.Players.LocalPlayer:GetAttribute("CurrentRoom")
        if currentRoom then
            for i = 1, 3 do
                local nextRoomNumber = currentRoom + i
                local nextRoom = workspace.CurrentRooms:FindFirstChild(tostring(nextRoomNumber))
                if nextRoom and nextRoom:GetAttribute("RawName") then
                    local roomName = nextRoom:GetAttribute("RawName")
                    if RoomTable[roomName] and not notifiedRooms[roomName] then
                        notifiedRooms[roomName] = true
                        NotifyRoom(roomName)
                    end
                end
            end
        end
    end)
end

function NotifyRoom(roomName)
    local roomData = RoomTable[roomName]
    if roomData then
        task.spawn(function()
            MsdoorsNotify(
                roomData.Title,
                roomData.Description,
                "",
                "rbxassetid://" .. roomData.Image,
                Color3.fromRGB(0, 255, 255),
                5
            )

            if _G.msdoors_chatActive then
                TrySendChatMessage("[" .. roomData.Title .. "] - " .. roomData.Description)
            end
        end)
    end
end

MonitorEntities()
MonitorRooms()


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
    local baseNumber = tonumber(room.Name)

    local startNumber = 1
    if floorName == "Mines" then
    startNumber = 100
    elseif floorName == "Backdoor" then
    startNumber = -50
    elseif floorName == "Hotel" then
    startNumber = 1
    end

    local doorNumber = baseNumber + startNumber

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
            Color = Color3.fromRGB(255, 0, 0)
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
            Name = "Grumle",
            Color = Color3.fromRGB(255, 0, 0)
        },
        BackdoorRush = {
            Name = "Blitz",
            Color = Color3.fromRGB(255, 0, 0)
        },
        Entity10 = {
            Name = "Entidade 10",
            Color = Color3.fromRGB(255, 0, 0)
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

local ITEMESPConfig = {
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

local ITEMESPConfig = {
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

local ITEMESPManager = {
    ActiveESPs = {},
    IsEnabled = false,
    IsChecking = false
}

function ITEMESPManager:CreateESP(object, itemName)
    if not object or not object.PrimaryPart or not object:IsDescendantOf(workspace) then return nil end

    local espInstance = ESPLibrary.ESP.Highlight({
        Name = itemName,
        Model = object,
        MaxDistance = ITEMESPConfig.Settings.MaxDistance,
        
        FillColor = Color3.fromRGB(0, 255, 255),
        OutlineColor = Color3.fromRGB(0, 255, 255),
        TextColor = Color3.fromRGB(0, 255, 255),
        TextSize = ITEMESPConfig.Settings.TextSize,

        FillTransparency = ITEMESPConfig.Settings.FillTransparency,
        OutlineTransparency = ITEMESPConfig.Settings.OutlineTransparency,

        Tracer = {
            Enabled = true,
            From = ITEMESPConfig.Settings.TracerStartPosition,
            Color = Color3.fromRGB(0, 255, 255)
        },

        Arrow = {
            Enabled = true,
            CenterOffset = ITEMESPConfig.Settings.ArrowCenterOffset,
            Color = Color3.fromRGB(0, 255, 255)
        }
    })

    object.AncestryChanged:Connect(function(_, parent)
        if not parent or not object:IsDescendantOf(workspace) then
            self:RemoveESP(object)
        end
    end)

    return espInstance
end

function ITEMESPManager:AddESP(object, itemName)
    if not object or self.ActiveESPs[object] or not object:IsDescendantOf(workspace) then return end

    local espInstance = self:CreateESP(object, itemName)
    if espInstance then
        self.ActiveESPs[object] = espInstance
    end
end

function ITEMESPManager:RemoveESP(object)
    if self.ActiveESPs[object] then
        self.ActiveESPs[object]:Destroy()
        self.ActiveESPs[object] = nil
    end
end

function ITEMESPManager:ScanDrops()
    if not self.IsEnabled then return end

    local dropsFolder = workspace:FindFirstChild("Drops")
    if not dropsFolder then return end

    for _, item in pairs(dropsFolder:GetChildren()) do
        local itemName = item:GetAttribute("Tool_NameSingular") or item:GetAttribute("Pickup")
        if itemName and item:IsDescendantOf(workspace) then
            self:AddESP(item, itemName)
        elseif self.ActiveESPs[item] then
            self:RemoveESP(item)
        end
    end
end

function ITEMESPManager:ScanWorkspace()
    if not self.IsEnabled then return end

    for _, object in pairs(workspace:GetDescendants()) do
        if object:GetAttribute("JustLoot") == true then
            local itemName = object:GetAttribute("Tool")
            if itemName and object:IsDescendantOf(workspace) then
                self:AddESP(object, itemName)
            elseif self.ActiveESPs[object] then
                self:RemoveESP(object)
            end
        end
    end
end

function ITEMESPManager:ClearESPs()
    for object, esp in pairs(self.ActiveESPs) do
        esp:Destroy()
    end
    self.ActiveESPs = {}
end

function ITEMESPManager:StartScanning()
    if self.IsChecking then return end
    self.IsChecking = true

    spawn(function()
        while self.IsChecking do
            self:ScanDrops()
            self:ScanWorkspace()
            wait(ITEMESPConfig.Settings.UpdateInterval)
        end
    end)
end

function ITEMESPManager:StopScanning()
    self.IsChecking = false
    self:ClearESPs()
end

GroupEsp:AddToggle("Visual-esp-item", {
    Text = "Esp Item",
    DisabledTooltip = "Manutenção!",
    Default = false,
    Disabled = true,
    Visible = true,
    Risky = true,
    Callback = function(state)
        ITEMESPManager.IsEnabled = state
        
        if state then
            ITEMESPManager:StartScanning()
        else
            ITEMESPManager:StopScanning()
        end
    end,
})

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
	Risky = false,
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
--// Este sistema de auto interact é originalmente dá mspaint \\--

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
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpHeight = value and Toggles.JumpBoost.Value or 0
        end
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
    if character and character:GetAttribute("CanJump") then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpHeight = value
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    character:SetAttribute("CanJump", Toggles.EnableJump.Value)
    
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.JumpHeight = Toggles.EnableJump.Value and Toggles.JumpBoost.Value or 0
end)

local Options = {}

Options.Brightness = {Value = 0}
Options.Fullbright = {Value = false}
Options.NoFog = {Value = false}

local Lighting = game:GetService("Lighting")
local LocalPlayer = game.Players.LocalPlayer
local fullbrightConnection = nil

GroupAmbient:AddSlider("Brightness", {
    Text = "Brilho",
    Default = 0,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Callback = function(value)
        Options.Brightness.Value = value
        Lighting.Brightness = value
    end
})

GroupAmbient:AddToggle("Fullbright", {
   Text = "Brilho total",
   Default = false,
   Callback = function(value)
       Options.Fullbright.Value = value
       
       if value then
           Lighting.Ambient = Color3.new(1, 1, 1)
           
           if fullbrightConnection then
               fullbrightConnection:Disconnect()
           end
           
           fullbrightConnection = game:GetService("RunService").RenderStepped:Connect(function()
               Lighting.Ambient = Color3.new(1, 1, 1)
           end)
       else
           if fullbrightConnection then
               fullbrightConnection:Disconnect()
               fullbrightConnection = nil
           end
           
           local currentRoom = LocalPlayer:GetAttribute("CurrentRoom")
           if currentRoom and workspace:FindFirstChild("CurrentRooms") and workspace.CurrentRooms:FindFirstChild(currentRoom) then
               Lighting.Ambient = workspace.CurrentRooms[currentRoom]:GetAttribute("Ambient") or Color3.new(0, 0, 0)
           else
               Lighting.Ambient = Color3.new(0, 0, 0)
           end
       end
   end
})

GroupAmbient:AddToggle("NoFog", {
    Text = "No Fog",
    Default = false,
    Callback = function(value)
        Options.NoFog.Value = value
        
        if not Lighting:GetAttribute("FogStart") then
            Lighting:SetAttribute("FogStart", Lighting.FogStart)
        end
        if not Lighting:GetAttribute("FogEnd") then
            Lighting:SetAttribute("FogEnd", Lighting.FogEnd)
        end

        Lighting.FogStart = value and 0 or Lighting:GetAttribute("FogStart")
        Lighting.FogEnd = value and math.huge or Lighting:GetAttribute("FogEnd")

        local fog = Lighting:FindFirstChildOfClass("Atmosphere")
        if fog then
            if not fog:GetAttribute("Density") then
                fog:SetAttribute("Density", fog.Density)
            end
            fog.Density = value and 0 or fog:GetAttribute("Density")
        end
    end
})

Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
    if Options and Options.Brightness and Options.Brightness.Value then
        Lighting.Brightness = Options.Brightness.Value
    end
end)

Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
    if Options and Options.Fullbright and Options.Fullbright.Value then
        Lighting.Ambient = Color3.new(1, 1, 1)
    end
end)

Lighting:GetPropertyChangedSignal("FogStart"):Connect(function()
    if Options and Options.NoFog and Options.NoFog.Value then
        Lighting.FogStart = 0
    end
end)

Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
    if Options and Options.NoFog and Options.NoFog.Value then
        Lighting.FogEnd = math.huge
    end
end)


function _G.msdoors_antilag:Activate()
    if not self.Enabled then return end  

    Lighting.FogEnd = 1e10
    Lighting.FogStart = 1e10
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if not self.StoredProperties[obj] then
                self.StoredProperties[obj] = { Material = obj.Material }
            end
            obj.Material = Enum.Material.Plastic
        elseif obj:IsA("Decal") then
            if not self.StoredProperties[obj] then
                self.StoredProperties[obj] = { Transparency = obj.Transparency }
            end
            obj.Transparency = 1
        end
    end

    if not self.Connection then
        self.Connection = Workspace.DescendantAdded:Connect(function(obj)
            if not self.Enabled then return end
            
            if obj:IsA("BasePart") then
                self.StoredProperties[obj] = { Material = obj.Material }
                obj.Material = Enum.Material.Plastic
            elseif obj:IsA("Decal") then
                self.StoredProperties[obj] = { Transparency = obj.Transparency }
                obj.Transparency = 1
            end
        end)
    end
end

function _G.msdoors_antilag:Deactivate()
    Lighting.FogEnd = 500
    Lighting.FogStart = 0
    Lighting.Brightness = 1
    Lighting.GlobalShadows = true
    Lighting.EnvironmentDiffuseScale = 1
    Lighting.EnvironmentSpecularScale = 1

    for obj, properties in pairs(self.StoredProperties) do
        if obj:IsA("BasePart") and properties.Material then
            obj.Material = properties.Material
        elseif obj:IsA("Decal") and properties.Transparency ~= nil then
            obj.Transparency = properties.Transparency
        end
    end

    self.StoredProperties = {}

    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end


GroupAmbient:AddToggle("AntiLag", {
    Text = "Anti-Lag",
    Default = false,
    Callback = function(value)
        _G.msdoors_antilag.Enabled = value
        if value then
            _G.msdoors_antilag:Activate()
        else
            _G.msdoors_antilag:Deactivate()
        end
    end
})

local latestRoom = game.ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")
latestRoom:GetPropertyChangedSignal("Value"):Connect(function()
    if _G.msdoors_antilag.Enabled then
        _G.msdoors_antilag:Activate()
    end
end)

--// ANTI ENTITY \\--
local function toggleScreech(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    
    if not mainUI then return end

    local modules = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and 
                    mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener") and 
                    mainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")

    if not modules then return end

    local screech = modules:FindFirstChild("Screech") or modules:FindFirstChild("Screech_MSDOORS_DISABLE")
    if not screech then return end

    screech.Name = enabled and "Screech_MSDOORS_DISABLE" or "Screech"
end

local function toggleDread(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    
    if not mainUI then return end

    local modules = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and 
                    mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener") and 
                    mainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")

    if not modules then return end

    local dread = modules:FindFirstChild("Dread") or modules:FindFirstChild("Dread_MSDOORS_DISABLE")
    if not dread then return end

    dread.Name = enabled and "Dread_MSDOORS_DISABLE" or "Dread"
end

if floorName == "Mines" then
    GroupAntiEntity:AddToggle("Anti-Giggle", {
    Text = "Anti Giggle",
    Default = false,
    Callback = function(state)
        local connection
        if state then
            connection = workspace.CurrentRooms.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "GiggleCeiling" then
                    local hitbox = descendant:WaitForChild("Hitbox", 5)
                    if hitbox then
                        hitbox.CanTouch = false
                    end
                end
            end)
        elseif connection then
            connection:Disconnect()
        end
        
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            for _, giggle in pairs(room:GetDescendants()) do
                if giggle.Name == "GiggleCeiling" then
                    local hitbox = giggle:FindFirstChild("Hitbox")
                    if hitbox then
                        hitbox.CanTouch = not state
                    end
                end
            end
        end
    end
})
end

if floorName == "Rooms" then
    local function toggleA90(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    
    if not mainUI then return end

    local modules = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and 
                    mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener") and 
                    mainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")

    if not modules then return end

    local a90 = modules:FindFirstChild("A90") or modules:FindFirstChild("A90_MSDOORS_DISABLE")
    if not a90 then return end

    a90.Name = enabled and "A90_MSDOORS_DISABLE" or "A90"
end

GroupModifiers:AddToggle("Anti-A90", {
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
end

local EyesName = (_G.msdoors_floor == "Hotel" and "Anti Eyes") or  
                 (_G.msdoors_floor == "Backdoor" and "Anti Lookman") or
                 (_G.msdoors_floor == "Mines" and "Anti Eyes") or  
                 "Anti Eyes"

local EyeActive = (_G.msdoors_floor == "Super Hard Mode") and true or false
GroupAntiEntity:AddToggle("AntiEyes", {
    Text = EyesName,
    Default = _G.msdoors_antieyes,
    Disabled = EyeActive,
    Callback = function(value)
    _G.msdoors_antieyes = value
        local function AntiEyes()
            for _, eye in pairs(Workspace:GetChildren()) do
                if eye.Name == "Eyes" or eye.Name == "BackdoorLookman" then
                    if _G.msdoors_antieyes then
                        ReplicatedStorage.RemotesFolder.MotorReplication:FireServer(-649)
                    end
                end
            end
        end

        if _G.msdoors_antieyes then
            task.spawn(function()
                while _G.msdoors_antieyes do
                    AntiEyes()
                    task.wait()
                end
            end)
        end
    end
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
        _G.msdoors_antiscppreech = Value
        toggleScreech(Value)
	end,
})

GroupAntiEntity:AddToggle("Anti-Snare", {
    Text = "Anti Snare",
    Default = false,
    Callback = function(state)
        local connection
        if state then
            connection = workspace.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "Snare" then
                    local hitbox = descendant:FindFirstChild("Hitbox")
                    if hitbox then
                        hitbox.CanTouch = false
                    end
                end
            end)
        elseif connection then
            connection:Disconnect()
        end
        for _, snare in pairs(workspace:GetDescendants()) do
            if snare.Name == "Snare" then
                local hitbox = snare:FindFirstChild("Hitbox")
                if hitbox then
                    hitbox.CanTouch = not state
                end
            end
        end
    end
})

GroupAntiEntity:AddToggle("AntiHearing", {
    Text = "Anti-Figure Hearing[MANUTENÇÃO]",
    Default = false,
    Disabled = true,
    Callback = function(state)
        local remote = game.ReplicatedStorage:FindFirstChild("Crouch")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(state)
        end
    end
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
    Max = 13,
    Default = _G.MaxActivationDistance,
    Increment = 0.1,
    Callback = function(value)
        _G.MaxActivationDistance = value
        UpdateProximityPrompts()
    end,
})

GroupNot:AddToggle("Visual-Notifier-Entities", {
    Text = "Notificar Entidades",
    Default = false,
    Callback = function(value)
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

GroupNotC:AddToggle("Chat-Notifier", {
    Text = "Enviar notificações no chat",
    Default = false,
    Callback = function(value)
        _G.msdoors_chatActive = value
    end,
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function renameEntities()
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    if not mainUI then return end

    local modules = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and 
                    mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener") and 
                    mainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")

    if not modules then return end

    if _G.msdoors_antia90 then
        local a90 = modules:FindFirstChild("A90") or modules:FindFirstChild("A90_MSDOORS_DISABLE")
        if a90 then a90.Name = "A90_MSDOORS_DISABLE" end
    end

    if _G.msdoors_antiscreech then
        local screech = modules:FindFirstChild("Screech") or modules:FindFirstChild("Screech_MSDOORS_DISABLE")
        if screech then screech.Name = "Screech_MSDOORS_DISABLE" end
    end

    if _G.msdoors_antidread then
        local dread = modules:FindFirstChild("Dread") or modules:FindFirstChild("Dread_MSDOORS_DISABLE")
        if dread then dread.Name = "Dread_MSDOORS_DISABLE" end
    end

    local remoteListener = mainUI.Initiator.Main_Game.RemoteListener

    if _G.msdoors_antijumpscares then
        local jumpscares = remoteListener:FindFirstChild("Jumpscares") or remoteListener:FindFirstChild("Jumpscares_MSDOORS_DISABLE")
        if jumpscares then jumpscares.Name = "Jumpscares_MSDOORS_DISABLE" end
    end

    if _G.msdoors_anticutscenes then
        local cutscenes = remoteListener:FindFirstChild("Cutscenes") or remoteListener:FindFirstChild("Cutscenes_MSDOORS_DISABLE")
        if cutscenes then cutscenes.Name = "Cutscenes_MSDOORS_DISABLE" end
    end
end

local function monitorAlive()
    while true do
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            local aliveAttr = character:GetAttribute("Alive")
            
            repeat task.wait(1) until not aliveAttr or humanoid.Health <= 0
            
            repeat
                task.wait(1)
                aliveAttr = character:GetAttribute("Alive")
            until aliveAttr and humanoid.Health > 0

            renameEntities()
        end
    end
end

task.spawn(monitorAlive)

local function toggleCutscenes(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")

    if not mainUI then return end

    local initiator = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game")
    if not initiator then return end

    local remoteListener = initiator:FindFirstChild("RemoteListener")
    if not remoteListener then return end

    local cutscenes = remoteListener:FindFirstChild("Cutscenes") or remoteListener:FindFirstChild("Cutscenes_MSDOORS_DISABLE")
    if not cutscenes then return end

    if enabled then
        if cutscenes.Name == "Cutscenes" then
            cutscenes.Name = "Cutscenes_MSDOORS_DISABLE"
        end
    else
        if cutscenes.Name == "Cutscenes_MSDOORS_DISABLE" then
            cutscenes.Name = "Cutscenes"
        end
    end
end

SelfTab:AddToggle("Anti-Cutscenes", {
    Text = "No Cutscenes",
    DisabledTooltip = "Eu estou desativado!",
    Default = _G.msdoors_anticutscenes,
    Disabled = false,
    Visible = true,
    Risky = false,
    Callback = function(Value)
        _G.msdoors_anticutscenes = Value
        toggleCutscenes(Value)
    end,
})

local function toggleJumpscares(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")

    if not mainUI then return end

    local initiator = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game")
    if not initiator then return end
	
    local remoteListener = initiator:FindFirstChild("RemoteListener")
    if not remoteListener then return end

    local jumpscares = remoteListener:FindFirstChild("Jumpscares") or remoteListener:FindFirstChild("Jumpscares_MSDOORS_DISABLE")
    if not jumpscares then return end

    if enabled then
        if jumpscares.Name == "Jumpscares" then
            jumpscares.Name = "Jumpscares_MSDOORS_DISABLE"
        end
    else
        if jumpscares.Name == "Jumpscares_MSDOORS_DISABLE" then
            jumpscares.Name = "Jumpscares"
        end
    end
end

SelfTabE:AddToggle("Anti-Jumpscares", {
    Text = "No Jumpscares",
    DisabledTooltip = "Eu estou desativado!",
    Default = _G.msdoors_antijumpscares,
    Disabled = false,
    Visible = true,
    Risky = false,
    Callback = function(Value)
        _G.msdoors_antijumpscares = Value
        toggleJumpscares(Value)
    end,
})

--// SPEED BYPASS \\--
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

_G.MSDoors_SpeedBypass = false
_G.MSDoors_EnableJump = false
_G.MSDoors_SpeedBypassDelay = 0.23
_G.MSDoors_WalkSpeed = 15
_G.MSDoors_FlySpeed = 15


local MSDoors_Script = {
    SpeedBypassing = false,
    CollisionClone = nil,
    Bypassed = false,
    FakeRevive = {Enabled = false},
}

if not Character then
    Character = LocalPlayer.CharacterAdded:Wait()
end

local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Collision

local function MSDoors_SetupCollision()
    Collision = Character:FindFirstChild("Collision")
    if not Collision then
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name:lower():find("collision") then
                Collision = part
                break
            end
        end
    end
    
    if not Collision then
        Collision = RootPart
    end
    
    if Collision then
        MSDoors_Script.CollisionClone = Collision:Clone()
        MSDoors_Script.CollisionClone.CanCollide = false
        MSDoors_Script.CollisionClone.Massless = true
        MSDoors_Script.CollisionClone.CanQuery = false
        MSDoors_Script.CollisionClone.Name = "CollisionClone"
        
        if MSDoors_Script.CollisionClone:FindFirstChild("CollisionCrouch") then
            MSDoors_Script.CollisionClone.CollisionCrouch:Destroy()
        end
        
        MSDoors_Script.CollisionClone.Parent = Character
    end
end

local function MSDoors_SpeedBypass()
    if MSDoors_Script.SpeedBypassing or not MSDoors_Script.CollisionClone then return end
    MSDoors_Script.SpeedBypassing = true

    task.spawn(function()
        while _G.MSDoors_SpeedBypass and MSDoors_Script.CollisionClone do
            if RootPart.Anchored then
                MSDoors_Script.CollisionClone.Massless = true
                repeat task.wait() until not RootPart.Anchored
                task.wait(0.15)
            else
                MSDoors_Script.CollisionClone.Massless = not MSDoors_Script.CollisionClone.Massless
            end
            task.wait(_G.MSDoors_SpeedBypassDelay)
        end

        MSDoors_Script.SpeedBypassing = false
        if MSDoors_Script.CollisionClone then
            MSDoors_Script.CollisionClone.Massless = true
        end
    end)
end

local function MSDoors_UpdateSpeeds()
    if _G.MSDoors_SpeedBypass then
        Humanoid.WalkSpeed = _G.MSDoors_WalkSpeed
    else
        local speed = MSDoors_Script.Bypassed and 75 or (_G.MSDoors_EnableJump and 18 or 22)
        Humanoid.WalkSpeed = math.min(_G.MSDoors_WalkSpeed, speed)
    end
end


GroupPlayer:AddToggle("WalkSpeed", {
	Text = "Habilitar WalkSpeed",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        _G.MSDoors_WalkSpeed = Value and 15 or Humanoid.WalkSpeed
        MSDoors_UpdateSpeeds()
	end,
})
GroupPlayer:AddSlider("WalkSpeedVelocity", {
	Text = "WalkSpeed",
	Default = 15,
	Min = 0,
	Max = 100,
	Rounding = 1,
	Compact = false,
	Callback = function(Value)
        _G.MSDoors_WalkSpeed = Value
        MSDoors_UpdateSpeeds()
	end,
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})


_G.msdoors_densidadeOriginal = nil
_G.msdoors_rootPart = nil

_G.msdoors_atualizarPropriedadesFisicas = function(valor)
    if not _G.msdoors_rootPart then return end
    
    local props = _G.msdoors_rootPart.CustomPhysicalProperties
    
    if valor then
        _G.msdoors_densidadeOriginal = props.Density
        
        _G.msdoors_rootPart.CustomPhysicalProperties = PhysicalProperties.new(
            100,
            props.Friction,
            props.Elasticity,
            props.FrictionWeight,
            props.ElasticityWeight
        )
    else
        if _G.msdoors_densidadeOriginal then
            _G.msdoors_rootPart.CustomPhysicalProperties = PhysicalProperties.new(
                _G.msdoors_densidadeOriginal,
                props.Friction,
                props.Elasticity,
                props.FrictionWeight,
                props.ElasticityWeight
            )
        end
    end
end

GroupPlayer:AddToggle("NoAccel", {
    Text = "No Acceleration",
    DisabledTooltip = "No Acceleration está desativado",
    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,
    Callback = function(value)
        _G.msdoors_atualizarPropriedadesFisicas(value)
    end,
})

_G.msdoors_iniciarPersonagem = function(character)
    if not character then return end
    
    local success = pcall(function()
        _G.msdoors_rootPart = character:WaitForChild("HumanoidRootPart", 5)
    end)
    
    if not success or not _G.msdoors_rootPart then return end
    
    if Toggles and Toggles.NoAccel and Toggles.NoAccel.Value then
        _G.msdoors_atualizarPropriedadesFisicas(true)
    end
end

local player = game.Players.LocalPlayer
if player then
    player.CharacterAdded:Connect(_G.msdoors_iniciarPersonagem)
    
    if player.Character then
        _G.msdoors_iniciarPersonagem(player.Character)
    end
end

GroupBypass:AddToggle("SpeedBypass", {
	Text = "Speed Bypass",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
            _G.MSDoors_SpeedBypass = Value
        
        if Value then
            _G.MSDoors_WalkSpeed = math.min(_G.MSDoors_WalkSpeed, 75)
            MSDoors_SpeedBypass()
        else
            if MSDoors_Script.FakeRevive.Enabled then return end
            
            local speed = MSDoors_Script.Bypassed and 75 or (_G.MSDoors_EnableJump and 18 or 22)
            _G.MSDoors_WalkSpeed = math.min(_G.MSDoors_WalkSpeed, speed)
        end
        
        MSDoors_UpdateSpeeds()
	end,
})

GroupBypass:AddSlider("WalkSpeedVelocity", {
	Text = "Speed Bypass delay",
	Default = 0.23,
	Min = 0.22,
	Max = 0.25,
	Rounding = 1,
	Compact = false,
	Callback = function(Value)
            _G.MSDoors_SpeedBypassDelay = Value
	end,
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})


MSDoors_SetupCollision()

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    
    MSDoors_SetupCollision()
    
    if _G.MSDoors_EnableJump then
        Character:SetAttribute("CanJump", true)
        Humanoid.JumpHeight = 7.2
    end
    
    if _G.MSDoors_SpeedBypass then
        MSDoors_SpeedBypass()
    end
    
    MSDoors_UpdateSpeeds()
end)

RunService.Heartbeat:Connect(function()
    if _G.MSDoors_SpeedBypass and _G.MSDoors_WalkSpeed > 0 then
        Humanoid.WalkSpeed = _G.MSDoors_WalkSpeed
    end
end)


--// ADDONS \\--
task.spawn(function()
    local AddonTab = Window:AddTab("Addons [BETA]")

    if not isfolder("msdoors/addons") then
        makefolder("msdoors/addons")
    end

    local function AddAddonElement(Group, Element)
        if not Element or type(Element) ~= "table" then return end

        if Element.Type == "Label" then
            Group:AddLabel(Element.Arguments.Text or "Sem Texto")
        elseif Element.Type == "Toggle" then
            Group:AddToggle(Element.Name, {
                Text = Element.Arguments.Text or "Sem Nome",
                Default = Element.Arguments.Default or false,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "Button" then
            Group:AddButton({
                Text = Element.Arguments.Text or "Botão",
                Func = Element.Arguments.Callback
            })
        elseif Element.Type == "Slider" then
            Group:AddSlider(Element.Name, {
                Text = Element.Arguments.Text or "Slider",
                Min = Element.Arguments.Min,
                Max = Element.Arguments.Max,
                Default = Element.Arguments.Default,
                Rounding = Element.Arguments.Rounding or 0,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "Input" then
            Group:AddInput(Element.Name, {
                Default = Element.Arguments.Default or "",
                Text = Element.Arguments.Text or "Entrada",
                Numeric = Element.Arguments.Numeric or false,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "Dropdown" then
            Group:AddDropdown(Element.Name, {
                Values = Element.Arguments.Values or {},
                Default = Element.Arguments.Default,
                Multi = Element.Arguments.Multi or false,
                Text = Element.Arguments.Text or "Dropdown",
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "ColorPicker" then
            Group:AddColorPicker(Element.Name, {
                Default = Element.Arguments.Default or Color3.new(1, 1, 1),
                Text = Element.Arguments.Text or "Cor",
                Callback = Element.Arguments.Callback
            })
	elseif Element.Type == "Divider" then
            Group:AddDivider()
        elseif Element.Type == "KeyPicker" then
            Group:AddKeyPicker(Element.Name, {
                Default = Element.Arguments.Default,
                Text = Element.Arguments.Text or "Atalho",
                Callback = Element.Arguments.Callback
            })
        else
            warn("[MsDoors Addons] Elemento '" .. tostring(Element.Name) .. "' não carregado: Tipo inválido.")
        end
    end

    local containAddonsLoaded = false

    for _, file in pairs(listfiles("msdoors/addons")) do
        print("[MsDoors Addons] Carregando addon '" .. file:gsub("msdoors/addons/", "") .. "'...")
        if not (file:match("%.lua$") or file:match("%.txt$") or file:match("%.luau$")) then
            continue
        end

        local success, errorMessage = pcall(function()
            local fileContent = readfile(file)
            local addon = loadstring(fileContent)()

            if type(addon.Name) ~= "string" or type(addon.Elements) ~= "table" then
                warn("[MsDoors Addons] Addon '" .. file:gsub("msdoors/addons/", "") .. "' não carregado: Nome/Elementos inválidos.")
                return 
            end

            containAddonsLoaded = true

            local AddonGroup = AddonTab:AddLeftGroupbox(addon.Name)
            AddonGroup:AddLabel(addon.Description or "Sem descrição.")

            for _, element in pairs(addon.Elements) do
                AddAddonElement(AddonGroup, element)
            end
        end)

        if not success then
            warn("[MsDoors Addons] Falha ao carregar addon '" .. file:gsub("msdoors/addons/", "") .. "':", errorMessage)
        end
    end

    if not containAddonsLoaded then
        local EmptyGroup = AddonTab:AddLeftGroupbox("Nenhum Addon Encontrado")
        EmptyGroup:AddLabel("A pasta 'msdoors/addons' está vazia. Adicione addons e reinicie o script.")
    end
end)

-- Credits[ Tenha bom senso ]
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
local FolderFloor = (_G.msdoors_floor == "Hotel" and "Hotel") or  
                 (_G.msdoors_floor == "Rooms" and "Rooms") or  
                 (_G.msdoors_floor == "Backdoor" and "Backdoor") or  
                 (_G.msdoors_floor == "Mines" and "Mines") or  
                 (_G.msdoors_floor == "Retro Mode" and "Retro") or
                 (_G.msdoors_floor == "Super Hard Mode" and "SuperHardMode") or  
                 "NoFloor"

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("msdoors")
SaveManager:SetFolder("msdoors/Doors")
SaveManager:SetSubFolder(FolderFloor)
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
_G.MsdoorsLoaded = true

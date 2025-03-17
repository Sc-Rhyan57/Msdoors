if _G.ObsidianaLib then
    warn("[Msdoors] • Script já carregado!")
    return
end
-- Definir um valor padrão para a variável global
_G.msdoors_syslibrary = _G.msdoors_syslibrary or "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local repo = _G.msdoors_syslibrary
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/MSESP/refs/heads/main/source.lua"))()
local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Msdoors/Msdoors.gg/refs/heads/main/Scripts/Msdoors/Notification/Source.lua"))()

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
_G.msdoors_LibraryNotif = _G.msdoors_LibraryNotif or "Linoria"
_G.msdoors.autoInteract.Enabled = _G.msdoors.autoInteract.Enabled or false
_G.msdoors_AntiSeekObstructions = _G.msdoors_AntiSeekObstructions or false
_G.msdoors_AntiSeekDoor = _G.msdoors_AntiSeekDoor or false
_G.msdoors_AntiSnare = _G.msdoors_AntiSnare = or false
_G.msdoors_AntiGloomEgg = _G.msdoors_AntiGloomEgg or false
_G.msdoors_AntiBanana = _G.msdoors_AntiBanana or false
_G.msdoors_AntiGiggle = _G.msdoors_AntiGiggle or false
_G.msdoors_DupeRunning = _G.msdoors_DupeRunning or false
_G.msdoors_AntiDupe = _G.msdoors_AntiDupe or false
_G.msdoors_AntiFlood = _G.msdoors_AntiFlood or false
_G.msdoors_anticutscenes = _G.msdoors_anticutscenes or false
_G.msdoors_antijumpscares = _G.msdoors_antijumpscares or false
_G.msdoors_antia90 = _G.msdoors_antia90 or false
_G.msdoors_antiscreech = _G.msdoors_antiscreech or false
_G.msdoors_antidread = _G.msdoors_antidread or false
_G.msdoors_CurrentlyUsingSGF = _G.msdoors_CurrentlyUsingSGF or false
_G.msdoors_SpeedBypassBeTurned = _G.msdoors_SpeedBypassBeTurned or nil
_G.msdoors_SpeedHackBeTurned = _G.msdoors_SpeedHackBeTurned or nil
_G.MaxActivationDistance = _G.MaxActivationDistance or 7
_G.PromptClip = _G.PromptClip or false
_G.msdoors_antieyes = _G.msdoors_antieyes or false
_G.msdoors_antilag = {
    Enabled = false,
    Connection = nil,
    StoredProperties = {}
}
getgenv().AntiSeekManager = { IsEnabled = false }
_G.ObsidianaLib = true
--[[ ESP SETTINGS ]]--
_G.msdoors_OutlineTr = _G.msdoors_OutlineTr or 0
_G.msdoors_tracePos = _G.msdoors_tracePos or "Bottom"
_G.msdoors_TextSize = _G.msdoors_TextSize or 16
_G.msdoors_tracerSt = _G.msdoors_tracerSt or false
_G.msdoors_arrowSt = _G.msdoors_arrowSt or false

--// ESP COLORS \\--
_G.msdoors_entityColor = _G.msdoors_entityColor or Color3.fromRGB(255, 0, 0)
_G.msdoors_objectiveColor = _G.msdoors_objectiveColor or Color3.fromRGB(0, 255, 0)
_G.msdoors_DoorEspColor = _G.msdoors_DoorEspColor or Color3.fromRGB(100, 200, 255)

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
local GroupNotification = Tabs.Visual:AddRightTabbox()
local GroupNot = GroupNotification:AddTab('Notificação')
local GroupNotC = GroupNotification:AddTab('Configurações')

local GroupAmbient = Tabs.Visual:AddLeftGroupbox("Ambiente")
local GroupVPlayer = Tabs.Visual:AddRightGroupbox("Player")

local GroupSelf = Tabs.Visual:AddRightTabbox()
local SelfTab = GroupSelf:AddTab('Camera')
local SelfTabE = GroupSelf:AddTab('Efeitos')

local GroupEspc = Tabs.Visual:AddLeftTabbox()
local GroupEsp = GroupEspc:AddTab('Esp')
local GroupEspConfig = GroupEspc:AddTab('Configurações')


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
_G.msdoors_AntiGiggle = false

GroupModifiers:AddToggle("Anti-Giggle", {
    Text = "Anti Giggle",
    Default = _G.msdoors_AntiGiggle,
    Callback = function(state)
        _G.msdoors_AntiGiggle = state
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
    Default = _G.msdoors_AntiBanana,
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
	local GroupHotel = Tabs.Hotel:AddLeftGroupbox("Floor")
	local GroupHotel = Tabs.Hotel:AddLeftGroupbox("Visuals")

  --[[ Show Haste Clock ]]--
_G.msdoors_HasteClockEnabled = false
_G.msdoors_DigitalTimerValue = 0
_G.msdoors_ScaryStartsNowValue = false
_G.msdoors_TimerLabel = nil
_G.msdoors_CLOCK_FUNCTIONS = {}

_G.msdoors_CLOCK_FUNCTIONS.TimerFormat = function(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%02d:%02d", minutes, remainingSeconds)
end

_G.msdoors_CLOCK_FUNCTIONS.Captions = function(text)
    if not _G.msdoors_TimerLabel then
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "HasteClockGui"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        
        local Frame = Instance.new("Frame")
        Frame.Name = "TimerFrame"
        Frame.AnchorPoint = Vector2.new(0.5, 1)
        Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Frame.BorderSizePixel = 2
        Frame.Position = UDim2.new(0.5, 0, 0.98, 0)
        Frame.Size = UDim2.new(0, 150, 0, 40)
        Frame.Parent = ScreenGui
        
        _G.msdoors_TimerLabel = Instance.new("TextLabel")
        _G.msdoors_TimerLabel.Name = "TimerText"
        _G.msdoors_TimerLabel.BackgroundTransparency = 1
        _G.msdoors_TimerLabel.Position = UDim2.new(0, 0, 0, 0)
        _G.msdoors_TimerLabel.Size = UDim2.new(1, 0, 1, 0)
        _G.msdoors_TimerLabel.Font = Enum.Font.SourceSansBold
        _G.msdoors_TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        _G.msdoors_TimerLabel.TextSize = 24
        _G.msdoors_TimerLabel.Text = text
        _G.msdoors_TimerLabel.Parent = Frame
        
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(0, 0, 0)
        UIStroke.Thickness = 2
        UIStroke.Parent = _G.msdoors_TimerLabel
    else
        _G.msdoors_TimerLabel.Text = text
    end
end

_G.msdoors_CLOCK_FUNCTIONS.HideCaptions = function()
    if _G.msdoors_TimerLabel and _G.msdoors_TimerLabel.Parent and _G.msdoors_TimerLabel.Parent.Parent then
        _G.msdoors_TimerLabel.Parent.Parent:Destroy()
        _G.msdoors_TimerLabel = nil
    end
end

GroupHotel:AddToggle("HasteClockToggle", {
    Text = "Haste Clock",
    Tooltip = "Shows a timer for Haste events",
    DisabledTooltip = "Haste Clock is disabled",
    Default = _G.msdoors_HasteClockEnabled,
    Disabled = false,
    Visible = true,
    Risky = false,
    
    Callback = function(value)
        _G.msdoors_HasteClockEnabled = value
        if not value then
            _G.msdoors_CLOCK_FUNCTIONS.HideCaptions()
        end
        
        if value then
            local FloorReplicated = game:GetService("ReplicatedStorage"):FindFirstChild("FloorReplicated")
            
            if FloorReplicated then
                local digitalTimer = FloorReplicated:FindFirstChild("DigitalTimer")
                local scaryStartsNow = FloorReplicated:FindFirstChild("ScaryStartsNow")
                
                if digitalTimer and scaryStartsNow then
                    _G.msdoors_DigitalTimerValue = digitalTimer.Value
                    _G.msdoors_ScaryStartsNowValue = scaryStartsNow.Value
                    
                    digitalTimer:GetPropertyChangedSignal("Value"):Connect(function()
                        _G.msdoors_DigitalTimerValue = digitalTimer.Value
                        if _G.msdoors_HasteClockEnabled and _G.msdoors_ScaryStartsNowValue then
                            _G.msdoors_CLOCK_FUNCTIONS.Captions(_G.msdoors_CLOCK_FUNCTIONS.TimerFormat(_G.msdoors_DigitalTimerValue))
                        end
                    end)
                    
                    scaryStartsNow:GetPropertyChangedSignal("Value"):Connect(function()
                        _G.msdoors_ScaryStartsNowValue = scaryStartsNow.Value
                    end)
                    
                    local clientRemote = FloorReplicated:FindFirstChild("ClientRemote")
                    if clientRemote then
                        local internal_temp_mspaint = clientRemote:FindFirstChild("_mspaint")
                        if internal_temp_mspaint and #internal_temp_mspaint:GetChildren() ~= 0 then
                            local hasteFolder = clientRemote:FindFirstChild("Haste")
                            if hasteFolder then
                                for _, v in pairs(internal_temp_mspaint:GetChildren()) do
                                    v.Parent = hasteFolder
                                end
                            end
                            internal_temp_mspaint:Destroy()
                        end
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Error",
                        Text = "Required game elements not found",
                        Duration = 5
                    })
                end
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Error",
                    Text = "FloorReplicated not found",
                    Duration = 5
                })
            end
        end
    end,
})

local FloorReplicated = game:GetService("ReplicatedStorage"):FindFirstChild("FloorReplicated")

if FloorReplicated then
    local digitalTimer = FloorReplicated:FindFirstChild("DigitalTimer")
    local scaryStartsNow = FloorReplicated:FindFirstChild("ScaryStartsNow")
    
    if digitalTimer and scaryStartsNow then
        _G.msdoors_DigitalTimerValue = digitalTimer.Value
        _G.msdoors_ScaryStartsNowValue = scaryStartsNow.Value
        
        digitalTimer:GetPropertyChangedSignal("Value"):Connect(function()
            _G.msdoors_DigitalTimerValue = digitalTimer.Value
            if _G.msdoors_HasteClockEnabled and _G.msdoors_ScaryStartsNowValue then
                _G.msdoors_CLOCK_FUNCTIONS.Captions(_G.msdoors_CLOCK_FUNCTIONS.TimerFormat(_G.msdoors_DigitalTimerValue))
            end
        end)
        
        scaryStartsNow:GetPropertyChangedSignal("Value"):Connect(function()
            _G.msdoors_ScaryStartsNowValue = scaryStartsNow.Value
        end)
        
        local clientRemote = FloorReplicated:FindFirstChild("ClientRemote")
        if clientRemote then
            local internal_temp_mspaint = clientRemote:FindFirstChild("_mspaint")
            if internal_temp_mspaint and #internal_temp_mspaint:GetChildren() ~= 0 then
                local hasteFolder = clientRemote:FindFirstChild("Haste")
                if hasteFolder then
                    for _, v in pairs(internal_temp_mspaint:GetChildren()) do
                        v.Parent = hasteFolder
                    end
                end
                internal_temp_mspaint:Destroy()
            end
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "Required game elements not found",
            Duration = 5
        })
    end
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "FloorReplicated not found",
        Duration = 5
    })
		end
		
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

    local a90 = modules:FindFirstChild("A90") or 

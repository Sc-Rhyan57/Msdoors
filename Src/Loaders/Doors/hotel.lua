if _G.ObsidianaLib then
    warn("[Msdoors] • Script já carregado!")
    return
end
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
_G.msdoors_AntiSeekObstructions = _G.msdoors_AntiSeekObstructions or false
_G.msdoors_InstaInteractEnabled = _G.msdoors_InstaInteractEnabled or false
_G.msdoors_spamTools = _G.msdoors_spamTools or false
_G.msdoors_autocltpad = _G.msdoors_autocltpad or false
_G.msdoors_autoReviveEnabled = _G.msdoors_autoReviveEnabled or false
_G.msdoors_Brightness = _G.msdoors_Brightness or 0
_G.msdoors_Fullbright = _G.msdoors_Fullbright or false
_G.msdoors_NoFog = _G.msdoors_NoFog or false
_G.msdoorsNoCrouchBarriers = _G.msdoorsNoCrouchBarriers or false
_G.msdoors_disAutoLibrary = _G.msdoors_disAutoLibrary or 20
_G.msdoors_notpadlock = _G.msdoors_notpadlock or false
_G.MSDoors_WalkSpeed = _G.MSDoors_WalkSpeed or 15
_G.MSDoors_jumpEnabled = _G.MSDoors_jumpEnabled or false
_G.MSDoors_JumpBoost = _G.MSDoors_JumpBoost = or 4
_G.msdoorsDoorReach = _G.msdoorsDoorReach or false
_G.msdoors_FigureDeaf = _G.msdoors_FigureDeaf or false
_G.msdoors_NoAmbienceEnabled = _G.msdoors_NoAmbienceEnabled or false  
_G.msdoors_ThoughtsEnabled = _G.msdoors_ThoughtsEnabled or false
_G.msdoors_AntiGiggle = _G.msdoors_AntiGiggle or false
_G.msdoors_atualizarPropriedadesFisicas = _G.msdoors_atualizarPropriedadesFisicas or false
_G.msdoors_AntiSeekDoor = _G.msdoors_AntiSeekDoor or false
_G.msdoors_AntiSnare = _G.msdoors_AntiSnare or false
_G.msdoors_DupeRunning = _G.msdoors_DupeRunning or false
_G.msdoors_AntiGloomEgg = _G.msdoors_AntiGloomEgg or false
_G.msdoors_AntiDupe = _G.msdoors_AntiDupe or false
_G.msdoors_AntiFlood = _G.msdoors_AntiFlood or false
_G.msdoors_AntiSeekDoor = _G.msdoors_AntiSeekDoor or false
_G.msdoors_anticutscenes = _G.msdoors_anticutscenes or false
_G.msdoors_antijumpscares = _G.msdoors_antijumpscares or false
_G.msdoors_antia90 = _G.msdoors_antia90 or false
_G.msdoors_antiscreech = _G.msdoors_antiscreech or false
_G.msdoors_antiShade = _G.msdoors_antiShade or false
_G.msdoors_antidread = _G.msdoors_antidread or false
_G.MSDoors_SpeedBypass = _G.MSDoors_SpeedBypass or false
_G.MSDoors_SpeedBypassDelay = _G.MSDoors_SpeedBypassDelay or 0.23
_G.msdoors_CurrentlyUsingSGF = _G.msdoors_CurrentlyUsingSGF or false
_G.msdoors_SpeedBypassBeTurned = _G.msdoors_SpeedBypassBeTurned or nil
_G.msdoors_SpeedHackBeTurned = _G.msdoors_SpeedHackBeTurned or nil
_G.MaxActivationDistance = _G.MaxActivationDistance or 7
_G.PromptClip = _G.PromptClip or false
_G.msdoors_antieyes = _G.msdoors_antieyes or false
_G.MSDoors_SpeedBypass = _G.MSDoors_SpeedBypass or false
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
    if floorName == "Hotel" then --[[ HOTEL TAB ]]--
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
    elseif floorName == "Super Hard Mode" then --[[ SUPER HARD MODE TAB ]]--
	local GroupHotel = Tabs.Hotel:AddLeftGroupbox("Floor Functions")
	local GroupPlayerFools = Tabs.Hotel:AddLeftGroupbox("Player")
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
            _G.msdoors_bananaOGproperties[child] = nil
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

GroupPlayerFools:AddButton({
    Text = 'Revive',
    Func = function()
        game:GetService("ReplicatedStorage").EntityInfo.Revive:FireServer()
    end,
    DoubleClick = false,
    Tooltip = 'Click to revive'
})

local connectionAliveCheck = nil
GroupPlayerFools:AddToggle('AutoRevive', {
    Text = 'Auto Revive',
    Default = _G.msdoors_autoReviveEnabled,
    Tooltip = 'Automatically revive when dead',
    Callback = function(Value)
        _G.msdoors_autoReviveEnabled = Value
        
        if _G.msdoors_autoReviveEnabled then
            connectionAliveCheck = game:GetService("RunService").RenderStepped:Connect(function()
                local isAlive = game:GetService("Players").LocalPlayer:GetAttribute("Alive")
                
                if isAlive == false then
                    game:GetService("ReplicatedStorage").EntityInfo.Revive:FireServer()
                end
            end)
        else
            if connectionAliveCheck then
                connectionAliveCheck:Disconnect()
                connectionAliveCheck = nil
            end
        end
    end
})
		
    elseif floorName == "Retro Mode" then --[[ RETRO MODE TAB ]]--
        print("[ Msdoors ] » Carregando funções da página Hotel para Fools24.")
    elseif floorName == "Ranked" then --[[ RANKED MODE TAB ]]--
        print("[ Msdoors ] » Carregando funções da página Hotel para Ranked25..")
	local GroupRankedPlayer = Tabs.Hotel:AddLeftGroupbox("Local")
	local GroupHotel = Tabs.Hotel:AddLeftGroupbox("Floor Functions")
	local player = Players.LocalPlayer
	        --[[ ANTI GIGGLE ]]--
GroupHotel:AddToggle("Anti-Giggle", {
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
-- game:GetService("ReplicatedStorage").ProjectileResults.NannerPeel
local function destroyAllBananaPeel()
    for _, child in ipairs(workspace:GetChildren()) do
        if child.Name == "NannerPeel" then
            modifyBanana(child, _G.msdoors_AntiBanana)
        end
    end
end

workspace.ChildAdded:Connect(function(child)
    if _G.msdoors_AntiBanana and child.Name == "NannerPeel" then
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
		
		--[[ ANTI A-90 ]]--
    local function toggleA90(enabled)
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

GroupHotel:AddToggle("Anti-A90", {
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

local function interactWithItemPads()
    while _G.msdoors_autocltpad do
        local success, err = pcall(function()
            local roomId = player:GetAttribute("CurrentRoom")
            if not roomId then return end
            local room = workspace.CurrentRooms:FindFirstChild(tostring(roomId))
            if room then
                local itemPads = room:FindFirstChild("ItemPads")
                if itemPads then
                    for _, item in ipairs(itemPads:GetChildren()) do
                        local hitbox = item:FindFirstChild("Hitbox")
                        if hitbox then
                            hitbox.Size = Vector3.new(20, 20, 20)

                            local touchInterest = hitbox:FindFirstChildWhichIsA("TouchTransmitter")
                            if touchInterest then
                                firetouchinterest(player.Character.HumanoidRootPart, hitbox, 0)
                                firetouchinterest(player.Character.HumanoidRootPart, hitbox, 1)
                            end
                        end

                        if item:IsA("ClickDetector") then
                            fireclickdetector(item)
                        elseif item:IsA("ProximityPrompt") then
                            fireproximityprompt(item)
                        end
                    end
                end
            end
        end)

        if not success then
            warn("[ Msdoors ] » AutoPowerUP: ", err)
        end
        RunService.Heartbeat:Wait()
    end
end

GroupRankedPlayer:AddToggle("PowerupPad", {
    Text = "AutoPowerUP",
    Default = false,
    Tooltip = "Automatically collects power-ups.",
    Callback = function(state)
    _G.msdoors_autocltpad = state
    if state then
        task.spawn(interactWithItemPads)
	end
    end
})
    elseif floorName == "Backdoor" then --[[ BACKDOOR TAB ]]--
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


_G.msdoors_ProcessedGloomEggs = {}
_G.msdoors_GloomEggConnection = nil

GroupHotel:AddToggle("AntiGloomEgg", {
    Text = "Anti Gloom Egg",
    Default = _G.msdoors_AntiGloomEgg,
    Callback = function(value)
        _G.msdoors_AntiGloomEgg = value

        local function processGloomEgg(gloomEgg)
            if value then
                if not _G.msdoors_ProcessedGloomEggs[gloomEgg] then
                    _G.msdoors_ProcessedGloomEggs[gloomEgg] = gloomEgg.CanTouch
                end
                gloomEgg.CanTouch = false
            else
                if _G.msdoors_ProcessedGloomEggs[gloomEgg] ~= nil then
                    gloomEgg.CanTouch = _G.msdoors_ProcessedGloomEggs[gloomEgg]
                    _G.msdoors_ProcessedGloomEggs[gloomEgg] = nil
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

        if value and not _G.msdoors_GloomEggConnection then
            _G.msdoors_GloomEggConnection = workspace.CurrentRooms.ChildAdded:Connect(function(room)
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
        elseif not value and _G.msdoors_GloomEggConnection then
            _G.msdoors_GloomEggConnection:Disconnect()
            _G.msdoors_GloomEggConnection = nil
        end
    end
})

_G.msdoors_SnareConnection = nil

GroupModifiers:AddToggle("Anti-Snare", {
    Text = "Anti Snare",
    Default = _G.msdoors_AntiSnare,
    Callback = function(state)
        _G.msdoors_AntiSnare = state

        if state and not _G.msdoors_SnareConnection then
            _G.msdoors_SnareConnection = workspace.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "Snare" then
                    local hitbox = descendant:FindFirstChild("Hitbox")
                    if hitbox then
                        hitbox.CanTouch = false
                    end
                end
            end)
        elseif not state and _G.msdoors_SnareConnection then
            _G.msdoors_SnareConnection:Disconnect()
            _G.msdoors_SnareConnection = nil
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

_G.msdoors_TempBridges = {}
_G.msdoors_BridgeConnection = nil

local function ProtectBridges(room)
    if not room:FindFirstChild("Parts") then return end

    for _, bridge in pairs(room.Parts:GetChildren()) do
        if bridge.Name == "Bridge" then
            for _, barrier in pairs(bridge:GetChildren()) do
                if not (barrier.Name == "PlayerBarrier" and barrier.Size.Y == 2.75 and (barrier.Rotation.X == 0 or barrier.Rotation.X == 180)) then 
                    continue 
                end

                local clone = barrier:Clone()
                clone.CFrame = clone.CFrame * CFrame.new(0, 0, -5)
                clone.Color = Color3.new(1, 1, 1)
                clone.Name = "AntiBridge"
                clone.Size = Vector3.new(clone.Size.X, clone.Size.Y, 11)
                clone.Transparency = 0
                clone.Parent = bridge

                table.insert(_G.msdoors_TempBridges, clone)
            end
        end
    end
end

GroupHotel:AddToggle("AntiSeekObstructions", {
    Text = "Anti Bridge Fall",
    Default = _G.msdoors_AntiSeekObstructions,
    Callback = function(value)
        _G.msdoors_AntiSeekObstructions = value

        if value then
            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                ProtectBridges(room)
            end
            _G.msdoors_BridgeConnection = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                ProtectBridges(room)
            end)
        else
            for _, bridge in pairs(_G.msdoors_TempBridges) do
                if bridge and bridge.Parent then
                    bridge:Destroy()
                end
            end
            _G.msdoors_TempBridges = {}

            if _G.msdoors_BridgeConnection then
                _G.msdoors_BridgeConnection:Disconnect()
                _G.msdoors_BridgeConnection = nil
            end
        end
    end
})

--[[ ANTI SEEK DOOR ]]--
_G.msdoors_SeekDoorConnection = nil
_G.msdoors_ModifiedDoors = {}

local function HandleSeekDoors(instance)
    if instance.Name == "SewerRingBreakable" then
        for _, child in pairs(instance:GetDescendants()) do
            if child:IsA("BasePart") and (child.Name == "DoorPart" or (string.find(child.Name, "Door") and string.find(child.Name, "[Pp]art"))) then
                if _G.msdoors_AntiSeekDoor then
                    if not _G.msdoors_ModifiedDoors[child] then
                        _G.msdoors_ModifiedDoors[child] = {
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
    for part, data in pairs(_G.msdoors_ModifiedDoors) do
        if part and part.Parent then
            part.CanCollide = data.CanCollide
        end
    end
    _G.msdoors_ModifiedDoors = {}
end

GroupHotel:AddToggle("antikickdoor", {
    Text = "Anti Kickdoor",
    DisabledTooltip = "I am disabled!",
    Default = _G.msdoors_AntiSeekDoor,
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
            
            if not _G.msdoors_SeekDoorConnection then
                _G.msdoors_SeekDoorConnection = workspace.DescendantAdded:Connect(function(instance)
                    HandleSeekDoors(instance)
                end)
            end
        else
            RestoreSeekDoors()

            if _G.msdoors_SeekDoorConnection then
                _G.msdoors_SeekDoorConnection:Disconnect()
                _G.msdoors_SeekDoorConnection = nil
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
        ["A60"] = { ["Image"] = "12350986086", ["Title"] = "A-60", ["Description"] = "A-60 surgiu!" },
        ["A120"] = { ["Image"] = "12351008553", ["Title"] = "A-120", ["Description"] = "A-120 surgiu!" },
        ["BackdoorRush"] = { ["Image"] = "11102256553", ["Title"] = "Blitz", ["Description"] = "Blitz surgiu!" },
        ["RushMoving"] = { ["Image"] = "11102256553", ["Title"] = "Rush", ["Description"] = "Rush surgiu!" },
        ["AmbushMoving"] = { ["Image"] = "10938726652", ["Title"] = "Ambush", ["Description"] = "Ambush surgiu!" },
        ["Eyes"] = { ["Image"] = "10865377903", ["Title"] = "Eyes", ["Description"] = "Eyes surgiu!!" },
        ["BackdoorLookman"] = { ["Image"] = "16764872677", ["Title"] = "Lookman", ["Description"] = "Lookman surgiu!" },
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
Notify({
    Title = notificationData.Title,
    Description = notificationData.Description,
    Reason = "",
    Image = "rbxassetid://" .. notificationData.Image,
    Color = Color3.fromRGB(255, 0, 0),
    Style = "ENTITIES",
    Duration = 6,
    NotifyStyle = _G.msdoors_LibraryNotif
})

--[[ EMBED ]]--
        SendEmbed({
            username = "Msdoors bot",
            avatar_url = "https://msdoors-gg.vercel.app/favicon.ico",
            content = "dsc.gg/msdoors-gg",      
            title = notificationData.Title,             
            description = notificationData.Description,          
            url = "https://dsc.gg/msdoors-gg",       
            color = 65280,                                 
            author_name = notificationData.Title,
            author_url = "https://msdoors-gg.vercel.app/shop",
            author_icon_url = "https://msdoors-gg.vercel.app/favicon.ico",
            footer_text = "msdoors • " .. game.JobId,
            footer_icon_url = "https://discord.com/favicon.ico",
            image_url = "",
            thumbnail_url = "https://msdoors-gg.vercel.app/favicon.ico",
            fields = { }
        })
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
	    Notify({
    Title = roomData.Title,
    Description = roomData.Description,
    Reason = "",
    Image = "rbxassetid://" .. roomData.Image,
    Color = Color3.fromRGB(255, 0, 0),
    Style = "EVENT",
    Duration = 6,
    NotifyStyle = _G.msdoors_LibraryNotif
    })

--[[ EMBED ]]--
        SendEmbed({
            username = "Msdoors bot",
            avatar_url = "https://msdoors-gg.vercel.app/favicon.ico",
            content = "dsc.gg/msdoors-gg",      
            title = roomData.Title,             
            description = roomData.Description,          
            url = "https://dsc.gg/msdoors-gg",       
            color = 65280,                                 
            author_name = roomData.Title,
            author_url = "https://msdoors-gg.vercel.app/shop",
            author_icon_url = "https://msdoors-gg.vercel.app/favicon.ico",
            footer_text = "msdoors • " .. game.JobId,
            footer_icon_url = "https://discord.com/favicon.ico",
            image_url = "",
            thumbnail_url = "https://msdoors-gg.vercel.app/favicon.ico",
            fields = { }
        })
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
            Color = _G.msdoors_DoorEspColor
        }
    },
    Settings = {
        MaxDistance = 5000,
        UpdateInterval = 5,
        TextSize = _G.msdoors_TextSize,
        FillTransparency = 0.75,
        OutlineTransparency = _G.msdoors_OutlineTr,
        TracerStartPosition = _G.msdoors_tracePos,
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
            Enabled = _G.msdoors_tracerSt,
            From = DoorESPConfig.Settings.TracerStartPosition,
            Color = config.Color
        },
        
        Arrow = {
            Enabled = _G.msdoors_arrowSt,
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
            Color = _G.msdoors_entityColor
        },
        AmbushMoving = {
            Name = "Ambush", 
            Color = _G.msdoors_entityColor
        },
        Snare = {
            Name = "Armadilha",
            Color = _G.msdoors_entityColor
        },
        FigureRig = {
            Name = "Figure",
            Color = _G.msdoors_entityColor
        },
        A60 = {
            Name = "A-60",
            Color = _G.msdoors_entityColor
        },
        A120 = {
            Name = "A-120",
            Color = _G.msdoors_entityColor
        },
        GiggleCeiling = {
            Name = "Giggle",
            Color = _G.msdoors_entityColor
        },
        GrumbleRig = {
            Name = "Grumle",
            Color = _G.msdoors_entityColor
        },
        BackdoorRush = {
            Name = "Blitz",
            Color = _G.msdoors_entityColor
        },
        Entity10 = {
            Name = "Entidade 10",
            Color = _G.msdoors_entityColor
        }
    },
    Settings = {
        MaxDistance = 5000,
        UpdateInterval = 5,
        TextSize = _G.msdoors_TextSize,
        FillTransparency = 0.75,
        OutlineTransparency = _G.msdoors_OutlineTr,
        TracerStartPosition = _G.msdoors_tracePos,
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
            Enabled = _G.msdoors_tracerSt,
            From = EntityESPConfig.Settings.TracerStartPosition,
            Color = config.Color
        },
        
        Arrow = {
            Enabled = _G.msdoors_arrowSt,
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
            Color = _G.msdoors_objectiveColor
        },
        LeverForGate = {
            Name = "Alavanca",
            Color = _G.msdoors_objectiveColor
        },
        ElectricalKeyObtain = {
            Name = "Chave elétrica",
            Color = _G.msdoors_objectiveColor
        },
        LiveHintBook = {
            Name = "Livro",
            Color = _G.msdoors_objectiveColor
        },
        LiveBreakerPolePickup = {
            Name = "Disjuntor",
            Color = _G.msdoors_objectiveColor
        },
        MinesGenerator = {
            Name = "Gerador",
            Color = _G.msdoors_objectiveColor
        },
        MinesGateButton = {
            Name = "Botão do portão",
            Color = _G.msdoors_objectiveColor
        },
        FuseObtain = {
            Name = "Fusível",
            Color = _G.msdoors_objectiveColor
        },
        MinesAnchor = {
            Name = "Torre",
            Color = _G.msdoors_objectiveColor
        },
        WaterPump = {
            Name = "Bomba de água",
            Color = _G.msdoors_objectiveColor
        }
    },
    Settings = {
        MaxDistance = 5000,
        UpdateInterval = 5,
        TextSize = _G.msdoors_TextSize,
        FillTransparency = 0.75,
        OutlineTransparency = _G.msdoors_OutlineTr,
        TracerStartPosition = _G.msdoors_tracePos,
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
            Enabled = _G.msdoors_tracerSt,
            From = ObjectiveESPConfig.Settings.TracerStartPosition,
            Color = config.Color
        },
        
        Arrow = {
            Enabled = _G.msdoors_arrowSt,
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
        TextSize = _G.msdoors_TextSize,
        FillTransparency = 0.75,
        OutlineTransparency = _G.msdoors_OutlineTr,
        TracerStartPosition = _G.msdoors_tracePos,
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
}):AddColorPicker("ObjectiveEsp-color", {
		Default = Color3.new(0, 255, 0),
		Title = "Selecione Uma cor",
		Transparency = 0,
		Callback = function(Value)
		_G.msdoors_objectiveColor = Value
                for _, esp in pairs(ObjectiveESPManager.ActiveESPs) do
                if esp then
                esp.Update({
                    FillColor = Value,
                    OutlineColor = Value,
                    TextColor = Value,
                })
                end
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
}):AddColorPicker("EntityEsp-color", {
		Default = Color3.new(255, 0, 0),
		Title = "Selecione Uma cor",
		Transparency = 0,
		Callback = function(Value)
	        _G.msdoors_entityColor = Value
                for _, esp in pairs(EntityESPManager.ActiveESPs) do
                if esp then
                esp.Update({
                    FillColor = Value,
                    OutlineColor = Value,
                    TextColor = Value,
                })
                end
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
}):AddColorPicker("DoorsEsp-color", {
		Default = Color3.fromRGB(100, 200, 255),
		Title = "Selecione Uma cor",
		Transparency = 0,
		Callback = function(Value)
		_G.msdoors_DoorEspColor = Value
                for _, esp in pairs(DoorESPManager.ActiveESPs) do
                if esp then
                esp.Update({
                    FillColor = Value,
                    OutlineColor = Value,
                    TextColor = Value,
                })
                end
		end
		end,
	})

game.Players.LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    if DoorESPManager.IsEnabled then
        DoorESPManager:ScanRoom()
    end
end)

GroupEspConfig:AddToggle("TracersEnabled", {
    Text = "Tracers",
    Default = false,
    Callback = function(Value)
        _G.msdoors_tracerSt = Value
        for _, esp in pairs(DoorESPManager.ActiveESPs) do
            if esp and esp.Update then
                esp.Update({
                    Tracer = {
                        Enabled = Value,
                        From = _G.msdoors_tracePos
                    }
                })
            end
        end
    end
})


GroupEspConfig:AddDropdown("LocalTrace", {
    Values = {"Bottom", "Center", "Top", "Mouse"},
    Default = "Bottom",
    Multi = false,
    Text = "Tracer Location",
    DisabledTooltip = "I am disabled!",
    Callback = function(Value)
        _G.msdoors_tracePos = Value
        for _, category in pairs(ESPLibrary.ESP) do
            if typeof(category) == "table" then
                for _, esp in pairs(category) do
                    if esp and esp.Update and _G.msdoors_tracerSt then
                        esp.Update({
                            Tracer = {
                                Enabled = _G.msdoors_tracerSt,
                                From = Value,
                                Color = _G.msdoors_DoorEspColor
                            }
                        })
                    end
                end
            end
        end
    end,
    Disabled = false, 
    Visible = true
})


GroupVPlayer:AddToggle("Visual-no-ambience", {
	Text = "No Ambience",
	DisabledTooltip = "I am disabled!",
	Default = _G.msdoors_NoAmbienceEnabled,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        _G.msdoors_NoAmbienceEnabled = Value  

        if not game.SoundService:FindFirstChild("AmbienceRemove") then
            local ambiencerem = Instance.new("BoolValue")
            ambiencerem.Name = "AmbienceRemove"
            ambiencerem.Parent = game.SoundService
        end

        if _G.msdoors_NoAmbienceEnabled then
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

_G.msdoors_fullbrightConnection = nil
GroupAmbient:AddSlider("Brightness", {
    Text = "Brilho",
    Default = _G.msdoors_Brightness,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Callback = function(value)
        _G.msdoors_Brightness = value
        Lighting.Brightness = value
    end
})

GroupAmbient:AddToggle("Fullbright", {
   Text = "Brilho total",
   Default = _G.msdoors_Fullbright,
   Callback = function(value)
       _G.msdoors_Fullbright = value
       
       if value then
           Lighting.Ambient = Color3.new(1, 1, 1)
           
           if _G.msdoors_fullbrightConnection then
               _G.msdoors_fullbrightConnection:Disconnect()
           end
           
           _G.msdoors_fullbrightConnection = game:GetService("RunService").RenderStepped:Connect(function()
               Lighting.Ambient = Color3.new(1, 1, 1)
           end)
       else
           if _G.msdoors_fullbrightConnection then
               _G.msdoors_fullbrightConnection:Disconnect()
               _G.msdoors_fullbrightConnection = nil
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
    Default = _G.msdoors_NoFog,
    Callback = function(value)
        _G.msdoors_NoFog = value
        
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
    if _G.msdoors_Brightness then
        Lighting.Brightness = _G.msdoors_Brightness
    end
end)

Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
    if _G.msdoors_Fullbright then
        Lighting.Ambient = Color3.new(1, 1, 1)
    end
end)

Lighting:GetPropertyChangedSignal("FogStart"):Connect(function()
    if _G.msdoors_NoFog then
        Lighting.FogStart = 0
    end
end)

Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
    if _G.msdoors_NoFog then
        Lighting.FogEnd = math.huge
    end
end)

_G.msdoors_Toggles = _G.msdoors_Toggles or {}  
local function UpdateProximityPrompts()
    for _, prompt in pairs(workspace.CurrentRooms:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            if _G.msdoors_InstaInteractEnabled then
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
        if _G.msdoors_InstaInteractEnabled then
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
	Default = _G.msdoors_InstaInteractEnabled,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(value)
        _G.msdoors_InstaInteractEnabled = value
        UpdateProximityPrompts()
	end,
})


_G.msdoors = _G.msdoors or {}
_G.msdoors.autoInteract = {
    Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait(),
    LocalPlayer = game.Players.LocalPlayer,
    Humanoid = nil,
    Enabled = false,
    IgnoreSettings = {
        ["Jeff Items"] = true,
        ["Unlock w/ Lockpick"] = false,
        ["Paintings"] = true,
        ["Gold"] = false,
        ["Light Source Items"] = false,
        ["Skull Prompt"] = false
    }
}

local function InitializeScript()
    _G.msdoors.autoInteract.Humanoid = _G.msdoors.autoInteract.Character:WaitForChild("Humanoid")
    game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
        _G.msdoors.autoInteract.Character = char
        _G.msdoors.autoInteract.Humanoid = char:WaitForChild("Humanoid")
    end)
end

_G.msdoors.autoInteract.fireproximityprompt = function(prompt)
    if prompt.ClassName == "ProximityPrompt" then
        fireproximityprompt(prompt)
    end
end

_G.msdoors.autoInteract.Script = {
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

_G.msdoors.autoInteract.Script.Functions = {
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
        if not _G.msdoors.autoInteract.Character or not _G.msdoors.autoInteract.Character:FindFirstChild("HumanoidRootPart") or not object then
            return math.huge
        end
        local objectPosition = object:IsA("BasePart") and object.Position or 
                             object:FindFirstChild("HumanoidRootPart") and object.HumanoidRootPart.Position or
                             object:FindFirstChildWhichIsA("BasePart") and object:FindFirstChildWhichIsA("BasePart").Position
        if not objectPosition then
            return math.huge
        end
        return (_G.msdoors.autoInteract.Character.HumanoidRootPart.Position - objectPosition).Magnitude
    end,
    
    IsExcluded = function(prompt)
        local Script = _G.msdoors.autoInteract.Script
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

--// Este sistema de auto interact é originalmente dá mspaint \\--

GroupAuto:AddToggle("Auto-interact", {
	Text = "Auto Interact",
	DisabledTooltip = "I am disabled!",
	Default = _G.msdoors.autoInteract.Enabled,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        _G.msdoors.autoInteract.Enabled = Value
	end,
}):AddKeyPicker("KeyP-autointeract", {
	Default = "P",
	SyncToggleState = true,
	Mode = "Toggle",
	Text = "Auto interact",
	NoUI = false,
	Callback = function(Value)
        _G.msdoors.autoInteract.Enabled = Value
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
        for k, _ in pairs(_G.msdoors.autoInteract.IgnoreSettings) do
            _G.msdoors.autoInteract.IgnoreSettings[k] = false
        end
        for _, v in pairs(Value) do
            _G.msdoors.autoInteract.IgnoreSettings[v] = true
        end
	end,
	Disabled = false,
	Visible = true, 
})

local function AutoInteractLoop()
    while true do
        task.wait()
        if _G.msdoors.autoInteract.Enabled then
            local prompts = _G.msdoors.autoInteract.Script.Functions.GetAllPromptsWithCondition(function(prompt)
                if not prompt.Parent then return false end
                if _G.msdoors.autoInteract.IgnoreSettings["Jeff Items"] and prompt.Parent:GetAttribute("JeffShop") then return false end
                if _G.msdoors.autoInteract.IgnoreSettings["Unlock w/ Lockpick"] and (prompt.Name == "UnlockPrompt" or prompt.Parent:GetAttribute("Locked")) and _G.msdoors.autoInteract.Character:FindFirstChild("Lockpick") then return false end
                if _G.msdoors.autoInteract.IgnoreSettings["Paintings"] and prompt.Name == "PropPrompt" then return false end
                if _G.msdoors.autoInteract.IgnoreSettings["Gold"] and prompt.Name == "LootPrompt" then return false end
                if _G.msdoors.autoInteract.IgnoreSettings["Light Source Items"] and prompt.Parent:GetAttribute("Tool_LightSource") and not prompt.Parent:GetAttribute("Tool_CanCutVines") then return false end
                if _G.msdoors.autoInteract.IgnoreSettings["Skull Prompt"] and prompt.Name == "SkullPrompt" then return false end
                if prompt.Parent:GetAttribute("PropType") == "Battery" and not (_G.msdoors.autoInteract.Character:FindFirstChildOfClass("Tool") and (_G.msdoors.autoInteract.Character:FindFirstChildOfClass("Tool"):GetAttribute("RechargeProp") == "Battery" or _G.msdoors.autoInteract.Character:FindFirstChildOfClass("Tool"):GetAttribute("StorageProp") == "Battery")) then return false end 
                if prompt.Parent:GetAttribute("PropType") == "Heal" and _G.msdoors.autoInteract.Humanoid and _G.msdoors.autoInteract.Humanoid.Health == _G.msdoors.autoInteract.Humanoid.MaxHealth then return false end
                if prompt.Parent.Name == "MinesAnchor" then return false end
                if _G.msdoors.autoInteract.Script.IsRetro and prompt.Parent.Parent.Name == "RetroWardrobe" then return false end
                return _G.msdoors.autoInteract.Script.PromptTable.Aura[prompt.Name] ~= nil
            end)

            for _, prompt in pairs(prompts) do
                task.spawn(function()
                    if _G.msdoors.autoInteract.Script.Functions.DistanceFromCharacter(prompt.Parent) < prompt.MaxActivationDistance and (not prompt:GetAttribute("Interactions" .. _G.msdoors.autoInteract.LocalPlayer.Name) or _G.msdoors.autoInteract.Script.PromptTable.Aura[prompt.Name] or table.find(_G.msdoors.autoInteract.Script.PromptTable.AuraObjects, prompt.Parent.Name)) then
                        if prompt.Parent.Name == "Slot" and prompt.Parent:GetAttribute("Hint") then
                            if _G.msdoors.autoInteract.Script.Temp.PaintingDebounce[prompt] then return end
                            local currentPainting = _G.msdoors.autoInteract.Character:FindFirstChild("Prop")
                            local slotPainting = prompt.Parent:FindFirstChild("Prop")
                            local currentHint = (currentPainting and currentPainting:GetAttribute("Hint"))
                            local slotHint = (slotPainting and slotPainting:GetAttribute("Hint"))
                            local promptHint = prompt.Parent:GetAttribute("Hint")
                            if slotHint ~= promptHint and (currentHint == promptHint or slotPainting) then
                                _G.msdoors.autoInteract.Script.Temp.PaintingDebounce[prompt] = true
                                _G.msdoors.autoInteract.fireproximityprompt(prompt)
                                task.wait(0.3)
                                _G.msdoors.autoInteract.Script.Temp.PaintingDebounce[prompt] = false    
                            end
                            return
                        end
                        _G.msdoors.autoInteract.fireproximityprompt(prompt)
                    end
                end)
            end
        end
    end
end
InitializeScript()
task.spawn(AutoInteractLoop)

_G.padlocknotify_chatActive = _G.padlocknotify_chatActive or false

local function padlocknotify(message)
    if _G.padlocknotify_chatActive then
        local TextChatService = game:GetService("TextChatService")

        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local textChannel = TextChatService.TextChannels.RBXGeneral
            textChannel:SendAsync(message)
        else
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        end
    end
end


GroupAuto:AddDivider()
GroupAuto:AddToggle("AutoLibrarySolver", {
    Text = "Auto Library Solver",
    Default = false,
    Callback = function(value)
        if value then
            for _, player in pairs(game.Players:GetPlayers()) do
                local character = player.Character
                if character then
                    character.ChildAdded:Connect(function(child)
                        if not (child:IsA("Tool") and child.Name:match("LibraryHintPaper")) then return end

                        task.wait(0.1)
                        local codeData = {}

                        if child:FindFirstChild("UI") then
                            for _, img in pairs(child.UI:GetChildren()) do
                                if img:IsA("ImageLabel") and tonumber(img.Name) then
                                    codeData[img.ImageRectOffset.X .. img.ImageRectOffset.Y] = {tonumber(img.Name), "_"}
                                end
                            end
                        end

                        for _, img in pairs(game.Players.LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()) do
                            if img.Name == "Icon" and codeData[img.ImageRectOffset.X .. img.ImageRectOffset.Y] then
                                codeData[img.ImageRectOffset.X .. img.ImageRectOffset.Y][2] = img.TextLabel.Text
                            end
                        end

                        local finalCode = {}
                        for _, num in pairs(codeData) do
                            finalCode[num[1]] = num[2]
                        end
                        local codeString = table.concat(finalCode)

                        local padlock = workspace:FindFirstChild("Padlock", true)
                        if tonumber(codeString) and padlock and (padlock.PrimaryPart.Position - game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude <= _G.msdoors_disAutoLibrary then
                            local code = { [1] = codeString }
                            game:GetService("ReplicatedStorage").RemotesFolder.PL:FireServer(unpack(code))
                        end
			SendEmbed({
                             username = "Msdoors bot",
                             avatar_url = "https://msdoors-gg.vercel.app/favicon.ico",
                             content = "dsc.gg/msdoors-gg",      
                             title = "PadLock Code",             
                             description = string.format("Código da biblioteca: %s", codeString),          
                             url = "",       
                             color = 65280,                                 
                             author_name = "Padlock code",
                             author_url = "",
                             author_icon_url = "https://msdoors-gg.vercel.app/favicon.ico",
                             footer_text = "msdoors • " .. game.JobId,
                             footer_icon_url = "https://msdoors-gg.vercel.app/favicon.ico",
                             image_url = "",
                             thumbnail_url = "https://msdoors-gg.vercel.app/favicon.ico",
                             fields = { }
                         })
			if _G.padlocknotify_chatActive then
			   Notify({
                            Title = "Padlock Code",
                            Description = string.format("Código da biblioteca: %s", codeString),
                            Reason = tonumber(codeString) and "Resolvi o código do cadeado da biblioteca" or "Ainda faltam alguns livros",
                            Image = "rbxassetid://",
                            Color = Color3.fromRGB(255, 0, 0),
                            Style = "SISTEMA",
                            Duration = 6,
                            NotifyStyle = _G.msdoors_LibraryNotif
                        })
									
			padlocknotify(string.format("Código da biblioteca: %s", codeString))
			else
			print(string.format("Código da biblioteca: %s", codeString))
			end
							
                    end)
                end
            end
        end
    end
})

GroupAuto:AddSlider("autolibrarydistance", {
	Text = "Distance to open",
	Default = _G.msdoors_disAutoLibrary,
	Min = 0,
	Max = 120,
	Rounding = 1,
	Compact = true,
	Callback = function(Value)
		_G.msdoors_disAutoLibrary = Value
	end,
	DisabledTooltip = "I am disabled!",
	Disabled = false,
})

_G.MSDoors_FeatureConnections = {
    Character = {},
    Humanoid = {}
}

GroupPlayer:AddToggle("EnableJump", {
    Text = "Habilitar Pulo",
    Default = false
}):OnChanged(function(value)
    local character = LocalPlayer.Character
    if character then
        character:SetAttribute("CanJump", value) 
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpHeight = value and _G.MSDoors_JumpBoost or 0
        end
    end
    
    _G.MSDoors_jumpEnabled = value
    if character and not _G.MSDoors_FeatureConnections.Character["CanJump"] then
        if _G.MSDoors_FeatureConnections.Character["CanJump"] then
            _G.MSDoors_FeatureConnections.Character["CanJump"]:Disconnect()
        end
        
        _G.MSDoors_FeatureConnections.Character["CanJump"] = character:GetAttributeChangedSignal("CanJump"):Connect(function()
            if not _G.MSDoors_jumpEnabled then return end
            
            if not character:GetAttribute("CanJump") then
                character:SetAttribute("CanJump", true)
            end
        end)
    end

    if not value and _G.MSDoors_SpeedBypass ~= nil and not _G.MSDoors_SpeedBypass then
        if _G.LastSpeed and _G.LastSpeed > 0 then
            _G.MSDoors_WalkSpeed = _G.LastSpeed
            _G.LastSpeed = 0
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
    _G.MSDoors_JumpBoost = value
    if character and humanoid and not _G.MSDoors_FeatureConnections.Humanoid["Jump"] then
        if _G.MSDoors_FeatureConnections.Humanoid["Jump"] then
            _G.MSDoors_FeatureConnections.Humanoid["Jump"]:Disconnect()
        end
        _G.MSDoors_FeatureConnections.Humanoid["Jump"] = humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
            if _G.MSDoors_jumpEnabled then
                humanoid.JumpHeight = _G.MSDoors_JumpBoost
            end
            if _G.MSDoors_SpeedBypass ~= nil then
                if not _G.MSDoors_SpeedBypass then
                    if humanoid.JumpHeight > 0 then
                        _G.LastSpeed = _G.MSDoors_WalkSpeed
                        _G.MSDoors_WalkSpeed = math.min(_G.MSDoors_WalkSpeed, 18)
                    elseif _G.LastSpeed and _G.LastSpeed > 0 then
                        _G.MSDoors_WalkSpeed = _G.LastSpeed
                        _G.LastSpeed = 0
                    end
                end
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    for _, oldConnection in pairs(_G.MSDoors_FeatureConnections.Character) do
        if oldConnection.Connected then
            oldConnection:Disconnect()
        end
    end
    
    for _, oldConnection in pairs(_G.MSDoors_FeatureConnections.Humanoid) do
        if oldConnection.Connected then
            oldConnection:Disconnect()
        end
    end
    
    _G.MSDoors_FeatureConnections.Character = {}
    _G.MSDoors_FeatureConnections.Humanoid = {}

    character:SetAttribute("CanJump", _G.MSDoors_jumpEnabled)
    
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.JumpHeight = _G.MSDoors_jumpEnabled and _G.MSDoors_JumpBoost or 0
    
    _G.MSDoors_FeatureConnections.Character["CanJump"] = character:GetAttributeChangedSignal("CanJump"):Connect(function()
        if not _G.MSDoors_jumpEnabled then return end
        
        if not character:GetAttribute("CanJump") then
            character:SetAttribute("CanJump", true)
        end
    end)
    
    _G.MSDoors_FeatureConnections.Humanoid["Jump"] = humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
        if _G.MSDoors_jumpEnabled then
            humanoid.JumpHeight = _G.MSDoors_JumpBoost
        end
        
        if _G.MSDoors_SpeedBypass ~= nil then
            if not _G.MSDoors_SpeedBypass then
                if humanoid.JumpHeight > 0 then
                    _G.LastSpeed = _G.MSDoors_WalkSpeed
                    _G.MSDoors_WalkSpeed = math.min(_G.MSDoors_WalkSpeed, 18)
                elseif _G.LastSpeed and _G.LastSpeed > 0 then
                    _G.MSDoors_WalkSpeed = _G.LastSpeed
                    _G.LastSpeed = 0
                end
            end
        end
    end)
end)

if LocalPlayer.Character then
    local character = LocalPlayer.Character
    character:SetAttribute("CanJump", _G.MSDoors_jumpEnabled or false)
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpHeight = (_G.MSDoors_jumpEnabled and _G.MSDoors_JumpBoost) or 0
    end
    _G.MSDoors_FeatureConnections.Character["CanJump"] = character:GetAttributeChangedSignal("CanJump"):Connect(function()
        if not _G.MSDoors_jumpEnabled then return end
        
        if not character:GetAttribute("CanJump") then
            character:SetAttribute("CanJump", true)
        end
    end)
    
    if humanoid then
        _G.MSDoors_FeatureConnections.Humanoid["Jump"] = humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
            if _G.MSDoors_jumpEnabled then
                humanoid.JumpHeight = _G.MSDoors_JumpBoost
            end
            
            if _G.MSDoors_SpeedBypass ~= nil then
                if not _G.MSDoors_SpeedBypass then
                    if humanoid.JumpHeight > 0 then
                        _G.LastSpeed = _G.MSDoors_WalkSpeed
                        _G.MSDoors_WalkSpeed = math.min(_G.MSDoors_WalkSpeed, 18)
                    elseif _G.LastSpeed and _G.LastSpeed > 0 then
                        _G.MSDoors_WalkSpeed = _G.LastSpeed
                        _G.LastSpeed = 0
                    end
                end
            end
        end)
    end
end



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
    Default = _G.msdoors_antilag.Enabled,
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
        _G.msdoors_antiscreech = Value
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


_G.msdoors_DupeOriginals = {}
_G.msdoors_DupeConnection = nil

local DupeName = (_G.msdoors_floor == "Hotel" and "Anti Dupe") or
                 (_G.msdoors_floor == "Backdoor" and "Anti Vacum") or  
                 "Anti Dupe"

GroupAntiEntity:AddToggle("Anti-Dupe", {
    Text = DupeName,
    Default = _G.msdoors_DupeRunning,
    Callback = function(state)
        _G.msdoors_DupeRunning = state

        if state then
            _G.msdoors_DupeConnection = workspace.DescendantAdded:Connect(function(descendant)
                if descendant:GetAttribute("LoadModule") == "DupeRoom" or descendant:GetAttribute("LoadModule") == "SpaceSideroom" then
                    if not _G.msdoors_DupeOriginals[descendant] then
                        _G.msdoors_DupeOriginals[descendant] = {}

                        if descendant:GetAttribute("LoadModule") == "SpaceSideroom" then
                            local collision = descendant:FindFirstChild("Collision")
                            if collision then
                                _G.msdoors_DupeOriginals[descendant].CanCollide = collision.CanCollide
                                _G.msdoors_DupeOriginals[descendant].CanTouch = collision.CanTouch
                                collision.CanCollide = true
                                collision.CanTouch = false
                            end
                        else
                            local doorFake = descendant:FindFirstChild("DoorFake")
                            if doorFake then
                                local hidden = doorFake:FindFirstChild("Hidden")
                                local lock = doorFake:FindFirstChild("Lock")
                                if hidden then
                                    _G.msdoors_DupeOriginals[descendant].HiddenCanTouch = hidden.CanTouch
                                    hidden.CanTouch = false
                                end
                                if lock and lock:FindFirstChild("UnlockPrompt") then
                                    _G.msdoors_DupeOriginals[descendant].UnlockPrompt = lock.UnlockPrompt.Enabled
                                    lock.UnlockPrompt.Enabled = false
                                end
                            end
                        end
                    end
                end
            end)
            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                for _, dupeRoom in pairs(room:GetChildren()) do
                    if dupeRoom:GetAttribute("LoadModule") == "DupeRoom" or dupeRoom:GetAttribute("LoadModule") == "SpaceSideroom" then
                        if not _G.msdoors_DupeOriginals[dupeRoom] then
                            _G.msdoors_DupeOriginals[dupeRoom] = {}

                            if dupeRoom:GetAttribute("LoadModule") == "SpaceSideroom" then
                                local collision = dupeRoom:FindFirstChild("Collision")
                                if collision then
                                    _G.msdoors_DupeOriginals[dupeRoom].CanCollide = collision.CanCollide
                                    _G.msdoors_DupeOriginals[dupeRoom].CanTouch = collision.CanTouch
                                    collision.CanCollide = true
                                    collision.CanTouch = false
                                end
                            else
                                local doorFake = dupeRoom:FindFirstChild("DoorFake")
                                if doorFake then
                                    local hidden = doorFake:FindFirstChild("Hidden")
                                    local lock = doorFake:FindFirstChild("Lock")
                                    if hidden then
                                        _G.msdoors_DupeOriginals[dupeRoom].HiddenCanTouch = hidden.CanTouch
                                        hidden.CanTouch = false
                                    end
                                    if lock and lock:FindFirstChild("UnlockPrompt") then
                                        _G.msdoors_DupeOriginals[dupeRoom].UnlockPrompt = lock.UnlockPrompt.Enabled
                                        lock.UnlockPrompt.Enabled = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            for dupeRoom, originalValues in pairs(_G.msdoors_DupeOriginals) do
                if dupeRoom and dupeRoom.Parent then
                    if dupeRoom:GetAttribute("LoadModule") == "SpaceSideroom" then
                        local collision = dupeRoom:FindFirstChild("Collision")
                        if collision then
                            collision.CanCollide = originalValues.CanCollide
                            collision.CanTouch = originalValues.CanTouch
                        end
                    else
                        local doorFake = dupeRoom:FindFirstChild("DoorFake")
                        if doorFake then
                            local hidden = doorFake:FindFirstChild("Hidden")
                            local lock = doorFake:FindFirstChild("Lock")
                            if hidden then
                                hidden.CanTouch = originalValues.HiddenCanTouch
                            end
                            if lock and lock:FindFirstChild("UnlockPrompt") then
                                lock.UnlockPrompt.Enabled = originalValues.UnlockPrompt
                            end
                        end
                    end
                end
            end
            _G.msdoors_DupeOriginals = {}

            if _G.msdoors_DupeConnection then
                _G.msdoors_DupeConnection:Disconnect()
                _G.msdoors_DupeConnection = nil
            end
        end
    end,
})

GroupAntiEntity:AddToggle("AntiHearing", {
    Text = "Anti-Figure Hearing",
    Default = _G.msdoors_FigureDeaf,
    Callback = function(state)
        _G.msdoors_FigureDeaf = state
        
        if state then
            local lastSendTime = 0
            local sendInterval = 0.1
            
            _G.HeartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
                local currentTime = tick()
                
                if currentTime - lastSendTime >= sendInterval then
                    lastSendTime = currentTime
                    
                    local args = { [1] = true }
                    local remote = game:GetService("ReplicatedStorage").RemotesFolder.Crouch
                    if remote and remote:IsA("RemoteEvent") then
                        remote:FireServer(unpack(args))
                    end
                end
                
                if not _G.msdoors_FigureDeaf then
                    if _G.HeartbeatConnection then
                        _G.HeartbeatConnection:Disconnect()
                        _G.HeartbeatConnection = nil
                    end
                end
            end)
        else
            if _G.HeartbeatConnection then
                _G.HeartbeatConnection:Disconnect()
                _G.HeartbeatConnection = nil
            end
            
            local args = {
                [1] = false
            }
            
            local remote = game:GetService("ReplicatedStorage").RemotesFolder.Crouch
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer(unpack(args))
            end
        end
    end
})

_G.msdoors_antiShade = _G.msdoors_antiShade or false

local function toggleShade(enabled)
    local player = game.Players.LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    
    if not mainUI then return end

    local modules = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and 
                    mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener") and 
                    mainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")

    if not modules then return end

    local shade = modules:FindFirstChild("Shade") or modules:FindFirstChild("Shade_MSDOORS_DISABLE")
    if not shade then return end

    shade.Name = enabled and "Shade_MSDOORS_DISABLE" or "Shade"
end

GroupAntiEntity:AddToggle("Anti-Shade", {
	Text = "Anti Halt",
	DisabledTooltip = "I am disabled!",
	Default = _G.msdoors_antiShade,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        _G.msdoors_antiShade = Value
        toggleShade(Value)
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

_G.msdoors_AnimTrack = _G.msdoors_AnimTrack or nil  
GroupTroll:AddToggle("Troll-Thoughts", {
	Text = "Thoughts",
	Tooltip = "Faz seu personagem ficar com uma animação de pensamento.",
	DisabledTooltip = "I am disabled!",
	Default = _G.msdoors_ThoughtsEnabled,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
        _G.msdoors_ThoughtsEnabled = Value  
        local lplr = game.Players.LocalPlayer
        local thinkanims = {"18885101321", "18885098453", "18885095182"}
        
        if _G.msdoors_ThoughtsEnabled then
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://" .. thinkanims[math.random(1, #thinkanims)]
            _G.msdoors_AnimTrack = lplr.Character:FindFirstChildWhichIsA("Humanoid"):LoadAnimation(animation)
            _G.msdoors_AnimTrack.Looped = true
            _G.msdoors_AnimTrack:Play()
        else
            if _G.msdoors_AnimTrack then
                _G.msdoors_AnimTrack:Stop()
                _G.msdoors_AnimTrack:Destroy()
                _G.msdoors_AnimTrack = nil  
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


_G.spamToolsConnection = nil

GroupTroll:AddToggle("SpamOtherTools", {
    Text = "Spam Other Tools",
    Default = _G.msdoors_spamTool,
    Risky = true,
    Tooltip = "Ativa o spam de ferramentas nos jogadores",
    Callback = function(Value)
        _G.msdoors_spamTool = Value

        if Value then
            if _G.spamToolsConnection then
                _G.spamToolsConnection:Disconnect()
                _G.spamToolsConnection = nil
            end

            _G.spamToolsConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.msdoors_spamTool then return end

                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player == game.Players.LocalPlayer then continue end

                    if player:FindFirstChild("Backpack") then
                        for _, tool in pairs(player.Backpack:GetChildren()) do
                            local remoteEvent = tool:FindFirstChildOfClass("RemoteEvent")
                            if remoteEvent then
                                remoteEvent:FireServer()
                            end
                        end
                    end

                    if player.Character then
                        for _, tool in pairs(player.Character:GetChildren()) do
                            if tool:IsA("Tool") then
                                local remoteEvent = tool:FindFirstChildOfClass("RemoteEvent")
                                if remoteEvent then
                                    remoteEvent:FireServer()
                                end
                            end
                        end

                        local toolRemote = player.Character:FindFirstChild("Remote", true)
                        if toolRemote and toolRemote:IsA("RemoteEvent") then
                            toolRemote:FireServer()
                        end
                    end
                end
            end)
        else
            if _G.spamToolsConnection then
                _G.spamToolsConnection:Disconnect()
                _G.spamToolsConnection = nil
            end
        end
    end
})


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

GroupReach:AddToggle("DoorReach", {
    Text = "Door Reach",
    Default = _G.msdoorsDoorReach,
    
    Callback = function(Value)
        _G.msdoorsDoorReach = Value
        
        if _G.doorReachConnection then
            _G.doorReachConnection:Disconnect()
            _G.doorReachConnection = nil
        end
        
        if _G.msdoorsDoorReach then
            local RunService = game:GetService("RunService")
            local GameData = game:GetService("ReplicatedStorage"):WaitForChild("GameData")
            local LatestRoomValue = GameData:WaitForChild("LatestRoom")
            
            _G.doorReachConnection = RunService.Heartbeat:Connect(function()
                local currentRoom = LatestRoomValue.Value
                
                if currentRoom and workspace.CurrentRooms:FindFirstChild(currentRoom) then
                    local door = workspace.CurrentRooms[currentRoom]:FindFirstChild("Door")
                    if door and door:FindFirstChild("ClientOpen") then
                        door.ClientOpen:FireServer()
                    end
                end
            end)
        end
    end
})

GroupReach:AddSlider("Main-MaxActivationDistance", {
    Text = "Prompt Reach Multiplier",
    Min = 7,
    Max = 13,
    Rounding = 1,
    Default = _G.MaxActivationDistance,
    Increment = 0.1,
    Callback = function(value)
        _G.MaxActivationDistance = value
        UpdateProximityPrompts()
    end,
})

GroupNot:AddToggle("Visual-Notifier-Entities", {
    Text = "Notificar Entidades",
    Default = notificationsEnabled,
    Callback = function(value)
        notificationsEnabled = value
    end,
})

GroupNot:AddToggle("NotPadlockCode", {
    Text = "Notify padlock code",
    Default = _G.padlocknotify_chatActive,
    Callback = function(value)
        _G.padlocknotify_chatActive = value
    end,
})

GroupNotC:AddToggle("Chat-Notifier", {
    Text = "Enviar notificações no chat",
    Default = _G.msdoors_chatActive,
    Callback = function(value)
        _G.msdoors_chatActive = value
    end,
})

GroupNotC:AddDivider()
GroupNotC:AddDropdown("notifyStyle", {
    Values = { "Obsdian", "Doors" },
    Default = 1,
    Multi = false,
    Text = "estilo de notificação",
    Tooltip = "Selecione o estilo de notificações",
    Searchable = false,
    Callback = function(Value)
        if Value == "Obsdian" then
            _G.msdoors_LibraryNotif = "Linoria"
        elseif Value == "Doors" then
            _G.msdoors_LibraryNotif = "Doors"
        end
    end,
    Disabled = false,
    Visible = true
})
GroupNotC:AddDivider()
GroupNotC:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",
	Text = "Lado de notificação",

	Callback = function(Value)
		Library:SetNotifySide(Value)
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
_G.MSDoors_EnableJump = false
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
	Text = "WalkSpeed",
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
	Default = _G.MSDoors_WalkSpeed,
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
    Default = _G.msdoors_atualizarPropriedadesFisicas,
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
	Default = _G.MSDoors_SpeedBypass,
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
	Default = _G.MSDoors_SpeedBypassDelay,
	Min = 0.22,
	Max = 0.26,
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

GroupBypass:AddToggle("NoCrouchBarriers", {
	Text = "No Crouch Barriers",
	Tooltip = "Removes barriers that require crouching", 
	Default = _G.msdoorsNoCrouchBarriers, 
	Callback = function(Value)
		_G.msdoorsNoCrouchBarriers = Value
		
		if not _G.storedCrouchBarriers then
			_G.storedCrouchBarriers = {}
		end
		
		if Value then
			if not _G.crouchBarrierMonitor then
				_G.crouchBarrierMonitor = game:GetService("RunService").RenderStepped:Connect(function()
					local currentRooms = game.Workspace:FindFirstChild("CurrentRooms")
					if not currentRooms then return end
					
					local room0 = currentRooms:FindFirstChild("0")
					if room0 and room0:FindFirstChild("Assets") then
						local luggageCart = room0.Assets:FindFirstChild("Luggage_Cart_Crouch")
						if luggageCart and not _G.storedCrouchBarriers["Room0_LuggageCart"] then
							_G.storedCrouchBarriers["Room0_LuggageCart"] = {
								Parent = luggageCart.Parent,
								Object = luggageCart
							}
							luggageCart.Parent = nil
						end
					end
					
					for _, room in ipairs(currentRooms:GetChildren()) do
						local roomNumber = tonumber(room.Name)
						if not roomNumber then continue end
						
						if room:FindFirstChild("Assets") then
							for _, glass in ipairs(room.Assets:GetChildren()) do
								if glass:IsA("UnionOperation") and glass.Name == "SeeThroughGlass" then
									local identifier = "Glass_Room" .. roomNumber
									if not _G.storedCrouchBarriers[identifier] then
										_G.storedCrouchBarriers[identifier] = {
											Parent = glass.Parent,
											Object = glass
										}
										glass.Parent = nil
									end
								end
							end
						end
						
						if room:FindFirstChild("Parts") then
							local collision = room.Parts:FindFirstChild("Collision")
							if collision and collision:IsA("Part") then
								local identifier = "Collision_Room" .. roomNumber
								if not _G.storedCrouchBarriers[identifier] then
									_G.storedCrouchBarriers[identifier] = {
										Parent = collision.Parent,
										Object = collision
									}
									collision.Parent = nil
								end
							end
						end
					end
				end)
			end
		else
			if _G.crouchBarrierMonitor then
				_G.crouchBarrierMonitor:Disconnect()
				_G.crouchBarrierMonitor = nil
			end
			
			for identifier, barrierData in pairs(_G.storedCrouchBarriers) do
				local parent = barrierData.Parent
				local barrier = barrierData.Object
				
				if parent and parent:IsDescendant(game.Workspace) then
					barrier.Parent = parent
				end
				_G.storedCrouchBarriers[identifier] = nil
			end
		end
	end,
})
--// ADDONS \\--
task.spawn(function()
    local AddonTab = Window:AddTab("Addons [BETA]", "package-plus")

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
local MenuInterface = Tabs["UI Settings"]:AddLeftGroupbox("Interface")
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
local MenuDiscord = Tabs["UI Settings"]:AddRightGroupbox("Discord")

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
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "85%", "95%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddDivider()
MenuGroup:AddButton("Unload", function()
    _G.MsdoorsLoaded = false
    _G.ObsidianaLib = false
    Library:Notify({
        Title = "Fechando...",
        Description = "Aguarde, estamos cuidando de tudo!",
        Time = 5,
    })
    Library:Unload()

    print("[Msdoors] • Tudo foi descarregado! Até outra hora 😉")
end)

_G.webhookEnabled = _G.webhookEnabled or false
_G.msdoors_webhook = _G.msdoors_webhook or "https://discord.com/api/webhooks/seu_id/seu_token"

function SendEmbed(options)
    if not _G.webhookEnabled then
        return
    end
    
    options = options or {}
    local OSTime = os.time()
    local Time = os.date("!*t", OSTime)
    
    local webhookData = {
        content = options.content or "",
        username = options.username,       
        avatar_url = options.avatar_url,   
        tts = options.tts or false,         
        embeds = {}
    }
    if options.title or options.description then
        local embed = {
            title = options.title,
            description = options.description,
            url = options.url,      
            color = options.color or 0,     
            timestamp = options.timestamp or string.format("%d-%d-%dT%02d:%02d:%02dZ", 
                Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec),
            fields = options.fields or {},
        }
        
        if options.author_name then
            embed.author = {
                name = options.author_name,
                url = options.author_url,
                icon_url = options.author_icon_url
            }
        end

        if options.footer_text then
            embed.footer = {
                text = options.footer_text or game.JobId,
                icon_url = options.footer_icon_url
            }
        else
            embed.footer = { text = game.JobId }
        end
        
        if options.image_url then
            embed.image = {
                url = options.image_url
            }
        end

        if options.thumbnail_url then
            embed.thumbnail = {
                url = options.thumbnail_url
            }
        end
        
        table.insert(webhookData.embeds, embed)
    end
    (syn and syn.request or http_request) {
        Url = _G.msdoors_webhook,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = game:GetService("HttpService"):JSONEncode(webhookData)
    }

end

MenuDiscord:AddLabel('• Enviar informações que estão ocorrendo\n no jogo em um chat\n específico no <font color="#9DABFF">Discord</font>')
MenuDiscord:AddToggle("Webhook", {
    Text = "Webhook",
    Default = _G.webhookEnabled,
    Disabled = false,
    Callback = function(Value)
        _G.webhookEnabled = Value
    end,
})
MenuDiscord:AddDivider()
MenuDiscord:AddInput("webhooklink", {
    Default = _G.msdoors_webhook,
    Numeric = false,
    Finished = false, 
    ClearTextOnFocus = true,
    Text = "Insira o link do Webhook",
    Callback = function(Value)
        _G.msdoors_webhook = Value
    end,
})
MenuDiscord:AddButton({
    Text = "Definir Webhook",
    Func = function()
        Notify({
            Title = "SUCESSO!",
            Description = "Webhook atualizado!",
            Image = "rbxassetid://95869322194132",
            Color = Color3.fromRGB(0, 0, 255),
            Style = "SISTEMA",
            Duration = 6,
            NotifyStyle = _G.msdoors_LibraryNotif
        })
    end
})
MenuDiscord:AddDivider()
MenuDiscord:AddButton({
    Text = "Testar webhook",
    Func = function()
        SendEmbed({
            username = "Msdoors bot",
            avatar_url = "https://msdoors-gg.vercel.app/favicon.ico",
            content = "dsc.gg/msdoors-gg",      
            title = "Entidade spawnou!",             
            description = "**Rush** Spawnou!",          
            url = "https://www.roblox.com/games/",       
            color = 65280,                                 
            author_name = "Rush",
            author_url = "https://msdoors-gg.vercel.app/favicon.ico",
            author_icon_url = "https://msdoors-gg.vercel.app/favicon.ico",
            footer_text = "msdoors • " .. game.JobId,
            footer_icon_url = "https://i.imgur.com/footer.png",
            image_url = "https://i.imgur.com/imagem.png",
            thumbnail_url = "https://i.imgur.com/thumb.png",
            fields = {
                { name = "Campo 1", value = "Valor 1", inline = true },
                { name = "Campo 2", value = "Valor 2", inline = true },
                { name = "Campo 3", value = "Valor 3", inline = false }
            }
        })
    end
})

MenuInterface:AddDropdown("LibraryDropdown", {
    Values = { "Obsidian", "Linoria" },
    Default = "Obsidian",
    Multi = false,
    Text = "Biblioteca",
    Tooltip = "Selecione qual biblioteca usar",
    Callback = function(selected)
        if selected == "Obsidian" then
            _G.msdoors_syslibrary = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
        elseif selected == "Linoria" then
            _G.msdoors_syslibrary = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
        end
    end
})

MenuInterface:AddButton({
	Text = "Recarregar",
	Func = function()
	Library:Unload()
	_G.msdoors_syslibrary = _G.msdoors_syslibrary
	_G.ObsidianaLib = false
	_G.MsdoorsLoaded = false
	wait(2)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Msdoors/refs/heads/main/Src/Loaders/Doors/hotel.lua"))()
	end,
	DoubleClick = false,
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
	Risky = false
})

--[[ VERIFICAÇÃO CONSTANTE DE SALA ]]--
if not _G.Config then
    _G.Config = {}
end

_G.Config.salaAnterior = nil
_G.Config.salaAtual = nil

local ultimaNotificacao = nil

local function NotificarMudancaDeSala(salaAnterior, salaAtual)
    if not _G.webhookEnabled then return end

    local nomeSalaAnterior = "Desconhecido"
    local nomeSalaAtual = "Desconhecido"
    if salaAnterior then
        local roomAnterior = workspace.CurrentRooms:FindFirstChild(tostring(salaAnterior))
        if roomAnterior and roomAnterior:GetAttribute("RawName") then
            nomeSalaAnterior = roomAnterior:GetAttribute("RawName")
        end
    end
    
    if salaAtual then
        local roomAtual = workspace.CurrentRooms:FindFirstChild(tostring(salaAtual))
        if roomAtual and roomAtual:GetAttribute("RawName") then
            nomeSalaAtual = roomAtual:GetAttribute("RawName")
        end
    end
    if ultimaNotificacao ~= salaAtual then
        ultimaNotificacao = salaAtual
        SendEmbed({
            username = "Msdoors bot",
            avatar_url = "https://msdoors-gg.vercel.app/favicon.ico",
	    title = "Mudança de sala detectada!",             
            description = string.format("**%s mudou de sala!\n **Sala %s → Sala %s ``(%s)``", 
                                    player.Name, 
                                    tostring(salaAnterior or "?"), 
                                    tostring(salaAtual or "?"),
                                    nomeSalaAtual),
            color = 65280, 
            footer_text = "msdoors • " .. game.JobId,
            footer_icon_url = "https://discord.com/favicon.ico"
        })
    end
end

local function VerificarMudancaDeSala()
    if not _G.webhookEnabled then return end
    local currentRoom = player:GetAttribute("CurrentRoom")
    if currentRoom and currentRoom ~= _G.Config.salaAtual then
        local salaAnterior = _G.Config.salaAtual
        _G.Config.salaAtual = currentRoom
        NotificarMudancaDeSala(salaAnterior, currentRoom)
    end
end
local function ConfigurarDeteccaoDeSalas()
    player:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
        VerificarMudancaDeSala()
    end)
    VerificarMudancaDeSala()
end
ConfigurarDeteccaoDeSalas()


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

Library:OnUnload(function()
	print("[ Msdoors ] » descarregando...")
	if connectionAliveCheck then
        connectionAliveCheck:Disconnect()
	end
	_G.msdoors_LibraryNotif = _G.msdoors_LibraryNotif or "Linoria"
_G.msdoors_AntiSeekObstructions = false
_G.msdoors_InstaInteractEnabled = false
_G.msdoors_spamTools = false
_G.msdoors_Brightness = 0
_G.msdoors_Fullbright = false
_G.msdoors_NoFog = false
_G.msdoorsNoCrouchBarriers = false
_G.msdoors_disAutoLibrary = 20
_G.msdoors_notpadlock = false
_G.MSDoors_WalkSpeed = 15
_G.msdoorsDoorReach = false
_G.msdoors_FigureDeaf = false
_G.msdoors_NoAmbienceEnabled = false  
_G.msdoors_ThoughtsEnabled = false
_G.msdoors_AntiGiggle = false
_G.msdoors_atualizarPropriedadesFisicas = false
_G.msdoors_AntiSeekDoor = false
_G.msdoors_AntiSnare = false
_G.msdoors_DupeRunning = false
_G.msdoors_AntiGloomEgg = false
_G.msdoors_AntiDupe = false
_G.msdoors_AntiFlood = false
_G.msdoors_AntiSeekDoor = false
_G.msdoors_anticutscenes = false
_G.msdoors_antijumpscares = false
_G.msdoors_antia90 = false
_G.msdoors_antiscreech = false
_G.msdoors_antiShade = false
_G.msdoors_antidread = false
_G.MSDoors_SpeedBypass = false
_G.MSDoors_SpeedBypassDelay = 0.23
_G.msdoors_CurrentlyUsingSGF = false
_G.msdoors_SpeedBypassBeTurned = nil
_G.msdoors_SpeedHackBeTurned = nil
_G.MaxActivationDistance = 7
_G.PromptClip = false
_G.msdoors_autoReviveEnabled = false
_G.msdoors_antieyes = false
_G.MSDoors_SpeedBypass = false
_G.msdoors_antilag = {
    Enabled = false,
    Connection = nil,
    StoredProperties = {}
}
getgenv().AntiSeekManager = { IsEnabled = false }
_G.ObsidianaLib = false


for name, toggle in pairs(Library.Toggles) do
    toggle:SetValue(false)
end
for name, option in pairs(Library.Options) do
    if option.Type == "Slider" then
        option:SetValue(option.Min)
    elseif option.Type == "Dropdown" then
        option:SetValue(option.Values[1]) 
    end
end

print("Todos os elementos foram resetados!")
end)

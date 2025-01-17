--// <Carts Game> | UPDATE EM BREVEL \\--

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
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/MS-ESP/refs/heads/main/source.lua"))()

print("[Msdoors] • [✅] Inialização da livraria e apis")
_G.ObsidianaLib = true

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
local Noclip = nil
local PathBeam = nil
local VelocityHandler = nil
print("[Msdoors] • [✅] Inicialização de Serviços")

_G.msdoors_desastre = {
    ativo = false,
    conexao = nil,
    valorAtual = nil,
    lastCheck = 0, 
    checkInterval = 0.1,
    hudDisplayTime = 5 
}
print("[Msdoors] • [✅] Inicialização de Serviços")
--[[ VERIFICAÇÃO DE JOGO ]]--
local GAME_ID_ESPERADO = 189707
local function getGameInfo()
    local success, gameInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    
    if not success then
        warn("[Msdoors] • Erro ao obter informações do jogo:", gameInfo)
        return nil
    end
    
    return gameInfo
end
local function verificarJogo()
    local gameInfo = getGameInfo()
    
    if not gameInfo then
        error(string.format([[
[ERRO CRÍTICO]
==========================================
Falha ao verificar o jogo atual
Detalhes do erro:
- Não foi possível obter informações do jogo
- Place ID atual: %d
- Hora do erro: %s
==========================================
]], game.PlaceId, os.date("%Y-%m-%d %H:%M:%S")))
        return false
    end
    
    if game.PlaceId ~= GAME_ID_ESPERADO then
        error(string.format([[
[ERRO DE VERIFICAÇÃO]
==========================================
Jogo incompatível detectado!
Detalhes:
- ID Esperado: %d
- ID Atual: %d
- Nome do Jogo: %s
- Criador: %s
- Hora da verificação: %s
==========================================
]], GAME_ID_ESPERADO, game.PlaceId, gameInfo.Name, gameInfo.Creator.Name, os.date("%Y-%m-%d %H:%M:%S")))
        return false
    end
    print(string.format([[
[VERIFICAÇÃO BEM-SUCEDIDA]
==========================================
Jogo verificado com sucesso!
- ID do Jogo: %d
- Nome: %s
- Hora: %s
==========================================
]], game.PlaceId, gameInfo.Name, os.date("%Y-%m-%d %H:%M:%S")))
    return true
end
verificarJogo()
--[[ NEW TABS ]]--

local Window = Library:CreateWindow({
    Title = "Msdoors",
    Footer = "Version: 1.3 | by rhyan57",
    Icon = "95869322194132",
    NotifySide = "Right",
    ShowCustomCursor = true
})

local Tabs = {
    Main = Window:AddTab("Principal", "user"),
    Credits = Window:AddTab("Créditos", "brain-circuit"),
    ["UI Settings"] = Window:AddTab("UI Settings", "bolt"),
}
local GroupCredits = Tabs.Credits:AddLeftGroupbox("Créditos")

local TeleportsTab = Tabs.Main:AddLeftGroupbox("Teleports")
TeleportsTab:AddLabel('<font color="#FF0000">Use responsibly and with consent.</font>')
local VisualsTab = Tabs.Main:AddLeftGroupbox("Visual")
VisualsTab:AddLabel('<font color="#00FF34">Things like Delete Screen Effects</font>')
local PlayersTab = Tabs.Main:AddLeftGroupbox("Players")
PlayersTab:AddLabel('<font color="#00FF34">Speed hack, walk speed and player stuff.</font>')
local FarmsTab = Tabs.Main:AddRightGroupbox("Farming")
FarmsTab:AddLabel('<font color="#FF0000">Farm Systems</font>')
local ExploitsTab = Tabs.Main:AddRightGroupbox("Exploits")
ExploitsTab:AddLabel('<font color="#00FF34">things like solid sland and solid water</font>')
local GamesTab = Tabs.Main:AddRightGroupbox("Game")
GamesTab:AddLabel('<font color="#00FF34">Funções do jogo atual</font>')
local GroupCredits = Tabs.Credits:AddLeftGroupbox("Créditos")

TeleportsTab:AddButton({
	Text = "Ilha",
	Func = function()
		print("[Msdoors] • Teleportado para: ILHA")
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-108, 49, 0)
	end,
	DoubleClick = false,
	Tooltip = "Será teleportado para ilha ao clicar",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})
TeleportsTab:AddButton({
	Text = "Torre",
	Func = function()
		print("[Msdoors] • Teleportado para: TORRE")
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-264, 196, 288)
	end,
	DoubleClick = false,
	Tooltip = "Será teleportado para Torre ao clicar",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

VisualsTab:AddButton({
	Text = "Remove SandstormUI",
	Func = function()
		print("[Msdoors] • Apagando Ui: SandStormGui")
                        game.Players.LocalPlayer.PlayerGui.SandStormGui:Destroy()
	end,
	DoubleClick = false,
	Tooltip = "removerá a Gui de SandStorm da tela.",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

VisualsTab:AddButton({
	Text = "Remove BlizzardGui",
	Func = function()
		print("[Msdoors] • Apagando Ui: BlizzardGui")
                            game.Players.LocalPlayer.PlayerGui.BlizzardGui:Destroy()
	end,
	DoubleClick = false,
	Tooltip = "removerá a Gui de Blizzard da tela.",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

VisualsTab:AddButton({
	Text = "Remove Ads",
	Func = function()
	print("[Msdoors] • Apagando placar de anúncios")
        game:GetService("Workspace").BillboardAd:Destroy()
        game:GetService("Workspace")["Main Portal Template "]:Destroy()
        game:GetService("Workspace").ReturnPortal:Destroy()
	end,
	DoubleClick = false,
	Tooltip = "removerá o placar de anúncios do mapa visualmente..",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

PlayersTab:AddButton({
	Text = "Godmode",
	Func = function()
	print("[Msdoors] • GodMode Byppas...")
game.Players.LocalPlayer.Character.Humanoid:Remove()
Instance.new('Humanoid', game.Players.LocalPlayer.Character)
game:GetService("Workspace")[game.Players.LocalPlayer.Name]:FindFirstChildOfClass(
'Humanoid').HipHeight = 2
		
	end,
	DoubleClick = false,
	Tooltip = "Antes de renascer ao clicar nesse botão você ficará imortal com speed byppas!",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

PlayersTab:AddToggle("Autofarm-old", {
    Text = "Autofarm[OLD]",
    Default = false,
    Tooltip = "Fique teleportando para o lobby durante a partida.",
    Callback = function(state)
    if state then
            autofarmEvent = game:GetService("RunService").RenderStepped:Connect(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-264, 195, 288)
            end)
        else
            if autofarmEvent then
                autofarmEvent:Disconnect()
            end
        end
    end
})

CartsTab:AddSlider("speed-player-natutal", {
	Text = "Speed",
	Default = 16,
	Min = 16,
	Max = 55,
	Rounding = 1,
	Compact = false,
	Callback = function(value)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
	end,

	Tooltip = "Velocidade do player atual.",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

CartsTab:AddSlider("gravity-player-natutal", {
	Text = "Gravidade / Jumpboost",
	Default = 1,
	Min = 0,
	Max = 196,
	Rounding = 1,
	Compact = false,
	Callback = function(value)
        game.Workspace.Gravity = value
	end,
	Tooltip = "Gravidade do player atual.",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

local cache = {
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    LocalPlayer = game:GetService("Players").LocalPlayer,
    TweenService = game:GetService("TweenService")
}
local config = {
    locations = {
        farm = CFrame.new(-281, 167, 339),
        safe = CFrame.new(-278, 180, 343)
    },
    tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear),
    updateRate = 0 -- 0 = máxima velocidade
}
local function initializeTeleportSystem()
    local function isCharacterValid()
        local character = cache.LocalPlayer.Character
        return character 
            and character:FindFirstChild("HumanoidRootPart") 
            and character:FindFirstChild("Humanoid") 
            and character.Humanoid.Health > 0
    end
local function teleportWithTween(targetCFrame)
        if not isCharacterValid() then return end
        
        local humanoidRootPart = cache.LocalPlayer.Character.HumanoidRootPart
        local tween = cache.TweenService:Create(
            humanoidRootPart,
            config.tweenInfo,
            {CFrame = targetCFrame}
        )
        tween:Play()
        return tween
    end
    getgenv().msdoors_isteleporting = false
    local connection

FarmsTab:AddToggle("Autofarm-new", {
    Text = "Autofarm[NEW]",
    Default = false,
    Tooltip = "Fique teleportando para o lobby durante a partida.",
    Callback = function(Value)
    getgenv().msdoors_isteleporting = Value
            
            if Value then
                connection = cache.RunService.Heartbeat:Connect(function()
                    if not isCharacterValid() then return end
                    cache.LocalPlayer.Character.HumanoidRootPart.CFrame = config.locations.farm
                end)
            else
                if connection then 
                    connection:Disconnect()
                    connection = nil
                    teleportWithTween(config.locations.safe)
                end
            end

    end
})

FarmsTab:AddButton({
	Text = "Instant Safe teleport",
	Func = function()
	        if isCharacterValid() then
                teleportWithTween(config.locations.safe)
		  end
		end,
	DoubleClick = false,
	Tooltip = "Caso falhe ao teleportar no botão anterior clique neste para sair do autofarm.",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})
initializeTeleportSystem()

ExploitsTab:AddToggle("Walk-on-water-new", {
    Text = "Andar sobre a água",
    Default = false,
    Tooltip = "Fique teleportando para o lobby durante a partida.",
    Callback = function(state)
    local water = game.Workspace.WaterLevel
        if state then
            water.CanCollide = true
            water.Size = Vector3.new(1000, 1, 1000)
        else
            water.CanCollide = false
            water.Size = Vector3.new(10, 1, 10)
        end
    end
})
ExploitsTab:AddToggle("Solid-island-new", {
    Text = "ilha sólida",
    Default = false,
    Tooltip = "Deixará as bordas da ilha sólida",
    Callback = function(state)
            for _, v in pairs(game.Workspace:GetDescendants()) do
            if v.Name == "LowerRocks" then
                v.CanCollide = state
            end
	end
    end
})

ExploitsTab:AddToggle("Escolher-mapa-old", {
    Text = "Escolher mapa",
    Default = false,
    Tooltip = "Mostra a gui para escolher mapas",
    Callback = function(state)
    game.Players.LocalPlayer.PlayerGui.MainGui.MapVotePage.Visible = state
    end
})

ExploitsTab:AddButton({
	Text = "Lançar foguete",
	Func = function()
            fireclickdetector(game:GetService("Workspace").Structure["Launch Land"]["SPACESHIP!!"].Shuttle.IgnitionButton.ClickDetector)
            fireclickdetector(game:GetService("Workspace").Structure["Launch Land"].RocketStand.ConsoleLower.ReleaseButtonLower.ClickDetector)
            fireclickdetector(game:GetService("Workspace").Structure["Launch Land"].RocketStand.ConsoleUpper.ReleaseButtonUpper.ClickDetector)
            fireclickdetector(game:GetService("Workspace").Structure["Launch Land"].LoadingTower.Console.ReleaseEntryBridge.ClickDetector)
            print("[Msdoors] • Lançando foguete!")
	end,
	DoubleClick = false,
	Tooltip = "Será teleportado para Torre ao clicar",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

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
    else

    end
end

local function createStylishHUD()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DisasterHUD"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 80)
    mainFrame.Position = UDim2.new(0.5, -150, 0, -100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = mainFrame

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "DisasterText"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 24
    textLabel.Parent = mainFrame

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 165, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    gradient.Parent = mainFrame

    local gradientRotation = 0
    RunService.RenderStepped:Connect(function()
        gradientRotation = (gradientRotation + 1) % 360
        gradient.Rotation = gradientRotation
    end)

    return screenGui, mainFrame, textLabel
end

local function showStylishHUD(message)
    local existingHUD = game.Players.LocalPlayer.PlayerGui:FindFirstChild("DisasterHUD")
    if existingHUD then existingHUD:Destroy() end

    local screenGui, mainFrame, textLabel = createStylishHUD()
    textLabel.Text = message

    local entranceTween = TweenService:Create(mainFrame, 
        TweenInfo.new(0.5, Enum.EasingStyle.Bounce), 
        {Position = UDim2.new(0.5, -150, 0, 20)}
    )
    entranceTween:Play()

    local pulseIn = TweenService:Create(mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 320, 0, 85)}
    )
    local pulseOut = TweenService:Create(mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 300, 0, 80)}
    )

    pulseIn:Play()
    pulseIn.Completed:Connect(function()
        pulseOut:Play()
    end)

    task.delay(_G.msdoors_desastre.hudDisplayTime, function()
        local exitTween = TweenService:Create(mainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, -150, 0, -100)}
        )
        exitTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
        exitTween:Play()
    end)
end

local function monitorarDesastre()
    local localPlayerName = Players.LocalPlayer.Name
    local lastValue = nil

    local function checkSurvivalTag()
        local playerModel = Workspace:FindFirstChild(localPlayerName)
        local survivalTag = playerModel and playerModel:FindFirstChild("SurvivalTag")

        if survivalTag and survivalTag:IsA("StringValue") then
            if survivalTag.Value ~= lastValue then
                lastValue = survivalTag.Value
		print("[Msdoors] • Desastre: " .. survivalTag.Value)
		TrySendChatMessage("⚠️ Desastre: " .. survivalTag.Value)
                showStylishHUD("Desastre: " .. survivalTag.Value)
                OrionLib:MakeNotification({
                    Name = "Desastre Detectado",
                    Content = "O desastre é " .. survivalTag.Value,
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
                
            end
            return true
        end
        return false
    end

    if not checkSurvivalTag() then
    
    end

    _G.msdoors_desastre.conexao = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        if currentTime - _G.msdoors_desastre.lastCheck >= _G.msdoors_desastre.checkInterval then
            _G.msdoors_desastre.lastCheck = currentTime
            checkSurvivalTag()
        end
    end)
end

local function pararMonitoramento()
    if _G.msdoors_desastre.conexao then
        _G.msdoors_desastre.conexao:Disconnect()
        _G.msdoors_desastre.conexao = nil
    end
    _G.msdoors_desastre.valorAtual = nil


end
GamesTab:AddToggle("Warn-of-disasters", {
    Text = "Avisar desastres",
    Default = false,
    Tooltip = "Avisar desastres na sua tela",
    Callback = function(estado)
            _G.msdoors_desastre.ativo = estado
        if estado then
            monitorarDesastre()
        else
            pararMonitoramento()
				end
        end
})
GamesTab:AddToggle("Warn-of-disasters-in-chat", {
    Text = "Avisar desastres no chat",
    Default = false,
    Tooltip = "Avisar desastres para todos no chat",
    Callback = function(value)
        _G.msdoors_chatActive = value
        end
})

GroupCredits:AddLabel('<font color="#00FFFF">Créditos</font>')
GroupCredits:AddLabel('• Rhyan57 - <font color="#FFA500">DONO</font>')
GroupCredits:AddLabel('• SeekAlegriaFla - <font color="#FFA500">SUB-DONO</font>')
GroupCredits:AddLabel('<font color="#00FFFF">Redes</font>')
GroupCredits:AddLabel('• Discord: <font color="#9DABFF">https://dsc.gg/msdoors-gg</font>')
GroupCredits:AddButton({
    Name = "Copiar Link",
    Callback = function()
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
		Description = "Seu executor não suporta redirecionar. link copiado.,
		Time = 5,
	})

        else
                        Library:Notify({
		Title = "LOL",
		Description = "Seu executor não suporta redirecionar ou copiar links.,
		Time = 5,
	})

        end
    end
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
	Library:Unload()
end)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("msdoors")
SaveManager:SetFolder("msdoors/carrinhointothegiganoob")
SaveManager:SetSubFolder("carrinhointothegiganoob")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
	
_G.MsdoorsLoaded = true

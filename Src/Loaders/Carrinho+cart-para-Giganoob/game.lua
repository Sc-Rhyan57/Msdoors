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
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau"))()

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
local musicPlayer = { isPlaying = false, currentSound = nil, currentPlaylist = nil, playlists = {}, currentIndex = 0, volume = 0.5, folderName = ".msdoors", }
print("[Msdoors] • [✅] Inicialização de Serviços")

--[[ VERIFICAÇÃO DE JOGO ]]--
local GAME_ID_ESPERADO = 5275822877
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


local Window = Library:CreateWindow({
    Title = "Msdoors v1",
    Footer = "Version: 1.3 | by rhyan57",
    Icon = "95869322194132",
    NotifySide = "Right",
    ShowCustomCursor = true
})

local Tabs = {
    Main = Window:AddTab("Principal", "user"),
    Credits = Window:AddTab("Créditos", "user"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}
local GroupCredits = Tabs.Credits:AddLeftGroupbox("Carts")

local CartsTab = Tabs.Main:AddLeftGroupbox("Carts")
CartsTab:AddLabel('<font color="#FF0000">Use responsibly and with consent.</font>')
local JeepsTab = Tabs.Main:AddLeftGroupbox("Jeeps")
JeepsTab:AddLabel('<font color="#FF0000">This function may cause some lag for the player.</font>')
local TeleportGroup = Tabs.Main:AddRightGroupbox("Teleportes")
TeleportGroup:AddLabel('<font color="#9DABFF">Aba de teleportes</font>')


-- Variáveis globais para controle
getgenv().AutoClickDetectors = false
getgenv().ClickSpeed = 0.3
local autoDestroy = true
local player = Players.LocalPlayer

local initialPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position

local function destroyAllBuyHatGamePassSign()
    for _, child in ipairs(workspace:GetChildren()) do
        if child.Name == "Buy Hat Game Pass Sign" then
            print("[Msdoors] • A seguinte pasta será apagada para evitar bugs:", child.Name)
            child:Destroy()
        end
    end
end

workspace.ChildAdded:Connect(function(child)
    if autoDestroy and child.Name == "Buy Hat Game Pass Sign" then
        task.wait(0.1)
        print("[Msdoors] • 'Buy Hat Game Pass Sign' encontrada e destruída:", child.Name)
        child:Destroy()
    end
end)

local function teleportToBuyHatGamePassSign()
    local target = workspace:FindFirstChild("Buy Hat Game Pass Sign")
    if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 5, 0)
        print("[Msdoors] Jogador teleportado para 'Buy Hat Game Pass Sign'.")
        task.wait(3)
        if initialPosition then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(initialPosition)
            print("[Msdoors] • Jogador retornado à posição inicial.")
        end
    else
        print("[Msdoors] • Pasta 'Buy Hat Game Pass Sign' não encontrada para teleporte.")
    end
end

local function interactWithClickDetectors()
    while getgenv().AutoClickDetectors do
        task.wait(getgenv().ClickSpeed)
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ClickDetector") then
                    fireclickdetector(v)
                end
            end
        end)
    end
end
destroyAllBuyHatGamePassSign()

--// ON/PLAY CART \\--
local Building = game:GetService("Workspace"):FindFirstChild("Building")
local function getAllClickDetectors()
    local clickDetectors = {}
    if Building then
        for _, descendant in ipairs(Building:GetDescendants()) do
            if descendant:IsA("ClickDetector") and descendant.Parent and descendant.Parent.Name == "On" then
                table.insert(clickDetectors, descendant)
            end
        end
    end
    return clickDetectors
end
local function interactOnce()
    local clickDetectors = getAllClickDetectors()
    for _, clickDetector in ipairs(clickDetectors) do
        pcall(function()
            fireclickdetector(clickDetector)
        end)
    end
end
--// JEEP \\--
getgenv().AutoSpamCarrinhos = false
local function getAllCarrinhos()
    local carrinhos = {}
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name:lower():find("jeep") then
            table.insert(carrinhos, descendant)
        end
    end
    return carrinhos
end
local function interactWithCarrinho(carrinho)
    for _, part in ipairs(carrinho:GetDescendants()) do
        if part:IsA("ClickDetector") then
            pcall(function()
                fireclickdetector(part)
            end)
        end
        if part:IsA("ProximityPrompt") then
            pcall(function()
                fireproximityprompt(part)
            end)
        end
        if part:IsA("TouchTransmitter") or part.Name == "TouchInterest" then
            pcall(function()
                firetouchinterest(part.Parent, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                task.wait(0.1)
                firetouchinterest(part.Parent, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
            end)
        end
    end
end

local function interactWithAllCarrinhos()
    while getgenv().AutoSpamCarrinhos do
        local carrinhos = getAllCarrinhos()
        for _, carrinho in ipairs(carrinhos) do
            pcall(function()
                interactWithCarrinho(carrinho)
            end)
        end
        task.wait(0.1) 
    end
end


--// UP CARTS \\--
getgenv().AutoClickDetectors1 = false
local Building = game:GetService("Workspace"):FindFirstChild("Building")

local function getAllClickDetectors()
    local clickDetectors = {}
    if Building then
        for _, descendant in ipairs(Building:GetDescendants()) do
            if descendant:IsA("ClickDetector") and descendant.Parent and descendant.Parent.Name == "Up" then
                table.insert(clickDetectors, descendant)
            end
        end
    end
    return clickDetectors
end

local function spamClickDetectors()
    while getgenv().AutoClickDetectors1 do
        local clickDetectors = getAllClickDetectors()
        for _, clickDetector in ipairs(clickDetectors) do
            pcall(function()
                fireclickdetector(clickDetector)
            end)
        end
        task.wait(0.1)
    end
end


CartsTab:AddToggle("BreakCarts", {
    Text = "Break Carts",
    Default = false,
    Tooltip = "Isso fará com que todos carrinhos fiquem loucos!",
    Callback = function(state)
    getgenv().AutoClickDetectors = state
        if state then
      print("[Msdoors] • Break Carts ativado.")
            spawn(interactWithClickDetectors)
        else
      print("[Msdoors] • Break Carts desativado.")
        end
    end
})
CartsTab:AddSlider("BreakCarts-velocity", {
	Text = "Velocidade de Break",
	Default = 0.3,
	Min = 0.1,
	Max = 2.1,
	Rounding = 1,
	Compact = false,
	Callback = function(value)
     getgenv().ClickSpeed = value
	end,

	Tooltip = "Definir velocidade de cliques do break Carts.",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})
CartsTab:AddDivider()
CartsTab:AddToggle("Spam-speed-carts", {
    Text = "Speed for all carts",
    Default = false,
    Tooltip = "Isso fará com que todos carts fiquem aumentando sua velocidade infinitamente.",
    Callback = function(state)
            getgenv().AutoClickDetectors1 = state
        if state then
            spawn(spamClickDetectors)
			else
        end
    end
})

CartsTab:AddButton({
    Text = "Play/Off carts",
    Func = function()
    interactOnce()
    end,
    DoubleClick = false,
    Tooltip = "Interage com todos carrinhos no botão play/stop"
})



JeepsTab:AddToggle("spam-jeeps", {
    Text = "Spawn Infinite Jeeps(half slow)",
    Default = false,
    Tooltip = "Isso fará com que você foque spawnando Jeeps infinitamente enquanto ativo.",
    Callback = function(state)
    getgenv().AutoSpamCarrinhos = state
        if state then
            print("[Msdoors] • Spam jeeps ativo")
            spawn(interactWithAllCarrinhos)
        else
            print("[Msdoors] • Spam jeeps pausado")
        end
    end
})

TeleportGroup:AddDropdown("teleport-droppdown", {
	Values = { "Início", "Meio", "Fim" },
	Default = 1,
	Multi = false,
	Text = "Teleporte",
	Tooltip = "Teleporte para qualquer nivel!",
	DisabledTooltip = "I am disabled!",
	Searchable = true,
	Callback = function(value)
       if value == "Início" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(233, 3, 7)
        elseif value == "Meio" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(271, 350, 466)
        elseif value == "Fim" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(163, 761, -1020)
        end
	end,
	Disabled = false,
	Visible = true
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

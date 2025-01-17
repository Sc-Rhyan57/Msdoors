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
    Title = "Msdoors",
    Footer = "Version: 1.3 | by rhyan57",
    Icon = "95869322194132",
    NotifySide = "Right",
    ShowCustomCursor = true
})

local Tabs = {
    Main = Window:AddTab("Principal", "user"),
    GroupMusic = Window:AddTab("Musica", "user"),
    Settings = Window:AddTab("Settings", "settings")
}

local Msplayer = Tabs.GroupMusic:AddLeftGroupbox("Música")
MsPlayer:AddLabel('<font color="#9DABFF">Escute músicas enquanto joga.</font>')

local Msplayer-playlist = Tabs.GroupMusic:AddRightGroupbox("Playlist system")
MsPlayer:AddLabel('<font color="#9DABFF">Playlists</font>')

local CartsTab = Tabs.Main:AddLeftGroupbox("Carts")
CartsTab:AddLabel('<font color="#FF0000">Use responsibly and with consent.</font>')
local JeepsTab = Tabs.Main:AddLeftGroupbox("Jeeps")
JeepsTab:AddLabel('<font color="#FF0000">This function may cause some lag for the player.</font>')
local TeleportGroup = Tabs.Main:AddRightGroupbox("Teleportes")
TeleportGroup:AddLabel('<font color="#9DABFF">Aba de teleportes</font>')


--[[ MUSIC SYSTEM ]]--
local function createFolderIfNotExists()
    if not isfolder(musicPlayer.folderName) then
        makefolder(musicPlayer.folderName)
    end
end

local function savePlaylist(name, data)
    createFolderIfNotExists()
    local filePath = musicPlayer.folderName .. "/" .. name .. ".json"
    local jsonData = HttpService:JSONEncode(data)
    writefile(filePath, jsonData)
end

local function loadPlaylist(name)
    local filePath = musicPlayer.folderName .. "/" .. name .. ".json"
    if isfile(filePath) then
        local jsonData = readfile(filePath)
        return HttpService:JSONDecode(jsonData)
    else
        return nil
    end
end

local function deletePlaylist(name)
    local filePath = musicPlayer.folderName .. "/" .. name .. ".json"
    if isfile(filePath) then
        delfile(filePath)
    end
end

local function createNotification(title, content, duration)
    Library:Notify({
		Title = title,
		Description = content,
		Time = duration,
	})
end

local function playMusic(index)
    if not musicPlayer.currentPlaylist or #musicPlayer.currentPlaylist == 0 then
        createNotification("Erro", "Playlist vazia ou não carregada.(tente re-entrar)", 3)
        return
    end

    if musicPlayer.currentSound then
        musicPlayer.currentSound:Destroy()
    end

    local sound = Instance.new("Sound", game:GetService("Workspace"))
    local musicData = musicPlayer.currentPlaylist[index]
    if not musicData then
        createNotification("Erro", "Nenhuma música encontrada.", 3)
        return
    end

    sound.SoundId = "rbxassetid://" .. musicData.Id
    sound.Volume = musicPlayer.volume
    sound.Looped = false
    sound:Play()

    musicPlayer.isPlaying = true
    musicPlayer.currentSound = sound
    musicPlayer.currentIndex = index

    createNotification("Reprodutor", "Tocando: " .. musicData.NAME, 3)

    sound.Ended:Connect(function()
        local nextIndex = musicPlayer.currentIndex + 1
        if nextIndex > #musicPlayer.currentPlaylist then nextIndex = 1 end
        playMusic(nextIndex)
    end)
end

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


Msplayer-playlist:AddInput("ADD-NAME-PLAYLIST", {
	Default = "",
	Numeric = false,
	Finished = true,
	ClearTextOnFocus = true,
	Text = "Nome da playlist",
	Tooltip = "Adicionar um nome a playlist",
	Placeholder = "",
	Callback = function(value)
    musicPlayer.currentPlaylistName = value
	end,
})
Msplayer-playlist:AddButton({
    Name = "Excluir playlist",
    Callback = function()
        if musicPlayer.currentPlaylistName and musicPlayer.currentPlaylistName ~= "" then
            musicPlayer.playlists[musicPlayer.currentPlaylistName] = {}
            savePlaylist(musicPlayer.currentPlaylistName, musicPlayer.playlists[musicPlayer.currentPlaylistName])
            createNotification("Playlist", "Playlist criada com sucesso!", 3)
        else
            createNotification("Erro", "Insira um nome para a playlist.", 3)
        end
    end
})


MsPlayer:AddButton({
    Name = "Criar Playlist",
    Callback = function()
        if musicPlayer.currentPlaylistName and musicPlayer.currentPlaylistName ~= "" then
            musicPlayer.playlists[musicPlayer.currentPlaylistName] = {}
            savePlaylist(musicPlayer.currentPlaylistName, musicPlayer.playlists[musicPlayer.currentPlaylistName])
            createNotification("Playlist", "Playlist criada com sucesso!", 3)
        else
            createNotification("Erro", "Insira um nome para a playlist.", 3)
        end
    end
})
Msplayer-playlist:AddButton({
    Name = "Carregar Playlist",
    Callback = function()
        if musicPlayer.currentPlaylistName and musicPlayer.currentPlaylistName ~= "" then
            local loadedPlaylist = loadPlaylist(musicPlayer.currentPlaylistName)
            if loadedPlaylist then
                musicPlayer.currentPlaylist = loadedPlaylist
                createNotification("Playlist", "Playlist carregada com sucesso!", 3)
            else
                createNotification("Erro", "Playlist não encontrada.", 3)
            end
        else
            createNotification("Erro", "Insira o nome da playlist para carregar.", 3)
        end

    end
})
Msplayer-playlist:AddButton({
    Name = "Salvar playlist",
    Callback = function()
        if musicPlayer.currentPlaylistName and musicPlayer.currentPlaylist then
            savePlaylist(musicPlayer.currentPlaylistName, musicPlayer.currentPlaylist)
            createNotification("Playlist", "Playlist salva com sucesso!", 3)
        else
            createNotification("Erro", "Nenhuma playlist carregada para salvar.", 3)
        end
    end
})


Msplayer-playlist:AddButton({
    Name = "Excluir playlist",
    Callback = function()
        if musicPlayer.currentPlaylistName then
            deletePlaylist(musicPlayer.currentPlaylistName)
            musicPlayer.currentPlaylist = nil
            createNotification("Playlist", "Playlist excluída com sucesso!", 3)
        else
            createNotification("Erro", "Insira o nome da playlist para excluir.", 3)
        end
    end
})


Msplayer-playlist:AddInput("ADD-MUSIC-ID", {
	Default = "",
	Numeric = false,
	Finished = true,
	ClearTextOnFocus = true,
	Text = "Musica(ID ROBLOX)",
	Tooltip = "Adicionar músicas por id a playlist.",
	Placeholder = "",
	Callback = function(value)
        if musicPlayer.currentPlaylist then
            local splitValue = string.split(value, ",")
            local musicData = { NAME = splitValue[1], Id = splitValue[2] }
            table.insert(musicPlayer.currentPlaylist, musicData)
            createNotification("Playlist", "Música adicionada à playlist.", 3)
        else
            createNotification("Erro", "Carregue uma playlist antes de adicionar músicas.", 3)
        end
	end,
})

MsPlayer:AddTextbox({
    Name = "Adicionar Música (Nome e Id) separados por vírgula)",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        if musicPlayer.currentPlaylist then
            local splitValue = string.split(value, ",")
            local musicData = { NAME = splitValue[1], Id = splitValue[2] }
            table.insert(musicPlayer.currentPlaylist, musicData)
            createNotification("Playlist", "Música adicionada à playlist.", 3)
        else
            createNotification("Erro", "Carregue uma playlist antes de adicionar músicas.", 3)
        end
    end
})

Msplayer-playlist:AddDivider()
Msplayer-playlist:AddButton({
    Name = "Tocar Playlist",
    Callback = function()
       playMusic(musicPlayer.currentIndex > 0 and musicPlayer.currentIndex or 1)
    end
})


Msplayer-playlist:AddButton({
    Name = "Próxima Música",
    Callback = function()
        local nextIndex = musicPlayer.currentIndex + 1
        if nextIndex > #musicPlayer.currentPlaylist then nextIndex = 1 end
        playMusic(nextIndex)
    end
})

Msplayer-playlist:AddButton({
    Text = "Pausar",
    Func = function()
    if musicPlayer.currentSound and musicPlayer.isPlaying then
            musicPlayer.currentSound:Pause()
            musicPlayer.isPlaying = false
            createNotification("Reprodutor", "Música pausada.", 3)
        else
            createNotification("Erro", "Nenhuma música está tocando ou já está pausada.", 3)
        end
    end,
    DoubleClick = false,
    Tooltip = "Pausa musicas em reprodução."
})


local musicIdFromTextbox = ""
MsPlayer:AddInput("MUSIC-ID", {
	Default = "",
	Numeric = false,
	Finished = false,
	ClearTextOnFocus = true,
	Text = "Musica(ID ROBLOX)",
	Tooltip = "Ao inserir o id e clicar em tocar você reproduz a música!",
	Placeholder = "",
	Callback = function(value)
		musicIdFromTextbox = value 
	end,
})

MsPlayer:AddButton({
    Text = "Tocar",
    Func = function()
    if musicIdFromTextbox == "" then
            createNotification("Erro", "Insira um ID válido no textbox.", 3)
            return
        end

        if musicPlayer.currentSound then
            musicPlayer.currentSound:Destroy()
        end

        local sound = Instance.new("Sound", game:GetService("Workspace"))
        sound.SoundId = "rbxassetid://" .. musicIdFromTextbox
        sound.Volume = musicPlayer.volume
        sound.Looped = false
        sound:Play()

        musicPlayer.isPlaying = true
        musicPlayer.currentSound = sound

        createNotification("Reprodutor", "Tocando música com ID: " .. musicIdFromTextbox, 3)

        sound.Ended:Connect(function()
            musicPlayer.isPlaying = false
            createNotification("Reprodutor", "Música finalizada.", 3)
        end)
    end,
    DoubleClick = false,
    Tooltip = "Reproduzir música do id inserido."
})


MsPlayer:AddButton({
    Text = "Pausar",
    Func = function()
    if musicPlayer.currentSound and musicPlayer.isPlaying then
            musicPlayer.currentSound:Pause()
            musicPlayer.isPlaying = false
            createNotification("Reprodutor", "Música pausada.", 3)
        else
            createNotification("Erro", "Nenhuma música está tocando ou já está pausada.", 3)
        end
    end,
    DoubleClick = false,
    Tooltip = "Pausa musicas em reprodução."
})

MsPlayer:AddSlider("msplayer-volume", {
	Text = "Volume",
	Default = 0.5,
	Min = 0,
	Max = 2,
	Rounding = 1,
	Compact = false,
	Callback = function(value)
     musicPlayer.volume = value
        if musicPlayer.currentSound then
            musicPlayer.currentSound.Volume = value
        end
	end,

	Tooltip = "Definir volume da musica em reprodução.",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

--[[
RightGroup2:AddToggle("MyToggle", {
    Text = "Example Toggle",
    Default = false,
    Tooltip = "This is a tooltip",
    Callback = function(Value)
        print("Toggle is now:", Value)
    end
})

LeftGroup1:AddSlider("MySlider", {
    Text = "Example Slider",
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false
})
]]--
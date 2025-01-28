--// <PRESSURE> | UPDATE EM BREVEL \\--

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
local Noclip = nil
local PathBeam = nil
local VelocityHandler = nil
print("[Msdoors] • [✅] Inicialização de Serviços")

--[[ VERIFICAÇÃO DE JOGO ]]--
local GAME_ID_ESPERADO = 12552538292
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
    Title = "Msdoors v1",
    Footer = "Game: pressure | Build: 0.1.3",
    Icon = "95869322194132",
    NotifySide = "Right",
    ShowCustomCursor = true
})

local Tabs = {
    Main = Window:AddTab("Principal", "user"),
    Visual = Window:AddTab("Visuals", "user"),
    Exploits = Window:AddTab("Exploits", "user"),
    Credits = Window:AddTab("Créditos", "brain-circuit"),
    ["UI Settings"] = Window:AddTab("UI Settings", "bolt"),
}
local GroupCredits = Tabs.Credits:AddLeftGroupbox("Créditos")

local GroupEsp = Tabs.Visual:AddLeftGroupbox("Esp")

local GroupPlayer = Tabs.Main:AddLeftGroupbox("Player")
local GroupCamera = Tabs.Main:AddRightGroupbox("Camera")


GroupPlayer:AddSlider("speed-boost-pressure", {
	Text = "Velocidade",
	Default = 20,
	Min = 1,
	Max = 75,
	Rounding = 1,
	Compact = false,
	Callback = function(Value)
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end,
	Tooltip = "Regule a velocidade de movimento do jogador.",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

GroupCamera:AddToggle("free-cam-pressure", {
	Text = "Camera livre",
	Tooltip = "Câmera Livre",
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character
        local runService = game:GetService("RunService")
        local camera = workspace.CurrentCamera
        local speed = 1
        local touchControls = {}

        local function isMobile()
            return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
        end

        if state then
            camera.CameraType = Enum.CameraType.Scriptable
            if isMobile() then
                _G.Freecam = runService.RenderStepped:Connect(function()
                    local moveDirection = Vector3.new()
                    if touchControls["MoveForward"] then
                        moveDirection = moveDirection + camera.CFrame.LookVector
                    end
                    if touchControls["MoveBackward"] then
                        moveDirection = moveDirection - camera.CFrame.LookVector
                    end
                    if touchControls["MoveLeft"] then
                        moveDirection = moveDirection - camera.CFrame.RightVector
                    end
                    if touchControls["MoveRight"] then
                        moveDirection = moveDirection + camera.CFrame.RightVector
                    end
                    if touchControls["MoveUp"] then
                        moveDirection = moveDirection + camera.CFrame.UpVector
                    end
                    if touchControls["MoveDown"] then
                        moveDirection = moveDirection - camera.CFrame.UpVector
                    end

                    camera.CFrame = camera.CFrame + moveDirection * speed
                end)

                UserInputService.TouchStarted:Connect(function(touch, gameProcessedEvent)
                    if not gameProcessedEvent then
                        if touch.Position.Y < workspace.CurrentCamera.ViewportSize.Y / 2 then
                            touchControls["MoveForward"] = true
                        else
                            touchControls["MoveBackward"] = true
                        end
                    end
                end)

                UserInputService.TouchEnded:Connect(function(touch, gameProcessedEvent)
                    if not gameProcessedEvent then
                        touchControls["MoveForward"] = false
                        touchControls["MoveBackward"] = false
                    end
                end)
            else
                _G.Freecam = runService.RenderStepped:Connect(function()
                    local moveDirection = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                        moveDirection = moveDirection - camera.CFrame.UpVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                        moveDirection = moveDirection + camera.CFrame.UpVector
                    end

                    camera.CFrame = camera.CFrame + moveDirection * speed
                end)
            end
        else
            if _G.Freecam then
                _G.Freecam:Disconnect()
                _G.Freecam = nil
            end
            camera.CameraType = Enum.CameraType.Custom
        end
     end,
})

GroupCamera:AddSlider("field-of-view-pressure", {
	Text = "Field Of View",
	Default = 70,
	Min = 50,
	Max = 120,
	Rounding = 1,
	Compact = false,
	Callback = function(Value)
         game:GetService("Workspace").CurrentCamera.FieldOfView = Value
	end,
	Tooltip = "Regule o Fov da camera ",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})

local Msdoors_doorsEsp_Configs = {
    Types = {
        NormalDoor = {
            Name = "Porta",
            Color = Color3.fromRGB(125, 125, 125),
            MaxDistance = 1000,
            TextSize = 17,
            ShowTracer = true,
            ShowHighlight = false,
            ShowDistance = true,
            UpdateRate = 0.1
        },
    },
    GlobalSettings = {
        Enabled = false,
        DefaultMaxDistance = 1000,
        DefaultTextSize = 16,
        DefaultColor = Color3.fromRGB(255, 255, 255),
        RefreshRate = 0.1
    }
}

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau"))()
local Msdoors_doorsEsp_ActiveObjects = {}

local function Msdoors_doorsEsp_FormatDistance(distance)
    return string.format("%.1f", distance)
end

local function Msdoors_doorsEsp_ShouldAdd(part)
    if part.Name == "NormalDoor" and part.Parent and part.Parent.Name == "Entrances" then
        return true
    end
    return false
end

local function Msdoors_doorsEsp_GetConfig(part)
    return Msdoors_doorsEsp_Configs.Types[part.Name] or {
        Name = part.Name,
        Color = Msdoors_doorsEsp_Configs.GlobalSettings.DefaultColor,
        MaxDistance = Msdoors_doorsEsp_Configs.GlobalSettings.DefaultMaxDistance,
        TextSize = Msdoors_doorsEsp_Configs.GlobalSettings.DefaultTextSize,
        ShowTracer = true,
        ShowHighlight = true,
        ShowDistance = true,
        UpdateRate = Msdoors_doorsEsp_Configs.GlobalSettings.RefreshRate
    }
end

local function Msdoors_doorsEsp_Update(part)
    local config = Msdoors_doorsEsp_GetConfig(part)
    if Msdoors_doorsEsp_ActiveObjects[part] then
        ESPLibrary:Remove(part)
        Msdoors_doorsEsp_ActiveObjects[part] = nil
    end
    if Msdoors_doorsEsp_Configs.GlobalSettings.Enabled then
        Msdoors_doorsEsp_ActiveObjects[part] = ESPLibrary:Add({
            Name = config.Name,
            Model = part,
            Color = config.Color,
            MaxDistance = config.MaxDistance,
            TextSize = config.TextSize,
            ESPType = config.ShowHighlight and "Highlight" or "Box",
            FillColor = config.Color,
            OutlineColor = config.Color,
            Tracer = {
                Enabled = config.ShowTracer,
                Color = config.Color
            },
            CustomText = config.ShowDistance and function(model)
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - model.Position).Magnitude
                return string.format("%s [%sm]", config.Name, Msdoors_doorsEsp_FormatDistance(distance))
            end or nil
        })
    end
end

local function Msdoors_doorsEsp_HandleObject(part)
    if not Msdoors_doorsEsp_ShouldAdd(part) then return end
    Msdoors_doorsEsp_Update(part)
    spawn(function()
        local config = Msdoors_doorsEsp_GetConfig(part)
        while wait(config.UpdateRate) do
            if not part or not part.Parent then
                if Msdoors_doorsEsp_ActiveObjects[part] then
                    ESPLibrary:Remove(part)
                    Msdoors_doorsEsp_ActiveObjects[part] = nil
                end
                break
            end
            Msdoors_doorsEsp_Update(part)
        end
    end)
end

local function Msdoors_doorsEsp_ToggleSystem(enabled)
    Msdoors_doorsEsp_Configs.GlobalSettings.Enabled = enabled
    if not Msdoors_doorsEsp_Configs.GlobalSettings.Enabled then
        for part, _ in pairs(Msdoors_doorsEsp_ActiveObjects) do
            ESPLibrary:Remove(part)
        end
        Msdoors_doorsEsp_ActiveObjects = {}
    else
        for _, part in pairs(workspace:GetDescendants()) do
            Msdoors_doorsEsp_HandleObject(part)
        end
    end
end

workspace.DescendantAdded:Connect(function(part)
    if Msdoors_doorsEsp_Configs.GlobalSettings.Enabled then
        Msdoors_doorsEsp_HandleObject(part)
    end
end)

GroupEsp:AddToggle("Esp-doors-pressure", {
    Text = "Portas",
    Tooltip = "Esp Portas",
    Default = false,
    Callback = function(Value)
        Msdoors_doorsEsp_ToggleSystem(Value)
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
local ScreenGui = game.CoreGui:FindFirstChild("msdoors-water")
if not ScreenGui then
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "msdoors-water"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Enabled = true
end

MenuGroup:AddToggle("msdoors-watermark", {
	Text = "WaterMark Msdoors",
	DisabledTooltip = "I am disabled!",
	Default = true,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(value)
        ScreenGui.Enabled = value
	end,
})

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
SaveManager:SetFolder("msdoors/Natural-disater")
SaveManager:SetSubFolder("Natural-disaster")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
_G.MsdoorsLoaded = true

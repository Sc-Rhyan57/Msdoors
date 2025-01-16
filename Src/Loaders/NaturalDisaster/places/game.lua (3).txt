--[[ LIBRARY & API]]--
if _G.OrionLibLoaded then
    warn("[Msdoors] • Script já está carregado!")
    return
end
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local OrionLib = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Sc-Rhyan57/Msdoors/refs/heads/main/Library/OrionLibrary_msdoors.lua'))()
local Window = OrionLib:MakeWindow({IntroText = "Msdoors | V1",Icon = "rbxassetid://100573561401335", IntroIcon = "rbxassetid://95869322194132", Name = "MsDoors | Natural Disaster", HidePremium = false, SaveConfig = true, ConfigFolder = ".msdoors/places/natural-disaster"})
local MsdoorsNotify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Notification-doorsAPI/refs/heads/main/Msdoors/MsdoorsApi.lua"))()
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/MS-ESP/refs/heads/main/source.lua"))()
print("[Msdoors] • [✅] Inialização da livraria e apis")
_G.OrionLibLoaded = true

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
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Noclip = nil
local PathBeam = nil
local VelocityHandler = nil

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

--[[ TABS]]--
local GroupPrincipal = Window:MakeTab({
    Name = "Principal",
    Icon = "rbxassetid://7733954760",
    PremiumOnly = false
})
local TeleportsGroup = GroupPrincipal:AddSection({ Name = "Teleports"})
TeleportsGroup:AddLabel('<font color="#00FF34">Teleport between island and tower</font>')

--[[ TELEPORTES ]]--
TeleportsGroup:AddButton({
    Name = "Island",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-108, 49, 0)
    end
})

TeleportsGroup:AddButton({
    Name = "Tower",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-264, 196, 288)
    end
})
TeleportsGroup:AddLabel("")

local VisualsGroup = GroupPrincipal:AddSection({ Name = "Visuals"})
VisualsGroup:AddLabel('<font color="#00FF34">Things like Delete Screen Effects</font>')

--[[ VISUAIS ]]--
VisualsGroup:AddButton({
    Name = "Remove Sandstorm UI",
    Callback = function()
        game.Players.LocalPlayer.PlayerGui.SandStormGui:Destroy()
    end
})

VisualsGroup:AddButton({
    Name = "Remove Blizzard UI",
    Callback = function()
        game.Players.LocalPlayer.PlayerGui.BlizzardGui:Destroy()
    end
})

VisualsGroup:AddButton({
    Name = "Remove Ads",
    Callback = function()
        game:GetService("Workspace").BillboardAd:Destroy()
        game:GetService("Workspace")["Main Portal Template "]:Destroy()
        game:GetService("Workspace").ReturnPortal:Destroy()
    end
})

local GroupPlayers = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://7743871002",
    PremiumOnly = false
})
local GroupPlayer = GroupPlayers:AddSection({ Name = "movement"})
GroupPlayer:AddLabel('<font color="#00FF34">Speed hack, walk speed and player stuff.</font>')


--[[ PLAYER ]]--
GroupPlayer:AddButton({
	Name = "GodMode",
	Callback = function()
      		print("[Msdoors] • GodMode")
            game.Players.LocalPlayer.Character.Humanoid:Remove()
Instance.new('Humanoid', game.Players.LocalPlayer.Character)
game:GetService("Workspace")[game.Players.LocalPlayer.Name]:FindFirstChildOfClass(
'Humanoid').HipHeight = 2
  	end    
})

GroupPlayer:AddToggle({
    Name = "Autofarm",
    Default = false,
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
GroupPlayer:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 50,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

GroupPlayer:AddSlider({
    Name = "Gravity / Jump boost",
    Min = 0,
    Max = 196,
    Default = 196,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Gravity",
    Callback = function(value)
        game.Workspace.Gravity = value
    end
})

local FarmingGroup = GroupPlayers:AddSection({ Name = "Farming"})
FarmingGroup:AddLabel('<font color="#FF0000">Farm Systems</font>')

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
    
    FarmingGroup:AddToggle({
        Name = "AutoFarm wins",
        Default = false,
        Flag = "autofarm-natural",
        Save = true,
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
    
    FarmingGroup:AddButton({
        Name = "Instant Safe Teleport",
        Callback = function()
            if isCharacterValid() then
                teleportWithTween(config.locations.safe)
            end
        end
    })
    
    FarmingGroup:AddLabel('<font color="#00FF34">Status do AutoFarm</font>')
    local statusLabel = FarmingGroup:AddLabel('Waiting...')

    cache.RunService.Heartbeat:Connect(function()
        if getgenv().msdoors_isteleporting then
            statusLabel:Set('Status: Active - <font color="#FF0000">Farming....</font>')
        else
            statusLabel:Set('Status: Inactive - <font color="#00FF34">SafeMode</font>')
        end
    end)
    cache.LocalPlayer.CharacterAdded:Connect(function()
        if getgenv().msdoors_isteleporting then
            task.wait(0.5)
            connection = cache.RunService.Heartbeat:Connect(function()
                if not isCharacterValid() then return end
                cache.LocalPlayer.Character.HumanoidRootPart.CFrame = config.locations.farm
            end)
        end
    end)
end
initializeTeleportSystem()

local GroupExploits = Window:MakeTab({
    Name = "Exploits",
    Icon = "rbxassetid://7733655834",
    PremiumOnly = false
})
local GroupExploit = GroupExploits:AddSection({ Name = "map"})
GroupExploit:AddLabel('<font color="#00FF34">things like solid sland and solid water</font>')

GroupExploit:AddToggle({
    Name = "Walk On Water",
    Default = false,
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


GroupExploit:AddToggle({
    Name = "Solid Island",
    Default = false,
    Callback = function(state)
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v.Name == "LowerRocks" then
                v.CanCollide = state
            end
        end
    end
})

GroupExploit:AddToggle({
    Name = "Choose Map",
    Default = false,
    Callback = function(state)
        game.Players.LocalPlayer.PlayerGui.MainGui.MapVotePage.Visible = state
    end
})


GroupExploit:AddButton({
    Name = "Launch Rocket",
    Callback = function()
        pcall(function()
            fireclickdetector(game:GetService("Workspace").Structure["Launch Land"]["SPACESHIP!!"].Shuttle.IgnitionButton.ClickDetector)
            fireclickdetector(game:GetService("Workspace").Structure["Launch Land"].RocketStand.ConsoleLower.ReleaseButtonLower.ClickDetector)
            fireclickdetector(game:GetService("Workspace").Structure["Launch Land"].RocketStand.ConsoleUpper.ReleaseButtonUpper.ClickDetector)
            fireclickdetector(game:GetService("Workspace").Structure["Launch Land"].LoadingTower.Console.ReleaseEntryBridge.ClickDetector)
        end)
    end
})


GroupExploit:AddLabel('<font color="#FF0000">Use at your own risk.</font>')

local function preventSit()
    if Humanoid then
        Humanoid.Seated:Connect(function()
            Humanoid.Sit = false
        end)
    end
end
local function enableVFly()
    local camera = workspace.CurrentCamera
    local SPEED = 1
    local controls = {
        q = false,
        e = false,
        w = false,
        a = false,
        s = false,
        d = false
    }

    if VelocityHandler then return end
    
    VelocityHandler = RunService.RenderStepped:Connect(function()
        if not HumanoidRootPart then return end
        
        local velocity = Vector3.new()
        local look = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        
        if controls.w then
            velocity = velocity + look
        end
        if controls.s then
            velocity = velocity - look
        end
        if controls.a then
            velocity = velocity - right
        end
        if controls.d then
            velocity = velocity + right
        end
        if controls.q then
            velocity = velocity + Vector3.new(0, 1, 0)
        end
        if controls.e then
            velocity = velocity - Vector3.new(0, 1, 0)
        end
        
        if velocity.Magnitude > 0 then
            velocity = velocity.Unit * (SPEED * 50)
        end
        
        HumanoidRootPart.Velocity = velocity
    end)
    
    local function keyHandler(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode.Name:lower()
        if controls[key] ~= nil then
            controls[key] = input.UserInputState == Enum.UserInputState.Begin
        end
    end
    
    game:GetService("UserInputService").InputBegan:Connect(keyHandler)
    game:GetService("UserInputService").InputEnded:Connect(keyHandler)
end

local function disableVFly()
    if VelocityHandler then
        VelocityHandler:Disconnect()
        VelocityHandler = nil
    end
end

local WalkFlingVelocity = nil
local function enableWalkFling()
    if WalkFlingVelocity then return end
    WalkFlingVelocity = RunService.Heartbeat:Connect(function()
        if HumanoidRootPart and Humanoid.MoveDirection.Magnitude > 0 then
            HumanoidRootPart.Velocity = Vector3.new(
                HumanoidRootPart.Velocity.X * 7,
                HumanoidRootPart.Velocity.Y,
                HumanoidRootPart.Velocity.Z * 7
            )
        end
    end)
end

local function disableWalkFling()
    if WalkFlingVelocity then
        WalkFlingVelocity:Disconnect()
        WalkFlingVelocity = nil
    end
end

local function setupCharacter(char)
    Character = char
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    preventSit()
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)

local isEnabled = false
local aura = nil
local currentTarget = nil

local function enableNoclip()
    if Noclip then return end
    Noclip = RunService.Stepped:Connect(function()
        if Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    if Noclip then
        Noclip:Disconnect()
        Noclip = nil
    end
end

local function createPathToTarget(target)
    if PathBeam and PathBeam.Parent then 
        PathBeam:Destroy() 
    end
    
    PathBeam = Instance.new("Beam")
    local a0 = Instance.new("Attachment")
    local a1 = Instance.new("Attachment")
    
    a0.Parent = HumanoidRootPart
    a1.Parent = target.Character.HumanoidRootPart
    
    PathBeam.Attachment0 = a0
    PathBeam.Attachment1 = a1
    PathBeam.Width0 = 1
    PathBeam.Width1 = 1
    PathBeam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    PathBeam.FaceCamera = true
    PathBeam.Parent = workspace
    
    return function()
        if PathBeam and PathBeam.Parent then
            PathBeam:Destroy()
        end
        if a0 and a0.Parent then
            a0:Destroy()
        end
        if a1 and a1.Parent then
            a1:Destroy()
        end
        PathBeam = nil
    end
end

local function createAura()
    if aura then return end
    
    aura = Instance.new("Part")
    aura.Shape = Enum.PartType.Ball
    aura.Size = Vector3.new(15, 15, 15) 
    aura.Material = Enum.Material.ForceField
    aura.CanCollide = false
    aura.Anchored = true
    aura.Transparency = 0.5
    aura.Parent = workspace
    
    local hue = 0
    RunService.Heartbeat:Connect(function()
        if not isEnabled then
            if aura and aura.Parent then
                aura:Destroy()
            end
            aura = nil
            return
        end
        
        if HumanoidRootPart then
            aura.Position = HumanoidRootPart.Position
            hue = (hue + 1) % 360
            aura.Color = Color3.fromHSV(hue/360, 1, 1)
        end
    end)
end

local function moveToTarget(target, cleanupPath)
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then 
        if cleanupPath then cleanupPath() end
        return false 
    end

    local distance = (targetRoot.Position - HumanoidRootPart.Position).magnitude
    if distance > 10 then
        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, targetRoot.Position)
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -distance/2)
        return true
    end
    
    return false
end

local function flingPlayer(target)
    local targetCharacter = target.Character
    if not targetCharacter then return end
    
    local startTime = tick()
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    while tick() - startTime < 5 and isEnabled and currentTarget == target do
        HumanoidRootPart.CFrame = targetRoot.CFrame
        HumanoidRootPart.Velocity = Vector3.new(99999, 99999, 99999)
        task.wait()
    end
end

local hudText = Drawing.new("Text")
hudText.Visible = false
hudText.Center = true
hudText.Outline = true
hudText.Font = 2
hudText.Size = 20
hudText.Color = Color3.fromRGB(255, 255, 255)
hudText.Position = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X/2, 50)

local function updateHUD(targetName)
    hudText.Text = "Current Target: " .. targetName
    hudText.Visible = true
end

local function processTarget(target)
    if not target.Character or target == LocalPlayer then return end
    
    currentTarget = target
    updateHUD(target.Name)
    
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local distance = (targetRoot.Position - HumanoidRootPart.Position).Magnitude
    local cleanupPath = nil
    
    if distance > 2000 then
        cleanupPath = createPathToTarget(target)
        enableNoclip()
        
        while distance > 10 and isEnabled do
            if not moveToTarget(target, cleanupPath) then break end
            distance = (targetRoot.Position - HumanoidRootPart.Position).Magnitude
            task.wait()
        end
        
        if cleanupPath then cleanupPath() end
        disableNoclip()
    end
    
    flingPlayer(target)
end

GroupExploit:AddToggle({
    Name = "fling all",
    Default = false,
    Callback = function(Value)
        isEnabled = Value
        hudText.Visible = Value
        
        if not Value then
            disableNoclip()
            disableVFly()
            disableWalkFling()
            if PathBeam and PathBeam.Parent then 
                PathBeam:Destroy() 
            end
            return
        end
        
        createAura()
        enableVFly()
        enableWalkFling()
        preventSit()
        
        spawn(function()
            while isEnabled do
                for _, target in pairs(Players:GetPlayers()) do
                    if not isEnabled then break end
                    processTarget(target)
                end
                task.wait(1)
            end
        end)
    end
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

VisualsGroup:AddLabel('<font color="#00FF34">see disasters before they appear.</font>')
VisualsGroup:AddToggle({
    Name = "warn of disasters",
    Default = false,
    Callback = function(estado)
        _G.msdoors_desastre.ativo = estado
        if estado then
            monitorarDesastre()
        else
            pararMonitoramento()
        end
    end
})

VisualsGroup:AddToggle({
    Name = "Send disasters in chat",
    Default = false,
    Callback = function(value)
        _G.msdoors_chatActive = value
    end
})
    
--// ADDONS \\--
task.spawn(function()
     local AddonTab = Window:MakeTab({Name = "Addons [BETA]", Icon = "rbxassetid://7733799901", PremiumOnly = false})
    AddonTab:AddLabel('<font color="#FF0000">This tab is for unofficial Msdoors addons! We are not responsible for anything!</font>')
   
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

local GroupCredits = Window:MakeTab({
    Name = "Msdoors",
    Icon = "rbxassetid://7733765045",
    PremiumOnly = false
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
            OrionLib:MakeNotification({
                Name = "Link Copiado!",
                Content = "Seu executor não suporta redirecionar. Link copiado.",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "LOL",
                Content = "Seu executor não suporta redirecionar ou copiar links.",
                Time = 5
            })
        end
    end
})
GroupCredits:AddLabel('<font color="#FF0000">Script</font>')
GroupCredits:AddButton({
    Name = "Descarregar",
    Callback = function()
        for _, thread in pairs(getfenv()) do
            if typeof(thread) == "thread" then
                task.cancel(thread)
            end
        end
      
        notificationsEnabled = false
        InstaInteractEnabled = false
        AutoInteractEnabled = false
        initialized = false
        verificarEspObjetos = false
        desativarESPObjetos()
      
        if OrionLib then
            OrionLib:Destroy()
        end
        warn("[Msdoors] • Todos os sistemas foram desativados e a interface fechada.")
    end
})

OrionLib:Init()
_G.MsdoorsLoaded = true

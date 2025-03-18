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
}

local GroupAuto = Tabs.Main:AddRightGroupbox("Automoção")

-- Variáveis principais
local AutoWardrobeEntities = {}

-- Configurações de distância para entidades
local EntityDistances = {
    ["RushMoving"] = {
        Distance = 100,
        Loader = 175
    },
    ["BackdoorRush"] = {
        Distance = 100,
        Loader = 175
    },
    ["AmbushMoving"] = {
        Distance = 155,
        Loader = 200
    },
    ["A60"] = {
        Distance = 200,
        Loader = 200
    },
    ["A120"] = {
        Distance = 200,
        Loader = 200
    }
}

-- Nomes dos esconderijos por tipo de mapa
local HidingPlaceName = {
    ["Hotel"] = "Closet",
    ["Backdoor"] = "Closet",
    ["Fools"] = "Closet",
    ["Retro"] = "Closet",
    ["Rooms"] = "Locker",
    ["Mines"] = "Locker"
}

-- Função para exibir mensagens no jogo
local function msg(message)
    local mainGame = require(LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
    mainGame.caption(message, true)
end

-- Função de notificação
local function Notify(options)
    if not _G.msdoors_autohide_notifications then return end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = options.Title or "",
        Text = options.Description or "",
        Duration = options.Duration or 6
    })
end

-- Função para verificar se uma entidade está no campo de visão do jogador
local function IsInViewOfPlayer(part, maxDistance, exclusions)
    if not part then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    
    local character = LocalPlayer.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not rootPart or not head then return false end
    
    local distance = (rootPart.Position - part.Position).Magnitude
    if distance > maxDistance then return false end
    
    local direction = (part.Position - head.Position).Unit
    local ray = Ray.new(head.Position, direction * distance)
    
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, exclusions or {character})
    return hit and hit:IsDescendantOf(part.Parent)
end

-- Função para calcular distância do personagem
local function DistanceFromCharacter(position)
    if typeof(position) == "Instance" then
        if position:IsA("Model") then
            if position.PrimaryPart then
                position = position.PrimaryPart.Position
            else
                position = position:GetPivot().Position
            end
        elseif position:IsA("BasePart") then
            position = position.Position
        else
            return math.huge
        end
    end
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    
    return (LocalPlayer.Character.HumanoidRootPart.Position - position).Magnitude
end

-- Função para encontrar o prompt mais próximo que atende a uma condição
local function GetNearestPromptWithCondition(condition)
    local closestPrompt = nil
    local closestDistance = math.huge
    
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and condition(prompt) then
            local distance = DistanceFromCharacter(prompt.Parent)
            if distance < closestDistance then
                closestPrompt = prompt
                closestDistance = distance
            end
        end
    end
    
    return closestPrompt
end

-- Função para gerar exclusões para o auto wardrobe
local function GenerateAutoWardrobeExclusions(targetWardrobePrompt)
    local currentRoom = LocalPlayer:GetAttribute("CurrentRoom")
    if not workspace.CurrentRooms:FindFirstChild(currentRoom) then return {targetWardrobePrompt.Parent} end
    
    local ignore = { targetWardrobePrompt.Parent }
    
    if workspace.CurrentRooms[currentRoom]:FindFirstChild("Assets") then
        for _, asset in pairs(workspace.CurrentRooms[currentRoom].Assets:GetChildren()) do
            if asset.Name == "Pillar" then table.insert(ignore, asset) end
        end
    end
    
    return ignore
end

-- Função principal do Auto Wardrobe
local function HandleAutoWardrobe(child, index)
    -- Verificações iniciais
    if not child then return end
    if not child:IsDescendantOf(workspace) then return end
    
    -- Verificar toggles
    if not _G.msdoors_autohide or not LocalPlayer:GetAttribute("Alive") then
        index = index or table.find(AutoWardrobeEntities, child)
        if index then
            table.remove(AutoWardrobeEntities, index)
        end
        return
    end
    
    local floorName = _G.msdoors_floor or "Hotel"
    local NotifPrefix = "Auto " .. HidingPlaceName[floorName]
    
    Notify({
        Title = NotifPrefix,
        Description = "Procurando um esconderijo",
        Duration = 6
    })
    
    local entityIndex = #AutoWardrobeEntities + 1
    AutoWardrobeEntities[entityIndex] = child
    
    -- Função para buscar prompt de esconderijo
    local targetWardrobeChecker = function(prompt)
        if not prompt.Parent then return false end
        if not prompt.Parent:FindFirstChild("HiddenPlayer") then return false end
        if prompt.Parent:FindFirstChild("Main") and prompt.Parent.Main:FindFirstChild("HideEntityOnSpot") then
            if prompt.Parent.Main.HideEntityOnSpot.Whispers.Playing == true then return false end
        end
        
        return prompt.Name == "HidePrompt" and 
               (prompt.Parent:GetAttribute("LoadModule") == "Wardrobe" or 
                prompt.Parent:GetAttribute("LoadModule") == "Bed" or 
                prompt.Parent.Name == "Rooms_Locker") and 
               not prompt.Parent.HiddenPlayer.Value and 
               DistanceFromCharacter(prompt.Parent) < prompt.MaxActivationDistance * 2
    end
    
    local targetWardrobePrompt = GetNearestPromptWithCondition(targetWardrobeChecker)
    
    local function getPrompt()
        if not targetWardrobePrompt or DistanceFromCharacter(targetWardrobePrompt:FindFirstAncestorWhichIsA("Model"):GetPivot().Position) > 15 then
            repeat task.wait()
                targetWardrobePrompt = GetNearestPromptWithCondition(targetWardrobeChecker)
            until targetWardrobePrompt ~= nil or 
                  LocalPlayer.Character:GetAttribute("Hiding") or 
                  (not _G.msdoors_autohide or not LocalPlayer:GetAttribute("Alive") or not child or not child:IsDescendantOf(workspace))
        end
    end
    
    getPrompt()
    
    -- Verificar se já está escondido
    if LocalPlayer.Character:GetAttribute("Hiding") then return end
    if not _G.msdoors_autohide or not LocalPlayer:GetAttribute("Alive") then return end
    
    Notify({
        Title = NotifPrefix,
        Description = "Iniciando...",
        Duration = 6
    })
    
    local exclusion = GenerateAutoWardrobeExclusions(targetWardrobePrompt)
    local attempts, maxAttempts = 0, 60
    
    -- Verificar se está seguro
    local function isSafeCheck(addMoreDist)
        local isSafe = true
        for _, entity in pairs(AutoWardrobeEntities) do
            if isSafe == false then break end
            
            local distanceEntity = EntityDistances[entity.Name].Distance
            
            local entityDeleted = (entity == nil or entity.Parent == nil)
            local inView = IsInViewOfPlayer(entity.PrimaryPart, distanceEntity + (addMoreDist == true and 15 or 0), exclusion)
            local isClose = DistanceFromCharacter(entity:GetPivot().Position) < distanceEntity + (addMoreDist == true and 15 or 0)
            
            isSafe = entityDeleted == true and true or (inView == false and isClose == false)
            if isSafe == false then break end
        end
        
        return isSafe
    end
    
    -- Esperar até ser seguro sair
    local function waitForSafeExit()
        if child.Name == "A120" then
            repeat task.wait() until not child:IsDescendantOf(workspace) or 
                                     (child.PrimaryPart and child.PrimaryPart.Position.Y < -10) or 
                                     (not LocalPlayer:GetAttribute("Alive") or not LocalPlayer.Character:GetAttribute("Hiding"))
        else
            local didPlayerSeeEntity = false
            local distance = EntityDistances[child.Name].Distance
            
            task.spawn(function()
                repeat task.wait()
                    if not LocalPlayer:GetAttribute("Alive") or not child or not child:IsDescendantOf(workspace) then break end
                    
                    if LocalPlayer.Character:GetAttribute("Hiding") and IsInViewOfPlayer(child.PrimaryPart, distance, exclusion) then
                        didPlayerSeeEntity = true
                        break
                    end
                until false
            end)
            
            repeat task.wait(0.15)
                local isSafe = isSafeCheck()
                if didPlayerSeeEntity == true and isSafe == true then
                    Notify({
                        Title = NotifPrefix,
                        Description = "Saindo do esconderijo, entidade está longe.",
                        Duration = 6
                    })
                    break
                else
                    if isSafe == true and not child:IsDescendantOf(workspace) then
                        Notify({
                            Title = NotifPrefix,
                            Description = "Saindo do esconderijo, entidade foi deletada.",
                            Duration = 6
                        })
                        break
                    end
                end
                
                if not LocalPlayer:GetAttribute("Alive") then
                    Notify({
                        Title = NotifPrefix,
                        Description = "Parando (você morreu)",
                        Duration = 6
                    })
                    break
                end
            until false
        end
        
        return true
    end
    
    -- Função para esconder
    local function hide()
        if (LocalPlayer.Character:GetAttribute("Hiding") and LocalPlayer.Character.HumanoidRootPart.Anchored) then return false end
        
        getPrompt()
        repeat task.wait()
            attempts += 1
            
            -- Tentar ativar o proximity prompt
            fireproximityprompt(targetWardrobePrompt)
        until attempts > maxAttempts or not LocalPlayer:GetAttribute("Alive") or (LocalPlayer.Character:GetAttribute("Hiding") and LocalPlayer.Character.HumanoidRootPart.Anchored)
        
        if attempts > maxAttempts or not LocalPlayer:GetAttribute("Alive") then return false end
        return true
    end
    
    -- Lógica específica para Ambush
    if child.Name == "AmbushMoving" then
        local LastPos = child:GetPivot().Position
        local IsMoving = false
        
        task.spawn(function()
            repeat task.wait(0.01)
                local diff = (LastPos - child:GetPivot().Position) / 0.01
                LastPos = child:GetPivot().Position
                IsMoving = diff.Magnitude > 0
            until not child or not child:IsDescendantOf(workspace)
        end)
        
        repeat task.wait()
            Notify({
                Title = NotifPrefix,
                Description = "Esperando Ambush se aproximar...",
                Duration = 6
            })
            
            repeat task.wait() until (IsMoving == true and DistanceFromCharacter(child:GetPivot().Position) <= EntityDistances[child.Name].Distance) or 
                                     (not child or not child:IsDescendantOf(workspace))
            
            if not child or not child:IsDescendantOf(workspace) then break end
            
            local success = hide()
            if success then
                Notify({
                    Title = NotifPrefix,
                    Description = "Esperando até ser seguro sair...",
                    Duration = 6
                })
                
                repeat task.wait() until (IsMoving == false and DistanceFromCharacter(child:GetPivot().Position) >= EntityDistances[child.Name].Distance) or 
                                         (not child or not child:IsDescendantOf(workspace))
                
                if not child or not child:IsDescendantOf(workspace) then break end
                
                -- Desbloquear câmera
                game.ReplicatedStorage.EntityInfo.CamLock:FireServer()
            end
        until (not child or not child:IsDescendantOf(workspace)) or not LocalPlayer:GetAttribute("Alive")
    else
        -- Lógica para outras entidades
        repeat task.wait() until isSafeCheck(true) == false
        
        repeat
            local success = hide()
            if success then
                local finished = waitForSafeExit()
                repeat task.wait() until finished == true
                game.ReplicatedStorage.EntityInfo.CamLock:FireServer()
            end
            
            task.wait()
        until isSafeCheck()
    end
    
    table.remove(AutoWardrobeEntities, entityIndex)
    Notify({
        Title = NotifPrefix,
        Description = "Finalizado.",
        Duration = 6
    })
end

-- Pegando o nome do andar atual
local floorName = _G.msdoors_floor or "Hotel"

-- Adicionando os toggles diretamente na interface LinoriaLib
-- Toggle para Auto Armário
LeftGroupBox:AddToggle("AutoHide", {
	Text = "Auto " .. HidingPlaceName[floorName],
	DisabledTooltip = "I am disabled!",
	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,
	Callback = function(Value)
            _G.msdoors_autohide = Value
	end,
})


-- Toggle para notificações
GroupAuto:AddToggle("AutoWardrobeNotif", {
    Text = "Auto " .. HidingPlaceName[floorName] .. " Notificações",
    Default = false,
    
    Callback = function(Value)
        _G.msdoors_autohide_notifications = Value
    end,
})

GroupAuto:AddDivider()

-- Monitoramento de entidades
local entitiesOfInterest = {
    "RushMoving",
    "AmbushMoving",
    "BackdoorRush",
    "A60",
    "A120"
}

-- Monitorar o workspace por novas entidades
workspace.ChildAdded:Connect(function(child)
    if table.find(entitiesOfInterest, child.Name) then
        task.wait(0.5) -- Pequeno delay para garantir que a entidade esteja totalmente carregada
        HandleAutoWardrobe(child)
    end
end)

-- Monitorar mudança de sala
LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    local currentRoom = LocalPlayer:GetAttribute("CurrentRoom")
    if currentRoom then
        msg("Sala atual: " .. currentRoom)
    end
end)

local OrionLib = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Giangplay/Script/main/Orion_Library_PE_V2.lua'))()
local Window = OrionLib:MakeWindow({IntroText = "Msdoors | V1",Icon = "rbxassetid://133997875469993", IntroIcon = "rbxassetid://133997875469993", Name = "MsDoors", HidePremium = false, SaveConfig = true, ConfigFolder = ".msdoors/places/hotel"})
--// APIS \\--
--[[ MSDOORS API ]]--
local MsdoorsNotify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Notification-doorsAPI/refs/heads/main/Msdoors/MsdoorsApi.lua"))()
--[[ MS ESP(@mstudio45) - thanks for the API! ]]--
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/MS-ESP/refs/heads/main/source.lua"))()
---[[ ELEMENTOS ]]--

MsdoorsNotify("Msdoors","Inicializado com sucesso!","Execução","rbxassetid://133997875469993", Color3.new(0.5, 0, 0.5), 5)
if game.PlaceId == 6516141723 then
MsdoorsNotify("Msdoors","Por favor, execute no jogo não no lobby!","Execução","rbxassetid://133997875469993", Color3.new(0.5, 0, 0.5), 6)
end


MsdoorsNotify("Atualização","Você está usando uma versão desatualizada do Msdoors!","Nova versão disponível no github","rbxassetid://133997875469993", Color3.new(255, 0, 0), 15)

local Oldversion = Window:MakeTab({
    Name = "Atualizar Script",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Oldversion:AddButton({
    Name = "Atualizar",
    Callback = function()
        OrionLib:Destroy() loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Msdoors/refs/heads/main/download/main.lua"))()
    end
})

--// Serviços \\--
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

local LocalPlayer = Players.LocalPlayer
local LatestRoom = ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")

--// Tabela de Itens Prompt \\--
local PromptTable = {
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
    },
    Clip = {
        "AwesomePrompt",
        "FusesPrompt",
        "HerbPrompt",
        "LeverPrompt",
        "LootPrompt",
        "ValvePrompt",
        "LeverForGate",
        "LiveBreakerPolePickup",
        "LiveHintBook",
        "Button",
    },
    Excluded = {
        Prompt = {
            "HintPrompt",
            "HidePrompt",
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
}
--[[ 👾 AUTO LOOT ]]--
--// VARIÁVEIS \\--
local autoLootEnabled = false
local autoLootAtivo = false

local function AutoLoot()
    while autoLootAtivo do
        for _, comodo in pairs(workspace.CurrentRooms:GetChildren()) do
            local assets = comodo:FindFirstChild("Assets")
            if assets then
                for _, v in pairs(assets:GetChildren()) do
                    if v.Name == "ChestBox" or 
                       v.Name == "GoldPile" or 
                       v.Name == "Crucifix" or 
                       v.Name == "KeyObtain" or 
                       v.Name == "Gold" or
                       v.Name == "LootPrompt" or 
                       v.Name == "LeverPrompt" or 
                       v.Name == "SkullPrompt" or
                       v.Name == "UnlockPrompt" or
                       v.Name == "ValvePrompt" then

                        local prompt = v:FindFirstChildWhichIsA("ProximityPrompt")
                        if prompt and prompt.Enabled then
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end
        end
        wait(0.1)
    end
end

--[[ 🏃 OBJETIVOS ESP ]]--
local objetos_esp = { 
    {"KeyObtain", "Chave", Color3.fromRGB(0, 255, 0)},
    {"LeverForGate", "Alavanca", Color3.fromRGB(0, 255, 0)},
    {"ElectricalKeyObtain", "Chave elétrica", Color3.fromRGB(0, 255, 0)},
    {"LiveHintBook", "Livro", Color3.fromRGB(0, 255, 0)},
    {"LiveBreakerPolePickup", "Disjuntor", Color3.fromRGB(0, 255, 0)},
    {"MinesGenerator", "Gerador", Color3.fromRGB(0, 255, 0)},
    {"MinesGateButton", "Botão do portão", Color3.fromRGB(0, 255, 0)},
    {"FuseObtain", "Fusível", Color3.fromRGB(0, 255, 0)},
    {"MinesAnchor", "Torre", Color3.fromRGB(0, 255, 0)},
    {"WaterPump", "Bomba de água", Color3.fromRGB(0, 255, 0)}
}

local espAtivosObjetos = {}
local espAtivoObjetos = false
local verificarEspObjetos = false

local function encontrarObjetosEsp(nomeObjeto)
    local objetosEncontrados = {}
    for _, objeto in ipairs(workspace:GetDescendants()) do
        if objeto.Name == nomeObjeto then
            table.insert(objetosEncontrados, objeto)
        end
    end
    return objetosEncontrados
end

local function aplicarESPObjetos(objeto, nome, cor)
    local highlightColor = cor or BrickColor.random().Color

    local Tracer = ESPLibrary.ESP.Tracer({
        Model = objeto,
        MaxDistance = 5000,
        From = "tracerDirection",
        Color = highlightColor
    })

    local Billboard = ESPLibrary.ESP.Billboard({
        Name = nome,
        Model = objeto,
        MaxDistance = 5000,
        Color = highlightColor
    })

    local Highlight = ESPLibrary.ESP.Highlight({
        Name = nome,
        Model = objeto,
        MaxDistance = 5000,
        FillColor = highlightColor,
        OutlineColor = highlightColor,
        TextColor = highlightColor
    })
    
    
    return {Tracer = Tracer, Billboard = Billboard, Highlight = Highlight}
end

local function ativarESPObjetos()
    for _, objData in ipairs(objetos_esp) do
        local objetosEncontrados = encontrarObjetosEsp(objData[1])
        if #objetosEncontrados > 0 then
            for _, objeto in ipairs(objetosEncontrados) do
                local espElementos = aplicarESPObjetos(objeto, objData[2], objData[3])
                table.insert(espAtivosObjetos, espElementos)
            end
        else
            warn("[ ⚠️ MsDoors - Aviso ] O objeto " .. objData[1] .. " não foi encontrado!")
        end
    end
end

local function desativarESPObjetos()
    for _, espElementos in ipairs(espAtivosObjetos) do
        if espElementos.Tracer then espElementos.Tracer:Destroy() end
        if espElementos.Billboard then espElementos.Billboard:Destroy() end
        if espElementos.Highlight then espElementos.Highlight:Destroy() end
    end
    espAtivosObjetos = {} 
end

local function verificarNovosObjetos()
    while verificarEspObjetos do
        if espAtivoObjetos then
            ativarESPObjetos()
        end
        wait(5)
    end
end

--[[ 👾 ESP ENTIDADE ]]--
local entidades = { 
    {"RushMoving", "Rush", Color3.fromRGB(255, 0, 0)},
    {"AmbushMoving", "Ambush", Color3.fromRGB(0, 255, 0)},
    {"Snare", "Armadilha", Color3.fromRGB(255, 0, 0)},
    {"FigureRig", "Figure", Color3.fromRGB(255, 0, 0)},
    {"A60", "A-60", Color3.fromRGB(255, 0, 0)},
    {"A120", "A-120", Color3.fromRGB(255, 0, 0)},
    {"GiggleCeiling", "Giggle", Color3.fromRGB(255, 0, 0)},
    {"GrumbleRig", "Grumbo", Color3.fromRGB(255, 0, 0)},
    {"BackdoorRush", "Blitz", Color3.fromRGB(255, 0, 0)},
    {"Entity10", "Entidade 10", Color3.fromRGB(128, 128, 0)}
}

local espAtivos = {}
local espAtivo = false
local verificarEsp = false

local function encontrarEntidades(nomeEntidade)
    local entidadesEncontradas = {}
    for _, entidade in ipairs(workspace:GetDescendants()) do
        if entidade.Name == nomeEntidade then
            table.insert(entidadesEncontradas, entidade)
        end
    end
    return entidadesEncontradas
end

local function aplicarESP(entidade, nome, cor)
    local highlightColor = cor or BrickColor.random().Color

    local Tracer = ESPLibrary.ESP.Tracer({
        Model = entidade,
        MaxDistance = 5000,
        From = "Bottom",
        Color = highlightColor
    })

    local Billboard = ESPLibrary.ESP.Billboard({
        Name = nome,
        Model = entidade,
        MaxDistance = 5000,
        Color = highlightColor
    })

    local Highlight = ESPLibrary.ESP.Highlight({
        Name = nome,
        Model = entidade,
        MaxDistance = 5000,
        FillColor = highlightColor,
        OutlineColor = highlightColor,
        TextColor = highlightColor
    })
    
    return {Tracer = Tracer, Billboard = Billboard, Highlight = Highlight}
end

local function ativarESP()
    for _, entData in ipairs(entidades) do
        local entidadesEncontradas = encontrarEntidades(entData[1])
        if #entidadesEncontradas > 0 then
            for _, entidade in ipairs(entidadesEncontradas) do
                local espElementos = aplicarESP(entidade, entData[2], entData[3])
                table.insert(espAtivos, espElementos)
            end
        else
            warn("[ ⚠️ MsDoors - Aviso ] A Entidade " .. entData[1] .. " não foi encontrada para aplicar o esp!")
        end
    end
end

local function desativarESP()
    for _, espElementos in ipairs(espAtivos) do
        if espElementos.Tracer then espElementos.Tracer:Destroy() end
        if espElementos.Billboard then espElementos.Billboard:Destroy() end
        if espElementos.Highlight then espElementos.Highlight:Destroy() end
    end
    espAtivos = {} 
end

local function verificarNovasEntidades()
    while verificarEsp do
        if espAtivo then
            ativarESP()
        end
        wait(5)
    end
end

--[[ 💺 ESP PARA ITENS ]]--
local esp_loot = {
    {"Item", nil, Color3.fromRGB(0, 255, 0)}  -- Define apenas a cor, nome real será extraído
}

local esp_loot_ativos = {}
local esp_loot_ativado = false
local verificar_esp_loot = false
local localPlayer = game.Players.LocalPlayer

local function encontrarLootESP(nome_loot)
    local loot_encontrado = {}
    for _, loot in ipairs(workspace:GetDescendants()) do
        if loot.Name == nome_loot then
            table.insert(loot_encontrado, loot)
        end
    end
    return loot_encontrado
end

local function aplicarESPLoot(loot, cor)
    local cor_destaque = cor or BrickColor.random().Color
    local nome_verdadeiro = loot.Name 

    local Tracer = ESPLibrary.ESP.Tracer({
        Model = loot,
        MaxDistance = 5000,
        From = "Bottom",
        Color = cor_destaque
    })

    local Billboard = ESPLibrary.ESP.Billboard({
        Name = nome_verdadeiro,
        Model = loot,
        MaxDistance = 5000,
        Color = cor_destaque
    })

    local Highlight = ESPLibrary.ESP.Highlight({
        Name = nome_verdadeiro,
        Model = loot,
        MaxDistance = 5000,
        FillColor = cor_destaque,
        OutlineColor = cor_destaque,
        TextColor = cor_destaque
    })

    RunService.RenderStepped:Connect(function()
        if loot and loot:IsDescendantOf(workspace) and esp_loot_ativado then
            local distancia = (localPlayer.Character.HumanoidRootPart.Position - loot.Position).Magnitude
            Billboard:SetName(string.format("%s [%.0f]", nome_verdadeiro, distancia))
        end
    end)

    return {Tracer = Tracer, Billboard = Billboard, Highlight = Highlight}
end

local function ativarESPLoot()
    for _, lootData in ipairs(esp_loot) do
        local loot_encontrado = encontrarLootESP(lootData[1])
        if #loot_encontrado > 0 then
            for _, loot in ipairs(loot_encontrado) do
                local espElementos = aplicarESPLoot(loot, lootData[3])
                table.insert(esp_loot_ativos, espElementos)
            end
        else
            warn("[ ⚠️ MsDoors - Aviso ] Não foi possível adicionar ESP a " .. lootData[1] .. " pois não foi encontrado!")
        end
    end
end

local function desativarESPLoot()
    for _, espElementos in ipairs(esp_loot_ativos) do
        if espElementos.Tracer then espElementos.Tracer:Destroy() end
        if espElementos.Billboard then espElementos.Billboard:Destroy() end
        if espElementos.Highlight then espElementos.Highlight:Destroy() end
    end
    esp_loot_ativos = {} 
end

local function verificarNovoLoot()
    while verificar_esp_loot do
        if esp_loot_ativado then
            ativarESPLoot()
        end
        wait(5)
    end
end

-- DOOR ESP
local portas_esp = {
    {"Door", "Porta", Color3.fromRGB(241, 196, 15)}
}

local espAtivosPortas = {}
local doorEspAtivo = false
local verificarEspPortas = false

local function encontrarPortasESP(nomePorta)
    local portasEncontradas = {}
    for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
        if room:FindFirstChild(nomePorta) and room[nomePorta]:FindFirstChild(nomePorta) then
            table.insert(portasEncontradas, room[nomePorta][nomePorta])
        end
    end
    return portasEncontradas
end

local function aplicarESPPorta(porta, nome, cor)
    local highlightColor = cor or BrickColor.random().Color

    local Tracer = ESPLibrary.ESP.Tracer({
        Model = porta,
        MaxDistance = 5000,
        From = "Bottom",
        Color = highlightColor
    })

    local Billboard = ESPLibrary.ESP.Billboard({
        Name = nome,
        Model = porta,
        MaxDistance = 5000,
        Color = highlightColor
    })

    local Highlight = ESPLibrary.ESP.Highlight({
        Name = nome,
        Model = porta,
        MaxDistance = 5000,
        FillColor = highlightColor,
        OutlineColor = highlightColor,
        TextColor = highlightColor
    })


    return {Tracer = Tracer, Billboard = Billboard, Highlight = Highlight}
end

local function ativarDoorESP()
    for _, portaData in ipairs(portas_esp) do
        local portasEncontradas = encontrarPortasESP(portaData[1])
        if #portasEncontradas > 0 then
            for _, porta in ipairs(portasEncontradas) do
                local room = porta.Parent.Parent 
                local doorNumber = tonumber(room.Name) + 1
                local opened = room.Door:GetAttribute("Opened")
                local locked = room:GetAttribute("RequiresKey")

                local doorState = opened and "[Aberta]" or (locked and "[Trancada]" or "")
                local espElementos = aplicarESPPorta(porta, portaData[2] .. " " .. doorNumber .. " " .. doorState, portaData[3])

                room.Door:GetAttributeChangedSignal("Opened"):Connect(function()
                    if espElementos.Billboard then
                        espElementos.Billboard:SetText(portaData[2] .. " " .. doorNumber .. " [Aberta]")
                    end
                end)

                table.insert(espAtivosPortas, espElementos)
            end
        else
            warn("[ ⚠️ Msdoors - Avisos ] A Porta " .. portaData[1] .. " não foi encontrada!")
        end
    end
end

local function desativarDoorESP()
    for _, espElementos in ipairs(espAtivosPortas) do
        if espElementos.Tracer then espElementos.Tracer:Destroy() end
        if espElementos.Billboard then espElementos.Billboard:Destroy() end
        if espElementos.Highlight then espElementos.Highlight:Destroy() end
    end
    espAtivosPortas = {}
end

local function verificarNovasPortas()
    while verificarEspPortas do
        if doorEspAtivo then
            ativarDoorESP()
        end
        wait(5)
    end
end

--------------------[[ 🌟 FUNÇÕES DO MSDOORS 🌟 ]]--------------------
--------------------[[ 🏃 NOCLIP 🏃 ]]--------------------------------


--------------------[[ 💻 ANTI LAG ]]--------------------------------
local antiLagEnabled = false
local antiLagConnection

local function ActivateAntiLag(notify)
    if not antiLagEnabled then return end  

    game.Lighting.FogEnd = 1e10
    game.Lighting.FogStart = 1e10
    game.Lighting.Brightness = 2
    game.Lighting.GlobalShadows = false
    game.Lighting.EnvironmentDiffuseScale = 0
    game.Lighting.EnvironmentSpecularScale = 0

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Material ~= Enum.Material.Plastic then
            obj.Material = Enum.Material.Plastic
        elseif obj:IsA("Decal") then
            obj.Transparency = 1
        end
    end

    if not antiLagConnection then
        antiLagConnection = workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("BasePart") and obj.Material ~= Enum.Material.Plastic then
                obj.Material = Enum.Material.Plastic
            elseif obj:IsA("Decal") then
                obj.Transparency = 1
            end
        end)
    end

    if notify then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔔 Notificação",
            Text = "Anti Lag ativo",
            Icon = "rbxassetid://13264701341",
            Duration = 5
        })

        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://4590657391"
        sound.Volume = 1
        sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end

local function DeactivateAntiLag()
    game.Lighting.FogEnd = 500
    game.Lighting.FogStart = 0
    game.Lighting.Brightness = 1
    game.Lighting.GlobalShadows = true
    game.Lighting.EnvironmentDiffuseScale = 1
    game.Lighting.EnvironmentSpecularScale = 1

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Material == Enum.Material.Plastic then
            obj.Material = Enum.Material.SmoothPlastic
        elseif obj:IsA("Decal") then
            obj.Transparency = 0
        end
    end

    if antiLagConnection then
        antiLagConnection:Disconnect()
        antiLagConnection = nil
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔔 Notificação",
        Text = "Anti Lag Desativado",
        Icon = "rbxassetid://13264701341",
        Duration = 5
    })

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://4590657391"
    sound.Volume = 1
    sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local function onRoomChanged()
    if antiLagEnabled then
        ActivateAntiLag(false)
    end
end

local latestRoom = game.ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")
latestRoom:GetPropertyChangedSignal("Value"):Connect(onRoomChanged)

--------------------[[ 📝 NOTIFICAR ENTIDADE 📝 ]]--------------------------------
--// Tabela de Entidades para notificação.
local EntityTable = {
    ["Names"] = {"BackdoorRush", "BackdoorLookman", "RushMoving", "AmbushMoving", "Eyes", "JeffTheKiller", "A60", "A120"},
    ["NotifyReason"] = {
        ["A60"] = { ["Image"] = "12350986086", ["Title"] = "Alerta A-60", ["Description"] = "Entidade A-60 detectada!" },
        ["A120"] = { ["Image"] = "12351008553", ["Title"] = "Cuidado com A-120", ["Description"] = "Entidade A-120 se aproximando!" },
        ["HaltRoom"] = { ["Image"] = "11331795398", ["Title"] = "Halt Detected", ["Description"] = "Prepare-se para o Halt!",  ["Spawned"] = true },
        ["BackdoorRush"] = { ["Image"] = "11102256553", ["Title"] = "Backdoor Rush", ["Description"] = "Rush se aproximando pelo backdoor!" },
        ["RushMoving"] = { ["Image"] = "11102256553", ["Title"] = "Rush em Movimento", ["Description"] = "Rush foi visto se movendo." },
        ["AmbushMoving"] = { ["Image"] = "10938726652", ["Title"] = "Ambush em Movimento", ["Description"] = "Ambush está ativo." },
        ["Eyes"] = { ["Image"] = "10865377903", ["Title"] = "Olhos!", ["Description"] = "Não olhe para os olhos!", ["Spawned"] = true },
        ["BackdoorLookman"] = { ["Image"] = "16764872677", ["Title"] = "Backdoor Lookman", ["Description"] = "Lookman foi visto!", ["Spawned"] = true },
        ["JeffTheKiller"] = { ["Image"] = "98993343", ["Title"] = "Jeff está Aqui", ["Description"] = "Fuja do Jeff the Killer!" }
    }
}

local notificationsEnabled = false

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
MonitorEntities()

function NotifyEntity(entityName)
    if EntityTable.NotifyReason[entityName] then
        local notificationData = EntityTable.NotifyReason[entityName]
        
            MsdoorsNotify(
            notificationData.Title,
            notificationData.Description,
            "Entidade nasceu!",
            "rbxassetid://" .. notificationData.Image,
            Color3.new(255, 0, 0), 
            6
        )
        
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://10469938989"
        sound.Volume = 3
        sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end


--------------------[[ 📚 AUTO LIBRARY CODE 📚 ]]--------------------------------
local mainUI = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainUI", 2.5)
local function DoorsNotify(options)
    local title = options.Title or "No Title"
    local description = options.Description or "No Text"
    local image = options.Image or "rbxassetid://6023426923"
    local time = options.Time or 5
    local color = options.Color

    if mainUI then
        local achievement = mainUI.AchievementsHolder.Achievement:Clone()
        achievement.Size = UDim2.new(0, 0, 0, 0)
        achievement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
        achievement.Name = "LiveAchievement"
        achievement.Visible = true

        achievement.Frame.Details.Desc.Text = description
        achievement.Frame.Details.Title.Text = title
        achievement.Frame.ImageLabel.Image = image

        if color then
            achievement.Frame.TextLabel.TextColor3 = color
            achievement.Frame.UIStroke.Color = color
            achievement.Frame.Glow.ImageColor3 = color
        end

        achievement.Parent = mainUI.AchievementsHolder
        achievement.Sound.SoundId = "rbxassetid://10469938989"
        achievement.Sound.Volume = 1
        achievement.Sound:Play()

        achievement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", 0.8, true)
        task.wait(0.8)
        achievement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)

        task.delay(time, function()
            achievement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
            task.wait(0.5)
            achievement:Destroy()
        end)
    end
end

local function LogNotification(level, message)
    local title, color, icon
    if level == "SUCESSO" then
        title, color, icon = "🟩 MsDoors", Color3.fromRGB(0, 255, 0), "rbxassetid://13311697821"
    elseif level == "ERRO" then
        title, color, icon = "🟥 MsDoors", Color3.fromRGB(255, 0, 0), "rbxassetid://13369776727"
    else -- Em análise
        title, color, icon = "🟨 MsDoors", Color3.fromRGB(255, 255, 0), "rbxassetid://97983317580515"
    end

    DoorsNotify({
        Title = title,
        Description = message,
        Image = icon,
        Time = 5,
        Color = color
    })
end

local function AutoLibrarySolver(value)
    if value then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if not otherPlayer.Character then continue end
            local tool = otherPlayer.Character:FindFirstChildOfClass("Tool")

            if tool and tool.Name:match("LibraryHintPaper") then
                local code = Script.Functions.GetPadlockCode(tool)
                local padlock = Workspace:FindFirstChild("Padlock", true)

                if tonumber(code) then
                    if Script.Functions.DistanceFromCharacter(padlock) <= Options.AutoLibraryDistance then
                        Script.RemotesFolder.PL:FireServer(code)
                        LogNotification("SUCESSO", "Cadeado desbloqueado com o código correto.")
                    else
                        LogNotification("ERRO", "Distância insuficiente para desbloquear o cadeado.")
                    end
                else
                    LogNotification("ERRO", "Código inválido detectado.")
                end
            else
                LogNotification("+-", "Procurando LibraryHintPaper...")
            end
        end
    else
        LogNotification("ERRO", "Auto Library Solver desativado.")
    end
end


--------------------// 📱 INTERFACE 📱\\--------------------------------
--// CRÉDITOS \\--
local CreditsTab = Window:MakeTab({
    Name = "Créditos - Msdoors",
    Icon = "rbxassetid://7743875759",
    PremiumOnly = false
})
local CdSc = CreditsTab:AddSection({
    Name = "Créditos"
})

CdSc:AddParagraph("Rhyan57", "• Criador e fundador do Msdoors.")
CdSc:AddParagraph("SeekAlegriaFla", "• Ajudante e coletor de files.")

--------------------[[ 💻 VISUAL 💻 ]]--------------------------------
local VisualsEsp = Window:MakeTab({
    Name = "Configuração Visual",
    Icon = "rbxassetid://7733741741",
    PremiumOnly = false
})

local EspVisu = VisualsEsp:AddSection({
	Name = "Esp functions"
})

--// 🔄 ELEMENTOS --  VisualEsp \\--
EspVisu:AddParagraph("🎨 ESP", "• Ver Objetos itens e mais através da parede.")

--{ 🚪 DOOR ESP / BOTÃO }--
EspVisu:AddToggle({
    Name = "door esp",
    Default = false,
    Callback = function(state)
        doorEspAtivo = state
        if doorEspAtivo then
            verificarEspPortas = true
            spawn(verificarNovasPortas)
        else
            verificarEspPortas = false
            desativarDoorESP()
        end
    end
})

--{ 👾 ESP ENTIDADES / BOTÃO }--
EspVisu:AddToggle({
    Name = "esp entidade",
    Default = false,
    Callback = function(state)
        espAtivo = state
        if espAtivo then
            verificarEsp = true
            spawn(verificarNovasEntidades)
        else
            verificarEsp = false
            desativarESP()
        end
    end
})

--{ 📝 ESP OBJETIVO / BOTÃO }--
EspVisu:AddToggle({
    Name = "esp de objetivo",
    Default = false,
    Callback = function(state)
        espAtivoObjetos = state
        if espAtivoObjetos then
            verificarEspObjetos = true
            spawn(verificarNovosObjetos)
        else
            verificarEspObjetos = false
            desativarESPObjetos()
        end
    end
})

--{ 🛍️ ESP ITENS / BOTÃO }--

EspVisu:AddToggle({
    Name = "esp loot",
    Default = false,
    Callback = function(state)
        esp_loot_ativado = state
        if esp_loot_ativado then
            verificar_esp_loot = true
            spawn(verificarNovoLoot)
        else
            verificar_esp_loot = false
            desativarESPLoot()
        end
    end
})

local playerVisu = VisualsEsp:AddSection({
	Name = "Player Functions"
})

playerVisu:AddParagraph("📸 Player", "Funções visuais do jogador.")

--{ ♻️ ANTI LAG / BOTÃO }--
playerVisu:AddToggle({
    Name = "Anti Lag",
    Default = false,
    Callback = function(Value)
        antiLagEnabled = Value
        if Value then
            ActivateAntiLag(true)
        else
            DeactivateAntiLag()
        end
    end
})
--{ 📸 REMOVE CUTSCENE / BOTÃO }--
local Toggles = shared.Toggles or {}
local Options = shared.Options or {}
shared.LocalPlayer = Players.LocalPlayer
shared.Character = shared.LocalPlayer and shared.LocalPlayer.Character
local Script = shared.Script or {}

playerVisu:AddToggle({
    Name = "No Cutscenes",
    Default = false,
    Callback = function(value)
        if Script.MainGame then
            local cutscenes = Script.MainGame:FindFirstChild("Cutscenes", true)
            if cutscenes then
                for _, cutscene in pairs(cutscenes:GetChildren()) do
                    if table.find(Script.CutsceneExclude, cutscene.Name) then continue end
                    local defaultName = cutscene.Name:gsub("_", "")
                    cutscene.Name = value and "_" .. defaultName or defaultName
                end
            end
        end

        if Script.FloorReplicated then
            for _, cutscene in pairs(Script.FloorReplicated:GetChildren()) do
                if not cutscene:IsA("ModuleScript") or table.find(Script.CutsceneExclude, cutscene.Name) then continue end
                local defaultName = cutscene.Name:gsub("_", "")
                cutscene.Name = value and "_" .. defaultName or defaultName
            end
        end
    end
})


playerVisu:AddToggle({
    Name = "Translucent Hiding Spot",
    Default = false,
    Callback = function(value)
        if value and shared.Character and shared.Character:GetAttribute("Hiding") then
            for _, obj in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if not obj:IsA("ObjectValue") and obj.Name ~= "HiddenPlayer" then continue end
                if obj.Value == shared.Character then
                    task.spawn(function()
                        local affectedParts = {}
                        for _, v in pairs(obj.Parent:GetChildren()) do
                            if not v:IsA("BasePart") then continue end
                            v.Transparency = Options.HidingTransparency and Options.HidingTransparency.Value or 0.5
                            table.insert(affectedParts, v)
                        end

                        repeat task.wait()
                            for _, part in pairs(affectedParts) do
                                part.Transparency = Options.HidingTransparency and Options.HidingTransparency.Value or 0.5
                            end
                        until not shared.Character:GetAttribute("Hiding") or not Toggles["Translucent Hiding Spot"].Value

                        for _, v in pairs(affectedParts) do
                            v.Transparency = 0
                        end
                    end)
                    break
                end
            end
        end
    end
})


playerVisu:AddToggle({
    Name = "Fullbright",
    Default = false,
    Callback = function(value)
        if value then
            Lighting.Ambient = Color3.new(1, 1, 1)
        else
            if alive then
                Lighting.Ambient = workspace.CurrentRooms[localPlayer:GetAttribute("CurrentRoom")]:GetAttribute("Ambient")
            else
                Lighting.Ambient = Color3.new(0, 0, 0)
            end
        end
    end
})

playerVisu:AddToggle({
    Name = "No Fog",
    Default = false,
    Callback = function(value)
        if not Lighting:GetAttribute("FogStart") then Lighting:SetAttribute("FogStart", Lighting.FogStart) end
        if not Lighting:GetAttribute("FogEnd") then Lighting:SetAttribute("FogEnd", Lighting.FogEnd) end

        Lighting.FogStart = value and 0 or Lighting:GetAttribute("FogStart")
        Lighting.FogEnd = value and math.huge or Lighting:GetAttribute("FogEnd")

        local fog = Lighting:FindFirstChildOfClass("Atmosphere")
        if fog then
            if not fog:GetAttribute("Density") then fog:SetAttribute("Density", fog.Density) end

            fog.Density = value and 0 or fog:GetAttribute("Density")
        end
    end
})


local notifsTab = VisualsEsp:AddSection({
    Name = "Notificações"
})
notifsTab:AddParagraph("🔔 Notificações", "Painel de controlhe para notificações.")

--{ 🔔 Notificação de Entidades / BOTÃO }--
notifsTab:AddToggle({
    Name = "Notificar Entidades",
    Default = false,
    Callback = function(value)
        notificationsEnabled = value
        local sound = Instance.new("Sound")
        if value then
            sound.SoundId = "rbxassetid://4590657391"
            sound.Volume = 1
            sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            sound:Play()
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
            MsdoorsNotify("MsDoors", "Notificações de Entidades ativas!", "", "rbxassetid://133997875469993", Color3.new(0, 1, 0), 3)
        else
            sound.SoundId = "rbxassetid://4590662766"
            sound.Volume = 1
            sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            sound:Play()
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
            MsdoorsNotify("MsDoors", "Notificações de Entidades desativadas!", "", "rbxassetid://133997875469993", Color3.new(1, 0, 0), 3)
        end
    end
})

--------------------[[ 💻 AUTOMAÇÃO 💻 ]]--------------------------------
local autoIn = Window:MakeTab({
    Name = "Automoção",
    Icon = "rbxassetid://7733765045",
    PremiumOnly = false
})

--{ 📚 Auto Library Code/ BOTÃO }--
autoIn:AddToggle({
    Name = "Auto Library Code",
    Default = false,
    Callback = function(value)
        AutoLibrarySolver(value)
    end
})

local function PromptCondition(prompt)
    local modelAncestor = prompt:FindFirstAncestorOfClass("Model")
    return prompt:IsA("ProximityPrompt") and 
        not table.find(PromptTable.Excluded.Prompt, prompt.Name) and 
        not table.find(PromptTable.Excluded.Parent, prompt.Parent and prompt.Parent.Name or "") and 
        not table.find(PromptTable.Excluded.ModelAncestor, modelAncestor and modelAncestor.Name or "")
end
local function AutoInteractWithPrompt(prompt)
    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
        fireproximityprompt(prompt)
    end
end
local function CheckPrompts()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if PromptCondition(prompt) then
            AutoInteractWithPrompt(prompt)
        end
    end
end

local function AdjustPromptProperties(prompt)
    task.defer(function()
        if not prompt:GetAttribute("Hold") then prompt:SetAttribute("Hold", prompt.HoldDuration) end
        if not prompt:GetAttribute("Distance") then prompt:SetAttribute("Distance", prompt.MaxActivationDistance) end
        if not prompt:GetAttribute("Enabled") then prompt:SetAttribute("Enabled", prompt.Enabled) end
        if not prompt:GetAttribute("Clip") then prompt:SetAttribute("Clip", prompt.RequiresLineOfSight) end
    end)
    
    task.defer(function()
        prompt.MaxActivationDistance = prompt:GetAttribute("Distance") * 1 -- Ajuste da distância multiplicada
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
    end)
    
    table.insert(PromptTable.GamePrompts, prompt)
end

local function ChildCheck(child)
    if PromptCondition(child) then
        AdjustPromptProperties(child)
    end
end

--{ ☝️ AUTO INTERACT / BOTÃO }--
local autoInteractEnabled = false
autoIn:AddToggle({
    Name = "Auto Interact",
    Default = false,
    Callback = function(Value)
        autoInteractEnabled = Value
        if Value then
            while autoInteractEnabled do
                CheckPrompts()
                task.wait(1)
            end
        end
    end
})
workspace.DescendantAdded:Connect(ChildCheck)
CheckPrompts()

--{ ☝️ AUTO LOOT / BOTÃO }--
autoIn:AddToggle({
    Name = "Auto Loot",
    Default = false,
    Callback = function(estado)
        autoLootAtivo = estado
        if autoLootAtivo then
            task.spawn(AutoLoot) 
        end
    end
})


local connections = {}

local function antiEyes()
    for _, instance in pairs(Workspace:GetChildren()) do
        if instance.Name == "Eyes" then
            instance:Destroy()
        end
    end
end

local function antiScreech()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local head = character:FindFirstChild("Head")

    if head then
        local screechAttack = head:FindFirstChild("Screech")
        if screechAttack then
            screechAttack:Destroy()
        end
    end
end

local function antiHalt()
    for _, instance in pairs(Workspace:GetChildren()) do
        if instance.Name == "Halt" then
            instance:Destroy()
        end
    end
end

--------------------[[ 💻 EXPLOITS 💻 ]]--------------------------------
local ExploitsTab = Window:MakeTab({
    Name = "Exploits",
    Icon = "rbxassetid://7743873633",
    PremiumOnly = false
})

--// Anti Entity Tab \\--
local AntiMonstersTab = ExploitsTab:AddSection({Name = "Anti-Entity"})

AntiMonstersTab:AddToggle({
    Name = "Anti Eyes(it broke)",
    Default = false,
    Callback = function(Value)
        if Value then
            connections.antiEyes = RunService.RenderStepped:Connect(antiEyes) 
        else
            if connections.antiEyes then connections.antiEyes:Disconnect() end
        end
    end
})

AntiMonstersTab:AddToggle({
    Name = "Anti Screech(it broke)",
    Default = false,
    Callback = function(Value)
        if Value then
            connections.antiScreech = RunService.RenderStepped:Connect(antiScreech)
        else
            if connections.antiScreech then connections.antiScreech:Disconnect() end
        end
    end
})

AntiMonstersTab:AddToggle({
    Name = "Anti Halt",
    Default = false,
    Callback = function(Value)
        if Value then
            connections.antiHalt = RunService.RenderStepped:Connect(antiHalt)
        else
            if connections.antiHalt then connections.antiHalt:Disconnect() end
        end
    end
})


--[EM BREVE]--

--[[ Byppas Area ]]--
local ByTab = Window:MakeTab({
    Name = "Byppas",
    Icon = "rbxassetid://7733964370",
    PremiumOnly = false
})

--[ EM BREVE ]--

--[ Itens ]--
local ItensTab = Window:MakeTab({
    Name = "Itens",
    Icon = "rbxassetid://7733914390",
    PremiumOnly = false
})

ItensTab:AddButton({
    Name = "💊 Vitamina Fake",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/Fun%C3%A7%C3%B5es/Sc/GiveVitamns.lua"))()
    end
})

-- Local Player
local GameLocal = Window:MakeTab({
    Name = "Funções do player",
    Icon = "rbxassetid://7733799795",
    PremiumOnly = false
})
local playerLocal = GameLocal:AddSection({
	Name = "Player Functions"
})

local FloorTab = Window:MakeTab({
    Name = "Floors",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

--// ADDONS \\--
task.spawn(function()

    local AddonTab = Window:MakeTab({Name = "Addons [BETA]", Icon = "rbxassetid://4483345998", PremiumOnly = false})

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


listModFiles()
OrionLib:Init()

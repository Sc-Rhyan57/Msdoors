print("[Msdoors] • Está é uma versão cancelada! trate de atualizar.")

--//Serviços\\--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--//APIS\\--

--//FUNCTIONS\\--
local scriptUrl = "https://github.com/Sc-Rhyan57/Msdoors/tree/main/Src/Loaders/Doors/"
local gameId = game.GameId
local placeId = game.PlaceId

local supportedPlaceIds = {
    [6516141723] = "lobby.lua", -- Lobby
    [6839171747] = "hotel.lua", -- Doors
    [10549820578] = "hotel.lua", -- Fools2023
    [101112] = "script4.lua",
    [131415] = "script5.lua"
}

-- Verifica se o jogo é suportado
if not supportedPlaceIds[placeId] then

      local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://2389339814"
    sound.Volume = 5
    sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "MsDoors",
        Text = "Msdoors não Oferece suporte a este jogo.",
        Icon = "rbxassetid://133997875469993",
        Duration = 8
    })
  
    return
end

if not game:IsLoaded() then
    game.Loaded:Wait()
    task.wait(4)
end
task.wait(1)

local currentFloor = ReplicatedStorage:WaitForChild("GameData", 10):WaitForChild("Floor", 10).Value

local scriptName = supportedPlaceIds[placeId]
if scriptName then
    loadstring(game:HttpGet(scriptUrl .. scriptName))()
end

local queueOnTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport
if queueOnTeleport then
    queueOnTeleport('loadstring(game:HttpGet("' .. scriptUrl .. 'default-tab.lua"))()')
end

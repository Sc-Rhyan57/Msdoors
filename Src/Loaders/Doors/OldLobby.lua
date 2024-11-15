local OrionLib = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Giangplay/Script/main/Orion_Library_PE_V2.lua'))()
local Window = OrionLib:MakeWindow({IntroText = "Msdoors | V1 ",Icon = "rbxassetid://133997875469993", IntroIcon = "rbxassetid://133997875469993", Name = "MsDoors | PRE HOTEL Lobby", HidePremium = false, SaveConfig = true, ConfigFolder = ".msdoors/places/Oldlobby"})

--[[ APIS ]]--
local MsdoorsNotify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Notification-doorsAPI/refs/heads/main/Msdoors/MsdoorsApi.lua"))()

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://4590656842"
sound.Volume = 2
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)

MsdoorsNotify("Msdoors", "Script Inicializado.", "Execução", "rbxassetid://6023426923", Color3.new(128, 0, 128), 5)


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
local MSoldLobby = Window:MakeTab({
	Name = "Funções",
	Icon = "rbxassetid://7733924046",
	PremiumOnly = false
})

MSoldLobby:AddButton({
	Name = "Teleport to PRE HOTEL LOBBY",
	Callback = function()
		game:GetService("TeleportService"):Teleport(110258689672367)
	end    
})

MSoldLobby:AddButton({
	Name = "Teleport to HOTEL LOBBY",
	Callback = function()
		game:GetService("TeleportService"):Teleport(6516141723)
	end    
})

OrionLib:Init()

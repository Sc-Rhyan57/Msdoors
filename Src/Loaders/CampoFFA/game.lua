--// <Campos de Armas[FFA]> | UPDATE EM BREVEL \\--

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

local Window = Library:CreateWindow({
    Title = "Msdoors v1",
    Footer = "Game: Campos de Armas[FFA] | Build: 0.1.3",
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

local GroupExploits = Tabs.Main:AddLeftGroupbox("Exploits")
GroupExploits:AddLabel('<font color="#FF0000">Exploits como Aimbot.</font>')

local GroupExtras = Tabs.Main:AddRightGroupbox("Extras")
GroupExtras:AddLabel('<font color="#9DABFF">Sistemas Extras.</font>')

GroupExploits:AddToggle("Aimbot", {
    Text = "Aimbot[NEW]",
    Default = false,
    Tooltip = "Aimbot",
    Callback = function(value)
        aimbotEnabled = value
        	Library:Notify({
		Title = value and "Aimbot Ativado" or "Aimbot Desativado",
		Description = value and "Agora o Aimbot está ativo!" or "O Aimbot foi desativado!",
		Time = 5,
	      })

     end
})
GroupExploits:AddDropdown("aim-mira", {
	Values = { "Head", "Torso" },
	Default = Head,
	Multi = false,
	Text = "Mira",
	Tooltip = "Parte do corpo em que a mira deve grudar.",
	DisabledTooltip = "I am disabled!",
	Searchable = false,
	Callback = function(optio )
	        aimbotPart = option
	end,
	Disabled = false,
	Visible = true,
})
GroupExploits:AddSlider("aim-distancia", {
	Text = "Distância para aimbot",
	Default = 250,
	Min = 0,
	Max = 500,
	Rounding = 1,
	Compact = false,
	Callback = function(value)
	   maxDistance = value
	end,
	Tooltip = "Definir distância em que o aimbot deve começar a funcionar.",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
})
GroupExploits:AddToggle("Aim-ignorar-time", {
    Text = "Ignorar jogadores do meu time",
    Default = false,
    Tooltip = "Ignora os jogadores do seu time atual.",
    Callback = function(value)
        ignoreTeams = value
     end
})


GroupExtras:AddButton({
	Text = "Expandir hitbox[NEW]",
	Func = function()
	print("[Msdoors] • Hitbox dos jogadores expandidas.") loadstring(game:HttpGet("https://mscripts.vercel.app/scfiles/hitbox-expander.lua"))()
	end,
	DoubleClick = false,
	Tooltip = "Expand all hitboxes",
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
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
    Tooltip = "Interage com todos carrinhos no botão play/stop"
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
	Library:Notify({
		Title = "Fechando...",
		Description = "Aguarde estamos cuidando de tudo!.",
		Time = 5,
	})
   AutofarmWin:SetValue(false)
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
SaveManager:SetFolder("msdoors/Campos-de-armas-ffa")
SaveManager:SetSubFolder("Campos-de-armas-ffa")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
_G.MsdoorsLoaded = true

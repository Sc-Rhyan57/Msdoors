if _G.ObsidianaLib then
    warn("[Msdoors] • Script já carregado!")
    return
end
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
----------------------------
--[[ VARIAVEIS GLOBAIS ]]--
_G.msdoors_LibraryNotif = _G.msdoors_LibraryNotif or "Linoria"
_G.ObsidianaLib = true
--[[ ESP SETTINGS ]]--
_G.msdoors_OutlineTr = _G.msdoors_OutlineTr or 0
_G.msdoors_tracePos = _G.msdoors_tracePos or "Bottom"
_G.msdoors_TextSize = _G.msdoors_TextSize or 16
_G.msdoors_tracerSt = _G.msdoors_tracerSt or false
_G.msdoors_arrowSt = _G.msdoors_arrowSt or false

--// ESP COLORS \\--
_G.msdoors_entityColor = _G.msdoors_entityColor or Color3.fromRGB(255, 0, 0)
_G.msdoors_objectiveColor = _G.msdoors_objectiveColor or Color3.fromRGB(0, 255, 0)
_G.msdoors_DoorEspColor = _G.msdoors_DoorEspColor or Color3.fromRGB(100, 200, 255)

local Window = Library:CreateWindow({
    Title = "Msdoors v1",
    Footer = "Build: 0.1.3 | Game: Doors Lobby",
    Icon = "95869322194132",
    NotifySide = "Right",
    ShowCustomCursor = true
})


local Tabs = {
    Main = Window:AddTab("Principal", "house"),
    Credits = Window:AddTab("Créditos", "axe"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

--// CRÉDITS PAGE \\--
local GroupCredits = Tabs.Credits:AddLeftGroupbox("Créditos")
local GroupMain = Tabs.Main:AddLeftGroupbox("Player")

--// PAGES \\--
GroupMain:AddLabel('<font color="#00FFFF">EM BREVE!</font>')
--// ADDONS \\--
task.spawn(function()
    local AddonTab = Window:AddTab("Addons [BETA]", "package-plus")

    if not isfolder("msdoors/addons") then
        makefolder("msdoors/addons")
    end

    local function AddAddonElement(Group, Element)
        if not Element or type(Element) ~= "table" then return end

        if Element.Type == "Label" then
            Group:AddLabel(Element.Arguments.Text or "Sem Texto")
        elseif Element.Type == "Toggle" then
            Group:AddToggle(Element.Name, {
                Text = Element.Arguments.Text or "Sem Nome",
                Default = Element.Arguments.Default or false,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "Button" then
            Group:AddButton({
                Text = Element.Arguments.Text or "Botão",
                Func = Element.Arguments.Callback
            })
        elseif Element.Type == "Slider" then
            Group:AddSlider(Element.Name, {
                Text = Element.Arguments.Text or "Slider",
                Min = Element.Arguments.Min,
                Max = Element.Arguments.Max,
                Default = Element.Arguments.Default,
                Rounding = Element.Arguments.Rounding or 0,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "Input" then
            Group:AddInput(Element.Name, {
                Default = Element.Arguments.Default or "",
                Text = Element.Arguments.Text or "Entrada",
                Numeric = Element.Arguments.Numeric or false,
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "Dropdown" then
            Group:AddDropdown(Element.Name, {
                Values = Element.Arguments.Values or {},
                Default = Element.Arguments.Default,
                Multi = Element.Arguments.Multi or false,
                Text = Element.Arguments.Text or "Dropdown",
                Callback = Element.Arguments.Callback
            })
        elseif Element.Type == "ColorPicker" then
            Group:AddColorPicker(Element.Name, {
                Default = Element.Arguments.Default or Color3.new(1, 1, 1),
                Text = Element.Arguments.Text or "Cor",
                Callback = Element.Arguments.Callback
            })
	elseif Element.Type == "Divider" then
            Group:AddDivider()
        elseif Element.Type == "KeyPicker" then
            Group:AddKeyPicker(Element.Name, {
                Default = Element.Arguments.Default,
                Text = Element.Arguments.Text or "Atalho",
                Callback = Element.Arguments.Callback
            })
        else
            warn("[MsDoors Addons] Elemento '" .. tostring(Element.Name) .. "' não carregado: Tipo inválido.")
        end
    end

    local containAddonsLoaded = false

    for _, file in pairs(listfiles("msdoors/addons")) do
        print("[MsDoors Addons] Carregando addon '" .. file:gsub("msdoors/addons/", "") .. "'...")
        if not (file:match("%.lua$") or file:match("%.txt$") or file:match("%.luau$")) then
            continue
        end

        local success, errorMessage = pcall(function()
            local fileContent = readfile(file)
            local addon = loadstring(fileContent)()

            if type(addon.Name) ~= "string" or type(addon.Elements) ~= "table" then
                warn("[MsDoors Addons] Addon '" .. file:gsub("msdoors/addons/", "") .. "' não carregado: Nome/Elementos inválidos.")
                return 
            end

            containAddonsLoaded = true

            local AddonGroup = AddonTab:AddLeftGroupbox(addon.Name)
            AddonGroup:AddLabel(addon.Description or "Sem descrição.")

            for _, element in pairs(addon.Elements) do
                AddAddonElement(AddonGroup, element)
            end
        end)

        if not success then
            warn("[MsDoors Addons] Falha ao carregar addon '" .. file:gsub("msdoors/addons/", "") .. "':", errorMessage)
        end
    end

    if not containAddonsLoaded then
        local EmptyGroup = AddonTab:AddLeftGroupbox("Nenhum Addon Encontrado")
        EmptyGroup:AddLabel("A pasta 'msdoors/addons' está vazia. Adicione addons e reinicie o script.")
    end
end)

-- Credits[ Tenha bom senso ]
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
local MenuInterface = Tabs["UI Settings"]:AddLeftGroupbox("Interface")
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
local MenuDiscord = Tabs["UI Settings"]:AddRightGroupbox("Discord")

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
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "85%", "95%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddDivider()
MenuGroup:AddButton("Unload", function()
    Library:Notify({
        Title = "Fechando...",
        Description = "Aguarde, estamos cuidando de tudo!",
        Time = 5,
    })

    print("[Msdoors] • Tudo foi descarregado! Até outra hora 😉")
end)

_G.webhookEnabled = _G.webhookEnabled or false
_G.msdoors_webhook = _G.msdoors_webhook or "https://discord.com/api/webhooks/seu_id/seu_token"

function SendEmbed(options)
    if not _G.webhookEnabled then
        return
    end
    
    options = options or {}
    local OSTime = os.time()
    local Time = os.date("!*t", OSTime)
    
    local webhookData = {
        content = options.content or "",
        username = options.username,       
        avatar_url = options.avatar_url,   
        tts = options.tts or false,         
        embeds = {}
    }
    if options.title or options.description then
        local embed = {
            title = options.title,
            description = options.description,
            url = options.url,      
            color = options.color or 0,     
            timestamp = options.timestamp or string.format("%d-%d-%dT%02d:%02d:%02dZ", 
                Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec),
            fields = options.fields or {},
        }
        
        if options.author_name then
            embed.author = {
                name = options.author_name,
                url = options.author_url,
                icon_url = options.author_icon_url
            }
        end

        if options.footer_text then
            embed.footer = {
                text = options.footer_text or game.JobId,
                icon_url = options.footer_icon_url
            }
        else
            embed.footer = { text = game.JobId }
        end
        
        if options.image_url then
            embed.image = {
                url = options.image_url
            }
        end

        if options.thumbnail_url then
            embed.thumbnail = {
                url = options.thumbnail_url
            }
        end
        
        table.insert(webhookData.embeds, embed)
    end
    (syn and syn.request or http_request) {
        Url = _G.msdoors_webhook,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = game:GetService("HttpService"):JSONEncode(webhookData)
    }

end

MenuDiscord:AddLabel('• Enviar informações que estão ocorrendo\n no jogo em um chat\n específico no <font color="#9DABFF">Discord</font>')
MenuDiscord:AddToggle("Webhook", {
    Text = "Webhook",
    Default = _G.webhookEnabled,
    Disabled = false,
    Callback = function(Value)
        _G.webhookEnabled = Value
    end,
})
MenuDiscord:AddDivider()
MenuDiscord:AddInput("webhooklink", {
    Default = _G.msdoors_webhook,
    Numeric = false,
    Finished = false, 
    ClearTextOnFocus = true,
    Text = "Insira o link do Webhook",
    Callback = function(Value)
        _G.msdoors_webhook = Value
    end,
})
MenuDiscord:AddButton({
    Text = "Definir Webhook",
    Func = function()
        Notify({
            Title = "SUCESSO!",
            Description = "Webhook atualizado!",
            Image = "rbxassetid://95869322194132",
            Color = Color3.fromRGB(0, 0, 255),
            Style = "SISTEMA",
            Duration = 6,
            NotifyStyle = _G.msdoors_LibraryNotif
        })
    end
})
MenuDiscord:AddDivider()
MenuDiscord:AddButton({
    Text = "Testar webhook",
    Func = function()
        SendEmbed({
            username = "Msdoors bot",
            avatar_url = "https://msdoors-gg.vercel.app/favicon.ico",
            content = "dsc.gg/msdoors-gg",      
            title = "Entidade spawnou!",             
            description = "**Rush** Spawnou!",          
            url = "https://www.roblox.com/games/",       
            color = 65280,                                 
            author_name = "Rush",
            author_url = "https://msdoors-gg.vercel.app/favicon.ico",
            author_icon_url = "https://msdoors-gg.vercel.app/favicon.ico",
            footer_text = "msdoors • " .. game.JobId,
            footer_icon_url = "https://i.imgur.com/footer.png",
            image_url = "https://i.imgur.com/imagem.png",
            thumbnail_url = "https://i.imgur.com/thumb.png",
            fields = {
                { name = "Campo 1", value = "Valor 1", inline = true },
                { name = "Campo 2", value = "Valor 2", inline = true },
                { name = "Campo 3", value = "Valor 3", inline = false }
            }
        })
    end
})

MenuInterface:AddDropdown("LibraryDropdown", {
    Values = { "Obsidian", "Linoria" },
    Default = "Obsidian",
    Multi = false,
    Text = "Biblioteca",
    Tooltip = "Selecione qual biblioteca usar",
    Callback = function(selected)
        if selected == "Obsidian" then
            _G.msdoors_syslibrary = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
        elseif selected == "Linoria" then
            _G.msdoors_syslibrary = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
        end
    end
})

MenuInterface:AddButton({
	Text = "Recarregar",
	Func = function()
	Library:Unload()
	_G.msdoors_syslibrary = _G.msdoors_syslibrary
	_G.ObsidianaLib = false
	_G.MsdoorsLoaded = false
	wait(2)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Msdoors/refs/heads/main/Src/Loaders/Doors/lobby/game.lua"))()
	end,
	DoubleClick = false,
	DisabledTooltip = "I am disabled!",
	Disabled = false,
	Visible = true,
	Risky = false
})



local FolderFloor = (_G.msdoors_floor == "Hotel" and "Hotel") or  
                 (_G.msdoors_floor == "Rooms" and "Rooms") or  
                 (_G.msdoors_floor == "Backdoor" and "Backdoor") or  
                 (_G.msdoors_floor == "Mines" and "Mines") or  
                 (_G.msdoors_floor == "Retro Mode" and "Retro") or
                 (_G.msdoors_floor == "Super Hard Mode" and "SuperHardMode") or  
                 "NoFloor"

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("msdoors")
SaveManager:SetFolder("msdoors/Doors")
SaveManager:SetSubFolder(FolderFloor)
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
_G.MsdoorsLoaded = true

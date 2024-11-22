local url = "https://github.com/Sc-Rhyan57/Msdoors/releases/download/MsdoorsLoad/Msdoors.lua"
local response = game:HttpGet(url, true)
local script = loadstring(response)
script()

if not makefolder then
    error("[Msdoors] Seu executor não suporta manipulação de arquivos locais (makefolder).")
end

local baseFolder = ".msdoors"
local placesFolder = baseFolder .. "/places"
local presetsFolder = placesFolder .. "/presets"

if not isfolder(baseFolder) then
    makefolder(baseFolder)
end

if not isfolder(placesFolder) then
    makefolder(placesFolder)
end

if not isfolder(presetsFolder) then
    makefolder(presetsFolder)
end
print("[msdoors] A pasta foi criada com sucesso em:", presetsFolder)

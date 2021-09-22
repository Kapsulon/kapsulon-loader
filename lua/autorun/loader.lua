--[[
    Lua loader for all the addons made by Kapsulon
--]]

Kapsulon = Kapsulon or {}

Kapsulon.Loader = {}
Kapsulon.Loader.Version = 1
Kapsulon.Loader.AutoUpdate = false
Kapsulon.Loader.SelfUpdate = true

Kapsulon.Addons = {
    "crypto-trade",
    "scp-database",
    "better-noclip"
}

function Kapsulon.kprint(text)
    print("[KAPSULON] "..text)
end

function Kapsulon.kprintcolor(color, text)
    MsgC(color, "[KAPSULON] "..text)
end

if Kapsulon.Loader.SelfUpdate then
    local updateFound = false
    print("")
    Kapsulon.kprint("Checking if an update is available...")
    http.Fetch("https://raw.githubusercontent.com/Kapsulon/kapsulon-loader/main/manifest.json", function(body, length, headers, code)
        local result = util.JSONToTable(body)
        if result.addon_version > Kapsulon.Loader.Version then
            updateFound = true
        end
    end)
    if updateFound then
        Kapsulon.kprintcolor(Color(255, 0, 0), "An update for the loader is available, it is strongly recommended to download it as it probably introduces compatibility changes and major bug fixes.")
    else
        Kapsulon.kprintcolor(Color(0, 255, 0), "No update was found.")
    end
end


print("")
Kapsulon.kprint("Starting initialization sequence...\n")

for _, i in pairs(Kapsulon.Addons) do
    if file.Exists("addons/"..i.."/manifest.json", "GAME") then
        Kapsulon.kprint("Manifest file found for "..i.." !")

        local manifest = util.JSONToTable(file.Read("addons/"..i.."/manifest.json", "GAME"))

        Kapsulon.kprint("Initializing "..i.."... (Version "..manifest.addon_version..")")
        if SERVER then AddCSLuaFile( manifest.loader_file_location .. "/loader.lua" ) include( manifest.loader_file_location .. "/loader.lua" ) else include( manifest.loader_file_location .. "/loader.lua" ) end
        Kapsulon.kprint("Initialized "..i.." (Version "..manifest.addon_version..") Successfully !")
    else
        Kapsulon.kprint("Manifest file not found for "..i.."...")
    end
end

print("")
Kapsulon.kprint("Initialization sequence finished !")
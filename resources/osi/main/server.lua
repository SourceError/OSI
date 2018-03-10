--local config = module("main/config")
local config = {}

config.start_credits = 0
config.start_cash = 1000
config.start_bank = 10000

osi = {}
osi.server = {}
osi.players = {}

RegisterServerEvent('osi:server:characterJoin')
RegisterServerEvent('osi:server:createCharacter')


MySQL.ready(function ()
    osi.sql.create_tables()
    print("MySQL Ready")
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason)
  osi.server.playerLoggedIn(source)
end)

AddEventHandler('osi:server:createCharacter', function(data)
    local char = {}
    local current_date = os.date("*t")

    if #data == 0 then
        for k, v in pairs(data) do
            print(tostring(k) .. ": " .. tostring(v))
        end
    end
    print("Source: " .. source)

    char.client_id = osi.players[source].client_id
    char.first_name = data.first
    char.last_name = data.last
    char.sex = data.sex
    char.strength = data.str    
    char.dexterity = data.dex
    char.intelligence = data.int
    char.cash = config.start_cash
    char.bank = config.start_bank
    char.dob = data.year .. "-" .. data.month .. "-" .. data.day
    char.created = current_date.year .. "-" .. string.format("%02d", current_date.month) .. "-" .. string.format("%02d", current_date.day)

    local new_char = osi.sql.create_character(char)

    players[source].character_id = new_char.id
    local character = osi.sql.get_character_data(new_char.id)
    TriggerClientEvent('osi:client:character_creation_success', source, character)
end)

AddEventHandler('osi:server:characterJoin', function(data)
    players[source].character_id = data.id
    local character = osi.sql.get_character_data(data.id)
    TriggerClientEvent('osi:client:characterJoined', -1, character)
end)

function osi.server.playerLoggedIn(player)
    -- Get steam_id and config
    local identifiers = GetPlayerIdentifiers(player)
    local steam_id = ""
    for _, v in ipairs(identifiers) do
        if string.find(v, "steam:") then
            steam_id = v
            print(v)
        end
    end

    local data = {}
    data.whitelist = true
    data.steam_id = steam_id

    if osi.server.isNewClient(steam_id) then
        print ("New client connected.")
        osi.sql.create_client(data)
    end

    local client = osi.sql.get_client_data(steam_id)
    local client_id = client["id"]
    print("Client connected: "..tostring(client_id))
    local characters = osi.sql.get_characters(client_id)

    osi.players[player] = {}
    osi.players[player].client_id = client_id

    print("Source: " .. player)

    TriggerClientEvent('osi:client:characters', player, characters)
end

function osi.server.isNewClient(steam_id)
    local client = osi.sql.get_client_data(steam_id)
    return client == nil
end

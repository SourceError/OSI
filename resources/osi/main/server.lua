--local config = module("main/config")
local config = {}

config.start_credits = 0
config.start_cash = 1000
config.start_bank = 10000

osi = {}
osi.server = {}

RegisterServerEvent('osi:client:characterJoin')
RegisterServerEvent('osi:client:createCharacter')

local players = {}

MySQL.ready(function ()
    osi.sql.create_tables()
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason)
  osi.server.playerLoggedIn(source)
end)

AddEventHandler('osi:client:createCharacter', function(data)
    local char = {}
    local current_date = os.date("*t")
    char.client_id = players[source].client_id
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

AddEventHandler('osi:client:characterJoin', function(data)
    players[source].character_id = data.id
    local character = osi.sql.get_character_data(data.id)
    TriggerClientEvent('osi:client:characterJoined', -1, character)
end)

function osi.server.playerLoggedIn(player)
    -- Get steam_id and config
    local identifiers = GetPlayerIdentifiers(player)

    for _, v in ipairs(identifiers) do
        print(v)
    end

    local data = {}
    data.whitelist = config.whitelist
    data.steam_id = identifiers[1]

    --osi.sql.create_client(data)

    --local client = osi.sql.get_client_data(identifiers[1])
    --local characters = osi.sql.get_characters(client.id)

    --players[player] = {}
    --players[player].client_id = client.id

    --TriggerClientEvent('osi:client:characters', player, characters)
end

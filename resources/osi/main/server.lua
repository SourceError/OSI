RegisterServerEvent('osi:client:characterJoin')

local players {}

MySQL.ready(function ()
    osi.sql.create_tables()
end)

AddEventHandler('hardcap:playerActivated', function()
  osi.server.playerLoggedIn(source)
end)

AddEventHandler('osi:client:characterJoin', function(data)
    players[source] = {}
    players[source].character_id = data.id
    local character = osi.sql.get_character_data(data.id)
    TriggerClientEvent('osi:client:characterJoined', -1, character)
end)

function osi.server.playerLoggedIn(player)
    -- Get steam_id and config
    local identifiers = GetPlayerIdentifiers(player)

    local data = {}
    data.whitelist = config.whitelist
    data.steam_id = identifiers[1]

    osi.sql.create_client(data)

    local client = osi.sql.get_client_data(identifiers[1])
    local characters = osi.sql.get_characters(client.id)

    TriggerClientEvent('osi:client:characters', player, { chars: characters })
end

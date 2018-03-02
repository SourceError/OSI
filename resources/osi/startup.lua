AddEventHandler('onClientMapStart', function()
  --exports.spawnmanager:setAutoSpawn(true)
  --exports.spawnmanager:forceRespawn()
    osi.server.open_intro()
end)

MySQL.ready(function ()
    osi.sql.create_tables()

    -- Get steam_id and config
    local player = GetPlayers()[1]
    local identifiers = GetPlayerIdentifiers(player)

    local data = {}
    data.whitelist = config.whitelist
    data.steam_id = identifiers[1]

    osi.sql.create_client(data)

    local client = osi.sql.get_client_data(identifiers[1])
    local characters = osi.sql.get_character_data(client.id)
end)


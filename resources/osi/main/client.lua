osi = {}
osi.client = {}

RegisterNetEvent('osi:client:characters')
RegisterNetEvent('osi:client:character_creation_success')
RegisterNetEvent('osi:client:characterJoined')

TriggerEvent('chatMessage', 'Client', { 0, 0, 0 }, "osi/main/client.lua loaded.")

local my_character = {}
local characters_available = {}
local players = {}

AddEventHandler('onClientMapStart', function()
    TriggerEvent('chatMessage', 'Client', { 0, 0, 0 }, "onClientMapStart")
    --exports.spawnmanager:setAutoSpawn(true)
    --exports.spawnmanager:forceRespawn()
    --TriggerServerEvent('osi:server:Notify', {msg: "onClientMapStart"})
    --osi.client.open_intro()
    osi.client.open_character_selection(characters_available)
end)

AddEventHandler('osi:client:characters', function(characters)
    characters_available = characters
    TriggerServerEvent('osi:server:Notify', {msg = "characters grabbed"})
end)

AddEventHandler('osi:client:character_creation_success', function(character)
    my_character = character
    osi.client.select_character(my_character.id)
end)

AddEventHandler('osi:client:characterJoined', function(data)
    table.insert(players, data)
end)

RegisterNUICallback('error_message', function(data, cb)
    -- log or post client errors
end)

RegisterNUICallback('select_character', function (data, cb)
    osi.client.select_character(data.id)
end)

RegisterNUICallback('create_character', function (data, cb)
    osi.client.create_character(data)
end)

function osi.client.open_intro()
    SendNUIMessage({ cmd: open_intro })
end

function osi.client.open_character_selection(chars)
    SendNUIMessage({ cmd: open_selection, characters: chars })
end

function osi.client.select_character(character_id)
   --exports.spawnmanager:setAutoSpawn(true)
   --exports.spawnmanager:forceRespawn() 
   TriggerServerEvent('osi:server:characterJoin', {id: character_id})
end

function osi.clien.create_character(data)
   TriggerServerEvent('osi:server:createCharacter', {data})
end

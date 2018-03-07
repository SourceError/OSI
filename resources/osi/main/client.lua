RegisterNetEvent('osi:client:characters')
RegisterNetEvent('osi:client:character_creation_success')
RegisterNetEvent('osi:client:characterJoined')

local my_character = {}
local players = {}

AddEventHandler('onClientMapStart', function()
  --exports.spawnmanager:setAutoSpawn(true)
  --exports.spawnmanager:forceRespawn()
    osi.client.open_intro()
end)

AddEventHandler('osi:client:characters', function(characters) {
    osi.client.open_character_selection(characters)
end)

AddEventHandler('osi:client:character_creation_success', function(character) {
    my_character = character
    osi.client.select_character(my_character.id)
end)

AddEventHandler('osi:client:characterJoined', function(data) {
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
   exports.spawnmanager:setAutoSpawn(true)
   exports.spawnmanager:forceRespawn() 
   TriggerServerEvent('osi:server:characterJoin', {id: character_id})
end

function osi.clien.create_character(data)
   TriggerServerEvent('osi:server:createCharacter', {data})
end

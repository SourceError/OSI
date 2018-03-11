osi = {}
osi.client = {}

RegisterNetEvent('osi:client:characters')
RegisterNetEvent('osi:client:character_creation_success')
RegisterNetEvent('osi:client:characterJoined')

local my_character = {}
local characters_available = {}
local players = {}

AddEventHandler('onClientMapStart', function()
    --exports.spawnmanager:setAutoSpawn(true)
    --exports.spawnmanager:forceRespawn()
    --TriggerServerEvent('osi:server:Notify', {msg: "onClientMapStart"})
    --osi.client.open_intro()
    osi.client.open_character_selection(characters_available)
end)

AddEventHandler('osi:client:characters', function(characters)
    characters_available = characters
    for ind = 1, #characters do
        for k,v in pairs(characters[ind]) do
            Citizen.Trace(tostring(k)..": ".. tostring(v))
        end
    end
    Citzen.Trace("Characters retrieved.")
end)

AddEventHandler('osi:client:character_creation_success', function(character)
   Citizen.Trace("Character creation success!")
    
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
    SetNuiFocus(false)
    osi.client.select_character(data.id)
end)

RegisterNUICallback('create_character', function (data, cb)
    SetNuiFocus(false)
    osi.client.create_character(data)
end)

function osi.client.open_intro()
    SendNUIMessage({ cmd = "open_intro" })
end

function osi.client.open_character_selection(chars)
    SetNuiFocus(true, true)
    SendNUIMessage({ cmd = "open_selection", characters = chars })
end

function osi.client.select_character(character_id)
   --exports.spawnmanager:setAutoSpawn(true)
   --exports.spawnmanager:forceRespawn() 
   TriggerServerEvent('osi:server:characterJoin', {id = character_id})
end

function osi.client.create_character(data)
   Citizen.Trace("Character being created!")
   TriggerServerEvent('osi:server:createCharacter', data)
end

osi = {}
osi.client = {}

RegisterNetEvent('osi:client:characters')
RegisterNetEvent('osi:client:character_creation_success')
RegisterNetEvent('osi:client:characterJoined')

local my_character = {}
local characters_available = {}
local players = {}
local mouse = {}
mouse.x = 0
mouse.y = 0

AddEventHandler('onClientMapStart', function()
    --exports.spawnmanager:setAutoSpawn(true)
    --exports.spawnmanager:forceRespawn()
    --TriggerServerEvent('osi:server:Notify', {msg: "onClientMapStart"})
    --osi.client.open_intro()
   TriggerServerEvent('osi:server:get_characters', {})
end)

AddEventHandler('osi:client:characters', function(characters)
    characters_available = characters
    osi.client.open_character_selection(characters)
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

RegisterNUICallback('mouse_pos', function (data, cb) 
    SetNuiFocus(false)
    mouse = data
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

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  -- normalize
  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  local dir = {}
  dir.x = x
  dir.y = y
  dir.z = z

  return dir
end

function cross_product(vec1, vec2)
    local result = {}

    result.x = vec1.y * vec2.z - vec1.z * vec2.y
    result.y = vec1.x * vec2.z - vec1.z * vec2.x
    result.z = vec1.x * vec2.y - vec1.y * vec2.x

    return result
end

function normalize(vec)
    local result = {}

    local mag = math.sqrt(vec.x*vec.x + vec.y*vec.y + vec.z*vec.z)
    result.x = vec.x / mag
    result.y = vec.y / mag
    result.z = vec.z / mag

    return result
end

function create4x4(position, direction)
    local up = { x = 0, y = 0, z = 0 }
    local xaxis = cross_product(up, direction)
    xaxis = normalize(xaxis)

    local yaxis = cross_product(direction, xaxis)
    yaxis = normalize(yaxis)

    local result = { _11 = xaxis.x, _12 = yaxis.x, _13 = direction.x, _14 = position.x, _21 = xaxis.y, _22 = yaxis.y, _23 = direction.y, _24 = position.y, _31 = xaxis.z, _32 = yaxis.z, _33 = direction.z, _34 = position.z, _41 = 0, _42 = 0, _43 = 0, _44 = 1 }
    return result
end

function multMatrixVec(matrix, vec)
    local result = {}

    result.x = matrix._11*vec.x + matrix._12*vec.y + matrix._13*vec.z + matrix._14*1
    result.y = matrix._21*vec.x + matrix._22*vec.y + matrix._23*vec.z + matrix._24*1
    result.z = matrix._31*vec.x + matrix._32*vec.y + matrix._33*vec.z + matrix._34*1

    return result
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local speed = GetEntitySpeed(GetPlayerPed(-1)) * 2.236936

    local camPos = GetGameplayCamCoord()
    local camDir = getCamDirection()
    local camFar = Citizen.InvokeNative(0xDFC8CBC606FDB0FC) -- GetGameplayCamFarClip
    local camFov = GetGameplayCamFov()

    local screen_w = 0
    local screen_h = 0
    screen_w, screen_h =  GetScreenResolution(0, 0)

    local pixelScreen = {}
    pixelScreen.x = 2 * mouse.x - 1
    pixelScreen.y = 1 - 2 * mouse.y 

    local posStr = "~y~ x: " .. string.format("%.2f", camPos.x) .. " y: " .. string.format("%.2f", camPos.y) .. " z: " .. string.format("%.2f", camPos.z) .. ""
    local rotStr = "~y~ x: " .. string.format("%.2f", camDir.x) .. " y: " .. string.format("%.2f", camDir.y) .. " z: " .. string.format("%.2f", camDir.z) .. ""

    drawTxt(1.407, 1.30, 1.0,1.0,0.7, "~y~" .. math.ceil(speed) .. "", 255, 255, 255, 255)
    drawTxt(1.4, 1.337, 1.0,1.0,0.7, "~b~ mph", 255, 255, 255, 255)

    drawTxt(1.2, 0.95, 1.0,1.0,0.4, posStr, 255, 255, 255, 255)
    drawTxt(1.2, 1.00, 1.0,1.0,0.4, rotStr, 255, 255, 255, 255)
    drawTxt(1.2, 1.05, 1.0,1.0,0.4, "~y~ width: " .. string.format("%.1f", screen_w) .. "", 255, 255, 255, 255)
    drawTxt(1.2, 1.10, 1.0,1.0,0.4, "~y~ height: " .. string.format("%.1f", screen_h) .. "", 255, 255, 255, 255)

    drawTxt(1.2, 1.20, 1.0,1.0,0.4, "~y~ x: " .. string.format("%.3f", pixelScreen.x) .. "", 255, 255, 255, 255)
    drawTxt(1.2, 1.25, 1.0,1.0,0.4, "~y~ y: " .. string.format("%.3f", pixelScreen.y) .. "", 255, 255, 255, 255)

    local aspectRatio = screen_w / screen_h
    local Px = (2 * ((pixelScreen.x + 0.5) / screen_w) - 1) * math.tan(camFov / 2 * math.pi / 180) * aspectRatio
    local Py = (1 - 2 * ((pixelScreen.y + 0.5) / screen_h)) * math.tan(camFov / 2 * math.pi / 180)

    local origin = { x = 0, y = 0, z = 0 }
    local cameraMatrix = create4x4(camPos, camDir)
    local rayOrigin = multMatrixVec(cameraMatrix, origin)
    local rayP = multMatrixVec(cameraMatrix, {x = Px, y = Py, z = -1})
    local rayDirection = { x = rayP.x - rayOrigin.x, y = rayP.y - rayOrigin.y, z = rayP.z - rayOrigin.z }
    rayDirection = normalize(rayDirection)

    local rayposStr = "~y~ x: " .. string.format("%.2f", camPos.x) .. " y: " .. string.format("%.2f", camPos.y) .. " z: " .. string.format("%.2f", camPos.z) .. ""
    local rayrotStr = "~y~ x: " .. string.format("%.2f", camDir.x) .. " y: " .. string.format("%.2f", camDir.y) .. " z: " .. string.format("%.2f", camDir.z) .. ""

    drawTxt(1.2, 0.80, 1.0,1.0,0.4, rayposStr, 255, 255, 255, 255)
    drawTxt(1.2, 0.85, 1.0,1.0,0.4, rayrotStr, 255, 255, 255, 255)

    local endPos = {}
    endPos.x = rayOrigin.x + (rayDirection.x * 5000)
    endPos.y = rayOrigin.y + (rayDirection.y * 5000)
    endPos.z = rayOrigin.z + (rayDirection.z * 5000)

    DrawLine(rayOrigin.x, rayOrigin.y, rayOrigin.z, endPos.x, endPos.y, endPos.z, 255, 0,0,255)

    if IsControlJustPressed(1, 19) then -- Left Alt
        SetNuiFocus(true,true)
    end

    --if IsControlJustReleased(1, 19) then
    --    SetNuiFocus(false)
    --end

    if IsControlJustReleased(0,142) then
        SendNUIMessage({ cmd = "get_mouse_pos" })
    end
  end
end)

RegisterCommand("run", function(source, args, rawCommand)
    print("Command from: " .. ((source == 0) and 'console' or GetPlayerName(source)) )

    print("Arguments were:")
    for k,v in pairs(args) do
        print("\t" .. k .. " = " .. v)
    end

    print("Raw Command: " .. rawCommand)

    local player = PlayerId()
    SetRunSprintMultiplierForPlayer(player, args[1])
    print("Run multiplier set to "..args[1])

end, false)
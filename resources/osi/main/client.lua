if osi == nil then osi = {} end

osi.client = {}

RegisterNetEvent('osi:client:characters')
RegisterNetEvent('osi:client:character_creation_success')
RegisterNetEvent('osi:client:characterJoined')

local my_character = {}
local characters_available = {}
local players = {}
local mouse = { x = 600, y = 400 }
local screen = { w = 1200, h = 800 }

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
    mouse = { x = data.x, y = data.y }
    screen = { w = data.w, h = data.h }
    osi.client.hit_test()
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
  
  drawTxt(0.5, 0.88, 1.0,1.0,0.4, "~y~ ".."heading:"..heading.."", 255, 255, 255, 255)
  drawTxt(0.5, 0.91, 1.0,1.0,0.4, "~y~ ".."pitch"..pitch.."", 255, 255, 255, 255)

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

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local speed = GetEntitySpeed(GetPlayerPed(-1)) * 2.236936
    drawTxt(1.407, 1.30, 1.0,1.0,0.7, "~y~" .. math.ceil(speed) .. "", 255, 255, 255, 255)
    drawTxt(1.4, 1.337, 1.0,1.0,0.7, "~b~ mph", 255, 255, 255, 255)

    local camPos = GetGameplayCamCoord()
    local camDir = getCamDirection()
    local camFov = GetGameplayCamFov()
    local screen_w, screen_h =  GetScreenResolution(0, 0)

    -- FAKE CAMERA TO GET CAMERA TO WORLD MATRIX - FIND ANOTHER WAY
    local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", false)
    local camRot = GetGameplayCamRot(2)

    SetCamCoord(cam, 0,0,0)
    SetCamRot(cam,camRot.x, camRot.y, camRot.z, 2)
    SetCamFov(cam, 50.0)

    local uu, vv, ww, pp = GetCamMatrix(cam)
    local u = Vec:Vec(uu.x,uu.y,uu.z)
    local v = Vec:Vec(vv.x,vv.y,vv.z)
    local w = Vec:Vec(ww.x,ww.y,ww.z)

    drawTxt(0.5, 0.70, 1.0,1.0,0.4, "~y~ "..u:tostring().."", 255, 255, 255, 255)
    drawTxt(0.5, 0.73, 1.0,1.0,0.4, "~y~ "..v:tostring().."", 255, 255, 255, 255)
    drawTxt(0.5, 0.76, 1.0,1.0,0.4, "~y~ "..w:tostring().."", 255, 255, 255, 255)

    local _camRot = GetCamRot(cam, 2)
    local _cv = Vec:Vec(_camRot.x, _camRot.y, _camRot.z)
    drawTxt(0.5, 0.85, 1.0,1.0,0.4, "~y~ ".._cv:tostring().."", 255, 255, 255, 255)

    DestroyCam(cam, false)
    -----------------------------------------------------------------

    local endCamPos = {}
    endCamPos.x = camPos.x + (camDir.x * 10)
    endCamPos.y = camPos.y + (camDir.y * 10)
    endCamPos.z = camPos.z + (camDir.z * 10)

    DrawMarker(1, endCamPos.x, endCamPos.y, endCamPos.z, 0, 0, 0, 0, 0, 0, 1.0,1.0,0.5, 255,0,0, 200, 0, 0, 2, 0, 0, 0, 0)

    local cameraMatrix = Matrix:Matrix():rotateZ(camRot.z):rotateX(camRot.x)

    drawTxt(1.3, 0.70, 1.0,1.0,0.4, "~y~ "..cameraMatrix.row1:tostring().."", 255, 255, 255, 255)
    drawTxt(1.3, 0.73, 1.0,1.0,0.4, "~y~ "..cameraMatrix.row2:tostring().."", 255, 255, 255, 255)
    drawTxt(1.3, 0.76, 1.0,1.0,0.4, "~y~ "..cameraMatrix.row3:tostring().."", 255, 255, 255, 255)

    local rayDir = osi.screenToWorld(mouse.x+0.5,mouse.y+0.5,screen.w,screen.h, camFov, cameraMatrix)
    drawTxt(1.2, 0.70, 1.0,1.0,0.4, "~y~ "..rayDir:tostring().."", 255, 255, 255, 255)

    local rayOrigin = Vec:Vector3(camPos):add(Vec.Scale(rayDir, 0.5))
    local rayEnd = Vec.Add(rayOrigin, Vec.Scale(rayDir, 10))
    
    DrawBox(rayEnd.x-0.1, rayEnd.y-0.1, rayEnd.z-0.1, rayEnd.x+0.1, rayEnd.y+0.1, rayEnd.z+0.1, 0, 255, 0, 200)

    --DrawMarker(1, rayEnd.x, rayEnd.y, rayEnd.z, 0, 0, 0, 0, 0, 0, 1.0,1.0,0.5, 0,255,0, 200, 0, 0, 2, 0, 0, 0, 0)

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

function osi.client.hit_test()
    local camPos = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local camFov = GetGameplayCamFov()

    local cameraMatrix = Matrix:Matrix():rotateZ(camRot.z):rotateX(camRot.x)
    local rayDir = osi.screenToWorld(mouse.x+0.5,mouse.y+0.5,screen.w,screen.h, camFov, cameraMatrix)

    local rayOrigin = Vec:Vector3(camPos):add(Vec.Scale(rayDir, 0.5))
    local rayEnd = Vec.Add(rayOrigin, Vec.Scale(rayDir, 100))

    local rayHandle = CastRayPointToPoint(rayOrigin.x, rayOrigin.y, rayOrigin.z, rayEnd.x, rayEnd.y, rayEnd.z, 31, GetPlayerPed(-1), 0)
    local _, _, endCoord, _, entity = GetRaycastResult(rayHandle)

    if entity ~= 0 and entity ~= nil then
        local entityType = GetEntityType(entity)
        if entityType == 0 then
            print("RayTest: None / Map")
        elseif entityType == 1 then
            print("RayTest: Ped")
        elseif entityType == 2 then
            print("RayTest: Veh")
        elseif entityType == 3 then
            print("RayTest: Object")
        else
            print("RayTest: Unknown")
        end
    end
end
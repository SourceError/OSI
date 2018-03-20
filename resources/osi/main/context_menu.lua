osi.context = {}
osi.context.menu = {}
osi.context.entity = nil
osi.context.player = nil

local entityTypes = {"Player", "Vehicle", "Object"}

RegisterNUICallback('menu_action', function(data, cb)
    SetNuiFocus(false)
    if osi.context.menu[data.category] ~= nil and osi.context.menu[data.category][data.id] ~= nil then
        osi.context.menu[data.category][data.id].cCB(osi.context.player, osi.context.entity)
    else
        Citizen.Trace("menu_action not found: "..data.label.."")
    end
end)

function add_to_context_menus(entityType, ace, label, visibleCallback, clickCallback)
    if osi.context.menu[entityType] == nil then
        osi.context.menu[entityType] = {}
    end

    table.insert(osi.context.menu[entityType], {ace = ace, label = label, vCB = visibleCallback, cCB = clickCallback})
end

function open_context_menu(entity, x, y)
    if entity == nil then return end
    local eType = GetEntityType(entity)
    if osi.context.menu[eType] == nil then return end

    local menuTitle = "Map"
    if eType ~= 0 then
        menuTitle = entityTypes[eType]
    end

    local menu_data = {}
    local player = PlayerId()
    osi.context.player = player
    osi.context.entity = entity

    for i = 1, #osi.context.menu[eType] do
        local menu_item = osi.context.menu[eType][i]
        if IsPlayerAceAllowed(player, menu_item.ace) and (menu_item.vCB == nil or menu_item.vCB(player,entity)) then
            table.insert(menu_data, {label = menu_item.label, category = eType, id = i})
        end
    end

    if #menu_data > 0 then
        SetNuiFocus(true, true)
        SendNUIMessage({ cmd = "open_context_menu", menu = menu_data, menu_title = menuTitle })
    end
end

add_to_context_menus(1, 'menu.ped.burn', 'Set Fire', nil, function(player, ped)
    StartEntityFire(ped)
end)

add_to_context_menus(1, 'menu.ped.handcuff', 'Handcuff', function(player, ped)
    -- If has handcuffs in inventory, ped not already cuffed
    return true
end,
function(player, ped)
    Citizen.Trace("Handcuff Ped.")
    -- tell server
    --osi.HandcuffPed(ped)
    --osi.RemoveItem(player, 'handcuffs')
end)

add_to_context_menus(3, 'menu.object.delete', 'Delete Object', nil, function(player, object)
    if object ~= nil then
        DeleteObject(object)
    end
end)
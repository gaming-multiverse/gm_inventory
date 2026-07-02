local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'

RegisterNetEvent('gm_core:server:clearSession', server.playerDropped)

AddEventHandler('gm_core:server:jobUpdated', function(source, job)
    local inventory = Inventory(source)
    if not inventory then return end
    inventory.player.groups[inventory.player.job] = nil
    inventory.player.job = job.name
    inventory.player.groups[job.name] = job.grade
end)

AddEventHandler('gm_core:client:gangUpdated', function(source, gang)
    local inventory = Inventory(source)
    if not inventory then return end
    inventory.player.groups[inventory.player.gang] = nil
    inventory.player.gang = gang.name
    inventory.player.groups[gang.name] = gang.grade
end)

local function setupPlayer(Player)
    Player.inventory = Player.inventory
    Player.identifier = Player.characterid
    Player.name = ('%s %s'):format(Player.firstname, Player.lastname)

    server.setPlayerInventory(Player)
end

RegisterNetEvent('gm_inventory:server:initializeInventory', function()
    local data = exports.gm_core:GetPlayerSession(source)

    setupPlayer(data)
end)

SetTimeout(500, function()
    local sessions = exports.gm_core:GetAllSessions()
    for src, session in pairs(sessions) do
        local data = session.getAll()

        setupPlayer(data)
    end
end)

function server.UseItem(source, itemName, data)
    local cb = exports.gm_core:CanUseItem(itemName)
    return cb and cb(source, data)
end

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
    local groups = {
        [player.job.name] = player.job.grade,
        [player.gang.name] = player.gang.grade
    }

    return {
        source = player.source,
        name = ('%s %s'):format(player.firstname, player.lastname),
        groups = groups,
        sex = player.gender,
        dateofbirth = player.age,
        job = player.job.name,
        gang = player.gang.name,
    }
end

--- Takes traditional item data and updates it to support ox_inventory, i.e.
--- ```
--- Old: {1:{"name": "cola", "amount": 1, "label": "Cola", "slot": 1}, 2:{"name": "burger", "amount": 3, "label": "Burger", "slot": 2}}
--- New: [{"slot":1,"name":"cola","count":1}, {"slot":2,"name":"burger","count":3}]
---```
---@diagnostic disable-next-line: duplicate-set-field
function server.convertInventory(playerId, items)
    if type(items) == 'table' then
        local player = server.GetPlayerFromId(playerId)
        local returnData, totalWeight = table.create(#items, 0), 0
        local slot = 0

        if player then
            for name in pairs(server.accounts) do
                local hasThis = false

                for _, data in pairs(items) do
                    if data.name == name then
                        hasThis = true
                        break
                    end
                end

                -- if not hasThis then
                --     local amount = exports.gm_core:GetMoney(playerId, name)
                --     if amount and amount > 0 then
                --         items[#items + 1] = { name = name, amount = amount }
                --     end
                -- end
            end
        end


        for _, data in pairs(items) do
            local item = Items(data.name)

            if item?.name then
                local metadata, count = Items.Metadata(playerId, item, data.info, data.amount or data.count or 1)
                local weight = Inventory.SlotWeight(item, { count = count, metadata = metadata })
                totalWeight += weight
                slot += 1
                returnData[slot] = {
                    name = item.name,
                    label = item.label,
                    weight = weight,
                    slot = slot,
                    count = count,
                    description =
                        item.description,
                    metadata = metadata,
                    stack = item.stack,
                    close = item.close
                }
            end
        end

        return returnData, totalWeight
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId)
    local Player = exports.gm_core:GetPlayerSession(source)

    return Player.job.isboss or Player.gang.isboss
end

local function export(exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(string.strsplit('.', exportName, 2)), function(setCB)
        setCB(func or function()
            error(("export '%s' is not supported when using ox_inventory"):format(exportName))
        end)
    end)
end

---Imagine if somebody who uses qb/qbox would PR these functions.
export('rsg-inventory.LoadInventory', function(playerId)
    if Inventory(playerId) then return end

    local player = RSGCore.Functions.GetPlayer(playerId)

    if player then
        setupPlayer(player)

        return Inventory(playerId).items
    end
end)

export('rsg-inventory.SaveInventory', function(playerId)
    if type(playerId) ~= 'number' then
        TypeError('playerId', 'number', type(playerId))
    end

    Inventory.Save(playerId)
end)

export('rsg-inventory.SetInventory')
export('rsg-inventory.SetItemData')
export('rsg-inventory.UseItem')
export('rsg-inventory.GetSlotsByItem')
export('rsg-inventory.GetFirstSlotByItem')

export('rsg-inventory.GetItemBySlot', function(playerId, slotId)
    return Inventory.GetSlot(playerId, slotId)
end)

export('rsg-inventory.GetTotalWeight')

export('rsg-inventory.GetItemByName', function(playerId, itemName)
    return Inventory.GetSlotWithItem(playerId, itemName)
end)

export('rsg-inventory.GetItemsByName', function(playerId, itemName)
    return Inventory.GetSlotsWithItem(playerId, itemName)
end)

export('rsg-inventory.GetSlots')
export('rsg-inventory.GetItemCount')

export('rsg-inventory.CanAddItem', function(playerId, itemName, amount)
    return (Inventory.CanCarryAmount(playerId, itemName) or 0) >= amount
end)

export('rsg-inventory.ClearInventory', function(playerId, filter)
    Inventory.Clear(playerId, filter)
end)

export('rsg-inventory.CloseInventory', function(playerId, inventoryId)
    local playerInventory = Inventory(playerId)

    if not playerInventory then return end

    local inventory = Inventory(playerInventory.open)

    if inventory and (inventoryId == inventory.id or not inventoryId) then
        playerInventory:closeInventory()
    end
end)

export('rsg-inventory.OpenInventory', function(playerId, invId, data)
    local inventory = Inventory(invId)

    if not inventory then return end

    server.forceOpenInventory(playerId, inventory.type, inventory.id)
end)

export('rsg-inventory.OpenInventoryById', function(playerId, targetId)
    server.forceOpenInventory(playerId, 'player', targetId)
end)

export('rsg-inventory.CreateShop')
export('rsg-inventory.OpenShop')

export('rsg-inventory.AddItem', function(invId, itemName, amount, slot, metadata)
    return Inventory.AddItem(invId, itemName, amount, metadata, slot) and true
end)

export('rsg-inventory.RemoveItem', function(invId, itemName, amount, slot)
    return Inventory.RemoveItem(invId, itemName, amount, nil, slot) and true
end)

export('rsg-inventory.HasItem', function(source, items, amount)
    amount = amount or 1

    local count = Inventory.Search(source, 'count', items)

    if type(items) == 'table' and type(count) == 'table' then
        for _, v in pairs(count) do
            if v < amount then
                return false
            end
        end

        return true
    end

    return count >= amount
end)
local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'

local RSGCore

AddEventHandler('RSGCore:Server:OnPlayerUnload', server.playerDropped)

AddEventHandler('RSGCore:Server:OnJobUpdate', function(source, job)
    local inventory = Inventory(source)
    if not inventory then return end
    inventory.player.groups[inventory.player.job] = nil
    inventory.player.job = job.name
    inventory.player.groups[job.name] = job.grade.level
end)

AddEventHandler('RSGCore:Server:OnGangUpdate', function(source, gang)
    local inventory = Inventory(source)
    if not inventory then return end
    inventory.player.groups[inventory.player.gang] = nil
    inventory.player.gang = gang.name
    inventory.player.groups[gang.name] = gang.grade.level
end)

--[[ AddEventHandler('onResourceStart', function(resource)
    if resource ~= 'qb-weapons' or resource ~= 'qb-shops' then return end
    StopResource(resource)
end) ]]

---@param item SlotWithItem?
---@return SlotWithItem?
local function setItemCompatibilityProps(item)
    if not item then return end

    item.info = item.metadata
    item.amount = item.count

    return item
end

local function setupPlayer(Player)
    Player.PlayerData.inventory = Player.PlayerData.items
    Player.PlayerData.identifier = Player.PlayerData.citizenid
    Player.PlayerData.name = ('%s %s'):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
    server.setPlayerInventory(Player.PlayerData)

    -- Discord tag lookup can fail at join time if the identifier isn't ready yet.
    -- Re-check after a short delay to apply the correct limits without a restart.
    local src = Player.PlayerData.source
    SetTimeout(500, function()
        if GetPlayerName(src) then
            server.refreshVipInventory(src)
        end
    end)

    -- Inventory.SetItem(Player.PlayerData.source, 'money', Player.PlayerData.money.cash)

    RSGCore.Functions.AddPlayerMethod(Player.PlayerData.source, "AddItem", function(item, amount, slot, info)
        return Inventory.AddItem(Player.PlayerData.source, item, amount, info, slot)
    end)

    RSGCore.Functions.AddPlayerMethod(Player.PlayerData.source, "RemoveItem", function(item, amount, slot)
        return Inventory.RemoveItem(Player.PlayerData.source, item, amount, nil, slot)
    end)

    RSGCore.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemBySlot", function(slot)
        return setItemCompatibilityProps(Inventory.GetSlot(Player.PlayerData.source, slot))
    end)

    RSGCore.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemByName", function(itemName)
        return setItemCompatibilityProps(Inventory.GetSlotWithItem(Player.PlayerData.source, itemName))
    end)

    RSGCore.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemsByName", function(itemName)
        return setItemCompatibilityProps(Inventory.GetSlotsWithItem(Player.PlayerData.source, itemName))
    end)

    RSGCore.Functions.AddPlayerMethod(Player.PlayerData.source, "ClearInventory", function(filterItems)
        Inventory.Clear(Player.PlayerData.source, filterItems)
    end)

    RSGCore.Functions.AddPlayerMethod(Player.PlayerData.source, "SetInventory", function()
        -- ox_inventory's item structure is not compatible with rsg-inventory's one so we don't support it
        error('Player.Functions.SetInventory is unsupported for ox_inventory. Try ClearInventory, then add the desired items.')
    end)
end

AddEventHandler('RSGCore:Server:PlayerLoaded', setupPlayer)

SetTimeout(500, function()
    RSGCore = exports['rsg-core']:GetCoreObject()
    server.GetPlayerFromId = RSGCore.Functions.GetPlayer
    --[[ local weapState = GetResourceState('qb-weapons')

    if weapState ~= 'missing' and (weapState == 'started' or weapState == 'starting') then
        StopResource('qb-weapons')
    end

    local shopState = GetResourceState('qb-shops')

    if shopState ~= 'missing' and (shopState == 'started' or shopState == 'starting') then
        StopResource('qb-shops')
    end ]]

    for _, Player in pairs(RSGCore.Functions.GetRSGPlayers()) do setupPlayer(Player) end

    CreateThread(function()
        local interval = shared.serverTagRefreshInterval * 60 * 1000
        while true do
            Wait(interval)
            for _, Player in pairs(RSGCore.Functions.GetRSGPlayers()) do
                server.refreshVipInventory(Player.PlayerData.source)
            end
        end
    end)
end)

function server.UseItem(source, itemName, data)
    local cb = RSGCore.Functions.CanUseItem(itemName)
    return cb and cb(source, data)
end

---@param source number
---@return string?
---@diagnostic disable-next-line: duplicate-set-field
function server.getUserTag(source)
    return nil
end

---@param source number
---@return boolean
---@diagnostic disable-next-line: duplicate-set-field
function server.hasVIP(source)
    return nil
end

AddEventHandler('RSGCore:Server:OnMoneyChange', function(src, account, amount, changeType)
    if account ~= "cash" then return end

    -- local item = Inventory.GetItem(src, 'money', nil, false)

    -- if not item then return end

    -- local newAmount = changeType == "set" and amount or changeType == "remove" and item.count - amount or changeType == "add" and item.count + amount

    -- Inventory.SetItem(src, 'money', newAmount)
end)

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
    local groups = {
        [player.job.name] = player.job.grade.level,
        [player.gang.name] = player.gang.grade.level
    }

    return {
        source = player.source,
        name = ('%s %s'):format(player.charinfo.firstname, player.charinfo.lastname),
        groups = groups,
        sex = player.charinfo.gender,
        dateofbirth = player.charinfo.birthdate,
        job = player.job.name,
        gang = player.gang.name,
    }
end

---@diagnostic disable-next-line: duplicate-set-field
function server.syncInventory(inv)
    local accounts = Inventory.GetAccountItemCounts(inv)

    --[[ if accounts then
        local player = server.GetPlayerFromId(inv.id)
        player.Functions.SetPlayerData('items', inv.items)

        if accounts.money and accounts.money ~= player.Functions.GetMoney('cash') then
            player.Functions.SetMoney('cash', accounts.money, "Sync money with inventory")
        end
    end ]]
end

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense(inv, license)
    local player = server.GetPlayerFromId(inv.id)
    return player and player.PlayerData.metadata.licences[license]
end

---@diagnostic disable-next-line: duplicate-set-field
function server.buyLicense(inv, license)
    local player = server.GetPlayerFromId(inv.id)
    if not player then return end

    if player.PlayerData.metadata.licences[license.name] then
        return false, 'already_have'
    -- elseif Inventory.GetItemCount(inv, 'money') < license.price then
    --     return false, 'can_not_afford'
    end

    -- Inventory.RemoveItem(inv, 'money', license.price)
    player.PlayerData.metadata.licences[license.name] = true
    player.Functions.SetMetaData('licences', player.PlayerData.metadata.licences)

    return true, 'have_purchased'
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
                    end
                end

                -- if not hasThis then
                --     local amount = player.Functions.GetMoney(name == 'money' and 'cash' or name)

                --     if amount then
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
    local Player = RSGCore.Functions.GetPlayer(playerId)

    return Player.PlayerData.job.isboss or Player.PlayerData.gang.isboss
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
export('rsg-inventory.GetSlotsByItem', function(inventoryOrSource, itemName)
    if type(inventoryOrSource) == 'table' then
        local slots = {}
        for slot, item in pairs(inventoryOrSource) do
            if item and item.name == itemName then
                slots[#slots + 1] = slot
            end
        end
        return slots
    end
    return Inventory.Search(inventoryOrSource, 'slots', itemName)
end)

export('rsg-inventory.GetFirstSlotByItem', function(inventoryOrSource, itemName)
    if type(inventoryOrSource) == 'table' then
        for slot, item in pairs(inventoryOrSource) do
            if item and item.name == itemName then
                return slot
            end
        end
        return nil
    end
    local slots = Inventory.Search(inventoryOrSource, 'slots', itemName)
    return slots and slots[1]
end)

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
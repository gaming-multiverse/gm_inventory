local Inventory = require 'modules.inventory.client'
local Weapon = require 'modules.weapon.client'

RegisterNetEvent('gm_core:client:playerUnloaded', client.onLogout)

RegisterNetEvent("gm_core:client:playerLoaded", function(characterData)
    if characterData == nil then return end

    local groups = characterData.job

    if not groups[characterData.job.name] or not groups[characterData.gang.name] or groups[characterData.job.name] ~= characterData.job.grade or groups[characterData.gang.name] ~= characterData.gang.grade then
        PlayerData.groups = {
            [characterData.job.name] = characterData.job.grade,
            [characterData.gang.name] = characterData.gang.grade,
        }

        OnPlayerData('groups', PlayerData.groups)
    end
end)

RegisterNetEvent("gm_core:client:jobUpdated", function(job)
    if job == nil then return end

    local groups = job

    if not groups[job.name] or not groups[job.name] or groups[job.name] ~= job.grade or groups[job.name] ~= job.grade then
        PlayerData.groups = {
            [job.name] = job.grade,
            [job.name] = job.grade,
        }

        OnPlayerData('groups', PlayerData.groups)
    end
end)

RegisterNetEvent("gm_core:server:gangUpdated", function(gang)
    if gang == nil then return end

    local groups = gang

    if not groups[gang.name] or not groups[gang.name] or groups[gang.name] ~= gang.grade or groups[gang.name] ~= gang.grade then
        PlayerData.groups = {
            [gang.name] = gang.grade,
            [gang.name] = gang.grade,
        }

        OnPlayerData('groups', PlayerData.groups)
    end
end)

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
    for name, value in pairs(values) do
        -- compatibility for ESX style values
        if value > 100 or value < -100 then
            value = value * 0.0001
        end

        if name == "hunger" then
            -- TriggerServerEvent('consumables:server:addHunger', RSGCore.Functions.GetPlayerData().metadata.hunger + value)
        elseif name == "thirst" then
            -- TriggerServerEvent('consumables:server:addThirst', RSGCore.Functions.GetPlayerData().metadata.thirst + value)
        elseif name == "stress" then
            -- exports.gm_core:AddStress(value)
            TriggerServerEvent("hud:server:GainStress", value)
        end
    end
end

RegisterNetEvent("inventory:client:OpenInventory", function(name, data)
    exports.gm_inventory:openInventory(name, data)
end)

AddStateBagChangeHandler('inv_busy', ('player:%s'):format(cache.serverId), function(_, _, value)
    LocalPlayer.state:set('invBusy', value, false)
end)

local function export(exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(string.strsplit('.', exportName, 2)), function(setCB)
        setCB(func or function()
            error(("export '%s' is not supported when using ox_inventory"):format(exportName))
        end)
    end)
end

export('rsg-inventory.HasItem', function(items, amount)
    amount = amount or 1

    if type(items) == 'table' then
        for _, v in pairs(items) do
            if Inventory.GetItemCount(v) < amount then
                return false
            end
        end

        return true
    else
        return Inventory.GetItemCount(items) >= amount
    end
end)

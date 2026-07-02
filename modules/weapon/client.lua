if not lib then return end

local Weapon = {}
local Items = require 'modules.items.client'
local Utils = require 'modules.utils.client'

-- generic group animation data
local anims = {}
anims[`GROUP_MELEE`] = { 'melee@holster', 'unholster', 200, 'melee@holster', 'holster', 600 }
anims[`GROUP_PISTOL`] = { 'reaction@intimidation@cop@unarmed', 'intro', 400, 'reaction@intimidation@cop@unarmed', 'outro', 450 }
anims[`GROUP_STUNGUN`] = anims[`GROUP_PISTOL`]

local function vehicleIsCycle(vehicle)
	local class = GetVehicleClass(vehicle)
	return class == 8 or class == 13
end

local function moveInventoryItem(inventoryId, old, new, slot)
	local outGUID = DataView.ArrayBuffer(8 * 13)
	if not slot then slot = 1 end
	local sHash = "SLOTID_WEAPON_"..tostring(slot)
	local success = Citizen.InvokeNative(0xDCCAA7C3BFD88862, inventoryId, old, new, GetHashKey(sHash), 1, outGUID:Buffer())
	return success and outGUID or nil
end

local function getGuidFromItemId(inventoryId, itemData, category, slotId)
	local outItem = DataView.ArrayBuffer(8 * 13)
	local success = Citizen.InvokeNative(0x886DFD3E185C8A89, inventoryId, itemData and itemData or 0, category, slotId, outItem:Buffer())
	return success and outItem or nil
end

local equippedWeapons = {}

local function givePlayerWeapon(id, weaponHash, itemData, attachPoint, moveWeapon)
	local addReason = GetHashKey("ADD_REASON_DEFAULT");
	-- local weaponHash = GetHashKey(weaponName);
	local ammoCount = 0;

	-- RequestWeaponAsset
	Citizen.InvokeNative(0x72D4CB5DB927009C, weaponHash, 0, true);

	-- local slot = attachPoint == 3 and 0 or 1

	Citizen.InvokeNative(0x12FB95FE3D579238, PlayerPedId(), itemData:Buffer(), true, attachPoint, false, false)

	-- if moveWeapon then
	-- 	Citizen.InvokeNative(0x12FB95FE3D579238, PlayerPedId(), equippedWeapons[1].guid, true, 1, false, false)
	-- end

	if id then
		local nWeapon = {
			id = id,
			weaponHash = weaponHash,
			guid = itemData:Buffer()
		}
		table.insert(equippedWeapons, nWeapon)
	end
	-- GIVE_WEAPON_TO_PED
	-- Citizen.InvokeNative("0x5E3BDDBCB83F3D84", PlayerPedId(), weaponHash, ammoCount, false, true, attachPoint, true, 0.0, 0.0, addReason, true, 0.0, false);
end

local function addWardrobeInventoryItem(id, slot, itemName, attachPoint)
	local itemHash = GetHashKey(itemName)
	local addReason = GetHashKey("ADD_REASON_DEFAULT")

	for _, weapon in ipairs(equippedWeapons) do
        if weapon.weaponHash == itemHash then
            -- Already equipped
            TriggerEvent("gm_notify:client:Notify", "error", "This weapon is already holstered", 4000)
            return false
        end
    end

	local sHash = ("SLOTID_WEAPON_%s"):format(slot)
	local slotHash = GetHashKey(sHash)

	if slot == 0 and id then
		if #equippedWeapons > 0 then
			slot = 1
		end
	end

	local inventoryId = 1

	-- _ITEMDATABASE_IS_KEY_VALID
	local isValid = Citizen.InvokeNative(0x6D5D51B188333FD1, itemHash, 0) --ItemdatabaseIsKeyValid
	if not isValid then
		return false
	end

	local characterItem = getGuidFromItemId(inventoryId, nil, GetHashKey("CHARACTER"), 0xA1212100) --return func_1367(joaat("CHARACTER"), func_2485(), -1591664384, bParam0);
	if not characterItem then
		-- print("no characterItem")
		return false
	end

	local weaponItem = getGuidFromItemId(inventoryId, characterItem:Buffer(), 923904168, -740156546) --return func_1367(923904168, func_1889(1), -740156546, 0);
	if not weaponItem then
		-- print("no weaponItem")
		return false
	end

	if slot == 1 and id then
		if #equippedWeapons > 0 then
			local newItemData = DataView.ArrayBuffer(8 * 13)
			local newGUID = moveInventoryItem(inventoryId, equippedWeapons[1].guid, weaponItem:Buffer())
			-- if not newGUID then
			-- 	print("can't move item")
			-- 	return false
			-- end
			slotHash = GetHashKey('SLOTID_WEAPON_0')
			slot = 0
		else
			slotHash = GetHashKey('SLOTID_WEAPON_0')
			slot = 0
		end
	end

	local itemData = DataView.ArrayBuffer(8 * 13)
	-- _INVENTORY_ADD_ITEM_WITH_GUID
	local isAdded = Citizen.InvokeNative(0xCB5D11F9508A928D, inventoryId, itemData:Buffer(), weaponItem:Buffer(), itemHash, slotHash, 1, addReason)
	if not isAdded then
		-- print(" no isAdded ")
		return false
	end

	-- _INVENTORY_EQUIP_ITEM_WITH_GUID
	local equipped = Citizen.InvokeNative(0x734311E2852760D0, inventoryId, itemData:Buffer(), true);
	if not equipped then
		return false
	end

	return givePlayerWeapon(id, itemHash, itemData, attachPoint, moveWeapon);
end

local attachOriginal = true
RegisterNetEvent("ox_inventory:ReplaceAttachPoint", function(item, attachPoint)
	local id = equippedWeapons[1] and 2 or 1
	local slot = attachPoint == 2 and 0 or 1

	addWardrobeInventoryItem(id, slot, item.name, attachPoint)

	TriggerEvent('gm_weaponcomp:client:applyComponents', item.name, GetHashKey(item.name), item.metadata.components)
end)

function Weapon.Equip(item, data, noWeaponAnim)
	local playerPed = cache.ped
	local coords = GetEntityCoords(playerPed, true)
	local sleep

	if client.weaponanims then
		if noWeaponAnim or (cache.vehicle and vehicleIsCycle(cache.vehicle)) then
			goto skipAnim
		end

		local anim = data.anim or anims[GetWeapontypeGroup(data.hash)]

		if anim == anims[`GROUP_PISTOL`] and not client.hasGroup(shared.police) then
			anim = nil
		end

		sleep = anim and anim[3] or 1200

		Utils.PlayAnimAdvanced(sleep, anim and anim[1] or 'reaction@intimidation@1h', anim and anim[2] or 'intro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, sleep * 2, 50, 0.1)
	end

	::skipAnim::

	item.hash = data.hash
	item.ammo = data.ammoname

	if IS_GTAV then
		item.melee = GetWeaponDamageType(data.hash) == 2 and 0
	end

	if IS_RDR3 then
		item.melee = IsWeaponMeleeWeapon(data.hash)
	end

	item.timer = 0
	item.throwable = data.throwable
	item.group = GetWeapontypeGroup(item.hash)

	if IS_GTAV then
		GiveWeaponToPed(playerPed, data.hash, 0, false, true)

	elseif IS_RDR3 then
		local isBow = (data.hash == `WEAPON_BOW` or data.hash == `WEAPON_BOW_IMPROVED`)

		if not HasPedGotWeapon(playerPed, data.hash, 0, false) then
			local currentWeaponAmmo = GetAmmoInPedWeapon(playerPed, data.hash)
			N_0xf4823c813cb8277d(playerPed, data.hash, currentWeaponAmmo, `REMOVE_REASON_DEBUG`)

			-- Wait(250)

			if data.throwable then
				GiveDelayedWeaponToPed(playerPed, data.hash, tonumber(item.count), true, 0)
			else
				-- IMPORTANT: don’t give bow with 0, it can bug equip state
				local giveAmmo = item.metadata.ammo or 0
				if isBow and giveAmmo <= 0 then giveAmmo = 1 end
				GiveDelayedWeaponToPed(playerPed, data.hash, giveAmmo, true, 0)
			end
		end

		-- Now equip for real
		SetCurrentPedWeapon(playerPed, data.hash, false, 0, false, false)

		-- Bow aim can still be weird if quiver is 0; do the "loaded arrow" nudge then restore
		if isBow and (item.metadata.ammo or 0) <= 0 then
			SetPedAmmo(playerPed, data.hash, 1)
			Wait(100)
			SetPedAmmo(playerPed, data.hash, 0)
		end

		Citizen.InvokeNative(0x2A7B50E, true) -- SetWeaponsNoAutoswap
	end

	if item.metadata.tint then
		SetPedWeaponTintIndex(playerPed, data.hash, item.metadata.tint)
	end

	if item.metadata.components then
		for i = 1, #item.metadata.components do
			local components = Items[item.metadata.components[i]].client.component
			for v = 1, #components do
				local component = components[v]
				if DoesWeaponTakeWeaponComponent(data.hash, component) then
					if not HasPedGotWeaponComponent(playerPed, data.hash, component) then
						GiveWeaponComponentToPed(playerPed, data.hash, component)
					end
				end
			end
		end
	end

	if item.metadata.specialAmmo then
		local clipComponentKey = ('%s_CLIP'):format(data.model:gsub('WEAPON_', 'COMPONENT_'))
		local specialClip = ('%s_%s'):format(clipComponentKey, item.metadata.specialAmmo:upper())

		if DoesWeaponTakeWeaponComponent(data.hash, specialClip) then
			GiveWeaponComponentToPed(playerPed, data.hash, specialClip)
		end
	end

	local ammo = item.metadata.ammo or (item.throwable and 1) or 0

	if IS_GTAV then
		SetCurrentPedWeapon(playerPed, data.hash, true)
		SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
		SetWeaponsNoAutoswap(true)
	end

	if IS_RDR3 then
		SetCurrentPedWeapon(playerPed, data.hash, false, 0, false, false)
		Citizen.InvokeNative(0x2A7B50E, true) -- SetWeaponsNoAutoswap

		-- Bow "init" nudge so aiming works immediately even if quiver (metadata.ammo) is 0
		local isBow = (data.hash == `WEAPON_BOW` or data.hash == `WEAPON_BOW_IMPROVED`)
		if isBow and (item.metadata.ammo or 0) <= 0 then
			SetPedAmmo(playerPed, data.hash, 1)
			Wait(100)
			SetPedAmmo(playerPed, data.hash, 0)
		end
	end

	SetPedAmmo(playerPed, data.hash, ammo)

	if IS_GTAV then
		SetTimeout(0, function()
			RefillAmmoInstantly(playerPed)
		end)
	end

	if item.group == 1595662460 or item.group == `GROUP_FIREEXTINGUISHER` then
		item.metadata.ammo = item.metadata.durability
		SetPedInfiniteAmmo(playerPed, true, data.hash)
	end

	TriggerEvent('ox_inventory:currentWeapon', item)

	if client.weaponnotify then
		Utils.ItemNotify({ item, 'ui_equipped' })
	end

	return item, sleep
end

function Weapon.Disarm(currentWeapon, noAnim, keepHolstered)
	if currentWeapon?.timer then
		currentWeapon.timer = nil

        TriggerServerEvent('ox_inventory:updateWeapon')
		SetPedAmmo(cache.ped, currentWeapon.hash, 0)

		if client.weaponanims and not noAnim then
			if cache.vehicle and vehicleIsCycle(cache.vehicle) then
				goto skipAnim
			end

			ClearPedSecondaryTask(cache.ped)

			local item = Items[currentWeapon.name]
			local coords = GetEntityCoords(cache.ped, true)
			local anim = item.anim or anims[GetWeapontypeGroup(currentWeapon.hash)]

			if anim == anims[`GROUP_PISTOL`] and not client.hasGroup(shared.police) then
				anim = nil
			end

			local sleep = anim and anim[6] or 1400

			-- Utils.PlayAnimAdvanced(sleep, anim and anim[4] or 'reaction@intimidation@1h', anim and anim[5] or 'outro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(cache.ped), 8.0, 3.0, sleep, 50, 0)
		end

		::skipAnim::

		if client.weaponnotify then
			Utils.ItemNotify({ currentWeapon, 'ui_holstered' })
		end

		TriggerEvent('ox_inventory:currentWeapon')
	end

	if IS_RDR3 and currentWeapon then
		if not keepHolstered then
			local ammoHash = GetPedAmmoTypeFromWeapon(cache.ped, currentWeapon.hash)
			RemoveAmmoFromPedByType(cache.ped, ammoHash, currentWeapon.ammo, GetHashKey('REMOVE_REASON_DROPPED'))  --_REMOVE_AMMO_FROM_PED_BY_TYPE

			RemoveWeaponFromPed(cache.ped, currentWeapon.hash)
			TriggerEvent("ox_inventory:clearEquippedWeapons")
		end

		local heldWeapon = GetPedCurrentHeldWeapon(cache.ped)

		if currentWeapon.hash == `WEAPON_BOW` or currentWeapon.hash == `WEAPON_BOW_IMPROVED` then
			ClearPedSecondaryTask(cache.ped)
			SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true, 0, false, false)
			HolsterPedWeapons(cache.ped, false, false, true, false)
			TaskSwapWeapon(cache.ped, 0, 0, 0, 0)
		else
			if heldWeapon == currentWeapon.hash then
				HolsterPedWeapons(cache.ped, false, false, true, false)
				TaskSwapWeapon(cache.ped, 0, 0, 0, 0)
			end
		end
	end

	if IS_GTAV then
		Utils.WeaponWheel()
		RemoveAllPedWeapons(cache.ped, true)
	end
end

function Weapon.ClearAll(currentWeapon)
	Weapon.Disarm(currentWeapon)

	if IS_RDR3 then
		RemoveAllPedWeapons(PlayerPedId(), true, IS_RDR3)
		TriggerEvent("ox_inventory:clearEquippedWeapons")
	end

	if client.parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(cache.ped, chute, 0, true, false)
		SetPedGadget(cache.ped, chute, true)
	end
end

if IS_RDR3 then
	function GetSelectedPedWeapon(playerPed)
		local _, wep = GetCurrentPedWeapon(playerPed, true, 0, true)
		return wep
	end
end

clearEquippedWeapons = function()
	equippedWeapons = {}
end

Utils.Disarm = Weapon.Disarm
Utils.ClearWeapons = Weapon.ClearAll

return Weapon

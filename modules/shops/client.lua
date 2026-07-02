if not lib then return end

local shopTypes = {}
local shops = {}
local createBlip = require 'modules.utils.client'.CreateBlip

for shopType, shopData in pairs(lib.load('data.shops') --[[@as table<string, OxShop>]]) do
	local shop = {
		name = shopData.name,
		groups = shopData.groups or shopData.jobs,
		blip = shopData.blip,
		label = shopData.label,
        icon = shopData.icon
	}

	if shared.target then
		shop.model = shopData.model
		shop.targets = shopData.targets
	else
		shop.locations = shopData.locations
	end

	-- if shopData.pedData then
    --     local model = shopData.pedData.model
    --     local locs  = shopData.pedData.locations or {}
    --     local i = 0

    --     for k, v in pairs(locs) do
    --         i = i + 1
    --         -- 👇 build a unique name inline
    --         local suffix = (type(v) == "table" and v.name) or (type(k) == "string" and k) or i
    --         local pedName = ((shopData.name or shopType) .. "_" .. tostring(suffix))
    --             :gsub("%s+", "_")
    --             :gsub("[^%w_]", "")
    --             :lower()
    --         exports.gm_core:SpawnPed(pedName, v, model, 10.0, 15.0)
    --     end
    -- end

	shopTypes[shopType] = shop
	local blip = shop.blip

	if blip then
		blip.name = ('ox_shop_%s'):format(shop.name)
		AddTextEntry(blip.name, shop.name or shopType)
	end
end

---@param point CPoint
local function onEnterShop(point)
	if not point.entity then
		local model = lib.requestModel(point.ped)

		if not model then return end

		local entity = CreatePed(0, model, point.coords.x, point.coords.y, point.coords.z, point.heading, false, true)

		if point.scenario then TaskStartScenarioInPlace(entity, point.scenario, 0, true) end

		SetModelAsNoLongerNeeded(model)
		FreezeEntityPosition(entity, true)
		SetEntityInvincible(entity, true)
		SetBlockingOfNonTemporaryEvents(entity, true)

		exports.ox_target:addLocalEntity(entity, {
            {
                icon = point.icon or 'fas fa-shopping-basket',
                label = point.label,
                groups = point.groups,
                onSelect = function()
                    client.openInventory('shop', { id = point.invId, type = point.type })
                end,
                iconColor = point.iconColor,
                distance = point.shopDistance or 2.0
            }
		})

		point.entity = entity
	end
end

local Utils = require 'modules.utils.client'

local function onExitShop(point)
	local entity = point.entity

	if not entity then return end

	exports.ox_target:removeLocalEntity(entity)
	Utils.DeleteEntity(entity)

	point.entity = nil
end

local function hasShopAccess(shop)
	return not shop.groups or client.hasGroup(shop.groups)
end

local function wipeShops()
	for i = 1, #shops do
		local shop = shops[i]

		if shop.zoneId then
            exports.ox_target:removeZone(shop.zoneId)
            shop.zoneId = nil
		end

		if shop.remove then
			if shop.entity then onExitShop(shop) end

			shop:remove()
		end

		if shop.blip then
			RemoveBlip(shop.blip)
		end
	end

	table.wipe(shops)
end

local function refreshShops()
	wipeShops()

	local id = 0

	for type, shop in pairs(shopTypes) do
		local blip = shop.blip
		local label = shop.label or locale('open_label', shop.name)

		if shared.target then
			if shop.model then
				if not hasShopAccess(shop) then goto skipLoop end

				exports.ox_target:removeModel(shop.model, shop.name)
				exports.ox_target:addModel(shop.model, {
                    {
                        name = shop.name,
                        icon = shop.icon or 'fas fa-shopping-basket',
                        label = label,
                        onSelect = function()
                            client.openInventory('shop', { type = type })
                        end,
                        distance = 2
                    },
				})
			elseif shop.targets then
				for i = 1, #shop.targets do
					local target = shop.targets[i]
					local shopid = ('%s-%s'):format(type, i)

					if target.ped then
						id += 1

						shops[id] = lib.points.new({
							coords = target.loc,
							heading = target.heading,
							distance = 60,
							inv = 'shop',
							invId = i,
							type = type,
							blip = blip and hasShopAccess(shop) and createBlip(blip, target.loc),
							ped = target.ped,
							scenario = target.scenario,
							label = label,
							groups = shop.groups,
							icon = shop.icon,
							iconColor = target.iconColor,
							onEnter = onEnterShop,
							onExit = onExitShop,
							shopDistance = target.distance,
						})
					else
						if not hasShopAccess(shop) then goto nextShop end

						id += 1

						shops[id] = {
							zoneId = Utils.CreateBoxZone(target, {
                                {
                                    name = shopid,
                                    icon = 'fas fa-shopping-basket',
                                    label = label,
                                    groups = shop.groups,
                                    onSelect = function()
                                        client.openInventory('shop', { id = i, type = type })
                                    end,
                                    iconColor = target.iconColor,
                                }
                            }),
							blip = blip and createBlip(blip, target.coords)
						}
					end

					::nextShop::
				end
			end
		elseif shop.locations then
			if not hasShopAccess(shop) then goto skipLoop end

			for i = 1, #shop.locations do
				local coords = shop.locations[i]
				local groupName = ('shop_%s_%s'):format(type, i)
				local promptKey = shop.promptKey or 0x5415BE48
				local promptLabel = label

				jo.prompt.create(groupName, promptLabel, promptKey, 1000)

				id += 1

				shops[id] = lib.points.new(coords, 16, {
					coords = coords,
					distance = 16,
					inv = 'shop',
					invId = i,
					type = type,
					nearby = function(self)
						if self.currentDistance < 1.5 then
							jo.prompt.displayGroup(groupName)
							if jo.prompt.isCompleted(groupName, promptKey) then
								client.openInventory('shop', { id = self.invId, type = self.type })
							end
						end
					end,
					groups = shop.groups,
					blip = blip and createBlip(blip, coords)
				})
			end
		end

		::skipLoop::
	end
end

return {
	refreshShops = refreshShops,
	wipeShops = wipeShops,
}

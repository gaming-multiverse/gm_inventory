local containers = {}

---@class ItemContainerProperties
---@field slots number
---@field maxWeight number
---@field whitelist? table<string, true> | string[]
---@field blacklist? table<string, true> | string[]

local function arrayToSet(tbl)
	local size = #tbl
	local set = table.create(0, size)

	for i = 1, size do
		set[tbl[i]] = true
	end

	return set
end

---Registers items with itemName as containers (i.e. backpacks, wallets).
---@param itemName string
---@param properties ItemContainerProperties
---@todo Rework containers for flexibility, improved data structure; then export this method.
local function setContainerProperties(itemName, properties)
	local blacklist, whitelist, explodeWeight = properties.blacklist, properties.whitelist, properties.explodeWeight

	if blacklist then
		local tableType = table.type(blacklist)

		if tableType == 'array' then
			blacklist = arrayToSet(blacklist)
		elseif tableType ~= 'hash' then
			TypeError('blacklist', 'table', type(blacklist))
		end
	end

	if whitelist then
		local tableType = table.type(whitelist)

		if tableType == 'array' then
			whitelist = arrayToSet(whitelist)
		elseif tableType ~= 'hash' then
			TypeError('whitelist', 'table', type(whitelist))
		end
	end

	containers[itemName] = {
		size = { properties.slots, properties.maxWeight },
		explodeWeight = explodeWeight,
		blacklist = blacklist,
		whitelist = whitelist,
	}
end

setContainerProperties('cigarbox', {
	slots = 25,
	maxWeight = 5000,
	explodeWeight = false,
	whitelist = { 'cigar1', 'cigar2', 'cigar3', 'cigar4', 'cigarette' }
})

setContainerProperties('doctorsatchel', {
	slots = 10,
	maxWeight = 50000,
	explodeWeight = true,
	whitelist = {
		'self_revive',
		'processedopium',
		'herbalremedies'
	}
})

setContainerProperties('paper_binder', {
	slots        = 50,
	maxWeight    = 500,
	explodeWeight = false,
	whitelist    = { 'k_official_paper', 'k_weapon_permit', 'cwnote' }
})

return containers

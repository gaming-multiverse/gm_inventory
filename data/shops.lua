return {
	--Public Shops
	General = {
		name = "General Store",
		promptKey = 0xF3830D8E,
		blip = {
			id = "blip_shop_store",
			colour = "BLIP_MODIFIER_MP_COLOR_32",
			scale = 0.2,
		},
		inventory = {
			{ name = "lumberjack_axe", price = 6.50, count = 999 },
			{ name = "pickaxe", price = 6.50, count = 999 },
			{ name = "goldpan", price = 4, count = 999 },
			{ name = "coffee", price = 0.50, count = 999 },
			{ name = "water", price = 0.50, count = 999 },
			{ name = "peach", price = 0.50, count = 999 },
			{ name = "kidneybeans_can", price = 2, count = 999 },
		},
		locations = {
			vec3(1328.09, -1293.74, 77.02), -- Rhodes
			vec3(-322.36, 803.84, 117.88), -- Valentine
			vec3(-1791.22, -387.08, 160.33), -- Strawberry
			vec3(2825.59, -1318.19, 46.76), -- Saint Denis
			vec3(-5487.24, -2938.99, -0.39), -- Tumbleweed
			vec3(-787.62, -1322.05, 43.88), -- Blackwater
			vec3(3027.29, 562.30, 44.72), -- Van Horn
			vec3(-3685.58, -2623.62, -13.41), -- Armadillo
			vec3(-1346.06, 2401.82, 307.07), -- Snow
			vec3(1420.59, 379.56, 89.92), -- Emerald Ranch
			vec3(432.58, 2193.16, 246.79), -- Wapiti
			vec3(-2192.51, -1713.85, 141.64), -- cree
		},
	},
	Sisika = {
		name = "General Store Sisika",
		promptKey = 0xF3830D8E,
		blip = {
			id = "blip_shop_store",
			colour = "BLIP_MODIFIER_MP_COLOR_32",
			scale = 0.2,
		},
		inventory = {
			{ name = "lumberjack_axe", price = 6.50, count = 999 },
			{ name = "pickaxe", price = 6.50, count = 999 },
			{ name = "goldpan", price = 4, count = 999 },
			{ name = "coffee", price = 0.50, count = 999 },
			{ name = "water", price = 0.50, count = 999 },
			{ name = "peach", price = 0.50, count = 999 },
			{ name = "kidneybeans_can", price = 2, count = 999 },
		},
		locations = {
			vec3(3335.83, -680.01, 45.61), -- sisika
		},
	},
	WeaponShop = {
		name = "Weapon Shop",
		promptKey = 0xF3830D8E,
		promptLabel = "Weapon Shop",
		inventory = {
			{ name = "weapon_melee_lantern", price = 15, count = 25 },
			{ name = "weapon_kit_binoculars", price = 15, count = 25 },
			{ name = "weapon_lasso", price = 9, count = 100 },
			{ name = "weapon_melee_knife", price = 6, count = 50 },
			{ name = "weapon_revolver_cattleman", price = 18, count = 50 },
			{ name = "weapon_rifle_varmint", price = 5, count = 50 },
			{ name = "weapon_bow", price = 8, count = 75 },
			{ name = "ammo_revolver", price = 0.16, count = 999 },
			{ name = "ammo_22", price = 0.05, count = 999 },
			{ name = "ammo_arrow", price = 0.04, count = 999 },
		},
		locations = {
			vec3(-281.20, 780.73, 119.53), -- Valentine
			vec3(1323.00, -1321.51, 77.89), -- Rhodes
			vec3(2716.46, -1285.47, 49.63), -- Saint Denis
			vec3(-5508.16, -2964.44, -0.63), -- Tumbleweeed
			vec3(2946.56, 1319.97, 44.82), -- Annesburg
			vec3(-786.69, -1297.80, 43.73), -- Blackwater
			vec3(-3675.86, -2598.79, -13.34), -- Armadillo
			vec3(-1844.78, -417.29, 161.34), -- Strawberry
		},
	},
	FishVendor = {
		name = "Fish shop",
		promptKey = 0xF3830D8E,
		promptLabel = "Fish shop",
		blip = {
			id = "blip_mg_fishing",
			colour = "BLIP_MODIFIER_MP_COLOR_32",
			scale = 0.2,
		},
		inventory = {
			{ name = "weapon_fishingrod", price = 8, count = 50 },
			{ name = "p_baitbread01x", price = 0.15, count = 50 },
			{ name = "p_baitcorn01x", price = 0.15, count = 50 },
			{ name = "p_baitcheese01x", price = 0.15, count = 50 },
			{ name = "p_baitworm01x", price = 0.15, count = 50 },
			{ name = "p_baitcricket01x", price = 0.15, count = 50 },
			{ name = "p_crawdad01x", price = 0.15, count = 50 },
		},
		locations = {
			vec3(2120.57, -557.59, 42.73),
			vec3(-1197.19, -1943.57, 43.61),
		},
	},


	--JOB Lock SHOPS
	-- Ranch = {
	-- 	name = "Ranch Store",
	-- 	promptKey = 0xF3830D8E,
	-- 	blip = {
	-- 		id = "blip_shop_store",
	-- 		colour = "BLIP_MODIFIER_MP_COLOR_32",
	-- 		scale = 0.2,
	-- 	},
	-- 	groups = {
	-- 		blackwaterranch = 0,
	-- 		pronghornranch = 0,
	-- 		emeraldranch = 0,
	-- 		rhodesranch = 0,
	-- 		macfarlaneranch = 0,
	-- 		rathskeller = 0,
	-- 	},
	-- 	inventory = {

	-- 		{ name = "feed_for_pet", price = 0.50, count = 500 },
	-- 		{ name = "drink_for_pet", price = 0.50, count = 500 },
	-- 		{ name = "medicine_for_pet", price = 1.0, count = 500 },
	-- 		{ name = "empty_bucket", price = 7.50, count = 100 },
	-- 		{ name = "ricx_waterpump", price = 30, count = 100 },
	-- 		{ name = "ricx_rake2", price = 15, count = 100 },
	-- 		{ name = "ricx_bugspray2", price = 15.50, count = 100 },
	-- 		{ name = "ricx_waterpump_pipe", price = 9, count = 100 },
	-- 		{ name = "scarecrow", price = 10, count = 100 },
	-- 	},
	-- 	locations = {
	-- 		vec3(-327.64, -364.87, 88.05), -- Flatnet
	-- 	},
	-- },
	-- RanchArmadillo = {
	-- 	name = "Ranch Store",
	-- 	promptKey = 0xF3830D8E,
	-- 	blip = {
	-- 		id = "blip_shop_store",
	-- 		colour = "BLIP_MODIFIER_MP_COLOR_32",
	-- 		scale = 0.2,
	-- 	},
	-- 	groups = {
	-- 		blackwaterranch = 0,
	-- 		pronghornranch = 0,
	-- 		emeraldranch = 0,
	-- 		rhodesranch = 0,
	-- 		macfarlaneranch = 0,
	-- 		rathskeller = 0,
	-- 	},
	-- 	inventory = {

	-- 		{ name = "feed_for_pet", price = 0.50, count = 500 },
	-- 		{ name = "drink_for_pet", price = 0.50, count = 500 },
	-- 		{ name = "medicine_for_pet", price = 1.0, count = 500 },
	-- 		{ name = "empty_bucket", price = 7.50, count = 100 },
	-- 		{ name = "ricx_waterpump", price = 30, count = 100 },
	-- 		{ name = "ricx_rake2", price = 15, count = 100 },
	-- 		{ name = "ricx_bugspray2", price = 15.50, count = 100 },
	-- 		{ name = "ricx_waterpump_pipe", price = 9, count = 100 },
	-- 		{ name = "scarecrow", price = 10, count = 100 },
	-- 	},
	-- 	locations = {
	-- 		vec3(-3681.83, -2539.20, -13.76), -- Armadillo
	-- 	},
	-- },
	Herbalist = {
		name = "Herbalist Market",
		promptKey = 0xF3830D8E,
		blip = {
			id = "blip_shop_market_stall",
			colour = "BLIP_MODIFIER_MP_COLOR_32",
			scale = 0.2,
		},
		groups = {
			saintdenisherbalist = 0,
			strawberryherbalist = 0,
			emeraldherbalist = 0,
			blackwaterherbalist = 0,
			armadilloherbalist = 0,
			test = 0,
		},
		inventory = {
			{ name = "hopseed", price = 0.30, count = 500 },
			{ name = "carrotseed", price = 0.30, count = 500 },
			{ name = "cornseed", price = 0.30, count = 500 },
			{ name = "sugarseed", price = 0.30, count = 500 },
			{ name = "tobaccoseed", price = 0.30, count = 500 },
			{ name = "tomatoseed", price = 0.30, count = 500 },
			{ name = "broccoliseed", price = 0.30, count = 500 },
			{ name = "potatoseed", price = 0.30, count = 500 },
			{ name = "agaritaseed", price = 0.30, count = 500 },
			{ name = "wildmintseed", price = 0.30, count = 500 },
			{ name = "ramsheadseed", price = 0.30, count = 500 },
			{ name = "parasolmushroomseed", price = 0.30, count = 500 },
			{ name = "hummingbirdsageseed", price = 0.30, count = 500 },
			{ name = "evergreenhuckleberryseed", price = 0.30, count = 500 },
			{ name = "alaskanginsengseed", price = 0.30, count = 500 },
			{ name = "grainseed", price = 0.30, count = 500 },
			{ name = "indtobaccoseed", price = 0.30, count = 500 },
			{ name = "onionseed", price = 0.30, count = 500 },
			{ name = "pepperseed", price = 0.30, count = 500 },
			{ name = "blackcurrantseed", price = 0.30, count = 500 },
			{ name = "cabbageseed", price = 0.30, count = 500 },
			{ name = "appleseed", price = 0.30, count = 500 },
			{ name = "yarrowseed", price = 0.30, count = 500 },
			{ name = "chamomileseed", price = 0.30, count = 500 },
			{ name = "thymeseed", price = 0.30, count = 500 },
			{ name = "oreganoseed", price = 0.30, count = 500 },
			{ name = "grapeseed", price = 0.30, count = 500 },
			{ name = "bberry", price = 0.30, count = 500 },
			{ name = "milkweedseed", price = 0.30, count = 500 },
			{ name = "viosnwdrpseed", price = 0.30, count = 500 },
			{ name = "desertsageseed", price = 0.30, count = 500 },
			{ name = "redsageseed", price = 0.30, count = 500 },
			{ name = "fertilizer", price = 1.50, count = 100 },
		},
		locations = {
			vec3(-327.64, -364.87, 88.05), -- Flatnet
		},
	},
	-- HerbalistArmadillo = {
	-- 	name = "Herbalist Market",
	-- 	promptKey = 0xF3830D8E,
	-- 	blip = {
	-- 		id = "blip_shop_market_stall",
	-- 		colour = "BLIP_MODIFIER_MP_COLOR_32",
	-- 		scale = 0.2,
	-- 	},
	-- 	groups = {
	-- 		armadilloherbalist = 0,
	-- 		saintdenisherbalist = 0,
	-- 		strawberryherbalist = 0,
	-- 		emeraldherbalist = 0,
	-- 		blackwaterherbalist = 0,
	-- 	},
	-- 	inventory = {
	-- 		{ name = "hopseed", price = 0.30, count = 500 },
	-- 		{ name = "carrotseed", price = 0.30, count = 500 },
	-- 		{ name = "cornseed", price = 0.30, count = 500 },
	-- 		{ name = "sugarseed", price = 0.30, count = 500 },
	-- 		{ name = "tobaccoseed", price = 0.30, count = 500 },
	-- 		{ name = "tomatoseed", price = 0.30, count = 500 },
	-- 		{ name = "broccoliseed", price = 0.30, count = 500 },
	-- 		{ name = "potatoseed", price = 0.30, count = 500 },
	-- 		{ name = "agaritaseed", price = 0.30, count = 500 },
	-- 		{ name = "wildmintseed", price = 0.30, count = 500 },
	-- 		{ name = "ramsheadseed", price = 0.30, count = 500 },
	-- 		{ name = "parasolmushroomseed", price = 0.30, count = 500 },
	-- 		{ name = "hummingbirdsageseed", price = 0.30, count = 500 },
	-- 		{ name = "evergreenhuckleberryseed", price = 0.30, count = 500 },
	-- 		{ name = "alaskanginsengseed", price = 0.30, count = 500 },
	-- 		{ name = "grainseed", price = 0.30, count = 500 },
	-- 		{ name = "indtobaccoseed", price = 0.30, count = 500 },
	-- 		{ name = "onionseed", price = 0.30, count = 500 },
	-- 		{ name = "pepperseed", price = 0.30, count = 500 },
	-- 		{ name = "blackcurrantseed", price = 0.30, count = 500 },
	-- 		{ name = "cabbageseed", price = 0.30, count = 500 },
	-- 		{ name = "appleseed", price = 0.30, count = 500 },
	-- 		{ name = "yarrowseed", price = 0.30, count = 500 },
	-- 		{ name = "chamomileseed", price = 0.30, count = 500 },
	-- 		{ name = "thymeseed", price = 0.30, count = 500 },
	-- 		{ name = "oreganoseed", price = 0.30, count = 500 },
	-- 		{ name = "grapeseed", price = 0.30, count = 500 },
	-- 		{ name = "bberry", price = 0.30, count = 500 },
	-- 		{ name = "milkweedseed", price = 0.30, count = 500 },
	-- 		{ name = "viosnwdrpseed", price = 0.30, count = 500 },
	-- 		{ name = "desertsageseed", price = 0.30, count = 500 },
	-- 		{ name = "redsageseed", price = 0.30, count = 500 },
	-- 		{ name = "fertilizer", price = 1.50, count = 100 },
	-- 	},
	-- 	locations = {
	-- 		vec3(-3681.83, -2539.20, -13.76), -- arma
	-- 	},
	-- },
	-- SaloonMarket = {
	-- 	name = "Saloon Market",
	-- 	promptKey = 0xF3830D8E,
	-- 	blip = {
	-- 		id = "blip_shop_market_stall",
	-- 		colour = "BLIP_MODIFIER_MP_COLOR_32",
	-- 		scale = 0.2,
	-- 	},
	-- 	groups = {
	-- 		valentinesaloon = 0,
	-- 		strawberrysaloon = 0,
	-- 		blackwatersaloon = 0,
	-- 		rhodessaloon = 0,
	-- 		armadillosaloon = 0,
	-- 		emeraldsaloon = 0,
	-- 		saintdenissaloon = 0,
	-- 		vanhornsaloon = 0,
	-- 	},
	-- 	inventory = {
	-- 		{ name = "cheese", price = 1.50, count = 50 },
	-- 		{ name = "milk", price = 1.50, count = 50 },
	-- 		{ name = "egg", price = 1.50, count = 50 },
	-- 		{ name = "yogurt", price = 1.50, count = 50 },
	-- 		{ name = "salt", price = 0.50, count = 50 },
	-- 		{ name = "empty_glass", price = 2, count = 10 },
	-- 		{ name = "whiskey", price = 5, count = 50 },
	-- 		{ name = "vodka", price = 5, count = 50 },
	-- 		{ name = "tequila", price = 5, count = 50 },
	-- 		{ name = "gin", price = 5, count = 50 },
	-- 		{ name = "wine", price = 5, count = 50 },
	-- 		{ name = "rum", price = 5, count = 50 },
	-- 	},
	-- 	locations = {
	-- 		vec3(-327.64, -364.87, 88.05), -- Flatnet
	-- 	},
	-- },
	-- SaloonMarketArmadillo = {
	-- 	name = "Saloon Market",
	-- 	promptKey = 0xF3830D8E,
	-- 	blip = {
	-- 		id = "blip_shop_market_stall",
	-- 		colour = "BLIP_MODIFIER_MP_COLOR_32",
	-- 		scale = 0.2,
	-- 	},
	-- 	groups = {
	-- 		valentinesaloon = 0,
	-- 		strawberrysaloon = 0,
	-- 		blackwatersaloon = 0,
	-- 		rhodessaloon = 0,
	-- 		armadillosaloon = 0,
	-- 		emeraldsaloon = 0,
	-- 		saintdenissaloon = 0,
	-- 		vanhornsaloon = 0,
	-- 	},
	-- 	inventory = {
	-- 		{ name = "cheese", price = 1.50, count = 50 },
	-- 		{ name = "milk", price = 1.50, count = 50 },
	-- 		{ name = "egg", price = 1.50, count = 50 },
	-- 		{ name = "yogurt", price = 1.50, count = 50 },
	-- 		{ name = "salt", price = 0.50, count = 50 },
	-- 		{ name = "empty_glass", price = 2, count = 50 },
	-- 		{ name = "whiskey", price = 5, count = 50 },
	-- 		{ name = "vodka", price = 5, count = 50 },
	-- 		{ name = "tequila", price = 5, count = 50 },
	-- 		{ name = "gin", price = 5, count = 50 },
	-- 		{ name = "wine", price = 5, count = 50 },
	-- 		{ name = "rum", price = 5, count = 50 },
	-- 	},
	-- 	locations = {
	-- 		vec3(-3681.83, -2539.20, -13.76), -- arma
	-- 	},
	-- },
	-- HorseTrainerMarket = {
	-- 	name = "Horse Trainer Market",
	-- 	promptKey = 0xF3830D8E,
	-- 	blip = {
	-- 		id = "blip_shop_market_stall",
	-- 		colour = "BLIP_MODIFIER_MP_COLOR_32",
	-- 		scale = 0.2,
	-- 	},
	-- 	groups = {
	-- 		horsetrainer = 0,
	-- 		cree = 0,
	-- 		macfarlanesstable = 0,
	-- 		emeraldranchstable = 0,
	-- 		bluewaterstable = 0,
	-- 		bigvalleystable = 0,
	-- 		dakotariverstable = 0,
	-- 		rhodesstable = 0,
	-- 	},
	-- 	inventory = {
	-- 	{ name = "horse_shoe", price = 60, count = 50 },
	-- 	{ name = "horsetag", price = 15, count = 5 },
	-- 	--	{ name = "hay", price = 0.30, count = 999 },
	-- 	--	{ name = "heal_for_horse", price = 45, count = 999 },
	-- 	--	{ name = "boost_for_horse", price = 3, count = 999 },
	-- 	--	{ name = "gold_for_horse", price = 3, count = 999 },
	-- 	{ name = "breeder_fix", price = 50, count = 10 },
	-- 	--	{ name = "horsebrush", price = 9, count = 100 },
	-- 	{ name = "hoof_hook", price = 8, count = 999 },
	-- 	--	{ name = "sugarcube", price = 3, count = 999 },
	-- 	--	{ name = "apple2", price = 3, count = 999 },
	-- 	},
	-- 	locations = {
	-- 		vec3(-327.64, -364.87, 88.05), -- Flatnet
	-- 	},
	-- },
	-- HorseTrainerMarketArmadillo = {
	-- 	name = "Horse Trainer Market",
	-- 	promptKey = 0xF3830D8E,
	-- 	blip = {
	-- 		id = "blip_shop_market_stall",
	-- 		colour = "BLIP_MODIFIER_MP_COLOR_32",
	-- 		scale = 0.2,
	-- 	},
	-- 	groups = {
	-- 		horsetrainer = 0,
	-- 		cree = 0,
	-- 		macfarlanesstable = 0,
	-- 		emeraldranchstable = 0,
	-- 		bluewaterstable = 0,
	-- 		bigvalleystable = 0,
	-- 		dakotariverstable = 0,
	-- 		rhodesstable = 0,
	-- 	},
	-- 	inventory = {
	-- 	{ name = "horse_shoe", price = 60, count = 50 },
	-- 	{ name = "horsetag", price = 15, count = 5 },
	-- 	--	{ name = "hay", price = 0.30, count = 999 },
	-- 	--	{ name = "heal_for_horse", price = 45, count = 999 },
	-- 	--	{ name = "boost_for_horse", price = 3, count = 999 },
	-- 	--	{ name = "gold_for_horse", price = 3, count = 999 },
	-- 	{ name = "breeder_fix", price = 50, count = 10 },
	-- 	--	{ name = "horsebrush", price = 9, count = 100 },
	-- 	{ name = "hoof_hook", price = 8, count = 999 },
	-- 	--	{ name = "sugarcube", price = 3, count = 999 },
	-- 	--	{ name = "apple2", price = 3, count = 999 },
	-- 	},
	-- 	locations = {
	-- 		vec3(-3681.83, -2539.20, -13.76), -- armadillo
	-- 	},
	-- },
	-- PinkertonArmory = {
	-- 	name = 'Pinkerton Armory',
    --     promptKey = 0x5415BE48,
    --     promptLabel = "Pinkerton Armory",
    --     groups = shared.pinkerton,
    --     inventory = {
    --         { name = 'weapon_revolver_schofield', price = 30, grade = 0},
    --         { name = 'ammo_revolver', price = 0.01, grade = 0},
    --         { name = 'pinkerton_badge', price = 1, grade = 0},
    --         { name = 'bountypaper_2', price = 5, grade = 0 },
	-- 		{ name = 'weapon_kit_binoculars', price = 15, grade = 0}
	-- 	},
	-- 	locations = {
	-- 		vec3(2576.78, -1104.63, 55.82), --StDenis
	-- 	}
	-- },
	-- PoliceArmory = {
    --     name = 'Police Armory',
    --     promptKey = 0x5415BE48,
    --     promptLabel = "Police Armory",
    --     groups = shared.police,
    --     inventory = {
    --         { name = 'weapon_revolver_schofield', price = 30, grade = 0},
    --     --    { name = 'weapon_revolver_navy', price = 100, grade = 2 },
    --         { name = 'weapon_repeater_winchester', price = 300, grade = 4},
    --         { name = 'weapon_shotgun_pump', price = 1000, grade = 15 },
    --         { name = 'ammo_revolver', price = 0.01, grade = 0},
    --         -- { name = 'ammo_rifle', price = 0.01, grade = 2},
    --         -- { name = 'ammo_repeater', price = 0.01, grade = 2},
    --     --    { name = 'ammo_shotgun', price = 0.50, grade = 7},
    --         { name = 'ifak', price = 1, grade = 0},
    --         { name = 'dopegum', price = 1, grade = 2},
    --         { name = 'mdt_ledger', price = 1, grade = 0},
    --         { name = 'cuffs', price = 5, grade = 0},
    --         { name = 'police_badge', price = 1, grade = 0},
    --         { name = 'deputy_badge', price = 1, grade = 0},
    --         { name = 'sheriff_badge', price = 1, grade = 11},
    --         { name = 'us_marshal_badge', price = 1, grade = 15},
    --         { name = 'barricade', price = 1, grade = 0},
    --         { name = 'bountypaper_2', price = 5, grade = 1 },
    --         { name = 'rescuepaper', price = 5, grade = 13 },
    --     },
	-- 	locations = {
    --         vec(-278.52, 805.34, 119.38), -- Valentine
    --         vec(-287.52, 774.75, 122.49), -- Valentine2
	-- 		vec(-5532.76, -2927.54, -1.34), -- Tumbleweed
	-- 		vec(-3622.71, -2600.28, -13.35), -- Armadillo
	-- 		vec(-764.95, -1272.39, 44.06), -- Blackwater
	-- 		vec(-1812.39, -355.80, 164.65), -- Strawberry
	-- 		vec(1361.27, -1305.99, 77.76), -- Rhodes
	-- 		vec(341.88, 1471.31, 179.74), -- Marshal’s Quarters – Fort Wallace
	-- 		vec(2906.72, 1315.35, 44.93), -- Annes
			
	-- 		-- vec(2494.45, -1313.40, 48.95), -- Saint Denis
	-- 		vec(2496.20, -1301.90, 48.85), -- Saint Denis NewMLO
	-- 	}
    -- },
}

-- Generated from template
hero = nil
weapons = {"item_weapon_sniper", "item_weapon_stungun", "item_weapon_blink", "item_weapon_gauntlet"}
spawnAreas = {}
spawnPickupTime = {}

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	PrecacheResource("particle_folder", "particles/units/heroes/hero_magnataur", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_antimage/", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_drow/", context)
	PrecacheUnitByNameSync("npc_dota_hero_nevermore", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:SetHeroSelectionTime( 0.0 )
	GameRules:SetPreGameTime( 20.0 )
	GameRules:SetPostGameTime( 30.0 )
	spawnAreas = Entities:FindAllByName("dota_weapon_spawner")
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	ListenToGameEvent("player_connect_full", Dynamic_Wrap(CAddonTemplateGameMode, "OnPlayerConnectFull"), self)
	--GameRules:SetHeroRespawnEnabled( true )
	--GameRules:SetUseUniversalShopMode( false )
	--GameRules:SetSameHeroSelectionEnabled( true )
end

function CAddonTemplateGameMode:OnPlayerConnectFull(keys)
	local player = PlayerInstanceFromIndex(keys.index + 1)
	local hero = CreateHeroForPlayer("npc_dota_hero_nevermore", player)
	local item = CreateItem("item_weapon_starter", hero, hero)
	hero:AddItem(item)
	print("adding item " .. item:GetName())
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	for _,hero in pairs( Entities:FindAllByClassname("npc_dota_hero_nevermore") ) do
		if hero:GetPlayerOwnerID() == -1 then
			local id = hero:GetPlayerOwner():GetPlayerID()
			if id ~= -1 then
				hero:SetControllableByPlayer(id, true)
				hero:SetPlayerID(id)
			end
		end
	end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		for i, s in ipairs(spawnAreas) do
			local e = #Entities:FindAllInSphere(s:GetAbsOrigin(), 10)
			if spawnPickupTime[i] == nil then
				spawnPickupTime[i] = -30
			end
			if Time() > spawnPickupTime[i] + 30 and e == 1 then
				local random = RandomInt(1, #weapons)
				local name = weapons[random]
				local created = CreateItemOnPositionSync(s:GetAbsOrigin(), CreateItem(name, nil, nil)) 
				print(random)
			elseif e > 1 then
				spawnPickupTime[i] = Time()
			end
		end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

-- Generated from template
hero = nil
weapons = {"item_weapon_sniper", "item_weapon_stungun", "item_weapon_blink"}
spawnAreas = {}
spawnPickupTime = {0, 0, 0, 0, 0, 0 ,0 ,0}

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )

	]]

	PrecacheResource("particle_folder", "particles/units/heroes/hero_mirana/", context)
	PrecacheResource("model", "models/heroes/undying/undying_tower.vmdl", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	spawnAreas = Entities:FindAllByName("dota_weapon_spawner")
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	--[[if hero == nil then
		hero = Entities:FindByClassname(nil, "npc_dota_hero_nevermore")
	end

	if hero ~= nil then
		if hero:HasItemInInventory("item_weapon_sniper") ~= true then
			hero:AddItem(CreateItem("item_weapon_sniper", hero, hero))
		end
		if hero:HasItemInInventory("item_weapon_railgun") ~= true then
			hero:AddItem(CreateItem("item_weapon_railgun", hero, hero))
			CreateItem()
		end
	end]]

	--print(Time())

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		for i, s in ipairs(spawnAreas) do
			local e = #Entities:FindAllInSphere(s:GetAbsOrigin(), 10)
			if Time() > spawnPickupTime[i] + 10 and e == 1 then
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

function SpawnWeapons()

end
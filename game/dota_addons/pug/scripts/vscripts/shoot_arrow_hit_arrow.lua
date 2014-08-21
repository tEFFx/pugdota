projectiles = {}

infoTable = {}
stats = {}
treeMurder = nil

if TreeDestroyer == nil then
	TreeDestroyer = class ({})
end

function initArrow(keys)
	local caster = keys.caster
	if caster:HasAbility("weapon_stungun_shoot_alt") == false then
		caster:AddAbility("weapon_stungun_shoot_alt")
		local ability = caster:FindAbilityByName("weapon_stungun_shoot_alt")
		caster:SetAbilityPoints(1)
		caster:UpgradeAbility(ability)
		caster:SwapAbilities("weapon_stungun_shoot", "weapon_stungun_shoot_alt", true, false)
		print("ability initiated")
	end
end

function shootArrow(keys)
	local caster = keys.caster
	infoTable = {Ability = keys.ability,
					EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf", 
					vSpawnOrigin = caster:GetAbsOrigin(),
			        fDistance = keys.MaxDistance,
		        	fStartRadius = 200,
		        	fEndRadius = 100,
		        	Source = caster,
		        	bHasFrontalCone = false,
		        	bReplaceExisting = false,
		        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_NONE,
		        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_TREE,
		        	fExpireTime = GameRules:GetGameTime() + 10.0,
					bDeleteOnHit = false,
					vVelocity = caster:GetForwardVector() * keys.Speed,
					bProvidesVision = true,
					iVisionRadius = 1000,
					iVisionTeamNumber = caster:GetTeamNumber() }
	stats = {speed = tonumber(keys.Speed), maxdist = tonumber(keys.MaxDistance)}
	print("new arrow")
	local p = ProjectileManager:CreateLinearProjectile(infoTable)
	projectiles[caster:GetPlayerID()] = {id = p, timeCreated = Time(), start = caster:GetAbsOrigin(), forwardVector = caster:GetForwardVector(), d = -1, distance = 0, timefirst = Time(), jumps = 0, cast = caster}
	caster:SwapAbilities("weapon_stungun_shoot", "weapon_stungun_shoot_alt", false, true)

	GameRules:GetGameModeEntity():SetThink( "annihilateTrees", TreeDestroyer, "fuckTrees", 0.2 )
	--TreeDestroyer:annihilateTrees()
end

function changeArrow(keys)
	local caster = keys.caster
	local delta = Time() - projectiles[caster:GetPlayerID()].timeCreated
	print("Delta: " .. delta)
	local dist = infoTable.fDistance - delta * stats.speed
	local startPoint = projectiles[caster:GetPlayerID()].start + projectiles[caster:GetPlayerID()].forwardVector * (delta * stats.speed)
	local endPoint = keys.target_points[1]
	local point = endPoint - startPoint
	point = point:Normalized()
	infoTable.vSpawnOrigin = startPoint
	infoTable.vVelocity = point * stats.speed
	infoTable.fDistance = dist
	ProjectileManager:DestroyLinearProjectile(projectiles[caster:GetPlayerID()].id)
	print("directed projectile")
	local p = ProjectileManager:CreateLinearProjectile(infoTable)
	projectiles[caster:GetPlayerID()] = {id = p, timeCreated = Time(), forwardVector = point, start = startPoint, d = delta, distance = dist, 
	timefirst = projectiles[caster:GetPlayerID()].timefirst, jumps = projectiles[caster:GetPlayerID()].jumps + 1, cast = caster}

	if projectiles[caster:GetPlayerID()].jumps > 3 then
		caster:SwapAbilities("weapon_stungun_shoot", "weapon_stungun_shoot_alt", true, false)
	end
end

function missArrow(keys)
	local caster = keys.caster
	projectiles[caster:GetPlayerID()] = nil
	print("you missed!!!!")
	caster:SwapAbilities("weapon_stungun_shoot", "weapon_stungun_shoot_alt", true, false)
end

function hitArrow(keys)
	
	local caster = keys.caster
	local unit = keys.target_entities[1]
	--DeepPrintTable(keys)
	local delta = Time() - projectiles[caster:GetPlayerID()].timefirst
	local distconst = stats.maxdist - delta * stats.speed
	distconst = distconst / stats.maxdist
	distconst = 1 - distconst

	ProjectileManager:DestroyLinearProjectile(projectiles[caster:GetPlayerID()].id)
	print("distance constant" .. distconst)

	ApplyDamage({victim = unit, attacker = caster, damage = tonumber(keys.MaxDamage) * distconst, damage_type = DAMAGE_TYPE_PURE})
	unit:AddNewModifier(caster, nil, "modifier_stunned", {duration = tonumber(keys.MaxStun) * distconst})

	print("you hit!!!!")
	caster:SwapAbilities("weapon_stungun_shoot", "weapon_stungun_shoot_alt", true, false)
	projectiles[caster:GetPlayerID()] = nil
end

function TreeDestroyer:annihilateTrees()
	local fail = true
	for _,id in pairs(projectiles) do
		if id ~= nil then
			fail = false

			if treeMurder == nil then
				treeMurder = CreateItem("item_tree_genocide", id.cast, id.cast)
			end

			local delta = Time() - id.timeCreated
			local pos = id.start + id.forwardVector * (delta * stats.speed)

			id.cast:CastAbilityOnPosition(pos, treeMurder, -1)
		end
	end

	print("tinkering")

	if fail == true then
		print("shit")
		return nil
	else
		return 0.2
	end
end
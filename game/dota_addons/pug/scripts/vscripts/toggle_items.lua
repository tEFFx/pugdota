lastWeapon = {}

function replaceAbility(keys, ability1, ability2)
	local caster = keys.caster
	local c = keys.ability:GetCurrentCharges()

	if c == 0 then
		keys.ability:EndCooldown()
		lastWeapon[caster:GetPlayerID()] = ""
		removeAbilities(keys)
		return nil
	end

	if lastWeapon[caster:GetPlayerID()] == keys.ability:GetName() then
		keys.ability:EndCooldown()
		keys.ability:SetCurrentCharges(c + 1)
		print("no wepon for u")
		return nil
	end

	removeAbilities(keys)

	caster:AddAbility(ability1)
	caster:AddAbility(ability2)

	local a1 = caster:FindAbilityByName(ability1)
	local a2 = caster:FindAbilityByName(ability2)
	
	a1:SetAbilityIndex(0)
	a2:SetAbilityIndex(1)
	caster:SetAbilityPoints(2)
	caster:UpgradeAbility(a1)
	caster:UpgradeAbility(a2)

	lastWeapon[caster:GetPlayerID()] = keys.ability:GetName()
	print(lastWeapon[caster:GetPlayerID()])
end

function toggleBlink(keys)
	replaceAbility(keys, "weapon_blink_blink", "weapon_blink_passive")
end

function toggleStungun(keys)
	replaceAbility(keys, "weapon_stungun_shoot", "weapon_stungun_passive")
end

function toggleSniper(keys)
	replaceAbility(keys, "weapon_sniper_snipe", "weapon_sniper_passive")
end

function dropWeapon(keys)
	local caster = keys.caster
	lastWeapon[caster:GetPlayerID()] = ""
	print("dropping yo stuffz")
	for i=0,5 do
		local item = caster:GetItemInSlot(i)
		if item ~= nil then
			caster:DropItemAtPositionImmediate(item, caster:GetAbsOrigin() + RandomVector(RandomFloat(0, 50)))
		end
	end

	removeAbilities(keys)
end

function removeAbilities(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("attribute_bonus")
	for i=0,3 do
		local remove = caster:GetAbilityByIndex(i)
		if remove ~= nil then
			caster:RemoveAbility(remove:GetAbilityName())
		end
	end
end
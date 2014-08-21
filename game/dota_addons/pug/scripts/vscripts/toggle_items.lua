lastWeapon = {}
weapons = {}
weapons["item_weapon_starter"] = {"weapon_starter_silence", "ability_empty"}
weapons["item_weapon_blink"] = {"weapon_blink_blink", "weapon_blink_passive"}
weapons["item_weapon_stungun"] = {"weapon_stungun_shoot", "weapon_stungun_passive"}
weapons["item_weapon_sniper"] = {"weapon_sniper_snipe", "weapon_sniper_passive"}

function replaceAbility(keys)
	local caster = keys.caster
	local c = keys.ability:GetCurrentCharges()
	local itemName = keys.ability:GetName()

	if lastWeapon[caster:GetPlayerID()] == keys.ability:GetName()  then
		keys.ability:EndCooldown()
		keys.ability:SetCurrentCharges(c + 1)
		print("no wepon for u")
		return nil
	end

	if c <= 1 and itemName ~= "item_weapon_starter" then
		lastWeapon[caster:GetPlayerID()] = ""
		for i=0,5 do
			local item = caster:GetItemInSlot(i)
			if item ~= nil and item:GetName() == itemName then
				caster:RemoveItem(item)
			end
		end
	end

	removeAbilities(keys)

	caster:SetAbilityPoints(2)

	caster:AddAbility(weapons[itemName][1])
	local active = caster:FindAbilityByName(weapons[itemName][1])
	active:SetAbilityIndex(1)
	caster:UpgradeAbility(active)

	caster:AddAbility(weapons[itemName][2])
	local passive = caster:FindAbilityByName(weapons[itemName][2])
	passive:SetAbilityIndex(0)
	caster:UpgradeAbility(passive)

	lastWeapon[caster:GetPlayerID()] = itemName
end

function dropWeapon(keys)
	local caster = keys.caster
	lastWeapon[caster:GetPlayerID()] = ""
	print("dropping yo stuffz")
	for i=0,5 do
		local item = caster:GetItemInSlot(i)
		if item ~= nil and item:GetName() ~= "item_weapon_starter" then
			caster:RemoveItem(item)
		end
	end

	removeAbilities(keys)
	setStarter(keys)
end

function removeAbilities(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("attribute_bonus")
	for i=0,3 do
		local remove = caster:GetAbilityByIndex(i)
		if remove ~= nil and remove:GetName() ~= "ability_ondeath" then
			caster:RemoveAbility(remove:GetAbilityName())
		end
	end
end

function setStarter(key)
	local caster = key.caster
	itemName = "item_weapon_starter"

	caster:AddAbility(weapons[itemName][1])
	local active = caster:FindAbilityByName(weapons[itemName][1])	
	active:SetAbilityIndex(1)
	caster:UpgradeAbility(active)

	caster:AddAbility(weapons[itemName][2])
	local passive = caster:FindAbilityByName(weapons[itemName][2])
	passive:SetAbilityIndex(0)
	caster:UpgradeAbility(passive)

end
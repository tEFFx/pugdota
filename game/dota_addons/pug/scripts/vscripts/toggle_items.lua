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

	if lastWeapon[caster:GetPlayerID()] == keys.ability:GetName() then
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
	print("PlayerID")
	print(lastWeapon[caster:GetPlayerID()])
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
end

function removeAbilities(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("attribute_bonus")
	for i=0,3 do
		local remove = caster:GetAbilityByIndex(i)
		if remove ~= nil and 
			remove:GetName() ~= "ability_ondeath" and
			remove:GetName() ~= "ability_empty" and 
			remove:GetName() ~= "weapon_starter_silence" then
			caster:RemoveAbility(remove:GetAbilityName())
		end
	end
end

function giveStarting(keys)
	print("you get an item and YOU get an item")
	local caster = keys.caster
	local itemName = "item_weapon_starter"
	if caster:HasItemInInventory(itemName) == false then
		caster:AddItem(CreateItem(itemName, caster, caster))
	end
end
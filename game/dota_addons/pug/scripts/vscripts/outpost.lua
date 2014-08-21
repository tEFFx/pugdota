function changeOwner(keys)
	local caster = keys.caster
	if caster:GetHealth() == 1 then
		local attacker = keys.attacker
		caster:SetTeam(attacker:GetTeam())
		caster:SetHealth(1000)
		caster:AddNewModifier(caster, nil, "vision_cooldown", {})
		caster:CastAbilityNoTarget(caster:FindAbilityByName("ability_outpost_reclaim"), -1)
	end
end

function reclaim(keys)
	local caster = keys.caster
	caster:SetTeam(DOTA_TEAM_NOTEAM)
end
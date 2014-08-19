function changeOwner(keys)
	local caster = keys.caster
	if caster:GetHealth() == 1 then
		local attacker = keys.attacker
		caster:SetTeam(attacker:GetTeam())
		caster:SetHealth(1000)
	end
end
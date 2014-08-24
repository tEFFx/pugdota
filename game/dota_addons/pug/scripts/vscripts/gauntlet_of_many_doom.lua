function punch(keys)
	local caster = keys.caster
	local target = keys.target

	local damageTarget = {victim = target, attacker = caster, damage = target:GetHealth() * 0.75, damage_type = DAMAGE_TYPE_PURE}
	local damageCaster = {victim = caster, attacker = caster, damage = target:GetHealth() * 0.25, damage_type = DAMAGE_TYPE_PURE}

	print(target:GetHealthPercent() .. "hp left")
	if target:GetHealthPercent() <= 25 then
		damageTarget.damage = 9000
		damageCaster.damage = target:GetHealth() * 0.5
	end

	if target:GetTeam() == caster:GetTeam() then
		damageCaster.damage = caster:GetHealth() * 0.5
		target:Heal(caster:GetHealth() * 0.25, caster)
	else
		ApplyDamage(damageTarget)
	end

	ApplyDamage(damageCaster)
	caster:Stop()
	target:Stop()
end
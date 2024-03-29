-- How to use:
-- Use rp_afk_demote 1 to enable AFK mode.
-- Use rp_afk_demotetime to set the time someone has to be AFK before they are demoted.
-- If a player uses /afk, they go into AFK mode, they will not be autodemoted and their salary is set to $0 (you can still be killed/vote demoted though!).
-- If a player does not use /afk, and they don't do anything for the demote time specified, they will be automatically demoted to hobo.

includeCS("AFK/cl_afk.lua")
AddToggleCommand("rp_afk_demote", "afkdemote", 0)
AddValueCommand("rp_afk_demotetime", "afkdemotetime", 600)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_afk_demote <1/0> - If set to 1, players who don't do anything for ".. GetConVarNumber("afkdemotetime") .." seconds will be demoted if they do not use AFK mode.")
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_afk_demotetime <time> - Sets the time a player has to be AFK for before they are demoted (in seconds).")

local function AFKDemote(ply)
	local rpname = ply.DarkRPVars.rpname
	
	if ply:Team() ~= TEAM_CITIZEN then
		ply:ChangeTeam(TEAM_CITIZEN, true)
		ply:SetDarkRPVar("AFKDemoted", true)
		NotifyAll(0, 5, rpname .. " has been demoted for being AFK for too long.")
	end
	ply:SetDarkRPVar("job", "AFK")
end

local function SetAFK(ply)
	local rpname = ply.DarkRPVars.rpname
	ply:SetDarkRPVar("AFK", not ply.DarkRPVars.AFK)

	umsg.Start("DarkRPEffects", ply)
		umsg.String("colormod")
		umsg.String(ply.DarkRPVars.AFK and "1" or "0")
	umsg.End()

	for k, v in pairs(team.GetAllTeams()) do
		ply.bannedfrom[k] = ply.DarkRPVars.AFK and 1 or 0
	end

	if ply.DarkRPVars.AFK then
		DB.RetrieveSalary(ply, function(amount) ply.OldSalary = amount end)
		ply.OldJob = ply.DarkRPVars.job
		NotifyAll(0, 5, rpname .. " is now AFK.")
		
		-- NPC code partially by _Undefined
		local npc = ents.Create("npc_citizen")
		npc:SetPos(ply:GetPos())
		npc:SetAngles(ply:GetAngles())
		npc:SetModel(ply:GetModel())
		npc:Spawn()
		npc:Activate()
		npc:SetNPCState(NPC_STATE_ALERT)
		npc:IdleSound()
		npc:CapabilitiesAdd(CAP_USE | CAP_OPEN_DOORS)
		for _,v in pairs(ents.FindByClass("prop_physics")) do npc:AddEntityRelationship(v, D_LI, 99) end
		for _,v in pairs(player.GetAll()) do if v == ply then npc:AddEntityRelationship(v, D_FR, 99) npc:SetEnemy(v) end end
		ply.AFKNpc = npc
		npc.Owner = ply
		npc.AFKPly = ply
		if ValidEntity(ply:GetActiveWeapon()) then npc:Give(ply:GetActiveWeapon():GetClass()) end
		npc:SetHealth(ply:Health())
		npc:SetNoDraw(false)
		ply:SetNoDraw(true)
		ply:SetPos(Vector(0,0,-5000))
		hook.Add("PlayerDeath", ply:EntIndex().."DRPNPCDeath", function(ply)
			ply:SetEyeAngles(ply.AFKNpc:EyeAngles())
			ply.AFKNpc:Remove()
			hook.Remove("PlayerDeath", ply:EntIndex().."DRPNPCDeath")
		end)
		hook.Add("PlayerDisconnected", ply:EntIndex().."DRPNPCDisconnect", function(ply)
			ply.AFKNpc:Remove()
			hook.Remove("PlayerDisconnected", ply:EntIndex().."DRPNPCDisconnect")
		end)
	else
		NotifyAll(1, 5, rpname .. " is no longer AFK.")
		Notify(ply, 0, 5, "Welcome back, your salary has now been restored.")
		if ValidEntity(ply.AFKNpc) then
			ply:SetEyeAngles(ply.AFKNpc:EyeAngles())
			ply:SetPos(ply.AFKNpc:GetPos() + ply.AFKNpc:GetAimVector() * 10)
			ply.AFKNpc:Remove()
		end
		ply:SetNoDraw(false)

		hook.Remove("PlayerDisconnected", ply:EntIndex().."DRPNPCDisconnect")
		hook.Remove("PlayerDeath", ply:EntIndex().."DRPNPCDeath")
	end
	ply:SetDarkRPVar("job", ply.DarkRPVars.AFK and "AFK" or ply.OldJob)
	DB.StoreSalary(ply, ply.DarkRPVars.AFK and 0 or ply.OldSalary or 0)
end

local function StartAFKOnPlayer(ply)
	local demotetime
	if GetConVarNumber("afkdemote") == 0 then
		demotetime = math.huge
	else
		demotetime = GetConVarNumber("afkdemotetime")
	end
	ply.AFKDemote = CurTime() + demotetime
end
hook.Add("PlayerInitialSpawn", "StartAFKOnPlayer", StartAFKOnPlayer)

local function ToggleAFK(ply)
	if GetConVarNumber("afkdemote") == 0 then
		Notify( ply, 1, 5, "AFK mode is disabled.")
		return ""
	end
	
	SetAFK(ply)
	return ""
end
AddChatCommand("/afk", ToggleAFK)

local function AFKTimer(ply, key)
	if GetConVarNumber("afkdemote") == 0 then return end
	ply.AFKDemote = CurTime() + GetConVarNumber("afkdemotetime")
	if ply.DarkRPVars.AFKDemoted then
		ply:SetDarkRPVar("job", "Citizen")
		timer.Simple(3, function() ply:SetDarkRPVar("AFKDemoted", false) end)
	end
end
hook.Add("KeyPress", "DarkRPKeyReleasedCheck", AFKTimer)

local function KillAFKTimer()
	for id, ply in pairs(player.GetAll()) do 
		if ply.AFKDemote and CurTime() > ply.AFKDemote and not ply.DarkRPVars.AFK then
			SetAFK(ply)
			AFKDemote(ply)
			ply.AFKDemote = math.huge
		end
	end
end
hook.Add("Think", "DarkRPKeyPressedCheck", KillAFKTimer)

local function DamagePlayer(target, inflictor, attacker, damage, DmgInfo)
	if target:IsNPC() and ValidEntity(target.AFKPly) then
		target.AFKPly:TakeDamageInfo(DmgInfo)
	end
end
hook.Add("EntityTakeDamage", "AFKDamage", DamagePlayer)
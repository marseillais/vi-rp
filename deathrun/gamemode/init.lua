
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include('shared.lua')
include('bhop.lua')

resource.AddFile("sound/music/your_team_lost.mp3")
resource.AddFile("sound/music/your_team_win.mp3")

function GM:CanStartRound()
	if (#team.GetPlayers(TEAM_RUN) + #team.GetPlayers(TEAM_KILLER) >= 2) then return true end
	return false
end

function GM:OnPreRoundStart(num)
	game.CleanUpMap()
	
	/* Fixes */
	for id, ent in pairs(ents.FindByClass("weapon_*")) do
		local phys = ent:GetPhysicsObject()
    
		if (phys and phys:IsValid()) then
			phys:Sleep()
		end
	end
	
	for id, ent in pairs(ents.FindByName("Ansa_01_Este")) do
		ent:SetKeyValue("spawnflags", 1)
	end

	//ent:Fire("addoutput", "OnStartTouch speedmod,ModifySpeed,1", 0.1) 
	/*Fixes*/

	local OldRun = team.GetPlayers(TEAM_RUN)
	local OldDeath = team.GetPlayers(TEAM_KILLER)
	local NrActivePlayers = #OldRun + #OldDeath

	if (NrActivePlayers >= 2) then
		local NrDeath = math.ceil(NrActivePlayers / 10)

		for _, pl in pairs(OldDeath) do
			pl:SetTeam(TEAM_RUN)
		end

		local count=0

		for _, pl in RandomPairs(OldRun) do
			if (count < NrDeath) then
				pl:SetTeam(TEAM_KILLER)
				count=count + 1
			end
		end

		for _, pl in RandomPairs(OldDeath) do
			if count < NrDeath then
				pl:SetTeam(TEAM_KILLER)
				count = count + 1
			end
		end

	end

	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
end

function GM:ProcessResultText(result, resulttext)
	if (resulttext == nil) then resulttext = "" end

	if (result == TEAM_RUN) then
		resulttext = "The Runners Win!"
	elseif (result == TEAM_KILLER) then
		resulttext = "Killers Win!"
	end

	return resulttext
end

function GM:OnRoundResult(result, resulttext)
	self.BaseClass:OnRoundResult(result, resulttext)

	for id, ply in pairs(player.GetAll()) do
		if (ply:Team() == result) then
			umsg.Start("Win", ply)
			umsg.End()
		else
			umsg.Start("Fail", ply)
			umsg.End()
		end
	end
end

function GM:PlayerUse(pl, ent)
	if (pl:Alive() and (pl:Team() == TEAM_KILLER or pl:Team() == TEAM_RUN))then
		return true
	else
		return false
	end
end

function GM:GetFallDamage(ply, flFallSpeed)
	if (GAMEMODE.RealisticFallDamage) then
		return flFallSpeed / 9
	end

	return 10
end

function GM:PlayerDeathSound()
	return true
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	if (ply:Team() == TEAM_RUN) then
		ply:EmitSound(DrunDieSounds[math.random(1, #DrunDieSounds)])
	elseif (ply:Team() == TEAM_KILLER) then
		ply:EmitSound(DrunDieSounds[math.random(1, #DrunDieSounds)], 90, 80)
	end

	self.BaseClass:DoPlayerDeath(ply, attacker, dmginfo)
end

local LastSawDie_Run = 0
local LastSawDie_Death = 0

function GM:PlayerDeath(ply, inflictor, attacker)
	self.BaseClass:PlayerDeath(ply, inflictor, attacker)

	for _, ent in RandomPairs(ents.FindInSphere(ply:GetPos(), 750)) do
		if (ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == ply:Team() and ent != ply) then
			if (ent:Team() == TEAM_RUN) then
				if (LastSawDie_Run + 5 <= CurTime()) then
					ent:EmitSound( DrunSawDieSounds[math.random(1, #DrunSawDieSounds)])
					LastSawDie_Run = CurTime()
				end
			elseif (ent:Team() == TEAM_KILLER) then
				if (LastSawDie_Death + 5 <= CurTime()) then
					ent:EmitSound(DrunSawDieSounds[math.random(1, #DrunSawDieSounds)], 90, 80)
					LastSawDie_Death = CurTime()
				end
			end
			break
		end
	end
end

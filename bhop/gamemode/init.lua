
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include('shared.lua')

MapEntities = {}

function GM:CanStartRound()
	if (#team.GetPlayers(TEAM_BHOP) > 0) then return true end
	return false
end

function GM:PlayerSpray(ply)
	return ply:Team() == TEAM_BHOP
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if (ply:HasWeapon(wep:GetClass())) then return false end
	return true
end

function GM:OnPreRoundStart(num)
	game.CleanUpMap()

	/* Fixes */
	for i, e in pairs(ents.FindByClass("weapon_*")) do
		table.insert(MapEntities, e)
	end
	/* Fixes */

	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
end

function GM:ProcessResultText(result, resulttext)
	if (resulttext == nil) then resulttext = "" end

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
	if (pl:Alive() and (pl:Team() == TEAM_T or pl:Team() == TEAM_CT))then
		return true
	else
		return false
	end
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerCanJoinTeam(ply, teamid)
	if (SERVER && !self.BaseClass:PlayerCanJoinTeam(ply, teamid)) then 
		return false 
	end

	if (GAMEMODE:TeamHasEnoughPlayers(teamid)) then
		ply:ChatPrint("That team is full!")
		return false
	end
	
	return true
end

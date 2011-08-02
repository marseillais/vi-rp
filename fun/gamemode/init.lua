
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include('shared.lua')
include('deathsounds.lua')
include('bhop.lua')

resource.AddFile("sound/music/your_team_lost.mp3")
resource.AddFile("sound/music/your_team_win.mp3")

MapEntities = {}

function GM:CanStartRound()
	if (#team.GetPlayers(TEAM_CT) > 0 and #team.GetPlayers(TEAM_T) > 0) then return true end
	return false
end

function GM:PlayerSpray(ply)
	return ply:Team() == TEAM_CT or ply:Team() == TEAM_T
end

function GM:PlayerCanPickupWeapon(ply, wep)
	print(ply, wep, wep.Slot)
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

	if (result == TEAM_CT) then
		resulttext = "Counter-Terrorists have won!"
	elseif (result == TEAM_T) then
		resulttext = "Terrorist have won!"
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

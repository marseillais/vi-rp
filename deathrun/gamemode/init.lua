
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include('shared.lua')
include('deathsounds.lua')
include('bhop.lua')

resource.AddFile("sound/music/your_team_lost.mp3")
resource.AddFile("sound/music/your_team_win.mp3")

GM.MapFixes = {}
GM.MapFixes['deathrun_italy_rats_final'] = function()
	for id, ent in pairs(ents.FindByName("Ansa_01_Este")) do
		ent:SetKeyValue("spawnflags", 1)
	end
end

MapEntities = {}

function GM:CanStartRound()
	if (#team.GetPlayers(TEAM_RUN) + #team.GetPlayers(TEAM_KILLER) >= 2) then return true end
	return false
end

function GM:PlayerSpray(ply)
	return ply:Team() == TEAM_RUN or ply:Team() == TEAM_KILLER
end

function GM:OnPreRoundStart(num)
	game.CleanUpMap()

	/* Fixes */
	if (self.MapFixes[game.GetMap()]) then
		self.MapFixes[game.GetMap()]()
	end
	
	for i, e in pairs(ents.FindByClass("weapon_*")) do
		table.insert(MapEntities, e)
	end
	/* Fixes */

	local OldRun = team.GetPlayers(TEAM_RUN)
	local OldDeath = team.GetPlayers(TEAM_KILLER)
	local NrActivePlayers = #OldRun + #OldDeath

	if (NrActivePlayers >= 2) then
		local NrDeath = math.ceil(NrActivePlayers / 10)

		for _, pl in pairs(OldDeath) do
			pl:SetTeam(TEAM_RUN)
		end

		local count = 0

		for _, pl in RandomPairs(OldRun) do
			if (count < NrDeath) then
				pl:SetTeam(TEAM_KILLER)
				count = count + 1
			end
		end

		for _, pl in RandomPairs(OldDeath) do
			if (count < NrDeath) then
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
		resulttext = "Runners have won!"
	elseif (result == TEAM_KILLER) then
		resulttext = "Killers have won!"
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

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerCanJoinTeam(ply, teamid)
	if (ply:Team() == TEAM_KILLER) then return false end
	if (SERVER && !self.BaseClass:PlayerCanJoinTeam(ply, teamid)) then 
		return false 
	end

	if (GAMEMODE:TeamHasEnoughPlayers(teamid)) then
		ply:ChatPrint("That team is full!")
		return false
	end
	
	return true
end

function GM:CountVotesForChange() // Little haxxy bullshit :)
	if (CurTime() >= GetConVarNumber("fretta_votegraceperiod")) then
		if (GAMEMODE:InGamemodeVote()) then return end
		fraction = GAMEMODE:GetFractionOfPlayersThatWantChange()
		
		if (fraction > fretta_votesneeded:GetFloat()) then
			if(!GAMEMODE.m_bVotingStarted) then
				GAMEMODE:ClearPlayerWants()
				BroadcastLua("GAMEMODE:ShowGamemodeChooser()")
				SetGlobalBool("InGamemodeVote", true)
				SetGlobalFloat("VoteEndTime", CurTime() + fretta_votetime:GetFloat())
				GAMEMODE.m_bVotingStarted = true
			end
			GAMEMODE.WinningGamemode = GAMEMODE.FolderName
			GAMEMODE:FinishGamemodeVote()
			return false
		end
	end

	return true
end

hook.Add("Think", "Deathrun_fixes", function()
	for id, ent in pairs(MapEntities) do
		if (ent and ent != NULL and ent:IsValid()) then
			local phys = ent:GetPhysicsObject()
		
			if (phys and phys:IsValid()) then
				phys:Sleep()
			end
		else
			table.remove(MapEntities, id)
		end
	end

	//ent:Fire("addoutput", "OnStartTouch speedmod,ModifySpeed,1", 0.1) 
	//<output name> <target name>:<input name>:<parameter>:<delay>:<max times to fire (-1 == infinite)>
end)


DrunDieSounds = {
	"vo/npc/Barney/ba_ohshit03.wav",
	"vo/npc/Barney/ba_no01.wav",
	"vo/npc/Barney/ba_no02.wav",
	"vo/npc/male01/no01.wav",
	"vo/npc/male01/no02.wav"
}

DrunSawDieSounds = {
	"vo/npc/male01/gordead_ques01.wav",
	"vo/npc/male01/gordead_ques02.wav",
	"vo/npc/male01/gordead_ques06.wav",
	"vo/npc/male01/gordead_ques07.wav",
	"vo/npc/male01/gordead_ques11.wav",
	"vo/npc/Barney/ba_danger02.wav",
	"vo/npc/Barney/ba_damnit.wav"
}

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
resource.AddFile("sound/music/your_team_lost.mp3");
--resource.AddFile("sound/music/VLVX_song23.mp3");
include( 'shared.lua' )
print("INITED")
local file_path = "deathrun_weapon_spawns/"..game.GetMap()..".txt"
local file_contents = ""
local SpawnersPos = {}

if file.Exists(file_path) then
	file_contents = file.Read(file_path)
	for x, y, z in string.gmatch(file_contents, "(%-?[%d%.]+), (%-?[%d%.]+), (%-?[%d%.]+)\n") do
		table.insert(SpawnersPos, {x = tonumber(x), y = tonumber(y), z = tonumber(z)})
	end
end

function GM:CanStartRound()
	if #team.GetPlayers( TEAM_RUN ) + #team.GetPlayers( TEAM_KILLER ) >= 2 then return true end
	return false
end

function GM:OnPreRoundStart( num )
	game.CleanUpMap()
	local replacing = {}
	replacing = table.Add(replacing, ents.FindByClass("weapon_ak47"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_aug"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_awp"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_deagle"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_elite"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_glock"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_m3"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_m4a1"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_m249"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_mp5navy"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_p90"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_scout"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_sg552"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_usp"))
	replacing = table.Add(replacing, ents.FindByClass("weapon_xm1014"))

	for _,wep in ipairs(replacing) do
		if not SpawnersPos[1] then
			local spawner = ents.Create("weapon_spawner")
			spawner:SetPos(wep:GetPos())
			spawner:Spawn()
		end
		wep:Remove()
	end

	for _,pos in ipairs(SpawnersPos) do
		local spawner = ents.Create("weapon_spawner")
		spawner:SetPos(Vector(pos.x, pos.y, pos.z))
		spawner:Spawn()
	end


	local OldRun = team.GetPlayers( TEAM_RUN )
	local OldDeath = team.GetPlayers( TEAM_KILLER )
	local NrActivePlayers = #OldRun + #OldDeath

	if NrActivePlayers >= 2 then

		local NrDeath = math.ceil( NrActivePlayers/10 )

		for _,pl in pairs ( OldDeath ) do
			pl:SetTeam( TEAM_RUN )
		end

		local count=0

		for _, pl in RandomPairs( OldRun ) do
			if count < NrDeath then
				pl:SetTeam( TEAM_KILLER )
				count=count+1
			end
		end

		for _, pl in RandomPairs( OldDeath ) do
			if count < NrDeath then
				pl:SetTeam( TEAM_KILLER )
				count=count+1
			end
		end

	end

	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
end

function GM:ProcessResultText( result, resulttext )
	if ( resulttext == nil ) then resulttext = "" end

	if ( result == TEAM_RUN ) then
		resulttext = "The Runners Win!"
	elseif ( result == TEAM_KILLER ) then
		resulttext = "Killers Win!"
	end

	return resulttext
end

function GM:OnRoundResult( result, resulttext )
	self.BaseClass:OnRoundResult( result, resulttext )

	if result == TEAM_RUN then
		umsg.Start("Runners", ply)
		umsg.End()
	elseif result == TEAM_KILLER then
		umsg.Start("Killers", ply)
		umsg.End()
	end
end

function GM:PlayerUse( pl, ent )
	if pl:Alive() and ( pl:Team() == TEAM_KILLER or pl:Team() == TEAM_RUN )then
		return true
	else
		return false
	end
end

function GM:GetFallDamage( ply, flFallSpeed )
	if ( GAMEMODE.RealisticFallDamage ) then
		return flFallSpeed / 9
	end

	return 10
end

function GM:PlayerDeathSound()
	return true
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	if ply:Team() == TEAM_RUN then
		ply:EmitSound( DrunDieSounds[math.random(1, #DrunDieSounds)] )
	elseif ply:Team() == TEAM_KILLER then
		ply:EmitSound( DrunDieSounds[math.random(1, #DrunDieSounds)], 90, 80 )
	end

	self.BaseClass:DoPlayerDeath( ply, attacker, dmginfo )
end

local LastSawDie_Run = 0
local LastSawDie_Death = 0

function GM:PlayerDeath( ply, inflictor, attacker )
	self.BaseClass:PlayerDeath( ply, inflictor, attacker )

	local nearby_ents = ents.FindInSphere( ply:GetPos(), 750 )

	if ply:Team() == TEAM_RUN then
		for k,v in pairs(player:GetAll()) do
			if v:Team() == TEAM_KILLER then
				v:SetNWInt("Profit",v:GetNetworkedInt("Profit")+5)
			end
		end
	else
		attacker:SetNWInt("Profit",attacker:GetNetworkedInt("Profit")+50)
	end

	for _,ent in RandomPairs(nearby_ents) do
		if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == ply:Team() and ent!=ply then
			if ent:Team() == TEAM_RUN then
				if LastSawDie_Run + 5 <= CurTime() then
					ent:EmitSound( DrunSawDieSounds[math.random(1, #DrunSawDieSounds)] )
					LastSawDie_Run = CurTime()
				end
			elseif ent:Team() == TEAM_KILLER then
				if LastSawDie_Death + 5 <= CurTime() then
					ent:EmitSound( DrunSawDieSounds[math.random(1, #DrunSawDieSounds)], 90, 80 )
					LastSawDie_Death = CurTime()
				end
			end
			break
		end
	end
end

concommand.Add("deathrun_weapon_spawner", function(ply)
	if not ply:IsValid() then return end
	if not ply:IsSuperAdmin() then return end
	local pos = ply:GetEyeTrace().HitPos

	local spawner = ents.Create("weapon_spawner")
	spawner:SetPos(pos)
	spawner:Spawn()

	table.insert(SpawnersPos, {x = pos.x, y = pos.y, z = pos.z})
	file_contents = file_contents..pos.x..", "..pos.y..", "..pos.z.."\n"
	file.Write(file_path, file_contents)
end)

GM.Name = "Deathrun"
GM.Author = "Robotboy655"//fuckyou>"Gred, FeliX , Robo"
GM.Email = ""
GM.Website = ""
GM.Help = "As killer, you need to defeat all of the runners. As runner, you need to finish the map and kill killers."

DeriveGamemode("fretta")
IncludePlayerClasses()

GM.GameLength = 60
GM.RoundLimit = 1337

GM.TeamBased = true
GM.ForceJoinBalancedTeams = false

GM.RoundBased = true
GM.RoundLength = 300
GM.RoundPreStartTime = 3
GM.RoundPostLength = 8
GM.RoundEndsWhenOneTeamAlive = true
GM.NoPlayerSuicide = true

GM.RealisticFallDamage = true
GM.NoAutomaticSpawning = true
GM.DeathLingerTime = 2

GM.AllowSpectating = true
GM.CanOnlySpectateOwnTeam = false
GM.ValidSpectatorModes = {OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING}

TEAM_RUN = 1
TEAM_KILLER = 2

function GM:CreateTeams()
	if (!GAMEMODE.TeamBased) then return end

	team.SetUp(TEAM_RUN, "Runners", Color(0, 64, 200), true)
	team.SetSpawnPoint(TEAM_RUN, "info_player_counterterrorist")
	team.SetClass(TEAM_RUN, {"Runner"})

	team.SetUp(TEAM_KILLER, "Killers", Color(255, 64, 32), false)
	team.SetSpawnPoint(TEAM_KILLER, "info_player_terrorist")
	team.SetClass(TEAM_KILLER, {"Killer"})
end
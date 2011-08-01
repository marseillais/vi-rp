GM.Name = "Fun"
GM.Author = "Robotboy655"
GM.Email = ""
GM.Website = ""
GM.Help = "No description."

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

TEAM_CT = 1
TEAM_T = 2

function GM:CreateTeams()
	if (!GAMEMODE.TeamBased) then return end

	team.SetUp(TEAM_CT, "Counter-Terrorists", Color(0, 64, 200), true)
	team.SetSpawnPoint(TEAM_CT, "info_player_counterterrorist")
	team.SetClass(TEAM_CT, {"Counter-Terrorist"})

	team.SetUp(TEAM_T, "Terrorists", Color(200, 64, 32), true)
	team.SetSpawnPoint(TEAM_T, "info_player_terrorist")
	team.SetClass(TEAM_T, {"Terrorist"})
end

GM.Name = "Bhop"
GM.Author = "Robotboy655"
GM.Email = ""
GM.Website = ""
GM.Help = "Bhop to the top!"

DeriveGamemode("fretta")
IncludePlayerClasses()

GM.GameLength = 60
GM.RoundLimit = 1337

GM.TeamBased = true
GM.ForceJoinBalancedTeams = false

GM.RoundBased = false
GM.NoPlayerSuicide = true

GM.RealisticFallDamage = false
GM.NoAutomaticSpawning = false
GM.DeathLingerTime = 2

GM.AllowSpectating = true
GM.CanOnlySpectateOwnTeam = false
GM.ValidSpectatorModes = {OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING}

TEAM_BHOPPERS = 1

function GM:CreateTeams()
	if (!GAMEMODE.TeamBased) then return end

	/*team.SetUp(TEAM_CT, "Counter-Terrorists", Color(0, 64, 200), true)
	team.SetSpawnPoint(TEAM_CT, "info_player_counterterrorist")
	team.SetClass(TEAM_CT, {"Counter-Terrorist"})*/

	team.SetUp(TEAM_BHOP, "Bhoppers", Color(200, 200, 0), true)
	team.SetSpawnPoint(TEAM_BHOP, "info_player_counterterrorist")
	team.SetClass(TEAM_BHOP, {"Bhopper"})
end

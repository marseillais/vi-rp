GM.Name 	= "Deathrun"
GM.Author 	= "Gred, FeliX , Robo"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "As killer, you need to defeat all of the runners. As runner, you need to finish the map and kill kilers."
GM.GameLength = 3600
GM.RoundLimit = 1337

GM.TeamBased = true
GM.ForceJoinBalancedTeams = false

GM.RoundBased = true
GM.RoundLength = 60*5
GM.RoundPreStartTime = 5
GM.RoundPostLength = 15
GM.RoundEndsWhenOneTeamAlive = true
GM.NoPlayerSuicide = true

GM.RealisticFallDamage = true
GM.NoAutomaticSpawning = true
GM.DeathLingerTime = 2

GM.AllowSpectating = true
GM.CanOnlySpectateOwnTeam = false
GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }

DeriveGamemode( "fretta" )
IncludePlayerClasses()

TEAM_RUN = 1
TEAM_KILLER = 2

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end

	team.SetUp( TEAM_RUN, "Runners", Color( 20, 20, 200 ), true )
	team.SetSpawnPoint( TEAM_RUN, "info_player_counterterrorist" )
	team.SetClass( TEAM_RUN, { "Runner" } )

	team.SetUp( TEAM_KILLER, "Killers", Color( 200, 20, 20 ), false )
	team.SetSpawnPoint( TEAM_KILLER, "info_player_terrorist" )
	team.SetClass( TEAM_KILLER, { "Killer" } )

	team.SetUp( TEAM_GHOST, "Ghost", Color(0,0,255), false )
	team.SetSpawnPoint( TEAM_GHOST, "Ghost" )
	team.SetClass( TEAM_GHOST, { "Ghost" } )

end

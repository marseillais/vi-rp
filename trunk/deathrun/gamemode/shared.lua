GM.Name = "Deathrun"
GM.Author = "Robotboy655"//fuckyou>"Gred, FeliX , Robo"
GM.Email = ""
GM.Website = ""
GM.Help = "As killer, you need to defeat all of the runners. As runner, you need to finish the map and kill killers."

DeriveGamemode("fretta")
IncludePlayerClasses()

GM.GameLength = 3600
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

PainSounds = {}
DeathSounds = {}

PainSounds["models/player/alyx.mdl"] = {
"vo/npc/alyx/hurt04.wav",
"vo/npc/alyx/hurt05.wav",
"vo/npc/alyx/hurt06.wav",
"vo/npc/alyx/hurt08.wav",
"vo/npc/alyx/uggh01.wav",
"vo/npc/alyx/uggh02.wav",
"vo/npc/alyx/gasp03.wav"
}

PainSounds["models/player/barney.mdl"] = {
"vo/npc/Barney/ba_pain01.wav",
"vo/npc/Barney/ba_pain02.wav",
"vo/npc/Barney/ba_pain03.wav",
"vo/npc/Barney/ba_pain04.wav",
"vo/npc/Barney/ba_pain05.wav",
"vo/npc/Barney/ba_pain06.wav",
"vo/npc/Barney/ba_pain07.wav",
"vo/npc/Barney/ba_pain08.wav",
"vo/npc/Barney/ba_pain09.wav",
"vo/npc/Barney/ba_pain10.wav"
}

PainSounds["models/player/monk.mdl"] = {
"vo/ravenholm/monk_pain01.wav",
"vo/ravenholm/monk_pain02.wav",
"vo/ravenholm/monk_pain03.wav",
"vo/ravenholm/monk_pain04.wav",
"vo/ravenholm/monk_pain05.wav",
"vo/ravenholm/monk_pain06.wav",
"vo/ravenholm/monk_pain07.wav",
"vo/ravenholm/monk_pain08.wav",
"vo/ravenholm/monk_pain09.wav",
"vo/ravenholm/monk_pain10.wav",
"vo/ravenholm/monk_pain11.wav",
"vo/ravenholm/monk_pain12.wav"
}

PainSounds["models/player/police.mdl"] = {
"npc/metropolice/pain1.wav",
"npc/metropolice/pain2.wav",
"npc/metropolice/pain3.wav",
"npc/metropolice/pain4.wav"
}

PainSounds["models/player/classic.mdl"] = {
"npc/zombie/zombie_pain1.wav",
"npc/zombie/zombie_pain2.wav",
"npc/zombie/zombie_pain3.wav",
"npc/zombie/zombie_pain4.wav",
"npc/zombie/zombie_pain5.wav",
"npc/zombie/zombie_pain6.wav"
}
PainSounds["models/player/Zombiefast.mdl"] = PainSounds["models/player/classic.mdl"]

PainSounds["models/player/zombie_soldier.mdl"] = {
"npc/zombine/zombine_pain1.wav",
"npc/zombine/zombine_pain2.wav",
"npc/zombine/zombine_pain3.wav",
"npc/zombine/zombine_pain4.wav"
}

PainSounds["models/player/charple01.mdl"] = {
"npc/stalker/stalker_pain1.wav",
"npc/stalker/stalker_pain2.wav",
"npc/stalker/stalker_pain3.wav"
}
PainSounds["models/player/soldier_stripped.mdl"] = PainSounds["models/player/charple01.mdl"]

PainSounds["-- POISON ZOMBIE PLAYER MODEL HERE --"] = {
"npc/zombie_poison/pz_pain1.wav",
"npc/zombie_poison/pz_pain2.wav",
"npc/zombie_poison/pz_pain3.wav"
}

PainSounds["models/player/combine_soldier.mdl"] = {
"npc/combine_soldier/pain1.wav",
"npc/combine_soldier/pain2.wav",
"npc/combine_soldier/pain3.wav"
}
PainSounds["models/player/combine_soldier_prisonguard.mdl"] = PainSounds["models/player/combine_soldier.mdl"]
PainSounds["models/player/combine_super_soldier.mdl"] = PainSounds["models/player/combine_soldier.mdl"]



PainSounds["models/player/group01/female_01.mdl"] = {
"vo/npc/female01/ow01.wav",
"vo/npc/female01/ow02.wav",
"vo/npc/female01/pain01.wav",
"vo/npc/female01/pain02.wav",
"vo/npc/female01/pain03.wav",
"vo/npc/female01/pain04.wav",
"vo/npc/female01/pain05.wav",
"vo/npc/female01/pain06.wav",
"vo/npc/female01/pain07.wav",
"vo/npc/female01/pain08.wav",
"vo/npc/female01/pain09.wav"
}
PainSounds["models/player/group01/female_02.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group01/female_03.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group01/female_04.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group01/female_05.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group01/female_06.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group01/female_07.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group03/female_01.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group03/female_02.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group03/female_03.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group03/female_04.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group03/female_05.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group03/female_06.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/group03/female_07.mdl"] = PainSounds["models/player/group01/female_01.mdl"]
PainSounds["models/player/mossman.mdl"] = PainSounds["models/player/group01/female_01.mdl"]

PainSounds["models/player/group01/male_01.mdl"] = {
"vo/npc/male01/ow01.wav",
"vo/npc/male01/ow02.wav",
"vo/npc/male01/pain01.wav",
"vo/npc/male01/pain02.wav",
"vo/npc/male01/pain03.wav",
"vo/npc/male01/pain04.wav",
"vo/npc/male01/pain05.wav",
"vo/npc/male01/pain06.wav",
"vo/npc/male01/pain07.wav",
"vo/npc/male01/pain08.wav",
"vo/npc/male01/pain09.wav"
}

PainSounds["models/player/group01/male_02.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group01/male_03.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group01/male_04.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group01/male_05.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group01/male_06.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group01/male_07.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group01/male_08.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group01/male_09.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group03/male_01.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group03/male_02.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group03/male_03.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group03/male_04.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group03/male_05.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group03/male_06.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group03/male_07.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group03/male_08.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/group03/male_09.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/magnusson.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/kleiner.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/breen.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/odessa.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/gman_high.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/dod_american.mdl"] = PainSounds["models/player/group01/male_01.mdl"]
PainSounds["models/player/dod_german.mdl"] = PainSounds["models/player/group01/male_01.mdl"]

DeathSounds["models/player/police.mdl"] = {
"npc/metropolice/die1.wav",
"npc/metropolice/die2.wav",
"npc/metropolice/die3.wav",
"npc/metropolice/die4.wav"
}

DeathSounds["models/player/urban.mdl"] = {
"player\death1.wav",
"player\death2.wav",
"player\death3.wav",
"player\death4.wav",
"player\death5.wav",
"player\death6.wav"
}
DeathSounds["models/player/swat.mdl"] = DeathSounds["models/player/urban.mdl"]
DeathSounds["models/player/gasmask.mdl"] = DeathSounds["models/player/urban.mdl"]
DeathSounds["models/player/riot.mdl"] = DeathSounds["models/player/urban.mdl"]
DeathSounds["models/player/leet.mdl"] = DeathSounds["models/player/urban.mdl"]
DeathSounds["models/player/guerilla.mdl"] = DeathSounds["models/player/urban.mdl"]
DeathSounds["models/player/phoenix.mdl"] = DeathSounds["models/player/urban.mdl"]
DeathSounds["models/player/arctic.mdl"] = DeathSounds["models/player/urban.mdl"]
DeathSounds["models/player/hostage/hostage_01.mdl"] = DeathSounds["models/player/urban.mdl"]
DeathSounds["models/player/hostage/hostage_02.mdl"] = DeathSounds["models/player/urban.mdl"]
DeathSounds["models/player/hostage/hostage_03.mdl"] = DeathSounds["models/player/urban.mdl"]
DeathSounds["models/player/hostage/hostage_04.mdl"] = DeathSounds["models/player/urban.mdl"]

DeathSounds["models/player/zombie_soldier.mdl"] = {
"npc/zombine/zombine_die1.wav",
"npc/zombine/zombine_die2.wav"
}

DeathSounds["models/player/classic.mdl"] = {
"npc/zombie/zombie_die1.wav",
"npc/zombie/zombie_die2.wav",
"npc/zombie/zombie_die3.wav"
}
DeathSounds["models/player/Zombiefast.mdl"] = DeathSounds["models/player/classic.mdl"]

DeathSounds["models/player/charple01.mdl"] = {
"npc/stalker/stalker_die1.wav",
"npc/stalker/stalker_die2.wav"
}
DeathSounds["models/player/soldier_stripped.mdl"] = DeathSounds["models/player/charple01.mdl"]

DeathSounds["-- POISON ZOMBIE PLAYER MODEL HERE --"] = {
"npc/zombie_poison/pz_die1.wav",
"npc/zombie_poison/pz_die2.wav"
}

DeathSounds["models/player/combine_soldier.mdl"] = {
"npc/combine_soldier/die1.wav",
"npc/combine_soldier/die2.wav",
"npc/combine_soldier/die3.wav"
}
DeathSounds["models/player/combine_soldier_prisonguard.mdl"] = DeathSounds["models/player/combine_soldier.mdl"]
DeathSounds["models/player/combine_super_soldier.mdl"] = DeathSounds["models/player/combine_soldier.mdl"]

function GM:CreateTeams()
	if (!GAMEMODE.TeamBased) then return end

	team.SetUp(TEAM_RUN, "Runners", Color(0, 64, 200), true)
	team.SetSpawnPoint(TEAM_RUN, "info_player_counterterrorist")
	team.SetClass(TEAM_RUN, {"Runner"})

	team.SetUp(TEAM_KILLER, "Killers", Color(255, 64, 32), false)
	team.SetSpawnPoint(TEAM_KILLER, "info_player_terrorist")
	team.SetClass(TEAM_KILLER, {"Killer"})
end

local CLASS = {}

CLASS.DisplayName = "Climber"
CLASS.WalkSpeed = 250
CLASS.RunSpeed = 250
CLASS.JumpPower = 176
CLASS.DrawTeamRing = true
CLASS.TeammateNoCollide = true
CLASS.AvoidPlayers = false
CLASS.DropWeaponOnDie = true

function CLASS:OnSpawn(pl)
	pl:SetBloodColor(BLOOD_COLOR_RED)
end

function CLASS:Loadout(pl)
	pl:Give("weapon_knife")
end

player_class.Register("Climber", CLASS)
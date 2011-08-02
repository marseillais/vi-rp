local CLASS = {}

CLASS.DisplayName = "Counter-Terrorist"
CLASS.WalkSpeed = 275
CLASS.RunSpeed = 275
CLASS.JumpPower = 200
CLASS.DrawTeamRing = false
CLASS.TeammateNoCollide = false
CLASS.AvoidPlayers = false
CLASS.DropWeaponOnDie = true

function CLASS:OnSpawn(pl)
	pl:SetBloodColor(BLOOD_COLOR_RED)
end

function CLASS:Loadout(pl)
	pl:Give("weapon_knife")
end

player_class.Register("Counter-Terrorist", CLASS)
local CLASS = {}

CLASS.DisplayName = "Runner"
CLASS.WalkSpeed = 275
CLASS.RunSpeed = 275
CLASS.JumpPower = 200
CLASS.DrawTeamRing = true
CLASS.TeammateNoCollide = true
CLASS.AvoidPlayers = false
CLASS.DropWeaponOnDie = true

function CLASS:OnSpawn(pl)
	pl:SetBloodColor(BLOOD_COLOR_RED)
end

function CLASS:Loadout(pl)
	//pl:Give("weapon_knife")
end

player_class.Register("Runner", CLASS)
local CLASS = {}

CLASS.DisplayName			= "Killer"
CLASS.WalkSpeed 			= 275
CLASS.RunSpeed				= 500
CLASS.JumpPower				= 200
CLASS.DrawTeamRing			= true
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= false
CLASS.DropWeaponOnDie		= false

function CLASS:OnSpawn( pl )
	
	pl:SetBloodColor(BLOOD_COLOR_RED)

end

function CLASS:Loadout( pl )

	pl:Give( "weapon_knife" )

end

player_class.Register( "Killer", CLASS )
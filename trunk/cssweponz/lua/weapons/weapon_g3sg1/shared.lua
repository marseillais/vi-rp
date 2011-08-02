

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Knockback 			= 2
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "G3SG1"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 12
	SWEP.IconLetter			= "o"
	
	killicon.AddFont( "weapon_g3sg1", "CSKillIcons", SWEP.IconLetter, Color( 255, 0, 0, 255 ) )
	
end

SWEP.HoldType			= "ar2"

SWEP.Base				= "weapon_biohazard_sniperbase"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_g3sg1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "weapons/g3sg1/g3sg1-1.wav" )
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 2000
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.ShowCrosshair	= false
SWEP.Primary.Automatic		= true

SWEP.Zoomed = {}

SWEP.Zoomed.Sound			= Sound( "weapons/g3sg1/g3sg1-1.wav"  )
SWEP.Zoomed.Recoil			= 1.2
SWEP.Zoomed.Damage			= 40
SWEP.Zoomed.NumShots		= 1
SWEP.Zoomed.Cone			= 0.01
SWEP.Zoomed.Delay			= 0.3

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 6.1, -7, 2.5 )
SWEP.IronSightsAng 		= Vector( 2.8, 0, 0 )

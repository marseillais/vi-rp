

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Knockback 			= 2
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "AUG"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "e"
	
	killicon.AddFont( "weapon_aug", "CSKillIcons", SWEP.IconLetter, Color( 255, 0, 0, 255 ) )
	
end

SWEP.HoldType			= "ar2"

SWEP.Base				= "weapon_biohazard_sniperbase"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_aug.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_aug.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "weapons/aug/aug-1.wav" )
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.06
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.088
SWEP.Primary.DefaultClip	= 3000
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.ShowCrosshair	= true
SWEP.Primary.Automatic		= true

SWEP.Zoomed = {}

SWEP.Zoomed.Sound			= Sound( "weapons/aug/aug-1.wav" )
SWEP.Zoomed.Recoil			= 0.5
SWEP.Zoomed.Damage			= 25
SWEP.Zoomed.NumShots		= 1
SWEP.Zoomed.Cone			= 0.01
SWEP.Zoomed.Delay			= 0.13

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 6.1, -7, 2.5 )
SWEP.IronSightsAng 		= Vector( 2.8, 0, 0 )

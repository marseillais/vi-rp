

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Knockback 			= 2
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Galil"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "v"
	SWEP.ViewModelFlip		= false
	killicon.AddFont( "weapon_galil", "CSKillIcons", SWEP.IconLetter, Color( 255, 0, 0, 255 ) )
	
end

SWEP.HoldType			= "ar2"

SWEP.Base				= "weapon_biohazard_base"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_galil.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "weapons/galil/galil-1.wav" )
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= 35
SWEP.Primary.Delay			= 0.095
SWEP.Primary.DefaultClip	= 3500
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

-- SWEP.IronSightsPos 		= Vector( 6.1, -7, 2.5 )
-- SWEP.IronSightsAng 		= Vector( 2.8, 0, 0 )

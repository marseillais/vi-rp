

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Knockback 			= 2
	SWEP.ZoomFactor 		= 60
end

if ( CLIENT ) then

	SWEP.PrintName			= "Scout"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 17
	SWEP.IconLetter			= "n"
	
	killicon.AddFont( "weapon_scout", "CSKillIcons", SWEP.IconLetter, Color( 255, 0, 0, 255 ) )
	
end

SWEP.HoldType			= "ar2"


SWEP.Base				= "weapon_biohazard_sniperbase"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_SCOUT.Single" )
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.1
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay			= 1.5
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.ShowCrosshair	= false
SWEP.Primary.Automatic		= false

SWEP.Zoomed = {}

SWEP.Zoomed.Sound			= Sound( "Weapon_SCOUT.Single" )
SWEP.Zoomed.Recoil			= 1
SWEP.Zoomed.Damage			= 50
SWEP.Zoomed.NumShots		= 1
SWEP.Zoomed.Cone			= 0.005
SWEP.Zoomed.Delay			= 1.5

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 6.1, -7, 2.5 )
SWEP.IronSightsAng 		= Vector( 2.8, 0, 0 )

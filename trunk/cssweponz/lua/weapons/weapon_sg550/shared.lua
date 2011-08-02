

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Knockback 			= 2
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "SG550"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 18
	SWEP.IconLetter			= "o"
	
	killicon.AddFont( "weapon_sg550", "CSKillIcons", SWEP.IconLetter, Color( 255, 0, 0, 255 ) )
	
end
	
SWEP.HoldType			= "ar2"


SWEP.Base				= "weapon_biohazard_sniperbase"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_sg550.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_sg550.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "weapons/sg550/sg550-1.wav" )
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.15
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.ShowCrosshair	= false
SWEP.Primary.Automatic		= true

SWEP.Zoomed = {}

SWEP.Zoomed.Sound			= Sound( "weapons/sg550/sg550-1.wav"  )
SWEP.Zoomed.Recoil			= 1.2
SWEP.Zoomed.Damage			= 40
SWEP.Zoomed.NumShots		= 1
SWEP.Zoomed.Cone			= 0.01
SWEP.Zoomed.Delay			= 0.3

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 6.1, -7, 2.5 )
SWEP.IronSightsAng 		= Vector( 2.8, 0, 0 )

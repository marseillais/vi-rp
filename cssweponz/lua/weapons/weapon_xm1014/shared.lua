local SWEP = {}
	SWEP.Primary = {}
	SWEP.Secondary = {}
	SWEP.Reload = {}
	weapons.Register(SWEP, "weapon_xm1014")

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "XM1014"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "k"
	
	killicon.AddFont( "weapon_xm1014", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_cs_base"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_xm1014.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_xm1014.Single" )
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.1
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.20
SWEP.Primary.DefaultClip	= 800
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector( 5.14, -5, 2.14 )
SWEP.IronSightsAng = Vector(0, 0.8, 0)


/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	
	//if ( CLIENT ) then return end
	
	self:SetIronsights( false )
	
	// Already reloading
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
	// Start reloading if we can
	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Owner:DoReloadEvent()
	end

end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()


	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then
	
		if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then
			
			// Finsished reload -
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNetworkedBool( "reloading", false )
				return
			end
			
			// Next cycle
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			self.Owner:DoReloadEvent()
			
			// Add ammo
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			
			// Finish filling, final pump
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				self.Owner:DoReloadEvent()
			else
			
			end
			
		end
	
	end

end


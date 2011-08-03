
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	SWEP.Knockback			= 1
	SWEP.ZoomFactor 		= 30
end

if ( CLIENT ) then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true
	SWEP.BounceWeaponIcon	= false
	// This is the font that's used to draw the death icons
	surface.CreateFont( "csd", ScreenScale( 30 ), 500, true, true, "CSKillIcons" )
	surface.CreateFont( "csd", ScreenScale( 60 ), 500, true, true, "CSSelectIcons" )

end

SWEP.Author			= "Counter-Strike"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

// Note: This is how it should have worked. The base weapon would set the category
// then all of the children would have inherited that.
// But a lot of SWEPS have based themselves on this base (probably not on purpose)
// So the category name is now defined in all of the child SWEPS.
//SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Primary.ShowCrosshair	= false

SWEP.Zoomed = {}

SWEP.Zoomed.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Zoomed.Recoil			= 1.5
SWEP.Zoomed.Damage			= 40
SWEP.Zoomed.NumShots		= 1
SWEP.Zoomed.Cone			= 0
SWEP.Zoomed.Delay			= 0.15


SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"




/*---------------------------------------------------------
---------------------------------------------------------*/
function SWEP:Initialize()

	if ( SERVER ) then
		
		self:SetNPCMinBurst( 30 )
		self:SetNPCMaxBurst( 30 )
		self:SetNPCFireRate( 0.01 )
	end
	self:SetWeaponHoldType( self.HoldType )
	self.Weapon:SetNetworkedBool( "Zoom", false )
	
end


/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	self:SetZoom( false )
end


/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()	
end

function SWEP:Deploy()
	if CLIENT then return end
	self.OriginalFOV = self.Owner:GetFOV()
end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if self.Weapon:GetNetworkedBool( "Zoom", false ) then
		local recoil = self.Zoomed.Recoil
		if self.Owner:KeyDown(IN_DUCK) then recoil = recoil * 0.5 end
		local cone = self.Zoomed.Cone
		cone = cone * math.Clamp(self.Owner:GetVelocity():Length() / 150, 1, 5)
	
		//self.Weapon:SetNextSecondaryFire( CurTime() + self.Zoomed.Delay )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Zoomed.Delay )
	
		if ( !self:CanPrimaryAttack() ) then return end
	
		// Play shoot sound
		self.Weapon:EmitSound( self.Zoomed.Sound )
	
		// Shoot the bullet
		self:CSShootBullet( self.Zoomed.Damage, recoil, self.Zoomed.NumShots, cone )
	
		// Remove 1 bullet from our clip
		self:TakePrimaryAmmo( 1 )
	
		if ( self.Owner:IsNPC() ) then return end
	
		// Punch the player's view
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * recoil, math.Rand(-0.1,0.1) * recoil, 0 ) )
	
		// In singleplayer this function doesn't get called on the client, so we use a networked float
		// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
		// send the float.
		if ( (SinglePlayer() && SERVER) || CLIENT ) then
			self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
		end
	else
		local recoil = self.Primary.Recoil
		if self.Owner:KeyDown(IN_DUCK) then recoil = recoil * 0.5 end
		local cone = self.Primary.Cone
		cone = cone * math.Clamp(self.Owner:GetVelocity():Length() / 150, 1, 5)
	
		//self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
		if ( !self:CanPrimaryAttack() ) then return end
	
		// Play shoot sound
		self.Weapon:EmitSound( self.Primary.Sound )
	
		// Shoot the bullet
		self:CSShootBullet( self.Primary.Damage, recoil, self.Primary.NumShots, cone )
	
		// Remove 1 bullet from our clip
		self:TakePrimaryAmmo( 1 )
	
		if ( self.Owner:IsNPC() ) then return end
	
		// Punch the player's view
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * recoil, math.Rand(-0.1,0.1) * recoil, 0 ) )
	
		// In singleplayer this function doesn't get called on the client, so we use a networked float
		// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
		// send the float.
		if ( (SinglePlayer() && SERVER) || CLIENT ) then
			self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:CSShootBullet( dmg, recoil, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( cone, cone, 0 )			// Aim Cone
	bullet.Tracer	= 1									// Show a tracer on every x bullets 
	bullet.Force	= 5									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	self.Owner.lbd = dmg
	
	if bullet.Num == 1 then
		bullet.Callback = function(a,b,c) PenetrateCallback(1,a,b,c) end
	end
	
	self.Owner:FireBullets( bullet )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	if ( self.Owner:IsNPC() ) then return end
	
	// CUSTOM RECOIL !
	if ( (SinglePlayer() && SERVER) || ( !SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end

end


/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	// try to fool them into thinking they're playing a Tony Hawks game
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-14, 14), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-9, 9), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	
end

local IRONSIGHT_TIME = 0.25

/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )
	if ( !self.IronSightsPos ) then return pos, ang end
end


/*---------------------------------------------------------
	SetIronsights
---------------------------------------------------------*/
function SWEP:SetZoom( b )
	if CLIENT then return end
	self.Weapon:SetNetworkedBool( "Zoom", b )
	if b == true then
		self.Owner:SetFOV(self.OriginalFOV - self.ZoomFactor , 0.2)
	else
		self.Owner:SetFOV(self.OriginalFOV, 0.2)
	end
end

hook.Add("AdjustMouseSensitivity", "MyAdjustHook", function(default_sensitivity)
	if (!LocalPlayer():GetActiveWeapon() and !LocalPlayer():GetActiveWeapon():GetNetworkedBool("Zoom", false)) then return -1 end
    return LocalPlayer():GetActiveWeapon().OriginalFOV / LocalPlayer():GetActiveWeapon().ZoomFactor
end)


SWEP.NextSecondaryAttack = 0
/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	//print("SecAttax")
	self:SetNextSecondaryFire(CurTime()+0.5)
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	bZoom = !self.Weapon:GetNetworkedBool( "Zoom", false )
	
	self:SetZoom( bZoom )
	
	self.NextSecondaryAttack = CurTime() + 0.3
	
end

/*---------------------------------------------------------
	DrawHUD
	
	Just a rough mock up showing how to draw your own crosshair.
	
---------------------------------------------------------*/
function SWEP:DrawHUD()
	local x = ScrW() / 2.0
	local y = ScrH() / 2.0
	// No crosshair when ironsights is on
	if ( self.Weapon:GetNetworkedBool( "Zoom" ) ) then
		surface.SetDrawColor( 255, 0, 0, 255 )
		surface.DrawLine(x - ScrW() / 5, y, x + ScrW() / 5, y)
		surface.DrawLine(x, y - ScrW() / 5, x, y + ScrW() / 5)
	else
	if self.Primary.ShowCrosshair == false then return end
	//Scale according to speed
	local scale = 10 * self.Primary.Cone * (math.Clamp(self.Owner:GetVelocity():Length() / 150, 1, 5))
	//And to crouch
	if self.Owner:KeyDown(IN_DUCK) then scale = scale * 0.5 end
	
	// Scale the size of the crosshair according to how long ago we fired our weapon
	local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
	scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
	
	surface.SetDrawColor( 255, 0, 0, 255 )
	
	// Draw an awesome crosshair
	local gap = 40 * scale
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
	surface.DrawLine( x-2, y, x+2, y )
	surface.DrawLine( x, y-2, x, y+2 )
	end
end

/*---------------------------------------------------------
	onRestore
	Loaded a saved game (or changelevel)
---------------------------------------------------------*/
function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetZoom( false )
	
end

if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
	util.PrecacheSound("weapons/knife/knife_hit1.wav")
	util.PrecacheSound("weapons/knife/knife_hit2.wav")
	util.PrecacheSound("weapons/knife/knife_hit3.wav")
	util.PrecacheSound("weapons/knife/knife_hit4.wav")
	
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false
	local ActIndex = {}
		ActIndex[ "knife" ]		= ACT_HL2MP_IDLE_KNIFE

	function SWEP:SetWeaponHoldType( t )

		local index 								= ActIndex[ t ]
			
		if (index == nil) then
			return
		end

		self.ActivityTranslate 							= {}
		self.ActivityTranslate [ ACT_HL2MP_IDLE ] 			= index
		self.ActivityTranslate [ ACT_HL2MP_WALK ] 			= index + 1
		self.ActivityTranslate [ ACT_HL2MP_RUN ] 				= index + 2
		self.ActivityTranslate [ ACT_HL2MP_IDLE_CROUCH ] 		= index + 3
		self.ActivityTranslate [ ACT_HL2MP_WALK_CROUCH ] 		= index + 4
		self.ActivityTranslate [ ACT_HL2MP_GESTURE_RANGE_ATTACK ] 	= index + 5
		self.ActivityTranslate [ ACT_HL2MP_GESTURE_RELOAD ] 		= index + 6
		self.ActivityTranslate [ ACT_HL2MP_JUMP ] 			= index + 7
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 			= index + 8
	
		self:SetupWeaponHoldTypeForAI( t )
	end
end

if ( CLIENT ) then
	SWEP.PrintName			= "Knife"	
	SWEP.Author				= "kna_rus"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	SWEP.ViewModelFOV			= 65
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes		= false
	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "j"

	killicon.AddFont("weapon_knife", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))

	-- This is the font that's used to draw the death icons
	surface.CreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
	-- This is the font that's used to draw the select icons
	surface.CreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
end


SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.ViewModel 				= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel 				= "models/weapons/w_knife_t.mdl" 

SWEP.Weight					= 5
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.ClipSize			= -1
SWEP.Primary.Damage			= 0
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= "none"

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Damage			= 0
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			= "none"

SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("weapons/knife/knife_hitwall1.wav")
SWEP.DeploySound				= Sound("weapons/knife/knife_deploy1.wav")
SWEP.HoldType			= 	"knife"


/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
end

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize() 
 	self:SetWeaponHoldType( self.HoldType ) 
end 

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:EmitSound( self.DeploySound, 50, 100 )
	return true
end

function SWEP:SecondaryAttack()

	if SERVER then
		self.Owner:LagCompensation(true)
	end
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 50 )
	tr.filter = team.GetPlayers(self.Owner:Team())
	tr.mask = MASK_SOLID
	local mv = self.Owner:OBBMins()
	tr.mins = Vector(mv.x,mv.y,-1)
	local mv = self.Owner:OBBMaxs()
	tr.maxs = Vector(mv.x,mv.y,1)
	local trace = util.TraceHull( tr )
	if SERVER then
		self.Owner:LagCompensation(false)
	end

	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		if trace.Entity:IsPlayer() then
			util.Decal("Impact.Flesh", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
			self.Weapon:EmitSound( "weapons/knife/knife_hit" .. math.random(1, 4) .. ".wav" )
			if trace.Entity:Team() == self.Owner:Team() then return end
			if CLIENT then
				bullet = {}
				bullet.Num=1
				bullet.Src=self.Owner:GetShootPos()
				bullet.Dir=self.Owner:GetAimVector()
				bullet.Spread=Vector(0,0,0)
				bullet.Tracer=0
				bullet.Force=0
				self:FireBullets(bullet)
			end
			if SERVER then
				local hitgroup = trace.HitGroup
				if hitgroup == HITGROUP_HEAD then
					trace.Entity:TakeDamage(150, self.Owner, self.Weapon)
				else
					trace.Entity:TakeDamage(65, self.Owner, self.Weapon)
				end
			end
		else
			if IsValid(trace.Entity) then
				if SERVER then trace.Entity:TakeDamage(65, self.Owner, self.Weapon) end
				util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
			else
				util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
			end
		self.Weapon:EmitSound( self.WallSound )		
		end
	else
		self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if SERVER then
		self.Owner:LagCompensation(true)
	end
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 50 )
	tr.filter = team.GetPlayers(self.Owner:Team())
	tr.mask = MASK_SOLID
	local mv = self.Owner:OBBMins()
	tr.mins = Vector(mv.x,mv.y,-1)
	local mv = self.Owner:OBBMaxs()
	tr.maxs = Vector(mv.x,mv.y,1)
	local trace = util.TraceHull( tr )
	if SERVER then
		self.Owner:LagCompensation(false)
	end

	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		if trace.Entity:IsPlayer() then
			util.Decal("Impact.Flesh", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
			self.Weapon:EmitSound( "weapons/knife/knife_hit" .. math.random(1, 4) .. ".wav" )
			if trace.Entity:Team() == self.Owner:Team() then return end
			if CLIENT then
				bullet = {}
				bullet.Num=1
				bullet.Src=self.Owner:GetShootPos()
				bullet.Dir=self.Owner:GetAimVector()
				bullet.Spread=Vector(0,0,0)
				bullet.Tracer=0
				bullet.Force=0
				self:FireBullets(bullet)
			end
			if SERVER then
				local hitgroup = trace.HitGroup
				if hitgroup == HITGROUP_HEAD then
					trace.Entity:TakeDamage(75, self.Owner, self.Weapon)
				else
					trace.Entity:TakeDamage(35, self.Owner, self.Weapon)
				end
			end
		else
			if IsValid(trace.Entity) then
				if SERVER then trace.Entity:TakeDamage(35, self.Owner, self.Weapon) end
				util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
			else
				util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
			end
		self.Weapon:EmitSound( self.WallSound )		
		end
	else
		self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
end

function SWEP:DoImpactEffect(tr,dmgtype)
	if tr.HitWorld == true then return true end
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
end

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()
	return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()
	return true
end

/*---------------------------------------------------------
ShootEffects
---------------------------------------------------------*/
function SWEP:ShootEffects()

end

/*---------------------------------------------------------
GetViewModelPosition
---------------------------------------------------------*/
function SWEP:GetViewModelPosition(pos, ang)
	return pos, ang
end

/*---------------------------------------------------------
DrawWeaponSelection
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.IconLetter, "CSSelectIcons", x + wide / 2, y + tall * 0.2, Color(255, 210, 0, 255), TEXT_ALIGN_CENTER)
	-- Draw a CS:S select icon
end

function SWEP:DrawHUD()
	local x = ScrW() / 2.0
	local y = ScrH() / 2.0
	surface.SetDrawColor( 255, 0, 0, 255 )
	surface.DrawLine( x-30, y, x+30, y )
	--surface.DrawLine( x-15, y-15, x+15, y-15 )
	--surface.DrawLine( x-15, y-15, x-15, y+15 )
	--surface.DrawLine( x+15, y-15, x+15, y+15 )
end
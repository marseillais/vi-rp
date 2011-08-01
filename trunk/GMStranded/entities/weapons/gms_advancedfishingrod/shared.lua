if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if (CLIENT) then
	SWEP.PrintName = "Advanced Fishing Rod"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Slot = 3
	SWEP.SlotPos = 1
end

SWEP.Author = "Stranded Team"
SWEP.Contact = ""
SWEP.Purpose = "Used for fishing."
SWEP.Instructions = "Primary fire: Fish from the water."

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel = Model("models/Weapons/V_hands.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if (CLIENT) then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Owner:EmitSound(Sound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav"))

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + (self.Owner:GetAimVector() * 500)
	trace.mask = MASK_WATER | MASK_SOLID
	trace.filter = self.Owner 

	local tr = util.TraceLine(trace)

	if (!tr.Hit) then return end
	if (tr.MatType ~= MAT_SLOSH) then return end

	local data = {}
	data.Entity = tr.Entity
	data.Chance = 70
	self.Owner:DoProcess("AdvancedFishing", 6, data)
end

function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end

function SWEP:Holster()
	//if (self.Owner.InProcess) then return false end
    return true
end

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if (CLIENT) then
	SWEP.PrintName = "Hands"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Slot = 0
	SWEP.SlotPos = 1
end

SWEP.Author = "Stranded Team"
SWEP.Contact = ""
SWEP.Purpose = "Pick up stuff, as well as poor harvesting."
SWEP.Instructions = "Primary fire: Attack/Harvest"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel = "models/weapons/v_fists.mdl"
SWEP.WorldModel = "models/weapons/w_fists.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetWeaponHoldType("fist")
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
    if (CLIENT) then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound(Sound("weapons/iceaxe/iceaxe_swing1.wav"))

    local trace = {}
    trace.start = self.Owner:GetShootPos()
    trace.endpos = trace.start + (self.Owner:GetAimVector() * 100)
    trace.filter = self.Owner
    local tr = util.TraceLine(trace)

    if (!tr.HitNonWorld) then return end
    if (!tr.Entity) then return end
	
    if (tr.Entity:IsTreeModel()) then
        local data = {}
        data.Entity = tr.Entity
        data.Chance = 33
        data.MinAmount = 1
        data.MaxAmount = 3
		self.Owner:DoProcess("WoodCutting", 3, data)
    elseif (tr.Entity:IsRockModel()) then
        local data = {}
        data.Entity = tr.Entity
        data.Chance = 33
        data.MinAmount = 1
        data.MaxAmount = 2
		self.Owner:DoProcess("Mining", 3, data)
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster()
	//if (self.Owner.InProcess) then return false end
	return true
end
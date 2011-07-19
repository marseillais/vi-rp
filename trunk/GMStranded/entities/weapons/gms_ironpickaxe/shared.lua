if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if (CLIENT) then
	SWEP.PrintName = "Iron Pickaxe"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Slot = 3
	SWEP.SlotPos = 2
end

SWEP.Author = "Stranded Team"
SWEP.Contact = ""
SWEP.Purpose = "Effective mining tool."
SWEP.Instructions = "Primary fire: Mine from a rock or rocky surface."

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel = "models/weapons/v_iron_pickaxe.mdl"
SWEP.WorldModel = "models/weapons/w_iron_pickaxe.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetWeaponHoldType("melee")
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
    if (CLIENT) then return end
    self.Weapon:SetNextPrimaryFire(CurTime() + 1)
    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
    self.Owner:EmitSound(Sound("weapons/iceaxe/iceaxe_swing1.wav"))

    local trace = {}
    trace.start = self.Owner:GetShootPos()
    trace.endpos = trace.start + (self.Owner:GetAimVector() * 150)
    trace.filter = self.Owner

    local tr = util.TraceLine(trace)
    if (!tr.HitNonWorld) then return end
    if (!tr.Entity) then return end

    if (tr.Entity:IsRockModel() or tr.Entity:GetModel() == GMS.SmallRockModel) then
        local data = {}
        data.Entity = tr.Entity
		data.Chance = 70
        data.MinAmount = 3
        data.MaxAmount = 7
        self.Owner:DoProcess("Mining", 2, data)
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster()
	//if (self.Owner.InProcess) then return false end
	return true
end
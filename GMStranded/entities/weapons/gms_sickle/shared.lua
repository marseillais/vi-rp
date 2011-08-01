if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if (CLIENT) then
	SWEP.PrintName = "Sickle"
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
SWEP.Purpose = "Effectivizes harvesting processes."
SWEP.Instructions = "Harvest when active."

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel = Model("models/Weapons/V_hands.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

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

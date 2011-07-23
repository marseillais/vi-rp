if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if (CLIENT) then
	SWEP.PrintName = "Wooden Spoon"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Author = "Stranded Team"
SWEP.Contact = ""
SWEP.Purpose = "for eating fruit..."
SWEP.Instructions = "Eat Some Melonz."

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel = "models/Weapons/V_hands.mdl"
SWEP.WorldModel = "models/Weapons/w_bullet.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
end

function SWEP:Reload()
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end

function SWEP:Holster()
	//if (self.Owner.InProcess) then return false end
    return true
end
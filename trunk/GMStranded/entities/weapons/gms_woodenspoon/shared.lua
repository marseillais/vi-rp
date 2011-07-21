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
	SWEP.SlotPos = 4
end

SWEP.Author = "Stranded Team"
SWEP.Contact = ""
SWEP.Purpose = "for eating fruit..."
SWEP.Instructions = "Eat Some Melonz."

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

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
    timer.Simple(0.1, self.HideWeapon, self, false)
    return true
end

function SWEP:HideWeapon(bool)
	if (SERVER and self.Owner) then 
		self.Owner:DrawViewModel(bool) 
		self.Owner:DrawWorldModel(bool) 
	end
end

function SWEP:Holster()
    timer.Simple(0.1, self.HideWeapon, self, true)
	//if (self.Owner.InProcess) then return false end
    return true
end
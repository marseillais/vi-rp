AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Model = "models/weapons/w_annabelle.mdl"
ENT.Weapon = "weapon_crowbar"
ENT.AmmoType = "smg1"
ENT.Ammo = 135

function ENT:Initialize()
	self.Entity:SetModel( self.Model )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:SetAngles( Angle(0,0,0) )
	self.Entity:SetPos( self.Entity:GetPos() + Vector(0,0,10) ) --move a bit up to make sure it's not in the ground
end

function ENT:Think()
	for _,ply in pairs(ents.FindInSphere( self.Entity:GetPos(), self.Entity:BoundingRadius() )) do
		if ply:IsValid() and ply:IsPlayer() and ply:Alive() and ( ply:Team() == 2 or ply:Team() == TEAM_RUN ) then
			if not ply:HasWeapon("weapon_crowbar") and not ply:HasWeapon("weapon_scythe") then
				ply:Give("weapon_crowbar")
				ply:Give("weapon_tmp")
				ply:Give("weapon_ak47_snipah")
				ply:Give("weapon_fiveseven")
				ply:Give("weapon_spawn")
				ply:Give("weapon_smg1")
				ply:Give("weapon_stunstick")
				ply:Give("weapon_frag")
				ply:Give("weapon_sg550")
				ply:Give("weapon_357")
				ply:Give("weapon_annabelle") --does not do damage
				ply:Give("weapon_slam")
			end
			if not ply:HasWeapon(self.Weapon) then
				ply:Give(self.Weapon)
			end
			if ply:GetAmmoCount(self.AmmoType) < 45 then
				ply:GiveAmmo(self.Ammo,self.AmmoType)
			end
		end
	end
end

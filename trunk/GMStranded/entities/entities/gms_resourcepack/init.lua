AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:EndTouch(entEntity)
end

function ENT:Initialize()
    self.Entity:SetModel("models/items/item_item_crate.mdl")
 	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
 	self.Entity:SetColor(255, 255, 255, 255)
 	self.Entity.Resources = {}
end

function ENT:AcceptInput(input, ply)
end

function ENT:KeyValue(k, v)
end

function ENT:OnRestore()
end

function ENT:OnTakeDamage(dmiDamage)
end

function ENT:PhysicsSimulate(pobPhysics, numDeltaTime)
end

function ENT:StartTouch(entEntity)
	if (entEntity:GetClass() == "gms_resourcedrop") then
		big_gms_combineresourcepack(self, entEntity)
	end
	if (entEntity:GetClass() == "gms_buildsite") then 
		gms_addbuildsiteresourcePack(self, entEntity)
	end
end

function ENT:Think()
end

function ENT:Touch(entEntity)
end

function ENT:UpdateTransmitState(entEntity)
end
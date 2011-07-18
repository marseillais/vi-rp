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
 	self.Entity.Type = "Resource"
 	self.Entity.Amount = 0
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
	if (entEntity:GetClass() == "gms_resourcedrop" and entEntity.Type == self.Entity.Type) then
		big_gms_combineresource(self, entEntity)
	end
	if (entEntity:GetClass() == "gms_resourcepack") then big_gms_combineresourcepack(entEntity, self) end
	if (entEntity:GetClass() == "gms_buildsite" and (entEntity.Costs[self.Entity.Type] != nil and entEntity.Costs[self.Entity.Type] > 0)) then
		gms_addbuildsiteresource(self, entEntity)
	end
end

function ENT:Think()
end

function ENT:Touch(entEntity)
end

function ENT:UpdateTransmitState(entEntity)
end
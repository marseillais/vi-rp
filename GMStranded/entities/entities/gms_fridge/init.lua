AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:EndTouch(entEntity)
end

function ENT:Initialize()
    self.Entity:SetModel("models/props_c17/FurnitureFridge001a.mdl")
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

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg) -- React physically when getting shot/blown
end

function ENT:PhysicsSimulate(pobPhysics, numDeltaTime)
end

function ENT:StartTouch(entEntity)
	if (entEntity:GetClass() == "gms_food") then
		big_gms_combinefood(self, entEntity)
	end
end

function ENT:Think()
end

function ENT:Touch(entEntity)
end

function ENT:UpdateTransmitState(entEntity)
end
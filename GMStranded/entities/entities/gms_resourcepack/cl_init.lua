include("shared.lua")

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:Initialize()
	self.AddAngle = Angle(0, 0, 90)
end

function ENT:IsTranslucent()
end

function ENT:OnRestore()
end

function ENT:Think()
	self.AddAngle = self.AddAngle + Angle(0, 1.5, 0)
end
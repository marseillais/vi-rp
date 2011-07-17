include("shared.lua")

function ENT:Draw()
    self.Entity:DrawModel()
	self.Entity:SetColor(90, 167, 243, 255)
end

function ENT:Initialize()
end

function ENT:IsTranslucent()
end

function ENT:OnRestore()
end

function ENT:Think()
end
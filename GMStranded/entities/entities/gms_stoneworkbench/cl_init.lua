include("shared.lua")

function ENT:Draw()
    self.Entity:DrawModel()
end

function ENT:Initialize()
	self.Entity:SetColor(186, 186, 186, 255)
end

function ENT:IsTranslucent()
end

function ENT:OnRestore()
end

function ENT:Think()
end
include("shared.lua")

function ENT:Draw()
	if self.Entity:GetNWBool("Usable") == true then
		self:DrawEntityOutline( 1.0 )
	else
		self:DrawEntityOutline( 0.0 )
	end
	self.Entity:DrawModel()
end
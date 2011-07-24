ENT.Type 			= "anim"
ENT.PrintName		= "Smoke Grenade"
ENT.Author			= "-NEGI-"
ENT.Contact			= "gic12@rambler.ru"
ENT.Purpose			= ""
ENT.Instructions	= "DEVS DEVS DEVS"

function ENT:SetupDataTables()  
	self:DTVar("Boal", 0, "Explode")
end 

function ENT:OnRemove()
end

function ENT:PhysicsUpdate()
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("SmokeGrenade.Bounce"))
	end
	local impulse = -data.Speed * data.HitNormal * 0.4 + (data.OurOldVelocity * -0.6)
	phys:ApplyForceCenter(impulse)

	if not self.Collide then self.Collide = false end
	if self.Collide then return end

	timer.Simple(1, function()
		if not self.Entity then return end
		if not IsFirstTimePredicted() then return end

		self.Entity:EmitSound(Sound("BaseSmokeEffect.Sound"))
		self.Entity:Fire("kill", "", 5)

		self.Entity:SetDTBool(0, true)
	end)
	self.Entity.Collide = true
end

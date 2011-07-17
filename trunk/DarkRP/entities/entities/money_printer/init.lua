-- RRPX Money Printer reworked for DarkRP by philxyz
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self.sparking = false
	self.damage = 100
	self.IsMoneyPrinter = true
	timer.Simple(30, self.CreateMoneybag, self)
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = self.damage - dmg:GetDamage()
	if self.damage <= 0 then
		local rnd = math.random(1, 10)
		if rnd < 3 then
			self:BurstIntoFlames()
		else
			self:Destruct()
			self:Remove()
		end
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	Notify(self:GetNWEntity("owning_ent"), 1, 4, "Your money printer has exploded!")
end

function ENT:BurstIntoFlames()
	if self.Cooler and self.Cooler:GetNWInt("charges") > 0 then
		Notify(self:GetNWEntity("owning_ent"), 1, 4, "Your money printer's cooler has used up a charge.\nRemaining charges: "..self.Cooler:GetNWInt("charges"))
		self.Cooler:SetNWInt("charges", self.Cooler:GetNWInt("charges") - 1)
	else
		Notify(self:GetNWEntity("owning_ent"), 1, 4, "Your money printer is overheating!")
		self.burningup = true
		local burntime = math.random(8, 18)
		self:Ignite(burntime, 0)
		timer.Simple(burntime, self.Fireball, self)
	end
end

function ENT:Fireball()
	local dist = math.random(20, 280) -- Explosion radius
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
		if not v:IsPlayer() and not v.IsMoneyPrinter then v:Ignite(math.random(5, 22), 0) end
	end
	self:Remove()
end

local function PrintMore(ent)
	if ValidEntity(ent) then
		ent.sparking = true
		timer.Simple(3, ent.CreateMoneybag, ent)
	end
end

function ENT:CreateMoneybag()
	if not ValidEntity(self) then return end
	if self:IsOnFire() then return end
	local MoneyPos = self:GetPos()

	self:BurstIntoFlames()

	local amount = GetGlobalInt("mprintamount")
	if amount == 0 then
		amount = 250
	end

	if not self.Collector then
		DarkRPCreateMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15), amount)
	else
		self.Collector:SetNWInt("money", self.Collector:GetNWInt("money") + amount)
	end
	self.sparking = false
	timer.Simple(math.random(100, 350), PrintMore, self)
end

function ENT:Think()
	if not self.sparking then return end

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
end

function ENT:Touch( hitEnt )
	if hitEnt.IsCooler and not self.Cooler then
		self.Cooler = hitEnt
		self.OldAngles = self.Entity:GetAngles()
		self.Entity:SetAngles(Vector(0, 0, 0))

		hitEnt:SetPos(self.Entity:GetPos() + Vector(1.9534912109375, 9.9049682617188, 6.304988861084))
		hitEnt:SetAngles(self.Entity:GetAngles() + Vector(0, 90, 0))
		constraint.Weld(hitEnt, self.Entity, 0, 0, 0, true)

		self.Entity:SetAngles(self.OldAngles)

		local phys = hitEnt:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(1)
		end
	elseif hitEnt.IsCollector and not self.Collector then
		self.Collector = hitEnt
		self.OldAngles = self.Entity:GetAngles()
		self.Entity:SetAngles(Vector(0, 0, 0))

		hitEnt:SetPos(self.Entity:GetPos() + Vector(-4.62841796875, -6.8973388671875, 14.61595916748))
		hitEnt:SetAngles(self.Entity:GetAngles() + Vector(89.261619508266, 6.043903529644, -19.906075708568))
		constraint.Weld(hitEnt, self.Entity, 0, 0, 0, true)

		self.Entity:SetAngles(self.OldAngles)

		local phys = hitEnt:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(1)
		end
	end
end 
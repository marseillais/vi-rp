AddCSLuaFile("cl_init.lua")

AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

self.Entity:SetModel("models/nater/plant/weedplant_pot_dirt.mdl")

self.Entity:PhysicsInit(SOLID_VPHYSICS)

self.Entity:SetMoveType(MOVETYPE_VPHYSICS)

self.Entity:SetSolid(SOLID_VPHYSICS)

self.Entity:SetUseType(SIMPLE_USE)

local phys = self.Entity:GetPhysicsObject()

if phys and phys:IsValid() then phys:Wake() end

self.Entity:SetNWBool("Usable", false)

self.Entity:SetNWBool("Plantable", true)

self.damage = 100

local ply = self.Entity:GetNWEntity("owning_ent")

end

function ENT:CreateMoneybag()
	if not ValidEntity(self) then return end
	local MoneyPos = self:GetPos()
	
	if math.random(1, 10) = 5 then self:Infertile() end
	
	local amount = GetGlobalInt("mprintamount")
	if amount == 0 then
		amount = 350
	end

	DarkRPCreateMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15), amount)
	self.sparking = true
	timer.Simple(math.random(250, 300), self)
	
	self.Entity:SetNWBool("Plantable", true)
end

function ENT:Infertile()
	Notify(self:GetNWEntity("owning_ent"), 1, 4, "Your Weed Plant is Infertile")
	self.Entity:SetNWBool("Plantable", false)
	self:SetColor ( 51, 47, 47, 255)


end


function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("pickup", effectdata)
	Notify(self:GetNWEntity("owning_ent"), 1, 4, "Your Weed Plant has been destroyed")
		timer.Destroy("Stage2")

		timer.Destroy("Stage3")

		timer.Destroy("Stage4")

		timer.Destroy("Stage5")

		timer.Destroy("Stage6")

		timer.Destroy("Stage7")

		timer.Destroy("Stage8")
		
		timer.Destroy("Stage9")
end

function ENT:OnTakeDamage(dmg)

self.damage = self.damage - dmg:GetDamage()

	if (self.damage <= 0) then
	self:Destruct()
	self:Remove()

end

end

function ENT:Use()

if self.Entity:GetNWBool("Usable") == true then

self.Entity:SetNWBool("Usable", false)

self.Entity:SetNWBool("Plantable", true)

self.Entity:SetModel("models/nater/plant/weedplant_pot_dirt.mdl")

self:CreateMoneybag()

end

end

function ENT:Touch(hitEnt)

if hitEnt:GetClass() == "seed_weed" then

if self.Entity:GetNWBool("Plantable") == true then

self.Entity:SetNWBool("Plantable", false)

hitEnt:Remove()

self.Entity:SetModel("models/nater/plant/weedplant_pot_planted.mdl")

timer.Create("Stage2_"..self:EntIndex(), 34, 1, function()

self.Entity:SetModel("models/nater/plant/weedplant_pot_growing1.mdl")

end)

timer.Create("Stage3_"..self:EntIndex(), 68, 1, function()

self.Entity:SetModel("models/nater/plant/weedplant_pot_growing2.mdl")

end)

timer.Create("Stage4_"..self:EntIndex(), 102, 1, function()

self.Entity:SetModel("models/nater/plant/weedplant_pot_growing3.mdl")

end)

timer.Create("Stage5_"..self:EntIndex(), 136, 1, function()

self.Entity:SetModel("models/nater/plant/weedplant_pot_growing4.mdl")

end)

timer.Create("Stage6_"..self:EntIndex(), 170, 1, function()

self.Entity:SetModel("models/nater/plant/weedplant_pot_growing5.mdl")

end)

timer.Create("Stage7_"..self:EntIndex(), 204, 1, function()

self.Entity:SetModel("models/nater/plant/weedplant_pot_growing6.mdl")

end)

timer.Create("Stage8_"..self:EntIndex(), 240, 1, function()

self.Entity:SetModel("models/nater/plant/weedplant_pot_growing7.mdl")

end)

timer.Create("Stage9_"..self:EntIndex(), 260, 1, function()

self.Entity:SetModel("models/nater/plant/weedplant_pot_dirt.mdl")

self:CreateMoneybag()


end)

end

end

end

function ENT:OnRemove()

if self.Entity:GetNWBool("Plantable") == false then

timer.Destroy("Stage2")

timer.Destroy("Stage3")

timer.Destroy("Stage4")

timer.Destroy("Stage5")

timer.Destroy("Stage6")

timer.Destroy("Stage7")

timer.Destroy("Stage8")

timer.Destroy("Stage9")

end

end 
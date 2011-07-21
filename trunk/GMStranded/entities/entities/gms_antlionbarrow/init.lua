AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:EndTouch(entEntity)
end

function ENT:Initialize()
	self.Entity:SetModel("models/props_wasteland/antlionhill.mdl")

 	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
    self.Entity:SetSolid(SOLID_VPHYSICS)

 	self.Entity:SetColor(255, 255, 255, 255)
	self.Entity:SetNetworkedString("Owner", "World")
 	self.MaxAntlions = 5
 	self.Antlions = {}
 	self.Spawning = false

    local phys = self.Entity:GetPhysicsObject()
	if (phys and phys != NULL) then phys:EnableMotion(false) end
    self.Entity.StrandedProtected = true

 	timer.Create("CheckSurroundings_" .. self.Entity:EntIndex(), 2, 0, self.CheckSurroundings, self)
end

function ENT:SpawnAntlions()
    for i = 1, self.MaxAntlions do self:SpawnAntlion() end
end

function ENT:SpawnAntlion()
    local offset = Vector(math.random(-500, 500), math.random(-500, 500), 100)
    local retries = 50

    while ((!util.IsInWorld(offset) and retries > 0) or offset:Distance(self.Entity:GetPos()) < 200) do
        offset = Vector(math.random(-400, 400), math.random(-400, 400), 100)
        retries = retries - 1
    end

    local trace = {}
    trace.start = self.Entity:GetPos() + offset
    trace.endpos = trace.start + Vector(0, 0, -10000)
	trace.mask = MASK_SOLID
    trace.filter = self.Entity 
    local tr = util.TraceLine(trace)
	local ant = ents.Create("npc_antlion")
	ant:SetPos(tr.HitPos + Vector(0, 0, 5))
	ant:SetNWString("Owner", "World")
    ant:Spawn()
    ant:Fadein(2)
    table.insert(self.Antlions, ant)
end

function ENT:CheckSurroundings()
    local tbl = {}

    for k, v in pairs(self.Antlions) do
        if (!v or v == NULL or !v:IsValid()) then
            table.remove(self.Antlions, k)
        else
			local enemy = v:GetEnemy()
			if ((enemy and enemy:GetPos():Distance(self.Entity:GetPos()) > 1500) or v:GetPos():Distance(self.Entity:GetPos()) > 1500) then
                v:SetEnemy(nil)
                local pos = self.Entity:GetPos() + Vector(math.random(-500 ,500), math.random(-500, 500), 0)
                while (pos:Distance(self.Entity:GetPos()) < 200) do
                    pos = self.Entity:GetPos() + Vector(math.random(-500 ,500), math.random(-500, 500), 0)
                end
				v:SetLastPosition(pos)
				v:SetSchedule(71)
            end
        end
    end
	local max = self.MaxAntlions
	if (IsNight) then max = math.ceil(max * 1.4) end
	if (#self.Antlions < max and !self.Spawning) then
        timer.Create("gms_antlionspawntimers_" .. self.Entity:EntIndex(), math.random(20, 60), 1, self.AddAntlion, self)
        self.Spawning = true
    end
end

function ENT:AddAntlion()
    self:SpawnAntlion()
    self.Spawning = false
end

function ENT:AcceptInput(input, ply)
end

function ENT:KeyValue(k, v)
    if (k == "MaxAntlions") then
		local val = tonumber(v) or 5
        self[k] = val
		self.MaxAntlions = val
	end
end

function ENT:OnRestore()
end

function ENT:OnTakeDamage(dmiDamage)
end

function ENT:PhysicsSimulate(pobPhysics, numDeltaTime)
end

function ENT:StartTouch(entEntity)
end

function ENT:Think()
end

function ENT:Touch(entEntity)
end

function ENT:UpdateTransmitState(entEntity)
end

function ENT:OnRemove()
	for k, ant in pairs(self.Antlions) do
		if (!(!ant or ant == NULL or !ant:IsValid())) then
			ant:Remove()
		end
	end
	timer.Destroy("CheckSurroundings_" .. self.Entity:EntIndex())
end

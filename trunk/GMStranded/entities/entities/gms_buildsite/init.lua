AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:EndTouch(entEntity)
end

function ENT:Initialize()
	self.Entity:DropToFloor( )
	self.Entity:SetMoveType(MOVETYPE_NONE)
 	self.Entity:SetMaterial("models/wireframe")
 	self.Entity.StrandedProtected = true
 	self.LastUsed = CurTime()
end

function ENT:AddResource(ply, res, int)
    self.Costs[res] = self.Costs[res] - int
    if (self.Costs[res] <= 0) then
        self.Costs[res] = nil
    end
	
	local str = ":"
	for k, v in pairs(self.Costs) do
		str = str .. " " .. string.Replace(k, "_", " ") .. " (" .. v .. "x)"
	end
	self.Entity:SetNetworkedString('Resources', str)
end

function ENT:Setup(model, resclass)
    self.Entity:SetModel(model)
    self.ResultClass = resclass

	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	self.Entity:SetColor(255, 255, 255, 255)

 	local phys = self.Entity:GetPhysicsObject()
 	if (phys != NULL and phys) then phys:EnableMotion(false) end
end

function ENT:Finish()
    local ent = ents.Create(self.ResultClass)	 
	if (self.NormalProp == true) then ent.NormalProp = true end
    ent:SetPos(self.Entity:GetPos())
    ent:SetAngles(self.Entity:GetAngles())
    ent:SetModel(self.Entity:GetModel())
	ent.Player = self.Entity.Player
	ent:SetNetworkedString('Name', self.Entity.Name)
    ent:Spawn()
    SPropProtection.PlayerMakePropOwner(ent.Player, ent)
    ent:Fadein()
 
    self.Entity.Player.HasBuildingSite = false
	self.Entity:Remove()
end

function ENT:Use(ply)
    if (CurTime() - self.LastUsed < 0.5) then return end
	self.LastUsed = CurTime()
	if (!(SPropProtection.PlayerIsPropOwner(ply, self.Entity) or SPropProtection.IsBuddy(ply, self.Entity)) and !(tonumber(SPropProtection["Config"]["use"]) != 1)) then return end

    for k, v in pairs(self.Costs) do
        if (ply:GetResource(k) >= 0) then
            if (ply:GetResource(k) < v) then
                self:AddResource(ply, k, ply:GetResource(k))
                ply:DecResource(k, ply:GetResource(k))
            else
                self:AddResource(ply, k, v)
                ply:DecResource(k, v)
            end
        end
    end

    if (table.Count(self.Costs) > 0) then
        local str = "You need:"
        for k, v in pairs(self.Costs) do
            str = str .. " " .. string.Replace(k, "_", " ") .. " (" .. v .. "x)"
        end
        str = str .. " to finish."
        ply:SendMessage(str, 5, Color(255, 255, 255, 255))
    else
        ply:SendMessage("Finished!", 3, Color(10, 200, 10, 255))
		self:Finish()            
    end
end

function ENT:AcceptInput(input, ply)
end

function ENT:KeyValue(k,v)
end

function ENT:OnRestore()
end

function ENT:OnTakeDamage(dmiDamage)
end

function ENT:PhysicsSimulate(pobPhysics,numDeltaTime)
end

function ENT:StartTouch(entEntity)
end

function ENT:Think()
end

function ENT:Touch(entEntity)
end

function ENT:UpdateTransmitState(entEntity)
end
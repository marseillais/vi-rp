ENT.Type = "Anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Seed"
ENT.Author = "Stranded Team"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""

ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:OnRemove()
    if (SERVER) then timer.Destroy("GMS_SeedTimers_" .. self.Entity:EntIndex()) end
end

function ENT:PhysicsCollide(tblData)
end

function ENT:PhysicsUpdate(pobPhysics)
end
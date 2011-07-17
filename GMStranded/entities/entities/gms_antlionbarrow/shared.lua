ENT.Type = "Anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Antlion Barrow"
ENT.Author = "Stranded Team"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""

ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:OnRemove()
   timer.Destroy("gms_antlionspawntimers_" .. self.Entity:EntIndex())
end

function ENT:PhysicsCollide(tblData)
end

function ENT:PhysicsUpdate(pobPhysics)
end
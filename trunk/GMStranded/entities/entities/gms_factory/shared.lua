ENT.Type = "Anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Factory"
ENT.Author = "Stranded Team"
ENT.Contact = ""
ENT.Purpose = "This is a Factory that can produce all sorts of resources for less"
ENT.Instructions = ""

ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:OnRemove()
end

function ENT:PhysicsCollide(tblData)
end

function ENT:PhysicsUpdate(pobPhysics)
end
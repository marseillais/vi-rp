ENT.Type = "Anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Mail"
ENT.Author = "Stranded Team"
ENT.Contact = ""
ENT.Purpose = "Pick up to read."
ENT.Instructions = ""

ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:OnRemove()
end

function ENT:PhysicsCollide(tblData)
end

function ENT:PhysicsUpdate(pobPhysics)
end
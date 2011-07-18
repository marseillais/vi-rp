ENT.Type = "Anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Resource Pack"
ENT.Author = "Robotboy655"
ENT.Contact = ""
ENT.Purpose = "Pick up to gain resources."
ENT.Instructions = "Press use to pick up."

ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:OnRemove()
end

function ENT:PhysicsCollide(tblData)
end

function ENT:PhysicsUpdate(pobPhysics)
end
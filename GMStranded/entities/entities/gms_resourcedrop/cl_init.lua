include("shared.lua")

if (!GMS) then 
	local GMS = {} 
end

function ENT:Draw()
	self.Entity:DrawModel()
end


function GMS.SetEntityDropInfo(um)
    local index = um:ReadString()
    local type = um:ReadString()
    local int = um:ReadShort()
    local ent = ents.GetByIndex(index)
    if (ent == NULL or !ent) then
		local tbl = {}
        tbl.Type = type
        tbl.Amount = int
        tbl.Index = index
		table.insert(GMS.PendingRDrops, tbl)
    else
		ent.Res = type
		ent.Amount = int
    end
end
usermessage.Hook("gms_SetResourceDropInfo", GMS.SetEntityDropInfo)

GMS.PendingRDrops = {}
function GMS.CheckForRDrop()
    for k, tbl in pairs(GMS.PendingRDrops) do
    local ent = ents.GetByIndex(tbl.Index)
		if (ent != NULL) then
            ent.Res = tbl.Type
            ent.Amount = tbl.Amount
			table.remove(GMS.PendingRDrops, k)
        end
    end
end
hook.Add("Think", "gms_CheckForPendingRDrops", GMS.CheckForRDrop)

function ENT:Initialize()
	self.AddAngle = Angle(0, 0, 90)
end

function ENT:IsTranslucent()
end

function ENT:OnRestore()
end

function ENT:Think()
	self.AddAngle = self.AddAngle + Angle(0, 1.5, 0)
end
include("shared.lua")

if (!GMS) then 
	local GMS = {} 
end

function ENT:Draw()
	self.Entity:DrawModel()
end

GMS.PendingRPDrops = {}

usermessage.Hook("gms_SetResPackInfo", function(um)
    local index = um:ReadString()
    local type = um:ReadString()
    local int = um:ReadShort()
    local ent = ents.GetByIndex(index)
	
	if (int <= 0) then int = nil end

    if (ent == NULL or !ent) then
		local tbl = {}
        tbl.Type = type
        tbl.Amount = int
        tbl.Index = index
		table.insert(GMS.PendingRPDrops, tbl)
    else
		ent.Resources[type] = int
    end
end)

hook.Add("Think", "gms_CheckForPendingRDrops", function()
    for k, tbl in pairs(GMS.PendingRPDrops) do
    local ent = ents.GetByIndex(tbl.Index)
		if (ent != NULL) then
            ent.Resources[tbl.Type] = tbl.Amount
			table.remove(GMS.PendingRPDrops, k)
        end
    end
end)

function ENT:Initialize()
	self.Resources = {}
	self.AddAngle = Angle(0, 0, 90)
end

function ENT:IsTranslucent()
end

function ENT:OnRestore()
end

function ENT:Think()
	self.AddAngle = self.AddAngle + Angle(0, 1.5, 0)
end
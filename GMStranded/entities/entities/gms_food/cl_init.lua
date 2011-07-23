include("shared.lua")

local texLogo = surface.GetTextureID("vgui/modicon")

function ENT:Initialize()
    self.AddAngle = Angle(0, 0, 90)
    self.FoodIcons = {}
    for k, v in pairs(GMS.Combinations["Cooking"]) do
        if (v.Texture) then
			self.FoodIcons[k] = surface.GetTextureID(v.Texture)
        end
    end
end

function ENT:Draw()
    self.Entity:DrawModel()
    local food = self.Entity.Food or "Loading.."
    local tex = self.FoodIcons[string.gsub(food, " ", "_")] or texLogo
	
	cam.Start3D2D(self.Entity:GetPos() + Vector(0,0,20), self.AddAngle, 0.01)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetTexture(tex)
        surface.DrawTexturedRect(-500, -500, 1000, 1000)
    cam.End3D2D()

    cam.Start3D2D(self.Entity:GetPos() + Vector(0,0,20), self.AddAngle + Angle(0, 180, 0), 0.01)
        surface.SetDrawColor(255,255,255,255)
        surface.SetTexture(tex)
        surface.DrawTexturedRect(-500,-500,1000,1000)
    cam.End3D2D()

    cam.Start3D2D(self.Entity:GetPos() + Vector(0, 0, 25), self.AddAngle, 0.2)
        draw.SimpleText(food, "ScoreboardText", 0, 0, Color(255, 255, 255, 255), 1, 1)
    cam.End3D2D()

    cam.Start3D2D(self.Entity:GetPos() + Vector(0, 0, 25), self.AddAngle + Angle(0, 180, 0), 0.2)
        draw.SimpleText(food, "ScoreboardText", 0, 0, Color(255, 255, 255, 255), 1, 1)
    cam.End3D2D()
end

usermessage.Hook("gms_SetFoodDropInfo", function(um)
    local index = um:ReadString()
    local type = um:ReadString()

    local ent = ents.GetByIndex(index)
    if (ent == NULL or !ent) then
		local tbl = {}
        tbl.Type = type
        tbl.Index = index
		table.insert(GMS.PendingFoodDrops, tbl)
    else
		ent.Food = type
    end
end)

GMS.PendingFoodDrops = {}
hook.Add("Think", "gms_CheckForPendingFoodDrops", function()
    for k, tbl in pairs(GMS.PendingFoodDrops) do
    local ent = ents.GetByIndex(tbl.Index)
		if (ent != NULL) then
            ent.Food = tbl.Type
			table.remove(GMS.PendingFoodDrops, k)
        end
    end
end)

function ENT:IsTranslucent()
end

function ENT:OnRestore()
end

function ENT:Think()
    self.AddAngle = self.AddAngle + Angle(0, 1.5, 0)
end
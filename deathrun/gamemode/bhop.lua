local abs = math.abs
local cl = math.Clamp
local Str = {}
local Dlt = {}
local Time = CurTime()

for k, v in pairs(player:GetAll()) do
	Str[v:UserID()] = 0
	Dlt[v:UserID()] = 0
end

function clamp(vec, Min, Max)
	return Vector(cl(vec[1], Min[1], Max[1]), cl(vec[2], Min[2], Max[2]), cl(vec[3], Min[3], Max[3]))
end

function Bhop(ply, data)
	if (data:GetMaxSpeed() ~= 3500) then data:SetMaxSpeed(3500) end
	local SVel = data:GetSideSpeed()
	local Vel = ((data:GetMaxSpeed()) / abs(SVel))
	data:SetVelocity(data:GetVelocity() + clamp(data:GetVelocity() / 300, Vector(-1, -1, 0), Vector(1, 1, 0) * Vel)) // 175 def
	--data:SetVelocity(data:GetVelocity()+(ply:GetForward()*Dlt[ply:UserID()]))
end
hook.Add("Move", "Bhop", Bhop)

hook.Add("Think", "Update", function()
	/*if (Time < CurTime()) then
		Time = CurTime() + 0.1
		for k, v in pairs(player:GetAll()) do
			Dlt[v:UserID()] = Str[v:UserID()]
			Str[v:UserID()] = (v:EyeAngles().y) - (Str[v:UserID()]) / 4
			Dlt[v:UserID()] = abs(Dlt[v:UserID()] - Str[v:UserID()]) / 2
		end
	end*/
end)

local abs = math.abs
local cl = math.Clamp

function clamp(vec, Min, Max)
	return Vector(cl(vec[1], Min[1], Max[1]), cl(vec[2], Min[2], Max[2]), cl(vec[3], Min[3], Max[3]))
end

hook.Add("Move", "Bhop", function(ply, data)
	if (data:GetMaxSpeed() ~= 1000) then data:SetMaxSpeed(1000) end
	local SVel = data:GetSideSpeed()
	local Vel = ((data:GetMaxSpeed()) / abs(SVel))
	data:SetVelocity(data:GetVelocity() + clamp(data:GetVelocity() / 400, Vector(-1, -1, 0), Vector(1, 1, 0) * Vel)) // 175 def
end)
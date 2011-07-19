
TOOL.Category = "Construction"
TOOL.Name = "#Ignite"
TOOL.Command = nil
TOOL.ConfigName = nil

TOOL.ClientConVar["length"] = 15

function TOOL:RightClick(trace)
	if (!trace.Entity) then return false end
	if (!trace.Entity:IsValid() ) then return false end
	if (trace.Entity:IsPlayer()) then return false end
	if (trace.Entity:IsWorld()) then return false end
	if (CLIENT) then return true end

	trace.Entity:Extinguish()
	
	return true
end


CreateClientConVar("SPropProtection_toggle", 1, false, true)
CreateClientConVar("SPropProtection_admin", 1, false, true)
CreateClientConVar("SPropProtection_use", 1, false, true)
CreateClientConVar("SPropProtection_edmg", 1, false, true)
CreateClientConVar("SPropProtection_pgr", 1, false, true)
CreateClientConVar("SPropProtection_awp", 0, false, true)
CreateClientConVar("SPropProtection_dpd", 1, false, true)
CreateClientConVar("SPropProtection_dae", 0, false, true)
CreateClientConVar("SPropProtection_delay", 120, false, true)

hook.Add("HUDPaint", "spp.hudpaint", function()
	if(!LocalPlayer() or !LocalPlayer():IsValid()) then return end
	local tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
	if (tr.HitNonWorld) then
		local ent = tr.Entity
		if (ent:IsValid() and !ent:IsPlayer() and !LocalPlayer():InVehicle()) then
			local PropOwner = "Owner: "
			local OwnerObj = ent:GetNetworkedEntity("OwnerObj", false)
			if (OwnerObj and OwnerObj:IsValid()) then
				PropOwner = PropOwner .. OwnerObj:Name()
			else
				PropOwner = PropOwner .. ent:GetNetworkedString("Owner", "N/A")
			end
			
			local tribeID = tonumber(ent:GetNetworkedString("TribeID", "1"))
			if (tribeID != 1) then
				local HisTribe = GAMEMODE.FindTribeByID(tribeID)
				if (HisTribe.pass == true) then
					PropOwner = "Owner tribe: " .. HisTribe.name
				end
			end

			surface.SetFont("DefaultBold")
			local Width, Height = surface.GetTextSize(PropOwner)
			Width = Width + 10
			draw.RoundedBox(4, ScrW() / 2 - (Width / 2), ScrH() - Height - 5, Width, Height + 10, Color(0, 0, 0, 150))
			draw.SimpleText(PropOwner, "DefaultBold", ScrW() / 2, ScrH() - 10, Color(255, 255, 255, 255), 1, 1)
		end
	end
end)

Time = 0

NightLight = string.byte('a')
DayLight = string.byte('m')

TargetPattern = DayLight
CurrentPattern = DayLight

if (CLIENT) then
elseif (SERVER) then
	timer.Create("DayTime.Timer", 1, 0, function()
		Time = os.time() - (math.floor(os.time() / 1440) * 1440)
		local hours = math.floor(Time / 60)
		local mins = (Time % 60)

		//print("[" .. hours .. ":" .. mins .. "]")
		
		local suns = ents.FindByClass("env_sun")
		if (#suns > 0) then
			for id, sun in pairs(suns) do
				sun:SetKeyValue("pitch", math.NormalizeAngle((Time / 1440 * 360) + 90))
				sun:Activate() -- Update it!
			end
		end
		
		light_environments = ents.FindByClass('light_environment')
		if (#light_environments > 0) then
			for _,light in pairs(light_environments) do
				if (hours == 18 and mins > 30) then
					TargetPattern = NightLight
				elseif (hours == 6) then
					TargetPattern = DayLight
				end
				
				if (hours > 6 and hours < 18) then
					TargetPattern = DayLight
				else
					TargetPattern = NightLight
				end
				
				if (TargetPattern != CurrentPattern) then
					if (TargetPattern > CurrentPattern) then
						CurrentPattern = math.Clamp(CurrentPattern + 1, NightLight, DayLight)
					else
						CurrentPattern = math.Clamp(CurrentPattern - 1, NightLight, DayLight)
					end
				
					light:Fire('FadeToPattern', string.char(CurrentPattern), 0)
					light:Activate()    
				end
			end
		end
	end)
end
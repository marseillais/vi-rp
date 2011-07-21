
NightLight = string.byte('a')
DayLight = string.byte('m')

TargetPattern = DayLight
CurrentPattern = DayLight

DayTime = 355 -- Day: 710 seconds, Night: 730 seconds
NightTime = 1085
Time = DayTime + 1

IsNight = false

if (CLIENT) then
	timer.Create("DayTime.TimerClient", 1, 0, function()
		Time = Time + 1
	end)
elseif (SERVER) then
	local light_environments = ents.FindByClass('light_environment')
	if (#light_environments > 0) then
		for _,light in pairs(light_environments) do -- Initial fade	
			light:Fire('FadeToPattern', string.char(CurrentPattern), 0)
			light:Activate()    
		end
	end

	timer.Create("DayTime.TimerServer", 1, 0, function()
		Time = Time + 1
		local suns = ents.FindByClass("env_sun")
		if (#suns > 0) then
			for id, sun in pairs(suns) do
				sun:SetKeyValue("pitch", math.NormalizeAngle((Time / 1440 * 360) + 90))
				sun:Activate() -- Update it!
			end
		end

		local light_environments = ents.FindByClass('light_environment')
		if (#light_environments > 0) then
			for _,light in pairs(light_environments) do
				if ((Time < DayTime or Time > NightTime) and TargetPattern != NightLight) then
					TargetPattern = NightLight
					IsNight = true
				elseif ((Time >= DayTime or Time <= NightTime) and TargetPattern != DayLight) then
					TargetPattern = DayLight
					IsNight = false
				end
				
				if ((Time % 3) == 0 and TargetPattern != CurrentPattern) then
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

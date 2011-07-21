if (CLIENT) then
elseif (SERVER) then
	local ost = os.time()
	GAMEMODE.Time = ost - (math.floor(ost / 1440) * 1440)
    
	time = GAMEMODE.Time
	hours = math.floor(time / 60)
	mins = (time % 60)

	//print("[" .. hours .. ":" .. mins .. "]")
    
	local suns = ents.FindByClass("env_sun")
	if (#suns > 0) then
		for id, sun in pairs(suns) do
			sun:SetKeyValue("pitch", math.NormalizeAngle((GAMEMODE.Time / 1440 * 360) + 90))
			sun:Activate() -- Update it!
		end
	end
	
	light_environments = ents.FindByClass('light_environment')
	if (#light_environments > 0) then
		for _,light in pairs(light_environments) do
			if (hours == 18 and mins > 30) then
				GAMEMODE.TargetPattern = GAMEMODE.NightLight
			elseif (hours == 6 and mins > 30) then
				GAMEMODE.TargetPattern = GAMEMODE.DayLight
			end
			
			if (hours > 6 and hours < 18) then
				GAMEMODE.TargetPattern = GAMEMODE.DayLight
			else
				GAMEMODE.TargetPattern = GAMEMODE.NightLight
			end
			
			if (GAMEMODE.TargetPattern != GAMEMODE.CurrentPattern) then
				if (GAMEMODE.TargetPattern > GAMEMODE.CurrentPattern) then
					GAMEMODE.CurrentPattern = math.Clamp(GAMEMODE.CurrentPattern + 1, GAMEMODE.NightLight, GAMEMODE.DayLight)
				else
					GAMEMODE.CurrentPattern = math.Clamp(GAMEMODE.CurrentPattern - 1, GAMEMODE.NightLight, GAMEMODE.DayLight)
				end
			
				light:Fire('FadeToPattern', string.char(GAMEMODE.CurrentPattern), 0)
				light:Activate()    
			end
		end
	end
end
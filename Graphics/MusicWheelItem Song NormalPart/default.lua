local args = ...
local wheelType = ScreenMetric("MusicWheelType")

if wheelType == "MusicWheelHorizontal" then
	return LoadActor(THEME:GetPathG("", "MusicWheelItem Song NormalPart/horizontal.lua"), args)
else
	return LoadActor(THEME:GetPathG("", "MusicWheelItem Song NormalPart/normal.lua"), args)
end
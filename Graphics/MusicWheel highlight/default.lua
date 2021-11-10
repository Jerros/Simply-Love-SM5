local args = ...
local wheelType = ScreenMetric("MusicWheelType")

if wheelType == "MusicWheelHorizontal" then
	return LoadActor(THEME:GetPathG("", "MusicWheel highlight/horizontal.lua"), args)
else
	return LoadActor(THEME:GetPathG("", "MusicWheel highlight/normal.lua"), args)
end
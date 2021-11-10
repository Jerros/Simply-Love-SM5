local args = ...
local wheelType = ScreenMetric("MusicWheelType")

if wheelType == "MusicWheelHorizontal" then
	return LoadActor(THEME:GetPathG("", "MusicWheelItem common/horizontal.lua"), args)
else
	return LoadActor(THEME:GetPathG("", "MusicWheelItem common/normal.lua"), args)
end
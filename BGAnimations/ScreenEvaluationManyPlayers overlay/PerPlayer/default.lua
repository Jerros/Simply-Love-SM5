local player = ...

return Def.ActorFrame{
	Name="Player" .. ToEnumShortString(player),

	Def.Quad{
		InitCommand=function(self)
			self:diffuse(color("#1E282F")):valign(0)
			self:xy(GetPlayerPlayfieldX(player), 220)
			self:zoomto( PlayFieldWidth()-60, 200 )
	
			if ThemePrefs.Get("RainbowMode") then
				self:diffusealpha(0.9)
			end
		end
	},

	LoadActor("./Panes/default.lua", player)
}
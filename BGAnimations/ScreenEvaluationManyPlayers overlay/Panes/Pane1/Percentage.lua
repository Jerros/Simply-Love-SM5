local player = unpack(...)

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
local PercentDP = stats:GetPercentDancePoints()
local percent = FormatPercentScore(PercentDP)
-- Format the Percentage string, removing the % symbol
percent = percent:gsub("%%", "")

return Def.ActorFrame{
	Name="PercentageContainer"..ToEnumShortString(player),
	OnCommand=function(self)
		self:SetWidth(self:GetParent():GetWidth())
	end,

	-- dark background quad behind player percent score
	Def.Quad{
		OnCommand=function(self)
			self:diffuse(color("#101519")):zoomto(self:GetParent():GetWidth(), 40)
		end
	},

	LoadFont("Wendy/_wendy white")..{
		Name="Percent",
		Text=percent,
		InitCommand=function(self)
			self:horizalign(right):zoom(0.4)
			self:x(41)
		end
	}
}

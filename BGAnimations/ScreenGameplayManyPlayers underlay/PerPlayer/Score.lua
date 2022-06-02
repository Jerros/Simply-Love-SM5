local player = ...
local pn = ToEnumShortString(player)
local _x = GetPlayerPlayfieldX(player)

local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

return LoadFont("Wendy/_wendy monospace numbers")..{
	Text="0.00",
	Name=pn.."Score",
	InitCommand=function(self)
		self:valign(1):horizalign(center)
		self:zoom(0.3)
		self:x(_x)
		self:y(50)
	end,

	BeginCommand=function(self)
		
	end,
	JudgmentMessageCommand=function(self) self:queuecommand("RedrawScore") end,
	RedrawScoreCommand=function(self)
		dance_points = pss:GetPercentDancePoints()
		percent = FormatPercentScore( dance_points ):sub(1,-2)
		self:settext(percent)
	end
}
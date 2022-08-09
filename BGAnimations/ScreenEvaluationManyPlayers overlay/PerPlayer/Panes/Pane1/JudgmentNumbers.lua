local player = unpack(...)

local pn = ToEnumShortString(player)
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

local rowHeight = 14
local zoom = 0.2

local TapNoteScores = {
	Types = { 'W1', 'W2', 'W3', 'W4', 'W5', 'Miss' },
}

local RadarCategories = {
	Types = { 'Holds', 'Mines', 'Hands', 'Rolls' },
}


local t = Def.ActorFrame{
	InitCommand=function(self)
		self:xy(20, 20) 
	end
}

-- do "regular" TapNotes first
for i=1,#TapNoteScores.Types do
	local window = TapNoteScores.Types[i]
	local number = pss:GetTapNoteScores( "TapNoteScore_"..window )

	-- actual numbers
	t[#t+1] = Def.RollingNumbers{
		Font="Wendy/_ScreenEvaluation numbers",
		InitCommand=function(self)
			self:zoom(zoom):horizalign(right)

			if SL.Global.GameMode ~= "ITG" then
				self:diffuse( SL.JudgmentColors[SL.Global.GameMode][i] )
			end

			-- if some TimingWindows were turned off, the leading 0s should not
			-- be colored any differently than the (lack of) JudgmentNumber,
			-- so load a unique Metric group.
			local gmods = SL.Global.ActiveModifiers
			if gmods.TimingWindows[i]==false and i ~= #TapNoteScores.Types then
				self:Load("RollingNumbersEvaluationNoDecentsWayOffs")
				self:diffuse(color("#444444"))

			-- Otherwise, We want leading 0s to be dimmed, so load the Metrics
			-- group "RollingNumberEvaluationA"	which does that for us.
			else
				self:Load("RollingNumbersEvaluationA")
			end
		end,
		BeginCommand=function(self)
			self:x( 10 )
			self:y((i-1)*rowHeight)
			self:targetnumber(number)
		end
	}

end


-- then handle holds, mines, hands, rolls
for index, RCType in ipairs(RadarCategories.Types) do

	local performance = pss:GetRadarActual():GetValue( "RadarCategory_"..RCType )
	local possible = pss:GetRadarPossible():GetValue( "RadarCategory_"..RCType )
	possible = clamp(possible, 0, 999)
	local _y = (#TapNoteScores.Types*rowHeight) + ((index-1)*rowHeight)

	-- player performance value
	-- use a RollingNumber to animate the count tallying up for visual effect
	t[#t+1] = Def.RollingNumbers{
		Font="Wendy/_ScreenEvaluation numbers",
		InitCommand=function(self) 
			self:zoom(zoom):horizalign(right):Load("RollingNumbersEvaluationB") 
		end,
		BeginCommand=function(self)
			self:xy(3, _y)
			self:targetnumber(performance)
		end
	}

	-- slash and possible value
	t[#t+1] = LoadFont("Wendy/_ScreenEvaluation numbers")..{
		InitCommand=function(self) self:zoom(zoom):horizalign(right) end,
		BeginCommand=function(self)
			self:xy(30, _y)
			self:settext(("/%03d"):format(possible))
			local leadingZeroAttr = { Length=4-tonumber(tostring(possible):len()), Diffuse=color("#5A6166") }
			self:AddAttribute(0, leadingZeroAttr )
		end
	}
end

return t
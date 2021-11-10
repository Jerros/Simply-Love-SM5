local player = ...
local pn = ToEnumShortString(player)

local r = PlayerNumber:Reverse()
local playerNum = r[player]

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

local TapNoteScores = {
	Types = { 'W1', 'W2', 'W3', 'W4', 'W5', 'Miss' },
	-- x values for P1 and P2
	x = { P1=64, P2=94 }
}

local RadarCategories = {
	Types = { 'Holds', 'Mines', 'Hands', 'Rolls' },
	-- x values for P1 and P2
	x = { P1=-180, P2=218 }
}

local padding = 5
local height = 30
local width = (_screen.w * 0.8) - (padding * 2)
local heigtTotal = height + padding
local x = padding + (_screen.w * 0.1)
local y = 200 + (heigtTotal * playerNum) + padding
local ycenter = y + height / 2
local col = 0
local textZoom = 0.4

local t = Def.ActorFrame { }

t[#t+1] = Def.Quad{
	Name="BackgroundQuad",
	InitCommand=function(self)
		self:zoomtowidth(width)
		self:zoomtoheight(height)
		self:horizalign(left)
		self:vertalign(top)
		
		self:xy(x, y)
		self:diffuse(color("#0f0f0f"))
	end
}

t[#t+1] = LoadFont("Common Bold")..{
	InitCommand=function(self)
		self:horizalign(left)
		self:xy(x + padding, ycenter)
		self:zoom(textZoom)
		self:settext(pn)
		self:diffuse(PlayerColor(player))
	end
}

t[#t+1] = LoadFont("Common Bold")..{
	InitCommand=function(self)
		self:horizalign(left)
		self:xy(x + padding + 40, y + (height/2))
		self:zoom(textZoom)
		
		local currentSteps = GAMESTATE:GetCurrentSteps(player)
		self:settext("Level " .. currentSteps:GetMeter())
		self:diffuse( DifficultyColor(currentSteps:GetDifficulty()) ) 
	end
}

t[#t+1] = LoadFont("Common Bold")..{
	InitCommand=function(self)
		local PercentDP = stats:GetPercentDancePoints()
		local percent = FormatPercentScore(PercentDP)
	
		self:horizalign(left)
		self:xy(x + padding + 120, ycenter)
		self:zoom(textZoom)
		self:settext(percent)
	end
}

-- do "regular" TapNotes first
for i=1,#TapNoteScores.Types do
	local window = TapNoteScores.Types[i]
	local number = stats:GetTapNoteScores( "TapNoteScore_"..window )
	local myColX = x + padding + 140 + (i * 80)

	-- actual numbers
	t[#t+1] = Def.RollingNumbers{
		Font="Wendy/_ScreenEvaluation numbers",
		InitCommand=function(self)
			self:zoom(textZoom):horizalign(left)
			self:xy( myColX, ycenter )
			

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
			self:targetnumber(number)
		end
	}
end

-- then handle holds, mines, hands, rolls
for i, RCType in ipairs(RadarCategories.Types) do

	local performance = stats:GetRadarActual():GetValue( "RadarCategory_"..RCType )
	local possible = stats:GetRadarPossible():GetValue( "RadarCategory_"..RCType )
	possible = clamp(possible, 0, 999)
	local myColX = x + padding + 600 + (i * 130)
	
	-- player performance value
	-- use a RollingNumber to animate the count tallying up for visual effect
	t[#t+1] = Def.RollingNumbers{
		Font="Wendy/_ScreenEvaluation numbers",
		InitCommand=function(self)
			self:zoom(textZoom):horizalign(right):Load("RollingNumbersEvaluationB")
			self:y( ycenter )
			self:x( myColX )
		end,
		BeginCommand=function(self)
			self:targetnumber(performance)
		end
	}

	-- slash and possible value
	t[#t+1] = LoadFont("Wendy/_ScreenEvaluation numbers")..{
		BeginCommand=function(self)
			self:zoom(textZoom):horizalign(right)
			self:y( ycenter )
			self:x( myColX + 62 )
			self:settext(("/%03d"):format(possible))
			local leadingZeroAttr = { Length=4-tonumber(tostring(possible):len()), Diffuse=color("#5A6166") }
			self:AddAttribute(0, leadingZeroAttr )
		end
	}
end



return t
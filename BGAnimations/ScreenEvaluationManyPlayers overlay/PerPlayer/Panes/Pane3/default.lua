local player = unpack(...)
local pn = ToEnumShortString(player)

local af = Def.ActorFrame{Name="HighScoreList"}
local zoom = 0.8

local row_height = 20
local columnX = {
	-60,
	-30,
	30,
	60
}

af[#af+1] = Def.ActorFrame{
	Name="HighScoreEntryHeader",
	LoadFont("Common Normal")..{
		Text="Rank",
		InitCommand=function(self) self:horizalign(right):xy(columnX[1], row_height):zoom(zoom) end,
	},
	LoadFont("Common Normal")..{
		Text="Player",
		InitCommand=function(self) self:horizalign(right):xy(columnX[2], row_height):zoom(zoom)  end,
	},
	LoadFont("Common Normal")..{
		Text="Score",
		InitCommand=function(self) self:horizalign(right):xy(columnX[3], row_height):zoom(zoom)  end,
	},
	LoadFont("Common Normal")..{
		Text="Level",
		InitCommand=function(self) self:horizalign(right):xy(columnX[4], row_height):zoom(zoom)  end,
	}
}

local scores = {}

local players = GAMESTATE:GetHumanPlayers()
for player in ivalues(players) do
	local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
	local PercentDP = stats:GetPercentDancePoints()

	table.insert(scores, {
		player = player,
		score = PercentDP,
		steps = stats:GetPlayedSteps()[1]
	})
end

local function sortfunc(a, b)
	return a['score'] > b['score']
end

table.sort(scores, sortfunc)

for row_index, s in pairs(scores) do
	local row = Def.ActorFrame{
		Name="HighScoreEntry"..(row_index+1),
		InitCommand=function(self)
			self:y((row_index+1) * row_height)
		end,
		LoadFont("Common Normal")..{
			Text=row_index,
			InitCommand=function(self) self:horizalign(right):x(columnX[1]):zoom(zoom) end,
		},
		LoadFont("Common Normal")..{
			Text=ToEnumShortString(s['player']),
			InitCommand=function(self)
				self:horizalign(right):x(columnX[2]):zoom(zoom)
				self:diffuse(PlayerColor(s['player']))
			end,
		},
		LoadFont("Common Normal")..{
			Text=FormatPercentScore(s['score']),
			InitCommand=function(self) self:horizalign(right):x(columnX[3]):zoom(zoom)  end,
		},
		LoadFont("Common Normal")..{
			Text=s['steps']:GetMeter(),
			InitCommand=function(self) self:horizalign(right):x(columnX[4]):zoom(zoom)  end,
		}
	}

	if s['player'] == player then
		row[#row+1] = Def.Quad{
			InitCommand=function(self)
				self:zoomto(170, row_height+2)
				self:diffuseshift():effectcolor1(0.8,0.8,0.8,0.15):effectcolor2(0.1,0.1,0.1,0.15):effectclock("beatnooffset"):effectperiod(2)
			end
		}
	end

	af[#af+1] = row
end

return af
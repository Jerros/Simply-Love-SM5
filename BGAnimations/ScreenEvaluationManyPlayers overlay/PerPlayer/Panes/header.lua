local player = unpack(...)
local pn = ToEnumShortString(player)

local _x = GetPlayerPlayfieldX(player)
local _y = 220
local _w = PlayFieldWidth()-60

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
local PercentDP = stats:GetPercentDancePoints()
local percent = FormatPercentScore(PercentDP)
-- Format the Percentage string, removing the % symbol
percent = percent:gsub("%%", "")
local grade = stats:GetGrade()

return Def.ActorFrame{
	Name="PercentageContainer"..pn,
	OnCommand=function(self)
		self:xy(_x, _y)
	end,

	-- dark background quad behind player percent score
	Def.Quad{
		OnCommand=function(self)
			self:diffuse(color("#101519")):zoomto(_w, 40)
		end
	},

    LoadFont("Common Bold")..{
        InitCommand=function(self)
            self:horizalign(left)
            self:x(-(_w/2) + 20)
            self:zoom(0.6)
            self:settext(pn)
            self:diffuse(PlayerColor(player))
        end
    },

	LoadFont("Wendy/_wendy white")..{
		Name="Percent",
		Text=percent,
		InitCommand=function(self)
			self:horizalign(right):zoom(0.32)
			self:x(_screen.w * 0.06)
		end
	},

    LoadActor(THEME:GetPathG("", "_grades/"..grade..".lua"), playerStats)..{
        InitCommand=function(self)
            self:halign(0):zoom(0.85)
            self:x(50)
            --self:y(_screen.cy-134)
        end,
        OnCommand=function(self) self:zoom(0.16) end
    }
}
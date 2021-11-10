local player = ...
local playerNumberReverse = PlayerNumber:Reverse()
local playerNumer = playerNumberReverse[player]

local _x = GetPlayerPlayfieldX(playerNumer) - (PlayFieldWidth() / 2) + 24

return Def.ActorFrame{
	InitCommand=function(self)
		self:xy(_x, 50)
	end,


	-- colored background for player's chart's difficulty meter
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(26, 26)
		end,
		OnCommand=function(self)
			local currentSteps = GAMESTATE:GetCurrentSteps(player)
			if currentSteps then
				local currentDifficulty = currentSteps:GetDifficulty()
				self:diffuse(DifficultyColor(currentDifficulty))
			end
		end
	},

	-- player's chart's difficulty meter
	LoadFont("Common Bold")..{
		InitCommand=function(self)
			self:diffuse( Color.Black )
			self:zoom( 0.3 )
		end,
		CurrentSongChangedMessageCommand=function(self) self:queuecommand("Begin") end,
		BeginCommand=function(self)
			local steps = GAMESTATE:GetCurrentSteps(player)
			local meter = steps:GetMeter()

			if meter then
				self:settext(meter)
			end
		end
	}
}
local player = ...
local pn = ToEnumShortString(player)

local r = PlayerNumber:Reverse()
local playerNum = r[player]

local w = 120
local h = _screen.h - 320

local textZoom = 0.4

local speed = 300

local t = Def.ActorFrame {
	OnCommand=function(self)
		self:vertalign(top)
		self:x(GetPlayerPlayfieldX(playerNum))
		self:setsize(w, h)
		self:queuecommand("Redraw")
	end,
	CodeMessageCommand=function(self, param)
		if param.PlayerNumber ~= player then
			return
		end
		
		if param.Name == "ScrollSpeedUp" and speed < 1000 then
			speed = speed + 100
		end
		
		if param.Name == "ScrollSpeedDown" and speed > 100 then
			speed = speed - 100
		end
		
		SL[pn].ActiveModifiers.SpeedMod     = speed
		SL[pn].ActiveModifiers.SpeedModType = "M"
		ApplyMods(player);
		
		self:playcommand("Redraw")
	end
}

t["CurrentSteps" .. pn .. "ChangedMessageCommand"] = function(self)
	self:queuecommand("Redraw")
end

t[#t+1] = Def.Quad{
	Name="BackgroundQuad",
	OnCommand=function(self)
		self:vertalign(top)
		self:setsize(w, h)
		self:diffuse(PlayerColor(player))
		self:diffusealpha(0.5)
	end
}

t[#t+1] = LoadFont("Common Bold")..{
	InitCommand=function(self)
		self:y(30)
		self:zoom(textZoom)
		self:settext(pn)
	end
}

t[#t+1] = LoadFont("Common Bold")..{
	Name="Diff",
	InitCommand=function(self)
		self:y(70)
		self:zoom(textZoom)
	end,
	RedrawCommand=function(self)
		local currentSteps = GAMESTATE:GetCurrentSteps(player)
		self:settext("Level: " .. currentSteps:GetMeter())
		self:diffuse( DifficultyColor(currentSteps:GetDifficulty()) ) 
	end
}

t[#t+1] = LoadFont("Common Bold")..{
	Name="Speed",
	InitCommand=function(self)
		self:y(110)
		self:zoom(textZoom)
	end,
	RedrawCommand=function(self)
		self:settext("Speed: " .. speed)
	end
}



return t
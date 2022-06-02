local player = ...
local pn = ToEnumShortString(player)

local w = 120
local h = _screen.h - 320
local textZoom = 0.35
local optY = 30
local optHeight = 25
local optIndex = -1
local opts = {
	'Diff',
	'Speed',
	'Noteskin'
}

local speed = 300
local noteskinIndex = 1
local chartIndex = 1
local noteskins = CustomOptionRow("NoteSkin").Choices
local steps = {}

local t = Def.ActorFrame {
	OnCommand=function(self)
		self:vertalign(top)
		self:x(GetPlayerPlayfieldX(player))
		self:setsize(w, h)
		self:queuecommand("Redraw")
		local song = GAMESTATE:GetCurrentSong()
		steps = SongUtil.GetPlayableSteps( song )
	end,
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		steps = SongUtil.GetPlayableSteps( song )
		chartIndex = 1
		self:queuecommand("Redraw")
	end,
	MenuUnlockCommand=function(self)
		local function OptInputHandler(e)
			SM(e)
			if e.PlayerNumber ~= player then
				return
			end
		
			if e.type ~= 'InputEventType_Release' then
				return
			end
		
			if e.button == 'Down' and optIndex < #opts then
				optIndex = optIndex + 1
				self:playcommand("Redraw")
			end
		
			if e.button == 'Up' and optIndex > 1 then
				optIndex = optIndex - 1
				self:playcommand("Redraw")
			end

			if e.button == 'Left' and optIndex > 0 and optIndex <= #opts then
				self:GetChild(opts[optIndex]):queuecommand('Down')
			end

			if e.button == 'Right' and optIndex > 0 and optIndex <= #opts then
				self:GetChild(opts[optIndex]):queuecommand('Up')
			end
		end

		self:GetChild("MenuArrow"):visible(true)
		SCREENMAN:GetTopScreen():AddInputCallback( OptInputHandler )
		self:playcommand("Redraw")
		self:zoom(1.1):linear(0.5):zoom(1)
	end,
	CodeMessageCommand=function(self, param)
		if param.PlayerNumber ~= player then
			return
		end

		if param.Name == "ScrollSpeedUp" and optIndex == -1 then
			self:GetChild("Speed"):queuecommand("Up")
		end
		
		if param.Name == "ScrollSpeedDown" and optIndex == -1 then
			self:GetChild("Speed"):queuecommand("Down")
		end

		if param.Name == 'OptsMode' then
			if optIndex == -1 then
				optIndex = 1
				self:queuecommand("MenuUnlock")
			end
		end
	end
}

t["CurrentSteps" .. pn .. "ChangedMessageCommand"] = function(self)
	self:queuecommand("Redraw")
end

t[#t+1] = LoadActor("Arrow.png")..{
	Name="MenuArrow",
	OnCommand=function(self)
		self:bob():effectmagnitude(4, 0, 0)
		self:x(-50)
		self:zoomto(20, 20)
		self:visible(false)
	end,
	RedrawCommand=function(self)
		self:y(optY + optIndex * optHeight)
	end
}

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
		self:y(optY)
		self:zoom(textZoom)
		self:settext(pn)
	end
}

t[#t+1] = LoadFont("Common Normal")..{
	Name="Diff",
	InitCommand=function(self)
		self:y(optY + optHeight)
		self:zoom(0.9)
	end,
	RedrawCommand=function(self)
		local currentSteps = GAMESTATE:GetCurrentSteps(player)
		self:settext("Level: " .. currentSteps:GetMeter())
		self:diffuse( DifficultyColor(currentSteps:GetDifficulty()) ) 
	end,
	UpCommand=function(self)
		if chartIndex < #steps then
			chartIndex = chartIndex + 1
		end
		GAMESTATE:SetCurrentSteps(player, steps[chartIndex])
		
		-- self:GetParent():playcommand("Redraw")
	end,
	DownCommand=function(self)
		if chartIndex > 1 then
			chartIndex = chartIndex - 1
		end
		GAMESTATE:SetCurrentSteps(player, steps[chartIndex])
		
		-- self:GetParent():playcommand("Redraw")
	end
}

t[#t+1] = LoadFont("Common Normal")..{
	Name="Speed",
	InitCommand=function(self)
		self:y(optY + optHeight * 2)
		self:zoom(0.9)
	end,
	RedrawCommand=function(self)
		self:settext("Speed: " .. speed)
	end,
	UpCommand=function(self)
		if speed < 1000 then
			speed = speed + 100
			SL[pn].ActiveModifiers.SpeedMod     = speed
			SL[pn].ActiveModifiers.SpeedModType = "M"
			ApplyMods(player);
			self:GetParent():playcommand("Redraw")
		end
	end,
	DownCommand=function(self)
		if speed > 0 then
			speed = speed - 100
			SL[pn].ActiveModifiers.SpeedMod     = speed
			SL[pn].ActiveModifiers.SpeedModType = "M"
			ApplyMods(player);
			self:GetParent():playcommand("Redraw")
		end
	end
}

t[#t+1] = Def.ActorProxy{
	Name="Noteskin",
	OnCommand=function(self)
		self:y(optY + optHeight * 3)
		self:zoom(0.45)
	end,
	RedrawCommand=function(self)
		local offscreen_actor_name = "NoteSkin_" .. noteskins[noteskinIndex]
		local offscreen_actor = SCREENMAN:GetTopScreen():GetChild("Overlay"):GetChild(offscreen_actor_name)
		self:SetTarget( offscreen_actor )
	end,
	UpCommand=function(self)
		local i=1
		noteskinIndex = noteskinIndex + 1
		if noteskinIndex > #noteskins then
			noteskinIndex = 1
		end
		SL[pn].ActiveModifiers.NoteSkin = noteskins[noteskinIndex]
		ApplyMods(player);
		self:GetParent():playcommand("Redraw")
	end,
	DownCommand=function(self)
		noteskinIndex = noteskinIndex - 1
		if noteskinIndex < 1 then
			noteskinIndex = #noteskins
		end
		SL[pn].ActiveModifiers.NoteSkin = noteskins[noteskinIndex]
		ApplyMods(player);
		self:GetParent():playcommand("Redraw")
	end
}

return t
local player = ...
local pn = ToEnumShortString(player)

local w = 120
local h = _screen.h - 320
local textZoom = 0.4
local optY = 30
local optHeight = 28
local optIndex = -1
local opts = {
	'Level',
	'Speed',
	'Filter',
	'Noteskin'
}

local filterIndex = 1
local FilterAlpha = {
	Off = 0,
	Dark = 0.5,
	Darker = 0.75,
	Darkest = 0.95
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
		self:queuecommand("CurrentSongChangedMessage")
	end,
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
			steps = SongUtil.GetPlayableSteps( song )
		else
			steps = {}
		end

		chartIndex = 1
		self:queuecommand("Redraw")
	end,
	MenuUnlockCommand=function(self)
		local function OptInputHandler(e)
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

		SCREENMAN:GetTopScreen():AddInputCallback( OptInputHandler )
		self:queuecommand("Redraw")
		self:zoom(1.1):linear(0.5):zoom(1)
	end,
	CodeMessageCommand=function(self, param)
		if param.PlayerNumber ~= player then
			return
		end

		if optIndex == -1 then
			if param.Name == "ScrollSpeedUp" then
				self:GetChild("Speed"):queuecommand("Up")
			end
			if param.Name == "ScrollSpeedDown" then
				self:GetChild("Speed"):queuecommand("Down")
			end
			if param.Name == "PrevStepsCode" then
				self:GetChild("Level"):queuecommand("Down")
			end
			if param.Name == "NextStepsCode" then
				self:GetChild("Level"):queuecommand("Up")
			end
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
	InitCommand=function(self)
		self:halign(1)
		self:bob():effectmagnitude(4, 0, 0)
		self:x(-70)
		self:zoomto(20, 20)
		self:visible(false)
	end,
	RedrawCommand=function(self)
		self:y(optY + optIndex * optHeight)
	end,
	MenuUnlockCommand=function(self)
		self:visible(true)
	end
}

t[#t+1] = Def.Quad{
	Name="BackgroundQuad",
	OnCommand=function(self)
		self:vertalign(top)
		self:setsize(w, h)
		self:diffuse(color("#1E282F"))
	end
}

t[#t+1] = Def.Quad{
	OnCommand=function(self)
		self:vertalign(top)
		self:setsize(w, 10)
		self:diffuse(PlayerColor(player))
	end
}

t[#t+1] = LoadFont("Common Bold")..{
	InitCommand=function(self)
		self:y(optY)
		self:zoom(textZoom)
		self:settext(pn)
		self:diffuse(PlayerColor(player))
	end
}

t[#t+1] = Def.ActorFrame{
	Name="Level",
	InitCommand=function(self)
		self:y(optY + optHeight)
	end,
	UpCommand=function(self)
		if chartIndex < #steps then
			chartIndex = chartIndex + 1
		end
		GAMESTATE:SetCurrentSteps(player, steps[chartIndex])
	end,
	DownCommand=function(self)
		if chartIndex > 1 then
			chartIndex = chartIndex - 1
		end
		GAMESTATE:SetCurrentSteps(player, steps[chartIndex])
	end,
	LoadFont("Common Bold")..{
		InitCommand=function(self)
			self:halign(1)
			self:zoom(textZoom)
			self:settext("Level")
		end,
	},
	Def.Quad{
		InitCommand=function(self)
			self:halign(0)
			self:x(18)

			local height = 28
			local spacing = 2
			self:diffuse(color("#0f0f0f")):zoomto(height, height)
			if ThemePrefs.Get("RainbowMode") then
				self:diffusealpha(0.9)
			end
		end
	},
	LoadFont("Common Bold")..{
		InitCommand=function(self)
			self:x(31)

			local height = 28
			local spacing = 2
			self:zoom(0.45)
		end,
		RedrawCommand=function(self, params)
			local currentSteps = GAMESTATE:GetCurrentSteps(player)
			if currentSteps then
				self:diffuse( DifficultyColor(currentSteps:GetDifficulty()) ) 
				self:settext(currentSteps:GetMeter())
			end
		end,
		UnsetCommand=function(self) self:settext(""):diffuse(color("#182025")) end,
	}
}

t[#t+1] = Def.ActorFrame {
	Name="Speed",
	InitCommand=function(self)
		self:y(optY + optHeight * 2)
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
		if speed > 100 then
			speed = speed - 100
			SL[pn].ActiveModifiers.SpeedMod     = speed
			SL[pn].ActiveModifiers.SpeedModType = "M"
			ApplyMods(player);
			self:GetParent():playcommand("Redraw")
		end
	end,
	LoadFont("Common Bold")..{
		InitCommand=function(self)
			self:halign(1)
			self:zoom(textZoom)
			self:settext("Speed")
		end,
	},
	LoadFont("Common Bold")..{
		InitCommand=function(self)
			self:zoom(textZoom)
			self:halign(0)
			self:x(18)
		end,
	
		RedrawCommand=function(self)
			self:settext(speed)
		end
	}
}

t[#t+1] = Def.ActorFrame {
	Name="Filter",
	InitCommand=function(self)
		self:y(optY + optHeight * 3)
		self:visible(false)
	end,
	MenuUnlockCommand=function(self)
		self:visible(true)
	end,
	UpCommand=function(self)
		if filter < 100 then
			filter = filter + 10
			SL[pn].ActiveModifiers.
			self:GetParent():playcommand("Redraw")
		end
	end,
	DownCommand=function(self)
		if filter > 0 then
			filter = filter - 10
			self:GetParent():playcommand("Redraw")
		end
	end,
	LoadFont("Common Bold")..{
		InitCommand=function(self)
			self:halign(1)
			self:zoom(textZoom)
			self:settext("Filter")
			self:x(3)
		end,
	},
	Def.Quad{
		InitCommand=function(self)
			self:halign(0)
			self:x(18)
			local height = 28
			self:zoomto(height, height)
			self:diffuse(color("#000000"))
		end,
		RedrawCommand=function(self)
			if filter > 0 then
				self:visible(true)
				self:diffusealpha(filter / 100)
			else
				self:visible(false)
			end
		end
	},
}

t[#t+1] = Def.ActorProxy{
	Name="Noteskin",
	InitCommand=function(self)
		self:y(optY + optHeight * 4)
		self:zoom(0.45)
		self:visible(false)
	end,
	MenuUnlockCommand=function(self)
		self:visible(true)
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
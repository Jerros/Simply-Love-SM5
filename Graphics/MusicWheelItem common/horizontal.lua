local args = ...

local color1 = args[1]
local color2 = args[2]

local w = 160
local h = 80
local y = 0

if color1 == "quad" then
	return Def.Quad{
		InitCommand=function(self) 
			self
				:y(y)
				:zoomto(w,h)
			end 
	}
end

return Def.ActorFrame{
	-- the MusicWheel is centered via metrics under [ScreenSelectMusic]; offset by a slight amount to the right here
	InitCommand=function(self)
		self:y(y)
		self:setsize(w, h)
	end,
	Def.Quad{
		InitCommand=function(self)
			self
				:diffuse(color1)
				:zoomto(w, h) 
		end
	}
}
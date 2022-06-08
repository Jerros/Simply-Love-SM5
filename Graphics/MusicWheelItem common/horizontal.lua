local args = ...

local color1 = args[1]
local color2 = args[2]

local w = 140
local h = 60
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
	InitCommand=function(self)
		self:y(y)
		self:setsize(w, h)
	end,
	Def.Quad{
		InitCommand=function(self)
			self
				:diffuse(color2)
				:zoomto(w, h) 
		end
	},
	
}
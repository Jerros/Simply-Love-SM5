local w = 140 + 20
local h = 60 + 20
local y = 0

return Def.ActorFrame {
	InitCommand=function(self)
		self:zoomto(w, h)
	end,

	Def.Quad{
		RealOnCommand=function(self)
			self:zoomto(w, h)
			if DarkUI() then
				self:diffuseshift():effectcolor1(0.8,0.8,0.8,0.15):effectcolor2(0.1,0.1,0.1,0.15):effectclock("beatnooffset"):effectperiod(2)
			else
				self:diffuseshift():effectcolor1(0.8,0.8,0.8,0.15):effectcolor2(0.8,0.8,0.8,0.05):effectclock("beatnooffset"):effectperiod(2)
			end
		end,
		RealOffCommand=function(self)
			self:decelerate(0.2):diffusealpha(0)
		end
	}
}
local args = ...

local color1 = args[1]
local color2 = args[2]

local num_items = THEME:GetMetric("MusicWheel", "NumWheelItems")
-- subtract 2 from the total number of MusicWheelItems
-- one MusicWheelItem will be offsceen above, one will be offscreen below
local num_visible_items = num_items - 2
local item_width = _screen.w / 2.125
local x = WideScale(28,33)

if color1 == "quad" then
	return Def.Quad{
		InitCommand=function(self) 
			self
				:horizalign(left)
				:x(x)
				:zoomto(item_width,_screen.h/num_visible_items-1)
			end 
	}
end

return Def.ActorFrame{
	-- the MusicWheel is centered via metrics under [ScreenSelectMusic]; offset by a slight amount to the right here
	InitCommand=function(self) self:x(x) end,
	Def.Quad{
		InitCommand=function(self)
			self
				:horizalign(left)
				:diffuse(color1)
				:zoomto(item_width, _screen.h/num_visible_items) 
		end
	},
	Def.Quad{
		InitCommand=function(self)
			self
				:horizalign(left)
				:diffuse(color2)
				:zoomto(item_width, _screen.h/num_visible_items - 1)
		end 
	}
}
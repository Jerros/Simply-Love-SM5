return Def.Quad{
	Name="ExplanationBackground",
	InitCommand=function(self) self:diffuse(0,0,0,0):xy(_screen.cx, _screen.h-57):zoomto(600, 38) end,
	OnCommand=function(self) self:linear(0.2):diffusealpha(0.8) end,
}
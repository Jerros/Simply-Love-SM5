local t = Def.ActorFrame{ Name="PlayerTable" }

local padding = 5
local height = 30
local heigtTotal = height + padding

t[#t+1] = Def.Quad{
	Name="BackgroundQuad",
	InitCommand=function(self)
		self:zoomtowidth(_screen.w * 0.8)
		self:zoomtoheight(heigtTotal * #GAMESTATE:GetHumanPlayers() + padding )
		
		self:vertalign(top)
		self:xy(_screen.cx, 200)
		self:diffuse(color("#1e282f"))
	end
}

for player in ivalues( GAMESTATE:GetHumanPlayers() ) do
	t[#t+1] = LoadActor("./TableRow.lua", player)
end

return t
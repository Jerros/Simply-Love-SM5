local t = Def.ActorFrame{
	Name="PlayerTable",
	InitCommand=function(self)
		self:vertalign(top)
		self:y(180)
	end
}

for player in ivalues( GAMESTATE:GetHumanPlayers() ) do
	t[#t+1] = LoadActor("./TableCol.lua", player)
end

return t
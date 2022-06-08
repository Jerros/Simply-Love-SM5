local Players = GAMESTATE:GetHumanPlayers()


if ThemePrefs.Get("WriteCustomScores") then
	WriteScores()
end

local t = Def.ActorFrame{
	Name="ScreenEval Common",
	OnCommand=function(self)
		local InputHandler = LoadActor("./InputHandler.lua", {self, 3})
		SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
	end
}

-- the title of the song and its graphical banner, if there is one
t[#t+1] = LoadActor("./Shared/TitleAndBanner.lua")

-- text to display BPM range (and ratemod if ~= 1.0) immediately under the banner
t[#t+1] = LoadActor("./Shared/BPM_RateMod.lua")

-- store some attributes of this playthrough of this song in the global SL table
-- for later retrieval on ScreenEvaluationSummary
t[#t+1] = LoadActor("./Shared/GlobalStorage.lua")


t[#t+1] = LoadActor("./Panes/default.lua")

for player in ivalues(Players) do

	-- store player stats for later retrieval on EvaluationSummary and NameEntryTraditional
	-- this doesn't draw anything to the screen, it just runs some code
	t[#t+1] = LoadActor("./PerPlayer/Storage.lua", player)

end

return t

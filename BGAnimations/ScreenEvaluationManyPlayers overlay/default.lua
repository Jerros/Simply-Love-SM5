local Players = GAMESTATE:GetHumanPlayers()


if ThemePrefs.Get("WriteCustomScores") then
	WriteScores()
end

local af = Def.ActorFrame{
	Name="ScreenEval Common",
	OnCommand=function(self)
		local InputHandler = LoadActor("./InputHandler.lua", {self, 3})
		SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
	end
}

local ns = ThemePrefs.Get("ScreenCount")

af[#af+1] = Def.ActorFrame{
	Name="Clonable",
	OnCommand=function(self)
		self:x(SubScreensX(1))
	end,
	LoadActor("./Shared/TitleAndBanner.lua"),
	LoadActor("./Shared/BPM_RateMod.lua")
}

if ns > 1 then
	for i=2,ns do
		af[#af+1] = Def.ActorProxy{
			InitCommand=function(self) 
				
			end,
			OnCommand=function(self)
				local clonable = self:GetParent():GetChild("Clonable")
				self:SetTarget(clonable)
				self:x(_screen.cx)
			end
		}
	end
end


-- store some attributes of this playthrough of this song in the global SL table
-- for later retrieval on ScreenEvaluationSummary
af[#af+1] = LoadActor("./Shared/GlobalStorage.lua")


for player in ivalues(Players) do

	af[#af+1] = LoadActor("./PerPlayer/default.lua", player)

	-- store player stats for later retrieval on EvaluationSummary and NameEntryTraditional
	-- this doesn't draw anything to the screen, it just runs some code
	af[#af+1] = LoadActor("./PerPlayer/Storage.lua", player)

end

return af

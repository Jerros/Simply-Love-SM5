local PlayerThatLateJoined = nil

for player in ivalues(GAMESTATE:GetHumanPlayers()) do
	local pn = ToEnumShortString(player)
	
	for i = 1, NUM_PLAYERS do
		SL[pn]:initialize()
	end
		
	GAMESTATE:SetPreferredDifficulty(player, 'Difficulty_Beginner');
end

return Def.Actor{
	-- "PlayerJoined" will be broadcast by the StepMania engine when a player latejoins on
	-- ScreenSelectMusic.  We'll need to check for a profile and apply modifiers.
	PlayerJoinedMessageCommand=function(self, params)
		-- Queueing is necessary here to give LoadProfileCustom() time to read this player's mods from file
		-- and set the SL[pn].ActiveModifiers table accordingly.  If we call ApplyMods(params.Player) here,
		-- the SL[pn].ActiveModifiers table is still in its default state, and mods won't be set properly.
		PlayerThatLateJoined = params.Player
		self:queuecommand("ApplyMods")
	end,
	ApplyModsCommand=function(self)
		if PlayerThatLateJoined then
			-- ApplyMods() is defined at the bottom of ./Scripts/SL-PlayerOptions.lua
			ApplyMods(PlayerThatLateJoined)
			-- and reset this back to nil
			PlayerThatLateJoined = nil
		end
	end
}
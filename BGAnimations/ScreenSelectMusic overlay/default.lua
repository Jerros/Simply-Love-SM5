local t = Def.ActorFrame{
	ChangeStepsMessageCommand=function(self, params)
		self:playcommand("StepsHaveChanged", params)
	end,
	StorageDevicesChangedMessageCommand=ReloadProfiles,

	-- make the MusicWheel appear to cascade down
	LoadActor("./MusicWheelAnimation.lua"),
	-- Apply player modifiers from profile
	LoadActor("./PlayerModifiers.lua"),
	-- Song search feature
	LoadActor("./SongSearch.lua"),

	-- ---------------------------------------------------
	-- next, load visual elements; the order of the layers matters for most of these

	-- make the MusicWheel appear to cascade down; this should draw underneath P2's PaneDisplay
	LoadActor("./MusicWheelAnimation.lua"),

	-- elements we need two of (one for each player) that draw underneath the StepsDisplayList
	-- this includes the stepartist boxes and the PaneDisplays (number of steps, jumps, holds, etc.)
	LoadActor("./PerPlayer/Under.lua"),
	-- Difficulty Blocks (normal) or CourseContentsList (CourseMode)
	LoadActor("./StepsDisplayList/default.lua"),
	-- Graphical Banner
	LoadActor("./Banner.lua"),
	-- Song Artist, BPM, Duration (Referred to in other themes as "PaneDisplay")
	LoadActor("./SongDescription.lua"),
	-- a folder of Lua files to be loaded twice (once for each player)
	LoadActor("./PerPlayer/default.lua"),
	-- MenuTimer code for preserving SSM's timer value
	LoadActor("./MenuTimer.lua"),
	-- overlay for sorting the MusicWheel, hidden by default
	LoadActor("./SortMenu/default.lua")
}

return t
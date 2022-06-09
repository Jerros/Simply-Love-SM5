local af = Def.ActorFrame{
	-- GameplayReloadCheck is a kludgy global variable used in ScreenGameplay in.lua to check
	-- if ScreenGameplay is being entered "properly" or being reloaded by a scripted mod-chart.
	-- If we're here in SelectMusic, set GameplayReloadCheck to false, signifying that the next
	-- time ScreenGameplay loads, it should have a properly animated entrance.
	InitCommand=function(self) SL.Global.GameplayReloadCheck = false end,

	-- ---------------------------------------------------
	--  first, load files that contain no visual elements, just code that needs to run

	-- MenuTimer code for preserving SSM's timer value when going
	-- from SSM to Player Options and then back to SSM
	LoadActor("./PreserveMenuTimer.lua"),
	-- Apply player modifiers from profile
	LoadActor("./PlayerModifiers.lua"),

	-- ---------------------------------------------------
	-- next, load visual elements; the order of these matters
	-- i.e. content in PerPlayer/Over needs to draw on top of content from PerPlayer/Under

	-- make the MusicWheel appear to cascade down; this should draw underneath P2's PaneDisplay
	LoadActor("./MusicWheelAnimation.lua"),

	-- elements we need two of (one for each player) that draw underneath the StepsDisplayList
	-- this includes the stepartist boxes, the density graph, and the cursors.
	LoadActor("./PerPlayer/default.lua"),

	-- ---------------------------------------------------
	-- finally, load the overlay used for sorting the MusicWheel (and more), hidden by default
	LoadActor("./SortMenu/default.lua"),
	-- a Test Input overlay can (maybe) be accessed from the SortMenu
	LoadActor("./TestInput.lua"),

	LoadActor("./SongSearch/default.lua"),
}

local ns = ThemePrefs.Get("ScreenCount")

af[#af+1] = Def.ActorFrame{
	Name="Clonable",
	OnCommand=function(self)
		self:halign(0.5)
		self:x(SubScreensX(1))
	end,
	LoadActor("./StepsDisplayList/default.lua"),
	LoadActor("./SongDescription/SongDescription.lua"),
}

if ns > 1 then
	for i=2,ns do
		af[#af+1] = Def.ActorProxy{
			InitCommand=function(self) 
				
			end,
			OnCommand=function(self)
				local clonable = self:GetParent():GetChild("Clonable")
				local _w = clonable:GetChild("StepsDisplayList"):GetWidth()
				self:SetTarget(clonable)

				self:x(_screen.cx)
			end
		}
	end
end

LoadActor("./../ScreenPlayerOptions overlay/OptionRowPreviews/NoteSkin.lua", af)

return af
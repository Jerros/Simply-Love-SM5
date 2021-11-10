local af = LoadActor(
	THEME:GetPathG("", "MusicWheelItem common"),
	{
		{0, 10/255, 17/255, 0.5},
		DarkUI() and {1,1,1,0.5} or {10/255, 20/255, 27/255, 1}
	}
)

af[#af+1] = Def.Sprite {
	-- Load the banner
	-- XXX Same code can be reused for courses, etc.  Folders too?
	SetMessageCommand = function(self, params)
		local song = params.Song
		if song and song:HasBanner() then
			self:LoadBanner(song:GetBannerPath())
		end
		self:setsize(self:GetParent():GetWidth(), self:GetParent():GetHeight())
	end,
};

return af
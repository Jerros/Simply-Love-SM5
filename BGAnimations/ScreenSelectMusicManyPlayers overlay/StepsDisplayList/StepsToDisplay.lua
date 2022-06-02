return function(AllSteps)
	local StepsToShow, edits = {}, {}

	for stepchart in ivalues(AllSteps) do

		local difficulty = stepchart:GetDifficulty()

		if difficulty == "Difficulty_Edit" then
			-- gather edit charts into a separate table for now
			edits[#edits+1] = stepchart
		else
			-- use the reverse lookup functionality available to all SM enums
			-- to map a difficulty string to a number
			-- SM's enums are 0 indexed, so Beginner is 0, Challenge is 4, and Edit is 5
			-- for our purposes, increment by 1 here
			StepsToShow[ Difficulty:Reverse()[difficulty] + 1 ] = stepchart
			-- assigning a stepchart directly to numerical index like this^
			-- can leave "holes" in the indexing, or indexing might not start at 1
			-- so be sure to use pairs() instead of ipairs() if iterating over later
		end
	end

	for i, edit_chart in ipairs(edits) do
		StepsToShow[7+i] = edit_chart
	end

	return StepsToShow
end
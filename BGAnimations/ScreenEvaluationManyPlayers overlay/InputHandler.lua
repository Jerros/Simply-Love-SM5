local af, num_panes = unpack(...)

if not af
or type(num_panes) ~= "number"
then
	return
end

-- -----------------------------------------------------------------------
-- local variables

local panes, active_pane = {}, {}

local style = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())
local players = GAMESTATE:GetHumanPlayers()
local mpn = GAMESTATE:GetMasterPlayerNumber()
local primary_i = 1

local players = GAMESTATE:GetHumanPlayers()
for player in ivalues(players) do
	local pn   = ToEnumShortString(player)
	panes[player] = {}

	for i=1,num_panes do
		local pane = af:GetChild("Panes"):GetChild( ("Pane%i_Side%s"):format(i, pn) )
		pane:visible(i == primary_i)
		active_pane[player] = primary_i
		table.insert(panes[player], pane)
	end
end

return function(event)
	if not (event and event.PlayerNumber and event.button) then return false end

	local cn = event.PlayerNumber

	if event.type == "InputEventType_FirstPress" and panes[cn] then

		if event.button == "Right" or event.button == "Left" then
			if event.button == "Right" then
				active_pane[cn] = (active_pane[cn] % #panes[cn]) + 1

			elseif event.button == "Left" then
				active_pane[cn] = ((active_pane[cn] - 2) % #panes[cn]) + 1
			end

			-- hide all panes for this side
			for i=1,#panes[cn] do
				panes[cn][i]:visible(false)
			end
			-- only show the pane we want on this side
			panes[cn][active_pane[cn]]:visible(true)

			af:queuecommand("PaneSwitch")
		end
	end
end
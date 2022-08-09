local player = ...
local NumPanes = 3
local af = Def.ActorFrame{
    Name="Panes"
}

local _x = GetPlayerPlayfieldX(player)
local _y = 240
local _w = PlayFieldWidth()-60



for i=1, NumPanes do
    local pn   = ToEnumShortString(player)
    local pane = LoadActor("./Pane"..i, {player})

    af[#af+1] = Def.ActorFrame{
        Name="Pane"..i,
        InitCommand=function(self) self:valign(0):xy(_x,_y) end,
        OnCommand=function(self) self:SetWidth(_w) end,
        pane
    }

    af[#af+1] = LoadActor("./header.lua", {player})
end

return af
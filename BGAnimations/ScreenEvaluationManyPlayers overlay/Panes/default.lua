local players = GAMESTATE:GetHumanPlayers()
local NumPanes = 2
local af = Def.ActorFrame{}
af.Name="Panes"

for player in ivalues(players) do
    local _x = GetPlayerPlayfieldX(player)
    local _y = 220
    local _w = PlayFieldWidth()-60

    af[#af+1] = Def.Quad{
        InitCommand=function(self)
            self:diffuse(color("#1E282F")):valign(0)
            self:xy(_x, _y)
            self:zoomto( _w, 200 )
    
            if ThemePrefs.Get("RainbowMode") then
                self:diffusealpha(0.9)
            end
        end
    }

    for i=1, NumPanes do
        local pn   = ToEnumShortString(player)
        local pane = LoadActor("./Pane"..i, {player})

        af[#af+1] = Def.ActorFrame{
            Name="Pane"..i.."_Side"..pn,
            InitCommand=function(self) self:valign(0):xy(_x,_y) end,
            OnCommand=function(self) self:SetWidth(_w) end,
            pane
        }
    end
end

return af
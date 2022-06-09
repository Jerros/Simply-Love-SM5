local ns = ThemePrefs.Get("ScreenCount")

if ns < 2 then
    return
end

local af = Def.ActorFrame{
    OnCommand=function(self)
        local bg = SCREENMAN:GetTopScreen():GetChild('SongBackground')
        bg:visible(false)
    end
}

for i=1,ns do
    af[#af+1] = Def.ActorProxy{
        InitCommand=function(self) 
            self:x(SubScreensX(i))
        end,
        OnCommand=function(self)
            local bg = SCREENMAN:GetTopScreen():GetChild('SongBackground')
            self:SetTarget(bg)
        end
    }
end

return af
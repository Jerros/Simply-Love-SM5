local ns = ThemePrefs.Get("ScreenCount")

if ns < 2 then
    return
end

local af = Def.ActorFrame{
    OnCommand=function(self)
        local bg = SCREENMAN:GetTopScreen():GetChild('SongBackground')
        bg:zoomx(0.5)
        bg:visible(false)
    end
}

for i=1,ns do
    af[#af+1] = Def.ActorProxy{
        InitCommand=function(self)
            --if i == 1 then
                    
            --end
            if i == 2 then
                self:x(_screen.w * 0.5)
            end
            
        end,
        OnCommand=function(self)
            local bg = SCREENMAN:GetTopScreen():GetChild('SongBackground')
            self:SetTarget(bg)
        end
    }
end

return af
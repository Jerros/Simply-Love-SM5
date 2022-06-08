return Def.ActorFrame{
    OnCommand=function(self)
        local bg = SCREENMAN:GetTopScreen():GetChild('SongBackground')
        bg:visible(false)

    end,
    Def.ActorProxy{
        OnCommand=function(self)
            local bg = SCREENMAN:GetTopScreen():GetChild('SongBackground')
            self:x(_screen.w * -0.25)
            self:SetTarget(bg)
        end
    },
    Def.ActorProxy{
        OnCommand=function(self)
            local bg = SCREENMAN:GetTopScreen():GetChild('SongBackground')
            self:x(_screen.w * 0.25)
            self:SetTarget(bg)
        end
    }
}
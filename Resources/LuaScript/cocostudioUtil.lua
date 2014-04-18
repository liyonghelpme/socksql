--recursive get children
function getChildByNameRec(ui, name)
    local t = ui:getChildByName(name)
    if t ~= nil then
        print("name", t:getName())
        return t
    end
    local ac = ui:getChildren()
    if ac ~= nil then
        local c = ac:count()
        for i=0, c-1, 1 do
            local ch = ac:objectAtIndex(i)
            local cw = tolua.cast(ch,"Widget")
            --[[
            if cw:getName() == name then
                print("wname", cw:getName())
                return cw
            end
            --]]
            local nw = getChildByNameRec(cw, name)
            if nw then
                return nw
            end
        end
    end
end

--使用panel 来承载 Image 背景图片
function centerBg(sp, sds)
    local vs = getVS()
    local ds = global.director.designSize
    if sds ~= nil then
        if type(sds) == 'userdata' then
            sds = {sds.width, sds.height}
        end
        ds = sds
    end
    --背景保证 等比例缩放 并且 宽度高度覆盖 整个屏幕
    local sca = math.max(vs.width/ds[1], vs.height/ds[2])
    local cx, cy = ds[1]/2, ds[2]/2
    local nx, ny = vs.width/2-cx*sca, vs.height/2-cy*sca
    print("centerBg", sca, nx, ny, vs.width, vs.height, ds[1], ds[2])

    setAnchor(setScale(sp, sca), {0, 0})
    --local wig = tolua.cast(sp, "Widget")
    setPos(sp, {nx, ny})

end

function upRightWidget(sp, sds)
    local ds = global.director.designSize
    if sds ~= nil then
        if type(sds) == 'userdata' then
            sds = {sds.width, sds.height}
        end
        ds = sds
    end

    local vs = getVS()
    local sca = math.min(vs.width/ds[1], vs.height/ds[2])
    local nx = vs.width-ds[1]*sca
    local ny = vs.height-ds[2]*sca
    setScale(sp, sca)
    setPos(sp, {nx, ny})
end

function centerWidget(sp, sds)
    local vs = getVS()
    local ds = global.director.designSize
    if sds ~= nil then
        if type(sds) == 'userdata' then
            sds = {sds.width, sds.height}
        end
        ds = sds
    end
    local sca = math.min(vs.width/ds[1], vs.height/ds[2])
    local cx, cy = ds[1]/2, ds[2]/2
    local nx, ny = vs.width/2-cx*sca, vs.height/2-cy*sca
    print("centerBg", sca, nx, ny, vs.width, vs.height, ds[1], ds[2])

    setScale(sp, sca)
    --local wig = tolua.cast(sp, "Widget")
    setPos(sp, {nx, ny})
end


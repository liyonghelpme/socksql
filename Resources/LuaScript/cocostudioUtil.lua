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
--show full screen pic
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

--full width screen at top
function upFullWidthWidget(sp, sds)
    local ds = global.director.designSize
    if sds ~= nil then
        if type(sds) == 'userdata' then
            sds = {sds.width, sds.height}
        end
        ds = sds
    end

    --480 * 600 
    --640 * 960
    local vs = getVS()
    print("upFullWidthWidget", sp, simple.encode(ds), vs.width, vs.height)

    local sca = vs.width/ds[1]
    --local sca = math.min(vs.width/ds[1], vs.height/ds[2])
    local cx = ds[1]/2
    local nx = vs.width/2-cx*sca
    local ny = vs.height-ds[2]*sca
    setScale(sp, sca)
    setPos(sp, {nx, ny})
    print("up position", nx, ny, sca)
end

function bottomFullWidthWidget(sp, sds)
    local ds = global.director.designSize
    if sds ~= nil then
        if type(sds) == 'userdata' then
            sds = {sds.width, sds.height}
        end
        ds = sds
    end

    local vs = getVS()
    local sca = vs.width/ds[1]
    setScale(sp, sca)
    local cx = ds[1]/2
    local nx = vs.width/2-cx*sca
    setPos(sp, {nx, 0})
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

function bottomWidget(sp, sds)
    local vs = getVS()
    local ds = global.director.designSize
    if sds ~= nil then
        if type(sds) == 'userdata' then
            sds = {sds.width, sds.height}
        end
        ds = sds
    end

    local vs = getVS()
    local sca = math.min(vs.width/ds[1], vs.height/ds[2])
    setScale(sp, sca)
    local cx = ds[1]/2
    local nx = vs.width/2-cx*sca
    setPos(sp, {nx, 0})
end

function addTouchEventListener(obj, func)
    local function touchEvent(sender, eventType)
        print("eventType touch", eventType)
        local del = func.delegate
        if eventType == TOUCH_EVENT_BEGAN then
            --print("began")
            if func.tb ~= nil then
                func.tb(del)
            end
        elseif eventType == TOUCH_EVENT_MOVED then
            if func.tm ~= nil then
                func.tm(del)
            end
        elseif eventType == TOUCH_EVENT_ENDED then
            if func.te ~= nil then
                func.te(del)
            end
        --on ios when finger > 5 then call this function
        elseif eventType == TOUCH_EVENT_CANCELED then
            if func.tc ~= nil then
                func.tc(del)
            end
        end
    end
    obj:addTouchEventListener(touchEvent)
end

function addEventListenerTextField(obj, func)
    local function textFieldEvent(sender, eventType)
        print("event", sender, eventType)
        if eventType == 0 then --attach_with_ime 
            --[[
            local textField = tolua.cast(sender,"TextField")
            local screenSize = CCDirector:sharedDirector():getWinSize()
            textField:runAction(CCMoveTo:create(0.225,CCPoint(widgetSize.width / 2.0, widgetSize.height / 2.0 + textField:getContentSize().height / 2.0)))
            self._displayValueLabel:setText("attach with IME")
            --]]
        elseif eventType == 1 then --ccs.TextFiledEventType.detach_with_ime then
            --[[
            local textField = tolua.cast(sender,"TextField")
            local screenSize = CCDirector:sharedDirector():getWinSize()
            textField:runAction(CCMoveTo:create(0.175, CCPoint(widgetSize.width / 2.0, widgetSize.height / 2.0)))
            self._displayValueLabel:setText("detach with IME")
            --]]
        elseif eventType == 2 then --ccs.TextFiledEventType.insert_text then
            --self._displayValueLabel:setText("insert words")
        elseif eventType == 3 then --ccs.TextFiledEventType.delete_backward then
            --self._displayValueLabel:setText("delete word")
        end
    end
    obj:addEventListenerTextField(textFieldEvent)
end

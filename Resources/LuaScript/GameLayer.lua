GameLayer = class()
function GameLayer:ctor()
    self.bg = CCLayer:create()
    self.needUpdate = true
    registerEnterOrExit(self)

    --addPlist("Image/duelking/loginUI/LoginScene0.plist")
    addPlist("LoginScene0.plist")
    local ui = TouchGroup:create() 
    --local f = "Image/duelking/loginUI/LoadingGame.ExportJson"

    local f= "NewUI_1.json"

    local addshow = GUIReader:shareReader():widgetFromJsonFile(f)    
    ui:addWidget(addshow)
    setAnchor(ui, {0, 0})
    addChild(self.bg, ui)


    local sz = GUIReader:shareReader():getFileDesignSize(f)
    local lb = getChildByNameRec(addshow, 'loginBg')
    print("lb is ", lb)

    --实现背景图片的全屏显示
    print("need", lb.needUpdate)
    --lb.needUpdate = false
    lb = tolua.cast(lb, "CCNode")
    centerBg(lb, sz)
    self.lb = lb
    --setPos(lb, {100, 100})

    print("sx", getScaleX(lb))
    --centerTemp(ui, sz)

    local ur = getChildByNameRec(addshow, "upRight")
    upRightWidget(ur, sz) 

    local function touchEvent(sender, eventType)
        print("eventType", eventType)
        if eventType == TOUCH_EVENT_BEGAN then
            print("began")
            
        elseif eventType == TOUCH_EVENT_MOVED then
        elseif eventType == TOUCH_EVENT_ENDED then
        --on ios when finger > 5 then call this function
        elseif eventType == TOUCH_EVENT_CANCELED then
        end
    end

    local but = getChildByNameRec(addshow, "back")
    but:addTouchEventListener(touchEvent)


    local cen = getChildByNameRec(addshow, "center")
    centerWidget(cen, sz) 
end


function GameLayer:update(diff)
    --print("lb sx", getScaleX(self.lb))
    --print("lb sy", getScaleY(self.lb))
end

PlayerScene = class()
function PlayerScene:ctor()
    self.bg = CCScene:create()
    self.layer = PlayerLayer.new()
    self.bg:addChild(self.layer.bg)
end


PlayerLayer = class()
function PlayerLayer:ctor()
    self.bg = CCLayer:create()
    local ui = TouchGroup:create()
    addChild(self.bg, ui)

    --addPlist("Image/duelking/menuUI/zhujiemian0.plist")
    addPlist("zhujiemian0.plist")
    --local f = "Image/duelking/playerUI/summoner_1.ExportJson"
    --local f = "Image/duelking/menuUI/zhujiemian.ExportJson"
    local f = 'MainUI_2.json'
    local addshow = GUIReader:shareReader():widgetFromJsonFile(f)
    --addChild(ui, addshow)
    ui:addWidget(addshow)

    local map = getChildByNameRec(addshow, 'Panel_map')
    map:setEnabled(false)
    self.map = map

    self.map:setEnabled(true)
    self.map:setVisible(true)
    self.map:setTouchEnabled(true)

    centerFullWidthWidget(self.map, sz)

    local bg = getChildByNameRec(addshow, "Panel_bg")
    local sz = GUIReader:shareReader():getFileDesignSize(f)
    centerBg(bg, sz)
    --bg:setEnabled(false)

    local up = getChildByNameRec(addshow, "up")
    upFullWidthWidget(up, sz)

    --centerWidget(up)
    local bottom = getChildByNameRec(addshow, "bottom")
    bottomFullWidthWidget(bottom, sz)

    --setPos(up, {0, -400})
    --setVisible(up, true)

    self.left = getChildByNameRec(addshow, "Left")
    local t = {
        delegate = self,
        te = self.onLeft,
    }
    addTouchEventListener(self.left, t)
    self.left:setEnabled(false)

    self.right = getChildByNameRec(addshow, "Right")
    local t = {
        delegate = self,
        te = self.onRight,
    }
    addTouchEventListener(self.right, t)
    --[[

    self.left:retain()
    removeSelf(self.left)
    ui:addWidget(self.left)
    setPos(self.left, {100, 100})
    self.left:release()
    --setVisible(self.left, true)

    self.right:retain()
    removeSelf(self.right)
    ui:addWidget(self.right)
    setPos(self.right, {100, 100})
    self.right:release()
    --]]

    --[[
    print("initial button")
    local button = Button:create()
    button:setTouchEnabled(true)
    button:loadTextures("btn_news_Nor.png", "btn_news_press.png", "", 1)
    button:setPosition(CCPoint(150, 150))
    local t = {
        delegate = self,
        te = self.onBut,
    }
    addTouchEventListener(button, t)
    ui:addWidget(button)
    button:setZOrder(100)
    --]]


    local below = getChildByNameRec(addshow, "below")
    --below:setEnabled(false)


    local p77 = getChildByNameRec(addshow, "PageView_77")
    --p77:setEnabled(false)
    self.p77 = p77

    local pb = getChildByNameRec(addshow, "port")
    print("pbpos", simple.encode(getPos(pb)))
    addTouchEventListener(pb, {delegate=self, te=self.onPort})


    local fri = getChildByNameRec(addshow, "Friend")
    print("friend", simple.encode(getPos(fri)))

    self.p79 = getChildByNameRec(addshow, "Panel_79")
    self.p78 = getChildByNameRec(addshow, "Panel_78")

    self.p77 = tolua.cast(getChildByNameRec(addshow, "PageView_77"), "PageView")
    local function on77(sender, eventType)
        print("on77", sender, eventType)
    end
    self.p77:addEventListenerPageView(on77)

end
function PlayerLayer:onBut()
    print("onBut")
end

function PlayerLayer:onPort()
    print("onPort")
    self.map:setEnabled(true)
    self.map:setVisible(true)
    self.map:setTouchEnabled(true)
end

function PlayerLayer:onLeft()
    if not self.inMove then
        print("onLeft")
        self.right:setEnabled(true)
        self.left:setEnabled(false)
        self.inMove = true
        local function cm()
            self.inMove = false
        end
        self.p78:runAction(sequence({moveby(0.5, 532, 0)}))
        self.p79:runAction(sequence({moveby(0.5, 532, 0), callfunc(nil, cm)}))
    end
end

function PlayerLayer:onRight()
    if not self.inMove then
        self.left:setEnabled(true)
        self.right:setEnabled(false)
        self.inMove = true
        local function cm()
            self.inMove = false
        end
        self.p78:runAction(sequence({moveby(0.5, -532, 0)}))
        self.p79:runAction(sequence({moveby(0.5, -532, 0), callfunc(nil, cm)}))
    end
end



ReadyMenu = class()
function ReadyMenu:ctor(l)
    self.layer = l
    local vs = getVS()
    self.bg = CCLayer:create()
    local sz = {width=1024, height=640}
    self.temp = setPos(addNode(self.bg), {0, fixY(sz.height, 0+sz.height)+0})
    local sp = setAnchor(setSize(setPos(addSprite(self.temp, "ready.png"), {512, fixY(sz.height, 199)}), {550, 88}), {0.50, 0.50})
    self.ready = sp
    local num = ui.newBMFontLabel({text="0", font="red.fnt", size=50})
    local sp = setAnchor(setSize(setPos(addChild(self.temp, num), {512, fixY(sz.height, 96)}), {78, 100}), {0.50, 0.50})
    self.num = sp

    local ani = createAnimation("hand", "hand%d.png", 0, 24, 3, 0.5, false)
    local sp = setAnchor(setSize(setPos(addChild(self.temp, createSprite("hand0.png")), {512, fixY(sz.height, 334)}), {210, 220}), {0.50, 0.50})
    self.hand = sp
    sp:runAction(repeatForever(Animate("hand")))
    centerTemp(self.temp)

    registerTouch(self)
    registerEnterOrExit(self)
end
function ReadyMenu:touchBegan(x, y)
    return true
end
function ReadyMenu:touchMoved(x, y)
end
function ReadyMenu:touchEnded(x, y)
    if not self.remove then
        self.remove = true
        self.num:runAction(sinein(moveby(0.5, 0, 200)))
        self.ready:runAction(fadeout(0.5))
        self.hand:runAction(sinein(moveby(0.5, 0, -400)))
        local function clo()
            print("self layer", self.layer.state )
            self.layer:startGame()
            global.director:popView()
            --self.layer.state = 1
        end
        self.bg:runAction(sequence({delaytime(0.5), callfunc(nil, clo)}))
    end
end



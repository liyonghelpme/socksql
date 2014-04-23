OverMenu = class()
function OverMenu:ctor(l)
    self.layer = l
    local vs = getVS()
    self.bg = CCNode:create()
    local sz = {width=1024, height=640}
    self.temp = setPos(addNode(self.bg), {0, fixY(sz.height, 0+sz.height)+0})
    local sp = setAnchor(setSize(setPos(addSprite(self.temp, "over.png"), {512, fixY(sz.height, 134)}), {550, 88}), {0.50, 0.50})
    self.over = sp

    local but = ui.newButton({image="BT1-01.png", text="", font="f1", size=18, delegate=self, callback=self.onBut, shadowColor={0, 0, 0}, color={255, 255, 255}, touchBegan=self.bt})
    local ani = createAnimation("btn", "BT1-0%d.png", 1, 3, 1, 0.2, false)

    but:setContentSize(240, 240)
    setPos(addChild(self.temp, but.bg), {512, fixY(sz.height, 419)})
    self.but = but

    local sp = setAnchor(setSize(setPos(addSprite(self.temp, "board.png"), {497, fixY(sz.height, 243)}), {531, 100}), {0.50, 0.50})
    self.board = sp

    local num = ui.newBMFontLabel({text=self.layer.score, size=25, font="red.fnt"})
    local sp = setAnchor(setPos(addChild(self.temp, num), {372, fixY(sz.height, 242)}), {0.00, 0.50})

    local u = CCUserDefault:sharedUserDefault()
    local s = u:getStringForKey("score")
    if s == "" then
        s = 0
    else
        s = simple.decode(s)
    end
    local best = math.max(self.layer.score, s)
    u:setStringForKey("score", simple.encode(best))

    local num2 = ui.newBMFontLabel({text=best, size=25, font="red.fnt"})
    local sp = setAnchor(setPos(addChild(self.temp, num2), {615, fixY(sz.height, 244)}), {0.00, 0.50})

    centerTemp(self.temp)
end
function OverMenu:bt()
    self.but.sp:runAction(Animate("btn"))
end

function OverMenu:onBut()
    if not self.resetYet then
        self.resetYet = true
        self.over:runAction(sinein(moveby(0.5, 0, 200)))
        self.but.bg:runAction(sinein(moveby(0.5, 0, -300)))
        self.board:runAction(fadeout(0.5))

        local function resetGame()
            closeDialog()
            self.layer:resetGame()
        end
        self.bg:runAction(sequence({delaytime(0.5), callfunc(nil, resetGame)})) 
    end
end


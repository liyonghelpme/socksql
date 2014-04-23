ScoreUI = class()
function ScoreUI:ctor()
    local vs = getVS()
    self.bg = CCNode:create()
    local sz = {width=1024, height=640}
    self.temp = setPos(addNode(self.bg), {0, fixY(sz.height, 0+sz.height)+0})
    local num = ui.newBMFontLabel({text="0", size=25, font="red.fnt"})
    local sp = setAnchor(setPos(addChild(self.temp, num), {991, fixY(sz.height, 62)}), {1.00, 0.50})
    self.num = num

    rightTopUI(self.temp)
end
function ScoreUI:changeScore(s)
    self.num:setString(s)
    self.num:runAction(sequence({scaleto(0.2, 1.2*0.5, 1.2*0.5), scaleto(0.2, 1*0.5, 1*0.5)}))
end

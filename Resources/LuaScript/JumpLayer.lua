require "OverMenu"
require "ReadyMenu"
require "ScoreUI"
BWidth = {
    705,
    914,
}

require "JumpPlayer"
JumpLayer = class()
function JumpLayer:ctor()
    self.bg = CCLayer:create()
    self.needUpdate = true
    registerEnterOrExit(self)

    local vs = getVS()
    local sca = vs.height/640
    
    self.bgLayer = CCNode:create()
    self.bg:addChild(self.bgLayer)
    local bg1 = createSprite("bg1.png")
    self.bg1 = bg1
    local bg2 = createSprite("bg2.png")
    self.bg2 = bg2

    setScale(setAnchor(setPos(addChild(self.bgLayer, bg1), {0, 0}), {0, 0}), 1.01)
    setScale(setAnchor(setPos(addChild(self.bgLayer, bg2), {1024, 0}), {0, 0}), 1.01)
    
    setScale(self.bgLayer, sca)

    self.floorLayer = CCNode:create()
    self.bg:addChild(self.floorLayer)
    setScale(self.floorLayer, sca)

    self.blocks = {}
    --28 659 width
    local bk = createSprite("block0.png")
    setScale(setAnchor(setPos(addChild(self.floorLayer, bk), {0, 0}), {0, 0}), 1.01)
    table.insert(self.blocks, {bk, 0})
    self.floorPos = 220

    local pole = createSprite("pole1.png")
    setAnchor(setPos(addChild(self.floorLayer, pole, 1), {670, 640-489}), {0.5, 0})
    self.pole = pole



    local pl = setScale(addNode(self.bg), sca)
    self.pl = pl
    self.player = JumpPlayer.new(self)
    addChild(pl, self.player.bg)

    self.sca = sca

    self.speed = 300*sca
    self.state = 0

    local sui = ScoreUI.new(self)
    self.bg:addChild(sui.bg, 10)
    self.score = 0
    self.scoreUI = sui
end

function JumpLayer:resetGame()
    self.state = 0
    self.score = 0
    self.scoreUI:changeScore(0)
    self.showReady = false

    setPos(self.floorLayer, {0, 0})
    

    setPos(self.bgLayer, {0, 0})
    setPos(self.bg1, {0, 0})
    setPos(self.bg2, {1024, 0})

    for k, v in ipairs(self.blocks) do
        removeSelf(v[1]) 
    end
    self.blocks = {}

    local bk = createSprite("block0.png")
    setScale(setAnchor(setPos(addChild(self.floorLayer, bk), {0, 0}), {0, 0}), 1.01)
    table.insert(self.blocks, {bk, 0})
    self.floorPos = 220

    self.player:resetGame()
end

function JumpLayer:startGame()
    print("start Game")
    self.state = 1
    self.startP = getPos(self.floorLayer)
end

function JumpLayer:adjustScene(diff)
    local mx = -self.speed*diff
    local p = getPos(self.floorLayer)
    p[1] = p[1]+mx
    setPos(self.floorLayer, p)

    if self.state ~= 0 then
        local sc = math.floor(-(p[1]-self.startP[1])*self.sca/200)
        if sc > self.score then
            self.score = self.score+1
            self.scoreUI:changeScore(self.score)
        end
    end

    --bgLayer
    setPos(self.bgLayer, {p[1]*0.5, 0})
    local bg1 = getPos(self.bg1)
    if p[1]*0.5+(bg1[1]+1024)*self.sca < 0 then
        local bg2 = getPos(self.bg2)
        setPos(self.bg1, {bg2[1]+1024, 0})
        self.bg1, self.bg2 = self.bg2, self.bg1
    end

end

function JumpLayer:generateBlock(diff)
    if #self.blocks == 0 then
        return
    end
    local fp = getPos(self.floorLayer)
    local vs = getVS()
    --check Block position
    --[[
    for k, v in ipairs(self.blocks) do
        local p = getPos(v)
        if fp[1]+p[1] <= 
    end
    --]]
    if #self.blocks < 5 then
        local rd = math.random(0, 1)
        local block = createSprite("block"..rd..".png")
        local gap = 50
        if self.state == 0 then
            gap = -50
        end
        setAnchor(setPos(addChild(self.floorLayer, block), {self.floorPos+gap, 0}), {0, 0})
        table.insert(self.blocks, {block, rd})
        local width
        self.floorPos = self.floorPos+gap+BWidth[rd+1]
    else
        local pos = getPos(self.blocks[1][1])
        local bp = getPos(self.floorLayer)
        if bp[1]+(pos[1]+BWidth[self.blocks[1][2]+1])*self.sca < 0 then
            local bk = table.remove(self.blocks, 1)
            removeSelf(bk[1])
        end
    end

end


function JumpLayer:update(diff)
    if not self.player.dead then
        if self.state == 0 then
            if not self.showReady then
                self.showReady = true
                global.director:pushView(ReadyMenu.new(self), 1, 0)
            end

            self:adjustScene(diff)
            self:generateBlock(diff)
        else
            self:adjustScene(diff)
            self:generateBlock(diff)
        end
    end
end

function JumpLayer:playerDead()
    global.director:pushView(OverMenu.new(self), 1, 0)
end

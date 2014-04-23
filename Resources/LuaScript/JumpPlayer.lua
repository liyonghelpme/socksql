JumpPlayer = class()
function JumpPlayer:ctor(l)
    self.layer = l
    self.bg = CCLayer:create()
    self.changeDirNode = addChild(self.bg, createSprite("p0.png"))
    setAnchor(self.changeDirNode, {0.5, 0})
    setPos(self.bg, {100, 150})

    local ani = createAnimation("run", "p%d.png", 0, 19, 1, 1, false)
    self.ani = repeatForever(Animate("run"))

    local ani2 = createAnimation("pickRun", "pick%d.png", 0, 19, 1, 1, false)
    local ani3 = createAnimation("jump", "jump%d.png", 0, 48, 3, 2, false)


    self.changeDirNode:runAction(self.ani)
    self.hasPole = false
    self.dead = false
    self.inSpace = false

    self.needUpdate = true

    registerEnterOrExit(self)
    registerTouch(self)
end
function JumpPlayer:resetGame()
    self.hasPole = false
    self.dead = false
    self.inSpace = false
    self.changeDirNode:stopAction(self.ani)
    self.ani = repeatForever(Animate("run"))
    self.changeDirNode:runAction(self.ani)
    setAnchor(setPos(self.changeDirNode, {0, 0}), {0.5, 0})

    self.layer.pole:runAction(fadein(0.2))
end

--move shadow
function JumpPlayer:touchBegan(x, y)
    if self.dead then
        return
    end
    if not self.inSpace then
        self.inSpace = true
        local function finishRun()
            self.ani = repeatForever(Animate("pickRun"))
            self.changeDirNode:runAction(self.ani)
            self.inSpace = false
        end
        --self.changeDirNode:runAction(sequence({jumpTo(2, 0, 0, 200, 1), callfunc(nil, finishRun)}))
        self.changeDirNode:stopAction(self.ani)
        local function setTex()
            setAnchor(setTexOrDis(self.changeDirNode, "jump0.png"), {48/613, 0})
            self.ani = Animate("jump")
            self.changeDirNode:runAction(self.ani)
        end

        self.changeDirNode:runAction(sequence({callfunc(nil, setTex), delaytime(2), callfunc(nil, finishRun)}))
    end
end

function JumpPlayer:touchMoved(x, y)
end
function JumpPlayer:touchEnded(x, y)
end


function JumpPlayer:update(diff)
    if not self.hasPole then
        local p = getPos(self.layer.floorLayer)
        --print("jpos", simple.encode(p), -570*self.layer.sca )

        if p[1] <= -540*self.layer.sca then
            self.hasPole = true

            self.layer.pole:runAction(fadeout(0.2))
            self.changeDirNode:stopAction(self.ani)
            local function restore()
                setTexOrDis(self.changeDirNode, "pick0.png")
                self.ani = repeatForever(Animate("pickRun"))
                self.changeDirNode:runAction(self.ani)
                setAnchor(self.changeDirNode, {28/308, 0})
            end
            local function setTex()
                setTexOrDis(self.changeDirNode, "pick.png")
            end
            self.changeDirNode:runAction(sequence({callfunc(nil, setTex), delaytime(0.2), callfunc(nil, restore)}))
        end
    else
        --+30 -30 
        local lsca = self.layer.sca
        local inBlock = false
        local fp = getPos(self.layer.floorLayer)
        for k, v in ipairs(self.layer.blocks) do
            local p = getPos(v[1]) 
            local width = BWidth[v[2]+1]
            local sp = p[1]+24
            local ep = p[1]+width-24
            --in block
            if fp[1]/lsca+sp <= 100 and fp[1]/lsca+ep >= 100 then
                inBlock = true
                break
            elseif fp[1]/lsca+sp > 100 then
                break
            end
        end
        --not in block and not in sky then dead 
        if self.layer.state ~= 0 and not inBlock and not self.inSpace then
            if not self.dead then
                self.dead = true
                self.layer:playerDead()
                self.changeDirNode:stopAction(self.ani)
                local function setTex()
                    setTexOrDis(self.changeDirNode, "fall.png")
                end
                self.changeDirNode:runAction(sequence({callfunc(nil, setTex), moveby(0.5, 0, -280), jumpTo(1, 0, -280, 300, 1)}))
            end
        end

    end
end


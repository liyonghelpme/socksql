require "TestLayer"
TestScene = class()
function TestScene:ctor()
    self.bg = CCScene:create()
    local vs = getVS()
    self.temp = addNode(self.bg)
    

    local ds = {640, 960}

    --[[
    local sp = createSprite("round.png")
    setColor(setAnchor(setSize(setPos(addChild(self.temp, sp), {320, 960-530}), {596, 596}), {0.5, 0.5}), {187, 173, 160})
    --]]

    local tex = CCTextureCache:sharedTextureCache():addImage("round.png")
    local ca = CCSpriteFrameCache:sharedSpriteFrameCache()
    for i=0, 8, 1 do
        local row = math.floor(i/3)
        local col = i%3
        local r = CCRectMake(col*32, row*32, 32, 32)
        local lu = createSpriteFrame(tex, r, 'r'..i)
    end
    local tn = addNode(self.temp)
    --[[
    for i=0,8,1 do
        local lu = createSprite("r"..i)
        local row = math.floor(i/3)
        local col = i%3
        setAnchor(setPos(addChild(tn, lu), {32*col, 32*(3-row)}), {0, 0})

    end
    --]]

    setAnchor(setPos(addChild(tn, createSprite("r0")), {22, 596+132}), {0, 1})
    setAnchor(setPos(addChild(tn, createSprite("r2")), {596+22, 596+132}), {1, 1})
    setSize(setAnchor(setPos(addChild(tn, createSprite("r1")), {22+32, 596+132}), {0, 1}), {596-64, 32})
    setSize(setAnchor(setPos(addChild(tn, createSprite("r3")), {22, 596+132-32}), {0, 1}), {32, 596-64})
    setSize(setAnchor(setPos(addChild(tn, createSprite("r4")), {22+32, 596+132-32}), {0, 1}), {596-64, 596-64})
    setSize(setAnchor(setPos(addChild(tn, createSprite("r5")), {596+22, 596+132-32}), {1, 1}), {32, 596-64})
    setSize(setAnchor(setPos(addChild(tn, createSprite("r6")), {22, 132}), {0, 0}), {32, 32})
    setSize(setAnchor(setPos(addChild(tn, createSprite("r7")), {22+32, 132}), {0, 0}), {596-64, 32})
    setSize(setAnchor(setPos(addChild(tn, createSprite("r8")), {596+22, 132}), {1, 0}), {32, 32})

    
    for i=0, 3, 1 do
        for j=0, 3, 1 do
            print("i j", i, j)
            local sp1 = createSprite("round.png")
            setColor(addChild(self.temp, setPos(sp1, {160*i+80, 132+596-58-160*j}), sp1), {205, 192, 180})
        end
    end
    
    centerTemp(self.temp)
    self.layer = TestLayer.new()
    self.temp:addChild(self.layer.bg)
end


require "TestLayer"
TestScene = class()
function TestScene:ctor()
    self.bg = CCScene:create()
    local ds = {640, 960}

    local vs = getVS()
    self.temp = addNode(self.bg)
    self.score = 0
    
    self.upRight = addNode(self.bg)
    rightTopUI(self.upRight)
    local sp = addChild(self.upRight, createSprite("round.png"))
    setSize(setColor(setPos(sp, {396, ds[2]-118}), {187, 173, 160}), {128, 96})
    setAnchor(setPos(addChild(self.upRight, ui.newBMFontLabel({text="SCORE", size=20, font="bound.fnt"})), {396, ds[2]-86}), {0.5, 0.5})
    self.cs = setAnchor(setPos(addChild(self.upRight, ui.newBMFontLabel({text="0", size=40, font="bound.fnt"})), {396, ds[2]-130}), {0.5, 0.5})

    local sp = setSize(setColor(setPos(addChild(self.upRight, createSprite("round.png")), {540, ds[2]-114}), {187, 173, 160}), {128, 96})
    setAnchor(setPos(addChild(self.upRight, ui.newBMFontLabel({text="BEST", size=20, font="bound.fnt"})), {540, ds[2]-86}), {0.5, 0.5})
    self.bs = setAnchor(setPos(addChild(self.upRight, ui.newBMFontLabel({text="0", size=40, font="bound.fnt"})), {540, ds[2]-130}), {0.5, 0.5})
    
    self.leftUp = addNode(self.bg)
    leftTopUI(self.leftUp)
    --local sp = setSize(setColor(setPos(addChild(self.leftUp, createSprite("round.png")), {142, ds[2]-114}), {143, 122, 102}), {192, 96})
    local but = ui.newButton({image="round.png", conSize={192, 96}, delegate=self, callback=self.onNew})
    setScriptTouchPriority(but.bg, -256)

    addChild(self.leftUp, setPos(but.bg, {142, ds[2]-114}))
    setColor(but.sp, {143, 122, 102})
    setAnchor(setPos(addChild(but.bg, ui.newBMFontLabel({text="New Game", size=30, font="bound.fnt"})), {0, 0}), {0.5, 0.5})


    

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

    setColor(setAnchor(setPos(addChild(tn, createSprite("r0")), {22, 596+132}), {0, 1}), {187, 173, 160})
    setColor(setAnchor(setPos(addChild(tn, createSprite("r2")), {596+22, 596+132}), {1, 1}), {187, 173, 160})
    setColor(setSize(setAnchor(setPos(addChild(tn, createSprite("r1")), {22+32, 596+132}), {0, 1}), {596-64, 32}),{187, 173, 160})
    setColor(setSize(setAnchor(setPos(addChild(tn, createSprite("r3")), {22, 596+132-32}), {0, 1}), {32, 596-64}), {187, 173, 160})
    setColor(setSize(setAnchor(setPos(addChild(tn, createSprite("r4")), {22+32, 596+132-32}), {0, 1}), {596-64, 596-64}), {187, 173, 160})
    setColor(setSize(setAnchor(setPos(addChild(tn, createSprite("r5")), {596+22, 596+132-32}), {1, 1}), {32, 596-64}), {187, 173, 160})
    setColor(setSize(setAnchor(setPos(addChild(tn, createSprite("r6")), {22, 132}), {0, 0}), {32, 32}), {187, 173, 160})
    setColor(setSize(setAnchor(setPos(addChild(tn, createSprite("r7")), {22+32, 132}), {0, 0}), {596-64, 32}), {187, 173, 160})
    setColor(setSize(setAnchor(setPos(addChild(tn, createSprite("r8")), {596+22, 132}), {1, 0}), {32, 32}), {187, 173, 160})

    
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

    self:updateScore(0)
end
function TestScene:updateScore(s)
    self.score = self.score+s

    local u = CCUserDefault:sharedUserDefault()
    local bs = u:getStringForKey("score")
    if bs == "" then
        bs = "0"
    end
    bs = simple.decode(bs)
    local ms = math.max(bs, self.score)
    u:setStringForKey("score", ms)
    
    self.bs:setString(ms)
    self.cs:setString(self.score)
end

function TestScene:onNew()
    removeSelf(self.layer.bg)
    self.layer = TestLayer.new()
    self.temp:addChild(self.layer.bg)
    self.score = 0
    self:updateScore(0)
end


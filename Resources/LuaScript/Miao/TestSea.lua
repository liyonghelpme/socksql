TestSea = class()
function TestSea:ctor()
    self.bg = CCScene:create()

    local tex = CCTextureCache:sharedTextureCache():addImage("water.jpg")
    
    local param = ccTexParams()
    param.minFilter = GL_LINEAR
    param.magFilter = GL_LINEAR
    param.wrapS = GL_REPEAT
    param.wrapT = GL_REPEAT
    tex:setTexParameters(param)
    local sea = CCSprite:createWithTexture(tex, CCRectMake(0, 0, MapWidth+2, MapHeight))
    self.bg:addChild(sea)
    self.sea = sea

    setAnchor(setPos(sea, {0, 0}), {0, 0})

    self.needUpdate = true
    registerEnterOrExit(self)

    self.passTime = 0
end

--因为旧的河水 只是 整个屏幕的动静 
--使用3D projection 非透视 而是 平视 来做 镜头
function TestSea:update(diff)
    self.passTime = self.passTime+diff
    if self.passTime >= 1 then
        self.passTime = 0
        --self.sea:runAction(CCRipple3D:create(2, CCSizeMake(20, 20), ccp(300, 300), 100, 4, 10))
        self.sea:runAction(CCWaves3D:create(2, CCSizeMake(20, 20), 4, 10))
    end
end

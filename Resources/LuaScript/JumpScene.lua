require "JumpLayer"
JumpScene = class()
function JumpScene:ctor()
    self.bg = CCScene:create()
    self.layer = JumpLayer.new()
    self.bg:addChild(self.layer.bg)
end



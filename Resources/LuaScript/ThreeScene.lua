require "ThreeLayer"
ThreeScene = class()
function ThreeScene:ctor()
    self.bg = CCScene:create()
    self.layer = ThreeLayer.new(self)
    self.bg:addChild(self.layer.bg)
    self.dialogController = DialogController.new(self)
    self.bg:addChild(self.dialogController.bg)
end


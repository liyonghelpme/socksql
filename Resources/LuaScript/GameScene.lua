require "GameLayer"
GameScene = class()
function GameScene:ctor()
    self.bg = CCScene:create()

    self.layer = GameLayer.new()
    addChild(self.bg, self.layer.bg)

end

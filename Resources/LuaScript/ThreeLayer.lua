ThreeLayer = class()
function ThreeLayer:ctor()
    self.bg = CCLayer:create()
    math.randomseed(2)

    local top = addNode(self.bg)
    self.top = top 
    local sp = setPos(setAnchor(addChild(top, createSprite("lowBoard.png")), {0.5, 1}), {320, 960-5}) 
    local sp = setPos(setAnchor(addChild(top, createSprite("upBoard.png")), {0.5, 1}), {320, 960-166}) 
    self.num = ui.newBMFontLabel({text="0", size=50, font="num.fnt"})
    setPos(setAnchor(addChild(self.top, self.num), {0, 0.5}), {32, 960-100})

    centerTop(top)

    self.needUpdate = true
    registerEnterOrExit(self)
    registerTouch(self)

    self.state = 0
    self.grids = {}
    self.score = 0

    local u = CCUserDefault:sharedUserDefault() 
    local s = u:getStringForKey("score")
    if s ~= "" then
        s = simple.decode(s)
    else
        s = 0
    end
    self.best = s

    self.bnum = ui.newBMFontLabel({text=self.best, size=50, font="num.fnt"})
    setPos(setAnchor(addChild(self.top, self.bnum), {1, 0.5}), {640-32, 960-100})

    local but = ui.newButton({image="but.png", text="New Game", size=30, delegate=self, callback=self.onBut})
    setPos(addChild(self.top, but.bg), {320, 960-100})
end

function ThreeLayer:touchBegan(x, y)
    print("touchBegan", self.state)
    if self.state == 5 then
        local np = self.top:convertToNodeSpace(ccp(x, y))
        self.lastPos = {np.x, np.y}
        self.swap = false
        return true
    end
end

function ThreeLayer:touchMoved(x, y)
    if self.state == 5 and not self.swap then
        local xy = self.top:convertToNodeSpace(ccp(x, y))
        x = xy.x
        y = xy.y
        local dx = x-self.lastPos[1]
        local dy = y-self.lastPos[2]
        local mx = math.abs(dx)
        local my = math.abs(dy)
        
        local gx = math.floor((self.lastPos[1])/91)
        local gy = math.floor((self.lastPos[2]-138)/94)
        --setPos(sp, {i*91+46, j*94+138+46})
        local n = gy*7+gx
        local bck = self.grids[n]
        if bck ~= nil then
            if mx > my then
                if mx > 10 then
                    local dir = Sign(dx)
                    local nx = gx+dir
                    local tid = gy*7+nx
                    local nsp = self.grids[tid]
                    
                    if nsp ~= nil then
                        self.src = {gx, gy, bck, 0, dir, n}
                        self.tar = {nx, gy, nsp, 0, -dir, tid}

                        bck[1]:runAction(moveby(0.1, 91*dir, 0))
                        nsp[1]:runAction(moveby(0.1, -91*dir, 0))
                        self.swap = true
                    end
                end
            else
                if my > 10 then
                    local dir = Sign(dy)
                    local ny = gy+dir
                    local tid = ny*7+gx
                    local nsp = self.grids[tid]
                    if nsp ~= nil then
                        self.src = {gx, gy, bck, 1, dir, n}
                        self.tar = {gx, ny, nsp, 1, -dir, tid}

                        bck[1]:runAction(moveby(0.1, 0, 94*dir))
                        nsp[1]:runAction(moveby(0.1, 0, -94*dir))
                        self.swap = true
                    end
                end
            end
        end
    end
end

function ThreeLayer:touchEnded(x, y)
    if self.swap then
        --self.state = 1

        --for check Direction so swap two grid
        local nid = self.src[6]
        local tid = self.tar[6]
        local oldSrc = self.grids[nid]
        local oldTar = self.grids[tid]

        local temp = self.grids[nid]
        self.grids[nid] = self.grids[tid]
        self.grids[tid] = temp

        local dis1 = self:checkDirection(self.src[1], self.src[2])
        local dis2 = self:checkDirection(self.tar[1], self.tar[2])
        if dis1 or dis2 then
            self.state = 1

        --restore 
        else
            self.grids[nid] = oldSrc
            self.grids[tid] = oldTar

            if self.src[4] == 0 then
                self.src[3][1]:runAction(moveby(0.1, -91*self.src[5], 0))
                self.tar[3][1]:runAction(moveby(0.1, 91*self.src[5], 0))
            else
                self.src[3][1]:runAction(moveby(0.1, 0, -94*self.src[5]))
                self.tar[3][1]:runAction(moveby(0.1, 0, 94*self.src[5]))
            end
        end
    end
end




local waitTime = 0.5
--check if can be disappear
--check if mark disappear yet check different direction not row will disappear
function ThreeLayer:checkDirection(x, y)
    local n = y*7+x
    local mark = self.grids[n][2]
    --same Row
    local disappear = false
    local row = {}
    local left = 0
    for i=x-1, 0, -1 do
        local nl = y*7+i
        if self.grids[nl][2] == mark then
            left = left+1
            table.insert(row, nl)
        else
            break
        end
    end
    
    local right = 0
    for i=x+1, 6, 1 do
        local nr = y*7+i
        if self.grids[nr][2] == mark then
            right = right+1
            table.insert(row, nr)
        else
            break
        end
    end

    local col = {}
    local bottom = 0
    for i=y-1, 0, -1 do
        local c = i*7+x 
        if self.grids[c][2] == mark then
            bottom = bottom+1
            table.insert(col, c)
        else
            break
        end
    end
    local top = 0
    for i=y+1, 6, 1 do
        local c = i*7+x
        if self.grids[c][2] == mark then
            top = top+1
            table.insert(col, c)
        else
            break
        end
    end

    if left+right >= 2 then
        disappear = true
    end
    if bottom+top >= 2 then
        disappear = true
    end
    return disappear
end

function ThreeLayer:swapBlock(a, b)
    local src = a[2]*7+a[1]
    local tar = b[2]*7+b[1]
    if self.grids[src] == nil or self.grids[tar] == nil then
        return false
    end
    self.grids[src], self.grids[tar] = self.grids[tar], self.grids[src]
    return true
end

--记录玩家得分的板子
function ThreeLayer:update(diff)
    if self.state == 0 then
        for i=0, 6, 1 do
            for j=0, 6, 1 do
                local rd = math.random(0, 3)
                local sp = createSprite("gem"..rd..".png")
                addChild(self.top, sp)
                setPos(sp, {i*91+46, j*94+138+46})
                self.grids[j*7+i] = {sp, rd}
            end
        end        

        self.state = 1
        self.passTime = 0
    --check disappear
    elseif self.state == 1 then
        self.fo = {}
        local fo = self.fo
        local find = false
        for i=0, 6, 1 do
            for j=0, 6, 1 do
                local dis = self:checkDirection(i, j)
                if dis then
                    local n = j*7+i
                    local obj = self.grids[n][1]
                    obj:runAction(sequence({fadeout(0.5), callfunc(nil, removeSelf, self.grids[n][1])}))
                    obj:runAction(sequence({scaleto(0.1, 1.2, 1.2), scaleto(0.1, 1, 1)}))

                    fo[n] = true
                    find = true
                    self.score = self.score+1
                    --self.grids[n] = nil
                end
            end
        end
        self.num:setString(self.score)
        self.num:runAction(sequence({scaleto(0.1, 1.2, 1.2), scaleto(0.1, 1, 1)}))
        if self.score > self.best then
            self.best = math.max(self.score, self.best)
            self.bnum:setString(self.best)
            self.bnum:runAction(sequence({scaleto(0.1, 1.2, 1.2), scaleto(0.1, 1, 1)}))
        end

        if find then
            self.state = 2
            self.passTime = 0
        else
            --check has possible to disappear swap which block two direction 
            --4 direction to swap
            local disapp = false
            for i=0, 6, 1 do
                for j=0, 6, 1 do
                    
                    local sdir = {
                        {1, 0},
                        {0, 1},
                        {-1, 0},
                        {0, -1},
                    }
                    for k, v in pairs(sdir) do
                        local dis = self:swapBlock({i, j}, {i+v[1], j+v[2]})
                        if dis then
                            dis = self:checkDirection(i, j)
                        end
                        --no matter whether can be disappear need to swap back
                        self:swapBlock({i, j}, {i+v[1], j+v[2]})
                        if dis then
                            disapp = true
                            break
                        else
                            --self:swapBlock({i, j}, {i+v[1], j+v[2]})
                        end
                    end

                    if disapp then
                        break
                    end
                end
                if disapp then
                    break
                end
            end

            if disapp then
                self.state = 5
                self.passTime = 0
            else
                self.state = 6
                local lab = ui.newTTFLabel({text="Game Over", size=80, color={102, 10, 10}})
                setPos(setAnchor(addChild(self.top, lab), {0.5, 0.5}), {320, 280})
                setOpacity(lab, 0)
                lab:runAction(sequence({fadein(0.2), moveby(0.3, 0, 200)}))
            end
        end

    elseif self.state == 2 then
        self.passTime = self.passTime+diff
        if self.passTime < waitTime then
            return
        end

        local fo = self.fo
        for i=0, 6, 1 do
            for j=0, 6, 1 do
                local sid = j*7+i
                if not fo[sid] then
                    local c = 0
                    --same column which disappear
                    for m=0, j-1, 1 do
                        local n = m*7+i
                        if fo[n] then
                            c = c+1
                        end
                    end
                    if c > 0 then
                        local nj = j-c
                        local bck = self.grids[sid]
                        bck[1]:runAction(sequence({sinein(moveby(0.2, 0, -c*94)), scaleto(0.1, 1.2, 1.2), scaleto(0.1, 1, 1)}))
                        local nid = nj*7+i
                        self.grids[nid] = bck
                        --self.grids[sid] = nil
                    end
                end

            end
        end
        self.state = 3
        self.passTime = 0
    elseif self.state == 3 then
        self.passTime = self.passTime+diff
        if self.passTime < waitTime then
            return
        end
        for i=0, 6, 1 do
            local c = 0
            for m =0, 6, 1 do
                local n = m*7+i
                if self.fo[n] then
                    c = c+1
                end
            end
            if c > 0 then
                for j=0, c-1, 1 do
                    local rd = math.random(0, 3)
                    local sp = createSprite("gem"..rd..".png")
                    local bs = 7-c+j
                    setPos(addChild(self.top, sp),{i*91+46, bs*94+138+46} )
                    self.grids[bs*7+i] = {sp, rd}
                    sp:setOpacity(0)
                    sp:runAction(fadein(0.5))
                    sp:runAction(sequence({scaleto(0.1, 1.2, 1.2), scaleto(0.1, 1, 1)}))
                    print("show ", i, bs, c)
                end
            end
        end

        self.state = 4
        self.passTime = 0
    elseif self.state == 4 then
        self.passTime = self.passTime+diff
        if self.passTime > waitTime then
            self.state = 1
            self.passTime = 0
        end
    elseif self.state == 5 then
        if not self.show then
            self.show = true
            --addBanner("swap now") 
        end
    elseif self.state == 6 then
    end
end
function ThreeLayer:onBut()
    local sc = ThreeScene.new()
    global.director:replaceScene(sc)
end

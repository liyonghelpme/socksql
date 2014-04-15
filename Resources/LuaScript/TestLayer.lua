
local movet = 0.2
local dtime = 0.2
local showTime = 0.4
local totalMTime = 0.3

TestLayer = class()
function TestLayer:ctor()
    self.bg = CCLayer:create()
    self.needUpdate = true
    registerEnterOrExit(self)
    registerTouch(self)

    self.state = 0
    
    self.map = {}
    for i=1, 16, 1 do
        self.map[i] = 0
    end
    self.maxValue = 1
    self.allLabel = {}
end
local cmap = {
    [2] = {238, 228, 218},
    [4] = {237, 224, 200},
    [8] = {242, 177, 121},
    [16] = {245, 149, 99},
    [32] = {246, 124, 95},
    [64] = {246, 94, 59},
    [128] = {246, 64, 49},
    [256] = {246, 34, 39},
    [512] = {246, 24, 29},
    [1024] = {246, 14, 19},
    [2048] = {246, 4, 9},
}

--touch move 
function TestLayer:update(diff)
    if self.state == 0 then
        local rd = math.random(1, 16)
        local c = 0
        while self.map[rd] ~= 0 and c < 16 do
            rd = rd%16
            rd = rd+1
            c = c+1
        end

        if c == 16 then
            self.state = 2
            self.word = ui.newBMFontLabel({text="You Fail", size=150, color={246, 4, 9}})
            setAnchor(setPos(addChild(self.bg, self.word), {320, 960-594}), {0.5, 0.5})
            return
        end
        
        if self.maxValue == 11 then
            self.state = 2
            self.word = ui.newBMFontLabel({text="You Win", size=150, color={246, 4, 9}})
            setAnchor(setPos(addChild(self.bg, self.word), {320, 960-594}), {0.5, 0.5})
            return
        end

        --rd = 1 
        --local v = math.random(1, math.min(2, self.maxValue))
        local v = math.random()
        print(v)
        if v < 0.9 then
            v = 2
        else
            v = 4
        end
        --v = math.pow(2, v)
        self.map[rd] = v 

        local row = math.floor((rd-1)/4)
        local col = (rd-1)%4

        self:makeNewNum(rd, v, col, row)

        --[[
        local bo = setColor(createSprite("round.png"), cmap[v])
        local l = ui.newBMFontLabel({font="bound.fnt", text=v, size=40})
        setAnchor(setPos(addChild(bo, l), {48, 48}), {0.5, 0.5})

        self.allLabel[rd] = bo
        --local row = 2
        --local col = 3
        setAnchor(setPos(addChild(self.bg, bo), {80+160*col, 132+596-58-160*row}), {0.5, 0.5})
        --]]
        
        self.state = 1
        print("map")
        print(simple.encode(self.map))
    elseif self.state == 1 then
        if self.inMove then
            self.moveTime = self.moveTime+diff
            if self.moveTime >= totalMTime then
                self.state = 0
                self.inMove = false
            end
        end
    elseif self.state == 2 then
             
    end
end
function TestLayer:touchBegan(x, y)
    self.lastPos = {x, y}
    return true
end
function TestLayer:touchMoved(x, y)
end


function TestLayer:makeNewNum(num, v, col, row)
    local bo = setColor(createSprite("round.png"), cmap[v])
    local l = ui.newBMFontLabel({font="bound.fnt", text=v, size=40})
    setAnchor(setPos(addChild(bo, l), {48, 48}), {0.5, 0.5})

    --local l = ui.newBMFontLabel({font="bound.fnt", text=st[3-i+1], size=40})
    setAnchor(setPos(addChild(self.bg, bo), {80+160*col, 132+596-58-160*row}), {0.5, 0.5})
    self.allLabel[num] = bo
    setOpacity(bo, 0)
    setVisible(bo, false)
    bo:runAction(sequence({delaytime(showTime), appear(bo), spawn({fadein(0.2), sequence({scaleto(0.2, 1.2, 1.2), scaleto(0.2, 1, 1)})})}))
end


function TestLayer:touchEnded(x, y)
    if self.inMove then
        return
    end
    if self.state ~= 1 then
        return
    end

    local dx = x-self.lastPos[1]
    local dy = y-self.lastPos[2]
    if math.abs(dx) < 10 and math.abs(dy) < 10 then
        return
    end
    self.inMove = true
    self.moveTime = 0
    if math.abs(dx) > math.abs(dy) then
        if dx > 0 then
            --right bound
            --right all possible
            --right column

            --map data
            --allLabel x y data

            --right number == 0
            -- == 4
            -- == 1 3
            -- == 2 2
            -- == 3 1
            --setAnchor(setPos(addChild(self.bg, l), {80+160*col, 132+596-58-160*row}), {0.5, 0.5})
            --first moveto
            --mergeto 2 2 4
            --4 2 2 ---> 44---> 8
            --两层递归
            --while calculate each state
            --1 move
            --2 merge 
            --fast way to find before value is what?

            for row=0, 3, 1 do

                --3 2 1 0
                --current value
                local st = {0, 0, 0, 0}
                --merge Yet
                --3 2 1 0
                local me = {false, false, false, false}

                --move Position
                -- 0 1 2 3
                local mt = {-1, -1, -1, -1}

                for i=3, 0, -1 do
                    local num = row*4+i+1
                    print("selfmap", num, self.map[num])
                    if self.map[num] ~= 0 then
                        
                        local find = false
                        for j=3-i, 0, -1 do
                            if st[j+1] == self.map[num] then
                                st[j+1] = 2*self.map[num]
                                me[j+1] = true
                                mt[i+1] = j
                                find = true
                                break 
                            --can't merge not empty then stop
                            elseif st[j+1] ~= 0 then
                                break
                            end
                        end

                        print("merge or move?", find)
                        --no merge then just move to first position
                        if not find then
                            for j=0, 3, 1 do
                                if st[j+1] == 0 then
                                    mt[i+1] = j
                                    st[j+1] = self.map[num]
                                    break
                                end
                            end
                        end
                    end
                end

                print("st me mt ")
                print(simple.encode(st))
                print(simple.encode(me))
                print(simple.encode(mt))
                for i=3, 0, -1 do
                    --move label position
                    --cur position block move to where
                    --0 1 2 3
                    if mt[i+1] ~= -1 then
                        print("move pos", i, mt[i+1])
                        local num = row*4+i+1
                        self.allLabel[num]:runAction(moveto(movet, 80+160*(3-mt[i+1]), 132+596-58-160*row)) 
                        
                        local nn = row*4+(3-mt[i+1])+1
                        -- if merge then move and remove myself
                        local col = 3-mt[i+1]
                        print("remove self", col, me[3-col+1])
                        --merge 
                        --not move at all

                        if me[3-col+1] then
                            print("remove allLabel", self.allLabel[num])
                            self.allLabel[num]:runAction(sequence({delaytime(dtime), fadeout(0.2), callfunc(nil, removeSelf, self.allLabel[num])}))
                            --self.allLabel[num]:runAction(fadeout(0.5))
                            self.allLabel[num] = nil
                            self.map[num] = 0
                            --merge value ---> j 3 2 1 0  move position
                            print("merge block value", st[mt[i+1]+1])
                            self.map[nn] = st[mt[i+1]+1]
                            self.maxValue = math.max(self.maxValue, getOrder(st[mt[i+1]+1])-1)
                        --no merge
                        elseif nn == num then

                        else
                            self.allLabel[nn] = self.allLabel[num]
                            self.allLabel[num] = nil
                            --new value = old value
                            self.map[nn] = self.map[num]
                            self.map[num] = 0
                        end
                    end
                end
                print("after map")
                print(simple.encode(self.map))

                --if merge wait then show new block
                --fadeout 
                for i=3, 0, -1 do
                    if me[3-i+1] then
                        local num = row*4+i+1
                        --self.allLabel[num] = ui.newBMFontLabel({})
                        local v = st[3-i+1]
                        self:makeNewNum(num, v, i, row)
                        global.director.curScene:updateScore(v)

                        --[[
                        local bo = setColor(createSprite("round.png"), cmap[v])
                        local l = ui.newBMFontLabel({font="bound.fnt", text=v, size=40})
                        setAnchor(setPos(addChild(bo, l), {48, 48}), {0.5, 0.5})

                        --local l = ui.newBMFontLabel({font="bound.fnt", text=st[3-i+1], size=40})
                        setAnchor(setPos(addChild(self.bg, bo), {80+160*i, 132+596-58-160*row}), {0.5, 0.5})
                        self.allLabel[num] = bo
                        bo:runAction(sequence({fadeout(0), delaytime(1), fadein(0.2)}))
                        --]]

                    end
                end
            end

            --[[
            local ct = {0, 0, 0, 0}
            for i=3, 0, -1 do
                for j=0, 3, 1 do
                    local num = j*4+i+1
                    if self.map[num] ~= 0 then
                        local xp = 3-ct[j+1]
                        self.allLabel[num]:runAction(moveto(1, 80+160*xp, 132+596-58-160*j)) 
                        ct[j+1] = ct[j+1]+1

                        local nn = j*4+xp+1
                        self.map[nn] = self.map[num]
                        self.map[num] = 0
                        
                        self.allLabel[nn] = self.allLabel[num]
                        self.allLabel[num] = nil
                    end
                end
            end
            --]]
        --left 
        else
            --row not change
            --col 0 1 2 3 direction judge 
            --test appear in 4 * 4 = 16

            for row=0, 3, 1 do

                --0 1 2 3
                --current value
                local st = {0, 0, 0, 0}
                --merge Yet
                --0 1 2 3
                local me = {false, false, false, false}
                --move Position
                -- 0 1 2 3
                local mt = {-1, -1, -1, -1}
                
                --******
                for i=0, 3, 1 do
                    local num = row*4+i+1
                    print("selfmap", num, self.map[num])
                    --0 1 2 3 has number
                    if self.map[num] ~= 0 then
                        local find = false
                        --judge need to merge 
                        for j=i-1, 0, -1 do
                            if st[j+1] == self.map[num] then
                                st[j+1] = 2*self.map[num]
                                me[j+1] = true
                                mt[i+1] = j
                                find = true
                                break 
                            --can't merge not empty then stop
                            elseif st[j+1] ~= 0 then
                                break
                            end
                        end

                        print("merge or move?", find)
                        --no merge then just move to first position
                        --first zero position 
                        --*****
                        if not find then
                            for j=0, 3, 1 do
                                if st[j+1] == 0 then
                                    mt[i+1] = j
                                    st[j+1] = self.map[num]
                                    break
                                end
                            end
                        end
                    end
                end

                print("st me mt ")
                print(simple.encode(st))
                print(simple.encode(me))
                print(simple.encode(mt))
                for i=0, 3, 1 do
                    --move label position
                    --cur position block move to where
                    --0 1 2 3
                    --mt j position 0 1 2 3
                    if mt[i+1] ~= -1 then
                        print("move pos", i, mt[i+1])
                        local num = row*4+i+1
                        --***
                        self.allLabel[num]:runAction(moveto(movet, 80+160*mt[i+1], 132+596-58-160*row)) 
                        --***
                        local nn = row*4+mt[i+1]+1
                        -- if merge then move and remove myself
                        local col = mt[i+1]
                        print("remove self", col, me[col+1])
                        --merge 
                        --not move at all
                        
                        --merge 0 1 2 3
                        --***
                        if me[col+1] then
                            print("remove allLabel", self.allLabel[num])
                            self.allLabel[num]:runAction(sequence({delaytime(dtime), fadeout(0.2), callfunc(nil, removeSelf, self.allLabel[num])}))
                            --self.allLabel[num]:runAction(fadeout(0.5))
                            self.allLabel[num] = nil
                            self.map[num] = 0
                            --merge value ---> j 3 2 1 0  move position
                            print("merge block value", st[mt[i+1]+1])
                            self.map[nn] = st[mt[i+1]+1]
                            self.maxValue = math.max(self.maxValue, getOrder(st[mt[i+1]+1])-1)


                        --no merge
                        elseif nn == num then

                        else
                            self.allLabel[nn] = self.allLabel[num]
                            self.allLabel[num] = nil
                            --new value = old value
                            self.map[nn] = self.map[num]
                            self.map[num] = 0
                        end
                    end
                end
                print("after map")
                print(simple.encode(self.map))

                --if merge wait then show new block
                --fadeout 
                --0 1 2 3
                for i=0, 3, 1 do
                --***
                    if me[i+1] then
                        local num = row*4+i+1
                        self:makeNewNum(num, st[i+1], i, row)
                        global.director.curScene:updateScore(st[i+1])

                        --[[
                        --self.allLabel[num] = ui.newBMFontLabel({})
                        local l = ui.newBMFontLabel({font="bound.fnt", text=st[i+1], size=40})
                        setAnchor(setPos(addChild(self.bg, l), {80+160*i, 132+596-58-160*row}), {0.5, 0.5})
                        self.allLabel[num] = l
                        l:setOpacity(0)
                        l:runAction(sequence({delaytime(1), fadein(0.2)}))
                        --]]
                    end
                end
            end

            --[[
            local ct = {0, 0, 0, 0}
            for i=0, 3, 1 do
                for j=0, 3, 1 do
                    local num = j*4+i+1
                    if self.map[num] ~= 0 then
                        local xp = ct[j+1]
                        self.allLabel[num]:runAction(moveto(1, 80+160*xp, 132+596-58-160*j)) 
                        ct[j+1] = ct[j+1]+1

                        local nn = j*4+xp+1
                        self.map[nn] = self.map[num]
                        self.map[num] = 0
                        self.allLabel[nn] = self.allLabel[num]
                        self.allLabel[num] = nil
                    end
                end
            end
            --]]
        end
    else
        -- up to low
        --0 1 2 3
        if dy > 0 then

            for col=0, 3, 1 do

                --0 1 2 3
                --current value
                local st = {0, 0, 0, 0}
                --merge Yet
                --0 1 2 3
                local me = {false, false, false, false}
                --move Position
                -- 0 1 2 3
                local mt = {-1, -1, -1, -1}
                
                --******
                for i=0, 3, 1 do
                    local num = i*4+col+1
                    print("selfmap", num, self.map[num])
                    --0 1 2 3 has number
                    if self.map[num] ~= 0 then
                        local find = false
                        --judge need to merge 
                        for j=i-1, 0, -1 do
                            if st[j+1] == self.map[num] then
                                st[j+1] = 2*self.map[num]
                                me[j+1] = true
                                mt[i+1] = j
                                find = true
                                break 
                            --can't merge not empty then stop
                            elseif st[j+1] ~= 0 then
                                break
                            end
                        end

                        print("merge or move?", find)
                        --no merge then just move to first position
                        --first zero position 
                        --*****
                        if not find then
                            for j=0, 3, 1 do
                                if st[j+1] == 0 then
                                    mt[i+1] = j
                                    st[j+1] = self.map[num]
                                    break
                                end
                            end
                        end
                    end
                end

                --row ---> col
                print("st me mt ")
                print(simple.encode(st))
                print(simple.encode(me))
                print(simple.encode(mt))
                for i=0, 3, 1 do
                    --move label position
                    --cur position block move to where
                    --0 1 2 3
                    --mt j position 0 1 2 3
                    if mt[i+1] ~= -1 then
                        print("move pos", i, mt[i+1])
                        local num = i*4+col+1
                        --***
                        self.allLabel[num]:runAction(moveto(movet, 80+160*col, 132+596-58-160*mt[i+1])) 
                        --***
                        local nn = mt[i+1]*4+col+1
                        -- if merge then move and remove myself
                        --local col = mt[i+1]
                        --print("remove self", col, me[col+1])
                        --merge 
                        --not move at all
                        
                        --merge 0 1 2 3
                        --***
                        if me[mt[i+1]+1] then
                            print("remove allLabel", self.allLabel[num])
                            self.allLabel[num]:runAction(sequence({delaytime(dtime), fadeout(0.2), callfunc(nil, removeSelf, self.allLabel[num])}))
                            --self.allLabel[num]:runAction(fadeout(0.5))
                            self.allLabel[num] = nil
                            self.map[num] = 0
                            --merge value ---> j 3 2 1 0  move position
                            print("merge block value", st[mt[i+1]+1])
                            self.map[nn] = st[mt[i+1]+1]
                            self.maxValue = math.max(self.maxValue, getOrder(st[mt[i+1]+1])-1)
                        --no merge
                        elseif nn == num then

                        else
                            self.allLabel[nn] = self.allLabel[num]
                            self.allLabel[num] = nil
                            --new value = old value
                            self.map[nn] = self.map[num]
                            self.map[num] = 0
                        end
                    end
                end
                print("after map")
                print(simple.encode(self.map))

                --if merge wait then show new block
                --fadeout 
                --0 1 2 3
                for i=0, 3, 1 do
                --***
                    if me[i+1] then
                        local num = i*4+col+1
                        self:makeNewNum(num, st[i+1], col, i)
                        global.director.curScene:updateScore(st[i+1])
                        --[[
                        --self.allLabel[num] = ui.newBMFontLabel({})
                        local l = ui.newBMFontLabel({font="bound.fnt", text=st[i+1], size=40})
                        setAnchor(setPos(addChild(self.bg, l), {80+160*col, 132+596-58-160*i}), {0.5, 0.5})
                        self.allLabel[num] = l
                        l:setOpacity(0)
                        l:runAction(sequence({delaytime(1), fadein(0.2)}))
                        --]]
                    end
                end
            end


            --[[
            local ct = {0, 0, 0, 0}
            print("dy > 0")
            --i col
            --j row
            --0 1 2 3
            for i=0, 3, 1 do
                for j=0, 3, 1 do
                    local num = j*4+i+1
                    if self.map[num] ~= 0 then
                        print("move y")
                        local xp = ct[i+1]
                        self.allLabel[num]:runAction(moveto(1, 80+160*i, 132+596-58-160*xp)) 
                        ct[i+1] = ct[i+1]+1

                        local nn = xp*4+i+1
                        self.map[nn] = self.map[num]
                        self.map[num] = 0
                        self.allLabel[nn] = self.allLabel[num]
                        self.allLabel[num] = nil
                    end
                end
            end
            --]]
        else

            for col=0, 3, 1 do

                --0 1 2 3
                --current value
                local st = {0, 0, 0, 0}
                --merge Yet
                --0 1 2 3
                local me = {false, false, false, false}
                --move Position
                -- 0 1 2 3
                local mt = {-1, -1, -1, -1}
                
                --******
                for i=3, 0, -1 do
                    local num = i*4+col+1
                    print("selfmap", num, self.map[num])
                    --0 1 2 3 has number
                    if self.map[num] ~= 0 then
                        local find = false
                        --judge need to merge 
                        --**** 
                        for j=i+1, 3, 1 do
                            if st[j+1] == self.map[num] then
                                st[j+1] = 2*self.map[num]
                                me[j+1] = true
                                mt[i+1] = j
                                find = true
                                break 
                            --can't merge not empty then stop
                            elseif st[j+1] ~= 0 then
                                break
                            end
                        end
                        print("merge or move?", find, mt[i+1])
                        --no merge then just move to first position
                        --first zero position 
                        --*****
                        if not find then
                            for j=3, 0, -1 do
                                if st[j+1] == 0 then
                                    mt[i+1] = j
                                    st[j+1] = self.map[num]
                                    break
                                end
                            end
                        end
                    end
                end

                --row ---> col
                print("st me mt ")
                print(simple.encode(st))
                print(simple.encode(me))
                print(simple.encode(mt))
                for i=3, 0, -1 do
                    --move label position
                    --cur position block move to where
                    --0 1 2 3
                    --mt j position 0 1 2 3
                    if mt[i+1] ~= -1 then
                        local num = i*4+col+1
                        print("move pos", i, mt[i+1], num)

                        --***
                        self.allLabel[num]:runAction(moveto(movet, 80+160*col, 132+596-58-160*mt[i+1])) 
                        --***
                        local nn = mt[i+1]*4+col+1
                        -- if merge then move and remove myself
                        --local col = mt[i+1]
                        --print("remove self", col, me[col+1])
                        --merge 
                        --not move at all
                        
                        --merge 0 1 2 3
                        --***
                        if me[mt[i+1]+1] then
                            print("remove allLabel", num, self.allLabel[num])
                            self.allLabel[num]:runAction(sequence({delaytime(dtime), fadeout(0.2), callfunc(nil, removeSelf, self.allLabel[num])}))
                            --self.allLabel[num]:runAction(fadeout(0.5))
                            self.allLabel[num] = nil
                            self.map[num] = 0
                            --merge value ---> j 3 2 1 0  move position
                            print("merge block value", st[mt[i+1]+1])
                            self.map[nn] = st[mt[i+1]+1]
                            self.maxValue = math.max(self.maxValue, getOrder(st[mt[i+1]+1])-1)
                        --no merge
                        elseif nn == num then

                        else
                            self.allLabel[nn] = self.allLabel[num]
                            self.allLabel[num] = nil
                            --new value = old value
                            self.map[nn] = self.map[num]
                            self.map[num] = 0
                        end
                    end
                end
                print("after map")
                print(simple.encode(self.map))

                --if merge wait then show new block
                --fadeout 
                --0 1 2 3
                for i=0, 3, 1 do
                --***
                    if me[i+1] then
                        local num = i*4+col+1
                        self:makeNewNum(num, st[i+1], col, i)
                        global.director.curScene:updateScore(st[i+1])
                        --[[
                        --self.allLabel[num] = ui.newBMFontLabel({})
                        local l = ui.newBMFontLabel({font="bound.fnt", text=st[i+1], size=40})
                        setAnchor(setPos(addChild(self.bg, l), {80+160*col, 132+596-58-160*i}), {0.5, 0.5})
                        self.allLabel[num] = l
                        l:setOpacity(0)
                        l:runAction(sequence({delaytime(1), fadein(0.2)}))
                        --]]
                    end
                end
            end


            --[[
            local ct = {0, 0, 0, 0}
            --i col
            --j row
            --0 1 2 3
            for i=0, 3, 1 do
                for j=3, 0, -1 do
                    local num = j*4+i+1
                    if self.map[num] ~= 0 then
                        --print("move y")
                        local xp = 3-ct[i+1]
                        self.allLabel[num]:runAction(moveto(1, 80+160*i, 132+596-58-160*xp)) 
                        ct[i+1] = ct[i+1]+1

                        local nn = xp*4+i+1
                        self.map[nn] = self.map[num]
                        self.map[num] = 0
                        self.allLabel[nn] = self.allLabel[num]
                        self.allLabel[num] = nil
                    end
                end
            end
            --]]

        end
    end
end

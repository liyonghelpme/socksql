local SocketTCP = require "SocketTCP"
SocScene = class()
function SocScene:ctor()
    self.bg = CCScene:create()
    
    print("time", GetTime())
    print(os.time())
    print(SocketTCP._VERSION)

    self.state = 0
    local lab = ui.newButton({text="Make", size=25, color={0, 0, 0}, image="round.png", delegate=self, callback=self.onBut})
    self.lab = lab
    setPos(addChild(self.bg, lab.bg), {100, 100})
end
function SocScene:onBut()
    if self.state == 0 then
        self.socket = SocketTCP.new("localhost", 8000, false)
        Event:registerEvent(SocketTCP.EVENT_CONNECTED, self)
        Event:registerEvent(SocketTCP.EVENT_CLOSE, self)
        Event:registerEvent(SocketTCP.EVENT_CLOSED, self)
        Event:registerEvent(SocketTCP.EVENT_CONNECT_FAILURE, self)
        Event:registerEvent(SocketTCP.EVENT_DATA, self)

        self.state = 1
        self.lab.text:setString("Connect")
    elseif self.state == 1 then
        self.state = 2
        self.socket:connect()
        self.lab.text:setString("Send")

    elseif self.state == 2 then
        self.state = 3
        local d= 'GET / HTTP/1.0\r\n\r\n'
        print("sendData", d)
        self.socket:send(d)
    end
end
function SocScene:receiveMsg(name, msg)
    print(name, msg)
    if name == SocketTCP.EVENT_CONNECTED then
    elseif name == SocketTCP.EVENT_DATA then
        print(msg.data)
    end
end


function init() as void
    m.ws = createObject("roSGNode", "WebSocketClient")
    m.ws.observeField("on_open", "on_open")
    m.ws.observeField("on_open", "on_close")
    m.ws.observeField("on_message", "on_message")
    m.ws.open = "ws://192.168.0.58:8080/game/create"
    m.qrCode = m.top.findNode("qrCode")
    m.playerList = m.top.findNode("playerList")
end function

function on_open(event as object) as void
    m.ws.send = ["who"]
end function

function on_close(event as object ) 
    print "it died"

end function

function on_message(event as object) as void
    if Left(event.getData().message, 3) = "qr:"
        uri = "tmp:/" + "code.png"
        roomCodeData = CreateObject("roByteArray")
        roomCodeData.FromBase64String(Right(event.getData().message ,Len(event.getData().message) - 3))
        roomCodeData.WriteFile(uri)
        m.qrCode.uri = uri
     else if  Mid(event.getData().message, 3,3) = "pys"
        RowItems = createObject("RoSGNode","ContentNode")
        players = ParseJson(event.getData().message)
        for each player in players.pys
             playerItem = createObject("RoSGNode","ContentNode")
             playerItem.Title = player.displayName
             RowItems.appendChild(playerItem)
        end for
        m.playerList.content = RowItems
     else
        print Mid(event.getData().message, 3,3)
        print event.getData().message
    end if
end function

function onKeyEvent(key, press)
    if press
        if key = "back"
          m.ws.close = [1001, "quitting match"]
        end if
    end if
    return result
end function
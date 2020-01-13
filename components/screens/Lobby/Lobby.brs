function init() as void
    m.ws = createObject("roSGNode", "WebSocketClient")
    m.ws.observeField("on_open", "on_open")
    m.ws.observeField("on_open", "on_close")
    m.ws.observeField("on_message", "on_message")
    m.ws.open = "ws://192.168.0.58:8080/game/create"
    m.qrCode = m.top.findNode("qrCode")
    m.playerList = m.top.findNode("playerList")
    m.timerLabel = m.top.findNode("timerLabel")
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
        rowItems = createObject("RoSGNode","ContentNode")
        print event.getData().message
        players = ParseJson(event.getData().message)
        for each player in players.pys
             playeritem       =  createObject("RoSGNode","ContentNode")
             playeritem.addField("isKing", "boolean", true)
             playeritem.Title = player.displayName
             playeritem.id = player.id
             playeritem.isKing = player.isKing
             playeritem.Description = player.avatar
             rowItems.appendChild(playeritem)
        end for
         m.playerList.content = rowItems
     else if Mid(event.getData().message, 3,9) = "remaining"
        timer = ParseJson(event.getData().message)
        m.timerLabel.text = "Timer: " + str(timer.remaining) + "/" + str(timer.total)
     else if Left(event.getData().message, 9) = "gamestage"
        print "game state changed to: " + Right(event.getData().message, 2)
        changeGameState(Right(event.getData().message, 2))
     else
        print Left(event.getData().message, 8)
        print event.getData().message
    end if
end function

function changeGameState(state)
  gameMode = val(state, 10)
  print "gamemode: " + str(gameMode)
  if gameMode = -1
    m.timerLabel.visible = false
    m.qrCode.visible = true
  else if gameMode = 0
      m.timerLabel.visible = false
  else if gameMode = 1
      m.qrCode.visible = false
      m.timerLabel.visible = true
  else if gameMode = 2
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
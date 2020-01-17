function init() as void
    m.ws = createObject("roSGNode", "WebSocketClient")
    m.ws.observeField("on_open", "on_open")
    m.ws.observeField("on_open", "on_close")
    m.ws.observeField("on_message", "on_message")
    m.ws.open = "ws://192.168.0.58:8080/game/create"
    m.qrCode = m.top.findNode("qrCode")
    m.playerList = m.top.findNode("playerList")
    m.timerLabel = m.top.findNode("timerLabel")
    m.statusText = m.top.findNode("StatusText")
    m.playerEntry = m.top.findNode("playerEntriesList")
    m.timerCountDown = m.top.findNode("countDownTimer")
    m.timerCountDown.ObserveField("fire","getHype")
    m.top.ChosenWord = ""
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
        updatePlayerList(event.getData().message)
     else if Mid(event.getData().message, 3,9) = "remaining"
        handleTimer(event.getData().message)
     else if Left(event.getData().message, 9) = "gamestage"
        print "game state changed to: " + Right(event.getData().message, 2)
        changeGameState(Right(event.getData().message, 2))
     else if Left(event.getData().message, 6) = "chWord"
        m.top.ChosenWord = Right(event.getData().message, (len(event.getData().message) - 8))
     else if event.getData().message = "!rndStart"
        m.statusText.text = "Round is starting!"
        centerPos = "[" + str(640 - (len(m.statusText.text) * 6)) + ", 250.0]"
        m.ws.send = ["rndStart"]
     else
        print Left(event.getData().message, 8)
        print event.getData().message
    end if
end function

function handleTimer(tData) 
        timer = ParseJson(tData)
        if timer.remaining <= 15
            m.timerLabel.Color = "0xCF1010"
            m.timerLabel.font.size = "72"
        else
            m.timerLabel.Color = "0xFFFFFF"
            m.timerLabel.font.size = "42" 
        end if
        m.timerLabel.text = "Timer: " + str(timer.remaining) + "/" + str(timer.total)
end function

function updatePlayerList(playerData)
        rowItems = createObject("RoSGNode","ContentNode")
        players = ParseJson(playerData)
        for each player in players.pys
             playeritem       =  createObject("RoSGNode","ContentNode")
             playeritem.addField("isKing", "boolean", true)
             playeritem.Title = player.displayName
             playeritem.id = player.id
             if player.isKing 
                m.statusText.text = player.displayName  + " is choosing the next word!"
                centerPos = "[" + str(640 - (len(m.statusText.text) * 6)) + ", 250.0]"
                m.statusText.translation = centerPos
             end if
             playeritem.isKing = player.isKing
             playeritem.Description = player.avatar
             rowItems.appendChild(playeritem)
        end for
         m.playerList.content = rowItems
end function

function changeGameState(state)
  gameMode = val(state, 10)
  print "gamemode: " + str(gameMode)
  if gameMode = -1
    m.timerLabel.visible = false
    m.qrCode.visible = true
    m.statusText.visible = false
  else if gameMode = 0
      m.timerLabel.visible = false
      m.qrCode.visible = true
      m.statusText.visible = false
  else if gameMode = 1
      m.qrCode.visible = false
      m.statusText.visible = true
      m.timerLabel.visible = true
  else if gameMode = 2
  end if
  if gameMode < 1 and m.playerList.opacity = 0
          fadeSwap("playerEntriesList.opacity", "playerList.opacity")
  end if    
end function

function wordChosen()
      print "Word Chosen:" + m.top.ChosenWord
      fadeSwap("playerList.opacity", "playerEntriesList.opacity")
      m.roundCount = 5
      m.timerCountDown.control = "start"
end function
        
function getHype()
    if m.roundCount = 0
        m.ws.send = ["rndStart"]
        m.statusText.Text = "Waiting for answers"
        m.timerCountDown.control = "stop"
    else
        m.statusText.Font.size = 42
        m.statusText.Text = m.roundCount
        m.roundCount -= 1
    end if
end function

function fadeSwap(hideItem as string, showItem as string)
   animController = m.top.findNode("flipSeqAnim")
   hideInterpolater = m.top.findNode("hideInterPol")
   showInterpolater = m.top.findNode("showInterPol")
  
   hideInterpolater.fieldToInterp = hideItem
   showInterpolater.fieldToInterp = showItem
   
   animController.repeat = "false"
   animController.control = "start"
end function


function onKeyEvent(key, press)
    if press
        if key = "back"
          m.ws.close = [1001, "quitting match"]
        end if
    end if
    return result
end function
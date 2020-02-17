function init() as void
    m.screenStack = []
    m.ws = createObject("roSGNode", "WebSocketClient")
    m.ws.observeField("on_open", "on_open")
    m.ws.observeField("on_open", "on_close")
    m.ws.observeField("on_message", "on_message")
    m.ws.open = "ws://labs.snapvids.com:8089/game/create"
    m.qrCode = m.top.findNode("qrCode")
    m.playerList = m.top.findNode("playerList")
    m.timerLabel = m.top.findNode("timerLabel")
    m.statusText = m.top.findNode("StatusText")
    m.playerEntry = m.top.findNode("playerEntriesList")
    m.timerCountDown = m.top.findNode("countDownTimer")
    m.timerCountDown.ObserveField("fire","getHype")
    m.top.ChosenWord = ""
    m.top.GameStage = "-1"
    m.sTextTrans = m.statusText.translation
    m.se = m.top.findNode("se")
    m.arrivedSFX = m.top.findNode("arrivedSFX")
end function

function on_open(event as object) as void
    m.ws.send = ["who"]
end function

function on_close(event as object ) 

end function

function on_message(event as object) as void
    if Left(event.getData().message, 3) = "qr:"
        uri = "tmp:/" + CreateObject("roDeviceInfo").GetRandomUUID() + ".png"
        roomCodeData = CreateObject("roByteArray")
        roomCodeData.FromBase64String(Right(event.getData().message ,Len(event.getData().message) - 3))
        roomCodeData.WriteFile(uri)
        m.qrCode.uri = uri
     else if  Mid(event.getData().message, 3,3) = "pys"
        updatePlayerList(event.getData().message)
     else if  Mid(event.getData().message, 3,3) = "aws"
        updateAnswerList(event.getData().message)    
     else if Mid(event.getData().message, 3,9) = "remaining"
        handleTimer(event.getData().message)
     else if Left(event.getData().message, 9) = "gamestage"
        print "game state changed to: " + Right(event.getData().message, 2)
        changeGameState(Right(event.getData().message, 2))
     else if Left(event.getData().message, 6) = "chWord"
        m.top.ChosenWord = Right(event.getData().message, (len(event.getData().message) - 8))
     else if event.getData().message = "!rndStart"
        m.statusText.text = "Round is starting!"
     else if MID(event.getData().message,3, 9) = "winningId"
          findWinner(event.getData().message)
     else
        print MID(event.getData().message,3, 9)
        print event.getData().message
    end if
end function

function handleTimer(tData) 
        timer = ParseJson(tData)
        m.timerLabel.visible = true
        if timer.remaining = 0
            m.se.uri = "pkg:/sounds/done.wav"
            m.se.control = "play"
        else if timer.remaining <= 15
            m.se.control = "play"
            m.timerLabel.Color = "0xCF1010"
            m.timerLabel.font.size = "48"
        else
            m.timerLabel.Color = "0xFFFFFF"
            m.timerLabel.font.size = "42"
            m.se.uri = "pkg:/sounds/tick.wav" 
        end if
        m.timerLabel.text = "Timer: " + str(timer.remaining) + "/" + str(timer.total)
end function

function findWinner(winnerJson)
    winner = ParseJson(winnerJson)
    playerDataNode = m.playerList.Content
    for i = 0 to playerDataNode.getChildCount() -1:
       playerData = playerDataNode.getChild(i)      
       if playerData.id = winner.winningId
           announceWinner(playerData)
       end if
    end for
end function

function announceWinner(player)
    m.winningPlayer = player
    m.roundCount = 10
    m.timerCountDown.control = "start"
    m.playerEntry.visible = "false"
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
             end if
             playeritem.isKing = player.isKing
             playeritem.Url = player.avatar
             print player.avatar
             rowItems.appendChild(playeritem)
             m.arrivedSFX.control = "start"
        end for
         m.playerList.content = rowItems
end function

function updateAnswerList(answerData)
        rowItems = createObject("RoSGNode","ContentNode")
        answers = ParseJson(answerData)
        for each answer in answers.aws
             answerItem       =  createObject("RoSGNode","ContentNode")
             answerItem.Title = answer
             rowItems.appendChild(answerItem)
        end for
        m.playerEntry.content = rowItems
end function

function changeGameState(state)
  gameMode = val(state, 10)
  m.top.GameStage = gameMode
  print "gamemode: " + str(gameMode)
  if gameMode = -1
    m.statusText.Font.size = 24
    m.timerLabel.visible = false
    m.qrCode.visible = true
    m.statusText.visible = false
  else if gameMode = 0
      m.statusText.Font.size = 24
      m.timerLabel.visible = false
      m.qrCode.visible = true
      m.statusText.visible = false
  else if gameMode = 1
      m.qrCode.visible = false
      m.statusText.visible = true
      m.timerLabel.visible = true
  else if gameMode = 2
  else if gameMode = 3
      m.timerLabel.visible = false
      m.statusText.Text = "And Answers are in!" + Chr(10) + "Awaiting for a winner to be chosen"
  end if
  if gameMode < 1 and m.playerList.opacity = 0
          fadeSwap("playerEntriesList.opacity", "playerList.opacity")
  end if    
end function

function wordChosen()
  fadeSwap("playerList.opacity", "playerEntriesList.opacity")
  m.roundCount = 7
  m.statusText.Font.size = 60
  m.timerLabel.visible = false
  m.timerCountDown.control = "start"
end function
        
function getHype()
    if m.top.GameStage =  1
        gameStartingHype()
    else if m.top.GameStage =  3
        gameWinnerHype()
    end if
end function

function gameWinnerHype()
   if m.roundCount = 0 
      m.timerCountDown.control = "stop"
      m.resultsScreen = CreateObject("roSGNode", "ResultsScene")
      m.resultsScreen.itemContent = m.winningPlayer
      m.Top.appendChild(m.resultsScreen)
      ShowScreen(m.resultsScreen)
   else if m.roundCount = 3 
       m.statusText.Text = "Doing the final calculations...."    
   else if m.roundCount > 6
       m.statusText.Text = "The results are in!"
   end if
   m.roundCount -= 1
end function

function gameStartingHype() 
    if m.roundCount = 0
        m.ws.send = ["rndStart"]
        m.statusText.width = 640
        m.statusText.Font.size = 48
        m.statusText.translation = m.sTextTrans
        m.statusText.Text =  m.top.ChosenWord + Chr(10) + "Waiting for answers!"
        m.statusText.scale = "[1, 1]"
        m.timerCountDown.control = "stop"
    else if m.roundCount < 6
        m.statusText.translation = "[580,250]"
        m.statusText.width = 50
        m.se.control = "play" 
        animation = m.top.findNode("timerShrinkScaleAnim")
        m.statusText.Text = m.roundCount
        animation.control = "start"
    end if
    m.roundCount -= 1
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

Sub ShowScreen(node)
    prev = m.screenStack.peek()
    if prev <> invalid
        prev.visible = false
    end if
    node.visible = true

    node.setFocus(true)
    m.screenStack.push(node)
End Sub

function onKeyEvent(key, press)
    if press
        if key = "back"
          m.qrCode.uri = "tmp:/null"
          for each file in listdir("tmp:/")
            deletefile("tmp:/" + file)
          end for 
          print listdir("tmp:/")
          m.ws.close = [1001, "quitting match"]
        end if
    end if
    return result
end function
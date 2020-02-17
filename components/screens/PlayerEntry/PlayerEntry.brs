'Playerlist component - CopyRight 2020 BirdBrain Productions

Function Init()
  m.playerAnswerItem = m.top.findNode("playerAnswer")
  m.answerSe = m.top.findNode("answerSFX")
End Function

Function showcontent()
    itemContent = m.top.itemContent
    print itemContent.Title
    m.playerAnswerItem.text = itemContent.Title
    m.answerSe.control = "play"
End Function

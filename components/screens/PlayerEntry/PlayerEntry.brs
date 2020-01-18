'Playerlist component - CopyRight 2020 BirdBrain Productions

Function Init()
  m.playerAnswerItem = m.top.findNode("playerAnswer")
End Function

Function showcontent()
    itemContent = m.top.itemContent
    print itemContent.Title
    m.playerAnswerItem.text = itemContent.Title
End Function

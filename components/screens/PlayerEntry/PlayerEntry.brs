'Playerlist component - CopyRight 2020 BirdBrain Productions

Function Init()
  m.playerEntry = m.top.findNode("playerAnswer")
End Function

Function showcontent()
    itemContent = m.top.itemContent
    m.playerEntry.text = itemContent.Title
End Function

'Playerlist component - CopyRight 2020 BirdBrain Productions

Function Init()
 ' m.playerAvatar = m.top.findNode("playerAvatar")
  m.playerName = m.top.findNode("playerName")
  m.kingdicator = m.top.findNode("kingIndicator")
End Function

Function showcontent()
    itemContent = m.top.itemContent
    m.playerName.text = itemContent.Title
'    m.playerAvatar.uri = itemContent.Description
    m.kingdicator.visible = itemContent.isKing
End Function

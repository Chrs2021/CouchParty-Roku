'Playerlist component - CopyRight 2020 BirdBrain Productions

Function Init()
  m.playerAvatar = m.top.findNode("playerAvatar")
  m.se = m.top.findNode("arrived")
  
  m.playerName = m.top.findNode("playerName")
  m.kingdicator = m.top.findNode("kingIndicator")
End Function

Function showcontent()
    itemContent = m.top.itemContent
    m.playerName.text = itemContent.Title
    if len(itemContent.Url) > 0
        m.playerAvatar.uri = itemContent.Url
        m.se.control = "play"  
    end if
    m.kingdicator.visible = itemContent.isKing
End Function

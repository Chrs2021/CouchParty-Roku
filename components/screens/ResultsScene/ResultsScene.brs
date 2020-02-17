function init()
    m.animation = m.top.findNode("revealParallelAnimation")
    m.background = m.top.findNode("background")
    m.playername = m.top.findNode("playerName")
    m.playerAvatar = m.top.findNode("playerAvatar")
    m.winningText = m.top.findNode("winningText")
    m.winningText.Font.size = "50"
    m.playername.Font.size = "60"
    m.animation.observeField("state", "animationTransition")
end function

Function showcontent()
    itemContent = m.top.itemContent
    m.playername.text = itemContent.Title
    m.playerAvatar.uri = itemContent.Url
    print itemContent.Url
    m.animation.control = "start"
end function

sub animationTransition(msg as object)
    if m.animation.state = "stopped"
        
    end if
end sub
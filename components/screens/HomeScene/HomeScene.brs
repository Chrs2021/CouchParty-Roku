' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 

 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    ' listen on port 8089
    ? "[HomeScene] Init"
    m.screenStack = []
    'main grid screen node
    m.TitleText = m.top.findNode("titleScreen")
    m.GridScreen = m.top.findNode("GridScreen")
    
    ShowScreen(m.GridScreen)
End Function 

' Row item selected handler
Sub PlayVideoFromGrid()
    ? "[HomeScene] OnItemSelected" 
    selectedItem = m.GridScreen.ItemSelected
    if selectedItem = 0
     m.TitleText.visible = false
     m.lobby = CreateObject("roSGNode", "Lobby")
     m.lobby.id="Lobby"
     m.top.appendChild(m.lobby)
     ShowScreen(m.lobby)
    end if
End Sub


' if content set, focus on GridScreen
Sub OnChangeContent()
    ? "OnChangeContent "
    m.GridScreen.setFocus(true)
End Sub

' Main Remote keypress event loop
Function OnkeyEvent(key, press) as Boolean
    ? ">>> HomeScene >> OnkeyEvent"
    result = false
    if press
        if key = "back"
            HideTop()
            result = m.screenStack.count() <> 0
        else if key = "options"
        end if
        
        ? "key == ";key
    end if
    return result
End Function

Sub ShowScreen(node)
    prev = m.screenStack.peek()
    if prev <> invalid
        prev.visible = false
    end if
    node.visible = true

    node.setFocus(true)
    m.screenStack.push(node)
End Sub

Sub HideTop()
    HideScreen(invalid)
end Sub

Sub HideScreen(node as Object)
    if node = invalid OR (m.screenStack.peek() <> invalid AND m.screenStack.peek().isSameNode(node)) 
        last = m.screenStack.pop()
        last.visible = false
        if last.id = "Lobby" 
            m.TitleText.visible = true
        end if
        prev = m.screenStack.peek()
        m.top.removeChild(last)
        if prev <> invalid
            prev.visible = true
            prev.setFocus(true)
        end if
    end if
End Sub
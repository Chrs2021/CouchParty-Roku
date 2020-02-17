' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 sub RunScreenSaver()
  
 end sub
 
 sub RunUserInterface()
    screen = CreateObject("roSGScreen")
    scene = screen.CreateScene("HomeScene")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.Show()
    

    list = [
        {
            Title:"Start Game"
        }
        {
            Title:"Options"
        }
        {
            Title:"About"
        }
    ]
    
   scene.gridContent = ParseXMLContent(list)

    while true
        msg = wait(0, port)
        print "------------------"
        print "msg = "; msg
    end while
    
    if screen <> invalid then
        screen.Close()
        screen = invalid
    end if
end sub


Function ParseXMLContent(list As Object)
    RowItems = createObject("RoSGNode","ContentNode")
    
    for each rowAA in list
        row = createObject("RoSGNode","ContentNode")
        row.Title = rowAA.Title

        RowItems.appendChild(row)
    end for

    return RowItems
End Function


Function ParseXML(str As String) As dynamic
    if str = invalid return invalid
    xml = CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
End Function
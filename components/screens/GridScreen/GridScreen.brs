' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********                                     
 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    ? "[GridScreen] Init"
    m.top.observeField("focusedChild", "OnFocusedChildChange")
    m.top.observeField("visible", "onVisibleChange")

    m.rowList       =   m.top.findNode("RowList")
End Function

' set proper focus to RowList in case if return from Details Screen
Sub OnFocusedChildChange()
    if m.top.isInFocusChain() and not m.rowList.hasFocus() then
        m.rowList.setFocus(true)
    end if
End Sub

' handler of focused item in RowList
Sub OnItemFocused()
    itemFocused = m.top.itemFocused
    ? ">> GridScreen > OnItemFocused"; itemFocused
     print "testing " + str(itemFocused)
     ItemSelected = itemFocused
    'When an item gains the key focus, set to a 2-element array, 
    'where element 0 contains the index of the focused row, 
    'and element 1 contains the index of the focused item in that row.
End Sub

' set proper focus to RowList in case if return from Details Screen
Sub onVisibleChange()
    if m.top.visible = true then
        m.rowList.setFocus(true)
    end if
End Sub
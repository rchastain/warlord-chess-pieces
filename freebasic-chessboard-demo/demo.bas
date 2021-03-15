
' demo.bas

#include "chessboard.bi"

ScreenRes(BRDW, BRDW, 32,, fb.GFX_NULL)
dim GC as TGraphChessboard = TGraphChessboard(colors.DARKKHAKI, colors.DARKOLIVEGREEN)
GC.SaveImages()
WindowTitle("Warlord Chessboard")
ScreenRes(BRDW, BRDW, 32)
GC.BufferToScreen()
SetMouse ,, 0

dim as integer dx, dy, brd, px, py
dim key as string
dim forceCursorRedraw as boolean = false

do
  Sleep(1)
  if GetMouse(GC.mx, GC.my,, GC.mb) = 0 then
    GC.PreventCursorExit()
    if cbool((GC.cur = GRAB) and (GC.mb = 1)) andalso GC.IsMouseOnPiece() then
      GC.OnStartGrabbing(dx, dy, px, py, brd)
      forceCursorRedraw = true
    elseif (GC.cur = GRABBING) andalso (GC.mb = 0) then
      GC.OnStopGrabbing(px, py, brd)
    end if
    if GC.MouseMoved() or forceCursorRedraw then
      if cbool(GC.cur = GRABBING) and not forceCursorRedraw then
        GC.DrawPiece(dx, dy, brd)
      else
        forceCursorRedraw = false
        GC.RestoreCursorBackground()
      end if
      GC.DrawCursor()
      GC.BufferToScreen()
      GC.SaveMousePos()
    end if
  end if
  key = InKey
loop until (key = Chr(255) & "k") or (key = Chr(27))

SetMouse ,, 1

GC.DestroyImages()


' chessboard.bi

#include "fbgfx.bi"
#include "colors.bi"
#include "pieces.bi"
#include "cursor.bi"

const BRDX = 0
const BRDY = 0
const SQRW = 48
const BRDW = 8 * SQRW
const BUFW = 10 * SQRW
const EMPTY = 0
const PAWN = 1
const KING = 6
const BLACK = -1
const BACKGROUND = 0
const GRAB = 1
const GRABBING = 2
const CURW = 32
const UPSIDEDOWN = false

PiecePlacement:

data -2,-3,-4,-5,-6,-4,-3,-2
data -1,-1,-1,-1,-1,-1,-1,-1
data  0, 0, 0, 0, 0, 0, 0, 0
data  0, 0, 0, 0, 0, 0, 0, 0
data  0, 0, 0, 0, 0, 0, 0, 0
data  0, 0, 0, 0, 0, 0, 0, 0
data  1, 1, 1, 1, 1, 1, 1, 1
data  2, 3, 4, 5, 6, 4, 3, 2

type TGraphChessboard
  as integer board(1 to 8, 1 to 8)
  as fb.image ptr images(BLACK * KING to KING)
  as fb.image ptr cursor(BACKGROUND to GRABBING)
  as fb.image ptr buffer
  as uinteger LSC, DSC
  as integer mx, my, mb, ox = 0, oy = 0, cur = GRAB
  declare constructor (aLSC as const uinteger, aDSC as const uinteger)
  declare sub CreateImages()
  declare sub DestroyImages()
  declare sub DrawImages()
  declare sub PiecesOutline()
  declare sub SaveImages()
  declare sub LoadBoard()
  declare sub Redraw()
  declare sub BufferToScreen()
  declare sub RedrawBackgroundImage(aX as const integer, aY as const integer)
  declare function XToBoard() as integer
  declare function YToBoard() as integer
  declare function XYToName(aX as const integer, aY as const integer) as string
  declare sub PreventCursorExit()
  declare sub OnStartGrabbing(byref dx as integer, byref dy as integer, byref px as integer, byref py as integer, byref brd as integer)
  declare sub OnStopGrabbing(byref px as integer, byref py as integer, brd as const integer)
  declare function MouseMoved() as boolean
  declare sub DrawPiece(dx as const integer, dy as const integer, brd as const integer)
  declare sub RestoreCursorBackground()
  declare sub DrawCursor()
  declare sub SaveMousePos()
  declare function IsMouseOnPiece() as boolean
end type

constructor TGraphChessboard (aLSC as const uinteger, aDSC as const uinteger)
  LSC = aLSC
  DSC = aDSC
  CreateImages()
  DrawImages()
  LoadBoard()
  Redraw()
end constructor

sub TGraphChessboard.CreateImages()
  buffer = ImageCreate(BUFW, BUFW, LSC)
  for i as integer = BLACK * KING to KING
    images(i) = ImageCreate(SQRW, SQRW)
  next i
  for i as integer = BACKGROUND to GRABBING
    cursor(i) = ImageCreate(CURW, CURW)
  next i
end sub

sub TGraphChessboard.DestroyImages()
  ImageDestroy(buffer)
  for i as integer = BLACK * KING to KING
    ImageDestroy(images(i))
  next i
  for i as integer = BACKGROUND to GRABBING
    ImageDestroy(cursor(i))
  next i
end sub

sub TGraphChessboard.DrawImages()
  dim datum as string
  dim as uinteger c1, c2
  
  Restore WarlordChessPieces
  for i as integer = PAWN to KING
    for y as integer = 0 to SQRW - 1
      Read(datum)
      for x as integer = 0 to SQRW - 1
        select case as const datum[x]
          case asc("0")
            c1 = colors.MAGENTA
            c2 = colors.MAGENTA
          case asc("1")
            c1 = colors.GRAY
            c2 = colors.GRAY
          case asc("2")
            c1 = colors.WHITE
            c2 = colors.BLACK
        end select
        PSet images( i), (x, y), c1
        PSet images(-i), (x, y), c2
      next x
    next y
  next i

  Restore HandCursor:
  for i as integer = GRAB to GRABBING
    for y as integer = 0 to CURW - 1
      Read datum
      for x as integer = 0 to CURW - 1
        select case as const datum[x]
          case asc("0")
            PSet cursor(i), (x, y), colors.MAGENTA
          case asc("1")
            PSet cursor(i), (x, y), colors.BLACK
          case asc("2")
            PSet cursor(i), (x, y), &hFFEFFF
        end select
      next x
    next y
  next i
end sub

sub TGraphChessboard.PiecesOutline()
  const WHITE = 1
  dim img as fb.image ptr = 0
  for colour as integer = BLACK to WHITE step 2
    for piece as integer = PAWN to KING
      img = images(colour * piece)
        for x as integer = 1 to SQRW - 2
          for y as integer = 1 to SQRW - 2
            if Point(x, y, img) = colors.MAGENTA then
              if (Point(x,     y - 1, img) = colors.GRAY) _
              or (Point(x + 1, y - 1, img) = colors.GRAY) _
              or (Point(x + 1, y,     img) = colors.GRAY) _
              or (Point(x + 1, y + 1, img) = colors.GRAY) _
              or (Point(x,     y + 1, img) = colors.GRAY) _
              or (Point(x - 1, y + 1, img) = colors.GRAY) _
              or (Point(x - 1, y,     img) = colors.GRAY) _
              or (Point(x - 1, y - 1, img) = colors.GRAY) then
                PSet img, (x, y), LSC
              end if
            end if
          next y
        next x
    next piece
  next colour
end sub

sub TGraphChessboard.SaveImages()
  dim img as fb.image ptr = ImageCreate(6 * SQRW, 2 * SQRW)
  
  for i as integer = PAWN to KING
    Put img, (SQRW * (i - 1), 0), images(i), PSET
    Put img, (SQRW * (i - 1), SQRW), images(-i), PSET
  next i
  BSave("warlord-chess-graphics.bmp", img)
  ImageDestroy(img)
  
  img = ImageCreate(2 * CURW, CURW)
  for i as integer = GRAB to GRABBING
    Put img, (CURW * (i - 1), 0), cursor(i), PSET
  next i
  BSave("hand.bmp", img)
  ImageDestroy(img)
end sub

sub TGraphChessboard.LoadBoard()
  Restore PiecePlacement:
  for y as integer = 8 to 1 step -1
    for x as integer = 1 to 8
      Read(board(x, y))
    next x
  next y
end sub

sub TGraphChessboard.Redraw()
  dim as integer xToBuf, yToBuf
  Line buffer, (0, 0)-(BUFW, BUFW), LSC, BF
  for y as integer = 1 to 8
    for x as integer = 1 to 8
      xToBuf = x * SQRW
      yToBuf = IIf(UPSIDEDOWN, y, 9 - y) * SQRW
      if (x + y) mod 2 = 0 then
        Line buffer, (xToBuf, yToBuf)-(xToBuf + SQRW - 1, yToBuf + SQRW - 1), DSC, BF
      end if
      if board(x, y) <> EMPTY then
        Put buffer, (xToBuf, yToBuf), images(board(x, y)), TRANS
      end if
    next x
  next y
  if (mx <> 0) or (my <> 0) then
    Get buffer, (mx + SQRW - 16, my + SQRW - 16)-(mx + SQRW + 15, my + SQRW + 15), cursor(BACKGROUND)
    Put buffer, (mx + SQRW - 16, my + SQRW - 16), cursor(cur), TRANS
  end if
end sub

sub TGraphChessboard.BufferToScreen()
  Put (BRDX, BRDY), buffer, (SQRW, SQRW)-(9 * SQRW - 1, 9 * SQRW - 1), PSET
end sub

sub TGraphChessboard.RedrawBackgroundImage(aX as const integer, aY as const integer)
  Line images(BACKGROUND), (0, 0)-(SQRW - 1, SQRW - 1), iif((aX + aY) mod 2 = 1, LSC, DSC), BF
end sub

function TGraphChessboard.XToBoard() as integer
  return mx \ SQRW + 1
end function

function TGraphChessboard.YToBoard() as integer
  return IIf(UPSIDEDOWN, my \ SQRW + 1, 8 - my \ SQRW)
end function

function TGraphChessboard.XYToName(aX as const integer, aY as const integer) as string
  return Chr(Asc("a") - 1 + aX, Asc("1") - 1 + aY)
end function

sub TGraphChessboard.PreventCursorExit()
  const BORDER = 12
  if mx < BORDER then
    mx = BORDER
  elseif mx > BRDW - 1 - BORDER then
    mx = BRDW - 1 - BORDER
  end if
  if my < BORDER then
    my = BORDER
  elseif my > BRDW - 1 - BORDER then
    my = BRDW - 1 - BORDER
  end if
end sub

sub TGraphChessboard.OnStartGrabbing(byref dx as integer, byref dy as integer, byref px as integer, byref py as integer, byref brd as integer)
  this.cur = GRABBING
  dx = SQRW * (this.mx \ SQRW) - this.mx
  dy = SQRW * (this.my \ SQRW) - this.my
  px = this.XToBoard()
  py = this.YToBoard()
  brd = this.board(px, py)
  this.RedrawBackgroundImage(px, py)
end sub

sub TGraphChessboard.OnStopGrabbing(byref px as integer, byref py as integer, brd as const integer)
  this.cur = GRAB
  this.board(px, py) = EMPTY
  px = this.XToBoard()
  py = this.YToBoard()
  this.board(px, py) = brd
  this.Redraw()
  this.BufferToScreen()
end sub

function TGraphChessboard.MouseMoved() as boolean
  return cbool((this.mx <> this.ox) or (this.my <> this.oy))
end function

sub TGraphChessboard.DrawPiece(dx as const integer, dy as const integer, brd as const integer)
  Put this.buffer, (this.ox + dx + SQRW, this.oy + dy + SQRW), this.images(BACKGROUND), PSET
  Get this.buffer, (this.mx + dx + SQRW, this.my + dy + SQRW)-(this.mx + dx + 2 * SQRW - 1, this.my + dy + 2 * SQRW - 1), this.images(BACKGROUND)
  Put this.buffer, (this.mx + dx + SQRW, this.my + dy + SQRW), this.images(brd), TRANS
end sub

sub TGraphChessboard.RestoreCursorBackground()
  if (this.ox <> 0) and (this.oy <> 0) then
    Put this.buffer, (this.ox + SQRW - 16, this.oy + SQRW - 16), this.cursor(BACKGROUND), PSET
  end if
end sub

sub TGraphChessboard.DrawCursor()
  Get this.buffer, (this.mx + SQRW - 16, this.my + SQRW - 16)-(this.mx + SQRW + 15, this.my + SQRW + 15), this.cursor(BACKGROUND)
  Put this.buffer, (this.mx + SQRW - 16, this.my + SQRW - 16), this.cursor(this.cur), TRANS
end sub

sub TGraphChessboard.SaveMousePos()
  this.ox = this.mx
  this.oy = this.my
end sub

function TGraphChessboard.IsMouseOnPiece() as boolean
  return cbool(this.board(this.XToBoard(), this.YToBoard()) <> EMPTY)
end function

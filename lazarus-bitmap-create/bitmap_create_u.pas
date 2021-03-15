unit bitmap_create_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  BGRABitmap, BGRABitmapTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    btCreate: TButton;
    imView: TImage;
    procedure btCreateClick(Sender: TObject);
  private
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btCreateClick(Sender: TObject);
var
  LBitmap: TBGRABitmap;
  LFile: text;
  LLine: string;
  LPicture, x, y: integer;
begin
  LBitmap := TBGRABitmap.Create(48 * 6, 48 * 2, CSSMagenta);

  AssignFile(LFile, '../warlord.txt');
  Reset(LFile);

  for LPicture := 0 to 5 do
    for y := 0 to 47 do
    begin
      ReadLn(LFile, LLine);

      for x := 0 to 47 do
        case LLine[Succ(x)] of
          '1':
            begin
              LBitmap.SetPixel(48 * LPicture + x, y, CSSGray);
              LBitmap.SetPixel(48 * LPicture + x, 48 + y, CSSGray);
            end;
          '2':
            begin
              LBitmap.SetPixel(48 * LPicture + x, y, CSSWhite);
              LBitmap.SetPixel(48 * LPicture + x, 48 + y, CSSBlack);
            end;
        end;
    end;

  CloseFile(LFile);

  LBitmap.Draw(imView.Canvas, 0, 0);
  LBitmap.SaveToFile('../warlord-chess-graphics.bmp');
  LBitmap.Free;
end;

end.


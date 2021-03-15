unit bitmap_cut_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  BGRABitmap, BGRABitmapTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    btCreateBMP: TButton;
    btCreatePNG: TButton;
    procedure btCreateBMPClick(Sender: TObject);
    procedure btCreatePNGClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btCreateBMPClick(Sender: TObject);
var
  img, part: TBGRABitmap;
begin
  img := TBGRABitmap.Create;
  //img.LoadFromFile('../warlord-chess-graphics.bmp', [loBmpAutoOpaque]);
  img.LoadFromFile('../warlord-chess-graphics.bmp');
  CreateDir('bmp');
  part := img.GetPart(RectWithSize(0 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/wp.bmp'); part.Free;
  part := img.GetPart(RectWithSize(1 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/wr.bmp'); part.Free;
  part := img.GetPart(RectWithSize(2 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/wn.bmp'); part.Free;
  part := img.GetPart(RectWithSize(3 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/wb.bmp'); part.Free;
  part := img.GetPart(RectWithSize(4 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/wq.bmp'); part.Free;
  part := img.GetPart(RectWithSize(5 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/wk.bmp'); part.Free;
  part := img.GetPart(RectWithSize(0 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/bp.bmp'); part.Free;
  part := img.GetPart(RectWithSize(1 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/br.bmp'); part.Free;
  part := img.GetPart(RectWithSize(2 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/bn.bmp'); part.Free;
  part := img.GetPart(RectWithSize(3 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/bb.bmp'); part.Free;
  part := img.GetPart(RectWithSize(4 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/bq.bmp'); part.Free;
  part := img.GetPart(RectWithSize(5 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('bmp/bk.bmp'); part.Free;
  img.Free;
end;

procedure TForm1.btCreatePNGClick(Sender: TObject);
var
  img, part: TBGRABitmap;

begin
  img := TBGRABitmap.Create;
  //img.LoadFromFile('../warlord-chess-graphics.bmp', [loBmpAutoOpaque]);
  img.LoadFromFile('../warlord-chess-graphics.bmp');
  img.ReplaceColor(CSSMagenta, BGRAPixelTransparent);
  CreateDir('png');
  part := img.GetPart(RectWithSize(0 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/wp.png'); part.Free;
  part := img.GetPart(RectWithSize(1 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/wr.png'); part.Free;
  part := img.GetPart(RectWithSize(2 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/wn.png'); part.Free;
  part := img.GetPart(RectWithSize(3 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/wb.png'); part.Free;
  part := img.GetPart(RectWithSize(4 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/wq.png'); part.Free;
  part := img.GetPart(RectWithSize(5 * 48, 0 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/wk.png'); part.Free;
  part := img.GetPart(RectWithSize(0 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/bp.png'); part.Free;
  part := img.GetPart(RectWithSize(1 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/br.png'); part.Free;
  part := img.GetPart(RectWithSize(2 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/bn.png'); part.Free;
  part := img.GetPart(RectWithSize(3 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/bb.png'); part.Free;
  part := img.GetPart(RectWithSize(4 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/bq.png'); part.Free;
  part := img.GetPart(RectWithSize(5 * 48, 1 * 48, 48, 48)) as TBGRABitmap; part.SaveToFile('png/bk.png'); part.Free;
  img.Free;
end;

end.


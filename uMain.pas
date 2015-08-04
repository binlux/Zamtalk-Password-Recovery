unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry, ExtCtrls, ComCtrls, WinSkinData, acPNG;

type
  TMainfrm = class(TForm)
    ZamLogo: TImage;
    lv1: TListView;
    skndt1: TSkinData;
    lblcredit: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lv1CustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Mainfrm: TMainfrm;

implementation

{$R *.dfm}

// By JamalCoder

procedure ZamRecover(RootKey: HKEY; const Key: string);
var
  Reg: TRegistry;
  SubKeyNames: TStrings;
  i, p: Integer;
  LI: TListItem;
  EncPassZam, DecPassZam, TempZam: string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := RootKey;
    if (Reg.OpenKeyReadOnly(Key)) then
    begin
      SubKeyNames := TStringList.Create;
      try
        Reg.GetKeyNames(SubKeyNames);
        Reg.CloseKey();
        if (SubKeyNames.Count > 0) then
        begin
          for i := 0 to SubKeyNames.Count - 1 do
          begin
            LI := Mainfrm.lv1.Items.Add;
            LI.Caption := SubKeyNames.Strings[i];
            Reg.OpenKeyReadOnly(Key + SubKeyNames.Strings[i]);
            EncPassZam := Reg.ReadString('Password');
            for p := 1 to Length(EncPassZam) do
            begin
              TempZam := TempZam + Copy(EncPassZam, p, 1);
              if (Length(TempZam) = 2) then
              begin
                DecPassZam := DecPassZam + AnsiChar(Ord(StrToInt('$' +
                  AnsiChar(TempZam[1]) +
                  AnsiChar(TempZam[2]))));
                TempZam := '';
              end;
            end;
            LI.SubItems.Add(DecPassZam);
            DecPassZam := '';
            Reg.CloseKey();
          end;
        end
        else
        begin
          MessageBoxA(0, 'No registered users on this computer',
            'ZamTalk Password Recovery Tool', MB_OK or MB_ICONWARNING);
          Application.Terminate();
        end;
      finally
        SubKeyNames.Free;
      end;
    end
    else
    begin
      MessageBoxA(0, 'Zamtalk is not installed',
        'ZamTalk Password Recovery Tool', MB_OK or MB_ICONWARNING);
      Application.Terminate();
    end;
  finally
    Reg.Free;
  end;
end;

procedure TMainfrm.FormCreate(Sender: TObject);
var
  Col: TListColumn;
begin
  // set Style
  lv1.ViewStyle := vsReport;
  //--------------Add Colums---------------------------
  Col := lv1.Columns.Add;
  Col.Caption := 'Nickname';
  Col.Alignment := taLeftJustify;
  Col.Width := 200;

  Col := lv1.Columns.Add;
  Col.Caption := 'Password';
  Col.Alignment := taLeftJustify;
  Col.Width := 270;

  ZamRecover(HKEY_CURRENT_USER, '\Software\ZamTalk\');
end;

procedure TMainfrm.lv1CustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if SubItem = 1 then
    try
      Sender.Canvas.Font.Color := clGreen;
    except
      on EConvertError do
        Next;
    end;
end;

end.


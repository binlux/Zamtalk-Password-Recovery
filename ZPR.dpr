program ZPR;

uses
  Forms,
  uMain in 'uMain.pas' {Mainfrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainfrm, Mainfrm);
  Application.Run;
end.

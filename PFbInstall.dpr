program PFbInstall;

uses
  Vcl.Forms,
  UFbInstall in 'UFbInstall.pas' {frmBloqueiaSysdba};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Kyrius - Bloqueia SYSDBA';
  Application.CreateForm(TfrmBloqueiaSysdba, frmBloqueiaSysdba);
  Application.Run;
end.

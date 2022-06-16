unit UFbInstall;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  Vcl.StdCtrls, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, ShellApi, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Comp.Script, Vcl.ExtCtrls, Vcl.Buttons;

type
  TfrmBloqueiaSysdba = class(TForm)
    Label1: TLabel;
    editPath: TEdit;
    Button1: TButton;
    btConexao: TButton;
    labConectado: TLabel;
    FDConexao: TFDConnection;
    Label4: TLabel;
    editUserDBA: TEdit;
    editSenhaDBA: TEdit;
    Label5: TLabel;
    FDQuery: TFDQuery;
    Memo1: TMemo;
    FDScript1: TFDScript;
    FDStoredProc1: TFDStoredProc;
    MemoResultado: TMemo;
    panelProcessar: TPanel;
    Label6: TLabel;
    Button2: TButton;
    EditCaminhoFB: TEdit;
    Button3: TButton;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    editPathSistema: TEdit;
    Button4: TButton;
    Bevel2: TBevel;
    procedure btConexaoClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure buscaCaminhoFb;
    function FindFile(aPath, FileName: string; SubDir: Boolean = True): String;
    function ExecutarEEsperar(NomeArquivo: String): Boolean;
    function RunAsAdmin(const Handle: Hwnd; const Path, Params: string): Boolean;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBloqueiaSysdba: TfrmBloqueiaSysdba;

implementation

{$R *.dfm}

procedure TfrmBloqueiaSysdba.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TfrmBloqueiaSysdba.btConexaoClick(Sender: TObject);
begin
  try
    FDConexao.Connected := false;
    FDConexao.Params.Values['Database'] := editPath.text;
    FDConexao.Params.Values['username'] := editUserDBA.text;
    FDConexao.Params.Values['password'] := editSenhaDBA.text;
    FDConexao.LoginPrompt := false;
    FDConexao.Connected := True;
    labConectado.font.Color := clblue;
    labConectado.caption := 'Banco de dados conectado com sucesso!';
    MemoResultado.clear;
    MemoResultado.lines.add('----- Log de operações ------');
    MemoResultado.lines.add('Banco de dados conectado com sucesso!');
    panelProcessar.visible := True;
    buscaCaminhoFb;
  except
    labConectado.font.Color := clred;
    panelProcessar.visible := false;
    labConectado.caption := 'Erro de conexão com o Banco de dados!';
    MemoResultado.lines.add('----- Log de operações ------');
    MemoResultado.lines.add('Erro de conexão com o Banco de dados!');
  end;
end;

procedure TfrmBloqueiaSysdba.buscaCaminhoFb;
var
  CaminhoFb: string;
begin
  CaminhoFb := '';
  if CaminhoFb = '' then
    CaminhoFb := FindFile('C:\Program Files\Firebird\', 'gsec.exe');
  if CaminhoFb = '' then
    CaminhoFb := FindFile('C:\Program Files (x86)\Firebird\', 'gsec.exe');
  if CaminhoFb = '' then
    CaminhoFb := FindFile('D:\Program Files\Firebird\', 'gsec.exe');
  if CaminhoFb = '' then
    CaminhoFb := FindFile('D:\Program Files (x86)\Firebird\', 'gsec.exe');
  if CaminhoFb = '' then
    CaminhoFb := FindFile('E:\Program Files\Firebird\', 'gsec.exe');
  if CaminhoFb = '' then
    CaminhoFb := FindFile('E:\Program Files (x86)\Firebird\', 'gsec.exe');
  if CaminhoFb = '' then
    CaminhoFb := FindFile('C:\Program Files\', 'gsec.exe');
  if CaminhoFb = '' then
    CaminhoFb := FindFile('C:\Program Files (x86)\', 'gsec.exe');

  if CaminhoFb <> '' then
    EditCaminhoFB.text := ExtractFileDir(CaminhoFb)
  else
  begin
    Showmessage('Caminho do firebird não encontrado');
    EditCaminhoFB.setfocus;
  end;
end;

procedure TfrmBloqueiaSysdba.Button1Click(Sender: TObject);
begin
  if OpenDialog1.execute then
    editPath.text := OpenDialog1.FileName;
end;

procedure TfrmBloqueiaSysdba.Button2Click(Sender: TObject);
var
  msg, pastaFB, pastaFBSemBin, nomebkp: String;
  I: Integer;
begin
  //Conexão com o Firebird Atual
  if not (DirectoryExists(EditCaminhoFB.text)) then
  begin
    Showmessage('O caminho informado do firebird não existe.');
    EditCaminhoFB.setfocus;
    MemoResultado.lines.add('Operação abortada!');
    Exit;
  end;

  //Testando o caminho correto do Firebird Atual
  if editPathSistema.text <> '' then
  begin
    if not (DirectoryExists(editPathSistema.text)) then
    begin
      Showmessage('O caminho informado do firebird não existe.');
      editPathSistema.setfocus;
      MemoResultado.lines.add('Operação abortada!');
      Exit;
    end;
  end
  else
  begin
    if application.messagebox('O caminho do Sistema não foi definido, com isso as DLLs do Fb 4.0 não serão copiadas. Deseja continuar?',
      'Caminho dfo Sistema', mb_iconquestion + mb_yesno) = idno then
    begin
      MemoResultado.lines.add('Operação abortada pelo usuário!');
      Exit;
    end;
  end;

  //Confirmação de processamento
  if application.messagebox(pchar('Passos de execução: ' + #13 + '- Backup da base de dados no Firebird atual' + #13 +
    '- Desinstalação do Firebird Atual' + #13 + '- Instalação do Firebird 4.0' + #13 + '- Restauração da base de dados no Firebird 4.0' +
    #13 + '- Susbtituição da base antiga pela nova' + #13 + '- Cópia das Dlls do Firebird 4.0 para a pasta do banco novo.' + #13 +
    'Confirma a execução?'), 'Atenção', mb_iconquestion + mb_yesno) = idyes then
  begin
    pastaFB := EditCaminhoFB.text;

    //Backup da base atual
    MemoResultado.lines.add('==========================');
    MemoResultado.lines.add(' ');
    MemoResultado.lines.add('Backup iniciado... (isso pode levar alguns minutos)');

    msg := '"' + pastaFB + '\gbak" -user ' + editUserDBA.text + ' -password ' + editSenhaDBA.text + ' -backup -v' + ' "' + editPath.text +
      '"  "' + ExtractFilePath(application.ExeName) + '40\backupAntiga.fbk' + '"';

    Memo1.lines.clear;
    Memo1.lines.add(msg);
    Memo1.lines.SaveToFile(ExtractFilePath(application.ExeName) + '40\bkpfb.bat');
    ExecutarEEsperar(ExtractFilePath(application.ExeName) + '40\bkpfb.bat');

    if FileExists(ExtractFilePath(application.ExeName) + '40\backupAntiga.fbk') then
      MemoResultado.lines.add('Backup no Firebird atual feito com sucesso.')
    else
    begin
      MemoResultado.lines.add('Erro - Backup no Firebird atual.');
      MemoResultado.lines.add('Operação abortada.');
      Exit;
    end;

    //Desinstalando o Firebird Atual e serviços
    FDConexao.Connected := false;
    MemoResultado.lines.add('==========================');
    MemoResultado.lines.add(' ');
    MemoResultado.lines.add('Desinstalando o Firebird atual...');

    Memo1.lines.clear;
    Memo1.lines.add('"' + pastaFB + '\instsvc.exe" stop');
    Memo1.lines.add('"' + pastaFB + '\instsvc.exe" remove');
    Memo1.lines.add('"' + pastaFB + '\instsvc.exe" query');
    Memo1.lines.add('"' + pastaFB + '\instsvc.exe" remove');

    msg := '"' + pastaFB + '\unins000.exe" /clean /verysilent /NORESTART /SUPPRESSMSGBOXES';
    if pos('2_5', pastaFB)>0 then
       msg:= stringreplace(msg, '\bin','',[rfReplaceall]);

    Memo1.lines.add(msg);
    Memo1.lines.SaveToFile(ExtractFilePath(application.ExeName) + '40\servico.bat');
    ExecutarEEsperar(ExtractFilePath(application.ExeName) + '40\servico.bat');

    //Copiando a base atual
    Memo1.lines.clear;
    Memo1.lines.add('xcopy "' + pchar(editPath.text) + '" "' + ExtractFilePath(application.ExeName) + 'baseantiga\" /y /e /c /r /a /q /i');
    Memo1.lines.SaveToFile(ExtractFilePath(application.ExeName) + '40\copybd.bat');
    ExecutarEEsperar(ExtractFilePath(application.ExeName) + '40\copybd.bat');

    if FileExists(ExtractFilePath(application.ExeName) + 'baseantiga\' + ExtractFilename(editPath.text)) then
      DeleteFile(pchar(editPath.text));

    //Abortar se deu erro na cópia da base de dados atual
    if FileExists(pchar(editPath.text)) then
    begin
      MemoResultado.lines.add('Erro apagando base de dados atual. ');
      MemoResultado.lines.add('Abortado. ');
      Exit;
    end;

    //Instalando o FB 4.0
    MemoResultado.lines.add('==========================');
    MemoResultado.lines.add(' ');
    MemoResultado.lines.add('Instalando o Firebird 4.0...');
    msg := '"' + ExtractFilePath(application.ExeName) +
      '40\Firebird40.exe" /verysilent /sp- /NORESTART /tasks="UseSuperServerTask,UseServiceTask,AutoStartTask,CopyFbClientToSysTask" /sysdbapassword="masterkey"'
      + '"';

    Memo1.lines.clear;
    Memo1.lines.add(msg);
    Memo1.lines.SaveToFile(ExtractFilePath(application.ExeName) + '40\fb40.bat');
    ExecutarEEsperar(ExtractFilePath(application.ExeName) + '40\fb40.bat');
    MemoResultado.lines.add('Firebird 4.0 instalado');
    MemoResultado.lines.add('==========================');
    MemoResultado.lines.add(' ');
    MemoResultado.lines.add('Base anterior copiada com o nome "baseAnterior.fdb"');

    //Restaurando a base atual para o Fb 4.0
    MemoResultado.lines.add('==========================');
    MemoResultado.lines.add(' ');
    MemoResultado.lines.add('Restaurando o banco para versão 4.0 ...');
    pastaFB := stringreplace(pastaFB, '3_0', '4_0', [rfreplaceAll]);
    pastaFB := stringreplace(pastaFB, '2_5\bin', '4_0', [rfreplaceAll]);
    msg := '"' + pastaFB + '\gbak" -user SYDBA -password masterkey -r -p 4096' + ' "' + ExtractFilePath(application.ExeName) +
      '40\backupAntiga.fbk' + '"  "' + ExtractFileDir(editPath.text) + '\base.fdb' + '"';

    Memo1.lines.clear;
    Memo1.lines.add(msg);
    Memo1.lines.SaveToFile(ExtractFilePath(application.ExeName) + '40\restorefb40.bat');
    ExecutarEEsperar(ExtractFilePath(application.ExeName) + '40\restorefb40.bat');
    MemoResultado.lines.add('Nova base FB 4.0 criada com sucesso.');

    //Copiando as dlls do Fb 4.0 para a pasta do Sistema
    if editPathSistema.text <> '' then
    begin
      MemoResultado.lines.add('==========================');
      MemoResultado.lines.add(' ');
      MemoResultado.lines.add('Copiando as Dlls para a pasta ' + editPathSistema.text );
      Memo1.lines.clear;
      Memo1.lines.add('xcopy "' + ExtractFilePath(application.ExeName) + 'dlls\' + '" "' + editPathSistema.text + '" /y /e /c /r /a /q /i');
      Memo1.lines.SaveToFile(ExtractFilePath(application.ExeName) + '40\copydlls.bat');
      ExecutarEEsperar(ExtractFilePath(application.ExeName) + '40\copydlls.bat');

      MemoResultado.lines.add('Dlls copiadas com sucesso');
    end;

    //Deletando os arquivos de migração
    MemoResultado.lines.add('==========================');
    MemoResultado.lines.add(' ');
    MemoResultado.lines.add('Apagando arquivos temporários ...');
    DeleteFile(ExtractFilePath(application.ExeName) + '40\bkpfb.bat');
    DeleteFile(ExtractFilePath(application.ExeName) + '40\servico.bat');
    DeleteFile(ExtractFilePath(application.ExeName) + '40\restorefb40.bat');
    DeleteFile(ExtractFilePath(application.ExeName) + '40\fb40.bat');
    DeleteFile(ExtractFilePath(application.ExeName) + '40\copybd.bat');
    DeleteFile(ExtractFilePath(application.ExeName) + '40\copydlls.bat');

    //Salvando o log
    MemoResultado.lines.add('==========================');
    MemoResultado.lines.add(' ');
    MemoResultado.lines.SaveToFile('log.txt');
    MemoResultado.lines.add('Arquivo de log gerado com sucesso (log.txt).');
    MemoResultado.lines.add('==========================');
    MemoResultado.lines.add(' ');
    MemoResultado.lines.add('Processo finalizado.');
  end;
end;

procedure TfrmBloqueiaSysdba.Button3Click(Sender: TObject);
begin
  if OpenDialog1.execute then
    EditCaminhoFB.text := ExtractFileDir(OpenDialog1.FileName);
end;

procedure TfrmBloqueiaSysdba.Button4Click(Sender: TObject);
begin
  if OpenDialog1.execute then
    editPathSistema.text := ExtractFileDir(OpenDialog1.FileName);

end;

function TfrmBloqueiaSysdba.ExecutarEEsperar(NomeArquivo: String): Boolean;
var
  Sh: TShellExecuteInfo;
  CodigoSaida: DWORD;
begin
  FillChar(Sh, SizeOf(Sh), 0);
  Sh.cbSize := SizeOf(TShellExecuteInfo);
  with Sh do
  begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := application.Handle;
    lpVerb := nil;
    lpFile := pchar(NomeArquivo);
    nShow := SW_HIDE;
  end;
  if ShellExecuteEx(@Sh) then
  begin
    repeat
      application.ProcessMessages;
      GetExitCodeProcess(Sh.hProcess, CodigoSaida);
    until not (CodigoSaida = STILL_ACTIVE);
    Result := True;
  end
  else
    Result := false;
end;

function TfrmBloqueiaSysdba.FindFile(aPath, FileName: string; SubDir: Boolean): String;
var
  FD: TWin32findData;

  function _FindDir(wPath: string; var vRes: string): Boolean;
  var
    H: THandle;
  begin
    _FindDir := false;
    H := FindFirstFile(pchar(wPath + FileName), FD);
    if H <> INVALID_HANDLE_VALUE then
      try
        repeat
          if (Copy(FD.cFileName, 1, 1) <> '.') then
          begin
            vRes := wPath + FD.cFileName;
            _FindDir := True;
            Exit;
          end;
        until not (FindNextFile(H, FD));
      finally
        Winapi.Windows.FindClose(H);
      end;

    if not SubDir then
      Exit;

    H := FindFirstFile(pchar(wPath + '*.'), FD);
    if H <> INVALID_HANDLE_VALUE then
      try
        repeat
          if (FD.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0 then
            if Copy(FD.cFileName, 1, 1) <> '.' then
            begin
              if _FindDir(wPath + FD.cFileName + '\', vRes) then
              begin
                Result := True;
                Exit;
              end;
            end;
        until not (FindNextFile(H, FD));
      finally
        Winapi.Windows.FindClose(H);
      end;
  end;

begin
  if not _FindDir(IncludeTrailingBackslash(aPath), Result) then
    Result := '';
end;

function TfrmBloqueiaSysdba.RunAsAdmin(const Handle: Hwnd; const Path, Params: string): Boolean;
var
  sei: TShellExecuteInfoA;
begin
  FillChar(sei, SizeOf(sei), 0);
  sei.cbSize := SizeOf(sei);
  sei.Wnd := Handle;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  sei.lpVerb := 'runas';
  sei.lpFile := PAnsiChar(Path);
  sei.lpParameters := PAnsiChar(Params);
  sei.nShow := SW_SHOWNORMAL;
  Result := ShellExecuteExA(@sei);
end;

function ExecutarEEsperar(NomeArquivo: String): Boolean;
var
  Sh: TShellExecuteInfo;
  CodigoSaida: DWORD;
begin
  FillChar(Sh, SizeOf(Sh), 0);
  Sh.cbSize := SizeOf(TShellExecuteInfo);
  with Sh do
  begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := application.Handle;
    lpVerb := nil;
    lpFile := pchar(NomeArquivo);
    nShow := SW_SHOWNORMAL;
  end;
  if ShellExecuteEx(@Sh) then
  begin
    repeat
      application.ProcessMessages;
      GetExitCodeProcess(Sh.hProcess, CodigoSaida);
    until not (CodigoSaida = STILL_ACTIVE);
    Result := True;
  end
  else
    Result := false;
end;

end.

unit formulario1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, CustomDrawnControls, DBCtrls, ShellApi, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    CDButton1: TCDButton;
    CDButton2: TCDButton;
    CDButton3: TCDButton;
    CDButton4: TCDButton;
    CDButton5: TCDButton;
    Edit2: TEdit;
    Edit5: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit4: TEdit;
    Edit3: TEdit;
    Edit6: TEdit;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    OpenDialog1: TOpenDialog;
    TrayIcon1: TTrayIcon;
    procedure CDButton1Click(Sender: TObject);
    procedure CDButton2Click(Sender: TObject);
    procedure CDButton3Click(Sender: TObject);
    procedure CDButton4Click(Sender: TObject);
    procedure CDButton5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
  private
    function LerArquivoTexto(NomeArquivo: String): String;
    procedure EscreverArquivoTexto(NomeArquivo, Conteudo: String);
  public

  end;

var
  Form1: TForm1;
  JSONString: String;
  JsonObject: TJSONObject;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Supondo que JSONString contenha o JSON com as cinco strings
  JSONString := LerArquivoTexto('justificar.json');

  // Analisando o JSON
  JsonObject := GetJSON(JSONString) as TJSONObject;

  // Atribuindo os valores do JSON ao registro
  Edit1.Text := JsonObject.Get('usr', '');
  Edit2.Text := JsonObject.Get('pwd', '');
  Edit3.Text := JsonObject.Get('file', '');
  Edit4.Text := JsonObject.Get('sheet', '');
  Edit5.Text := JsonObject.Get('log', '');
  Edit6.Text := JsonObject.Get('column', '');
  Edit7.Text := JsonObject.Get('URLlogin', '');
  Edit8.Text := JsonObject.Get('URLos', '');
end;

procedure TForm1.CDButton1Click(Sender: TObject);
begin
  // Converter os dados para JSON
  JsonObject := TJSONObject.Create;
  JsonObject.Add('usr', Edit1.Text);
  JsonObject.Add('pwd', Edit2.Text);
  JsonObject.Add('file', Edit3.Text);
  JsonObject.Add('sheet', Edit4.Text);
  JsonObject.Add('log', Edit5.Text);
  JsonObject.Add('column', Edit6.Text);
  JsonObject.Add('URLlogin', Edit7.Text);
  JsonObject.Add('URLos', Edit8.Text);
  JSONString := JsonObject.FormatJSON();
  EscreverArquivoTexto('justificar.json', JSONString);
  MessageDlg('Informação', 'Configuração salva com sucesso!', mtInformation, [mbOK], 0);
end;

procedure TForm1.CDButton2Click(Sender: TObject);
var
  AppDir, ProgramPath : String;
begin
  // Obter o diretório do executável da aplicação
  AppDir := ExtractFilePath(Application.ExeName);

  // Construir o caminho completo para o programa externo "justificar.exe"
  ProgramPath := AppDir + 'justificar.exe';
  ProgramPath := StringReplace(ProgramPath, '\', '/', [rfReplaceAll]);

  // Roda o robô
  ShellExecute(0, 'open', PChar(ProgramPath), '', '', 1);
end;

procedure TForm1.CDButton3Click(Sender: TObject);
begin
  // Minimize to tray when the button is clicked
  TrayIcon1.Visible := True;
  // Application.Minimize;
  Self.Hide; // Esconde o formulário da barra de tarefas
end;

procedure TForm1.CDButton4Click(Sender: TObject);
var
  caminhoCompleto: string;
begin
  // Obtém o caminho completo do arquivo no mesmo diretório que o executável
  caminhoCompleto := ExtractFilePath(Application.ExeName) + 'justificar.log';

  // Abre o Bloco de Notas com o arquivo especificado
  ShellExecute(0, 'open', 'notepad.exe', PChar(caminhoCompleto), nil, 1);
end;

procedure TForm1.CDButton5Click(Sender: TObject);
var
  CaminhoArquivo: string;
begin
  OpenDialog1 := TOpenDialog.Create(nil);
  try
    if OpenDialog1.Execute then
    begin
      CaminhoArquivo := OpenDialog1.FileName;
      Edit3.Text := StringReplace(CaminhoArquivo, '\', '/', [rfReplaceAll]);
    end;
  finally
    OpenDialog1.Free;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  // Garante que o ícone seja removido ao fechar o aplicativo
  TrayIcon1.Visible := False;
end;

function TForm1.LerArquivoTexto(NomeArquivo: String): String;
var
  Arquivo: TextFile;
  Linha: String;
begin
  Result := '';
  try
    AssignFile(Arquivo, NomeArquivo);
    {$I-}
    Reset(Arquivo);
    {$I+}

    if IOResult <> 0 then
    begin
      ShowMessage('Erro ao abrir o arquivo');
      Exit;
    end;

    while not Eof(Arquivo) do
    begin
      ReadLn(Arquivo, Linha);
      Result := Result + Linha + sLineBreak;
    end;

    CloseFile(Arquivo);
  except
    on E: Exception do
    begin
      Result := '';
      ShowMessage('Erro ao ler o arquivo: ' + E.Message);
    end;
  end;
end;

procedure TForm1.EscreverArquivoTexto(NomeArquivo, Conteudo: String);
var
  Arquivo: TextFile;
begin
  try
    AssignFile(Arquivo, NomeArquivo);
    Rewrite(Arquivo);
    Write(Arquivo, Conteudo);
    CloseFile(Arquivo);
  except
    on E: Exception do
      ShowMessage('Erro ao escrever no arquivo: ' + E.Message);
  end;
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  // Show and restore the application when double-clicked on the tray icon
  TrayIcon1.Visible := False;
  // Application.Restore;
  Self.Show; // Exibe o formulário na barra de tarefas
end;

end.


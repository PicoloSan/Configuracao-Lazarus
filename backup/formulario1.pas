unit formulario1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    OpenDialog1: TOpenDialog;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function LerArquivoTexto(NomeArquivo: String): String;
    procedure EscreverArquivoTexto(NomeArquivo, Conteudo: String);
  private

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

procedure TForm1.BitBtn1Click(Sender: TObject);
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
  MessageDlg('Informação', 'Configuração salva com sucesso!', [mtInformation], [mbOK], 0.0);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
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

end.


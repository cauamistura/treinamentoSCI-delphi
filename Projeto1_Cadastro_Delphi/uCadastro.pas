unit uCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Menus, uEstagioDesejado, uEstagioDesejadoQui;

type
  TfrCadastroAluno = class(TForm)
    lbTitulo: TLabel;
    lbNome: TLabel;
    lbSexo: TLabel;
    lbIdade: TLabel;
    lbCurso: TLabel;
    lbFase: TLabel;
    lbMediaNota: TLabel;
    edNome: TEdit;
    edIdade: TEdit;
    cbFase: TComboBox;
    cbCurso: TComboBox;
    edMediaNota: TEdit;
    cbSexo: TComboBox;
    btResultado: TButton;
    ckEstagio: TCheckBox;
    btLista: TButton;
    btSalvar: TButton;
    btEstagioDesejada: TButton;
    procedure btResultadoClick(Sender: TObject);
    procedure btListaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure ckEstagioClick(Sender: TObject);
    procedure edNomeExit(Sender: TObject);
    procedure edIdadeExit(Sender: TObject);
    procedure btEstagioDesejadaClick(Sender: TObject);
    procedure cbCursoClick(Sender: TObject);
  private
    { Private declarations }
    wSLAluno: TStringlist;  // Variavel declarada para tela toda

    //Declara��es de Fun��o
    function fDiretorio: String;
    function fSexo: String;
    function fCurso: String;
    function fDesejoEstagio: String;

  public
    { Public declarations }
  end;

var
  frCadastroAluno: TfrCadastroAluno;

implementation

{$R *.dfm}

procedure TfrCadastroAluno.btEstagioDesejadaClick(Sender: TObject);
var
  wTela1: TfrEstagiosInf;
  wTela2: TfrEstagioQui;
begin
    if cbCurso.ItemIndex = 0 then
    begin
      wTela1 := TfrEstagiosInf.Create(Self);
      wTela1.Show;
    end
  else if cbCurso.ItemIndex = 1 then
     begin
       wtela2 := TfrEstagioQui.Create(Self);
       wTela2.show
     end;
end;

procedure TfrCadastroAluno.btListaClick(Sender: TObject); //Bot�o lista
 var
  wSexo: String;
  wCurso: String;
  wDesejoEstagio: String;
  wIdade: String;
begin

  wSexo := fSexo;
  wCurso := fCurso;
  wDesejoEstagio := fDesejoEstagio;

  wSLAluno.Add('Nome: ' + edNome.Text + //adiciona dados a lista
               ' | Sexo: ' + wSexo +
               ' | Idade: ' + edIdade.Text +
               ' | Curso: ' + wCurso +
               ' | Fase: ' + cbFase.Text +
               ' | Media: ' + edMediaNota.Text +
               ' | Quer Estagiar: ' + wDesejoEstagio);

   ShowMessage(wSLAluno.Text);   //Printa a lista

end;

procedure TfrCadastroAluno.btResultadoClick(Sender: TObject);
var
  wFase: String;
  wSexo: String;
  wCurso: String;
  wIdade: String;
  wMedia: String;
  wDesejoEstagio: String;
  wLetrasNome: Integer;
begin

  wSexo := fSexo;
  wCurso := fCurso;
  wDesejoEstagio := fDesejoEstagio;

  wFase := 'N�o informado';
  if cbFase.ItemIndex < 4 then
      wFase := 'Incoerente com o pedido'
  else if cbFase.ItemIndex >= 4 then
      wFase := 'Prop�cia';

  wIdade := 'N�o informada';
  if StrToInt(edIdade.Text) > 16 then
    wIdade := 'Prop�cia'
  else if StrToInt(edIdade.Text) < 16 then
    wIdade := 'Prop�cia';

  wMedia := 'N�o informada';
  if StrToInt(edMediaNota.Text) > 7 then      //converte String para Inteiro
    wMedia := 'Prop�cia'
  else if StrToInt(edMediaNota.Text) < 7 then
    wMedia := 'Inadequada';



  ShowMessage('Nome: ' + edNome.Text + #13 +      //printa resultado
              'Sexo: ' + wSexo + #13 +
              'Idade: ' + wIdade + #13 +
              'Curso: ' + wCurso + #13 +
              'Fase: ' + wFase + #13 +
              'Media: ' + wMedia + #13 +
              'Quer Estagiar: ' + wDesejoEstagio);
end;

procedure TfrCadastroAluno.btSalvarClick(Sender: TObject);
begin
  if not FileExists(fDiretorio) then //Verifica se o diretorio existe
      ForceDirectories(fDiretorio); //Cria Diretorio

  wSLAluno.SaveToFile(fDiretorio + '\Aluno.txt'); //Salva o "txt" no diretorio designado
end;

procedure TfrCadastroAluno.cbCursoClick(Sender: TObject);
begin
  btEstagioDesejada.Enabled := true;
  if cbCurso.ItemIndex = -1 then
  begin
      btEstagioDesejada.Enabled := False;
      btEstagioDesejada.Enabled := True;
  end;

end;

procedure TfrCadastroAluno.ckEstagioClick(Sender: TObject);  //Utiliza a Check box
begin
  cbCurso.Enabled := True; //seta os campos como visivel
  edMediaNota.Enabled := True;
  cbFase.Enabled := True;
  if not ckEstagio.Checked then //Faz os campus sumirem
    begin
      cbCurso.Enabled := False;
      cbCurso.ItemIndex := -1;  //Limpa o Combo Box

      edMediaNota.Enabled := False;
      edMediaNota.Text := '';    //Limpa a edit

      cbFase.Enabled := False;
      cbFase.ItemIndex := -1;
    end;
end;

procedure TfrCadastroAluno.edIdadeExit(Sender: TObject);
begin
  if (StrToInt(edIdade.Text) < 14) or (StrToInt(edIdade.Text) >= 60) then //converte e valida a idade
    begin
      edIdade.SetFocus;  //n�o deixa sair da idade se ela for inadequada
      ShowMessage('Idade inadequada, voc� n�o pode proseguir');
    end;
end;

procedure TfrCadastroAluno.edNomeExit(Sender: TObject);
begin
  if Length(edNome.Text) < 3  then  //conta a quantidade de letras da palavra e valida
    begin
      edNome.SetFocus; //n�o deixa sair se o nome tiver menos de 3 letras
      ShowMessage('Erro!! Nome precisa ter mais de 3 caracteres ');
    end;
end;

function TfrCadastroAluno.fDesejoEstagio: String;
begin
   Result := 'N�o';
  if ckEstagio.Checked then
    Result := 'Sim';
end;

function TfrCadastroAluno.fDiretorio: String;
begin
  Result := 'C:\Users\prog30\Documents\txt_para_prog'
end;

procedure TfrCadastroAluno.FormShow(Sender: TObject);  //Cria��o da tela
begin
  wSLAluno := TStringList.Create; //Cria a Lista ao abrir a tela

  if FileExists(fDiretorio + '\Aluno.txt') then //verifica se o diretorio existe
      wSLAluno.LoadFromFile(fDiretorio + '\Aluno.txt');   //carrega dados j� salvos se ouver o diretorio
end;

function TfrCadastroAluno.fSexo: String;
begin
  Result := 'N�o atribuido';
  if cbSexo.ItemIndex = 0 then
      Result := 'Feminino'
  else if cbSexo.ItemIndex = 1 then
      Result := 'Masculino';
end;

function TfrCadastroAluno.fCurso: String;
begin
  Result := 'N�o atribuido';
  if cbCurso.ItemIndex = 0 then
      Result := 'Informatica'
  else if cbCurso.ItemIndex = 1 then
      Result := 'Quimica';
end;

end.

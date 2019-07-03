unit SDIMAIN;

interface

uses Winapi.Windows, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Controls,
  Vcl.Menus, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.ImgList, Vcl.StdActns, Vcl.ActnList, Vcl.ToolWin,
  System.Sysutils;

type
  TSDIAppForm = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ToolBar1: TToolBar;
    ToolButton9: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileOpen1: TAction;
    FileSave1: TAction;
    FileSaveAs1: TAction;
    FileExit1: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    HelpAbout1: TAction;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    Help1: TMenuItem;
    HelpAboutItem: TMenuItem;
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private
    is8bit: boolean;
  public
    { Public declarations }
  end;

var
  SDIAppForm: TSDIAppForm;

function HexWordValidation(const pc: string): boolean;
function HexValidation(const pc: string; const width: byte = 4): boolean;

implementation

uses About;

{$R *.dfm}

procedure TSDIAppForm.FileNew1Execute(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TSDIAppForm.FileOpen1Execute(Sender: TObject);
begin
  OpenDialog.Execute;
end;

procedure TSDIAppForm.FileSave1Execute(Sender: TObject);
begin
  SaveDialog.Execute;
end;

procedure TSDIAppForm.FormResize(Sender: TObject);
begin
  Memo1.Left := 1;
  Memo1.Height := ClientHeight - Memo1.Top - statusbar.Height - 2;
  Memo2.Height := Memo1.Height;
  Memo1.Width := round(ClientWidth * 0.5)- 2;
  Memo2.Width := Clientwidth - Memo1.Width - 5;
  Memo2.Left := Memo1.Width + 5;
  Button1.Left := memo2.Left - 39;
  Label1.Left := memo2.Left + 100;
end;

procedure TSDIAppForm.Button1Click(Sender: TObject);
var i, j, h: integer;
    s, n, t: string;
    w: integer;
begin
  memo2.Clear;
  if is8bit then
    w := 2
  else
    w := 4;
  n := '';
  for i := 0 to memo1.Lines.Count do
  begin
    s:= trim(memo1.Lines[i]);
    j := 1;
    while j < (length(s)) do
    begin
      t := copy(s, j, w);
      if HexValidation(t, w) then
      begin
        if (t = StringOfChar('0', w)) or (t = '0a') then
        begin
          memo2.Lines.Add(n);
          n := '';
        end
        else
        begin
          h := strtoint('$' + t);
          n := n + char(h);
        end;
        //showmessage(inttostr(h));
        j := j + w - 1;
      end;
      inc(j);
    end;
  end;
  if n <> '' then memo2.Lines.Add(n);
end;

procedure TSDIAppForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TSDIAppForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TSDIAppForm.RadioButton2Click(Sender: TObject);
begin
  Memo2.Clear;
  is8Bit := RadioButton2.Checked
end;

function HexWordValidation(const pc: string): boolean;
var test, pct: string;
  i: Integer;
begin
  pct := AnsiUpperCase(trim(pc));
  result := false;
  test := '';
  if (length(pct)<4) or (length(pct)>4) then exit;
  for i := 1 to length(pct) do
  case pct[i] of
    '0'..'9': test := test + 'H';
    'A'..'F': test := test + 'H';
    else test := test + ' ';
  end;

  if test = 'HHHH' then result := true;       // 1234
end;

function HexValidation(const pc: string; const width: byte = 4): boolean;
var test, pct: string;
  i: Integer;
begin
  pct := AnsiUpperCase(trim(pc));
  result := false;
  test := '';
  if (length(pct) < width) or (length(pct) > width) then exit;
  for i := 1 to length(pct) do
  case pct[i] of
    '0'..'9': test := test + 'H';
    'A'..'F': test := test + 'H';
    else test := test + ' ';
  end;
  if test = StringOfChar('H', width) then result := true;       // 12[34]
end;

end.

unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, iComponent, iVCLComponent,
  iCustomComponent, iLed, iLedDiamond,formautosize, pngimage;

type
  Tfmain = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Splitter1: TSplitter;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    iLedDiamond1: TiLedDiamond;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmain: Tfmain;

implementation
uses regedit,common,reg,test,database,print,config;
{$R *.dfm}

procedure Tfmain.FormShow(Sender: TObject);
begin
    if GenerateMd5Code <> GetStrValueFromIni('reg','machineCode','md5') then
    begin
        freg.ShowModal;
    end;
end;
Const   Orignwidth=800;   Orignheight=600;
procedure Tfmain.FormCreate(Sender: TObject);
begin
 {   scaled:=true;
  if (screen.width<>orignwidth) then  
  begin    
    height:=longint(height)*longint(screen.height)div orignheight; 
    width:=longint(width)*longint(screen.width)div orignwidth;    
    scaleby(screen.width,orignwidth);
  end;  }
end;

procedure Tfmain.Button1Click(Sender: TObject);
begin
    ftest.Show;
end;

procedure Tfmain.Button3Click(Sender: TObject);
begin
    fdatabase.Show;
end;

procedure Tfmain.Button5Click(Sender: TObject);
begin
    application.Terminate;
end;

procedure Tfmain.Button4Click(Sender: TObject);
begin
fprint.Show;
end;

procedure Tfmain.Button2Click(Sender: TObject);
begin
fconfig.Show;
end;

end.

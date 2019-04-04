unit reg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  Tfreg = class(TForm)
    mcode: TLabeledEdit;
    Label1: TLabel;
    regcode: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  freg: Tfreg;

implementation
uses regedit,common;
{$R *.dfm}

procedure Tfreg.FormShow(Sender: TObject);
begin
    mcode.Text:=GetCode();
end;

procedure Tfreg.Button1Click(Sender: TObject);
var
 md5code:string;
begin
    md5code:= GenerateMd5Code;
    if md5code<> regcode.Text then
    begin
      showmessage('×¢²áÊ§°Ü£º×¢²áÂë´íÎó£¬ÇëÖØÐÂÊäÈë');
      SetStrValueToIni('tmp','machineCode','md5',md5code);
    end
    else
    begin
       showmessage('×¢²á³É¹¦');
       SetStrValueToIni('reg','machineCode','md5',md5code);
       freg.Close;
    end;
end;

procedure Tfreg.Button2Click(Sender: TObject);
begin
    application.Terminate;
end;

end.

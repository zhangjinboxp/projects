unit commConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,SPComm;

type
  TcommForm = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    BAUT: TComboBox;
    sciCOM: TComboBox;
    scibtn: TButton;
    Parity: TComboBox;
    stopbits: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Comm1: TComm;
    procedure scibtnClick(Sender: TObject);
    procedure sciCOMChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  commForm: TcommForm;

implementation
uses sci,common;
{$R *.dfm}

procedure TcommForm.scibtnClick(Sender: TObject);
begin
   if sciComs[sciCom.ItemIndex].sciPort=nil then
   begin
       sciComs[sciCom.ItemIndex].sciPort:=TComm.Create(Self);
       sciComs[sciCom.ItemIndex].sciPort.ByteSize:=_8;
       sciComs[sciCom.ItemIndex].sciPort.ParityCheck:=true;
       sciComs[sciCom.ItemIndex].sciPort.Parity:=TParity(Parity.ItemIndex);
       sciComs[sciCom.ItemIndex].sciPort.Inx_XonXoffFlow := False;
       sciComs[sciCom.ItemIndex].sciPort.Outx_XonXoffFlow := False;
       sciComs[sciCom.ItemIndex].sciPort.StopBits:=_1;
       sciComs[sciCom.ItemIndex].ctrlButton:=scibtn;
       sciComs[sciCom.ItemIndex].memo:=nil;
       sciComs[sciCom.ItemIndex].logEnable:=true;
       sciComs[sciCom.ItemIndex].logtype:=1;
   end;
   sciComs[sciCom.ItemIndex].sciPort.CommName:= scicom.Text;
   sciComs[sciCom.ItemIndex].sciPort.BaudRate:= strtoint(baut.Text);
   sciComs[sciCom.ItemIndex].ctrlButtonClick;
   pActiveSci:=@sciComs[sciCom.ItemIndex];
   if sciComs[sciCom.ItemIndex].isOn then commForm.Close;
end;

procedure TcommForm.sciCOMChange(Sender: TObject);
begin
   scibtn.Caption:='����';
   if sciComs[sciCom.ItemIndex].isOn then scibtn.Caption:='�ر�';
   if sciComs[sciCom.ItemIndex].sciPort<>nil then
          baut.ItemIndex:=baut.Items.IndexOf(inttostr(sciComs[sciCom.ItemIndex].sciPort.BaudRate));
end;


procedure TcommForm.FormCreate(Sender: TObject);
begin
    sciCOM.Items.Clear;
    GetComPorts(sciCOM.Items);
    sciCOM.ItemIndex:=0;
     {
    if MotCtrlPort<> '' then
    begin
       sciCOM.ItemIndex:= sciCOM.Items.IndexOf(MotCtrlPort);
       Baut.ItemIndex:= Baut.Items.IndexOf(MotCtrlBaud);
       scibtn.Click;

       pSciMotCtrl:=@sciComs[sciCom.ItemIndex];
       fmain.sciMotInitial;
    end;
    if TorqueSensorPort<> '' then
    begin
       sciCOM.ItemIndex:= sciCOM.Items.IndexOf(TorqueSensorPort);
       Baut.ItemIndex:= Baut.Items.IndexOf(TorqueSensorBaud);
       scibtn.Click;

       pSciTorqueSensor:=@sciComs[sciCom.ItemIndex];
       fmain.sciTorqueInitial;
    end;
     }
end;


end.

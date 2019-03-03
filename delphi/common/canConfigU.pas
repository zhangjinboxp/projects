unit canConfigU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ControlCAN,canCommon;

type
  TcanConfig = class(TForm)
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    baudratesBox: TComboBox;
    Button1: TButton;
    Label3: TLabel;
    channelBox: TComboBox;
    logtype: TComboBox;
    Label4: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure logtypeChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  canConfig: TcanConfig;
  
  chid:integer;
implementation
uses unit1;
{$R *.dfm}

procedure TcanConfig.Button1Click(Sender: TObject);
begin
    chid:= strtoint(channelBox.text)-1;
    canCh1.memo:=@form1.Memo1;
    canCh2.memo:=@form1.Memo1;
    if chid=0 then pcanCh:=@canCh1
    else pcanCh:=@canCh2;
    //pcanCh.logenable:=1;
    if Button1.Caption='连接CAN' then
    begin
        //pcanCh.logenable:=1;
        pcanCh.logtype:= logtype.ItemIndex;
        pcanCh.setBaudRate(strtoint(baudratesBox.text));
        pcanCh.ConfigChannel(0,chid,pcanCh);
        pcanCh.open;
        //Button1.Caption:='断开CAN';
    end
    else
    begin
        pcanCh.close;
        //Button1.Caption:='连接CAN';
    end;
    if pcanCh.connected then Button1.Caption:='断开CAN'
    else Button1.Caption:='连接CAN';
    form1.connectbtn.Caption :=  canConfig.Button1.Caption;
    if pcanCh.connected then canConfig.Close;
    {
    canCh1.logenable:=1;
    canCh1.setSendId($123);
    canCh1.setBaudRate(500);
    canCh1.ConfigChannel(0,0,@canCh1);
    canCh1.open;
    canCh1.sendFrame(snddata);
    canCh1.memo :=@memo1;

    canCh2.logenable:=1;
    canCh2.setSendId($123);
    canCh2.setBaudRate(500);
    canCh2.ConfigChannel(0,1,@canCh2);
    canCh2.open;
    canCh2.sendFrame(snddata);
    canCh2.memo :=@memo2;
    }
end;

procedure TcanConfig.logtypeChange(Sender: TObject);
begin
    chid:= strtoint(channelBox.text)-1;
    if chid=0 then pcanCh:=@canCh1
    else pcanCh:=@canCh2;
    pcanCh.logtype:= logtype.ItemIndex;
end;

procedure TcanConfig.Button2Click(Sender: TObject);
begin
    canConfig.Close;
end;

end.

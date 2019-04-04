unit test;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, iLedDiamond, iComponent, iVCLComponent,
  iCustomComponent, iLed, iLedRectangle, jpeg, Buttons, pngimage, DBCtrls,
  RzCmboBx,sci,StrUtils, Mask;

type
  Tftest = class(TForm)
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    LabeledEdit9: TLabeledEdit;
    GroupBox3: TGroupBox;
    LabeledEdit10: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    CheckBox1: TCheckBox;
    iLedRectangle1: TiLedRectangle;
    Memo1: TMemo;
    Button5: TButton;
    iLedDiamond1: TiLedDiamond;
    BitBtn1: TBitBtn;
    Image1: TImage;
    iLedRectangle2: TiLedRectangle;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    ComboBox2: TComboBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button6: TButton;
    DBEdit1: TDBEdit;
    Label4: TLabel;
    DBEdit2: TDBEdit;
    Label5: TLabel;
    DBEdit3: TDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    Label8: TLabel;
    Label9: TLabel;
    ComboBox1: TComboBox;
    Label10: TLabel;
    Button7: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure updateproductDrawIds;
    procedure ComboBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox1Change(Sender: TObject);
    procedure readAteqFinalInfo;
    procedure Button5Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
      procedure updateproductNames;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;
type
   PAteqInfo=^TAteqInfo;
   TAteqInfo = Object
   ahead:array[0..2] of BYTE;
   ProgramNum:WORD;
   nouse:WORD;
   FinalStatus:WORD;
   {FinalStatus Bit 0 = 1: pass part.
Bit 1 = 1: fail test part.
Bit 2 = 1: fail reference part.
Bit 3 = 1: alarm.
Bit 4 = 1: pressure error.
Bit 5 = 1: cycle end. Word 2
Bit 6 = 1: recoverable part.
Bit 7 = 1: CAL error or drift.
Bit 8 = 1: Calibration check error.
Bit 9 = 1: ATR error or drift.
Bits 10 / 11 / 12 / 13 / 14 = 1: unused.
Bit 15 = 1: key presence. }
   AlarmCode:WORD;
   Pressure:DWORD;
   PressureUnit:DWORD;
   Leak:DWORD;
   LeakUnit:DWORD;
   crc:WORD;
end;
type
   PAteqRealtimeInfo=^TAteqRealtimeInfo;
   TAteqRealtimeInfo = Object
   ahead:array[0..2] of BYTE;
   ProgramNum:WORD;
   nouse:WORD;
   testType:WORD;
   images:WORD;
   stepCode:WORD;
   Pressure:DWORD;
   PressureUnit:DWORD;
   Leak:DWORD;
   LeakUnit:DWORD;
   crc:WORD;
end;
var
  ftest: Tftest;
  //Slaveaddress+fun+Bytesnumber+Programn°(word 1)+Test type(word 2)+Relays image(word 3)+Alarm code(word 4)
     //数据是先低在高字节
     readRealtimeAteqParam:array[0..7] of BYTE=($01,$03,$00,$30,$00,13,$00,$00);
readAteqfinalResult:array[0..7] of BYTE=($01,$03,$23,$01,$00,$0b,$00,$00);
writeAteqProgramNo:array[0..10] of BYTE=($01,$10,$02,$00,$00,$01,$02,$00,$00,$00,$00);//倒数34两个字节为程序号减1
          Ateqstart:array[0..7] of BYTE=($01,$05,$00,$01,$ff,$00,$dd,$fa);
          Ateqreset:array[0..7] of BYTE=($01,$05,$00,$00,$ff,$00,$00,$00);
pAteqSci:^TSciCom=@sciComs[0];
pZebraSci:^TSciCom=@sciComs[0];
AteqRcvBuf:array[0..100] of BYTE;
AteqRcvLen:integer=0;
LastAteqInfo:TAteqInfo absolute AteqRcvBuf;
RealtimeAteqInfo:TAteqRealtimeInfo absolute AteqRcvBuf;
ateqResult:string='NG';
implementation
uses config,dbinterface,common,print,commconfig;
{$R *.dfm}

procedure AteqRcvSci(var pbuf;len: integer);
var
pdata: PCHAR;
tmp:DWORD;
addr:WORD;
data:DWORD;
begin
   pdata:=PCHAR(@pbuf);
   AteqRcvLen:=len;
   move(pdata^,AteqRcvBuf[0],len);
   pAteqSci.isidle:=1;
end;

procedure Tftest.BitBtn1Click(Sender: TObject);
begin

   if MessageBox(ftest.Handle,'确认退出测试界面？','提示',MB_ICONINFORMATION+MB_OkCancel)= idOk then
     begin
       ftest.Close;
     end;

end;

procedure Tftest.Button1Click(Sender: TObject);
begin
    if MessageBox(ftest.Handle,'确定要重置流水号？','提示',MB_ICONINFORMATION+MB_OkCancel)= idOk then
     begin
       dbio.ADOQuery1.edit;
       DbEdit1.Text := Format('%.4d',[0]) ;
       dbio.ADOQuery1.post; dbio.ADOQuery1.UpdateBatch();
     end;
end;

procedure Tftest.updateproductDrawIds;
var
i:integer;
begin
   combobox1.Items.Clear;

   with   fconfig.DBGrid1.DataSource.DataSet   do
   begin
      First;
      while   not   Eof   do
      begin
          combobox1.Items.Add(FieldByName('productDrawId').asstring);
          //其他处理
          //也可以xx:=FeildValues[FieldName];
          //其他处理etc...
          Next;//这句别忘了.
      end;
  end;
end;

procedure Tftest.FormShow(Sender: TObject);
var
i:integer;
begin
   updateproductDrawIds;
   updateproductNames;
end;

procedure Tftest.ComboBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var
  tmpstr:string;
begin
   tmpstr:= ComboBox1.Text;
   //memo1.Lines.Add('select * from config where productDrawId like '+quotedstr('%'+trim(ComboBox1.Text)+'%'));
    readADOQuery(dbio.ADOQuery1,'select * from config where productDrawId like '+quotedstr('%'+trim(ComboBox1.Text)+'%'));
    updateproductDrawIds;
    ComboBox1.AutoComplete:=false;
    ComboBox1.DroppedDown:=true;
    ComboBox1.Text:= tmpstr;
    ComboBox1.SelStart := length(trim(tmpstr));
    //label2.caption:=inttostr(length(tmpstr));

    if (strtoint(label2.caption)>0) and (strtoint(label2.caption)<5)   then
    begin
        iLedRectangle2.CenterLabelText:='图号输入错误';
    end
    else  if (strtoint(label2.caption)>0) and (strtoint(label2.caption)>=5)   then
    begin

    end;
end;

procedure Tftest.readAteqFinalInfo;
var
sqlstr:string;
begin
   
   delay(300);
   LabeledEdit7.Text:= inttostr(Swap16(LastAteqInfo.ProgramNum)+1);
      LabeledEdit8.Text:= floattostr(Swap32(LastAteqInfo.leak)*0.001)+' ml/s';
      LabeledEdit9.Text:= floattostr(Swap32(LastAteqInfo.Pressure)*0.001)+' ml/s';
   if ((LastAteqInfo.FinalStatus and $1)>0) or (((LastAteqInfo.FinalStatus and $6)>0) and (LastAteqInfo.AlarmCode=0))  then
   begin
       ateqResult:='OK';
   end
   else if ((LastAteqInfo.FinalStatus and $04)>0) then //告警
   begin
        ateqResult:='NG';
   end
   else if ((LastAteqInfo.FinalStatus and $10)>0) then //压力错误
   begin
       ateqResult:='NG';
   end;
   sqlstr:='insert into record([time],[barcode],[modelnum],[programnum],[pressure],[leakvalue],[testresult],[serialnum]) values(';
   sqlstr:=sqlstr+Quotedstr(FormatdateTime('yyyy-MM-dd hh:mm:ss',now))
      +',' +quotedstr(Dbedit2.Text)
      +',' +quotedstr(Dbedit3.Text)
      +',' +quotedstr(Dbedit5.Text)
      +',' +quotedstr(LabeledEdit9.Text)
      +',' +quotedstr(LabeledEdit8.Text)
      +',' +quotedstr(ateqResult)
      +',' +quotedstr(Dbedit1.Text)
      +')';
    //memo1.Lines.Add(sqlstr);
   execADOQuery(dbio.ADOQuery2,sqlstr);
   iLedRectangle1.CenterLabelText:=Dbedit3.Text+'-'+Dbedit5.Text+'测试完成 结果：'+ateqResult;
   iLedRectangle1.activeColor:=clYellow;
   memo1.Lines.Add('测试时间'+FormatdateTime('yyyy-MM-dd hh:mm:ss',now)+iLedRectangle1.CenterLabelText);
   pAteqSci.sendMobusRtu(Ateqreset,length(Ateqreset)-2);
   iLedRectangle1.CenterLabelText:='复位';
   memo1.Lines.Add('复位');
   delay(300);
end;

procedure Tftest.ComboBox1Change(Sender: TObject);
begin
     label2.caption:=inttostr(length(ComboBox1.Text));

     if -1<>ComboBox1.items.IndexOf(ComboBox1.Text) then
     begin
         pAteqSci.memo:=@memo1;
         pAteqSci.pRcvfun:= AteqRcvSci;
         ComboBox1.ItemIndex:=ComboBox1.items.IndexOf(ComboBox1.Text);
         iLedRectangle1.CenterLabelText:='等待获取程序号';
         readADOQuery(dbio.ADOQuery1,'select * from config where productDrawId like '+quotedstr('%'+trim(ComboBox1.Text)+'%'));
         fconfig.DBGrid1.DataSource.DataSet.First;
         ComboBox2.Text:= fconfig.DBGrid1.DataSource.DataSet.FieldByName('productName').asstring;
         memset(AteqRcvBuf,0,sizeof(AteqRcvBuf));
       {  pAteqSci.sendMobusRtu(readAteqParam,length(readAteqParam)-2);
       AteqRcvBuf
         delay(300);
         iLedRectangle1.CenterLabelText:='仪器未连接';
         writeAteqProgramNo[length(writeAteqProgramNo)-5]:= strtoint(LabeledEdit6.Text) and $ff;
         writeAteqProgramNo[length(writeAteqProgramNo)-4]:= (strtoint(LabeledEdit6.Text) shr 8) and $ff;
         pAteqSci.sendMobusRtu(writeAteqProgramNo,length(writeAteqProgramNo)-2);
         delay(300);

         pAteqSci.sendMobusRtu(AteqStart,length(AteqStart)-2);//前6个字节相同，即返回成功
         delay(300);
          if not CompareMem(@readAteqfinalResult, @AteqRcvBuf, 6)  then
          begin
             iLedRectangle1.CenterLabelText:='启动失败';
          end;
         iLedRectangle1.CenterLabelText:=LabeledEdit5.Text+'-'+LabeledEdit6.Text+'测试开始';
         iLedRectangle1.activeColor:=clYellow;
         memo1.Lines.Add(iLedRectangle1.CenterLabelText);

         fprint.printLabel(LabeledEdit5.Text+FormatdateTime('yyMMdd',now)+ rightstr(LabeledEdit2.Text,4));
         dbio.ADOQuery1.edit;
         fpirnt.DbEdit2.Text := FormatdateTime('yyMMdd',now);
         dbio.ADOQuery1.post;
         dbio.ADOQuery1.UpdateBatch();
        }
     end;
end;

procedure Tftest.Button5Click(Sender: TObject);
begin
    LabeledEdit8.Text:= '--';
end;

procedure Tftest.ComboBox2Change(Sender: TObject);
begin
     if -1<>ComboBox2.items.IndexOf(ComboBox2.Text) then
     begin
         ComboBox1.Text:= fconfig.DBGrid1.DataSource.DataSet.FieldByName('productDrawId').asstring;
         ComboBox1.OnChange(Sender);
     end;
end;

procedure Tftest.updateproductNames;
var
i:integer;
begin
   combobox2.Items.Clear;

   with   fconfig.DBGrid1.DataSource.DataSet   do
   begin
      First;
      while   not   Eof   do
      begin
          combobox2.Items.Add(FieldByName('productName').asstring);
          //其他处理
          //也可以xx:=FeildValues[FieldName];
          //其他处理etc...
          Next;//这句别忘了.
      end;
  end;
end;

procedure Tftest.ComboBox2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
    var
  tmpstr:string;
begin
   tmpstr:= ComboBox2.Text;
   //memo1.Lines.Add('select * from config where productName like '+quotedstr('%'+trim(ComboBox2.Text)+'%'));
    readADOQuery(dbio.ADOQuery1,'select * from config where productName like '+quotedstr('%'+trim(ComboBox2.Text)+'%'));
    updateproductNames;
    ComboBox2.AutoComplete:=false;
    ComboBox2.DroppedDown:=true;
    ComboBox2.Text:= tmpstr;
    ComboBox2.SelStart := length(trim(tmpstr));
    //label2.caption:=inttostr(length(tmpstr));

end;

procedure Tftest.Button2Click(Sender: TObject);
begin
commForm.ShowModal;
end;

procedure Tftest.Button3Click(Sender: TObject);
begin
   pAteqSci:=pActiveSci;
   pAteqSci.memo:=@memo1;
         pAteqSci.pRcvfun:= AteqRcvSci;
    pAteqSci.sendMobusRtu(readAteqfinalResult,length(readAteqfinalResult)-2);
    readAteqFinalInfo;
end;

procedure Tftest.Button4Click(Sender: TObject);
begin
   pAteqSci:=pActiveSci;
   pAteqSci.memo:=@memo1;
         pAteqSci.pRcvfun:= AteqRcvSci;
writeAteqProgramNo[length(writeAteqProgramNo)-4]:= 2;
         writeAteqProgramNo[length(writeAteqProgramNo)-3]:= 0;
         pAteqSci.sendMobusRtu(writeAteqProgramNo,length(writeAteqProgramNo)-2);
       
         delay(300);
end;

procedure Tftest.Button6Click(Sender: TObject);
begin
 fprint.printlabel('1234567890012345678901234');
end;

procedure Tftest.Button7Click(Sender: TObject);
begin
pAteqSci:=pActiveSci;
   pAteqSci.memo:=@memo1;
         pAteqSci.pRcvfun:= AteqRcvSci;
   pAteqSci.sendMobusRtu(readRealTimeAteqParam,length(readRealTimeAteqParam)-2);
   readAteqFinalInfo;
end;

end.

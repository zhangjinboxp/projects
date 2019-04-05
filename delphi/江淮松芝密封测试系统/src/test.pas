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
    Timer1: TTimer;
    BitBtn2: TBitBtn;
    Memo2: TMemo;
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
    procedure Button6Click(Sender: TObject);
    procedure readAteqRealTimeInfo;
    procedure Timer1Timer(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;
type
   PAteqInfo=^TAteqInfo;
   TAteqInfo = packed record
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
Bit 15 = 1: key presence. 
Do not use these results while the Bit 5 (cycle end is not 1).
Use only Bit 5 (cycle end)and Bit 15 (key presence).
}
   AlarmCode:WORD;
   Pressure:DWORD;
   PressureUnit:DWORD;
   Leak:DWORD;
   LeakUnit:DWORD;
   crc:WORD;
end;
type
   PAteqRealtimeInfo=^TAteqRealtimeInfo;
   TAteqRealtimeInfo = packed record
    slaveAddr:BYTE;
   fun:BYTE;
   bytesCnt:BYTE;
   ProgramNum:WORD;
   resultCnt:WORD;
   testType:WORD;
								   {Test type: invalid test, leak test, mode P test, mode D
										test, operator test.
										 Invalid: 0000.
										 Leak: 1000.
										 Blockage mode: 2000.
										 Desensitized mode: 3000.
										 Operator mode: 4000.
										 Burst test: 5000
										 Volume test: 6000}
   status:WORD;
					   			{ Bit 0 = 1: pass part.
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
										Bit 15 = 1: key presence. 
										Do not use these results while the Bit 5 (cycle end is not 1).
										Use only Bit 5 (cycle end)and Bit 15 (key presence).
										}
   stepCode:WORD;
											   {
															00 00 Pre-fill.预充气
															00 01 Pre-dump.预排气
															00 02 Sealed component fill.密封部件充气
															00 03 Sealed component stabilization.密封部件保压
															00 04 Fill.充气
															00 05 Stabilization.保压
															00 06 Test.测试
															00 07 Dump.排气
															FF FF No step in progress.
											   }
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
pAteqSci:^TSciCom absolute pActiveSci;
pZebraSci:^TSciCom=@sciComs[0];
AteqRcvBuf:array[0..100] of BYTE;
AteqRcvLen:integer=0;
LastAteqInfo:TAteqInfo absolute AteqRcvBuf;
RealtimeAteqInfo:TAteqRealtimeInfo absolute AteqRcvBuf;
ateqResult:string='NG';
stepCodeInfo:array[0..7] of string=('预充气',                                    
																		'预排气',                                    
																		'密封部件充气',                
																		'密封部件保压',        
																		'充气',                                          
																		'保压',                                 
																		'测试',                                          
																		'排气');
implementation
uses config,dbinterface,common,print,commconfig;
{$R *.dfm}

function getStatusInfo(status:WORD):string;
begin
    if isBitSet(status,0) then
   begin
       result:='OK';
   end
   else if ((status and $1e)>0) then 
   begin
        result:='NG';
   end
   
end;

function getStepInfo(stepcode:WORD):string;
begin
   if stepcode=$ffff then result:='No step'
   else if stepcode<8 then  result:=stepCodeInfo[stepcode];   
end;

procedure Tftest.readAteqRealTimeInfo;
var
sqlstr:string;
status:WORD;

begin
    memset(AteqRcvBuf,0,20);
    pAteqSci.sendMobusRtu(readRealtimeAteqParam,length(readRealtimeAteqParam)-2);
    delay(300);
    if not CompareMem(@readRealtimeAteqParam, @AteqRcvBuf, 2) then
    begin
        iLedRectangle1.CenterLabelText:='读实时数据无响应';
        iLedRectangle1.activeColor:=clYellow;
        exit;
    end;
    iLedRectangle1.activeColor:=cllime;
   iLedRectangle1.CenterLabelText:=getStepInfo((RealtimeAteqInfo.stepCode));
   LabeledEdit10.Text:= inttostr((RealtimeAteqInfo.ProgramNum)+1);
   LabeledEdit11.Text:= floattostr((RealtimeAteqInfo.Pressure)*0.001)+' ml/s';
   status:=(RealtimeAteqInfo.Status);
   if not isBitSet(status,5) then
   begin
       checkbox1.checked:=true;
       readAteqFinalInfo;
       //iLedRectangle1.CenterLabelText:='测试结束';
   end
   else  checkbox1.checked:=false;
   
   
end;

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
       Timer1.Enabled:=false;
       if pAteqSci.isOn then pAteqSci.ctrlButtonClick;;
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
   if pAteqSci.isOn then
   begin
      button2.Visible:=false;
      pAteqSci.memo:=@memo2;
      pAteqSci.pRcvfun:= AteqRcvSci;
   end
   else
   begin
      button2.Visible:=true;
      iLedRectangle2.CenterLabelText:='通讯端口不存在！';
   end;
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
        //iLedRectangle1.activeColor:=clYellow;
    end
    else  if (strtoint(label2.caption)>0) and (strtoint(label2.caption)>=5)   then
    begin

    end;
end;



procedure Tftest.readAteqFinalInfo;
var
sqlstr:string;
status:WORD;

begin
   pAteqSci.sendMobusRtu(readAteqfinalResult,length(readAteqfinalResult)-2);
   delay(300);
   LabeledEdit7.Text:= inttostr((LastAteqInfo.ProgramNum)+1);
      LabeledEdit8.Text:= floattostr((LastAteqInfo.leak)*0.001)+' ml/s';
      LabeledEdit9.Text:= floattostr((LastAteqInfo.Pressure)*0.001)+' ml/s';
   status:=(LastAteqInfo.FinalStatus);
   if ((status and $1)>0) or (((status and $6)>0) and (LastAteqInfo.AlarmCode=0))  then
   begin
       ateqResult:='OK';
   end
   else if ((status and $04)>0) then //告警
   begin
        ateqResult:='NG';
   end
   else if ((status and $10)>0) then //压力错误
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
   
   iLedRectangle1.activeColor:=cllime;
   memo1.Lines.Add('测试时间'+FormatdateTime('yyyy-MM-dd hh:mm:ss',now)+iLedRectangle1.CenterLabelText);
   pAteqSci.sendMobusRtu(Ateqreset,length(Ateqreset)-2);
   iLedRectangle1.CenterLabelText:='复位';
   memo1.Lines.Add('复位');
   fprint.printLabel(Dbedit2.Text+FormatdateTime('yyMMdd',now)+ rightstr(Dbedit1.Text,4));
   dbio.ADOQuery1.edit;
   DbEdit1.Text := Format('%.4d',[strtointdef(DbEdit1.Text,0)+strtointdef(DbEdit4.Text,1)]) ;
   fprint.DbEdit2.Text := FormatdateTime('yyMMdd',now);
   dbio.ADOQuery1.post;
   dbio.ADOQuery1.UpdateBatch();

end;

procedure Tftest.ComboBox1Change(Sender: TObject);
var
programNo:integer;
begin
     label2.caption:=inttostr(length(ComboBox1.Text));

     if -1<>ComboBox1.items.IndexOf(ComboBox1.Text) then
     begin
         if pAteqSci.isOn then
          begin
              button2.Visible:=false;
              pAteqSci.memo:=@memo2;
              pAteqSci.pRcvfun:= AteqRcvSci;
          end;
         timer1.Enabled:=false;
         ComboBox1.ItemIndex:=ComboBox1.items.IndexOf(ComboBox1.Text);
         iLedRectangle2.CenterLabelText:='等待获取程序号';
         iLedRectangle1.activeColor:=cllime;
         readADOQuery(dbio.ADOQuery1,'select * from config where productDrawId like '+quotedstr('%'+trim(ComboBox1.Text)+'%'));
         fconfig.DBGrid1.DataSource.DataSet.First;
         if strtointdef(DbEdit1.Text,0) <> strtointdef(FormatdateTime('yyMMdd',now),0) then
        begin
            DbEdit1.Text := Format('%.4d',[0]) ;
        end;
         ComboBox2.Text:= fconfig.DBGrid1.DataSource.DataSet.FieldByName('productName').asstring;
         memset(AteqRcvBuf[0],0,20);
         while true do
         begin
	         pAteqSci.sendMobusRtu(readRealtimeAteqParam,length(readRealtimeAteqParam)-2);
	         delay(300);
	         if RealtimeAteqInfo.fun<>readRealtimeAteqParam[1] then
	         begin
	            iLedRectangle2.CenterLabelText:='仪器未连接';
	            //iLedRectangle1.activeColor:=clYellow;
	            delay(1000);
	            continue;
	         end;
           programNo:= (LastAteqInfo.ProgramNum)+1;
	         break;
         end;

         if  programNo<>strtoint(dbEdit5.Text) then
         begin
	         
	         writeAteqProgramNo[length(writeAteqProgramNo)-4]:= strtoint(dbEdit5.Text) and $ff;
	         writeAteqProgramNo[length(writeAteqProgramNo)-3]:= (strtoint(dbEdit5.Text) shr 8) and $ff;
	         while true do
	         begin
	           memset(AteqRcvBuf,0,20);
		         pAteqSci.sendMobusRtu(writeAteqProgramNo,length(writeAteqProgramNo)-2);
		         delay(300);
						  if not CompareMem(@writeAteqProgramNo, @AteqRcvBuf, 6) then
			         begin
			            iLedRectangle2.CenterLabelText:='写程序号失败';
			           // iLedRectangle1.activeColor:=clYellow;
			            delay(1000);
			            continue;
		           end;
		         break;
	         end;
         end;
         iLedRectangle2.CenterLabelText:='测试中';
         timer1.Enabled:=true;
         {pAteqSci.sendMobusRtu(AteqStart,length(AteqStart)-2);//前6个字节相同，即返回成功
         delay(300);
          if not CompareMem(@readAteqfinalResult, @AteqRcvBuf, 6)  then
          begin
             iLedRectangle1.CenterLabelText:='启动失败';
             iLedRectangle1.activeColor:=clYellow;
          end;}
         iLedRectangle1.CenterLabelText:=dbEdit2.Text+'测试开始';
         
         memo1.Lines.Add(iLedRectangle1.CenterLabelText);


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
    readAteqFinalInfo;
end;

procedure Tftest.Button6Click(Sender: TObject);
begin
 fprint.printlabel('1234567890012345678901234');
end;

procedure Tftest.Timer1Timer(Sender: TObject);
begin
    readAteqRealTimeInfo;
end;

procedure Tftest.BitBtn2Click(Sender: TObject);
begin
   button2.Visible:=not button2.Visible;
   button3.Visible:=not button3.Visible;
   button6.Visible:=not button6.Visible;
   memo2.Visible:=not memo2.Visible;
end;

end.

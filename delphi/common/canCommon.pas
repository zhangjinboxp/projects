unit canCommon;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,StdCtrls,ControlCAN;

type
   TCanVar=record
     name:string;
     messageid:integer;
     startbit:integer;
     bitlen:integer;
     visible:integer;
     multivar:double;
     addvar:integer;
     value:integer;
end;
type
   TUdsId=record
   phyId: DWORD;
   funId: DWORD;
   rspId: DWORD;
end;
type  
  {使用record定义一个结构体}
  TCanCom = Object
    //_ : AutoRecord;
    //procedure Operator_Initialize(); //初始化
    //procedure Operaor_Finalize(); //反初始化
    {定义结构体的属性}
    public
    address:Pointer;
       devtype : DWORD;
   devId : DWORD;
      channelId: DWORD;
   connected : bool;
       timing0:byte;
   timing1:byte;
    sendId:DWORD;
    RcvThreadhandle : integer;
    SendThreadhandle : integer;
    fileByteBuf:array[0..100000] of byte;
    sendbuf:array[0..10000] of byte;
    rcvbuf:array[0..10000] of byte;
    rcvPos: integer;
    rcvLen: integer;
    sendframeDelayms:integer;
    receiveFlowCtlFrameflg:BYTE;
    FlowCtlBlockSize:integer;
    FlowCtlBlockTimeOut:integer;
    rcvOkflg:BYTE;
    rcvpendingflg:BYTE;
    applicationId:BYTE;
    errflg:BYTE;
    addrType:BYTE;
    logenable:BYTE;
    logtype:BYTE;//0 文本 1 memo
    lastTickCount: Longint;
    memo : ^TMemo;
    udsid:TUdsId;
    pRcvfun:procedure(msg:VCI_CAN_OBJ);
    {定义结构体的过程函数}
    procedure setSendId(id:DWORD);
    procedure setBaudRate(baudrate:DWORD);
    procedure sendFrame(var data;id:DWORD=0);
    procedure sendFirstTpData(var data;len:WORD);
    procedure sendConsecutiveTpData(var data;index:WORD);
    procedure sendUdsData(var data; len:WORD);
    procedure sendFlowCtrl;
    procedure WaitFlowCtrlResponse;
    procedure receiveFrame(msg:VCI_CAN_OBJ);
    procedure receiveUdsFrame(msg:VCI_CAN_OBJ);
    procedure receiveUdsMessage;
    procedure ConfigChannel(deviceId : DWORD;chId: DWORD;addr:Pointer;dtype : DWORD=4);
    procedure open;
    procedure close;
    function getCanValueInByte(var data;sbit:integer; len:integer=1):integer;
    procedure sendValueOnce(ID : UINT;sbit:integer; value:integer=1);
    procedure sendKeyValue(ID : UINT;sbit:integer; value:integer=1);
    procedure setBufValue(var data;sbit:integer; value:integer=1);
    procedure print(log:string);

  end;
  
type
   TCanChannel=record
   channelId: DWORD;
   connected : bool;
   canCom:TCanCom;
end;

type
   TCanDev=record
   channells: array[0..1] of TCanChannel;
   devtype : DWORD;
   devId : DWORD;
end;
type
   TBaudRate=record
   baudrate:integer;//输入 k
   sjw:byte;//总线重同步跳转宽度
   BRP:byte;//分频系数
   samCnt:byte;//采样次数0 三倍：总线采样三次：建议在中/低速总线（A 和 B 级）使用，有处于过滤总线上毛刺
                //1 单倍：总线采样一次；建议使用在高速总线上（SAEC 级）
   TSEG1,TSEG2:byte;//采样点占整个位时间的位置
   timing0:byte;
   timing1:byte;

end;
var
canCh1:TCanCom=(pRcvfun:nil);
canCh2:TCanCom=(pRcvfun:nil);
pcanCh:^TCanCom=@canCh1;
const
     baudConfig:array[0..13] of TBaudRate=((baudrate:10   ;timing0:$31;timing1:$1C),
																					(baudrate:20   ;timing0:$18;timing1:$1C),
																					(baudrate:40   ;timing0:$87;timing1:$FF),
																					(baudrate:50   ;timing0:$09;timing1:$1C),
																					(baudrate:80   ;timing0:$83;timing1:$FF),
																					(baudrate:100  ;timing0:$04;timing1:$1C),
																					(baudrate:125  ;timing0:$03;timing1:$1C),
																					(baudrate:200  ;timing0:$81;timing1:$FA),
																					(baudrate:250  ;timing0:$01;timing1:$1C),
																					(baudrate:400  ;timing0:$80;timing1:$FA),
																					(baudrate:500  ;timing0:$00;timing1:$1C),
																					(baudrate:666  ;timing0:$80;timing1:$B6),
																					(baudrate:800  ;timing0:$00;timing1:$16),
																					(baudrate:1000 ;timing0:$00;timing1:$14));
implementation
uses common;

procedure TCanCom.ConfigChannel(deviceId : DWORD;chId: DWORD;addr:Pointer;dtype:DWORD=4);
begin
   devtype := dtype;
   devId :=deviceId;
   channelId:=chId;
   address:=addr;
end;
procedure TCanCom.receiveUdsMessage;
begin
   if applicationId+$40=rcvbuf[0] then
   begin
    //memo1.Lines.Add('applicationId：'+inttohex(applicationId,2));
    rcvOkflg:=1;
    if applicationId=$22 then
    begin
    print('软件版本：'+char(rcvbuf[3])+char(rcvbuf[4])+char(rcvbuf[5])+char(rcvbuf[6])
              +char(rcvbuf[7])+char(rcvbuf[8])+char(rcvbuf[9])+char(rcvbuf[10])+char(rcvbuf[11]));
    end;
   end
   else if (applicationId=$27) and (rcvbuf[1]=$21) then
    begin
        //seed[0]:=rcvbuf[2];seed[1]:=rcvbuf[3];seed[2]:=rcvbuf[4];seed[3]:=rcvbuf[5];
        print('种子：'+inttohex(rcvbuf[2],2)+inttohex(rcvbuf[3],2)+inttohex(rcvbuf[4],2)+inttohex(rcvbuf[5],2));
   end
   else if (applicationId=$31) and (rcvbuf[1]=$ff) and (rcvbuf[2]=$01) then
    begin
    end
   else
   begin
      print('appId:'+inttohex(applicationId,2)
                        +' receive id:'+inttohex(rcvbuf[0],2));
   end;
   if rcvbuf[0]=$7f then
   begin
   
   if rcvbuf[2]=$78 then
   begin
   rcvpendingflg:=1;
   print('应答挂起');
   end
   else print('响应错误');
   end;
end;
procedure TCanCom.receiveUdsFrame(msg:VCI_CAN_OBJ);
var
frameType:BYTE;
i:integer;
begin
    if udsid.rspId = msg.id then
    begin
        frameType:= (msg.Data[0] and $f0) shr 4;
        if frameType=0 then
        begin
          rcvPos:=0;
          Move(msg.Data[1],rcvbuf[rcvPos],msg.DataLen-1);
          rcvPos:=rcvPos+msg.DataLen-1;
          rcvLen:=msg.DataLen-1;
          receiveUdsMessage;
        end
        else if frameType=1 then
        begin
          rcvPos:=0;
          Move(msg.Data[2],rcvbuf[rcvPos],msg.DataLen-1);
          rcvPos:=rcvPos+6;
          rcvLen:=(msg.Data[0] and $0f)*256+msg.Data[1];
          delay(5);
          sendFlowCtrl;
        end
        else if frameType=2 then
        begin
          Move(msg.Data[1],rcvbuf[rcvPos],msg.DataLen-1);
          rcvPos:=rcvPos+msg.DataLen-1;
          if rcvPos>=rcvLen then
          begin
              receiveUdsMessage;
          end;
        end
        else if frameType=3 then
        begin
           receiveFlowCtlFrameflg:=1;
           if logenable=1 then print('flow ctrl frame');
           if (msg.Data[0] and $0f)=0 then
           begin
           FlowCtlBlockSize:=msg.Data[1];
           FlowCtlBlockTimeOut:=msg.Data[2];
           end;
        end
    end;
end;

procedure TCanCom.receiveFrame(msg:VCI_CAN_OBJ);
var
i:integer;
begin

end;
function ReceiveThread(param : Pointer): integer;
var
canChannel : ^TCanCom;
receivedata : array[0..49] of VCI_CAN_OBJ;
len : integer;
j : integer;
i : integer;
str : AnsiString;
tmpstr :AnsiString;
memo : ^TMemo;
errinfo : VCI_ERR_INFO;
begin
    canChannel:=param;
    while TRUE do
    begin
    if not canChannel.connected then break;
      Sleep(2);
      len:=VCI_Receive(canChannel.devtype,canChannel.devid,canChannel.channelid,@receivedata[0],50,200);
      if len<=0 then
        begin
          continue;
        end;

      for i:=0 to len-1 do
        begin
          //if canChannel.isIdForbid(receivedata[i].ID) then continue;
	    		if receivedata[i].RemoteFlag=0 then
          begin
    			 	str:='';
            tmpstr:='';
            if receivedata[i].DataLen>8 then
              receivedata[i].DataLen:=8;
          if canChannel.logenable=1 then
          begin
    				for j:=0 to receivedata[i].DataLen-1 do
              begin
      					tmpstr:=IntToHex(receivedata[i].Data[j],2)+' ';
	      				str:=str+tmpstr;
              end;
              tmpstr:='time:'+IntTostr(receivedata[i].TimeStamp)+' '
                            +'ID:0x'+IntToHex(receivedata[i].ID,1)+' ' ;

          canChannel.print('receive '+tmpstr+':');
          canChannel.print('      '+str);
         end;
          canChannel.receiveFrame(receivedata[i]);
          if @canChannel.pRcvfun<>nil then canChannel.pRcvfun(receivedata[i]);
          end;
        end;
    end;
end;

function SendThread(param : Pointer): integer;
var
canChannel : ^TCanCom;
begin
    canChannel:=param;
    //canChannel.memo.lines.add('SendThread************');
    while TRUE do
    begin
    //sleep(5000);
    //canChannel.memo.lines.add('SendThread');
    if not canChannel.connected then break;
    end;
end;
procedure TCanCom.open;
var
index,i: integer;
ret: integer;
cannum: integer;
threadid: LongWord;
initconfig : VCI_INIT_CONFIG;
begin
    if connected then
    begin
        //ret:= VCI_ConnectDevice(devtype,devId);
        //if ret <> 1 then close
        //else
        exit;
    end;
    ret:= VCI_OpenDevice(devtype,devId,0);
    if (ret<>1) and (ret<>0) then
    begin
        ShowMessage('打开设备失败')
    end
    else if (ret=0) or (ret=1) then
      begin
        initconfig.AccCode:=StrToInt('0x00000000');
        initconfig.AccMask:=StrToInt('0xffffffff');
        initconfig.Timing0:=timing0;
        initconfig.Timing1:=timing1;
        initconfig.Filter:=0;
        initconfig.Mode:=0;
        ret:=VCI_InitCAN(devtype,devid,channelid,@initconfig);
        if ret <>1 then
          begin
            Showmessage('初始化CAN'+inttostr(channelid)+'失败:'+inttostr(ret));
            Exit;
          end;
        connected:=true;
        RcvThreadhandle:=BeginThread(0,0,ReceiveThread,address,0,threadid);
        SendThreadhandle:=BeginThread(0,0,SendThread,address,0,threadid);

        if VCI_StartCAN(devtype,devid,channelid)<>1 then
        ShowMessage('启动CAN失败')
        else
        begin
         print('启动CAN成功');
        end;
      end;
end;

procedure TCanCom.close;
begin
  if connected then
  begin
    connected:=false;
    WaitForSingleObject(RcvThreadhandle,2000);
    RcvThreadhandle:=0;
    WaitForSingleObject(SendThreadhandle,2000);
    SendThreadhandle:=0;
    VCI_CloseDevice(devtype,devid);
  end;
end;

procedure TCanCom.setSendId(id:DWORD);
begin
    sendId:=id;
end;


procedure TCanCom.setBaudRate(baudrate:DWORD);
var
i:integer;
begin
    for i:=0 to Length(baudConfig) do 
    begin
        if baudrate=baudConfig[i].baudrate then
        begin
          timing0:=baudConfig[i].timing0;
          timing1:=baudConfig[i].timing1;
          break;
        end;
    end;
   

end;

procedure TCanCom.sendFrame(var data;id:DWORD=0);
var
  senddata : VCI_CAN_OBJ;
  strdata:string;
  i,retcode,retrycnt:integer;
begin
  if not connected then  Exit;

  delay(sendframeDelayms);
  senddata.SendType:=0;
  senddata.RemoteFlag:=0;
  senddata.ID:=sendId;
  if id>0 then senddata.ID:=id;
  senddata.ExternFlag:=0;
  if senddata.ID>$7ff then senddata.ExternFlag:=1;

  senddata.DataLen:=8;
  Move(data,senddata.Data,senddata.DataLen);
  strdata:='';
  for i:=0 to 7 do
    begin
      strdata:=strdata+inttohex(senddata.Data[i],2)+' ';
    end;
    if logenable=1 then
    begin
    print('send time:'+inttostr(GetTickCount())+'ID:0x'+inttohex(senddata.ID,2));
    print('       '+strdata);
    end;
    retrycnt:=0;
    repeat
    begin
      retcode:= VCI_Transmit(devtype,devId,channelId,@senddata,1);
      if retcode=1 then
      begin
    //print('发送成功 ');
      end
      else
      begin
          retrycnt:=retrycnt+1;
          print('发送失败'+inttostr(retcode));
          delay(sendframeDelayms);
          VCI_ClearBuffer(devtype,devId,channelId);
      end;
    end;
    until (retcode=1) or (retrycnt>10);

end;
procedure TCanCom.sendFirstTpData(var data;len:WORD);
var
  i:integer;
  snddata : array[0..7] of BYTE;
begin
    fillchar(snddata,sizeof(snddata),0);
    snddata[0]:=byte((1 shl 4)+(len shr 8));
    snddata[1]:=byte(len and $ff);
    Move(data,snddata[2],6);
    sendFrame(snddata[0]);
end;
procedure TCanCom.sendConsecutiveTpData(var data;index:WORD);
var
  i:integer;
  snddata : array[0..7] of BYTE;
begin
    fillchar(snddata,sizeof(snddata),0);
    snddata[0]:=(2 shl 4)+(index and ($0f));
    Move(data,snddata[1],7);
    sendFrame(snddata[0]);
end;
procedure TCanCom.sendUdsData(var data; len:WORD);
var
  senddata : VCI_CAN_OBJ;
  strdata:string;
  i,frameCnt:integer;
  pdata:PCHAR;
begin
  if not connected then  Exit;
  sendframeDelayms:=5;
  errflg:=0;
  if len<8 then
  begin
    sendbuf[0]:=len;
    Move(data,sendbuf[1],len);
    //print(inttohex(sendbuf[1],2)+inttohex(sendbuf[2],2));
    sendFrame(sendbuf[0]);
    applicationId:=sendbuf[1];
  end
  else
  begin
      sendFirstTpData(data, len);
      pdata:= PChar(@data);
      applicationId:=BYTE(pdata[0]);
      waitFlowCtrlResponse;
      if errflg=1 then exit;
      frameCnt:= ((len-6) div 7) +1;

       for i:=0 to frameCnt-1 do
       begin
         sendConsecutiveTpData(pdata[i*7+6],((i+1) mod 16));
         if (i>0) and ((i+1) mod FlowCtlBlockSize =0) then waitFlowCtrlResponse;
         if errflg=1 then exit;
       end;
  end;
end;

procedure TCanCom.sendFlowCtrl;
var
i,id:integer;
snddata : array[0..7] of BYTE;
begin
    fillchar(snddata,sizeof(snddata),0);
    snddata[0]:=$30;
    snddata[1]:=$00;
    snddata[2]:=$0a;
    sendFrame(snddata[0]);
end;

procedure TCanCom.WaitFlowCtrlResponse;
begin
    if WaitFlgTrue(@receiveFlowCtlFrameflg,5000) <> 0 then
    begin
        print('没收到流控帧');
        errflg:=1;
        //raise Exception.Create('没收到流控帧');
    end;
end;

function TCanCom.getCanValueInByte(var data;sbit:integer; len:integer=1):integer;
var
i:integer;
pdata: PChar;
begin
  pdata:=PChar(@data);
  result:=byte(pdata[sbit shr 3]);
  result:=(result shr (sbit mod 8)) and ($ff shr (8-len));
end;

procedure TCanCom.sendKeyValue(ID : UINT;sbit:integer; value:integer=1);
var
i:integer;
snddata : array[0..7] of BYTE;
begin
  fillchar(snddata,sizeof(snddata),0);
  snddata[sbit shr 3]:=byte(value shl (sbit mod 8));
  sendFrame(snddata,id);
  Delay(100);
  sendFrame(snddata,id);
  Delay(100);
  //if isNotSendKeyReset=0 then
  begin
  fillchar(snddata,sizeof(snddata),0);
  sendFrame(snddata,id);
  end;
  //isNotSendKeyReset:=0;
end;

procedure TCanCom.sendValueOnce(ID : UINT;sbit:integer; value:integer=1);
var
i:integer;
snddata : array[0..7] of BYTE;
begin
  fillchar(snddata,sizeof(snddata),0);
  snddata[sbit shr 3]:=byte(value shl (sbit mod 8));
  sendFrame(snddata,id);
end;
procedure TCanCom.setBufValue(var data;sbit:integer; value:integer=1);
var
i,tvalue:integer;
pdata: PCHAR;
tmp: BYTE;
begin
  pdata:=PCHAR(@data);
  tvalue:=value shl (sbit mod 8);
  if tvalue>$ff then
  begin
     tmp:= byte(pdata[(sbit shr 3)-1])+BYTE(tvalue shr 8);
     pdata[(sbit shr 3)-1]:=char(tmp);
  end;
  tmp:= byte(pdata[(sbit shr 3)])+BYTE(tvalue);
  pdata[sbit shr 3]:=char(tmp);

end;

procedure TCanCom.print(log:string);
begin
    if logenable=1 then
    begin
        if memo<>nil then myprint(log,logtype,memo^)
        else myprint(log,logtype);
    end;
end;
end.

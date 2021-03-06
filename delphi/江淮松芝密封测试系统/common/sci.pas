unit sci;

interface
uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,StdCtrls,ComCtrls,SPComm;

type
   PModbus=^TModbus;
   TModbus = Object
   commid:BYTE;
   funId:BYTE;
   data:array[0..7] of BYTE;
   crc:WORD;
end;
type
  {使用record定义一个结构体}
  PSciCom =^TSciCom;
  TSciCom = Object
  isOn:boolean;
  isidle:BYTE;
  ctrlButton: TButton;
  sciPort:TComm;
  memo : ^TMemo;
  logEnable:boolean;
  logtype:BYTE;//0 文本 1 memo
  rbufsci:array[0..100] of BYTE;
  pRcvfun:procedure(var pbuf;len: integer);
  initialOnOpen:procedure;
  procedure start;
  procedure close;
  procedure ctrlButtonClick;
  procedure print(log:string);
  procedure sendSciBuf(var sbuf;len:integer;sciComm:TComm=nil);
  procedure ReceiveData(Sender: TObject; Buffer: Pointer;BufferLength: Word);
  procedure sendMobusRtu(Var buf; len:integer);

end;
var
  sciComs:array[0..12] of TSciCom;
  pActiveSci:^TSciCom=@sciComs[0];
  pActiveSci2:^TSciCom=@sciComs[1];
implementation
uses common;

procedure TSciCom.print(log:string);
begin
    if logenable then
    begin
        if memo<>nil then myprint(log,logtype,memo^)
        else myprint(log,logtype);
    end;
end;

procedure TSciCom.start;
begin
    sciPort.StartComm;

end;

procedure TSciCom.close;
begin
    sciPort.StopComm;
end;

procedure TSciCom.ctrlButtonClick;
begin
  if (not isOn) or (ctrlButton.Caption='启动') then
	begin
    sciPort.OnReceiveData:=ReceiveData;
		sciPort.StartComm;
    isOn:=true;
    ctrlButton.Caption:='关闭';
    if @initialOnOpen<>nil then initialOnOpen;
	end
	else
	begin
		sciPort.StopComm;
    isOn:=false;
    ctrlButton.Caption:='启动';
	end;
end;

procedure TSciCom.sendSciBuf(var sbuf;len:integer;sciComm:TComm=nil);
var
  i:integer;
	commflg:boolean;
	viewstring:string;
	pdata: PCHAR;
begin
  if not ison then begin print('端口未打开'); exit;end;
	viewstring:='';
	commflg:=true;
	pdata:=PCHAR(@sbuf);
	for i:=0 to len-1 do
	begin
    if not sciPort.writecommdata(@pdata[i],1) then
		begin
			commflg:=false;
			break;
		end;

		//发送时字节间的延时
		sleep(1);
		viewstring:=viewstring+inttohex(BYTE(pdata[i]),2)+' ';
	end;
 // sciPort.StopComm;
 //   sciPort.StartComm;
	print('发送 :  '+DateTimeToStr(NOW));
	//viewstring:=viewstring;
	print(viewstring);
	print(' ');
	if not commflg then print('发送失败 !');
end;

procedure TSciCom.ReceiveData(Sender: TObject; Buffer: Pointer;BufferLength: Word);
var
	i:integer;
	viewstring:string;
begin
	viewstring:='';
	move(buffer^,pchar(@rbufsci)^,bufferlength);

    print('接收:  '+DateTimeToStr(NOW));
	for i:=0 to bufferlength-1 do
		viewstring:=viewstring+inttohex(rbufsci[i],2)+' ';
	print(viewstring);
	print(' ');
  if @pRcvfun<>nil then pRcvfun(rbufsci,BufferLength);
{
if bufferlength=rxlength then
 begin
 for i:=1 to bufferlength do rbuf[i]:=rbufsci[i];
 end;
if bufferlength=(rxlength*2) then
 begin
 
 end;}
end;

procedure TSciCom.sendMobusRtu(Var buf; len:integer);
var
crc16:WORD;
pData:PCHAR;
sendbuf:array[0..100] of BYTE;
begin
if not isOn then exit;
isidle:=0;
pData:=PCHAR(@buf);
Move(pData^,sendbuf[0],len);
pData:=PCHAR(@sendbuf);
crc16:=crc_16(sendbuf,len);
//memo.Lines.Add(inttohex(crc16,4));
sendbuf[len]:=BYTE(crc16 and $ff);
sendbuf[len+1]:= BYTE((crc16 and $ff00) shr 8);

sendSciBuf(sendbuf,len+2);
//infomemo.Lines.Add('sendMobusRtu0');
WaitFlgTrue(@isidle,500,false);
//infomemo.Lines.Add('sendMobusRtu');
end;
end.

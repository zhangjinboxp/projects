unit common;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls, ComCtrls, Grids, ValEdit, DB, ADODB,OleCtrls,ComObj,
  Menus, ToolWin, ActnMan, ActnCtrls, ActnMenus, ExtCtrls,
  iComponent, iVCLComponent, iCustomComponent,IniFiles,StrUtils,Math,Registry;

	procedure Delay(MSecs: Longint);
  procedure DelayFromLastCall(MSecs: Longint);
	procedure readADOQuery(qry: TADOQuery;strsql:string);
	procedure execADOQuery(qry: TADOQuery;strsql:string);
	procedure openAdoXls(Conn: TADOConnection;qry: TADOQuery;filename: string);
	procedure myprint(loginfo:string;showType:integer=0;memo:Tmemo=nil;filename:string='log.txt');
  function isExcelTableExist(qry: TADOQuery;tabname:string):bool;
	function hexSpaceStringToByteArray(hexstring: string;Var bytearray;len:integer):integer;
  function WaitFlgTrue(pflg:PBYTE;TimeoutMs: Longint;isClear:bool=true):integer;
  function GetStrValueFromIni(fname:string;sectionName:string;memberName:string):string;
  procedure SetStrValueToIni(fname:string;sectionName:string;memberName:string;memValue:string);
  function crc_16(var data;length:integer):WORD;
  procedure GetComPorts(portlist:Tstrings);
  Procedure ExportCsvFile(FileName: string;rowCnt: dword;ColCnt: dword);
  function GetIndexFromStrBuf(findStr:string;var strbuf: array of string;buflen: integer):integer;
  function GetBetweenCharFromStr(linestr: string;beginChar: char;endChar: char):string;
  function   DynaCreateComponent(OwnerName:   TComponent;   CompType:   TControlClass;   CompName:   String;   V_Left,V_Top,V_Width,V_Height:Integer):   TControl;
  function Swap16(const Value: Word): Word;
  function Swap32(const Value: LongWord): LongWord;
  function isBitSet(const Value: DWord;bitPos: BYTE): boolean;
  procedure memset(Var buf; value:BYTE;len:integer);
  type
   TCreateComp=record
   compType:TControlClass;
   compName:String;
   compCaption:String;
   comptext:String;
   active:bool;
   visible:bool;
   Left,Top,Width,Height:Integer;
end;
const
maxRow:integer=100000;
maxCol:integer=100;
  
var
saveTab : array[0..100000,0..100] of string;
    saveTabColumn:array[1..32] of string;
    saveTabcnt:integer;
	lastTickCount: Longint;
	ExcelVersion: string='';
  //结构体初始化//canVartest:array[0..1] of TCanVar=((name:'';messageid:123;startbit:0;),(name:'';messageid:123;startbit:0;));

implementation

procedure GetComPorts(portlist:TStrings);
var
  reg: TRegistry;
  ts: TStrings;
  i: integer;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('hardware\devicemap\serialcomm', False);
  ts := TStringList.Create;
  reg.GetValueNames(ts);

  for i := 0 to ts.Count - 1 do
  begin
    portlist.Add(reg.ReadString(ts.Strings[i]));
  end;
  ts.Free;
  reg.CloseKey;
  reg.Free;
end;
function crc_16(var data;length:integer):WORD;
var
pdata:PBYTE;
CRC16:Word;
i,j:integer;
begin
    CRC16:=$FFFF;
	pdata:= PBYTE(@data);
	//showmessage('len:'+inttostr(length));
	for i := 0 to length-1 do
    begin
        //showmessage('pdata^:'+inttostr(pdata^));
        CRC16:=CRC16 xor pdata^;

		    for j := 0 to 7 do
		    begin
			    if (CRC16 and 1) = 1 then CRC16 := ( CRC16 shr 1 ) xor $A001
			    else  CRC16 := CRC16 shr 1;

        end;
        inc(pdata);
    end;
    result:=CRC16;	
end;
//动态创建控件
function   DynaCreateComponent(OwnerName:TComponent; CompType:TControlClass; CompName:String; V_Left,V_Top,V_Width,V_Height:Integer): TControl;
begin
      if   (OwnerName.FindComponent(CompName)<>nil)   and   not(OwnerName.FindComponent(CompName)   is   TControl)   then
      begin
          showmessage('the name is exist');
          Result   :=   nil;
          exit;
      end;   
      Result   :=   OwnerName.FindComponent(CompName)   as   TControl;   
      if   Result=nil   then
      begin   
          Result   :=   CompType.Create(OwnerName);   
          with   Result   do   
          begin   
              if   OwnerName   is   TwinControl   then   
              begin   
                  SetBounds(V_Left,V_Top,V_Width,V_Height);   
                  Parent   :=   TwinControl(OwnerName);{如果是可视构件,则显示之}   
                  if   OwnerName   is   TForm   then   TForm(OwnerName).ActiveControl   :=   TWinControl(Result);{设置窗口焦点}   
              end;   
          end;   
          Result.Name   :=   CompName;
      end   
      else   {Result<>Nil}
      if   not(Result   is   CompType)   then   
      begin
          Result   :=   nil;   
          Exit;   
      end;   
      Result.Visible   :=   True;   
  {对于未知数量的控件组，利用TList   
  var   ControlList:   Tlist;   CreateNum:   integer;
  const   CreateClass   :   TControlClass   =   TButton;//可以任意修改TControlClass   =   TEdit或TPanel等。效果一样。   
  var   i:integer;   V_Point:   Pointer;   
  ControlList   :=   TList.Create;   
  ControlList.Clear;
  CreateNum   :=   10;   
  for   i:=1   to   CreateNum   do   
          begin
              V_Point   :=   Pointer(DynaCreateComponent(self,CreateClass,'Button_'   +   IntToStr(i),0,i*20+1,60,20));//创建
              ControlList.Add(V_Point);
          end;   
  TButton(ControlList.Items[i]).Caption   :=   'XXXX';}
end;

function GetStrValueFromIni(fname:string;sectionName:string;memberName:string):string;
var
myinifile   : TIniFile;
fpath   :string;
intValue    :Integer;
strValue   :string;
begin
try
  fpath  := ExtractFilePath(Paramstr(0)) + fname;        //获取当前路径+文件名
  myinifile := Tinifile.Create(fpath);                         //创建文件
  //if products.Items.Count=0 then myinifile.readsections(products.Items);
except
  ShowMessage('打开配置文件'+fname+'失败');
  result:='';
  Exit;
end;
   result := myinifile.ReadString(sectionName, memberName, '');
end;

procedure SetStrValueToIni(fname:string;sectionName:string;memberName:string;memValue:string);
var
myinifile   : TIniFile;
temp        :string;  
fpath    :string;
begin
try
  fpath  := ExtractFilePath(Paramstr(0))  + fname;        //获取当前路径+文件名
  myinifile := Tinifile.Create(fpath);                         //创建文件
except
  ShowMessage('打开配置文件'+fname+'失败');
  Exit;
end;
myinifile.WriteString(sectionName, memberName, memValue);
end;

procedure DelayFromLastCall(MSecs: Longint); //延时函数，MSecs单位为毫秒(千分之1秒)
var
FirstTickCount, Now: Longint;
begin
	FirstTickCount := GetTickCount();
	if lastTickCount+MSecs>FirstTickCount then exit;//保证两次发送时间间隔满足就行

	repeat
		Application.ProcessMessages;
		Now := GetTickCount();
	until (Now >= FirstTickCount+MSecs) or (Now < FirstTickCount);
	lastTickCount:=Now;
end;
procedure Delay(MSecs: Longint); //延时函数，MSecs单位为毫秒(千分之1秒)
var
FirstTickCount, Now: Longint;
begin
  FirstTickCount := GetTickCount();
	repeat
		Application.ProcessMessages;
		Now := GetTickCount();
	until (Now >= FirstTickCount+MSecs) or (Now < FirstTickCount);
end;
procedure readADOQuery(qry: TADOQuery;strsql:string);   //
begin
    try
    With qry do
    begin
        Close;
        SQL.Clear;
        SQL.Add(strsql);
        Open;
        First;
    end;
    except on E: Exception do
    begin
        ShowMessage(e.Message+':'+strsql);
    exit;
    end;
    end;
end;

procedure execADOQuery(qry: TADOQuery;strsql:string);   //
begin
    try
    With qry do
    begin
        Close;
        SQL.Clear;
        SQL.Add(strsql);
        ExecSQL;
    end;
    except on E: Exception do
    begin
        ShowMessage(e.Message+':'+strsql);
    exit;
    end;
    end;
end;

procedure myprint(loginfo:string;showType:integer=0;memo:Tmemo=nil;filename:string='log.txt');
var
  filev: TextFile;
  ss: string;
begin
    if (showType=1) and (memo<>nil) then memo.Lines.Add(loginfo)
    else if showType=2 then showmessage(loginfo)
    else
    begin
      loginfo:=DateTimeToStr(Now)+' Log: '+loginfo;
      ss:=ExtractFilePath(Application.Exename)+filename;
      if FileExists(ss) then
      begin
        AssignFile(filev, ss);
        append(filev);
        writeln(filev, loginfo);
      end 
      else 
      begin
        AssignFile(filev, ss);
        ReWrite(filev);
        writeln(filev, loginfo);
      end;
      CloseFile(filev);
    end;
end;

procedure openAdoXls(Conn: TADOConnection;qry: TADOQuery;filename: string);
var
  Excel: OLEVariant;
begin
	if ExcelVersion='' then
	begin
	   try
	      Excel := CreateOLEObject('EXCEL.Application');
	      ExcelVersion := Excel.version;
	   finally
	      Excel.Quit;
	      Excel := UnAssigned;  
	   end;
	end;
  Conn.Close;

  myprint('excel version:'+ExcelVersion);
  if ExcelVersion = '11.0' then
    //Excel2003及早期的版本
     Conn.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+
                            filename+';Extended Properties=excel 8.0;'+
                            'Persist Security Info=false;'
  else //Excel2007及以后的版本
     Conn.ConnectionString:='Provider=Microsoft.ACE.OLEDB.12.0;Data Source='+
                            filename+';Extended Properties=excel 12.0;'+
                             'Persist Security Info=True';//注意不能为false  

    Conn.LoginPrompt:=false;
    Conn.Connected:=true;
    qry.Connection:=Conn;
end;

function isExcelTableExist(qry: TADOQuery;tabname:string):bool;   //
begin
    try
    With qry do
    begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM '+tabname);
        Open;
    end;
    except on E: Exception do
    begin
        result:=false;
        showmessage(tabname+'表不存在！请确认打开的文件是否正确！');
        exit;
    end;
    end;
    result:=true;
end;

function hexSpaceStringToByteArray(hexstring: string;Var bytearray;len:integer):integer;
var
i:integer;
strdata:string;
pbytedata: PChar;
begin
result:=len;
pbytedata:=PChar(@bytearray);
for i:=0 to len-1 do
    begin
      strdata:=Copy(hexstring,3*i+1,2);
      strdata:=Trim(strdata);
      if Length(strdata)=0 then
      begin
        result:=i;
        break;
      end;
      pbytedata[i]:=char(StrToInt('0x'+strdata));
    end;

end;

function WaitFlgTrue(pflg:PBYTE;TimeoutMs: Longint;isClear:bool=true):integer;
var
FirstTickCount, Now: Longint;
begin
FirstTickCount := GetTickCount();
repeat
Application.ProcessMessages;
Now := GetTickCount();
until (Now >= FirstTickCount+TimeoutMs) or (pflg^=1);
if pflg^=1 then result:=0;
if Now >= FirstTickCount+TimeoutMs then result:=-1;
if isclear then pflg^:=0;
end;

function CalCRC16(AData: array of Byte; AStart, AEnd: Integer): string;
const
  GENP=$A001;  //多项式公式X16+X15+X2+1（1100 0000 0000 0101）  //$A001    $8408
var
  crc:Word;
  i:Integer;
  tmp:Byte;
  s:string;
procedure CalOneByte(AByte:Byte);  //计算1个字节的校验码
var
j:Integer;
begin
  crc:=crc xor AByte;   //将数据与CRC寄存器的低8位进行异或
  for j:=0 to 7 do      //对每一位进行校验
  begin
    tmp:=crc and 1;        //取出最低位
    crc:=crc shr 1;        //寄存器向右移一位
    crc:=crc and $7FFF;    //将最高位置0
    if tmp=1 then         //检测移出的位，如果为1，那么与多项式异或
      crc:=crc xor GENP;
      crc:=crc and $FFFF;
  end;
end;
begin
  crc:=$FFFF;             //将余数设定为FFFF
  for i:=AStart to AEnd do   //对每一个字节进行校验
    CalOneByte(AData[i]);
  s:=inttohex(crc,2);
  Result:= rightstr(s,2)+leftstr(s,2);
end;



function strtocrc(s: string): string;
var
  buf1:array[0..256] of byte;
  i:integer;
  strOrder:string;
  Res: string;
begin
  strOrder :=StringReplace(s,' ','',[rfReplaceAll]);
  for i:=0 to (length(strOrder) div 2-1) do
    buf1[i]:= StrToInt('$'+copy(strOrder, i*2 + 1,2)); 
  result:=s+CalCRC16(buf1,Low(buf1),length(strOrder) div 2-1);
end;

Procedure ExportCsvFile(FileName: string;rowCnt: dword;ColCnt: dword);
var
  i, j: integer;
  tmpstr:string;
  Col, row: dword;
  aFileStream: TFileStream;
begin
  FileName:=FileName+'.csv';
  if FileExists(FileName) then DeleteFile(FileName); //文件存在，先删除
  aFileStream := TFileStream.Create(FileName, fmCreate);
  Try

    Col := 0; Row := 0;

    for Row:=0 to rowCnt-1 do
    begin
        for Col:=0 to ColCnt-1 do
        begin
            tmpstr:=saveTab[Row,Col]+',';
            aFileStream.WriteBuffer(Pointer(tmpstr)^, Length(tmpstr));
        end;
        tmpstr:= #13#10;
        aFileStream.WriteBuffer(Pointer(tmpstr)^, Length(tmpstr));
    end;

  finally
    AFileStream.Free;
  end;
end;

function GetBetweenCharFromStr(linestr: string;beginChar: char;endChar: char):string;
var
List: TStringList;
tmpstr:string;
begin
  result:='';
  List := TStringList.Create;
  List.Delimiter := beginChar;
  List.DelimitedText := linestr;
  if list.Count =0 then exit;
  tmpstr:=List[1];
  list.Clear;
  List.Delimiter := endChar;
  List.DelimitedText := tmpstr;
  if list.Count =0 then exit;
  result:=List[0];

end;

function GetIndexFromStrBuf(findStr:string;var strbuf: array of string;buflen: integer):integer;
var
i:integer;
begin
    for i:=0 to buflen-1 do
    begin
        if strbuf[i]=findStr then
        begin
            result:=i;
            exit;
        end;
        if strbuf[i]='' then
        begin
            strbuf[i]:=findStr;
            result:=i;
            exit;
        end;
    end;
end;

function Swap16(const Value: Word): Word;
begin
  Result := Swap(Value);
end;

function Swap32(const Value: LongWord): LongWord;
begin
  Result := Swap(Word(Value)) shl 16 + Swap(Word(Value shr 16));
end;

procedure memset(Var buf; value:BYTE;len:integer);
var
pData:PCHAR;
begin
fillchar(buf, len, value);
end;


function isBitSet(const Value: DWord;bitPos: BYTE):boolean;
begin
    result:=false;
    if (Value and (1 shl bitPos))>0 then result:=true;
end;

end.

unit common;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls, ComCtrls, Grids, ValEdit, DB, ADODB,OleCtrls,ComObj,
  Menus, ToolWin, ActnMan, ActnCtrls, ActnMenus, ExtCtrls,
  iComponent, iVCLComponent, iCustomComponent,IniFiles;

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
  function   DynaCreateComponent(OwnerName:   TComponent;   CompType:   TControlClass;   CompName:   String;   V_Left,V_Top,V_Width,V_Height:Integer):   TControl;
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
var
	lastTickCount: Longint;
	ExcelVersion: string='';
  //结构体初始化//canVartest:array[0..1] of TCanVar=((name:'';messageid:123;startbit:0;),(name:'';messageid:123;startbit:0;));

implementation
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


end.

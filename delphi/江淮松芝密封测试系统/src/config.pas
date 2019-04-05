unit config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, RzSpnEdt, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls,
  pngimage,ADODB,DB, Mask, DBCtrls;

type
  Tfconfig = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Splitter3: TSplitter;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    LabeledEdit1: TLabeledEdit;
    Splitter2: TSplitter;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    RzSpinButtons1: TRzSpinButtons;
    RzSpinButtons2: TRzSpinButtons;
    RzSpinButtons3: TRzSpinButtons;
    RzButton1: TRzButton;
    RzButton3: TRzButton;
    RzButton4: TRzButton;
    OpenDialog1: TOpenDialog;
    RzButton2: TRzButton;
    DBEdit2: TDBEdit;
    Label4: TLabel;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    Label3: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    Label8: TLabel;
    RzButton5: TRzButton;
    RzButton6: TRzButton;
    LabeledEdit7: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure RzButton4Click(Sender: TObject);
    procedure RzButton1Click(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RzSpinButtons1DownLeftClick(Sender: TObject);
    procedure RzSpinButtons1UpRightClick(Sender: TObject);
    procedure RzSpinButtons2DownLeftClick(Sender: TObject);
    procedure RzSpinButtons2UpRightClick(Sender: TObject);
    procedure RzSpinButtons3DownLeftClick(Sender: TObject);
    procedure RzSpinButtons3UpRightClick(Sender: TObject);
    procedure RzButton2Click(Sender: TObject);
    procedure LabeledEdit8Change(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBEdit2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzButton3Click(Sender: TObject);
    procedure RzButton5Click(Sender: TObject);
    procedure RzButton6Click(Sender: TObject);
    procedure LabeledEdit7Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
type
  TconfigDetail = Object
supplierCode:string;
materialNum:string;
serial1:string;
serial2:string;
serial3:string;
increaseValue:string;
programNum:string;
productName:string;
productDrawId:string;
end;
type
 TMyDBGrid=class(TDBGrid)
end;

var
  fconfig: Tfconfig;
  configDetail:array[0..200] of TconfigDetail;
  configDetailCnt:integer=0;
implementation
uses dbinterface,common;
{$R *.dfm}

procedure Tfconfig.FormCreate(Sender: TObject);
var
sql:string;
i:integer;
begin
for i:=0 to dbgrid1.Columns.Count-1 do
    begin
      dbgrid1.Columns.Items[i].Title.Alignment:=taCenter;
      dbgrid1.Columns.Items[i].Title.Font.Name:='宋体';
      dbgrid1.Columns.Items[i].Title.Font.Size :=11;
      dbgrid1.Columns.Items[i].Title.Font.Style:=[fsBold];
    end;

sql:= 'select * from config';

readADOQuery(dbio.ADOQuery1,sql);
end;

procedure Tfconfig.RzButton4Click(Sender: TObject);
var
i:integer;
sqlstr:string;
begin
    opendialog1.Filter:='表格文件(*.xls;*.xlsx)|*.xls;*.xlsx';
    if opendialog1.Execute then
    begin
       openAdoXls(dbio.ADOConnXls,dbio.ADOQryXls,opendialog1.filename);
       dbio.ADOConnXls.Connected:=true;
       readADOQuery(dbio.ADOQryXls,'select * from [config$] where 产品图号<>''''');
       configDetailCnt:=dbio.ADOQryXls.RecordCount;
       for i:=0 to dbio.ADOQryXls.RecordCount-1 do
   begin
      configDetail[i].supplierCode:= dbio.ADOQryXls.FieldByName('供应商代码').asString;
      configDetail[i].materialNum:= dbio.ADOQryXls.FieldByName('物料代码').asString;
      configDetail[i].serial1:= dbio.ADOQryXls.FieldByName('流水号1').asString;
      configDetail[i].serial2:=dbio.ADOQryXls.FieldByName('流水号2').asString;
      configDetail[i].serial3:= dbio.ADOQryXls.FieldByName('流水号3').asString;
      configDetail[i].increaseValue:= dbio.ADOQryXls.FieldByName('自加值').asString;
      configDetail[i].programNum:=dbio.ADOQryXls.FieldByName('程序号').asString;
      configDetail[i].productName:=dbio.ADOQryXls.FieldByName('产品名称').asString;
      configDetail[i].productDrawId:= dbio.ADOQryXls.FieldByName('产品图号').asString;
       dbio.ADOQryXls.Next;
      readADOQuery(dbio.ADOQuery1,'select * from config where productDrawId like '+quotedstr(configDetail[i].productDrawId));
      if dbio.ADOQuery1.RecordCount>0 then continue;
      sqlstr:='insert into config([supplierCode],[materialNum],[serial1],[serial2],[serial3],[increaseValue],[programNum],[productName],[productDrawId]) values(';
   sqlstr:=sqlstr+Quotedstr(configDetail[i].supplierCode)
      +',' +quotedstr(configDetail[i].materialNum)
      +',' +quotedstr(configDetail[i].serial1)
      +',' +quotedstr(configDetail[i].serial2)
      +',' +quotedstr(configDetail[i].serial3)
      +',' +quotedstr(configDetail[i].increaseValue)
      +',' +quotedstr(configDetail[i].programNum)
      +',' +quotedstr(configDetail[i].productName)
      +',' +quotedstr(configDetail[i].productDrawId)
      +')';
    //memo1.Lines.Add(sqlstr);
      execADOQuery(dbio.ADOQuery1,sqlstr);

   end;
   dbio.ADOConnXls.Connected:=false;
   readADOQuery(dbio.ADOQuery1,'select * from config');
    end;
end;

procedure Tfconfig.RzButton1Click(Sender: TObject);
var
i:integer;
sqlstr:string;
begin

    //readADOQuery(dbio.ADOQuery1,'select * from config where productDrawId like '+quotedstr(dbEdit2.Text));
     {  if dbio.ADOQuery1.RecordCount>0 then
      begin
       showmessage('该图号已存在！');
       exit;
       end;
       
      
      sqlstr:='insert into config([supplierCode],[materialNum],[serial1],[increaseValue],[programNum],[productName],[productDrawId]) values(';
   sqlstr:=sqlstr+Quotedstr(dbEdit3.Text)
      +',' +quotedstr(dbEdit4.Text)
      +',' +quotedstr(dbEdit5.Text)
      +',' +quotedstr(dbEdit6.Text)
      +',' +quotedstr(dbEdit7.Text)
      +',' +quotedstr(dbEdit1.Text)
      +',' +quotedstr(dbEdit2.Text)
      +')';
    //memo1.Lines.Add(sqlstr);
      execADOQuery(dbio.ADOQuery1,sqlstr);
      }
      dbio.ADOQuery1.UpdateBatch();
      dbio.ADOQuery1.edit;
      readADOQuery(dbio.ADOQuery1,'select * from config');
end;

procedure Tfconfig.LabeledEdit1Change(Sender: TObject);
begin
if LabeledEdit1.Text='' then
  begin
      readADOQuery(dbio.ADOQuery1,'select * from config');
  end
  else
  begin

   readADOQuery(dbio.ADOQuery1,'select * from config where productDrawId like '+Quotedstr('%'+LabeledEdit1.Text+'%'));
  end;
end;

procedure Tfconfig.BitBtn1Click(Sender: TObject);
begin
    if MessageBox(fconfig.Handle,'确定要保存所以更改并退出吗？','提示',MB_ICONINFORMATION+MB_OkCancel)= idOk then
     begin
       dbio.ADOQuery1.UpdateBatch();
       fconfig.Close;
     end;
end;

procedure Tfconfig.RzSpinButtons1DownLeftClick(Sender: TObject);
begin
    if strtointdef(dbEdit5.Text,0)>0 then dbEdit5.Text:=inttostr(strtointdef(dbEdit5.Text,0)-1);
end;

procedure Tfconfig.RzSpinButtons1UpRightClick(Sender: TObject);
begin
    dbEdit5.Text:=inttostr(strtointdef(dbEdit5.Text,0)+1);
end;

procedure Tfconfig.RzSpinButtons2DownLeftClick(Sender: TObject);
begin
    if strtointdef(dbEdit6.Text,0)>0 then dbEdit6.Text:=inttostr(strtointdef(dbEdit6.Text,0)-1);
end;

procedure Tfconfig.RzSpinButtons2UpRightClick(Sender: TObject);
begin
   dbEdit6.Text:=inttostr(strtointdef(dbEdit6.Text,0)+1);
end;

procedure Tfconfig.RzSpinButtons3DownLeftClick(Sender: TObject);
begin
    if strtointdef(dbEdit7.Text,0)>0 then dbEdit7.Text:=inttostr(strtointdef(dbEdit7.Text,0)-1);
end;

procedure Tfconfig.RzSpinButtons3UpRightClick(Sender: TObject);
begin
    dbEdit7.Text:=inttostr(strtointdef(dbEdit7.Text,0)+1);
end;

procedure Tfconfig.RzButton2Click(Sender: TObject);
begin
   dbio.ADOQuery1.Delete;
   if MessageBox(fconfig.Handle,'确定要删除？','提示',MB_ICONINFORMATION+MB_OkCancel)= idOk then
     begin
       dbio.ADOQuery1.UpdateBatch();
     end
     else
     begin
       readADOQuery(dbio.ADOQuery1,'select * from config');
     end;
end;

procedure Tfconfig.LabeledEdit8Change(Sender: TObject);
begin
    if dbEdit2.Text='' then
  begin
      readADOQuery(dbio.ADOQuery1,'select * from config');
  end
  else
  begin

   readADOQuery(dbio.ADOQuery1,'select * from config where productDrawId like '+Quotedstr('%'+dbEdit2.Text+'%'));
  end;
end;

procedure Tfconfig.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
Var Row : integer;
begin
 //DBGrid1.Canvas.Brush.Color:=clred;
 // DBGrid1.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  with TMyDBGrid(Sender) do
  begin
    if DataLink.ActiveRecord=Row-1 then
    begin
      Canvas.Font.Color:=clWhite;
      Canvas.Brush.Color:=$00800040;
    end
    else
    begin
        Canvas.Brush.Color:=Color;
        Canvas.Font.Color:=Font.Color;
    end;
    DefaultDrawColumnCell(Rect,DataCol,Column,State);
    end;
end;

procedure Tfconfig.DBEdit2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//readADOQuery(dbio.ADOQuery1,'select * from config where productDrawId like '+quotedstr(dbEdit2.Text));
end;

procedure Tfconfig.RzButton3Click(Sender: TObject);
begin
dbio.ADOQuery1.edit;
dbedit5.Text:=Format('%.4d',[0]) ;
dbio.ADOQuery1.post;
//dbio.ADOQuery1.UpdateBatch();
end;

procedure Tfconfig.RzButton5Click(Sender: TObject);
begin
dbio.ADOQuery1.append;
dbEdit1.Text:='';
dbEdit2.Text:='';
dbEdit3.Text:='';
dbEdit4.Text:='';
dbEdit5.Text:=Format('%.4d',[0]) ;
dbEdit6.Text:='0';
dbEdit7.Text:='0';
dbio.ADOQuery1.post;
end;

procedure Tfconfig.RzButton6Click(Sender: TObject);
begin
     if MessageBox(fconfig.Handle,'确定要保存当前更改？','提示',MB_ICONINFORMATION+MB_OkCancel)= idOk then
     begin
       dbio.ADOQuery1.UpdateBatch();
     end
     else
     begin
       readADOQuery(dbio.ADOQuery1,'select * from config');
     end;

end;

procedure Tfconfig.LabeledEdit7Change(Sender: TObject);
begin
    if LabeledEdit7.Text='' then
  begin
      readADOQuery(dbio.ADOQuery1,'select * from config');
  end
  else
  begin
   readADOQuery(dbio.ADOQuery1,'select * from config where productName like '+Quotedstr('%'+LabeledEdit7.Text+'%'));
  end;
end;

end.

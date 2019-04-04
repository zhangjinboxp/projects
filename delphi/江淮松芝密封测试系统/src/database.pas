unit database;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Grids, DBGrids, jpeg, RzDTP, Mask,
  RzEdit, RzDBEdit, ADODB, DB, Buttons, ActnList, DBActns, pngimage;

type
  Tfdatabase = class(TForm)
    Splitter1: TSplitter;
    Panel1: TPanel;
    Label1: TLabel;
    Splitter2: TSplitter;
    Label2: TLabel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    mcode: TLabeledEdit;
    startdate: TDateTimePicker;
    enddate: TDateTimePicker;
    starttime: TRzDateTimeEdit;
    endtime: TRzDateTimeEdit;
    resultbox: TComboBox;
    GroupBox2: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    DBGrid1: TDBGrid;
    ActionList1: TActionList;
    DataSetDelete1: TDataSetDelete;
    Image1: TImage;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fdatabase: Tfdatabase;

implementation
uses dbinterface,common;
{$R *.dfm}

procedure Tfdatabase.Button1Click(Sender: TObject);
begin
    fdatabase.Close;
end;

procedure Tfdatabase.FormCreate(Sender: TObject);
var i,j:Integer;
begin
    startdate.DateTime:=now;
    starttime.Time:=0;
    enddate.DateTime:=now;
    endtime.Time:=now;


    for i:=0 to dbgrid1.Columns.Count-1 do
    begin
      dbgrid1.Columns.Items[i].Title.Alignment:=taCenter;
      dbgrid1.Columns.Items[i].Title.Font.Name:='宋体';
      dbgrid1.Columns.Items[i].Title.Font.Size :=11;
      dbgrid1.Columns.Items[i].Title.Font.Style:=[fsBold];
    end;


end;

procedure Tfdatabase.BitBtn4Click(Sender: TObject);
begin
    fdatabase.Close;
end;

procedure Tfdatabase.BitBtn1Click(Sender: TObject);
var
sql:string;
begin
sql:= 'select * from record where time between '+Quotedstr(FormatdateTime('yyyy-MM-dd ',startdate.Date)+FormatdateTime('hh:mm:ss',starttime.Time))
                      +' and '+Quotedstr(FormatdateTime('yyyy-MM-dd ',enddate.Date)+FormatdateTime('hh:mm:ss',endtime.Time));
if mcode.Text<>'' then
begin
 sql:= sql+' and serialnum like '+quotedstr('%'+mcode.Text+'%');
end;
if resultbox.Text<>'ALL' then
begin
 sql:= sql+' and testresult like '+quotedstr('%'+resultbox.Text+'%');
end;
//showmessage(sql);
readADOQuery(dbio.ADOQuery2,sql);
end;

procedure Tfdatabase.FormShow(Sender: TObject);
begin
    dbgrid1.DataSource:=dbio.DataSource2;
end;

procedure Tfdatabase.BitBtn3Click(Sender: TObject);
var
rowCnt: dword;
ColCnt: dword;
i,j:integer;
begin
    //dbio.ADOQuery2.Refresh;
    //showmessage('数据更新成功！');
    savedialog1.Filter:='表格文件(*.csv)|*.csv';
    if savedialog1.Execute then
    begin
        DBGrid1.DataSource.DataSet.First;
    ColCnt := DBGrid1.DataSource.DataSet.FieldCount;
    rowCnt := DBGrid1.DataSource.DataSet.RecordCount;
    
    Application.ProcessMessages;
    for i := 0 to ColCnt - 1 do
      saveTab[0, i] := DBGrid1.Columns[i].Title.Caption;
    for j := 0 to rowCnt-1 do
    begin
      for i := 0 to ColCnt - 1 do
        saveTab[j+1, i] := DBGrid1.DataSource.DataSet.Fields[i].AsString;
      DBGrid1.DataSource.DataSet.Next;
    end;
    ExportCsvFile(savedialog1.Filename,rowCnt+1,ColCnt);
    end;
end;

procedure Tfdatabase.BitBtn2Click(Sender: TObject);
begin
   
   dbio.ADOQuery2.Delete;
end;

end.

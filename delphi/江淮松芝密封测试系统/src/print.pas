unit print;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, jpeg, pngimage,
  Mask, DBCtrls;

type
  Tfprint = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Splitter2: TSplitter;
    Panel3: TPanel;
    Splitter3: TSplitter;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    ComboBox1: TComboBox;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    Button5: TButton;
    LabeledEdit1: TLabeledEdit;
    Image1: TImage;
    Memo1: TMemo;
    DBEdit1: TDBEdit;
    LabeledEdit7: TLabeledEdit;
    DBEdit2: TDBEdit;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure LabeledEdit7Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure printlabel(contentTxt:string);
  end;

var
  fprint: Tfprint;

implementation
uses dbinterface,common;
{$R *.dfm}

procedure Tfprint.FormShow(Sender: TObject);
var
Column: TColumn;
begin
dbgrid1.DataSource:=dbio.DataSource1;
readADOQuery(dbio.ADOQuery1,'select * from config');

dbgrid1.OnCellClick(nil);
end;

procedure Tfprint.LabeledEdit1Change(Sender: TObject);
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

procedure Tfprint.BitBtn1Click(Sender: TObject);
begin
    fprint.Close;
end;

procedure Tfprint.printLabel(contentTxt:string);
var
printtxt:string;
lpt:textfile;
begin
    //exit;
    //contentTxt:= LabeledEdit5.Text+FormatdateTime('yyMMdd',now)+ rightstr(LabeledEdit2.Text,2);// '流水号'
    {printtxt:= '^XA^FO'+'25,30' //开始标签格式并设置字段位置。(从左上角开始)到条码字段x，y座标
               +'^A0,35,15'//0号字体，高，宽
               +'^XGE:252.GRF,2,2'  //^XG=调用图象 贮存图象名 .GRF扩展名  xy方向放大因子
               +'^FS'   //＾FS字段分隔
               +'^FO'+'120,85'  //内容坐标' ^FO（字段原点）增加字体大小将使文本块从顶到底尺寸增加
               +'^A0,32,24'
               +'^FD'+'NO.'+FormatdateTime('yyMMdd',now)
                     +LabeledEdit2.Text// '流水号'
                     +'001184' //^FD（字段数据）指令定义字段的数据串
               +'^FS'
               +'^FO'+'120,125'//内容坐标'
               +'^A0,32,24'
               +'^FD'+LabeledEdit5.Text//'供应商代码'+'物料代码'
               +'^FS'
               +'^FO'+'20,70'  //'条码坐标'
                //二维码
               +'^BQ,2.5,2.5'
               +'^FD'+'NO.'+FormatdateTime('yyMMdd',now)
                     +LabeledEdit2.Text// '流水号'
                     +'001184'
                     +LabeledEdit5.Text//'供应商代码'+'物料代码'

               +'^FS^XZ';       //^XZ表明结束打印字段并结束标签格式
               write(lpt,'^XA^A0,N,25,25'
                  +'^FO45,30^BY1^BCN,80^FD'+'ad02'+'^FS'
                  +'^FO0,145^GB360,0,5' +'^FS'
                  +'^FO160,145^GB0,80,5' +'^FS'
                  +'^FO10,170^ADN,40,24^FDQC.'+qcid +'^FS'
                  +'^FO180,170^ADN,40,24^FD'+testResult +'^FS'
                  +'^XZ');
     }
     printtxt:= '^XA^FO'+'25,30'
               // +'^A0,35,15'  //0号字体，高，宽
                +'^BY1,3,49'
                +'^FT114,70'     //字段排版 x/y坐标
                //+'^FO'+'100,30'  //内容坐标' ^FO（字段原点）增加字体大小将使文本块从顶到底尺寸增加
                +'^BCN,80,Y,N,N'  //BC128码
                +'^FD>:'+contentTxt
                +'^FS^XZ';

 
   printtxt:=GetStrValueFromIni('config.ini','pinter','preConfig')
             +'^FD>:'+contentTxt+'^FS^XZ';
   assignFile(lpt,'LPT1');
   rewrite(lpt);
   write(lpt,printtxt);
   CloseFile(lpt);
end;


procedure Tfprint.FormCreate(Sender: TObject);
var
i:integer;
begin
    for i:=0 to dbgrid1.Columns.Count-1 do
    begin
      dbgrid1.Columns.Items[i].Title.Alignment:=taCenter;
      dbgrid1.Columns.Items[i].Title.Font.Name:='宋体';
      dbgrid1.Columns.Items[i].Title.Font.Size :=11;
      dbgrid1.Columns.Items[i].Title.Font.Style:=[fsBold];
    end;
end;

procedure Tfprint.Button5Click(Sender: TObject);
var
i:integer;
sqlstr,labelstr:string;
begin
    dbio.ADOQuery1.edit;
    for i:=0 to strtointdef(LabeledEdit5.Text,0)-1 do
    begin
        //memo1.Lines.Add(DBGrid1.DataSource.DataSet.FieldByName('productDrawId').Asstring+FormatdateTime('yyMMdd',now)+Format('%.4d',[strtointdef(DbEdit1.Text,0)]));
        //printLabel(DBGrid1.DataSource.DataSet.FieldByName('productDrawId').Asstring+FormatdateTime('yyMMdd',now)+ LabeledEdit6.Text);
        DbEdit1.Text := Format('%.4d',[strtointdef(DbEdit1.Text,0)]) ;
        if strtointdef(DbEdit2.Text,0) <> strtointdef(FormatdateTime('yyMMdd',now),0) then
        begin
            DbEdit1.Text := Format('%.4d',[0]) ;
        end;

        with DBGrid1.DataSource.DataSet do
        begin
          sqlstr:='insert into record([time],[barcode],[modelnum],[programnum],[testresult],[serialnum]) values(';
          sqlstr:=sqlstr+Quotedstr(FormatdateTime('yyyy-MM-dd hh:mm:ss',now))
                +',' +Quotedstr(FieldByName('productDrawId').Asstring)
                +',' +Quotedstr(FieldByName('supplierCode').Asstring+FieldByName('materialNum').Asstring)
                +',' +Quotedstr(FieldByName('programnum').Asstring)
                +',' +quotedstr('OK')
                +',' +Quotedstr(DbEdit1.Text)
                +')';
          memo1.Lines.Add(sqlstr);
          execADOQuery(dbio.ADOQuery2,sqlstr);

          DbEdit1.Text := Format('%.4d',[strtointdef(DbEdit1.Text,0)+strtointdef(LabeledEdit6.Text,1)]) ;

          labelstr:= FieldByName('supplierCode').Asstring+FieldByName('materialNum').Asstring
                    +FormatdateTime('yyMMdd',now)
                    +DbEdit1.Text;
        end;
        memo1.Lines.Add(labelstr);
        //printLabel(labelstr);
    end;
    DbEdit2.Text := FormatdateTime('yyMMdd',now);
    dbio.ADOQuery1.post;
    dbio.ADOQuery1.UpdateBatch();

end;

procedure Tfprint.DBGrid1CellClick(Column: TColumn);
begin
    with DBGrid1.DataSource.DataSet do
    begin
        LabeledEdit3.Text := FieldByName('supplierCode').Asstring;
        LabeledEdit2.Text := FieldByName('materialNum').Asstring;
        //dbedit1.Text := FieldByName('serial1').Asstring;
        LabeledEdit6.Text := FieldByName('increaseValue').Asstring;
    end;
end;

procedure Tfprint.LabeledEdit7Change(Sender: TObject);
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

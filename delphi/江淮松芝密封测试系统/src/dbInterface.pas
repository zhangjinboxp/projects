unit dbInterface;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DB;

type
  Tdbio = class(TForm)
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    ADOTable1: TADOTable;
    ADOTable2: TADOTable;
    ADOQuery2: TADOQuery;
    ADOConnection2: TADOConnection;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ADOConnXls: TADOConnection;
    ADOQryXls: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure initAdo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dbio: Tdbio;

implementation

{$R *.dfm}
procedure Tdbio.initAdo;
begin
    ADOConnection1.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+
               ExtractFilePath(ParamStr(0))+'\database.mdb;Jet OLEDB:Database Password=870606'+
               ';Persist Security Info=False';
    ADOQuery1.Connection:=ADOConnection1;
    ADOConnection1.LoginPrompt:=False;
end;
procedure Tdbio.FormCreate(Sender: TObject);
begin
    initAdo;
end;

end.

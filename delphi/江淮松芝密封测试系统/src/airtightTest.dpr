program airtightTest;

uses
  Forms,
  main in 'main.pas' {fmain},
  regedit in 'regedit.pas',
  md5 in 'md5.pas',
  reg in 'reg.pas' {freg},
  common in '..\common\common.pas',
  test in 'test.pas' {ftest},
  database in 'database.pas' {fdatabase},
  formAutoSize in 'formAutoSize.pas',
  print in 'print.pas' {fprint},
  dbInterface in 'dbInterface.pas' {dbio},
  config in 'config.pas' {fconfig},
  sci in '..\common\sci.pas',
  commConfig in '..\common\commConfig.pas' {commForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfmain, fmain);
  Application.CreateForm(Tfreg, freg);
  Application.CreateForm(Tdbio, dbio);
  Application.CreateForm(Tftest, ftest);
  Application.CreateForm(Tfdatabase, fdatabase);
  Application.CreateForm(Tfprint, fprint);
  Application.CreateForm(Tfconfig, fconfig);
  Application.CreateForm(TcommForm, commForm);
  Application.Run;
end.

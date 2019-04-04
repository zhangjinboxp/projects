object dbio: Tdbio
  Left = 586
  Top = 125
  Width = 199
  Height = 198
  Caption = 'fdbio'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ADOConnection1: TADOConnection
    Left = 32
    Top = 17
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    LockType = ltBatchOptimistic
    Parameters = <>
    Left = 72
    Top = 17
  end
  object ADOTable1: TADOTable
    Connection = ADOConnection1
    Left = 104
    Top = 17
  end
  object ADOTable2: TADOTable
    Connection = ADOConnection2
    Left = 112
    Top = 49
  end
  object ADOQuery2: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 72
    Top = 49
  end
  object ADOConnection2: TADOConnection
    Left = 32
    Top = 49
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 144
    Top = 16
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 144
    Top = 56
  end
  object ADOConnXls: TADOConnection
    Left = 32
    Top = 89
  end
  object ADOQryXls: TADOQuery
    Connection = ADOConnXls
    Parameters = <>
    Left = 72
    Top = 89
  end
end

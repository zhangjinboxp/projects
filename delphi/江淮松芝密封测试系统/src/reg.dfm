object freg: Tfreg
  Left = 488
  Top = 172
  BorderStyle = bsNone
  Caption = #27880#20876
  ClientHeight = 300
  ClientWidth = 422
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 144
    Top = 48
    Width = 177
    Height = 41
    AutoSize = False
    Caption = #36719#20214#26410#27880#20876#65281
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object mcode: TLabeledEdit
    Left = 120
    Top = 120
    Width = 273
    Height = 21
    EditLabel.Width = 57
    EditLabel.Height = 13
    EditLabel.Caption = #26426#22120#30721#65306'   '
    ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    LabelPosition = lpLeft
    TabOrder = 0
  end
  object regcode: TLabeledEdit
    Left = 120
    Top = 160
    Width = 273
    Height = 21
    EditLabel.Width = 93
    EditLabel.Height = 13
    EditLabel.Caption = #35831#36755#20837#27880#20876#30721#65306'   '
    ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    LabelPosition = lpLeft
    TabOrder = 1
  end
  object Button1: TButton
    Left = 128
    Top = 224
    Width = 75
    Height = 25
    Caption = #27880#20876
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 248
    Top = 224
    Width = 75
    Height = 25
    Caption = #36864#20986
    TabOrder = 3
    OnClick = Button2Click
  end
end

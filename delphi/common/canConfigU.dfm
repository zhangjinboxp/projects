object canConfig: TcanConfig
  Left = 337
  Top = 164
  Width = 362
  Height = 325
  Caption = 'can'#37197#32622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox3: TGroupBox
    Left = 19
    Top = 24
    Width = 310
    Height = 241
    Caption = #21021#22987#21270'CAN'#21442#25968
    TabOrder = 0
    object Label1: TLabel
      Left = 15
      Top = 88
      Width = 59
      Height = 13
      Caption = #39564#25910#30721#65306'0x'
    end
    object Label2: TLabel
      Left = 168
      Top = 88
      Width = 59
      Height = 13
      Caption = #23631#34109#30721#65306'0x'
    end
    object Label10: TLabel
      Left = 16
      Top = 40
      Width = 71
      Height = 13
      Caption = #27874#29305#29575'kbps'#65306
    end
    object Label12: TLabel
      Left = 144
      Top = 136
      Width = 60
      Height = 13
      Caption = #28388#27874#26041#24335#65306
    end
    object Label13: TLabel
      Left = 16
      Top = 136
      Width = 36
      Height = 13
      Caption = #27169#24335#65306
    end
    object Label3: TLabel
      Left = 168
      Top = 40
      Width = 36
      Height = 13
      Caption = #36890#36947#65306
    end
    object Label4: TLabel
      Left = 16
      Top = 176
      Width = 36
      Height = 13
      Caption = #26085#24535#65306
    end
    object Edit2: TEdit
      Left = 80
      Top = 83
      Width = 65
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#19975#33021#20116#31508#36755#20837#27861
      TabOrder = 0
      Text = '00000000'
    end
    object Edit3: TEdit
      Left = 232
      Top = 83
      Width = 65
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#19975#33021#20116#31508#36755#20837#27861
      TabOrder = 1
      Text = 'FFFFFFFF'
    end
    object ComboBox3: TComboBox
      Left = 208
      Top = 131
      Width = 97
      Height = 21
      Style = csDropDownList
      Enabled = False
      ImeName = #20013#25991'('#31616#20307') - '#19975#33021#20116#31508#36755#20837#27861
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 2
      Text = #25509#25910#25152#26377#31867#22411
      Items.Strings = (
        #25509#25910#25152#26377#31867#22411
        #21482#25509#25910#26631#20934#24103
        #21482#25509#25910#25193#23637#24103)
    end
    object ComboBox4: TComboBox
      Left = 56
      Top = 132
      Width = 81
      Height = 21
      Style = csDropDownList
      Enabled = False
      ImeName = #20013#25991'('#31616#20307') - '#19975#33021#20116#31508#36755#20837#27861
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = #27491#24120#27169#24335
      Items.Strings = (
        #27491#24120#27169#24335
        #21482#21548#27169#24335
        #33258#27979#27169#24335)
    end
    object baudratesBox: TComboBox
      Left = 88
      Top = 35
      Width = 57
      Height = 19
      Style = csOwnerDrawFixed
      ImeName = #20013#25991'('#31616#20307') - '#19975#33021#20116#31508#36755#20837#27861
      ItemHeight = 13
      ItemIndex = 10
      TabOrder = 4
      Text = '500'
      Items.Strings = (
        '10'
        '20'
        '40'
        '50'
        '80'
        '100'
        '125'
        '200'
        '250'
        '400'
        '500'
        '666'
        '800'
        '1000')
    end
    object Button1: TButton
      Left = 117
      Top = 208
      Width = 73
      Height = 25
      Caption = #36830#25509'CAN'
      TabOrder = 5
      OnClick = Button1Click
    end
    object channelBox: TComboBox
      Left = 216
      Top = 35
      Width = 57
      Height = 21
      Style = csDropDownList
      ImeName = #20013#25991'('#31616#20307') - '#19975#33021#20116#31508#36755#20837#27861
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 6
      Text = '1'
      Items.Strings = (
        '1'
        '2')
    end
    object logtype: TComboBox
      Left = 56
      Top = 172
      Width = 81
      Height = 21
      Style = csDropDownList
      ImeName = #20013#25991'('#31616#20307') - '#19975#33021#20116#31508#36755#20837#27861
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 7
      Text = 'log.txt'
      OnChange = logtypeChange
      Items.Strings = (
        'log.txt'
        'memo')
    end
    object Button2: TButton
      Left = 224
      Top = 208
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 8
      OnClick = Button2Click
    end
  end
end

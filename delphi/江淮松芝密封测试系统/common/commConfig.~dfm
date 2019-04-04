object commForm: TcommForm
  Left = 327
  Top = 92
  BorderStyle = bsDialog
  Caption = #36890#35759#37197#32622
  ClientHeight = 294
  ClientWidth = 326
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
  object Splitter1: TSplitter
    Left = 0
    Top = 49
    Width = 326
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 326
    Height = 49
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 48
      Top = 16
      Width = 89
      Height = 17
      AutoSize = False
      Caption = #36890#35759#31867#22411
    end
    object ComboBox1: TComboBox
      Left = 120
      Top = 8
      Width = 145
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 13
      TabOrder = 0
      Text = #20018#21475
      Items.Strings = (
        #20018#21475
        'can')
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 52
    Width = 326
    Height = 242
    Align = alClient
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 324
      Height = 240
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #20018#21475#37197#32622
        object GroupBox1: TGroupBox
          Left = 32
          Top = 40
          Width = 257
          Height = 113
          TabOrder = 0
          object Label2: TLabel
            Left = 152
            Top = 24
            Width = 33
            Height = 17
            AutoSize = False
            Caption = #26657#39564
          end
          object Label3: TLabel
            Left = 144
            Top = 48
            Width = 41
            Height = 17
            AutoSize = False
            Caption = #20572#27490#20301
          end
          object Label4: TLabel
            Left = 16
            Top = 24
            Width = 33
            Height = 17
            AutoSize = False
            Caption = #31471#21475
          end
          object Label5: TLabel
            Left = 16
            Top = 48
            Width = 49
            Height = 17
            AutoSize = False
            Caption = #27874#29305#29575
          end
          object BAUT: TComboBox
            Left = 64
            Top = 42
            Width = 57
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
            ItemHeight = 13
            ItemIndex = 1
            ParentFont = False
            TabOrder = 0
            Text = '9600'
            Items.Strings = (
              '4800'
              '9600'
              '14400'
              '19200'
              '38400')
          end
          object sciCOM: TComboBox
            Left = 64
            Top = 18
            Width = 57
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
            ItemHeight = 13
            ItemIndex = 8
            ParentFont = False
            TabOrder = 1
            Text = 'COM9'
            OnChange = sciCOMChange
            Items.Strings = (
              'COM1'
              'COM2'
              'COM3'
              'COM4'
              'COM5'
              'COM6'
              'COM7'
              'COM8'
              'COM9'
              'COM10')
          end
          object scibtn: TButton
            Left = 88
            Top = 74
            Width = 65
            Height = 21
            Caption = #21551#21160
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = scibtnClick
          end
          object Parity: TComboBox
            Left = 192
            Top = 16
            Width = 49
            Height = 21
            ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
            ItemHeight = 13
            ItemIndex = 2
            TabOrder = 3
            Text = #20598#26657#39564
            Items.Strings = (
              #26080
              #22855#26657#39564
              #20598#26657#39564
              'Mark'
              'Space')
          end
          object stopbits: TComboBox
            Left = 192
            Top = 40
            Width = 49
            Height = 21
            ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
            ItemHeight = 13
            TabOrder = 4
            Text = '1'
            Items.Strings = (
              '1'
              '1.5'
              '2')
          end
        end
      end
    end
  end
  object Comm1: TComm
    CommName = 'COM2'
    BaudRate = 9600
    ParityCheck = False
    Outx_CtsFlow = False
    Outx_DsrFlow = False
    DtrControl = DtrEnable
    DsrSensitivity = False
    TxContinueOnXoff = True
    Outx_XonXoffFlow = True
    Inx_XonXoffFlow = True
    ReplaceWhenParityError = False
    IgnoreNullChar = False
    RtsControl = RtsEnable
    XonLimit = 500
    XoffLimit = 500
    ByteSize = _8
    Parity = None
    StopBits = _1
    XonChar = #17
    XoffChar = #19
    ReplacedChar = #0
    ReadIntervalTimeout = 100
    ReadTotalTimeoutMultiplier = 0
    ReadTotalTimeoutConstant = 0
    WriteTotalTimeoutMultiplier = 0
    WriteTotalTimeoutConstant = 0
    Left = 101
    Top = 85
  end
end

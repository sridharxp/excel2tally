object frmTxfer: TfrmTxfer
  Left = 236
  Top = 118
  Width = 409
  Height = 287
  Caption = 'Transfer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 13
    Top = 63
    Width = 49
    Height = 13
    Caption = 'From Date'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 231
    Top = 63
    Width = 13
    Height = 13
    Caption = 'To'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 13
    Top = 137
    Width = 59
    Height = 13
    Caption = 'From Ledger'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Info: TLabel
    Left = 13
    Top = 232
    Width = 356
    Height = 13
    Caption = 'Status'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 13
    Top = 28
    Width = 65
    Height = 13
    Caption = 'Ledger Group'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblLedger: TLabel
    Left = 13
    Top = 170
    Width = 49
    Height = 26
    Caption = 'To Ledger'#13#10
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 13
    Top = 101
    Width = 3
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 13
    Top = 101
    Width = 44
    Height = 13
    Caption = 'Company'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object btnTxfer: TButton
    Left = 246
    Top = 208
    Width = 98
    Height = 20
    Caption = 'Transfer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = btnTxferClick
  end
  object DateTimePicker2: TDateTimePicker
    Left = 259
    Top = 63
    Width = 114
    Height = 24
    Date = 43921.474290173610000000
    Format = 'dd/MM/yyyy'
    Time = 43921.474290173610000000
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object cmbLedGroup: TComboBox
    Left = 105
    Top = 28
    Width = 118
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 0
    Items.Strings = (
      ''
      'Duties &; Taxes')
  end
  object cmbFrmLed: TComboBox
    Left = 105
    Top = 132
    Width = 268
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 4
    OnClick = cmbFrmLedClick
    OnDblClick = cmbFrmLedDblClick
  end
  object cmbToLed: TComboBox
    Left = 105
    Top = 167
    Width = 268
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 5
    Items.Strings = (
      '')
  end
  object btnRefresh: TButton
    Left = 49
    Top = 208
    Width = 123
    Height = 20
    Caption = 'Import Ledger List'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btnRefreshClick
  end
  object cmbFirm: TComboBox
    Left = 105
    Top = 98
    Width = 268
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 3
  end
  object DateTimePicker1: TDateTimePicker
    Left = 105
    Top = 63
    Width = 114
    Height = 24
    Date = 43556.474290173610000000
    Format = 'dd/MM/yyyy'
    Time = 43556.474290173610000000
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
end

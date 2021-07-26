object frmMatch: TfrmMatch
  Left = 236
  Top = 118
  Width = 500
  Height = 294
  Caption = 'Match Ledgers with Bank  Stmt'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Info: TLabel
    Left = 29
    Top = 232
    Width = 30
    Height = 13
    Caption = 'Status'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 21
    Top = 53
    Width = 3
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 37
    Top = 30
    Width = 145
    Height = 16
    Caption = 'Minimum length to check'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 37
    Top = 63
    Width = 128
    Height = 16
    Caption = 'Write Matched Text in'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object btnMatch: TButton
    Left = 169
    Top = 201
    Width = 98
    Height = 20
    Caption = 'Match'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnMatchClick
  end
  object ckbRepl: TCheckBox
    Left = 37
    Top = 97
    Width = 396
    Height = 17
    Caption = 'Replace previous Name { No to protect Manual Entries }'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 1
  end
  object edtChkLen: TEdit
    Left = 249
    Top = 30
    Width = 64
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '5'
  end
  object ckbLedImp: TCheckBox
    Left = 37
    Top = 164
    Width = 260
    Height = 17
    Caption = 'Reduce Minimum Length '
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object ckbWrdSearch: TCheckBox
    Left = 37
    Top = 130
    Width = 204
    Height = 17
    Caption = 'Word / Text search'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object edtMatchCol: TEdit
    Left = 249
    Top = 63
    Width = 120
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = 'Ledger'
  end
end

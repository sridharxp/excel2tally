object frmCFig: TfrmCFig
  Left = 192
  Top = 124
  Width = 548
  Height = 251
  Caption = 'Configuration'
  Color = clBtnShadow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 23
  object lbl1: TLabel
    Left = 34
    Top = 40
    Width = 43
    Height = 23
    Caption = 'State'
  end
  object ckb6: TCheckBox
    Left = 330
    Top = 40
    Width = 121
    Height = 17
    Caption = 'Create Mode'
    Checked = True
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 0
  end
  object ckb7: TCheckBox
    Left = 330
    Top = 178
    Width = 201
    Height = 17
    Caption = 'Response in TallyID'
    Checked = True
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 1
  end
  object ckb8: TCheckBox
    Left = 330
    Top = 86
    Width = 135
    Height = 17
    Caption = 'Create Masters'
    Checked = True
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 2
  end
  object ckbGSTSettings: TCheckBox
    Left = 330
    Top = 132
    Width = 159
    Height = 17
    Caption = 'Set GST Settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object cmbState: TComboBox
    Left = 100
    Top = 40
    Width = 145
    Height = 31
    ItemHeight = 23
    ItemIndex = 32
    TabOrder = 4
    Text = 'Tamil Nadu '
    Items.Strings = (
      'Jammu & Kashmir'
      'Himachal Pradesh '
      'Punjab '
      'Chandigarh '
      'Uttranchal '
      'Haryana '
      'Delhi '
      'Rajasthan '
      'Uttar Pradesh '
      'Bihar '
      'Sikkim '
      'Arunachal Pradesh '
      'Nagaland '
      'Manipur '
      'Mizoram '
      'Tripura '
      'Meghalaya '
      'Assam '
      'West Bengal '
      'Jharkhand '
      'Odisha (Formerly Orissa '
      'Chhattisgarh '
      'Madhya Pradesh '
      'Gujarat '
      'Daman & Diu '
      'Dadra & Nagar Haveli '
      'Maharashtra '
      'Andhra Pradesh '
      'Karnataka '
      'Goa '
      'Lakshdweep '
      'Kerala '
      'Tamil Nadu '
      'Pondicherry '
      'Andaman & Nicobar Islands '
      'Telangana '
      'Andhra Pradesh (New)')
  end
end

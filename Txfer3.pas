(*
Copyright (C) 2013, Sridharan S

This file is part of Excel to Tally.

Excel to Tally is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Exce; to Tally is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License version 3
along with Excel to Tally. If not, see <http://www.gnu.org/licenses/>.
*)

unit Txfer3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  ShellApi,
  xmldb_PJrnl,
  PClientFns,
  MstListImp;

const
  TaxLed: array [0..29] of string = (
  'Input SGST 1.5%',
  'Input CGST 1.5%',
  'Input IGST 3%',
  'Input SGST 2.5%',
  'Input CGST 2.5%',
  'Input IGST 5%',
  'Input SGST 6%',
  'Input CGST 6%',
  'Input IGST 12%',
  'Input SGST 9%',
  'Input CGST 9%',
  'Input IGST 18%',
  'Input SGST 14%',
  'Input CGST 14%',
  'Input IGST 28%',

  'Output SGST 1.5%',
  'Output CGST 1.5%',
  'Output IGST 3%',
  'Output SGST 2.5%',
  'Output CGST 2.5%',
  'Output IGST 5%',
  'Output SGST 6%',
  'Output CGST 6%',
  'Output IGST 12%',
  'Output SGST 9%',
  'Output CGST 9%',
  'Output IGST 18%',
  'Output SGST 14%',
  'Output CGST 14%',
  'Output IGST 28%');

  TxLed: array [0..29] of string = (
 'SGST',
 'CGST',
 'IGST',
 'SGST',
 'CGST',
 'IGST',
 'SGST',
 'CGST',
 'IGST',
 'SGST',
 'CGST',
 'IGST',
 'SGST',
 'CGST',
 'IGST',

 'SGST',
 'CGST',
 'IGST',
 'SGST',
 'CGST',
 'IGST',
 'SGST',
 'CGST',
 'IGST',
 'SGST',
 'CGST',
 'IGST',
 'SGST',
 'CGST',
 'IGST');

type
  TfrmTxfer = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnTxfer: TButton;
    DateTimePicker2: TDateTimePicker;
    Info: TLabel;
    cmbLedGroup: TComboBox;
    Label4: TLabel;
    cmbFrmLed: TComboBox;
    lblLedger: TLabel;
    cmbToLed: TComboBox;
    btnRefresh: TButton;
    cmbFirm: TComboBox;
    Label6: TLabel;
    Label8: TLabel;
    DateTimePicker1: TDateTimePicker;
    ckbCustomize: TCheckBox;

    procedure btnTxferClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbFrmLedDblClick(Sender: TObject);
    procedure cmbFrmLedClick(Sender: TObject);
    procedure ckbCustomizeClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetToLed;
  public
    { Public declarations }
    IsImported: boolean;
  end;

procedure UpdateMsg(const aMsg: string);

var
  frmTxfer: TfrmTxfer;

implementation

uses SY, Merge3;

{$R *.dfm}


procedure TfrmTxfer.btnTxferClick(Sender: TObject);
var
  xdb: TbjPJrnl;
//  mr: integer;
//  DParent, LParent: string;
//  TaxList: TStringList;
  idx: integer;
  isDefault: boolean;
  frmLedGrp, toLedGrp: string;
begin
  isDefault := False;
  if MessageDlg('Transfer to SGST, CGST, IGST ?', mtConfirmation, mbOKCancel, 0)  = mrOK then
    isDefault := True;

  if not isDefault then
  begin
  if (Length(cmbToLed.Text) = 0) or (Length(cmbFrmLed.Text) = 0) then
  begin
    MessageDlg('Ledger (From or To) can not be empty', mtError, [mbOK], 0);
    Exit;
  end;
  if (cmbToLed.Text = cmbFrmLed.Text) then
  begin
    MessageDlg('Both From and To Ledgers are the same', mtError, [mbOK], 0);
    Exit;
  end;
  frmLedGrp := GetLedgerGroup(cmbFrmLed.Text);
  toLedGrp :=  GetLedgerGroup(cmbToLed.Text);
  if (frmLedGrp <> toLedGrp) then
    if not (((frmLedGrp = 'Sundry Debtors') or (frmLedGrp = 'Sundry Creditors')) and
      ((toLedGrp = 'Sundry Debtors') or (toLedGrp = 'Sundry Creditors'))) then
    begin
      MessageDlg('Groups differ', mtError, [mbOK], 0);
      Exit;
    end;
  end;
  btnTxfer.Enabled := False;
  btnRefresh.Enabled := False;
  xdb := TbjPJrnl.Create;
  Xdb.Host := 'http://' + frmXlExport.edtHost.Text + ':'+
  frmXlExport.edtPort.Text;
  try
    xdb.FUpdate := UpdateMsg;
//    xdb.FrmDt := FormatDateTime('yyyyMMDD',DateTimePicker1.date);
    xdb.FrmDt := FormatDateTime('DD-MMM-YYYY',DateTimePicker1.date);
    xdb.ToDt :=  FormatDateTime('DD-MMM-YYYY',DateTimePicker2.date);
    if Length(Trim(xdb.FrmDt)) = 0 then
      xdb.FrmDt := FormatDateTime('yyyyMMDD',Now);
    if Length(Trim(xdb.ToDt)) = 0 then
      xdb.ToDt := FormatDateTime('yyyyMMDD',Now);

    xdb.IsSaveXMLFileOn := False;
    xdb.Host := 'http://' + frmXlExport.edtHost.Text + ':'+
    frmXlExport.edtPort.Text;
    if not isDefault then
    begin
      xdb.FrmLed := cmbFrmLed.Text;
      xdb.ToLed := cmbToLed.Text;
      xdb.Process;
    end
    else
    begin
      for idx := 0 to 29 do
      begin
        xdb.FrmLed := TaxLed[idx];
        xdb.ToLed := TxLed[idx];
        xdb.Process;
      end;
    end;
  finally
    MessageDlg(IntToStr(xdb.ndups) + ' Journals passed',
      mtInformation, [mbOK],0);
    xdb.Free;
    btnTxfer.Enabled := True;
    btnRefresh.Enabled := True;
  end;
end;

procedure TfrmTxfer.btnRefreshClick(Sender: TObject);
var
  i: integer;
  CMPList: TStringlist;
  LedList: TStringlist;
  Obj: TbjMstListImp;
begin
  if MessageDlg('Clear From and To lists ?', mtWarning, mbOKCancel, 0) = mrCancel then
    Exit;
  btnTxfer.Enabled := False;
  btnRefresh.Enabled := False;
  CMPList := TStringList.Create;
  LedList := TStringList.Create;
  try
  Obj := TbjMstListImp.Create;
  Obj.ToPack := False;
  Obj.Host := 'http://' + frmXlExport.edtHost.Text + ':' +
    frmXlExport.edtPort.Text;
  try
    try
      CMPList.Text := Obj.GetCMPText;
      CMPList.Sorted := True;
        LedList.Text := Obj.GetLedText;
      LedList.Sorted := True;
    except
      MessageDlg('Error Connecting to Tally', mtError, [mbOK], 0);
    end;
  finally
    Obj.Free;
  end;

  cmbFirm.Items.Add('');
  cmbFirm.Clear;
  for i:= 0 to CMPList.Count-1 do
    cmbFirm.Items.Add(CMPList.Strings[i]);
  cmbFrmLed.Clear;
  for i:= 0 to LedList.Count-1 do
    cmbFrmLed.Items.Add(LedList.Strings[i]);
  cmbToLed.Clear;
  for i:= 0 to LedList.Count-1 do
    cmbToLed.Items.Add(LedList.Strings[i]);
  finally
  btnTxfer.Enabled := True;
  btnRefresh.Enabled := True;
  MessageDlg(InttoStr(LedList.Count) + ' ledgers imported', mtInformation, [mbOK], 0);
  CMPList.Clear;
  CMPList.Free;
  LedList.Clear;
  LedList.Free;
  cmbToLed.Enabled := True;
  end;
  IsImported := True;
end;

procedure TfrmTxfer.FormShow(Sender: TObject);
var
  ctr: integer;
begin
  cmbFirm.Clear;
  cmbFirm.Items.Add('');
  cmbFrmLed.Clear;
  for ctr := low(TaxLed) to  high(TaxLed) do
  begin
    cmbFrmLed.Items.Add(TaxLed[ctr]);
  end;

  cmbToLed.Clear;
  cmbToLed.Items.Add('SGST');
  cmbToLed.Items.Add('CGST');
  cmbToLed.Items.Add('IGST');
end;

procedure TfrmTxfer.SetToLed;
begin
  if IsImported then
    Exit;
  if Pos('SGST', cmbFrmLed.Text) > 0 then
    cmbToLed.Text := 'SGST';
  if Pos('CGST', cmbFrmLed.Text) > 0 then
    cmbToLed.Text := 'CGST';
  if Pos('IGST', cmbFrmLed.Text) > 0 then
    cmbToLed.Text := 'IGST';
end;

procedure TfrmTxfer.cmbFrmLedDblClick(Sender: TObject);
begin
  SetToLed;
end;

procedure TfrmTxfer.cmbFrmLedClick(Sender: TObject);
begin
  SetToLed;
end;

procedure UpdateMsg(const aMsg: string);
begin
  if Length(aMsg) > 0 then
    frmTxfer.Info.Caption := aMsg;
  Application.ProcessMessages;
end;

procedure TfrmTxfer.ckbCustomizeClick(Sender: TObject);
begin
  if ckbCustomize.Checked then
  begin
    cmbLedGroup.Enabled := True;
    cmbFrmLed.Enabled := True;
    cmbToLed.Enabled := True;
    btnRefresh.Enabled := True;
    cmbFirm.Enabled := True;
  end
  else
  begin
    cmbLedGroup.Enabled := False;
    cmbFrmLed.Enabled := False;
    cmbToLed.Enabled := False;
    btnRefresh.Enabled := False;
    cmbFirm.Enabled := False;
  end;
end;

end.

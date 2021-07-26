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

unit Match;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  ShellApi,
  xmldb_ML,
  PClientFns,
  XmlStr_GST_uf,
  Guess,
  MstListImp;

type
  TfrmMatch = class(TForm)
    btnMatch: TButton;
    Info: TLabel;
    Label6: TLabel;
    ckbRepl: TCheckBox;
    edtChkLen: TEdit;
    lbl1: TLabel;
    ckbLedImp: TCheckBox;
    ckbWrdSearch: TCheckBox;
    edtMatchCol: TEdit;
    lbl2: TLabel;
    procedure btnMatchClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure UpdateMsg(const aMsg: string);

var
  frmMatch: TfrmMatch;

implementation

uses UF;

{$R *.dfm}

(*
procedure TfrmMatch.btnMergeClick(Sender: TObject);
var
  Obj: TbjGuess;
  Host: string;
begin

  xdb: TbjxMerge;
  mr: integer;
  DParent, LParent: string;
  Obj:TbjMstListImp;
begin
  mr  := MessageDlg('Newer Version of Tally installed?', mtConfirmation, mbYesNoCancel, 0);
//  if mr = mrCancel then
  if mr <> mrYes then
    Exit;
  if (Length(cmbParty.Text) = 0) or (Length(cmbDupLed.Text) = 0) then
  begin
    MessageDlg('Party and Duplicate can not be empty', mtError, [mbOK], 0);
    Exit;
  end;
  if (cmbParty.Text = cmbDupLed.Text) then
  begin
    MessageDlg('Both Party and Duplicate are the same', mtError, [mbOK], 0);
    Exit;
  end;
  Obj := TbjMstListImp.Create;
  Obj.Host := 'http://' + frmXlExport.edtHost.Text + ':'+
    frmXlExport.edtPort.Text;
  try
    dParent := GetLedgerGroup(cmbDupLed.Text);
    lParent := GetLedgerGroup(cmbParty.Text);
  finally
      Obj.Free;
  end;
  if DParent <> LParent then
  begin
    MessageDlg('Groups differ', mtError, [mbOK], 0);
    Exit;
  end;
    btnMerge.Enabled := False;
    btnRefresh.Enabled := False;
    xdb := TbjxMerge.Create;
    try
      xdb.FUpdate := UpdateMsg;
      xdb.FrmDt := FormatDateTime('yyyyMMDD',DateTimePicker1.date);
      xdb.ToDt := FormatDateTime('yyyyMMDD',DateTimePicker2.date);

      if Length(Trim(xdb.FrmDt)) = 0 then
        xdb.FrmDt := FormatDateTime('yyyyMMDD',Now);
      if Length(Trim(xdb.ToDt)) = 0 then
        xdb.ToDt := FormatDateTime('yyyyMMDD',Now);

      xdb.SaveXMLFile := False;
      xdb.Party := cmbParty.Text;
      xdb.DupLed := cmbDupLed.Text;
      xdb.Host := 'http://' + frmXlExport.edtHost.Text + ':'+
      frmXlExport.edtPort.Text;
{
      if mr = mrNo then
        xdb.ImportNoDups := True;
}
      xdb.Process;
    finally
      MessageDlg(IntToStr(xdb.ndups) + ' Duplicates merged',
      mtInformation, [mbOK],0);
      xdb.Free;
      btnMerge.Enabled := True;
      btnRefresh.Enabled := True;
    end;
end;
procedure TfrmMatch.btnRefreshClick(Sender: TObject);
var
  i: integer;
  CMPList: TStringlist;
  LedList: TStringlist;
  Obj: TbjMstListImp;
begin
  btnMerge.Enabled := False;
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
      case cmbLedGroup.ItemIndex of
      2 :
        LedList.Text := Obj.GetPartyText(False);
      else
        LedList.Text := Obj.GetPartyText(True);
      end;
      LedList.Sorted := True;
    except
      MessageDlg('Error Connecting to Tally', mtError, [mbOK], 0);
    end;
  finally
    Obj.Free;
  end;

//  cmbFirm.Items.Add('');
  cmbFirm.Clear;
  for i:= 0 to CMPList.Count-1 do
    cmbFirm.Items.Add(CMPList.Strings[i]);
  cmbDupLed.Clear;
  for i:= 0 to LedList.Count-1 do
    cmbDupLed.Items.Add(LedList.Strings[i]);
  cmbParty.Clear;
  for i:= 0 to LedList.Count-1 do
    cmbParty.Items.Add(LedList.Strings[i]);
  finally
  btnMerge.Enabled := True;
  btnRefresh.Enabled := True;
  MessageDlg(InttoStr(LedList.Count) + ' ledgers imported', mtInformation, [mbOK], 0);
  CMPList.Clear;
  CMPList.Free;
  LedList.Clear;
  LedList.Free;
  end;
end;
*)

procedure TfrmMatch.btnMatchClick(Sender: TObject);
var
  Obj: TbjGuess;
  Host: string;
begin
  btnMatch.Enabled := False;
  Host := 'http://' + frmXlExport.edtHost.Text + ':' + frmXlExport.edtPort.Text;
  Obj := Tbjguess.Create;
  obj.FUpdate := Updatemsg;
  obj.XmlStr := Bank;
  obj.dbName := frmXlExport.edtFolder.Text + frmXlExport.edtdbName.Text;
  obj.TableName := 'Bank';
  if StrToInt(edtChkLen.Text) >= Guess.DefMatchLen-1 then
    Obj.ChlLen := StrtoInt(edtChkLen.Text)
  else
    edtChkLen.Text := IntToStr(Guess.DefMatchLen);
  if ckbRepl.Checked then
    Obj.IsOverWriteOn := True
  else
    Obj.IsOverWriteOn := False;
  if ckbWrdSearch.Checked then
    Obj.IsWrdSearchOn := True
  else
    Obj.IsWrdSearchOn := False;
  if Length(edtMatchCol.Text) > 0 then
    Obj.MatchCol := edtMatchCol.Text
  else
    Obj.MatchCol := 'Ledger';
  obj.Host := Host;
//    obj.Firm := aName;
  try
    Obj.Execute;
  finally
    Obj.Free;
  btnMatch.Enabled := True;
  end;
end;

procedure UpdateMsg(const aMsg: string);
begin
  if Length(aMsg) > 0 then
    frmMatch.Info.Caption := aMsg;
  Application.ProcessMessages;
end;

end.

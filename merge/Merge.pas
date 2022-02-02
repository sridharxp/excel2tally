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

unit Merge;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  ShellApi,
  xmldb_ML,
  PClientFns,
  DateUtils,
  MstListImp;

type
  TfrmMerge = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnMerge: TButton;
    DateTimePicker2: TDateTimePicker;
    Info: TLabel;
    cmbLedGroup: TComboBox;
    Label4: TLabel;
    cmbDupLed: TComboBox;
    lblLedger: TLabel;
    cmbParty: TComboBox;
    btnRefresh: TButton;
    cmbFirm: TComboBox;
    Label6: TLabel;
    Label8: TLabel;
    DateTimePicker1: TDateTimePicker;
    lbl1: TLabel;
    procedure btnMergeClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    { Private declarations }
  protected
  public
    { Public declarations }
  Host: string;
  end;

procedure UpdateMsg(const aMsg: string);

var
  frmMerge: TfrmMerge;

implementation


{$R *.dfm}

procedure TfrmMerge.btnMergeClick(Sender: TObject);
var
  xdb: TbjxMerge;
  StartTime, EndTime, Elapsed: double;
  Hrs, Mins, Secs, Msecs: word;
  DParent, LParent: string;
  Obj:TbjMstListImp;
  sDups: Integer;
  CalcToDt, eDt: TDate;
begin
  StartTime := Time;

//  if mr = mrCancel then
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

  sDups := 0;
  Obj := TbjMstListImp.Create;
//  Obj.Host := 'http://' + frmXlExport.edtHost.Text + ':'+
//    frmXlExport.edtPort.Text;
  Obj.Host := Host;
  try
    dParent := GetLedgerGroup(cmbDupLed.Text);
    lParent := GetLedgerGroup(cmbParty.Text);
  finally
      Obj.Free;
  end;
  if (DParent <> LParent) and (cmbLedGroup.ItemIndex = 2) then
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

      xdb.IsSaveXMLFileOn := False;
      xdb.Party := cmbParty.Text;
      xdb.DupLed := cmbDupLed.Text;
//      xdb.Host := 'http://' + frmXlExport.edtHost.Text + ':'+
//      frmXlExport.edtPort.Text;
      xdb.Host := Host;
{
      if mr = mrNo then
        xdb.ImportNoDups := True;
}
      CalcToDt := DateTimePicker2.Date;
      while DateTimePicker1.Date < CalcToDt do
      begin
        xdb.Process;
        sDups := sDups + xdb.ndups;
        xdb.ndups := 0;
        CalcToDt := IncMonth(CalcToDt, -1);
        eDt := EndOfAMonth(Yearof(CalcToDt), Monthof(CalcToDt));
        if eDt <> CalcToDt then
        begin
          CalcToDt := eDt;
        end;
        xdb.ToDt := FormatDateTime('yyyyMMDD',CalcToDt);
      end;
    finally
  EndTime := Time;
  Elapsed := EndTime - StartTime;
  DecodeTime(Elapsed, Hrs, Mins, Secs, MSecs);
      xDb.FUpDate(IntToStr(sDups) + ' Duplicates merged; '+ IntToStr(SecsPerMin) + ' seonds');
      xdb.Free;
      MessageDlg(IntToStr(sDups) + ' Duplicates merged',
      mtInformation, [mbOK],0);
      btnMerge.Enabled := True;
      btnRefresh.Enabled := True;
    end;
end;

procedure TfrmMerge.btnRefreshClick(Sender: TObject);
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
//  Obj.Host := 'http://' + frmXlExport.edtHost.Text + ':' +
//    frmXlExport.edtPort.Text;
  Obj.Host := Host;
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

procedure UpdateMsg(const aMsg: string);
begin
  if Length(aMsg) > 0 then
    frmMerge.Info.Caption := aMsg;
  Application.ProcessMessages;
end;

end.

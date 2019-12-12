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

unit OffLineP3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  ShellApi,
  xmldb_OffV,
  VerifyOLine,
  PClientFns,
  MstListImp;

type
  TfrMOffLineP = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnImport: TButton;
    DateTimePicker2: TDateTimePicker;
    Info: TLabel;
    cmbLedGroup: TComboBox;
    Label4: TLabel;
    cmbVendor: TComboBox;
    btnRefresh: TButton;
    cmbFirm: TComboBox;
    Label6: TLabel;
    Label8: TLabel;
    DateTimePicker1: TDateTimePicker;
    btnReconcile: TButton;
    procedure btnImportClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnReconcileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure UpdateMsg(Msg: string);

var
  frMOffLineP: TfrMOffLineP;

implementation

uses
  UF, Blank;

{$R *.dfm}

procedure TfrMOffLineP.btnImportClick(Sender: TObject);
var
  xdb: TbjxLedVch4P;
begin
  btnImport.Enabled := False;
  btnRefresh.Enabled := False;
  btnReconcile.Enabled := False;

  xdb := TbjxLedVch4P.Create;
    try
    xdb.FUpdate := UpdateMsg;
    xdb.FrmDt := FormatDateTime('yyyyMMDD',DateTimePicker1.date);
    xdb.ToDt := FormatDateTime('yyyyMMDD',DateTimePicker2.date);

    if Length(Trim(xdb.FrmDt)) = 0 then
      xdb.FrmDt := FormatDateTime('yyyyMMDD',Now);
    if Length(Trim(xdb.ToDt)) = 0 then
      xdb.ToDt := FormatDateTime('yyyyMMDD',Now);

    xdb.ToSaveXMLFile := False;
    xdb.ToSaveXMLFile := True;
    xdb.Vendor := cmbVendor.Text;
    xdb.VchType := cmbLedGroup.Text;
    xdb.Host := 'http://' + frmXlExport.edtHost.Text + ':'+
      frmXlExport.edtPort.Text;
    xdb.Process;
  finally
    MessageDlg(IntToStr(xdb.ndups) + ' Invoice lines imported',
      mtInformation, [mbOK],0);
    xdb.Free;

    btnImport.Enabled := True;
    btnRefresh.Enabled := True;
    btnReconcile.Enabled := True;
  end;
end;

procedure UpdateMsg;
begin
  if length(msg) > 0 then
    frmOffLineP.Info.Caption := Msg
  else
    frmOffLineP.Info.Caption := 'Done';
  Application.ProcessMessages;
end;

procedure TfrMOffLineP.btnRefreshClick(Sender: TObject);
var
  i: integer;
  CMPList: TStringlist;
  LedList: TStringlist;
  Obj: TbjMstListImp;
begin
  btnReconcile.Enabled := False;
  btnImport.Enabled := False;
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

  cmbFirm.Items.Add('');
  cmbFirm.Clear;
  for i:= 0 to CMPList.Count-1 do
    cmbFirm.Items.Add(CMPList.Strings[i]);
  cmbVendor.Clear;
//  cmbVendor.Items.Add('');
  for i:= 0 to LedList.Count-1 do
    cmbVendor.Items.Add(LedList.Strings[i]);
//  cmbParty.Clear;
//  for i:= 0 to LedList.Count-1 do
//    cmbParty.Items.Add(LedList.Strings[i]);
  finally
  btnReconcile.Enabled := True;
  btnImport.Enabled := True;
  btnRefresh.Enabled := True;
  CMPList.Clear;
  CMPList.Free;
  LedList.Clear;
  LedList.Free;
  end;
  MessageDlg('Done', mtInformation, [mbOK], 0);
end;

procedure TfrMOffLineP.btnReconcileClick(Sender: TObject);
var
  Obj: TbjVerifyOLine;
begin
  btnImport.Enabled := False;
  btnRefresh.Enabled := False;
  btnReconcile.Enabled := False;

  Obj := TbjVerifyOLine.Create;
  try
    obj.FUpdate := UpdateMsg;
    Obj.VerifyOLine;
  finally
    Obj.Free;
  end;

  MessageDlg(IntToStr(obj.nNInp) + ' lines found',
    mtInformation, [mbOK],0);

  btnImport.Enabled := True;
  btnRefresh.Enabled := True;
  btnReconcile.Enabled := True;
   ShellExecute(frmxlExport.Handle, Pchar('Open'), PChar(
      '.\Data\Tally-2A.xls'),
      nil,
      nil, SW_SHOWNORMAL);
end;

end.

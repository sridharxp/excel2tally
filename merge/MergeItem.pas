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

unit MergeItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  ShellApi,
  xmldb_MI,
  PClientFns,
  DateUtils,
  MstListImp;

type
  TfrmMergeItem = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnMerge: TButton;
    DateTimePicker2: TDateTimePicker;
    Info: TLabel;
    lblLedger: TLabel;
    cmbItem: TComboBox;
    btnRefresh: TButton;
    cmbFirm: TComboBox;
    Label6: TLabel;
    Label8: TLabel;
    DateTimePicker1: TDateTimePicker;
    cmbDupItem: TComboBox;
    procedure btnMergeClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure mniTestTallyClick(Sender: TObject);
    procedure mniAbout1Click(Sender: TObject);
    procedure mniFindUpdate1Click(Sender: TObject);
    procedure mniDownloadAccessDatabaseEngine20161Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure UpdateMsg(const aMsg: string);

var
  frmMergeItem: TfrmMergeItem;

implementation

uses XlExport;

{$R *.dfm}

procedure TfrmMergeItem.btnMergeClick(Sender: TObject);
var
  xdb: TbjxMerge;
  mr: integer;
//  DParent, LParent: string;
//  Obj: TbjMstListImp;
  ItemUnit, DupUnit: string;
  sDups: Integer;
  CalcToDt, eDt: TDate;
begin
//  mr  := MessageDlg('Newer Version of Tally installed?', mtConfirmation, mbYesNoCancel, 0);
//  if mr = mrCancel then
//  if mr <> mrYes then
//    Exit;
{
  if Length(cmbLedger.Text) = 0 then
  begin
    MessageDlg('Ledger can not be empty', mtError, [mbOK], 0);
    Exit;
  end;
}
  if (Length(cmbItem.Text) = 0) or (Length(cmbDupItem.Text) = 0) then
  begin
    MessageDlg('Item and Duplicate can not be empty', mtError, [mbOK], 0);
    Exit;
  end;
  if (cmbItem.Text = cmbDupItem.Text) then
  begin
    MessageDlg('Both Item and Duplicate can not be the same', mtError, [mbOK], 0);
    Exit;
  end;
  if not Assigned(ClientFns) then
     ClientFns := TbjGSTClientFns.Create;
  ClientFns.Host := 'http://' + frmXlExport.edtHost.Text + ':'+
    frmXlExport.edtPort.Text;
  ItemUnit := GetItemUnit(cmbItem.Text);
  DupUnit := GetItemUnit(cmbDupItem.Text);
  if ItemUnit <> Dupunit then
  begin
    MessageDlg('Units differ', mtError, [mbOK], 0);
    Exit;
  end;
{
  Obj := TbjMstList.Create;
  try
    dParent := Obj.GetGroup(cmbDupItem.Text);
    lParent := Obj.GetGroup(cmbItem.Text);
  finally
      Obj.Free;
  end;
  if DParent <> LParent then
  begin
    MessageDlg('Groups differ', mtError, [mbOK], 0);
    Exit;
  end;
}
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
//      xdb.Ledger := cmbLedger.Text;
      xdb.Item := cmbItem.Text;
      xdb.DupItem := cmbDupItem.Text;
      xdb.Host := 'http://' + frmXlExport.edtHost.Text + ':'+
      frmXlExport.edtPort.Text;
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
      MessageDlg(IntToStr(sDups) + ' Duplicates merged',
      mtInformation, [mbOK],0);
      xdb.Free;
      btnMerge.Enabled := True;
      btnRefresh.Enabled := True;
    end;
end;

procedure TfrmMergeItem.btnRefreshClick(Sender: TObject);
var
  i: integer;
  CMPList: TStringlist;
  ItemList: TStringlist;
//  LedList: TStringList;
  Obj: TbjMstListImp;
begin
  btnMerge.Enabled := False;
  btnRefresh.Enabled := False;
  CMPList := TStringList.Create;
 // lEDList := TStringList.Create;
  ItemList := TStringList.Create;
  try
    Obj := TbjMstListImp.Create;
    Obj.ToPack := False;
    Obj.Host := 'http://' + frmXlExport.edtHost.Text + ':' +
    frmXlExport.edtPort.Text;
    try
      try
        CMPList.Text := Obj.GetCMPText;
        CMPList.Sorted := True;
//      case cmbLedGroup.ItemIndex of
//      2 :
//        LedList.Text := Obj.GetPartyText(False);
//      else
//        LedList.Text := Obj.GetPartyText(True);
//      end;
        ItemList.Text := Obj.GetItemText;
//      LedList.Text := Obj.GetSalesList.Text + Obj.GetPurcList.Text;
//      LedList := Obj.GetSalesList;
        ItemList.Sorted := True;
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
    cmbDupItem.Clear;
    cmbDupItem.Items.Add('');
    for i:= 0 to ItemList.Count-1 do
      cmbDupItem.Items.Add(ItemList.Strings[i]);
    cmbItem.Clear;
    for i:= 0 to ItemList.Count-1 do
      cmbItem.Items.Add(ItemList.Strings[i]);
//  CmbLedger.Clear;
//  cmbLedger.Items.Add('');
//  for i:= 0 to LedList.Count-1 do
//    cmbLedger.Items.Add(LedList.Strings[i]);
  finally
    btnMerge.Enabled := True;
    btnRefresh.Enabled := True;
    MessageDlg(InttoStr(ItemList.Count) + ' items imported', mtInformation, [mbOK], 0);
    CMPList.Clear;
    CMPList.Free;
    ItemList.Clear;
    ItemList.Free;
//  LedList.Clear;
//  LedList.Free;
  end;
end;

procedure TfrmMergeItem.mniTestTallyClick(Sender: TObject);
  var
    url: string;
begin
  url := 'http://127.0.0.1:9000' ;
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
 end;

procedure TfrmMergeItem.mniAbout1Click(Sender: TObject);
begin
  MessageDlg('Sridharan S' + #10 + '+91 98656 82910' + #10 +'excel2tallyerp@gmail.com',
  mtInformation, [mbOK], 0);
end;

procedure TfrmMergeItem.mniFindUpdate1Click(Sender: TObject);
  var
    url: string;
begin
  url := 'https://drive.google.com/drive/folders/1sxuQN7yLrNtHc77eoXu_dcj489jWie11?usp=sharing';
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMergeItem.mniDownloadAccessDatabaseEngine20161Click(
  Sender: TObject);
  var
    url: string;
begin
  if MessageDlg('Download) Access Database Engine 2016?', mtConfirmation, mbYesNoCancel, 0) <> mrYes then
    Exit;
  url := 'https://download.microsoft.com/download/3/5/C/35C84C36-661A-44E6-9324-8786B8DBE231/AccessDatabaseEngine.exe';
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure UpdateMsg(const aMsg: string);
begin
  if Length(aMsg) > 0 then
    frmMergeItem.Info.Caption := aMsg;
  Application.ProcessMessages;
end;

end.

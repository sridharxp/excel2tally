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
unit VerifyOLine;

interface

uses
  Classes, SysUtils, DateUtils,
  Dialogs,
  XLSFile,
  Blank,
  XLSWorkbook,
  Variants,
  xlstbl;

type
  Tfnupdate = procedure(msg: string);

  PV = Record
//    Month: TDateTime;
    Month: integer;
    GSTN: string;
    Invoice_No: string;
//    Invoice_Date: TDateTime;
    Invoice_Date: integer;
    Invoice_Value: string;
    Supplier: string;
    Basic: string;
    SGST: string;
    CGST: string;
    IGST: string;
    Tax: double;
    Rate: string;
  end;
  pPV = ^PV;

type
  TbjVerifyOLine = class
  private
    { Private declarations }
  protected
  public
    { Public declarations }
    nNInp: integer;
    XL: TXLSFile;
    flds: TStringList;
    OnLine: TbjXLSTable;
    OffLine: TbjXLSTable;
    NoInput: TbjXLSTable;
    FUpdate: TfnUpdate;
    OffList: TList;
    OnList: TList;
    VList: TList;
    procedure VerifyOline;
    procedure LoadList;
    procedure VerifyOneTime(item: pPV; const chk: string);
    procedure Writexls(item: pPV);
    constructor Create;
    destructor Destroy; override;
  end;
function VarIsSame(_A, _B: Variant): Boolean;
function VarCompare(_A, _B: Variant): Boolean;

implementation

Constructor TbjVerifyOLine.Create;
var
  Obj: TxlsBlank;
begin
  Inherited;
  Obj := TxlsBlank.Create;
  Obj.CreateTally2A;
  Obj.Free;
  onLine := TbjXLSTable.Create;
  offLine := TbjXLSTable.Create;
  NoInput := TbjXLSTable.Create;
  NoInput.ToSaveFile := True;
  OnList := TList.Create;
  OFFList := TList.Create;
  flds := TStringList.Create;
  XL := TXLSFile.Create;
  XL.OpenFile('.\Data\Tally-2A.xls');

  OnLine.XL := XL;
  OnLine.Workbook := XL.Workbook;
  OnLine.SetSheet('ONLINE');
  flds.Clear;
  flds.Add('Month');
  flds.Add('GSTN');
  flds.Add('Invoice_No');
  flds.Add('Invoice_Date');
  flds.Add('Invoice_Value');
  flds.Add('Supplier');
  flds.Add('Basic');
  flds.Add('SGST');
  flds.Add('CGST');
  flds.Add('IGST');
  flds.Add('Total_Tax');
  flds.Add('Tax_rate');
  OnLine.GetFields(flds);
  Online.SetFieldFormat('Month', 14);
  OnLine.SetFieldFormat('Invoice_Date', 14);

  OffLine.XL := XL;
  OffLine.Workbook := XL.Workbook;
  OffLine.SetSheet('OFFLINE');
  flds.Clear;
  flds.Add('Month');
  flds.Add('GSTN');
  flds.Add('Invoice_No');
  flds.Add('Invoice_Date');
  flds.Add('Invoice_Value');
  flds.Add('Supplier');
  flds.Add('Basic');
  flds.Add('SGST');
  flds.Add('CGST');
  flds.Add('IGST');
  flds.Add('Total_Tax');
  flds.Add('Tax_rate');
  OffLine.GetFields(flds);
  OffLine.SetFieldFormat('Month', 14);
  OffLine.SetFieldFormat('Invoice_Date', 14);

  NoInput.XL := XL;
  NoInput.Workbook := XL.Workbook;
  NoInput.SetSheet('NOINPUT');
  flds.Clear;
  flds.Add('Month');
  flds.Add('GSTN');
  flds.Add('Invoice_No');
  flds.Add('Invoice_Date');
  flds.Add('Invoice_Value');
  flds.Add('Supplier');
  flds.Add('Basic');
  flds.Add('SGST');
  flds.Add('CGST');
  flds.Add('IGST');
  flds.Add('Total_Tax');
  flds.Add('Tax_rate');
  NoInput.GetFields(flds);
  NoINput.SetFieldFormat('Month', 14);
  NoINput.SetFieldFormat('Invoice_Date', 14);
end;

destructor TbjVerifyOLine.Destroy;
var
  item: pPV;
  i: integer;
begin
  for i := 0 to OnList.Count - 1 do
  begin
    item := OnList.Items[i];
    item.GSTN := '';
    item.Invoice_No := '';
    item.Supplier := '';
    item.Rate := '';
    Dispose(item);
  end;
  OnList.Clear;
  OnList.Free;
  for i := 0 to OffList.Count - 1 do
  begin
    item := OffList.Items[i];
    item.GSTN := '';
    item.Invoice_No := '';
    item.Supplier := '';
    item.Rate := '';
    Dispose(item);
  end;
  OffList.Clear;
  OffList.Free;
  flds.Free;
  XL.Free;
  OnLine.Free;
  OffLine.Free;
  NoInput.Free;
  inherited;
end;

procedure TbjVerifyOLine.VerifyOline;
var
  item_L: pPV;
  i: integer;
begin
  NoInput.First;
  LoadList;
  for i := 0 to OffList.Count-1 do
  begin
    item_L := OffList.Items[i];
    FUpdate('Checking ' + item_L.Invoice_No);
    VerifyOneTime(item_L, ' ');

    VerifyOneTime(item_L, 'I');
    VerifyOneTime(item_L, 'D');
    VerifyOneTime(item_L, 'ID');

    WriteXls(item_L);
  end;
  NoInput.SetFieldVal('MONTH', '');
  NoInput.SetFieldVal('GSTN', '');
  NoInput.SetFieldVal('INVOICE_NO', '');
  NoInput.SetFieldVal('INVOICE_DATE', '');
  NoInput.SetFieldVal('SUPPLIER', '');
  NoInput.SetFieldVal('Tax_rate', '');
  NoInput.SetFieldVal('BASIC', '');
  NoInput.SetFieldVal('SGST', '');
  NoInput.SetFieldVal('CGST', '');
  NoInput.SetFieldVal('IGST', '');
  NoInput.SaveAs('.\Data\Tally-2A.xls');
end;

procedure TbjVerifyOLine.VerifyOnetime(item: pPV; const chk: string);
var
  item_R: pPV;
  i: integer;
begin
  for i := 0 to OnList.Count-1 do
  begin
    item_R := OnList.Items[i];
    if item.GSTN <> item_R.GSTN then
      Continue;
    if Pos('D', Chk) = 0 then
    if item.Invoice_Date <> item_R.Invoice_Date then
      Continue;
    if Pos('I', Chk) = 0 then
    if item.Invoice_No <> item_R.Invoice_No then
      Continue;
    if item.Rate <> item_R.Rate then
      Continue;
    if ((item.Invoice_Value <> item_R.Invoice_Value)) and
      ((item.Basic <> item_R.Basic)) then
      Continue;
{
    if (item.Invoice_Value <> item_R.Invoice_Value) OR
      (trunc(item.Invoice_Value) <> item_R.Invoice_Value) or
      (trunc(item.Invoice_Value) <> item_R.Invoice_Value)then

    if item.Basic > 0 then
    if item.Basic = item_R.Basic then
    begin
      item.Basic := 0;
//      item_R.Basic := 0;
    end;
}
    if Length(item.SGST) > 0 then
    if item.SGST = item_R.SGST then
    begin
      item.SGST := ''
    end;
    if Length(item.CGST) > 0 then
    if item.CGST = item_R.CGST then
    begin
      item.CGST := '';
    end;
    if Length(item.IGST) > 0 then
    if item.IGST = item_R.IGST then
    begin
      item.IGST := '';
    end;
  end;
end;

procedure TbjVerifyOLine.Writexls(item: pPV);
begin
  if (Length(item.SGST) = 0) and (Length(item.CGST) = 0) and (Length(item.IGST) = 0) then
  Exit;
  NoInput.SetFieldVal('MONTH', item.Month);
  NoInput.SetFieldVal('GSTN', item.GSTN);
  NoInput.SetFieldVal('INVOICE_NO', item.Invoice_No);
  NoInput.SetFieldVal('INVOICE_DATE', item.Invoice_Date);
  NoInput.SetFieldVal('INVOICE_VALUE', item.Invoice_Value);
  NoInput.SetFieldVal('SUPPLIER', item.Supplier);
  NoInput.SetFieldVal('BASIC', item.Basic);
  NoInput.SetFieldVal('SGST', item.SGST);
  NoInput.SetFieldVal('CGST', item.CGST);
  NoInput.SetFieldVal('IGST', item.IGST);
  NoInput.SetFieldVal('Tax_rate', item.Rate);
  nNInp := nNInp + 1;
  NoInput.CurrentRow := NoInput.CurrentRow + 1;
end;

{
procedure TbjVerifyOLine.VerifyOline;
begin
  LoadList;
  OffLine.First;
  NoInput.First;
  while not OffLine.EOF do
  begin
    FUpdate('Checking ' + OffLine.GetFieldString('INVOICE_DATE'));
//    NoInput.CurrentRow := OffLine.CurrentRow;
//    NoInput.Insert;
    NoInput.SetFieldVal('MONTH', OffLine.GetFieldVal('MONTH'));
    NoInput.SetFieldVal('GSTN', OffLine.GetFieldVal('GSTN'));
    NoInput.SetFieldVal('INVOICE_NO', OffLine.GetFieldVal('INVOICE_NO'));
    NoInput.SetFieldVal('INVOICE_DATE', OffLine.GetFieldVal('INVOICE_DATE'));
    NoInput.SetFieldVal('INVOICE_VALUE', OffLine.GetFieldVal('INVOICE_VALUE'));
    NoInput.SetFieldVal('SUPPLIER', OffLine.GetFieldVal('SUPPLIER'));
    NoInput.SetFieldVal('Tax_rate', OffLine.GetFieldVal('Tax_rate'));
    IsNoInput;
    OffLine.Next;
  end;
  NoInput.Insert;
  NoInput.SetFieldVal('MONTH', '');
  NoInput.SetFieldVal('GSTN', '');
  NoInput.SetFieldVal('INVOICE_NO', '');
  NoInput.SetFieldVal('INVOICE_DATE', '');
  NoInput.SetFieldVal('SUPPLIER', '');
  NoInput.SetFieldVal('Tax_rate', '');
  NoInput.SetFieldVal('BASIC', '');
  NoInput.SetFieldVal('SGST', '');
  NoInput.SetFieldVal('CGST', '');
  NoInput.SetFieldVal('IGST', '');
  NoInput.SaveAs('.\Data\Tally-2A.xls');
end;

function TbjVerifyOLine.IsNoInput: boolean;
var
  IsNoInput: boolean;
begin
  IsNoInput := False;
  Result := False;
  Online.First;
  while not Online.EOF do
  begin
    if not VarCompare(OffLine.GetFieldVal('GSTN'), OnLine.GetFieldVal('GSTN')) then
    begin
      OnLine.Next;
      Continue;
    end;
    if not VarCompare(OffLine.GetFieldVal('INVOICE_DATE'), OnLine.GetFieldVal('INVOICE_DATE')) then
    begin
      OnLine.Next;
      Continue;
    end;
    if not VarCompare(OffLine.GetFieldVal('INVOICE_NO'), OnLine.GetFieldVal('INVOICE_NO')) then
    begin
      OnLine.Next;
      Continue;
    end;
    if not VarCompare(OffLine.GetFieldVal('Tax_rate'), OnLine.GetFieldVal('Tax_rate')) then
    begin
      OnLine.Next;
      Continue;
    end;
    if not VarCompare(OffLine.GetFieldVal('BASIC'), OnLine.GetFieldVal('BASIC')) then
    begin
      NoInput.SetFieldVal('BASIC', Offline.GetFieldVal('BASIC'));
      IsNoInput := True;
    end;
    if not VarCompare(OffLine.GetFieldVal('SGST'), OnLine.GetFieldVal('SGST')) then
    begin
      NoInput.SetFieldVal('SGST', Offline.GetFieldVal('SGST'));
      IsNoInput := True;
    end;
    if not VarCompare(OffLine.GetFieldVal('CGST'), OnLine.GetFieldVal('CGST')) then
    begin
      NoInput.SetFieldVal('CGST', Offline.GetFieldVal('CGST'));
      IsNoInput := True;
    end;
    if not VarCompare(OffLine.GetFieldVal('IGST'), OnLine.GetFieldVal('IGST')) then
    begin
      NoInput.SetFieldVal('IGST', Offline.GetFieldVal('IGST'));
      IsNoInput := True;
    end;
    if IsNoInput then
    begin
      nNInp := nNInp + 1;
      NoInput.CurrentRow := NoInput.CurrentRow + 1;
      Exit;
    end
   else
   begin
      NoInput.Delete;
      Exit;
   end;
    OnLine.Next;
  end;
  NoInput.SetFieldVal('BASIC', Offline.GetFieldVal('BASIC'));
  NoInput.SetFieldVal('SGST', Offline.GetFieldVal('SGST'));
  NoInput.SetFieldVal('CGST', Offline.GetFieldVal('CGST'));
  NoInput.SetFieldVal('IGST', Offline.GetFieldVal('IGST'));
  nNInp := nNInp + 1;
  NoInput.CurrentRow := NoInput.CurrentRow + 1;
end;
}

procedure TbjVerifyOLine.LoadList;
var
  item: pPV;
begin
  OnLine.First;
  if OnLine.EOF then
    MessageDlg('OnLine worksheet is empty', mtWarning, [mbOK], 0);
  OffLine.First;
  if OffLine.EOF then
    MessageDlg('OffLine worksheet is empty', mtWarning, [mbOK], 0);
  while not OnLine.EOF do
  begin
    item := New(pPV);
    iTEM.Month := OnLine.GetFieldVal('MONTH');
    item.GSTN := OnLine.GetFieldVal('GSTN');
    item.Invoice_No := OnLine.GetFieldVal('INVOICE_NO');
    item.Invoice_Date := OnLine.GetFieldVal('INVOICE_DATE');
    item.Supplier := OnLine.GetFieldVal('SUPPLIER');
    item.Basic := OnLine.GetFieldVal('BASIC');
    item.SGST := OnLine.GetFieldVal('SGST');
    item.CGST := OnLine.GetFieldVal('CGST');
    item.IGST := OnLine.GetFieldVal('IGST');
    item.Tax := OnLine.GetFieldVal('TOTAL_TAX');
    item.Rate := OnLine.GetFieldVal('TAX_RATE');
    OnList.Add(item);
    OnLine.Next;
  end;
  OffLine.First;
  while not OFFLine.EOF do
  begin
    item := New(pPV);
    iTEM.Month := OffLine.GetFieldVal('MONTH');
    item.GSTN := OffLine.GetFieldVal('GSTN');
    item.Invoice_No := OffLine.GetFieldVal('INVOICE_NO');
    item.Invoice_Date := OffLine.GetFieldVal('INVOICE_DATE');
    item.Invoice_Value := OffLine.GetFieldVal('INVOICE_Value');
    item.Supplier := OffLine.GetFieldVal('SUPPLIER');
    item.Basic := OffLine.GetFieldVal('BASIC');
    item.SGST := OffLine.GetFieldVal('SGST');
    item.CGST := OffLine.GetFieldVal('CGST');
    item.IGST := OffLine.GetFieldVal('IGST');
    item.Tax := OffLine.GetFieldVal('TOTAL_TAX');
    item.Rate := OffLine.GetFieldVal('TAX_RATE');
    OffList.Add(item);
    OffLine.Next;
  end;
end;

function VarIsSame(_A, _B: Variant): Boolean;
var
  LA, LB: TVarData;
begin
  LA := FindVarData(_A)^;
  LB := FindVarData(_B)^;
  if LA.VType <> LB.VType then
    Result := False
  else
    Result := (_A = _B);
end;

function VarCompare(_A, _B: Variant): Boolean;
begin
  Result := VarIsSame(_A, _B);
  if not Result then
    Result := VarSameValue(_A, _B);
end;

end.

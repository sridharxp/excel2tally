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
unit xmldb_OffV;

interface

uses
  Classes, SysUtils, DateUtils,
  Dialogs,
  DateFns,
  StrUtils,
  VchLib,
  Client,
  PClientFns,
  xlstbl,
  MstListImp,
  bjxml3_1;

type
  Tfnupdate = procedure(msg: string);

type
  TbjxLedVch4P = class
  private
    { Private declarations }
    FXReq: wideString;
    FHost: string;
    FFirm: String;
    FFrmDt: string;
    FToDT: string;
    FVendor: string;
    FVchType: string;
  protected
    rDB: string;
    xDB: string;
    VendorGSTN: string;
    dmyDate: TDateTime;
    Date, InvNo, InvAmt: string;
    lName, lAmt: string;
    Basic, SGST, CGST, IGST: string;
    Basic28, SGST14, CGST14, IGST28: string;
    Basic18, SGST9, CGST9, IGST18: string;
    Basic12, SGST6, CGST6, IGST12: string;
    Basic5, SGST2_5, CGST2_5, IGST5: string;
    Basic3, SGST1_5, CGST1_5, IGST3: string;
    Client: TbjClient;
    aID: Ibjxml;
    vID: Ibjxml;
    lID: Ibjxml;
    MList: TbjMstListImp;
    PuList, TXList: TStringList;
//    plID: Ibjxml;
  public
    { Public declarations }
    ndups: Integer;
    CurDt: string;
    ToSaveXMLFile: boolean;
    FUpdate: TfnUpdate;
    flds: TStringList;
    kadb: TbjXLSTable;
    procedure GetLedVchRgtr;
    procedure GetVouXML;
    procedure CalcAmt;
    procedure WriteXls;
    procedure Process;
    procedure ParseVch;
    procedure ErrorCheck;
    procedure LoadDefault;
    procedure SetHost(const aHost: string);
    constructor Create;
    destructor Destroy; override;
  published
    property Firm: String read FFirm write FFirm;
    property Host: String read FHost write SetHost;
    property FrmDt: string Read FFrmDt write FFrmDt;
    property ToDt: string Read FToDt write FToDt;
    property Vendor: string Read FVendor write FVendor;
    property VchType: string Read FVchType write FVchType;
  end;

implementation

uses
  Blank;

Constructor TbjxLedVch4P.Create;
var
  Obj: TxlsBlank;
begin
  FHost := 'http://127.0.0.1:9000';
  Client := TbjClient.Create;
  ToSaveXMLFile := False;
  Obj := TxlsBlank.Create;
  Obj.CreateTally2A;
  Obj.Free;
  kadb := TbjXLSTable.Create;
  kadb.ToSaveFile := True;
  MList := TbjMstListImp.Create;
  TxList := TStringList.Create;
  PuList := TStringList.Create;
  flds := TStringList.Create;
  kadb.SetXLSFile('.\Data\Tally-2A.xls');
  kadb.SetSheet('OFFLINE');
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
  kadb.GetFields(flds);
  kadb.First;
end;

destructor TbjxLedVch4P.Destroy;
begin
  Client.Free;
  PuList.Free;
  TxList.Free;
  MList.Free;
  flds.Free;
  kadb.Free;
  inherited;
end;

Procedure TbjxLedVch4P.ErrorCheck;
begin
  if Client.Response.Size = 0 then
    raise exception.Create('Error Getting Data from Tally');
end;

procedure TbjxLedVch4P.SetHost(const aHost: string);
begin
  FHost := aHost;
end;

procedure TbjxLedVch4P.Process;
var
  rDoc: Ibjxml;
  rID: Ibjxml;
  rVchType: IbjXml;
begin
{
  kadb.First;
//  while not kadb.IsEmptyField('SUPPLIER') do
  while not kadb.Eof do
    kadb.Delete;
}
  if Length(Vendor) = 0 then
  begin
    MessageDlg('Supplier can not be blank', mtError, [mbOK], 0);
    Abort;
  end;
  PuList.Text := MList.GetPurcText;
  PuList.Sorted := True;
  TxList.Text := MList.GetTaxText;
  TxList.Sorted := True;
  if not Assigned(ClientFns) then
     ClientFns := TbjGSTClientFns.Create;
  VendorGSTN := GetLedgersGSTN(Vendor);
  GetLedVchRgtr;
  rDoc := CreatebjXmlDocument;
  rDoc.LoadXML(rDB);
  rID := rDoc.SearchForTag(nil, 'DSPVCHDATE');
  while Assigned(rID) do
  begin

    rVchType := rDoc.SearchForTag(rID, 'DSPVCHTYPE');
    if Assigned(rVchType) then
    if rVchType.GetContent <> 'Purc' then
    begin
      rID := rDoc.SearchForTag(rID, 'DSPVCHDATE');
      Continue;
    end;

    if CurDt = rID.GetContent then
    begin
      rID := rDoc.SearchForTag(rID, 'DSPVCHDATE');
      Continue;
    end;
    CurDt := rID.GetContent;
    FUpdate('Importing ' + CurDt);
    GetVouXML;
    ParseVch;;
  rID := rDoc.SearchForTag(rID, 'DSPVCHDATE');
  end;
  PuList.Clear;
  TxList.Clear;
end;

procedure TbjxLedVch4P.GetLedVchRgtr;
begin
  FxReq := '<ENVELOPE><HEADER><TALLYREQUEST>Export Data</TALLYREQUEST></' +
    'HEADER>'+
  '<BODY><EXPORTDATA><REQUESTDESC>' +
  '<REPORTNAME>Ledger Vouchers</REPORTNAME>'
  +'<STATICVARIABLES>';
  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';
  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';
  if ( Length(FFrmDt) <> 0 ) and ( Length(FToDt) <> 0 ) then
  begin
    FxReq := FXReq + '<SVFROMDATE>' + FFrmDt + '</SVFROMDATE>';
    FxReq := FXReq + '<SVTODATE>' + FToDt + '</SVTODATE>';
  end;
  FxReq := FXReq + '<LEDGERNAME>' +  Vendor + '</LEDGERNAME>';
  FxReq := FXReq +
  '</STATICVARIABLES>'+
  '</REQUESTDESC>'+
  '</EXPORTDATA></BODY></ENVELOPE>';

  if ToSaveXMLFile then
      Client.xmlResponsefile := 'LedVouRgtr.xml';
  Client.Host := FHost;
  Client.xmlRequestString := Fxreq;
  Client.post;
  Errorcheck;
  rdb := Client.xmlResponseString;
end;

procedure TbjxLedVch4P.GetVouXML;
begin
  FxReq := '<ENVELOPE><HEADER><TALLYREQUEST>Export Data</TALLYREQUEST></' +
    'HEADER>'+
  '<BODY><EXPORTDATA><REQUESTDESC>' +
  '<REPORTNAME>Voucher Register</REPORTNAME>'
//'<REPORTNAME>Day Book</REPORTNAME>'
  +'<STATICVARIABLES>';

  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';

  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';

    FxReq := FXReq + '<SVCURRENTDATE>' + CurDt + '</SVCURRENTDATE>';

    FxReq := FXReq + '<OnlyAccVouchers>' +  'true' + '</OnlyAccVouchers>';
//    FxReq := FXReq + '<OnlyInvVouchers>' +  'True' + '</OnlyInvVouchers>';
//    FxReq := FXReq + '<$$IsSales:SVVoucherType>' + 'False' +
//      '</$$IsSales:SVVoucherType>';
  FxReq := FXReq + '<VoucherTypeName>' +  '$$VchTypePurchase' + '</VoucherTypeName>';
  FxReq := FXReq + '<LEDGERNAME>' +  Vendor + '</LEDGERNAME>';

  FxReq := FXReq +
  '</STATICVARIABLES>'+
  '</REQUESTDESC>'+
  '</EXPORTDATA></BODY></ENVELOPE>';

  if ToSaveXMLFile then
      Client.xmlResponsefile := 'VouReg.xml';
  Client.Host := FHost;
  Client.xmlRequestString := Fxreq;
  Client.post;
  Errorcheck;
  xdb := Client.xmlResponseString;
end;


{ rfReplaceAll rfIgnoreCase }
procedure TbjxLedVch4P.ParseVch;
var
  MDoc, VDoc: Ibjxml;
begin
  MDoc := CreatebjXmlDocument;
  MDoc.LoadXML(xDB);
  vDoc := MDoc.SearchForTag(nil, 'TALLYMESSAGE');
  while Assigned(vDoc) do
  begin
    vid := vDoc.SearchForTag(nil, 'VOUCHER');
    lID := vID.SearchForTag(nil, 'LEDGERNAME');
//    plID := vID.SearchForTag(nil, 'PARTYLEDGERNAME');
    Date := '';
    InvNo := '';
    lName := '';
    lAmt := '';
    Basic := '';
    SGST := '';
    CGST := '';
    IGST := '';
    Basic28 := '';
    SGST14 := '';
    CGST14 := '';
    IGST28 := '';
    Basic18 := '';
    SGST9 := '';
    CGST9 := '';
    IGST18 := '';
    Basic12 := '';
    SGST6 := '';
    CGST6 := '';
    IGST12 := '';
    Basic5 := '';
    SGST2_5 := '';
    CGST2_5 := '';
    IGST5 := '';
    Basic3 := '';
    SGST1_5 := '';
    CGST1_5 := '';
    IGST3 := '';
    while Assigned(lID) do
    begin
      CalcAmt;
      lID := vID.SearchForTag(lID, 'LEDGERNAME');
    end;
    WriteXls;
    vDoc := MDoc.SearchForTag(VDoc, 'TALLYMESSAGE');
  end;
  kadb.SetFieldVal('MONTH', '');
  kadb.SetFieldVal('GSTN', '');
  kadb.SetFieldVal('INVOICE_NO', '');
  kadb.SetFieldVal('INVOICE_DATE', '');
  kadb.SetFieldVal('SUPPLIER', '');
  kadb.SetFieldVal('Tax_rate', '');
  kadb.SetFieldVal('BASIC', '');
  kadb.SetFieldVal('SGST', '');
  kadb.SetFieldVal('CGST', '');
  kadb.SetFieldVal('IGST', '');
  if kadb.ToSaveFile then
    kadb.SaveAs('.\data\Tally-2A.xls');
end;

procedure TbjxLedVch4P.CalcAmt;
var
//  Obj: TxlsBlank;
  AmtID: Ibjxml;
  xDate, xRef: IbjXml;
  idx: integer;
begin
  lName := lID.GetContent;
  AmtID := VID.SearchForTag(lID, 'AMOUNT');
  if Assigned(AmtID) then
    lAmt := AmtID.GetContent;
  xDate := VID.SearchForTag(nil, 'DATE');
  Date := xDate.GetContent;
  xRef := VID.SearchForTag(nil, 'REFERENCE');
  InvNo := xRef.GetContent;
  if lName = Vendor then
    InvAmt := lAmt;
  if (TxList.Find(PackStr(lName),  idx)) and (Pos('SGST', UpperCase(lName)) > 0)  then
  begin
    if Pos('14', lName) > 0 then
      SGST14 := lAmt
    else if Pos('9', lName) > 0 then
      SGST9 := lAmt
    else if Pos('6', lName) > 0 then
      SGST6 := lAmt
    else if Pos('2.5', lName) > 0 then
      SGST2_5 := lAmt
    else if Pos('1.5', lName) > 0 then
      SGST1_5 := lAmt
    else
      SGST := lAmt;
    end;
  if (TxList.Find(PackStr(lName), idx)) and (Pos('CGST', UpperCase(lName)) > 0)  then
  begin
    if Pos('14', lName) > 0 then
      CGST14 := lAmt
    else if Pos('9', lName) > 0 then
      CGST9 := lAmt
    else if Pos('6', lName) > 0 then
      CGST6 := lAmt
    else if Pos('2.5', lName) > 0 then
      CGST2_5 := lAmt
    else if Pos('1.5', lName) > 0 then
      CGST1_5 := lAmt
    else
      CGST := lAmt;
    end;
  if (TxList.Find(PackStr(lName), idx)) and (Pos('IGST', UpperCase(lName)) > 0)  then
    begin
    if Pos('28', lName) > 0 then
      IGST28 := lAmt
    else if Pos('18', lName) > 0 then
      IGST18 := lAmt
    else if Pos('12', lName) > 0 then
      IGST12 := lAmt
    else if Pos('5', lName) > 0 then
      IGST5 := lAmt
    else if Pos('3', lName) > 0 then
      IGST3 := lAmt
    else
      IGST := lAmt;
    end;
//    ShowMessage(LName);
//  ShowMessage(PuList.text);
//     if Pos('PURCHASE', UpperCase(lName)) > 0 then
    if PuList.Find(PackStr(lName), idx) then
    begin
//      ShowMessage(lname);
      if Pos('28', lName) > 0 then
      Basic28 := lAmt
      else if Pos('18', lName) > 0 then
      Basic18 := lAmt
      else if Pos('12', lName) > 0 then
      Basic12 := lAmt
      else if Pos('5', lName) > 0 then
      Basic5 := lAmt
      else if Pos('3', lName) > 0 then
      Basic3 := lAmt
      else
      Basic := lAmt;
    end;
end;

procedure TbjxLedVch4P.WriteXls;
var
  lineOK: boolean;
//  dmyDate: TDateTime;
//  mthDate: string;
begin
  lineOK := False;
    dmyDate := DateTimeStrEval('YYYYMMDD', Date);
//    mthDate := LongMonthNames(Monthof(dmyDate));
    IF Length(Basic) > 0 then
    begin
    kadb.SetFieldVal('BASIC', - StrtoFloat(Basic));
    lineOK := True;
    end;
    IF Length(SGST) > 0 then
    begin
    kadb.SetFieldVal('SGST', - StrtoFloat(SGST));
    lineOK := True;
    end;
    IF Length(CGST) > 0 then
    begin
    kadb.SetFieldVal('CGST', - StrtoFloat(CGST));
    lineOK := True;
    end;
    IF Length(IGST) > 0 then
    begin
    kadb.SetFieldVal('IGST', - StrtoFloat(IGST));
    lineOK := True;
    end;
    if LineOK then
    begin
//      kadb.SetFieldVal('MONTH', dmyDate);
//      kadb.SetFieldVal('GSTN', VendorGSTN);
//      kadb.SetFieldVal('INVOICE_NO', InvNo);
//      kadb.SetFieldVal('INVOICE_DATE', dmyDate);
//      kadb.SetFieldVal('INVOICE_VALUE', InvAmt);
//      kadb.SetFieldVal('SUPPLIER', Vendor);
      LoadDefault;
      kadb.SetFieldVal('Tax_rate', '');
      kadb.CurrentRow := kadb.CurrentRow + 1;
      ndups := ndups + 1;
    END;

  lineOK := False;
    IF Length(Basic28) > 0 then
    begin
    kadb.SetFieldVal('BASIC', - StrtoFloat(Basic28));
    lineOK := True;
    end;
    IF Length(SGST14) > 0 then
    begin
    kadb.SetFieldVal('SGST', - StrtoFloat(SGST14));
    lineOK := True;
    end;
    IF Length(CGST14) > 0 then
    begin
    kadb.SetFieldVal('CGST', - StrtoFloat(CGST14));
    lineOK := True;
    end;
    IF Length(IGST28) > 0 then
    begin
    kadb.SetFieldVal('IGST', - StrtoFloat(IGST28));
    lineOK := True;
    end;
    if LineOK then
    begin
//      kadb.SetFieldVal('MONTH', dmyDate);
//      kadb.SetFieldVal('GSTN', VendorGSTN);
//      kadb.SetFieldVal('INVOICE_NO', InvNo);
//      kadb.SetFieldVal('INVOICE_DATE', dmyDate);
//      kadb.SetFieldVal('INVOICE_VALUE', InvAmt);
//      kadb.SetFieldVal('SUPPLIER', Vendor);
      LoadDefault;
      kadb.SetFieldVal('Tax_rate', '28');
      kadb.CurrentRow := kadb.CurrentRow + 1;
      ndups := ndups + 1;
    END;

  lineOK := False;
    IF Length(Basic18) > 0 then
    begin
    kadb.SetFieldVal('BASIC', - StrtoFloat(Basic18));
    lineOK := True;
    end;
    IF Length(SGST9) > 0 then
    begin
    kadb.SetFieldVal('SGST', - StrtoFloat(SGST9));
    lineOK := True;
    end;
    IF Length(CGST9) > 0 then
    begin
    kadb.SetFieldVal('CGST', - StrtoFloat(CGST9));
    lineOK := True;
    end;
    IF Length(IGST18) > 0 then
    begin
    kadb.SetFieldVal('IGST', - StrtoFloat(IGST18));
    lineOK := True;
    end;
    if LineOK then
    begin
//      kadb.SetFieldVal('MONTH', dmyDate);
//      kadb.SetFieldVal('GSTN', VendorGSTN);
//      kadb.SetFieldVal('INVOICE_NO', InvNo);
//      kadb.SetFieldVal('INVOICE_DATE', dmyDate);
//      kadb.SetFieldVal('INVOICE_VALUE', InvAmt);
//      kadb.SetFieldVal('SUPPLIER', Vendor);
      LoadDefault;
      kadb.SetFieldVal('Tax_rate', '18');
      kadb.CurrentRow := kadb.CurrentRow + 1;
      ndups := ndups + 1;
    END;

  lineOK := False;
    IF Length(Basic12) > 0 then
    begin
    kadb.SetFieldVal('BASIC', - StrtoFloat(Basic12));
    lineOK := True;
    end;
    IF Length(SGST6) > 0 then
    begin
    kadb.SetFieldVal('SGST', - StrtoFloat(SGST6));
    lineOK := True;
    end;
    IF Length(CGST6) > 0 then
    begin
    kadb.SetFieldVal('CGST', - StrtoFloat(CGST6));
    lineOK := True;
    end;
    IF Length(IGST12) > 0 then
    begin
    kadb.SetFieldVal('IGST', - StrtoFloat(IGST12));
    lineOK := True;
    end;
    if LineOK then
    begin
//      kadb.SetFieldVal('MONTH', dmyDate);
//      kadb.SetFieldVal('GSTN', VendorGSTN);
//      kadb.SetFieldVal('INVOICE_NO', InvNo);
//      kadb.SetFieldVal('INVOICE_DATE', dmyDate);
//      kadb.SetFieldVal('INVOICE_VALUE', InvAmt);
//      kadb.SetFieldVal('SUPPLIER', Vendor);
      LoadDefault;
      kadb.SetFieldVal('Tax_rate', '12');
      kadb.CurrentRow := kadb.CurrentRow + 1;
      ndups := ndups + 1;
    END;

  lineOK := False;
    IF Length(Basic5) > 0 then
    begin
    kadb.SetFieldVal('BASIC', - StrtoFloat(Basic5));
    lineOK := True;
    end;
    IF Length(SGST2_5) > 0 then
    begin
    kadb.SetFieldVal('SGST', - StrtoFloat(SGST2_5));
    lineOK := True;
    end;
    IF Length(CGST2_5) > 0 then
    begin
    kadb.SetFieldVal('CGST', - StrtoFloat(CGST2_5));
    lineOK := True;
    end;
    IF Length(IGST5) > 0 then
    begin
    kadb.SetFieldVal('IGST', - StrtoFloat(IGST5));
    lineOK := True;
    end;
    if LineOK then
    begin
//      kadb.SetFieldVal('MONTH', dmyDate);
//      kadb.SetFieldVal('GSTN', VendorGSTN);
//      kadb.SetFieldVal('INVOICE_NO', InvNo);
//      kadb.SetFieldVal('INVOICE_DATE', dmyDate);
//      kadb.SetFieldVal('INVOICE_VALUE', InvAmt);
//      kadb.SetFieldVal('SUPPLIER', Vendor);
      LoadDefault;
      kadb.SetFieldVal('Tax_rate', '5');
      kadb.CurrentRow := kadb.CurrentRow + 1;
      ndups := ndups + 1;
    END;

  lineOK := False;
    IF Length(Basic3) > 0 then
    begin
    kadb.SetFieldVal('BASIC', - StrtoFloat(Basic3));
    lineOK := True;
    end;
    IF Length(SGST1_5) > 0 then
    begin
    kadb.SetFieldVal('SGST', - StrtoFloat(SGST1_5));
    lineOK := True;
    end;
    IF Length(CGST1_5) > 0 then
    begin
    kadb.SetFieldVal('CGST', - StrtoFloat(CGST1_5));
    lineOK := True;
    end;
    IF Length(IGST3) > 0 then
    begin
    kadb.SetFieldVal('IGST', - StrtoFloat(IGST3));
    lineOK := True;
    end;
    if LineOK then
    begin
//      kadb.SetFieldVal('MONTH', dmyDate);
//      kadb.SetFieldVal('GSTN', VendorGSTN);
//      kadb.SetFieldVal('INVOICE_NO', InvNo);
//      kadb.SetFieldVal('INVOICE_DATE', dmyDate);
//      kadb.SetFieldVal('INVOICE_VALUE', InvAmt);
//      kadb.SetFieldVal('SUPPLIER', Vendor);
      LoadDefault;
      kadb.SetFieldVal('Tax_rate', '3');
      kadb.CurrentRow := kadb.CurrentRow + 1;
      ndups := ndups + 1;
    end;
end;

procedure TbjxLedVch4P.LoadDefault;
begin
  kadb.SetFieldVal('MONTH', dmyDate);
  kadb.SetFieldVal('GSTN', VendorGSTN);
  kadb.SetFieldVal('INVOICE_NO', InvNo);
  kadb.SetFieldVal('INVOICE_DATE', dmyDate);
  kadb.SetFieldVal('INVOICE_VALUE', InvAmt);
  kadb.SetFieldVal('SUPPLIER', Vendor);
//  kadb.SetFieldVal('Tax_rate', '');
end;

end.

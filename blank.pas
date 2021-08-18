unit blank;

interface

uses
  SysUtils, Variants, Classes,
  XLSWorkbook,
  xlstbl3,
  XmlStr_GST,
  bjXml3_1,
  Dialogs;

type
  TxlsBlank = class
  private
    { Private declarations }
  protected
    cfgn: IbjXml;
    flds: TStringList;
    kadb: TbjXLSTable;
    procedure AddWS(const xStr, ws: string);
    procedure FormatWs;
  public
    { Public declarations }
    procedure CreateSample;
    procedure CreateTally2A;
    procedure CreateRpet;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TxlsBlank.Create;
begin
  kadb := TbjXLSTable.Create;
  kadb.ToSaveFile := True;
  Cfgn := CreatebjXmlDocument;
  flds := TStringList.Create;
end;

destructor TxlsBlank.Destroy;
 begin
  flds.Free;
  kadb.Free;
 end;

procedure TxlsBlank.AddWS(const xStr, ws: string);
begin
  Cfgn.Clear;
  cfgn.LoadXML(xStr);
  kadb.SetSheet(ws);
  kadb.ParseXml(Cfgn, flds);
  flds.Add('TALLYID');
  flds.Add('REMOTEID');
  kadb.SetFields(flds, True);
  FormatWs;
  kadb.WorkSheet := nil;
end;

procedure TxlsBlank.FormatWs;
begin
  kadb.SetFieldFormat('Tax_rate', 35);
  kadb.SetFieldFormat('DATE', 14);
  kadb.SetFieldFormat('Voucher_Date', 14);
  kadb.SetFieldFormat('Invoice_Date', 14);
  kadb.SetFieldFormat('ID', 35);
  kadb.SetFieldFormat('NARRATION', 35);
  kadb.SetFieldFormat('GSTN', 35);
  kadb.SetFieldFormat('Item', 35);
  kadb.SetFieldFormat('HSN', 35);
  kadb.SetFieldFormat('Batch', 35);
  kadb.SetFieldFormat('Unit', 35);
  kadb.SetFieldFormat('Bank_Ledger', 35);
  kadb.SetFieldFormat('ChequeNo', 35);
  kadb.SetFieldFormat('Sales_Ledger', 35);
  kadb.SetFieldFormat('Purchase_Ledger', 35);
  kadb.SetFieldFormat('Bill_Ledger', 35);
  kadb.SetFieldFormat('Credit_Ledger', 35);
  kadb.SetFieldFormat('Debit_Ledger', 35);
  kadb.SetFieldFormat('LEDGER', 35);
  kadb.SetFieldFormat('Party_Ledger', 35);
  kadb.SetFieldFormat('Payment_Ledger', 35);
  kadb.SetFieldFormat('Receipt_Ledger', 35);
  kadb.SetFieldFormat('Voucher_No', 35);
  kadb.SetFieldFormat('Voucher_Ref', 35);
  kadb.SetFieldFormat('Bill Ref', 35);
  kadb.SetFieldFormat('GROUP', 35);
  kadb.SetFieldFormat('Alias', 35);
  kadb.SetFieldFormat('GSTRate', 35);
  kadb.SetFieldFormat('SubGroup', 35);
  kadb.SetFieldFormat('Godown', 35);
  kadb.SetFieldFormat('Category', 35);
end;

procedure TxlsBlank.CreateSample;
begin
  kadb.SetXLSFile('');

  AddWS(CONTRA, 'Contra');
  AddWS(PYMT, 'Payment');
  AddWS(RCPT, 'Receipt');
  AddWS(GSTSALE, 'Sales');
  AddWS(GSTPURC, 'Purchase');
  AddWS(JRNL, 'Journal');
  AddWS(BANK, 'Bank');
  AddWS(DAYBOOK, 'Daybook');
  AddWS(MYSALE, 'MySales');
  AddWS(MYPURC, 'MyPurchase');
  AddWS(CNOTE, 'CNOTE');
  AddWS(DNOTE, 'DNOTE');
  AddWS(SBILL, 'SBill');
  AddWS(ACCMASTER, 'LMaster');
  AddWS(INVMASTER, 'IMaster');
  kadb.XL.Workbook.Sheets.DeleteByName('Sheet1');
//  MessageDlg('Empty Tally.xls created', mtInformation, [mbOK], 0);
  if kadb.ToSaveFile then
    kadb.SaveAs('.\Data\Tally.xls');
end;

procedure TxlsBlank.CreateTally2A;
begin
//  kadb.SetXLSFile('.\Data\Tally-2A.xls');
  kadb.SetXLSFile('');

  kadb.SetSheet('ONLINE');
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
  kadb.SetFields(flds, True);

  kadb.SetSheet('OFFLINE');
  kadb.SetFields(flds, True);

  kadb.SetSheet('NOINPUT');
  kadb.SetFields(flds, True);
  flds.Clear;
//  FormatWs;
//  kadb.WorkSheet := nil;

  kadb.XL.Workbook.Sheets.DeleteByName('Sheet1');
//  essageDlg('Empty Tally.xls created', mtInformation, [mbOK], 0);
if kadb.ToSaveFile then
if FileExists('.\Data\Tally-2A.xls') then
begin
if (MessageDlg('Overwrite Tally-2A.xls ?', mtConfirmation,  [mbYes, mbNo], 0) <>  mrNo) then
    kadb.SaveAs('.\Data\Tally-2A.xls');
end
else
    kadb.SaveAs('.\Data\Tally-2A.xls');
end;

procedure TxlsBlank.CreateRpet;
begin
  kadb.SetXLSFile('');

  kadb.SetSheet('REPEET');
  flds.Clear;
  flds.Add('GSTN');
  flds.Add('GSTN');
  flds.Add('Ledger_1');
  flds.Add('Ledger_2');
  flds.Add('Ledger_3');
  kadb.SetFields(flds, True);

  flds.Clear;

  kadb.XL.Workbook.Sheets.DeleteByName('Sheet1');
  if kadb.ToSaveFile then
    kadb.SaveAs('.\Data\RpetGSTN.xls');
end;

end.


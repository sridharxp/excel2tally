unit blank;

interface

uses
  SysUtils, Variants, Classes,
  XLSWorkbook,
  xlstbl,
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
//    dbName: string;
    procedure Execute;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TxlsBlank.Create;
begin
  kadb := TbjXLSTable.Create;
  kadb.NewFile('.\Data\Tally.xls');
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
  kadb.SetFields(flds, True);
  FormatWs;
  kadb.WorkSheet := nil;
end;

procedure TxlsBlank.FormatWs;
begin
  kadb.SetFieldFormat('Tax_rate', 35);
  kadb.SetFieldFormat('DATE', 14);
  kadb.SetFieldFormat('Voucher Date', 14);
  kadb.SetFieldFormat('Invoice_Date', 14);
  kadb.SetFieldFormat('ID', 35);
  kadb.SetFieldFormat('NARRATION', 35);
  kadb.SetFieldFormat('GSTN', 35);
  kadb.SetFieldFormat('Item', 35);
  kadb.SetFieldFormat('HSN', 35);
  kadb.SetFieldFormat('Unit', 35);
  kadb.SetFieldFormat('Bank Ledger', 35);
  kadb.SetFieldFormat('Sales_Ledger', 35);
  kadb.SetFieldFormat('Purchase_Ledger', 35);
  kadb.SetFieldFormat('Bill_Ledger', 35);
  kadb.SetFieldFormat('Credit Ledger', 35);
  kadb.SetFieldFormat('Debit Ledger', 35);
  kadb.SetFieldFormat('LEDGER', 35);
  kadb.SetFieldFormat('Party Ledger', 35);
  kadb.SetFieldFormat('Payment Ledger', 35);
  kadb.SetFieldFormat('Receipt Ledger', 35);
  kadb.SetFieldFormat('Voucher Ref', 35);
  kadb.SetFieldFormat('Bill Ref', 35);
  kadb.SetFieldFormat('GROUP', 35);
  kadb.SetFieldFormat('Alias', 35);
  kadb.SetFieldFormat('GSTRate', 35);
  kadb.SetFieldFormat('SubGroup', 35);
  kadb.SetFieldFormat('Godown', 35);
  kadb.SetFieldFormat('Category', 35);
end;

procedure TxlsBlank.ExEcute;
begin
  AddWS(BANK, 'Bank');
  AddWS(MYSALE, 'MySales');
  AddWS(MYPURC, 'MyPurchase');
  AddWS(GSTSALE, 'Sales');
  AddWS(GSTPURC, 'Purchase');
  AddWS(SBILL, 'SBill');
  AddWS(PYMT, 'Payment');
  AddWS(RCPT, 'Receipt');
  AddWS(JRNL, 'Journal');
  AddWS(CONTRA, 'Contra');
  AddWS(DAYBOOK, 'Daybook');
  AddWS(ACCMASTER, 'LMaster');
  AddWS(INVMASTER, 'IMaster');
  AddWS(CNOTE, 'CNOTE');
  AddWS(DNOTE, 'DNOTE');
  kadb.XL.Workbook.Sheets.DeleteByName('Sheet1');
  MessageDlg('Empty Tally.xls created', mtInformation, [mbOK], 0);
  if kadb.ToSaveFile then
    kadb.XL.SaveAs('.\Data\Tally.xls');
  kadb.ToSaveFile := False;
end;

end.


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
  public
    { Public declarations }
    dbName: string;
    procedure Execute;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TxlsBlank.Create;
begin
  kadb := TbjXLSTable.Create;
  dbName := '.\Data\Tally.xls';
  kadb.XLSFileName := 'Sample.xls';
  kadb.ToSaveFile := True;
  kadb.ToParseSorted := False;
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
  kadb.WorkSheet := nil;
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
  kadb.XL.Workbook.Sheets.DeleteByName('Sheet1');
  MessageDlg('Empty Tally.xls created'+ #10 + 'Shuffle columns to your convenience', mtInformation, [mbOK], 0);
  if kadb.ToSaveFile then
      kadb.XL.SaveAs(dbName);
end;

end.


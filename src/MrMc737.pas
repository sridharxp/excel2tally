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
{
This version processes Inventory data

IsMultiRow - id and single Ledger, Debit + Credit
Optional - Default Ledger

IsMultiCol - Many Ledger, Many Amount
Amount info is now nested within ledger node
optional -  id,
            Default Ledger or
Dr or Cr Col empty)  Single Ledger + Debit + Credit + Default Ledger Col or Name
}
{
File Type (extension)                                             Extended Properties
---------------------------------------------------------------------------------------------
Excel 97-2003 Workbook (.xls)                                  "Excel 8.0"
Excel Workbook (.xlsx)                             "Excel 12.0 Xml"
Excel Macro-enabled workbook (.xlsm)      "Excel 12.0 Macro"
Excel Non-XML binary workbook (.xlsb)      "Excel 12.0"
}
unit MrMc737;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB,
  xlstbl3,
  XlExp,
  Math,
  Client,
  ZS733,
  PClientFns,
  DateFns,
  XLSWorkbook,
  bjXml3_1,
  Repet,
  VchLib,
  Dialogs;

{$DEFINE xlstbl}

Const
  PGLEN = 20;
  COLUMNLIMIT = 64;
  TallyAmtPicture = '############.##';

type
  Tfnupdate = procedure(const msg: string);


{
Declared refers to Xml (rule) Object
Defined refers to Worksheet Template;
defines Mandatory or Optional column
}
TbjDSLParser = class(TinterfacedObject, IbjDSLParser)
  { Private declarations }
  private
    FIsMListDeclared: Boolean;
    FIsVListDeclared: Boolean;
    FIsIListDeclared: Boolean;
  protected
{ Xml related }
    cfgn: IbjXml;
    cfg: IbjXml;
    xcfg: IbjXml;
{ Default Values }
    DiDateValue: string;
    DiTypeValue: string;
    DiLedgerValue: array [1..COLUMNLIMIT] of String;
    DiRoundOff: string;
    RoundOffCol: string;

    { Public declarations }
    RoundOffGroup: string;
    RoundOffGroupCol: string;
    URoundOffAmountColName: string;
    IsRoundOffAmountColDeclared: Boolean;
{    Amt: array [1..COLUMNLIMIT] of double; }

{ COLUMNLIMIT - To limit looping  }
    IsLedgerDeclared: array [1..COLUMNLIMIT] of boolean;
    IsAmtDeclared: array [1..COLUMNLIMIT] of boolean;
{ Colnumn Variables used in Xml }
    LedgerTag: string;
    AmountType: array [1..COLUMNLIMIT] of string;
    AmountCols: array [1..COLUMNLIMIT] of integer;
    Amount2Type: array [1..COLUMNLIMIT] of string;
    Amount3Type: array [1..COLUMNLIMIT] of string;
{ User Colnumn Names }
    ULedgerName: array [1..COLUMNLIMIT] of string;
    UAmountName: array [1..COLUMNLIMIT] of string;
    UAmount2Name: array [1..COLUMNLIMIT] of string;
  { Used for Row Ledgers Triggered only when alias is defined in template}
    UMstGroupName: string;
    LedgerGroup: array [1..COLUMNLIMIT] of string;
{ +1 for RoundOff }
    LedgerDict: array [1..COLUMNLIMIT + 1] of TList;
    IsGroupDeclared: array [1..COLUMNLIMIT + 1] of boolean;
    IsGSTNDeclared: array [1..COLUMNLIMIT + 1] of boolean;
    UGSTNName: array [1..COLUMNLIMIT + 1] of string;
    UGroupName: array [1..COLUMNLIMIT ] of string;
    UAliasName: string;
    UMailingName: string;
    UGodownName: string;
    UCategoryName: string;
    USubGroupName: string;
    UDateName: string;
    UVTypeName: string;
    UNarrationName: string;
    UVchNoColName: string;
    UVoucherRefName: string;
    UVoucherDateName: string;
    UBillRefName: string;
    UOBalName: string;
    UORateName: string;
    UMRPRateName: string;
    UGSTRateName: string;
    UAddressName: string;
    UAddress1Name: string;
    UAddress2Name: string;
    UAddress3Name: string;
    UAddress4Name: string;
    UPincodeName: string;
    UStateName: string;
    UMobileName: string;
    UeMailName: string;
    UTallyIDName: string;
    URemoteIDName: string;
    UChequeNoName: string;

    UInItemName: string;
    UOutItemName: string;
    UInUnitName: string;
    UOutUnitName: string;
    UInQtyName: string;
    UOutQtyName: string;
    UInRateName: string;
    UOutRateName: string;
    UInAmtName: string;
    UOutAmtName: string;
    UInGodownName: string;
    UOutGodownName: string;

    UAssessableName: array [1..COLUMNLIMIT] of string;

    InventoryTag: string;
    UItemName: string;
    UHSNName: string;
    UBatchName: string;
    UOBatchName: string;
    UUserDescName: string;
    UUnitName: string;
    UQtyName: string;
    URateName: string;
    ToCheckInvCols: boolean;
    IsAddressDefined: boolean;
    IsAddress1Defined: boolean;
    IsAddress2Defined: boolean;
    IsAddress3Defined: boolean;
    IsAddress4Defined: boolean;
    IsPincodeDefined: boolean;
    IsStateDefined: boolean;
    IsLedgerPhoneDefined: boolean;
    IsOBalDefined: boolean;
    IsORateDefined: boolean;
    IsMRPRateDefined: boolean;
    IsGSTRateDefined: boolean;
    IsMobileDefined: boolean;
    IseMailDefined: boolean;
    IsNarrationDefined: boolean;
    IsChequeNoDefined: boolean;
    IsTallyIdDefined: boolean;
    IsRemoteIDDefined: boolean;
    IsRoundOffGroupColDefined: boolean;
    UidName: string;
    IsIDGenerated: Boolean;
    IsDaybook: Boolean;
    IsBank: boolean;
    IsJournal: boolean;
    IsReference: boolean;
    DrAmtCol: string;
    CrAmtCol: string;
    DrAmtColType: string;
    CrAmtColType: string;
    IsCrDrAmtColsDefined: Boolean;
{ Xls related }
    IsIdDefined: boolean;
    IsDateDefined: boolean;
    IsVchNoDefined: boolean;
    IsVTypeDefined: boolean;
    IsVoucherRefDefined: boolean;
    IsVoucherDateDefined: boolean;
    IsBillRefDefined: boolean;
    IsItemDefined: boolean;
    IsHSNDefined: boolean;
    IsBatchDefined: boolean;
    IsOBatchDefined: boolean;
    IsUserDescDefined: boolean;
    IsUnitDefined: boolean;
    IsAliasDefined: Boolean;
    IsMailingNameDefined: Boolean;
    IsGodownDefined: Boolean;
    IsCategoryDefined: Boolean;
    IsGroupDefined: Boolean;
    IsSubGroupDefined: Boolean;
    IsInItemDefined: boolean;
    IsOutItemDefined: boolean;
    IsLedgerDefined: array [1..COLUMNLIMIT] of boolean;
    IsRoundOffColDefined: boolean;
    IsRoundOffAmountColDefined: boolean;
    IsAmtDefined: array [1..COLUMNLIMIT] of boolean;
    IsGSTNDefined: array [1..COLUMNLIMIT + 1] of boolean;
    IsInvDefined: array [1..COLUMNLIMIT + 1] of boolean;
    IsAssessableDefined: array [1..COLUMNLIMIT] of boolean;
  public
    XmlStr: string;
    IsMultiRowVoucher: boolean;
    IsMultiColumnVoucher: boolean;
    DefGroup: string;
    dbName: string;
    TableName: string;
    kadb: TbjXLSTable;
    FUpdate: TfnUpdate;
    procedure DeclareColName;
    procedure CheckColName;
    procedure CheckColumn(const colname: string);
    constructor Create;
    destructor Destroy; override;
    property IsMListDeclared: Boolean read FIsMListDeclared write FIsMListDeclared;
    property IsVListDeclared: Boolean read FIsVListDeclared write FIsVListDeclared;
    property IsIListDeclared: Boolean read FIsIListDeclared write FIsIListDeclared;
end;

TbjMrMc = class(TinterfacedObject, IbjXlExp, IbjMrMc)
  private
    { Private declarations }
    FXmlstr: string;
    FTableName: string;
    FToLog: boolean;
    FdynPgLen: integer;
    FVchType: string;
    FWSType: string;
    FIsExpItemMst: Boolean;
    FIsCheckLedMst: Boolean;
    FFirm: string;
    FFirmGUID: string;
    FHost: string;
    FIsGstSetting: Boolean;
    FIsPostto1stLedgerwithGSTNon: boolean;
    FIsUniqueVchRefon: boolean;
    FGSTLedType: string;
    FVchAction: string;
    FRemoteID: string;
    FProcessedCount: integer;
    FSCount: integer;
  protected
    missingledgers: Integer;
    IDstr: string;
    UIdint: integer;
    IsIdOnlyChecked: boolean;
{ Non Default }
    NarrationColValue: string;
    ChequeNoColValue: string;
    Amt: array [1..COLUMNLIMIT] of currency;

{ if exosts value if not di}
    DateColValue: string;
    TypeColValue: string;

    notoskip: integer;
//    ProcessedCount: integer;
    VTotal: currency;
    IsInventoryAssigned: Boolean;
    RoundOffName: string;
    RoundOffActual: Currency;
    StartTime, EndTime, Elapsed: double;
    Hrs, Mins, Secs, Msecs: word;
    ToAutoCreateMst: boolean;
    AskAgainToAutoCreateMst: boolean;
    AskedOnce: boolean;
    MstExp: TbjMstExp;
    VchExp: TbjVchExp;
    procedure OpenFile;
    procedure GenerateID;
    procedure CheckLedMst;
    procedure ExpItemMst;
    procedure ExpStkJrnl;
    procedure CreateRowLedger;
    procedure CreateColLedger;
    procedure CreateItem(const level: integer);
    procedure NewIdLine;
    procedure ProcessMaster;
    procedure Process;
    procedure ProcessRow;
    procedure ProcessCol(const level: integer);
    procedure ProcessItem(const level: integer; InvAmt: currency);
    function IsIDChanged: boolean;
    procedure GetDefaults;
    procedure WriteStatus;
    procedure WriteStock;
    function GetLedger(const level: integer): string;
    function GetRoundOffName: string;
    function GetAmt(const level: integer): currency;
    function IsMoreColumn(const level: integer): boolean;
    procedure SetFirm(const aFirm: string);
    procedure SetFirmGUID(const aGUID: string);
    procedure SetHost(const aHost: string);
    function GetGSTState(const aGSTN: string): string;
    function GETDictToken(const ctr: integer): string;
    function GETDictValue(const ctr: integer): string;
    procedure Filter(aFailure: integer);
    procedure FormatCols;
    procedure UnFilter;
    procedure CreateGSTLedger;
    procedure CreateDefLedger;
    procedure SetGSTSetting;
    procedure SetGstLedSetting(const doit: boolean);
    procedure SetXmlstr(const aStr: string);
    procedure SetPostto1stLedgerwithGSTN(const aChoice: boolean);
    procedure SetIsUniqueVchRef(const aChoice: boolean);
    procedure SetGSTLedType(const aType: string);
    procedure SetVchAction(const aAction: string);
  public
    { Public declarations }

    dbName: string;
    ReportFileName: string;
    XmlFile: string;
    FileFmt: string;
    IsDateCheck: boolean;
//    SCount: integer;
    FUpdate: TfnUpdate;

  
    Tally_11: boolean;
    UdefStateName: string;
    RoundOffMethod: string;
{    ToCreateMasters: boolean; }
    Env: TbjEnv;
    dsl: TbjDSLParser;
    kadb: TbjXLSTable;
    RpetObj: TRpetGSTN;
    IsMinus: boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
//  published
{ Logging is optional }
    property ToLog: boolean read FToLog write FToLog;
{ Auto Create Master is optional }
    property VchType: string read FVchType write FVchType;
    property WSType: string read FWSType write FWSType;
    property IsCheckLedMst: Boolean read FIsCheckLedMst write FIsCheckLedMst;
    property IsExpItemMst: Boolean read FIsExpItemMst write FIsExpItemMst;
    property Firm: string read FFirm write setFirm;
    PROPERTY Host: string read FHost write SetHost;
    property IsGstSetting: boolean write SetGstLedSetting;
    property XmlStr: string write SetXmlstr;
    property TableName: string read FTableName write FTableName;
    property IsPostto1stLedgerwithGSTNon: boolean read FIsPostto1stLedgerwithGSTNon write SetPostto1stLedgerwithGSTN;
    property FirmGUID: string read FFirmGUID write SetFirmGUID;
  	property IsUniqueVchRefon: boolean write SetIsUniqueVchRef;
    property GSTLedType: string read FGSTLedType write SetGSTLedType;
    property VchAction: string read FVchAction write SetVchAction;
    property RemoteID: string read FRemoteID write FRemoteID;
    property ProcessedCount: integer read FProcessedCount;
    property SCount: integer read FSCount;
  end;

{ Level refers to TokenCol }
{ Token Column can be separate from any Ledger column }
  TDict = Record
    TokenCol: string;
    Token: string;
    Value: String;
  end;
  pDict = ^TDict;

function RoundCurr(const Value: Currency): Currency;

implementation

uses
  DM_UF;

constructor TbjDSLParser.Create;
var
  i: integer;
begin
  Inherited;
  Cfgn := CreatebjXmlDocument;
  UIdName := 'ID';
  LedgerTag := 'LEDGER';
  for i:= 1 to COLUMNLIMIT do
    ULedgerName[i] := 'LEDGER';
  for i:= 1 to COLUMNLIMIT do
    UAmountName[i] := 'AMOUNT';
  for i:= 1 to COLUMNLIMIT do
    AmountType[i] := 'Dr';
  UDateName := 'DATE';
  UVTypeName := 'VTYPE';
  UNarrationName := 'NARRATION';
  UChequeNoName := 'ChequeNo';
  UVoucherRefName := 'VoucherRef';
  UVoucherDateName := 'VoucherDate';
  UVchNoColName := 'VoucherNo';
  UBillRefName := 'BillRef';
  inventoryTag := 'INVENTORY';
  UItemName := 'Item';
  UHSNName := 'HSN';
  UBatchName := 'BATCH';
  UUserDescName := 'UserDesc';
  UUnitName := 'Unit';
  UQtyName := 'Qty';
  URateName := 'Rate';
  UAliasName := 'Alias';
  UMailingName := 'PartNo';
  UGodownName := 'GODOWN';
  UCategoryName := 'Category';
  USubGroupName := 'SubGroup';
  uOBalName := 'O_BALANCE';
  uOBatchName := 'O_BATCH';
  UORateName := 'O_RATE';
  UMRPRateName := 'MRPRATE';
  UGSTRateName := 'GSTRate';
  UAddressName := 'ADDRESS';
  UAddress1Name := 'ADDRESS1';
  UAddress2Name := 'ADDRESS2';
  UAddress3Name := 'ADDRESS3';
  UAddress4Name := 'ADDRESS4';
  UPincodeName := 'PINCODE';
  UStateName := 'STATE';
  UMobileName := 'Mobile';
  UeMailName := 'EMail';
  UTallyIDName := 'TALLYID';
  URemoteIDName := 'REMOTEID';
  UMstGroupName := 'GROUP';
  UInItemName := 'DrITEM';
  UOutItemName := 'CrITEM';
  UInUnitName := 'DrUNIT';
  UOutUnitName := 'CrUNIT';
  UInQtyName := 'DrQTY';
  UOutQtyName := 'CrQTY';
  UInRateName := 'DrRATE';
  UOutRateName := 'CrRATE';
  UInAmtName := 'DrAMOUNT';
  UOutAmtName := 'CrAMOUNT';
  UInGodownName := 'DrGODOWN';
  UOutGodownName := 'CrGODOWN';
  URoundOffAmountColName := 'Invoice_Amt';
end;

destructor TbjDSLParser.Destroy;
var
  i, j: integer;
  ditem: pDict;
begin
{ +1 for RoundOff }
  for i:= 1 to COLUMNLIMIT+1 do
    if Assigned(LedgerDict[i]) then
    begin
{ TList finalizes items }

    for j := 0 to LedgerDict[i].Count-1 do
    begin
      ditem := LedgerDict[i].Items[j];
      ditem^.TokenCol := '';
      ditem^.Token := '';
      ditem^.Value := '';
      Dispose(ditem);
    end;

  LedgerDict[i].Clear;
  LedgerDict[i].Free;
  end;
  cfgn.Clear;
  Inherited;
end;

procedure TbjDSLParser.DeclareColName;
var
  DataFolder: string;
  Database: string;
  VList: string;
  MList: string;
  IList: string;
  str: string;
  i: integer;
  dcfg, xxcfg: IbjXml;
  dItem: pDict;
begin
  FUpdate('Processing Xml');
  cfgn.LoadXML(XmlStr);
  cfg := Cfgn.SearchForTag(nil, 'Voucher');
  if not Assigned(cfg) then
    raise Exception.Create('Voucher Configuration not Found');
  xcfg := Cfg.SearchForTag(nil, 'Data');
  DataFolder := xcfg.GetChildContent('Folder');
  Database := xcfg.GetChildContent('Database');
  if Length(DataFolder + Database) > 0 then
    dbName := DataFolder + Database;
  VList  := xcfg.GetChildContent('VoucherList');
  if (Length(Vlist) > 0) then
  begin
    if Length(TableName) = 0 then
      TableName := VList;
    IsVListDeclared := True;
  end;
  MList  := xcfg.GetChildContent('MasterList');
  if (Length(MList) > 0) then
  begin
    if Length(TableName) = 0 then
      TableName := MList;
    IsMListDeclared := True;
  end;
  IList  := xcfg.GetChildContent('StkVchList');
  if (Length(IList) > 0) then
  begin
    if Length(TableName) = 0 then
      TableName := IList;
    IsIListDeclared := True;
  end;
{
AutoCreateMst affects default group only
}
  DefGroup := xcfg.GetChildContent('DefaultGroup');
{ Round of tag moved from Ledger to Data }
  str := xcfg.GetChildContent('IsMultiRow');
  if  str = 'Yes' then
    IsMultiRowVoucher := True;
  str := xcfg.GetChildContent('IsMultiColumn');
  if  str = 'Yes' then
    IsMultiColumnVoucher := True;

  xCfg := Cfg.SearchForTag(nil, 'RoundOff');
  if Assigned(xCfg) then
  begin

    dCfg := xcfg.SearchForTag(nil, 'Dict');
    if Assigned(dCfg) then
    begin
      LedgerDict[COLUMNLIMIT+1] := TList.Create;
      while Assigned(dcfg) do
      begin
        ditem := new (pDict);
        pDict(dItem)^.TokenCol := dcfg.GetChildContent('TokenCol');
        str := dcfg.GetChildContent('Token');
        pDict(dItem)^.Token := str;
        str := dcfg.GetChildContent('Value');
        pDict(dItem)^.Value := str;
        LedgerDict[COLUMNLIMIT+1].Add(Ditem);
        dCfg := xcfg.SearchForTag(dcfg, 'Dict');
      end;
    end;

    str := xCfg.GetChildContent(UAliasName);
    if Length(str) > 0 then
      RoundOffCol := str;
    DiRoundOff := xCfg.GetChildContent('Default');
    xxCfg := xcfg.SearchForTag(nil, 'Group');
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        RoundOffGroupCol := str;
      RoundOffGroup := xxCfg.GetChildContent('Default');
    end;

    xxCfg := xcfg.SearchForTag(nil, 'GSTN');
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      UGSTNName[COLUMNLIMIT+1] := str;
      if Length(str) > 0 then
        IsGSTNDeclared[COLUMNLIMIT+1] := True;
    end;
    xxCfg := xcfg.SearchForTag(nil, 'AmtCol');
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      URoundOffAmountColName := str;
      if Length(str) > 0 then
        IsRoundOffAmountColDeclared := True;
    end;
  end;

  xCfg := Cfg.SearchForTag(nil, UVchNoColName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent(UAliasName);
    if Length(str) > 0 then
      UVchNoColName := str;
  end;

  xCfg := Cfg.SearchForTag(nil, UDateName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent(UAliasName);
    if Length(str) > 0 then
    begin
      UDateName := str;
    end;
    DiDateValue := xCfg.GetChildContent('Default');
  end;

  xCfg := Cfg.SearchForTag(nil, UVTypeName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent(UAliasName);
    if Length(str) > 0 then
      UVTypeName := str;
    DiTypeValue := xcfg.GetChildContent('Default');
  end;

  xCfg := Cfg.SearchForTag(nil, 'CrAmtCol');
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent(UAliasName);
    if Length(str) <> 0 then
    begin
      CrAmtCol := str;
      IsCrDrAmtColsDefined := True;
    end;
    str := xCfg.GetChildContent('Type');
    if Length(str) > 0 then
      CrAmtColType := str;
  end;

  xCfg := Cfg.SearchForTag(nil, 'DrAmtCol');
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent(UAliasName);
    if Length(str) <> 0 then
    begin
      DrAmtCol := str;
      IsCrDrAmtColsDefined := True;
    end;
    str := xCfg.GetChildContent('Type');
    if Length(str) > 0 then
      DrAmtColType := str;
  end;

  if IsCrDrAmtColsDefined  then
  begin
    IsAmtDeclared[1] := True;
    IsAmtDeclared[2] := True;
  end;

  xCfg := Cfg.SearchForTag(nil, UNarrationName);
  if Assigned(xCfg) then
  begin
    xxCfg := xCfg.SearchForTag(nil, UAliasName);
    if xxCfg <> nil then
    begin
      str := xxCfg.GetContent;
      if Length(str) > 0 then
      begin
        UNarrationName  := str;
      end;
    end;
  end;

  xCfg := Cfg.SearchForTag(nil, UIdName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent(UAliasName);
    if Length(str) > 0 then
    begin
      UIdName  := str;
    end;
    str := xCfg.GetChildContent('IsGenerated');
    if str = 'Yes' then
      IsIDGenerated  := True;
    str := xCfg.GetChildContent('IsDaybook');
    if str = 'Yes' then
      IsDaybook  := True;
    str := xCfg.GetChildContent('IsBank');
    if str = 'Yes' then
      IsBank  := True;
    str := xCfg.GetChildContent('IsJournal');
    if str = 'Yes' then
      IsJournal  := True;
  end;

  xCfg := cfg.SearchForTag(nil, UVoucherRefName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent(UAliasName);
    if Length(str) > 0 then
    begin
      UVoucherRefName := str;
    end;
    str := '';
    str := xCfg.GetChildContent('IsReference');
    if str = 'Yes' then
    begin
      IsReference := True;
    end;
  end;

  xCfg := cfg.SearchForTag(nil, 'Bill Ref');
  if Assigned(xCfg) then
  begin
    str := xCfg.GetContent;
    if Length(str) > 0 then
    begin
      UBillRefName := str;
    end;
  end;

  xCfg := Cfg.SearchForTag(nil, UChequeNoName);
  if Assigned(xCfg) then
  begin
    xxCfg := xCfg.SearchForTag(nil, UAliasName);
    if xxCfg <> nil then
    begin
      str := xxCfg.GetContent;
      if Length(str) > 0 then
        UChequeNoName  := str;
    end;
  end;

  xCfg := nil;
  for i := 1 to COLUMNLIMIT do
  begin
    xCfg := Cfg.SearchForTag(xCfg, LedgerTag);
    if not Assigned(xCfg) then
      break;
    if Assigned(xCfg) then
    begin
      DiLedgerValue[i] := xcfg.GetChildContent('Default');
      if Length(DiLedgerValue[i]) > 0 then
        IsLedgerDeclared[i] := True;
    end;

    str := '';
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(Str) > 0 then
      begin
        ULedgerName[i] := str;
        IsLedgerDeclared[i] := True;
      end;
    end;
    if Assigned(xCfg) then
    begin
      xxCfg := xcfg.SearchForTag(nil, 'Group');
      if Assigned(xxCfg) then
      begin
{
Todo
}
        LedgerGroup[i] := xxCfg.GetContent;
        if Length(LedgerGroup[i]) = 0 then
          LedgerGroup[i] := xxCfg.GetChildContent('Default');

        str := xxCfg.GetChildContent(UAliasName);
        UGroupName[i] := str;
        if Length(str) > 0 then
          IsGroupDeclared[i] := True;
      end;

      xxCfg := xcfg.SearchForTag(nil, 'GSTN');
      if Assigned(xxCfg) then
      begin
        str := xxCfg.GetContent;
        UGSTNName[i] := str;
        if Length(str) > 0 then
          IsGSTNDeclared[i] := True;
      end;
      xxCfg := xcfg.SearchForTag(nil, 'IsInvCol');
      if Assigned(xxCfg) then
      begin
        str := xxCfg.GetContent;
        if str = 'Yes' then
        begin
          IsInvDefined[i] := True;
          ToCheckInvCols := True;
        end;
      end;
    end;

    if Assigned(xCfg) then
    begin
      UAssessableName[i] := xCfg.GetChildContent('Assessable');
      if Length(UAssessableName[i]) > 0 then
      IsAssessableDefined[i] := True;
    end;

    if Assigned(xCfg) then
    begin
      xxCfg := xcfg.SearchForTag(nil, 'AmtCol');
      if Assigned(xxCfg) then
      begin
        str := xxCfg.GetChildContent(UAliasName);
        UAmountName[i] := str;
        if Length(str) > 0 then
        begin
          IsAmtDeclared[i] := True;
          AmountCols[i] := AmountCols[i] + 1;
        end;
        AmountType[i] := xxCfg.GetChildContent('Type');
        if (AmountType[i] <> 'Cr') and (AmountType[i] <> 'Dr') then
          AmountType[i] := 'Cr';
{ Default Ledger Name thr user defined value in Xml }
        if xxCfg.GetChildContent('IsLedgerName') = 'Yes' then
        begin
          IsLedgerDeclared[i] := True;
          DiLedgerValue[i] := str;
{ For Ledger without Alias }
          str := xxCfg.GetChildContent('Group');
          if Length(str) > 0 then
            LedgerGroup[i] := str;
        end;
{ Unused Feature }
{ For Combining two Column Amounts }
        if Assigned(xxCfg) then
        begin
          xxCfg := xcfg.SearchForTag(xxcfg, 'AmtCol');
          if Assigned(xxCfg) then
          begin
            UAmount2Name[i] := xxCfg.GetChildContent(UAliasName);
            AmountCols[i] := AmountCols[i] + 1;
            Amount2Type[i] := xxCfg.GetChildContent('Type');
            if Length(Amount2Type[i]) = 0 then
              Amount2Type[i] := AmountType[i];
          end;
        end
      end;
    end;

    if Assigned(xCfg) then
    begin
      dCfg := xcfg.SearchForTag(nil, 'Dict');
      if Assigned(dCfg) then
      begin
        LedgerDict[i] := TList.Create;
        while Assigned(dcfg) do
        begin
          ditem := New (pDict);
          pDict(dItem)^.TokenCol := dcfg.GetChildContent('TokenCol');
          str := dcfg.GetChildContent('Token');
          pDict(dItem)^.Token := str;
          str := dcfg.GetChildContent('Value');
          pDict(dItem)^.Value := str;
          LedgerDict[i].Add(Ditem);
          dCfg := xcfg.SearchForTag(dcfg, 'Dict');
        end;
        IsLedgerDeclared[i] := True;
      end;
    end;
  end;

  xCfg := Cfg.SearchForTag(nil, InventoryTag);
  if Assigned(xcfg) then
  begin
    xxCfg := xCfg.SearchForTag(nil, UItemName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UItemName := str;
    end;

    xxCfg := xcfg.SearchForTag(nil, UUnitName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
      begin
        UUnitName := str;
      end;
    end;

    xxCfg := xCfg.SearchForTag(nil, UQtyName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UQtyName := str;
    end;

    xxCfg := xCfg.SearchForTag(nil, URateName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        URateName := str;
    end;

    xxCfg := xCfg.SearchForTag(nil, UBatchName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UBatchName := str;
    end;

    xxCfg := xCfg.SearchForTag(nil, UUserDescName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UUserDescName := str;
    end;
    xxCfg := xCfg.SearchForTag(nil, UGSTRateName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UGSTRateName := str;
    end;
  end;
  if IsMListDeclared then
  begin
    xCfg := Cfg.SearchForTag(nil, UOBalName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UOBalName := str;
    end;

    xxCfg := xCfg.SearchForTag(nil, UoBatchName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UoBatchName := str;
    end;

    xCfg := Cfg.SearchForTag(nil, UORateName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UORateName := str;
    end;

    xCfg := Cfg.SearchForTag(nil, UMRPRateName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UMRPRateName := str;
    end;

    xCfg := Cfg.SearchForTag(nil, UGSTRateName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UGSTRateName := str;
    end;

    xCfg := Cfg.SearchForTag(nil, UGodownName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UGodownName := str;
    end;

    xCfg := Cfg.SearchForTag(nil, UCategoryName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UCategoryName := str;
    end;

    xCfg := Cfg.SearchForTag(nil, USubGroupName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        USubGroupName := str;
    end;

    xCfg := Cfg.SearchForTag(nil, UAddressName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UAddressName := str;
    end;

    xCfg := Cfg.SearchForTag(nil, UAddress1Name);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UAddress1Name := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UAddress2Name);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UAddress2Name := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UAddress3Name);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UAddress3Name := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UAddress4Name);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UAddress4Name := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UPincodeName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UPincodeName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UStateName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UStateName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UMobileName);
    if Assigned(xCfg) then
    begin
      xxCfg := xCfg.SearchForTag(nil, UAliasName);
      if xxCfg <> nil then
      begin
        str := xxCfg.GetContent;
        if Length(str) > 0 then
          UMobileName  := str;
      end;
    end;

    xCfg := Cfg.SearchForTag(nil, UeMailName);
    if Assigned(xCfg) then
    begin
    xxCfg := xCfg.SearchForTag(nil, UAliasName);
    if xxCfg <> nil then
    begin
      str := xxCfg.GetContent;
      if Length(str) > 0 then
        UeMailName  := str;
      end;
    end;

  end;
  if IsIListDeclared then
  begin
    xCfg := Cfg.SearchForTag(nil, UInItemName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UInItemName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UOutItemName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UOutItemName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UInUnitName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UInUnitName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UOutUnitName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UOutUnitName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UInQtyName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UInQtyName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UOutQtyName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UOutQtyName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UInRateName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UInRateName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UOutRateName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UOutRateName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UInAmtName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UInAmtName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UOutAmtName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UOutAmtName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UInGodownName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UInGodownName := str;
    end;
    xCfg := Cfg.SearchForTag(nil, UOutGodownName);
    if Assigned(xCfg) then
    begin
      str := xCfg.GetChildContent(UAliasName);
      if Length(str) > 0 then
        UOutGodownName := str;
    end;
  end;

//Shifted from ChckcolNames as this is Xml file specific
{ If Ledger is definded corresponding amount column should be defined }
{ gaps should not exist }
  for i := 1 to COLUMNLIMIT do
  begin
    if IsLedgerDeclared[i] then
    begin
      if IsLedgerDeclared[i+1] then
         if not IsAmtDeclared[i] then
           raise Exception.Create(UAmountName[i] + ' Column is required');
    end;
  end;

{ Mandtory Column }
  if IsVListDeclared then
  if not IsLedgerDeclared[1] then
    raise Exception.Create(ULedgerName[1] + ' Column is required');
end;

{ Validation of Table Columns in Excel
  Creation of Default Ledgers }
procedure TbjDSLParser.CheckColName;
var
  i, j: integer;
begin
  FUPdate('Checking worksheet columns');
  if kadb.FindField(UIdName) <> nil then
  begin
    IsIdDefined := True;
  end
  else
  if IsReference then
  begin
    UIdName := UVoucherRefName;
    IsIdDefined := True;
  end;
  if IsIdDefined then
    IsMultiRowVoucher := True;
  if kadb.FindField(UDateName) <> nil then
    IsDateDefined := True;
  if kadb.FindField(UVchNoColName) <> nil then
    IsVchNoDefined := True;
  if kadb.FindField(UVTypeName) <> nil then
    IsVTypeDefined := True;
  if kadb.FindField(UVoucherRefName) <> nil then
    IsVoucherRefDefined := True;
  if kadb.FindField(UVoucherDateName) <> nil then
    IsVoucherDateDefined := True;
  if kadb.FindField(UBillRefName) <> nil then
    IsBillRefDefined := True;
  if kadb.FindField(UNarrationName) <> nil then
    IsNarrationDefined := True;
  if kadb.FindField(UChequeNoName) <> nil then
    IsChequeNoDefined := True;
  if kadb.FindField(UItemName) <> nil then
    IsItemDefined := True;
  if kadb.FindField(UHSNName) <> nil then
    IsHSNDefined := True;
  if kadb.FindField(UBatchName) <> nil then
    IsBatchDefined := True;
  if kadb.FindField(UUserDescName) <> nil then
    IsUserDescDefined := True;
  if kadb.FindField(UUnitName) <> nil then
    IsUnitDefined := True;
//  if kadb.FindField(UAliasName) <> nil then
//    IsAliasDefined := True;
  if kadb.FindField(UMailingName) <> nil then
    IsMailingNameDefined := True;
  if kadb.FindField(UGodownName) <> nil then
    IsGodownDefined := True;
  if IsRoundOffAmountColDeclared then
  if kadb.FindField(URoundOffAmountColName) <> nil then
    IsRoundOffAmountColDefined := True;
  if kadb.FindField(UGSTRateName) <> nil then
    IsGSTRateDefined := True;
  if IsMListDeclared then
  begin
  if kadb.FindField(UAliasName) <> nil then
    IsAliasDefined := True;
    if kadb.FindField(UobALName) <> nil then
      IsobALDefined := True;
    if kadb.FindField(UoBatchName) <> nil then
      IsoBatchDefined := True;
    if kadb.FindField(UAddressName) <> nil then
      IsAddressDefined := True;
    if kadb.FindField(UAddress1Name) <> nil then
      IsAddress1Defined := True;
    if kadb.FindField(UAddress2Name) <> nil then
      IsAddress2Defined := True;
    if kadb.FindField(UAddress3Name) <> nil then
      IsAddress3Defined := True;
    if kadb.FindField(UAddress4Name) <> nil then
      IsAddress4Defined := True;
    if kadb.FindField(UPincodeName) <> nil then
      IsPincodeDefined := True;
    if kadb.FindField(UStateName) <> nil then
      IsStateDefined := True;
    if kadb.FindField(UMobileName) <> nil then
      IsMobileDefined := True;
    if kadb.FindField(UeMailName) <> nil then
      IseMailDefined := True;
    if kadb.FindField(UCategoryName) <> nil then
      IsCategoryDefined := True;
    if kadb.FindField(UMstGroupName) <> nil then
      IsGroupDefined := True;
    if kadb.FindField(USubGroupName) <> nil then
      IsSubGroupDefined := True;
    if kadb.FindField(UORateName) <> nil then
      IsORateDefined := True;
    if kadb.FindField(UMRPRateName) <> nil then
      IsMRPRateDefined := True;
//    if kadb.FindField(UGSTRateName) <> nil then
//      IsGSTRateDefined := True;
  end;
  if IsIListDeclared then
  begin
    if kadb.FindField(UInItemName) <> nil then
      IsInItemDefined := True;
    if kadb.FindField(UOutItemName) <> nil then
      IsOutItemDefined := True;
  end;
{ Check for TallyId }
  if kadb.FindField(UTallyIDName) <> nil then
    IsTallyIDDefined := True
  else
    MessageDlg('Column TallyID is not found', mtError, [mbNo], 0);
  if kadb.FindField(URemoteIDName) <> nil then
    IsRemoteIDDefined := True;
{ Fill IsAmtDeclared array
  Needed for Default Amount }
  for j := 1 to COLUMNLIMIT do
  begin
    if kadb.FindField(UAmountName[j]) <> nil then
    begin
      IsAmtDefined[j] := True;
    end;
  end;
//  if kadb.FindField(RoundOffCol) <> nil then
//    IsRoundOffColDefined := True;
//  if kadb.FindField(RoundOffGroupCol) <> nil then
//    IsRoundOffGroupColDefined := True;

  if IsVListDeclared then
  begin
    if Length(DiLedgerValue[1]) = 0 then
      CheckColumn(ULedgerName[1]);
//  if not IsMListDeclared then
//  begin
    if Length(DiDateValue) = 0 then
      CheckColumn(UDateName);
    if Length(DiTypeValue) = 0 then
      if not IsVtypeDefined then
      CheckColumn(UVTypeName);
    if kadb.FindField(RoundOffCol) <> nil then
      IsRoundOffColDefined := True;
    if kadb.FindField(RoundOffGroupCol) <> nil then
      IsRoundOffGroupColDefined := True;
    if kadb.FindField(UAliasName) <> nil then
      IsRoundOffAliasColDefined := True;
  end;
  if ToCheckInvCols then
    if IsItemDefined then
    begin
      CheckColumn(UQtyName);
      CheckColumn(URateName);
    end;
{ if a Column is defined it should exist in Table }
  for j := 1 to COLUMNLIMIT do
  begin
      if kadb.FindField(ULedgerName[j]) <> nil then
        IsLedgerDefined[j] := True;
  end;
  for i := 1 to COLUMNLIMIT+1 do
  begin
        if IsGSTNDeclared[i] then
          if kadb.FindField(UGSTNName[i]) <> nil then
          begin
            IsGSTNDefined[i] := True;
            if not IsLedgerDefined[i] then
              raise Exception.Create('Check CreateColLedger');
          end;
  end;
end;

{
Amount column is mandatory Where Ledger is defined
Other Columns when not defined relevent code is skipped
}
procedure TbjDSLParser.CheckColumn(const colname: string);
begin
  if kadb.FindField(ColName) = nil  then
  raise Exception.Create(Colname + ' column is Required')
end;

{ TbjMrMc }
constructor TbjMrMc.Create;
begin
  Inherited;
  Env := TbjEnv.Create;
{  SetDebugMode; }
  Env.IsSaveXmlFileOn := False;
  MstExp := TbjMstExp.Create;
  MstExp.Env := Env;
  Env.MstExp := MstExp;
  Env.IsPostto1stLedgerwithGSTNon := FIsPostto1stLedgerwithGSTNon;
  VchExp := TbjVchExp.Create;
  VchExp.Env := Env;
  VchExp.MstExp := MstExp;
  xmlFile := copy(Application.ExeName, 1, Pos('.exe', Application.ExeName)-1) + '.xml';

{  UNarration := '';}
{  Amt1 := '';}
  dsl := TbjDSLParser.Create;
  notoskip := 0;
  FProcessedCount := 0;
  FToLog := True;
  FdynPgLen := PgLen + Random(36);
  askAgainToAutoCreateMst := True;
end;

destructor TbjMrMc.Destroy;
begin
  VchExp.Free;
  MstExp.Free;
  Env.Free;
  dsl.Free;
  if Assigned(kadb) then
  if kadb.ToSaveFile then
    if Length(ReportFileName) > 0 then
      kadb.SaveAs(ReportFileName);
  kadb.Free;
  RpetObj.Free;
  inherited;
end;

procedure TbjMrMc.OpenFile;
var
  flds: TStringList;
  idx: Integer;
begin
{ No try except ...
passing Windows Exception as it is }
  if Length(dbName) = 0 then
    dbName := dsl.dbName;
  if not FileExists(dbName) then
    raise Exception.Create('File ' + dbname + ' not found');
  if Length(TableName) = 0 then
    TableName := dsl.TableName;
{$IFDEF xlstbl}
  if FileFmt = 'Excel_Table' then
  begin
    kadb := TbjXLSTable.Create;
    kadb.XLSFileName := dbname;
    kadb.SetSheet(FTablename);
    kadb.ToSaveFile := True;
    FUpdate('Reading '+ TableName + ' worksheet');
    flds := TStringList.Create;
    kadb.ParseXml(dsl.Cfgn, flds);
    if not flds.Find(DSL.UidName, idx) then
      flds.Add(dsl.UidName);
    flds.Add(dsl.UTallyIDName);
    flds.Add(dsl.URemoteIDName);
    kadb.GetFields(flds);
    FormatCols;
    dsl.kadb := kadb;
    flds.Free;
  end;
{$ENDIF}
  kadb.First;
  if kadb.Eof then
    raise Exception.Create('Worksheet not found or Table is Empty');;
end;

procedure TbjMrMc.CreateDefLedger;
var
  i, j: integer;
  dItem: pDict;
  str: string;
  LedgerColValue: string;
  DeclaredLedgers: integer;
begin
  if Length(dsl.DefGroup) = 0 then
    Env.DefaultGroup := dsl.DefGroup;
  DeclaredLedgers := 0;
{ if a Column is defined it should exist in Table }
  for j := 1 to COLUMNLIMIT do
  begin
      if dsl.IsLedgerDeclared[j] then
        DeclaredLedgers := j;
  end;
  for i := 0 to kadb.FieldList.Count-1 do
  begin
    str := kadb.FieldList[i];
    if copy(str, 1,3) = 'Cr_' then
    begin
      DeclaredLedgers := DeclaredLedgers + 1;
      dsl.IsLedgerDeclared[DeclaredLedgers] := True;
      dsl.DiLedgerValue[DeclaredLedgers] := copy(str, 4, Length(str)-3);
      dsl.IsAmtDefined[DeclaredLedgers] := True;
      dsl.UAmountName[DeclaredLedgers] := str;
      dsl.AmountType[DeclaredLedgers] := 'Cr';
      MstExp.NewLedger(dsl.DiLedgerValue[DeclaredLedgers], 'Indirect Incomes', 0);
    end;
    if copy(str, 1,3) = 'Dr_' then
    begin
      DeclaredLedgers := DeclaredLedgers + 1;
      dsl.IsLedgerDeclared[DeclaredLedgers] := True;
      dsl.DiLedgerValue[DeclaredLedgers] := copy(str, 4, Length(str)-3);
      dsl.IsAmtDefined[DeclaredLedgers] := True;
      dsl.UAmountName[DeclaredLedgers] := str;
      dsl.AmountType[DeclaredLedgers] := 'Dr';
      MstExp.NewLedger(dsl.DiLedgerValue[DeclaredLedgers], 'Indirect Expenses', 0);
    end;
  end;
// Ledger Creation should be done only when necessary
{ Create Default Ledgers }
  for i := 1 to COLUMNLIMIT do
  begin
    if (Length(dsl.LedgerGroup[i]) > 0) then
{ Default Ledger with Amount Column }
      if (Length(dsl.DiLedgerValue[i]) > 0) then
        MstExp.NewLedger(dsl.DiLedgerValue[i], dsl.LedgerGroup[i], 0);
  end;
{
  if dsl.IsRoundOffGroupColDefined then
  begin
    RoundOffGroupColValue :=  kadb.GetFieldString(dsl.RoundOffGroupCol);
    ShowMessage(RoundOffGroupColValue);
    if Length(RoundOffGroupColValue) = 0 then
      RoundOffGroupColValue := dsl.RoundOffGroup;
  end;
}
  if Length(dsl.RoundOffGroup) > 0 then
  if Length(dsl.DiRoundOff) > 0 then
    MstExp.NewLedger(dsl.DiRoundOff, dsl.RoundOffGroup, 0);

{ Create Dictionary Ledgers }
{ +1 for RoundOff }
   for i := 1 to COLUMNLIMIT do
   begin
     if Assigned(dsl.LedgerDict[i]) then
       for j := 0 to dsl.LedgerDict[i].Count-1 do
       begin
         ditem := dsl.LedgerDict[i].Items[j];
         if (Length(dsl.LedgerGroup[i]) > 0) then
         begin
//           MstExp.VchType := VchType;
           LedgerColValue := pDict(dItem)^.Value;
           MstExp.NewGST(LedgerColValue, dsl.LedgerGroup[i], pDict(dItem)^.Token);
         end;
       end;
   end;
  if Assigned(dsl.LedgerDict[COLUMNLIMIT+1]) then
    for j := 0 to dsl.LedgerDict[COLUMNLIMIT+1].Count-1 do
    begin
      ditem := dsl.LedgerDict[COLUMNLIMIT+1].Items[j];
//      if (Length(dsl.RoundOffGroup) > 0) then
      if (Length(dsl.RoundOffGroup) > 0) then
      begin
        LedgerColValue := pDict(dItem)^.Value;
//        MstExp.NewLedger(LedgerColValue, dsl.RoundOffGroup, 0);
        MstExp.NewLedger(LedgerColValue, dsl.RoundOffGroup, 0);
      end;
    end;
    MstExp.NewLedger('RoundOff', 'Indirect Expenses', 0);
  SetGSTSetting;
end;

procedure TbjMrMc.Execute;
var
  StatusMsg: string;
  timestr: string;
begin
  StartTime := Time;
  FProcessedCount := 0;
  dsl.DeclareColName;
  OpenFile;
  dsl.CheckColName;
  CreateDefLedger;
  ProcessMaster;
  if dsl.IsMListDeclared then
    Exit;
{
  if dsl.IsMListDeclared then
  if MessageDlg('Allow modification of Masters?', mtConfirmation, [mbOK, mbCancel], 0) = mrOK then
   begin
    Env.ToUpdateMasters := True;
    ToAutoCreateMst := True;
  end;
  
  kadb.First;
  IDstr := '';
  vTotal := 0;
  while (not kadb.Eof)  do
  begin
    GenerateID;
    CheckLedMst;
    ExpItemMst;
    if dsl.IsMultiRowVoucher then
      CreateRowLedger;
    if dsl.IsMultiColumnVoucher then
      CreateColLedger;
    kadb.Next;
  end;
  if dsl.IsMListDeclared then
  begin
    if IsCheckLedMst then
    begin
    if missingledgers > 0 then
      MessageDlg(IntToStr(missingledgers)+ ' Ledgers Missing in Tally', mtInformation, [mbOK], 0)
    else
      MessageDlg('Done', mtInformation, [mbOK], 0);
    end;
    if IsExpItemMst then
      MessageDlg('Done', mtInformation, [mbOK], 0);
    Exit;
  end;
}
  kadb.First;
  IDstr := '';
  kadb.First;
  vTotal := 0;
  RoundOffActual := 0;
  NewIdLine;
  IsIdOnlyChecked := True;
{ Make sure id is empty }
  while (not kadb.Eof)  do
  begin
    IsInventoryAssigned := False;
    if dsl.IsIdDefined then
    begin
      if (kadb.IsEmptyField(dsl.UIdName)) then
        break;
    end
    else
    begin
{ or otherwise Make sure date is empty }
      if not dsl.IsMultiRowVoucher then
        if dsl.IsDateDefined then
          if (kadb.IsEmptyField(dsl.UDateName)) then
            break;
    end;
    Process;
    if IsIdOnlyChecked then
      Continue;




    kadb.Next;
    if not kadb.Eof then
      notoskip := notoskip + 1;
  end;
  if dsl.IsVListDeclared then
  WriteStatus;
  if dsl.IsiListDeclared then
  WriteStoCK;
  EndTime := Time;
  Elapsed := EndTime - StartTime;
  DecodeTime(Elapsed, Hrs, Mins, Secs, MSecs);
  if Mins > 0 then
  timestr := InttoStr(Mins) + ' minute(s) ' + InttoStr(Secs) +' Seconds'
  else
  timestr := InttoStr(Secs) +' Seconds';




    StatusMsg := InttoStr(ProcessedCount) + '/' + InttoStr(FdynPgLen) +
    ' Vouchers processed; ' +
    InttoStr(SCount) + ' Success. ' + timestr;
  FUpdate(StatusMsg);
//  if not dsl.IsRemoteIdDefined then
  MessageDlg(InttoStr(ProcessedCount) + ' Vouchers processed; To Cancel this post use Success.xls ',
      mtInformation, [mbOK], 0);
  Filter(ProcessedCount - SCount);
end;

procedure TbjMrMc.ProcessMaster;
begin
  if dsl.IsMListDeclared then
  if MessageDlg('Allow modification of Masters?', mtConfirmation, [mbOK, mbCancel], 0) = mrOK then
   begin
    Env.ToUpdateMasters := True;
    ToAutoCreateMst := True;
    AskAgainToAutoCreateMst := False;
    AskedOnce := True;
  end;
  kadb.First;
  IDstr := '';
  vTotal := 0;
  while (not kadb.Eof)  do
  begin
    GenerateID;
    CheckLedMst;
    ExpItemMst;
    if dsl.IsMultiRowVoucher then
      CreateRowLedger;
    if dsl.IsMultiColumnVoucher then
      CreateColLedger;
    kadb.Next;
  end;
  if dsl.IsMListDeclared then
  begin
    if IsCheckLedMst then
    begin
    if missingledgers > 0 then
      MessageDlg(IntToStr(missingledgers)+ ' Ledgers Missing in Tally', mtInformation, [mbOK], 0)
    else
      MessageDlg('Done', mtInformation, [mbOK], 0);
    end;
    if IsExpItemMst then
      MessageDlg('Done', mtInformation, [mbOK], 0);
//    Exit;
  end;
end;

procedure TbjMrMc.Process;
var
  FoundNewId: boolean;
begin
  FoundNewId :=  IsIDChanged;
  if not FoundNewId then
  begin
    if dsl.IsVListDeclared then
    ProcessRow;
    if dsl.IsIListDeclared then
    begin
      ExpStkJrnl;
    end;
    IsIdOnlyChecked := False;
  end;
  if FoundNewId then
  begin
    WriteStatus;
    NewIdline;
    IsIdOnlyChecked := True
  end;
end;

procedure TbjMrMc.ProcessRow;
var
  LedgerColValue: string;
begin
  if dsl.IsNarrationDefined then
  begin
    if dsl.IsIDGenerated then
    begin
      if Length(NarrationColValue) > 0 then
      begin
        if dsl.IsBank then
        NarrationColValue := NarrationColValue + kadb.GetFieldString(dsl.UNarrationName)
        else
        NarrationColValue := NarrationColValue + ' ' + kadb.GetFieldString(dsl.UNarrationName)
      end
      else
        NarrationColValue := (kadb.GetFieldString(dsl.UNarrationName));
      end;
  end;
  LedgerColvalue := Getledger(1);
  Amt[1] := GetAmt(1);
  if Abs(Amt[1]) >= 0.01 then
  begin
    VchExp.AddLine(LedgerColValue, RoundCurr(Amt[1]), IsMinus);
    if dsl.IsAssessableDefined[1] then
      VchExp.SetAssessable(kadb.GetFieldCurr(dsl.UAssessableName[1]));
    VTotal := VTotal + RoundCurr(Amt[1]);
    ProcessItem(1, RoundCurr(Amt[1]));
  end;
  if dsl.IsMultiColumnVoucher then
    ProcessCol(2);
end;

procedure TbjMrMc.ProcessCol(const level: integer);
var
  LedgerColValue: string;
begin
  if not dsl.IsLedgerDeclared[level] then
    Exit;
  LedgerColValue := GetLedger(level);
  if Length(LedgerColValue) = 0 then
    exit;

  amt[level] := GetAmt(level);
  if abs(Amt[level]) >= 0.01 then
  begin
    VchExp.AddLine(LedgerColValue, RoundCurr(Amt[level]), IsMinus);
    if dsl.IsAssessableDefined[level] then
      VchExp.SetAssessable(kadb.GetFieldCurr(dsl.UAssessableName[level]));
    VTotal := VTotal + RoundCurr(Amt[level]);
    ProcessItem(level, RoundCurr(Amt[level]));
    ProcessCol(level+1);
  end;
  if Amt[level] = 0 then
  begin
    if IsMoreColumn(level) then
    begin
      ProcessCol(level+1);
      exit;
    end;
  end;
end;

procedure TbjMrMc.ProcessItem(const level: integer; InvAmt: currency);
var
  ItemColValue: string;
  BatchColValue: string;
  UserDescColValue: string;
  GodownColValue: string;
begin
  if not  dsl.IsInvDefined[level] then
    Exit;
  if IsInventoryAssigned then
    Exit;
  if not dsl.IsItemDefined then
    Exit;
  if kadb.IsEmptyField(dsl.UItemName) then
    Exit;
  if kadb.IsEmptyField(dsl.UQtyName) then
    Exit;
{ InvAmt for Purchase }
  ItemColValue := kadb.GetFieldString(dsl.UItemName);
//  GodownColValue := '';
  if dsl.IsGodownDefined then
  GodownColValue :=  kadb.GetFieldString(dsl.UGodownName);
  if dsl.IsBatchDefined then
  BatchColValue :=  kadb.GetFieldString(dsl.UBatchName);
  if dsl.IsUserDescDefined then
  UserDescColValue :=  kadb.GetFieldString(dsl.UUserDescName);
  if (Length(ItemColValue) > 0)
//    and (not kadb.IsEmptyField(dsl.UQtyName))
    then
    VchExp.SetInvLine(ItemColValue,
    kadb.GetFieldCurr(dsl.UQtyName),
    kadb.GetFieldCurr(dsl.URateName),
    invamt, GodownColValue, BatchColValue, UserDescColValue);
  IsInventoryAssigned := True;
  VchExp.InvVch := True;
end;

procedure TbjMrMc.CreateColLedger;
var
  i: integer;
  StateColValue: string;
  LedgerColValue: string;
  GroupColValue: string;
  GSTNColValue: string;
  RoundOffAliasColValue: string;
  RoundOffGroupColValue: string;
  atoken: string;
  oLedger: string;
begin
{
AutoCreateMst does not affect explicit group or roundoff group
}
  for i:= 1 to COLUMNLIMIT do
  begin
// Convert Declared to Defined
    if dsl.IsGroupDeclared[i] then
    if Length(dsl.UGroupName[i]) > 0 then
      GroupColValue := kadb.GetFieldString(dsl.UGroupName[i]);
    if Length(GroupColValue) = 0 then
        GroupColValue := dsl.LedgerGroup[i];
    if Length(GroupColValue) > 0 then
    begin
      if dsl.IsLedgerDefined[i] then
      begin
        LedgerColValue := kadb.GetFieldString(dsl.ULedgerName[i]);
        if Length(LedgerColValue) = 0 then
          Continue;
        if dsl.IsGSTNDefined[i] then
        begin
          GSTNColValue := kadb.GetFieldString(dsl.UGSTNName[i]);
          StateColValue := GetGSTState(GSTNColValue);
          if not IsPostto1stLedgerwithGSTNon then
          MstExp.NewParty(LedgerColValue, GroupColValue, GSTNColValue,
            StateColValue)
          else
          begin
          oLedger := MstExp.NewParty(LedgerColValue, GroupColValue, GSTNColValue,
            StateColValue);
            if Length(oLedger) > 0 then
              kadb.SetFieldVal(dsl.ULedgerName[i], oLedger);
          end;
        end
        else if dsl.IsLedgerDefined[i] then
        begin
            atoken := GetDictToken(i);
            if Length(aToken) > 0 then
              MstExp.NewGST(LedgerColValue, GroupColValue, aToken)
            else
            begin
              MstExp.NewLedger(LedgerColValue, GroupColValue, 0);
              FUpdate('Ledger: ' + LedgerColValue);
            end;
        end;
      end;
    end;
  end;
  MstExp.Alias := '';
  for i := 1 to COLUMNLIMIT do
  if dsl.IsInvDefined[i] then
    CreateItem(i);
  if dsl.IsRoundOffAliasColDefined then
    RoundOffAliasColValue :=  kadb.GetFieldString(dsl.UAliasName);
  MstExp.Alias := RoundOffAliasColValue;

  if dsl.IsRoundOffGroupColDefined then
    RoundOffGroupColValue :=  kadb.GetFieldString(dsl.RoundOffGroupCol);
  if Length(RoundOffGroupColValue) = 0 then
    RoundOffGroupColValue := dsl.RoundOffGroup;

  if dsl.IsRoundOffColDefined then
  if Length(RoundOffGroupColValue) > 0 then
  begin
    LedgerColValue := kadb.GetFieldString(dsl.RoundOffCol);
    FUpdate('Ledger: ' + LedgerColValue);
    if dsl.IsGSTNDefined[COLUMNLIMIT + 1] then
    begin
      GSTNColValue := kadb.GetFieldString(dsl.UGSTNName[COLUMNLIMIT+1]);
      StateColValue := GetGSTState(GSTNColValue);
      if not IsPostto1stLedgerwithGSTNon then
        MstExp.NewParty(LedgerColValue, RoundOffGroupColValue, GSTNColValue,
          StateColValue)
      else
      begin
        oLedger := MstExp.NewParty(LedgerColValue, RoundOffGroupColValue, GSTNColValue,
            StateColValue);
        if Length(oLedger) > 0 then
          kadb.SetFieldVal(dsl.RoundOffCol, oLedger);
      end;
    end
    else
      MstExp.NewLedger(LedgerColValue, RoundOffGroupColValue, 0);
//    FUpdate('Ledger: ' + LedgerColValue);
  end;
end;

procedure TbjMrMc.CreateItem(const level: integer);
var
  UnitColValue: string;
  ItemColValue: string;
  HSNColValue: string;
  GRate: string;
begin
  if not dsl.IsInvDefined[level] then
    Exit;
  if not dsl.IsItemDefined then
    Exit;
  ItemColValue := kadb.GetFieldString(dsl.UItemName);
  UnitColValue := '';
  if not dsl.IsUnitDefined then
  begin
    MstExp.NewUnit('NOs');
//    UnitColValue := 'Nos';
  end
  else
  begin
    UnitColValue := kadb.GetFieldString(dsl.UUnitName);
    MstExp.NewUnit(UnitColValue);
  end;

  if dsl.IsGodownDefined then
  if Length(kadb.GetFieldString(dsl.UGodownName)) > 0 then
    MstExp.NewGodown(kadb.GetFieldString(dsl.UgODOWNName),'');

  if dsl.IsBatchDefined then
  if Length(kadb.GetFieldString(dsl.UBatchName)) > 0 then
    MstExp.IsBatchwiseOn := True
  else
    MstExp.IsBatchwiseOn := False;
{
    if dsl.IsUserDescDefined then
    MstExp.UserDesc := kadb.GetFieldString(dsl.UUserDescName);
}
  if dsl.IsHSNDefined then
  begin
    HSNColValue := kadb.GetFieldString(dsl.UHSNName);
//    GRate := kadb.GetFieldToken('Tax_rate');
	  if dsl.IsGSTRateDefined then
    GRate := kadb.GetFieldToken(dsl.UGSTRateName);
    MstExp.NewHSN(ItemColValue, UnitColValue, HSNColValue, GRate);
  end
  else
    MstExp.NewItem(ItemColValue,
    UnitColValue , 0, 0);
    FUpdate('Item: ' + ItemColValue);
end;

procedure TbjMrMc.GenerateID;
begin
  if not dsl.IsIDGenerated then
    Exit;

  if dsl.IsDaybook then
  begin
{
    if (vTotal = 0) and (kadb.GetFieldCurr(dsl.CrAmtCol) +
      kadb.GetFieldCurr(dsl.DrAmtCol) > 0) then
    begin
      IDstr :=  IntToStr(kadb.CurrentRow);
      if kadb.IsEmptyField(dsl.UIdName) then
        kadb.SetFieldVal(dsl.UIdName, IDstr)
      else
        IDstr :=  kadb.GetFieldString(dsl.UIdName);
    end;
}
    if (vTotal = 0) then
      IDstr := '';
    if (kadb.GetFieldCurr(dsl.CrAmtCol) +
      kadb.GetFieldCurr(dsl.DrAmtCol) > 0) then
    begin
      if Length(IDstr) = 0 then
      IDstr :=  IntToStr(kadb.CurrentRow);
	  if kadb.IsEmptyField(dsl.UIdName) then
      kadb.SetFieldVal(dsl.UIdName, IDstr)
      else
      IDstr :=  kadb.GetFieldString(dsl.UIdName);
    end;
    vTotal := vTotal + kadb.GetFieldCurr(dsl.CrAmtCol) -
              kadb.GetFieldCurr(dsl.DrAmtCol);
  end;
    if not dsl.IsIdDefined then
      Exit;
  if dsl.IsBank then
  begin
    if (kadb.GetFieldCurr(dsl.CrAmtCol) <> 0) or
      (kadb.GetFieldCurr(dsl.DrAmtCol) <> 0) then
      IDstr :=  IntToStr(kadb.CurrentRow);
    if kadb.IsEmptyField(dsl.UIdName) then
    begin
      kadb.SetFieldVal(dsl.UIdName, IDstr);
    end;
  end;
  FUpdate('ID: '+ IDstr);
end;

procedure TbjMrMc.CheckLedMst;
var
  dbkLed, wLed, dbGSTN, wGSTN: string;
  IsThere: boolean;
  dbAlias: string;
  wOBal: currency;
  wAddress, wMobile, weMail: string;
  rAddress1, rAddress2, rAddress3, rAddress4, rPincode, rState: string;
begin
  if not dsl.IsMListDeclared then
    Exit;
  if not IsCheckLedMst then
    Exit;
  wOBal := 0;
  if not Assigned(RpetObj) then
  begin
    RpetObj := TRpetGSTN.Create;
  end;
  kadb.SetFieldVal('TALLYID', ' - ');
  if dsl.IsOBalDefined then
  wOBal := kadb.GetFieldCurr(dsl.UOBalName);
  MstExp.OBal := wOBal;
  if dsl.IsAddressDefined then
    wAddress := kadb.GetFieldString(dsl.UAddressName)
  else
  begin
    if dsl.IsAddress1Defined then
      rAddress1 := kadb.GetFieldString(dsl.UAddress1Name);
    if dsl.IsAddress2Defined then
      rAddress2 := kadb.GetFieldString(dsl.UAddress2Name);
    if dsl.IsAddress3Defined then
      rAddress3 := kadb.GetFieldString(dsl.UAddress3Name);
    if dsl.IsAddress4Defined then
      rAddress4 := kadb.GetFieldString(dsl.UAddress4Name);
  end;
  if dsl.IsPincodeDefined then
    rPincode := kadb.GetFieldString(dsl.UPincodeName);
  MstExp.Address := wAddress;
  MstExp.Address1 := rAddress1;
  MstExp.Address2 := rAddress2;
  MstExp.Address3 := rAddress3;
  MstExp.Address4 := rAddress4;
  MstExp.Pincode := rPincode;
  if dsl.IsMobileDefined then
    wMobile := kadb.GetFieldString(dsl.UMobileName);
  MstExp.Mobile := wMobile;
  if dsl.IseMailDefined then
    weMail := kadb.GetFieldString(dsl.UeMailName);
  MstExp.eMail := weMail;
  if dsl.IsLedgerdefined[1] then
  dbkLed := kadb.GetFieldString('Ledger');
  if dsl.IsAliasDefined then
  begin
    dbAlias := kadb.GetFieldString(dsl.UAliasName);
    MstExp.Alias := dbAlias;
  end;
  if Length(dbkLed) > 0 then
  begin
    dbGSTN := kadb.GetFieldString('GSTN');
    wLed := RpetObj.GetGSTNParty(dbGSTN);
    IsThere := False;
    if not Env.ToUpdateMasters then
    IsThere := MstExp.IsLedger(dbkLed);
    if not IsThere then
    begin
      if Length(wLed) > 0 then
      if dbkLed <> wLed then
        Exit;
    end;
    if not IsThere then
    begin
      if AskAgainToAutoCreateMst then
        if MessageDlg('Create missing Ledger ' + dbkLed +' ?', mtConfirmation, mbOKCancel, 0) = mrCancel then
          ToAutoCreateMst := False
        else
          ToAutoCreateMst := True;
      if not AskedOnce then
        if MessageDlg('Continue asking' + ' ?', mtConfirmation, mbOKCancel, 0) = mrCancel then
          askAgainToAutoCreateMst := False;
      AskedOnce := True;
    end;
    if not IsThere  then
    begin
      if not ToAutoCreateMst then
      begin
        kadb.SetFieldVal('TALLYID', 'New Ledger');
        missingledgers := missingledgers + 1;
      end
      else
     begin
        CreateGSTLedger;
     end;
    end
    else
    if dsl.IsGSTNDefined[1] then
      if not kadb.IsEmptyField('GSTN') then
      begin
        wGSTN := GetLedgersGSTN(dbkLed);
        if Length(wGSTN) = 0 then
        begin
          kadb.SetFieldVal('TALLYID', 'Update GSTN');
      end;
      if dbGSTN <> wGSTN then
        kadb.SetFieldVal('TALLYID', 'New GSTN - Repeat Name');
      if dbkLed <> wLed then
        kadb.SetFieldVal('TALLYID', wLed + ' - Repeat GSTN');
      end;
  end;
end;

procedure TbjMrMc.ExpItemMst;
var
  dbItem, dbUnit: string;
  dbAlias, dbMailingName: string;
  dbGodown, dbParent, dbCategory: string;
  dbHSN: string;
  dbOBatch: string;
  wOBal: currency;
  ORate: currency;
  MRPRate: currency;
  GRate: string;
begin
  if not dsl.IsMListDeclared then
    Exit;
  if not IsExpItemMst then
    Exit;
  wOBal := 0;
  dbUnit := '';
  oRate := 0;
  MRPRate := 0;
  if dsl.IsUnitDefined then
  begin
//    dbUnit := kadb.GetFieldString('Unit');
    dbUnit := kadb.GetFieldString(dsl.UUnitName);
    MstExp.NewUnit(dbUnit);
  end;
  if dsl.IsAliasDefined then
  begin
    dbAlias := kadb.GetFieldString(dsl.UAliasName);
    MstExp.Alias := dbAlias;
  end;
  if dsl.IsMailingNameDefined then
  begin
    dbMailingName := kadb.GetFieldString(dsl.UMailingName);
    MstExp.MailingName := dbMailingName;
  end;
  if dsl.IsGodownDefined then
  begin
    dbGodown := kadb.GetFieldString(dsl.UGodownName);
    MstExp.NewGodown(dbGodown,'');
    MstExp.Godown := dbGodown;
  end;
  if dsl.IsCategoryDefined then
  begin
    dbCategory := kadb.GetFieldString(dsl.UCategoryName);
    MstExp.NewCategory(dbCategory,'');
    MstExp.Category := dbCategory;
  end;
  if dsl.IsGroupDefined then
  begin
    dbParent := kadb.GetFieldString(dsl.UMstGroupName);
    MstExp.NewItemGroup(dbParent,'');
    MstExp.Group := dbParent;
  end;
  if dsl.IsSubGroupDefined then
  begin
    dbParent := kadb.GetFieldString(dsl.USubGroupName);
    if Length(dbParent) > 0 then
    begin
      MstExp.NewItemGroup(dbParent,
        kadb.GetFieldString(dsl.UMstGroupName));
      MstExp.Group := dbParent;
    end;
  end;
  dbItem := kadb.GetFieldString(dsl.UItemName);
  if dsl.IsOBalDefined then
  wOBal := kadb.GetFieldCurr(dsl.UOBalName);
  if dsl.IsOBatchDefined then
    dbOBatch := kadb.GetFieldString(dsl.UOBatchName);
  if dsl.IsORateDefined then
    ORate := kadb.GetFieldCurr(dsl.UORateName);
  if dsl.IsMRPRateDefined then
    MRPRate := kadb.GetFieldCurr(dsl.UMrpRateName);
  if dsl.IsGSTRateDefined then
    GRate := kadb.GetFieldString(dsl.UGSTRateName);
  MstExp.OBal := wOBal;
  MstExp.ORate := ORate;
  MstExp.MRPRate := MRPRate;
  MstExp.OBatch := dbOBatch;
  if dsl.IsOBatchDefined then
  if Length(kadb.GetFieldString(dsl.UOBatchName)) > 0 then
    MstExp.IsBatchwiseOn := True
  else
    MstExp.IsBatchwiseOn := False;
  if dsl.IsUserDescDefined then
    MstExp.UserDesc := kadb.GetFieldString(dsl.UUserDescName);
  if dsl.IsHSNDefined then
  begin
    dbHSN := kadb.GetFieldString(dsl.UHSNName);
//    MstExp.OBal := wOBal;
//    MstExp.ORate := ORate;
    MstExp.NewHSN(dbItem, dbUnit, dbHSN, GRate);
  end
  else
    MstExp.NewItem(dbItem, dbUnit, wOBal, ORate);
  FUpdate('Item: ' + dbItem);
end;

procedure TbjMrMc.ExpStkJrnl;
var
  ItemColValue: string;
  dbUnit: string;
  BatchColValue: string;
  GodownColValue: string;
  UserDescColValue: string;
begin
  if dsl.IsNarrationDefined then
  begin
    if Length(NarrationColValue) > 0 then
    NarrationColValue := NarrationColValue + ' ' + kadb.GetFieldString(dsl.UNarrationName)
    else
    NarrationColValue := (kadb.GetFieldString(dsl.UNarrationName));
  end;
  if dsl.IsOutItemDefined then
  begin
    dbUnit := kadb.GetFieldString(dsl.UOutUnitName);
    MstExp.NewUnit(dbUnit);
    ItemColValue := kadb.GetFieldString(dsl.UOutItemName);
    MstExp.NewItem(ItemColValue, dbUnit, 0,0);
  end;
  if dsl.IsInItemDefined then
  begin
    dbUnit := kadb.GetFieldString(dsl.UInUnitName);
    MstExp.NewUnit(dbUnit);
    ItemColValue := kadb.GetFieldString(dsl.UInItemName);
    MstExp.NewItem(ItemColValue, dbUnit, 0,0);
  end;
  if dsl.IsOutItemDefined then
  begin
{
  if dsl.IsBatchDefined then
  BatchColValue :=  kadb.GetFieldString('Batch');
  if dsl.IsUserDescDefined then
  UserDescColValue :=  kadb.GetFieldString(dsl.UUserDescName);
}
  ItemColValue := kadb.GetFieldString(dsl.UOutItemName);
  GodownColValue := kadb.GetFieldString(dsl.UOutGodownName);
  if (Length(ItemColValue) > 0) and
    (not kadb.IsEmptyField(dsl.UOutQtyName)) then
    VchExp.SetInvLine(ItemColValue,
    kadb.GetFieldCurr(dsl.UOutQtyName),
    kadb.GetFieldCurr(dsl.UOutRateName),
    kadb.GetFieldCurr(dsl.UOutAmtName),
    GodownColValue, BatchColValue, UserDescColValue);
  end;
  if dsl.IsInItemDefined then
  begin
{
  if dsl.IsBatchDefined then
  BatchColValue :=  kadb.GetFieldString('Batch');
  if dsl.IsUserDescDefined then
  UserDescColValue :=  kadb.GetFieldString(dsl.UUserDescName);
}
  ItemColValue := kadb.GetFieldString(dsl.UInItemName);
  GodownColValue := kadb.GetFieldString(dsl.UInGodownName);
  if (Length(ItemColValue) > 0) and
    (not kadb.IsEmptyField(dsl.UInQtyName)) then
    VchExp.SetInvLine(ItemColValue,
    kadb.GetFieldCurr(dsl.UInQtyName),
    kadb.GetFieldCurr(dsl.UInRateName),
    -kadb.GetFieldCurr(dsl.UInAmtName),
    GodownColValue, BatchColValue, UserDescColValue);
  end;
end;

procedure TbjMrMc.CreateRowLedger;
var
  OB: currency;
  StateColValue: string;
  LedgerColValue: string;
  GroupColValue: string;
  GSTNColValue: string;
  oLedger: string;
begin
  OB := 0;
  if not dsl.IsGroupDeclared[1] then
    Exit;
{
AutoCreateMst does not affect explicit group or roundoff group
}
  if not kadb.IsEmptyField(dsl.UGroupName[1]) then
  begin
    LedgerColValue := kadb.GetFieldString(dsl.ULedgerName[1]);
    FUpdate('Ledger: ' + LedgerColValue);
    GroupColValue := kadb.GetFieldString(dsl.UGroupName[1]);
    if dsl.IsGSTNDefined[1] then
    begin
      GSTNColValue := kadb.GetFieldString(dsl.UGSTNName[1]);
      StateColValue := GetGSTState(GSTNColValue);
      if not IsPostto1stLedgerwithGSTNon then
      MstExp.NewParty(LedgerColValue,
        GroupColValue,
        GSTNColValue,
        StateColValue)
      else
      begin
          oLedger := MstExp.NewParty(LedgerColValue, GroupColValue, GSTNColValue,
            StateColValue);
            if Length(oLedger) > 0 then
              kadb.SetFieldVal(dsl.ULedgerName[1], oLedger);
      end;
    end
    else
      MstExp.NewLedger(LedgerColValue,
        GroupColValue, OB);
//    FUpdate('Ledger: ' + LedgerColValue);
  end;
end;

procedure TbjMrMc.NewIdLine;
var
  TId: string;
begin
  if dsl.IsIdDefined then
    IDstr := kadb.GetFieldString(dsl.UIdName);
  UIdint := kadb.CurrentRow;
  NarrationColValue := '';
  GetDefaults;
  TID := '';
{ Let VchUpdate generate random id in case of no id }
{ Natural no as id would interfere will Tall's logic in some versions }
  If dsl.IsVchNoDefined then
  VchExp.VchNo := kadb.GetFieldString(dsl.UVchNoColName);

  if dsl.IsVoucherRefDefined then
    VchExp.VchRef := kadb.GetFieldString(dsl.UVoucherRefName);
  if dsl.IsVoucherDateDefined then
  begin
    VchExp.VouDate := kadb.GetFieldSDate(dsl.UVoucherDateName);
    VchExp.VchRefDate := kadb.GetFieldSDate(dsl.UDateName);
  end;
  if dsl.IsBillRefDefined then
    VchExp.BillRef := kadb.GetFieldString(dsl.UBillRefName);
{ Late binding of VchExp.VchNarration }
  VchExp.VchGSTN := '';
    if dsl.IsGSTNDefined[COLUMNLIMIT + 1] then
    VchExp.VchGSTN := kadb.GetFieldString(dsl.UGSTNName[COLUMNLIMIT+1]);
  VchExp.vchDate := DateColValue;
  VchExp.VchType := typeColValue;
  VchExp.WSType := WSType;
  if dsl.IsRemoteIdDefined then
  if VchAction = 'Delete' then
  VchExp.RemoteID := RemoteID;
  VchExp.VchID := tid;
  VchExp.VchChequeNo := ChequeNoColValue;
  ChequeNoColValue := '';
  RoundOffName := GetRoundOffName;
  notoskip := 0;
end;

{***}
procedure TbjMrMc.GetDefaults;
begin
{  GetSingleValues; }
  RemoteID := '';
  DateColValue := '';
  TypeColValue := '';
  if dsl.IsDateDefined then
    if not kadb.IsEmptyField(dsl.UDateName) then
    DateColValue := kadb.GetFieldSDate(dsl.UDateName);
  if dsl.IsVtypeDefined then
{ Find if user set has Voucher type }
    TypeColValue := kadb.GetFieldString(dsl.UVTypeName);
{
  Bank has only two types
  Daybook has all types
  VchUpdate has defaults to Voucher Type Journal
}
  if dsl.IsCrDrAmtColsDefined then
  begin
  if Length(TypeColValue) = 0 then
  begin
    if kadb.GetFieldCurr(dsl.CrAmtCol) > 0 then
      if Length(dsl.CrAmtColType) > 0 then
        TypeColValue := dsl.CrAmtColType;
    if kadb.GetFieldCurr(dsl.DrAmtCol) > 0 then
      if Length(dsl.DrAmtColType) > 0 then
        TypeColValue := dsl.DrAmtColType;
  end;
  end;
{ For reusing Templates }
  if Length(TypeColValue) = 0 then
    TypeColValue := FVchType;
{ With VchType this should not be needed }
  if Length(TypeColValue) = 0 then
    TypeColValue := dsl.DiTypeValue;

  if not dsl.IsIDGenerated then
  if dsl.IsNarrationDefined then
    NarrationColValue := kadb.GetFieldString(dsl.UNarrationName);

  if dsl.IsChequeNoDefined then
    if not kadb.IsEmptyField(dsl.UChequeNoName) then
    ChequeNoColValue := kadb.GetFieldString(dsl.UChequeNoName);
  if dsl.IsRemoteIdDefined then
  if VchAction = 'Delete' then
  begin
    RemoteID := kadb.GetFieldString(dsl.URemoteIdName);
  end;
  if dsl.IsRoundOffAmountColDefined then
    RoundOffActual := kadb.GetFieldCurr(dsl.URoundOffAmountColName);
end;

{
Id can be determined with date and voucher total.
If there is demand...
}
function TbjMrMc.IsIDChanged: boolean;
begin
  Result := False;
  if dsl.IsIdDefined then
    if (kadb.GetFieldString(dsl.UIdName) <> IDstr) then
      Result  := True;

  if not dsl.IsMultiRowVoucher then
    if kadb.CurrentRow <> uidint then
      Result := True;
{
  Date check is for end of file only
}
end;


function TbjMrMc.GetLedger(const level: integer): string;
var
  lstr: string;
begin
  if dsl.IsLedgerDefined[level] then
  begin
    if not kadb.IsEmptyField(dsl.ULedgerName[level]) then
      lstr := kadb.GetFieldString(dsl.ULedgerName[level]);
    if Length(lstr) > 0 then
    begin
      Result := lstr;
      Exit;
    end;
  end;
{
{
Depending on token in one column 1 Ledger 1 is derived
Token code is exception to normal logic; Getout after executing this fragment
}
  lstr := GetDictValue(level);
  if Length(lstr) > 0 then
  begin
    Result := lstr;
    Exit;
  end;
  if Length(lstr) = 0 then
    Result := dsl.DiLedgerValue[level];
end;

{ Modifies Amtount according to Voucher Types to +ve or -ve }
function TbjMrMc.GetAmt(const level: integer): currency;
begin
  Result := 0;
  IsMinus := False;
{
  IsMultiRow with Cr Dr Columns
  or
  IsMultiCol with CR Dr Columns
  Cr Dr Col Amt code is exeception to normal logic
  So exit is used
}
  if dsl.IsCrDrAmtcolsDefined then
  begin
    if (level = 1) or (level = 2)  then
    begin
      if not kadb.IsEmptyField(dsl.DrAmtCol) then
      if kadb.GetFieldCurr(dsl.DrAmtCol) <> 0 then
        Result := -kadb.GetFieldCurr(dsl.DrAmtCol);
      if not kadb.IsEmptyField(dsl.CrAmtCol) then
      if kadb.GetFieldCurr(dsl.CrAmtCol) <> 0 then
        Result := kadb.GetFieldCurr(dsl.CrAmtCol);
      if (level = 2)  then
        Result := -Result;
    end;
    Exit;
  end;
{ IsMultiCol }
  if dsl.IsAmtDefined[level] then
  begin
    if not kadb.IsEmptyField(dsl.UAmountName[level]) then
    begin
      Result := kadb.GetFieldCurr(dsl.UAmountName[level]);
      if Result < 0 then
        IsMinus := True;
      if dsl.AmountType[level] = 'Dr' then
        Result := - kadb.GetFieldCurr(dsl.UAmountName[level]);
{      Exit;}
    end;
    if dsl.AmountCols[level] > 1 then
    begin
      if not kadb.IsEmptyField(dsl.UAmount2Name[level]) then
      begin
        if dsl.Amount2Type[level] = 'Cr' then
          Result := Result + kadb.GetFieldCurr(dsl.UAmount2Name[level]);
        if dsl.Amount2Type[level] = 'Dr' then
          Result := Result - kadb.GetFieldCurr(dsl.UAmount2Name[level]);
{      Exit;}
      end;
    end;
  end;
end;


{***}
function TbjMrMc.IsMoreColumn(const level: integer): boolean;
var
i: integer;
begin
  Result := False;
  for i := level to COLUMNLIMIT-1 do
  begin
  if dsl.IsLedgerDeclared[i+1] then
  begin
    Result := True;
    break;
  end;
  end;
end;

function TbjMrMc.GetRoundOffName: string;
var
  lStr: string;
begin
  Result := '';
  if dsl.IsRoundOffColDefined then
  begin
    if not kadb.IsEmptyField(dsl.RoundOffCol) then
      lstr := kadb.GetFieldString(dsl.RoundOffCol);
    if Length(lstr) > 0 then
    begin
      Result := lstr;
      Exit;
    end;
  end;
    lstr := GetDictValue(COLUMNLIMIT+1);
    if Length(lstr) > 0 then
    begin
      Result := lstr;
      Exit;
    end;
  if Length(dsl.DiRoundOff) > 0 then
    Result := dsl.DiRoundOff;
end;

procedure TbjMrMc.WriteStatus;
var
  i: integer;
  statmsg: string;
  RoundOffAmount: currency;
  Thisalso: boolean;
begin
  Thisalso := False;
  IsMinus := False;

  if dsl.IsRoundOffAmountColDefined then
  begin
    if VTotal < 0 then
      RoundOffActual := -RoundOffActual;
  end;
  if RoundOffActual = 0 then
  begin
  RoundOffAmount := Trunc(Vtotal) - VTotal;
  if RoundOffMethod = ' ' then
    RoundOffAmount :=  0;
  if RoundOffMethod = 'W' then
  begin
    if Abs(RoundOffAmount) > 0.5 then
//      RoundOffMethod := 'N';
      thisalso := True;
  end;
  if (RoundOffMethod = 'N') or thisalso then
  begin
    if RoundOffAmount < 0 then
    begin
      RoundOffAmount :=  RoundOffAmount + 1;
      VTotal := VTotal + 1;
    end
    else if RoundOffAmount > 0 then
    begin
      RoundOffAmount := RoundOffAmount - 1;
      VTotal := VTotal - 1;
    end;
  end;
  end;
{  CheckErrStr := '(FOR OBJECT: '; }
//  vchAction := 'Create';
  If VchAction = 'Delete' then
  begin
  if not dsl.IsRemoteIDDefined then
//    MessageDlg('Column RemoteID is not found', mtError, [mbOK], 0)
    raise Exception.Create('RemoteID column is not found');
    VchExp.RemoteID := RemoteID;
  end;
  if RoundOffActual = 0 then
  begin
    if RoundOffAmount <> 0 then
    begin
    VchExp.AddLine(RoundOffName, - trunc(VTotal), IsMinus);
  if VTotal > 0 then
  if RoundOffAmount < 0 then
      IsMinus := True;
  if VTotal < 0 then
  if RoundOffAmount > 0 then
      IsMinus := True;
      VchExp.AddLine('RoundOff', RoundOffAmount, IsMinus);
    end
    else
      VchExp.AddLine(RoundOffName, - VTotal, IsMinus);
  end
  else
  begin
    RoundOffAmount := RoundOffActual - VTotal;
    if RoundOffAmount <> 0 then
    begin
      VchExp.AddLine(RoundOffName, - RoundOffActual, IsMinus);
      if VTotal > 0 then
      if RoundOffAmount < 0 then
        IsMinus := True;
      if VTotal < 0 then
      if RoundOffAmount > 0 then
        IsMinus := True;
      VchExp.AddLine('RoundOff', RoundOffAmount, IsMinus);
    end
    else
      VchExp.AddLine(RoundOffName, -RoundOffActual, IsMinus);
  end;
  if dsl.IsNarrationDefined then
    VchExp.VchNarration := NarrationColValue;
  StatMsg := VchExp.Post(VchAction, True);
  if Length(Env.LastAction) > 0 then
  if Env.LastAction <> 'CREATED' THEN
    StatMsg := StatMsg + ' ' + Capitalize(Env.LastACtion);
  If VchAction = 'Create' then
  RemoteID := VchExp.RemoteID;
  If VchAction = 'Delete' then
  RemoteID := '';
  VTotal := 0;
  RoundOffActual := 0;
  FUpdate('Voucher: ' + Statmsg);
  FProcessedCount := FProcessedCount + 1;

  for i := 1 to notoskip do
    kadb.Prior;
  if ToLog then
  if dsl.isTallyIdDefined then
    kadb.SetFieldVal('TALLYID', statmsg);
  if dsl.IsRemoteIDDefined then
    kadb.SetFieldVal('RemoteID', RemoteID);
  for i := 1 to notoskip do
    kadb.Next;
  notoskip := 0;
  if (Length(StatMsg) > 0 ) and (Length(StatMsg) < 9 )then
    if StatMsg <> '0' then
      FSCount := FScount + 1;
end;

procedure TbjMrMc.WriteStock;
var
  i: integer;
  statmsg: string;
  Thisalso: boolean;
begin
//  vchAction := 'Create';
  if dsl.IsNarrationDefined then
    VchExp.VchNarration := NarrationColValue;
  StatMsg := VchExp.SPost(VchAction, True);
  FUpdate('Voucher: ' + Statmsg);
  FProcessedCount := FProcessedCount + 1;

  for i := 1 to notoskip do
    kadb.Prior;
  if ToLog then
  if dsl.isTallyIdDefined then
    kadb.SetFieldVal('TALLYID', statmsg);
  for i := 1 to notoskip do
    kadb.Next;
  notoskip := 0;
  if (Length(StatMsg) > 0 ) and (Length(StatMsg) < 9 )then
    if StatMsg <> '0' then
      FSCount := Scount + 1;
end;

procedure TbjMrMc.SetFirm(const aFirm: string);
begin
  FFirm := aFirm;
  Env.Firm := aFirm;
end;

procedure TbjMrMc.SetFirmGUID(const aGUID: string);
begin
  FFirmGUID := aGUID;
  Env.GUID := aGuid;
end;
procedure TbjMrMc.SetHost(const aHost: string);
begin
  FHost := aHost;
  if not Assigned(ClientFns) then
     ClientFns := TbjGSTClientFns.Create;
  ClientFns.Host := Host;
  Env.Host := Host;
end;

procedure TbjMrMc.SetPostto1stLedgerwithGSTN(const aChoice: Boolean);
begin
  FIsPostto1stLedgerwithGSTNon := aChoice;
  Env.IsPostto1stLedgerwithGSTNon := aChoice;
end;
procedure TbjMrMc.SetIsUniqueVchRef(const aChoice: Boolean);
begin
  FIsUniqueVchRefon := aChoice;
  Env.IsUniqueVchRefon := aChoice;
end;
procedure TbjMrMc.SetGSTLedType(const aType: string);
begin
  FGSTLedType := aType;
  Env.GSTLedType := aType;
end;

procedure TbjMrMc.SetXmlstr(const aStr: string);
begin
  FXmlStr := aStr;
  dsl.XmlStr := aStr;
end;

function TbjMrMc.GetGSTState(const aGSTN: string): string;
var
  idx: integer;
  str: string;
begin
  Result := UdefStateName;
  idx := 33;
  str := copy(aGSTN, 1, 2);
  if Length(Trim(str)) = 0 then
  begin
//  Result := UdefStateName;
  Exit;
  end;
  if not tryStrtoInt(str, idx) then
  begin
    MessageDlg('Error in GSTN, Row: '+ IntToStr(kadb.CurrentRow+1) , mterror, [mbOK], 0);
    kadb.SetFieldVal('TALLYID', 'GSTN');
//    Result := UDefStateName;
    Exit;
  end;
  Case idx of
        1: str := 'Jammu & Kashmir';
        2: str := 'Himachal Pradesh';
        3: str := 'Punjab';
        4: str := 'Chandigarh';
        5: str := 'Uttranchal';
        6: str := 'Haryana';
        7: str := 'Delhi';
        8: str := 'Rajasthan';
       09: str := 'Uttar Pradesh';
       10: str := 'Bihar';
       11: str := 'Sikkim';
       12: str := 'Arunachal Pradesh';
       13: str := 'Nagaland';
       14: str := 'Manipur';
       15: str := 'Mizoram';
       16: str := 'Tripura';
       17: str := 'Meghalaya';
       18: str := 'Assam';
       19: str := 'West Bengal';
       20: str := 'Jharkhand';
       21: str := 'Odisha (Formerly Orissa';
       22: str := 'Chhattisgarh';
       23: str := 'Madhya Pradesh';
       24: str := 'Gujarat';
       25: str := 'Daman & Diu';
       26: str := 'Dadra & Nagar Haveli';
       27: str := 'Maharashtra';
       28: str := 'Andhra Pradesh';
       29: str := 'Karnataka';
       30: str := 'Goa';
       31: str := 'Lakshdweep';
       32: str := 'Kerala';
       33: str := 'Tamil Nadu';
//       34: str := 'Pondicherry';
       34: str := 'Puducherry';
       35: str := 'Andaman & Nicobar Islands';
       36: str := 'Telangana';
       37: str := 'Andhra Pradesh (New)';
  else
  str := UdefStateName;
  end;
  Result := str;
end;

function TbjMrMc.GETDictToken(const ctr: integer): string;
var
  i: integer;
  item: pDict;
  rpetToken: string;
begin
  rpetToken := '';
  if not Assigned(dsl.LedgerDict[ctr]) then
  Exit;
  for i := 0 to dsl.LedgerDict[ctr].Count-1 do
  begin
    Item := dsl.LedgerDict[ctr].Items[i];
    if Length(rpetToken) = 0 then
      rpetToken := kadb.GetFieldToken(pDict(Item)^.TokenCol);
//    if pDict(Item)^.Token = Trim(kadb.GetFieldString(pDict(Item)^.TokenCol)) then
    if rpetToken = pDict(Item)^.Token then
    begin
      Result := pDict(Item)^.Token;
      break;
    end;
  end;
end;


function TbjMrMc.GETDictValue(const ctr: integer): string;
var
  i: integer;
  item: pDict;
  rpetToken: string;
begin
  rpetToken := '';
  if not Assigned(dsl.LedgerDict[ctr]) then
  Exit;
  for i := 0 to dsl.LedgerDict[ctr].Count-1 do
  begin
    Item := dsl.LedgerDict[ctr].Items[i];
    if Length(rpetToken) = 0 then
      rpetToken := kadb.GetFieldToken(pDict(Item)^.TokenCol);
//    if (pDict(Item)^.Token = Trim(kadb.GetFieldString(pDict(Item)^.TokenCol))) then
    if rpetToken = pDict(Item)^.Token then
    begin
      Result := pDict(Item)^.Value;
      break;
    end;
  end;
end;

procedure TbjMrMc.Filter(aFailure: integer);
var
  inErr: boolean;
begin
  kadb.SaveAs('.\Data\Success.xls');
//  if (aFailure = 0) then
  inErr := True;
  kadb.First;
  while not kadb.EOF do
  begin
    if kadb.IsEmptyField(dsl.UTallyIDName)  then
    if not inErr then
    begin
      kadb.Delete;
      Continue;
    end;
//    Exit;
    if not kadb.IsEmptyField(dsl.UTallyIDName) then
      if kadb.GetFieldCurr(dsl.UTallyIDName) >  0 then
      begin
        inErr := False;
        kadb.Delete;
        Continue;
      end
      else
        inErr := True;
    kadb.Next;
  end;
  UnFilter;
end;
//  KAdb.Save('.\Data\Response.xls');
procedure TbjMrMc.FormatCols;
begin
  kadb.SetFieldFormat('Tax_rate', 35);
  kadb.SetFieldFormat('DATE', 14);
  kadb.SetFieldFormat('Voucher_Date', 14);
  kadb.SetFieldFormat('Invoice_Date', 14);
  kadb.SetFieldFormat('ID', 35);
  kadb.SetFieldFormat('NARRATION', 35);

  kadb.SetFieldFormat('PARTY', 35);

  kadb.SetFieldFormat('GSTN', 35);
  kadb.SetFieldFormat('Item', 35);
  kadb.SetFieldFormat('HSN', 35);
  kadb.SetFieldFormat('Batch', 35);
  kadb.SetFieldFormat('UserDesc', 35);
  kadb.SetFieldFormat('Unit', 35);
  kadb.SetFieldFormat('Bank_Ledger', 35);
  kadb.SetFieldFormat('Sales_Ledger', 35);
  kadb.SetFieldFormat('Purchase_Ledger', 35);
  kadb.SetFieldFormat('Bill_Ledger', 35);
  kadb.SetFieldFormat('Credit_Ledger', 35);
  kadb.SetFieldFormat('Debit_Ledger', 35);
  kadb.SetFieldFormat('LEDGER', 35);
  kadb.SetFieldFormat('Party Ledger', 35);
  kadb.SetFieldFormat('Payment_Ledger', 35);
  kadb.SetFieldFormat('Receipt_Ledger', 35);
  kadb.SetFieldFormat('Voucher Ref', 35);
  kadb.SetFieldFormat('Bill Ref', 35);
  kadb.SetFieldFormat('GROUP', 35);
  kadb.SetFieldFormat('Alias', 35);
  kadb.SetFieldFormat('GSTRate', 35);
  kadb.SetFieldFormat('SubGroup', 35);
  kadb.SetFieldFormat('Godown', 35);
  kadb.SetFieldFormat('Category', 35);
  kadb.SetFieldFormat('TALLYID', 35);
  kadb.SetFieldFormat('REMOTEID', 35);
    end;

procedure TbjMrMc.UnFilter;
var
  inErr: boolean;
  Successdb: TbjXLSTable;
  flds: TStringList;
  idx: Integer;
begin
  Successdb := TbjXLSTable.Create;
  try
  Successdb.XLSFileName := '.\Data\Success.xls';
  Successdb.SetSheet(FTablename);
  Successdb.ToSaveFile := True;
  flds := TStringList.Create;
  try
    Successdb.ParseXml(dsl.Cfgn, flds);
    if not flds.Find(dsl.UidName, idx) then
      flds.Add(dsl.UidName);
    flds.Add(dsl.UTallyIDName);
    flds.Add(dsl.URemoteIDName);
    Successdb.GetFields(flds);
  finally
    flds.Free;
  end;
  inErr := True;
  Successdb.First;
  while not Successdb.EOF do
  begin
    if Successdb.IsEmptyField(dsl.UTallyIDName)  then
    if inErr then
    begin
      Successdb.Delete;
      Continue;
    end;
    if not Successdb.IsEmptyField(dsl.UTallyIDName) then
      if Successdb.GetFieldCurr(dsl.UTallyIDName) =  0 then
      begin
        inErr := True;
        Successdb.Delete;
        Continue;
      end
      else
        inErr := False;
    Successdb.Next;
  end;
  if Successdb.ToSaveFile then
    Successdb.Save;
  finally
  successdb.Free;
  end;
end;

procedure TbjMrMc.CreateGSTLedger;
var
  rState: string;
begin
  if dsl.IsStateDefined then
    rState := kadb.GetFieldString(dsl.UStateName);
  if Length(rState) = 0 then
    rState := UdefStateName;
  if kadb.GetFieldString('Group') = 'Duties & Taxes' then
  begin
    MstExp.NewGst(kadb.GetFieldString('Ledger'), 'Duties & Taxes', '12');
    Exit;
  end;
  if (kadb.GetFieldString('Group') = 'Sundry Debtors') or
    (kadb.GetFieldString('Group') = 'Sundry Creditors') then
  begin
    MstExp.NewParty(kadb.GetFieldString('Ledger'), kadb.GetFieldString('Group'),
//      kadb.GetFieldString('GSTN'), UdefStateName);
      kadb.GetFieldString('GSTN'), rState);
    Exit;
  end;
  if (kadb.GetFieldString('Group') = 'Sales Accounts') or
    (kadb.GetFieldString('Group') = 'Purchase Accounts') then
  begin
    MstExp.NewGST(kadb.GetFieldString('Ledger'), kadb.GetFieldString('Group'),'12');
    Exit;
  end;
  MstExp.NewLedger(kadb.GetFieldString('Ledger'), kadb.GetFieldString('Group'),0);
end;

procedure TbjMrMc.SetGSTSetting;
begin
  FUpdate('Creating default GST ledgers...');
  if VchType = 'Sales' then
  begin
//    MstExp.VchType := 'Sales';
    MstExp.NewGst('GST Sales Exempted', 'Sales Accounts', '0');
    MstExp.NewGst('GST 3% Sales', 'Sales Accounts', '3');
    MstExp.NewGst('GST 5% Sales', 'Sales Accounts', '5');
//    MstExp.NewLedger('GST 5% Sales', 'Sales Accounts', 0);
    MstExp.NewGst('GST 12% Sales', 'Sales Accounts', '12');
    MstExp.NewGst('GST 18% Sales', 'Sales Accounts', '18');
    MstExp.NewGst('GST 28% Sales', 'Sales Accounts', '28');
    MstExp.NewGst('IGST Sales Exempted', 'Sales Accounts', '0');
    MstExp.NewGst('IGST 3% Sales', 'Sales Accounts', '3');
    MstExp.NewGst('IGST 5% Sales', 'Sales Accounts', '5');
    MstExp.NewGst('IGST 12% Sales', 'Sales Accounts', '12');
    MstExp.NewGst('IGST 18% Sales', 'Sales Accounts', '18');
    MstExp.NewGst('IGST 28% Sales', 'Sales Accounts', '28');

    MstExp.NewGst('Output SGST 1.5%', 'Duties & Taxes', '3');
    MstExp.NewGst('Output CGST 1.5%', 'Duties & Taxes', '3');
    MstExp.NewGst('Output IGST 3%', 'Duties & Taxes', '3');
    MstExp.NewGst('Output SGST 2.5%', 'Duties & Taxes', '5');
    MstExp.NewGst('Output CGST 2.5%', 'Duties & Taxes', '5');
    MstExp.NewGst('Output IGST 5%', 'Duties & Taxes', '5');
    MstExp.NewGst('Output SGST 6%', 'Duties & Taxes', '12');
    MstExp.NewGst('Output CGST 6%', 'Duties & Taxes', '12');
    MstExp.NewGst('Output IGST 12%', 'Duties & Taxes', '12');
    MstExp.NewGst('Output SGST 9%', 'Duties & Taxes', '18');
    MstExp.NewGst('Output CGST 9%', 'Duties & Taxes', '18');
    MstExp.NewGst('Output IGST 18%', 'Duties & Taxes', '18');
    MstExp.NewGst('Output SGST 14%', 'Duties & Taxes', '28');
    MstExp.NewGst('Output CGST 14%', 'Duties & Taxes', '28');
    MstExp.NewGst('Output IGST 28%', 'Duties & Taxes', '28');
  end;
  if VchType = 'Purchase' then
  begin
//    MstExp.VchType := 'Purchase';
    MstExp.NewGst('GST Purchase Exempted', 'Purchase Accounts', '0');
    MstExp.NewGst('GST 3% Purchase', 'Purchase Accounts', '3');
    MstExp.NewGst('GST 5% Purchase', 'Purchase Accounts', '5');
    MstExp.NewGst('GST 12% Purchase', 'Purchase Accounts', '12');
    MstExp.NewGst('GST 18% Purchase', 'Purchase Accounts', '18');
    MstExp.NewGst('GST 28% ', 'Purchase Accounts', '28');
    MstExp.NewGst('GST Purchase Exempted', 'Purchase Accounts', '0');
    MstExp.NewGst('IGST 3% Purchase', 'Purchase Accounts', '3');
    MstExp.NewGst('IGST 5% Purchase', 'Purchase Accounts', '5');
    MstExp.NewGst('IGST 12% Purchase', 'Purchase Accounts', '12');
    MstExp.NewGst('IGST 18% Purchase', 'Purchase Accounts', '18');
    MstExp.NewGst('IGST 28% ', 'Purchase Accounts', '28');

    MstExp.NewGst('Input SGST 1.5%', 'Duties & Taxes', '3');
    MstExp.NewGst('intput CGST 1.5%', 'Duties & Taxes', '3');
    MstExp.NewGst('input IGST 3%', 'Duties & Taxes', '3');
    MstExp.NewGst('input SGST 2.5%', 'Duties & Taxes', '5');
    MstExp.NewGst('input CGST 2.5%', 'Duties & Taxes', '5');
    MstExp.NewGst('input IGST 5%', 'Duties & Taxes', '5');
    MstExp.NewGst('input SGST 6%', 'Duties & Taxes', '12');
    MstExp.NewGst('input CGST 6%', 'Duties & Taxes', '12');
    MstExp.NewGst('input IGST 12%', 'Duties & Taxes', '12');
    MstExp.NewGst('input SGST 9%', 'Duties & Taxes', '18');
    MstExp.NewGst('input CGST 9%', 'Duties & Taxes', '18');
//    MstExp.NewGst('input IGST 18%', 'Duties &amp; Taxes', '18');
    MstExp.NewGst('input IGST 18%', 'Duties & Taxes', '18');
    MstExp.NewGst('input SGST 14%', 'Duties & Taxes', '28');
    MstExp.NewGst('input CGST 14%', 'Duties & Taxes', '28');
    MstExp.NewGst('input IGST 28%', 'Duties & Taxes', '28');
  end;
  if (VchType = 'Sales') or (VchType = 'Purchase') then
  begin
    MstExp.NewGst('SGST', 'Duties & Taxes', '12');
    MstExp.NewGst('CGST', 'Duties & Taxes', '12');
    MstExp.NewGst('IGST', 'Duties & Taxes', '12');
  end;
end;

procedure TbjMrMc.SetGstLedSetting(const doit: boolean);
begin
  FIsGSTSetting := True;
end;

procedure TbjMrMc.SetVchAction(const aAction: string);
begin
  FVchAction := aAction;
  VchExp.VchAction := VchAction;
end;
function RoundCurr(const Value: Currency): Currency;
var
  V64: Int64 absolute Result;
  Decimals: Integer;
begin
  Result := Value;
  Decimals := V64 mod 100;
  Dec(V64, Decimals);
  case Decimals of
    -99 .. -50 : Dec(V64, 100);
    50 .. 99 : Inc(V64, 100);
  end;
end;

end.

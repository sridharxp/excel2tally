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
unit MrMc73;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  DB,
  xlstbl,
  XlExp,
  Math,
  Client,
  ZS73,
  PClientFns,
  DateFns,
  XLSWorkbook,
  bjXml3_1;

{$DEFINE xlstbl}

Const
  PGLEN = 12;
  COLUMNLIMIT = 64;
  TallyAmtPicture = '############.##';

type
  Tfnupdate = procedure(const msg: string);


{ Declared refers to Xml rule; Defined refers to Template }
TbjMrMc = class(TinterfacedObject, IbjXlExp, IbjMrMc)
  private
    { Private declarations }
    FRefreshLedMaster: Boolean;
    FToLog: boolean;
    FToAutoCreateMst: boolean;
    FdynPgLen: integer;
    FVchType: string;
    FRoundOfftoNext: boolean;
    FIsMListDeclared: Boolean;
    FIsVListDeclared: Boolean;
    FIsExpItemMst: Boolean;
    FIsCheckLedMst: Boolean;
    FFirm: string;
    FHost: string;
  protected
    missingledgers: Integer;
    UIdstr: string;
    UIdint: integer;
    cfgn: IbjXml;
    cfg: IbjXml;
    xcfg: IbjXml;
    kadb: TbjXLSTable;
    IsIdOnlyChecked: boolean;
{ Default Values }
    DiDateValue: string;
    DiTypeValue: string;
    DiLedgerValue: array [1..COLUMNLIMIT] of String;
{ Non Default }
    NarrationColValue: string;
    NarrationCol2Value: string;
    NarrationCol3Value: string;
    DiRoundOff: string;
    RoundOffCol: string;
    RoundToLimit: Integer;

    RoundOffGroup: string;

    Amt: array [1..COLUMNLIMIT] of double;

{ COLUMNLIMIT - To limit looping  }
    IsLedgerDeclared: array [1..COLUMNLIMIT] of boolean;
    IsAmtDeclared: array [1..COLUMNLIMIT] of boolean;
{
    IsCrAmtDefined: array [1..COLUMNLIMIT] of boolean;
    IsDrAmtDefined: array [1..COLUMNLIMIT] of boolean;
}
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
    UAmount3Name: array [1..COLUMNLIMIT] of string;
  { Used for Row Ledgers Triggered only when alias is defined in template}
    UMstGroupName: string;
    UOBDrName: string;
    UOBCrName: string;
    LedgerGroup: array [1..COLUMNLIMIT] of string;
{ +1 for RoundOff }
    LedgerDict: array [1..COLUMNLIMIT + 1] of TList;
    IsGroupDeclared: array [1..COLUMNLIMIT + 1] of boolean;
    IsGSTNDeclared: array [1..COLUMNLIMIT + 1] of boolean;
    IsGSTNDefined: array [1..COLUMNLIMIT + 1] of boolean;
//    IsGSTApplicableDeclared: array [1..COLUMNLIMIT + 1] of boolean;
//    IsGSTApplicableDefined: array [1..COLUMNLIMIT + 1] of boolean;
    IsInvDefined: array [1..COLUMNLIMIT + 1] of boolean;
    UGSTNName: array [1..COLUMNLIMIT + 1] of string;
    UStateName: array [1..COLUMNLIMIT+1] of string;
    UGroupName: array [1..COLUMNLIMIT ] of string;
    UAliasName: string;
    UGodownName: string;
    UCategoryName: string;
    USubGroupName: string;
    IsIdDefined: boolean;
    IsDateDefined: boolean;
    IsVchNoDefined: boolean;
    IsVTypeDefined: boolean;
    IsVoucherRefDefined: boolean;
    IsVoucherDateDefined: boolean;
    IsBillRefDefined: boolean;
    IsItemDefined: boolean;
    IsHSNDefined: boolean;
    IsUnitDefined: boolean;
    IsAliasDefined: Boolean;
    IsGodownDefined: Boolean;
    IsCategoryDefined: Boolean;
    IsGroupDefined: Boolean;
    IsSubGroupDefined: Boolean;
    UDateName: string;
    UVTypeName: string;
    IsLedgerDefined: array [1..COLUMNLIMIT] of boolean;
    IsRoundOffColDefined: boolean;
//    IsGroupDefined: array [1..COLUMNLIMIT + 1] of boolean;
    IsAmtDefined: array [1..COLUMNLIMIT] of boolean;
    UNarrationName: string;
    UNarration2Name: string;
    UNarration3Name: string;
    UVchNoColName: string;
    UVoucherRefName: string;
    UVoucherDateName: string;
    UBillRefName: string;
    UTallyIDName: string;

    IsAssessableDefined: array [1..COLUMNLIMIT] of boolean;
    UAssessableName: array [1..COLUMNLIMIT] of string;

    InventoryTag: string;
    UItemName: string;
    UHSNName: string;
    UUnitName: string;
    UQtyName: string;
    URateName: string;
//    UItemAmtName: string;
    ToCheckInvCols: boolean;

{ if exosts value if not di}
    DateColValue: string;
    TypeColValue: string;

    IsAmt1Defined: boolean;
{
    IsCrAmt1Defined: boolean;
    IsDrAmt1Defined: boolean;
}
    IsNarrationDefined: boolean;
    IsNarration2Defined: boolean;
    IsNarration3Defined: boolean;
    IsTallyIdDefined: boolean;
    notoskip: integer;
    ProcessedCount: integer;
    UidName: string;
    IsIDGenerated: Boolean;
    VTotal: double;
    VchAction: string;
    DrAmtCol: string;
    CrAmtCol: string;
    DrAmtColType: string;
    CrAmtColType: string;
    IsCrDrAmtColsDefined: Boolean;
    RoundOffName: string;
    IsInventoryAssigned: Boolean;

//    bjEnv: TbjEnv;
    bjMstExp: TbjMstExp;
    bjVchExp: TbjVchExp;
    procedure DeclareColNames;
    procedure CheckColNames;
    procedure OpenFile;
    procedure GenerateID;
    procedure CheckLedMst;
    procedure ExpItemMst;
    procedure CreateRowLedgers;
    procedure CreateColLedgers;
    procedure CreateItem(const level: integer);
    procedure NewIdLine;
    procedure Process;
    procedure ProcessRow;
    procedure ProcessCol(const level: integer);
    procedure ProcessItem(const level: integer; InvAmt: double);
    function IsIDChanged: boolean;
    procedure GetDefaults;
    procedure WriteStatus;
    function GetLedger(const level: integer): string;
    function GetRoundOffName: string;
    function GetAmt(const level: integer): double;
    function IsMoreColumn(const level: integer): boolean;
    procedure CheckColumn(const colname: string);
//    procedure SetColumnFormat(const colname: string; const fmt:integer);
    procedure SetFirm(const aFirm: string);
    procedure SetHost(const aHost: string);
    function GetGSTState(const aGSTN: string): string;
    function GETDictToken(const ctr: integer): string;
    function GETDictValue(const ctr: integer): string;
    procedure Filter(aFailure: integer);
    procedure CreateGSTLedger;
    procedure SetGSTSetting;
  public
    { Public declarations }
    dbName: string;
    FileName: string;
    ReportFileName: string;
    XmlFile: string;
    XmlStr: string;
    FileFmt: string;
    IsMultiRowVoucher: boolean;
    IsMultiColumnVoucher: boolean;
    IsDateCheck: boolean;
    SCount: integer;
    FUpdate: TfnUpdate;
    DefGroup: string;

    ToSetGstSettings: Boolean;
    UdefStateName: string;
//    Host: string;
//    ToCreateMasters: boolean;
    bjEnv: TbjEnv;
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
  published
{ Logging is optional }
    property ToLog: boolean read FToLog write FToLog;
{ Auto Create Master is optional }
    property ToAutoCreateMst: boolean read FToAutoCreateMst write FToAutoCreateMst;
    property RefreshLedMaster: Boolean read FRefreshLedMaster write FRefreshLedMaster;
    property VchType: string read FVchType write FVchType;
    property IsMListDeclared: Boolean read FIsMListDeclared write FIsMListDeclared;
    property IsVListDeclared: Boolean read FIsVListDeclared write FIsVListDeclared;
    property IsCheckLedMst: Boolean read FIsCheckLedMst write FIsCheckLedMst;
    property IsExpItemMst: Boolean read FIsExpItemMst write FIsExpItemMst;
    property Firm: string read FFirm write setFirm;
    PROPERTY Host: string read FHost write SetHost;
    property RoundOfftoNext: boolean read FRoundOfftoNext write FRoundOfftoNext;
  end;

  TbjDSLParser = class
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{ Level refers to TokenCol }
{ Token Column can be separate from any Ledger column }
  TDict = Record
    TokenCol: string;
    Token: string;
    Value: String;
  end;
  pDict = ^TDict;

implementation

uses
  Datamodule;

Constructor TbjMrMc.Create;
var
  i: integer;
begin
  Inherited;
    bjEnv := TbjEnv.Create;
{  SetDebugMode; }
    bjEnv.ToSaveXmlFile := False;
    bjMstExp := TbjMstExp.Create;
    bjMstExp.bjEnv := bjEnv;
    bjEnv.bjMstExp := bjMstExp;
    bjVchExp := TbjVchExp.Create;
    bjVchExp.bjEnv := bjEnv;
    bjVchExp.bjMstExp := bjMstExp;
  xmlFile := copy(Application.ExeName, 1, Pos('.exe', Application.ExeName)-1) + '.xml';
  Cfgn := CreatebjXmlDocument;
{  UNarration := '';}
{  Amt1 := '';}
  notoskip := 0;
  ProcessedCount := 0;;
  UIdName := 'ID';
  LedgerTag := 'LEDGER';

  UOBDrName := 'O BAL Dr';
  UOBCrName := 'O BAL Cr';

  for i:= 1 to COLUMNLIMIT do
    ULedgerName[i] := 'LEDGER';
  for i:= 1 to COLUMNLIMIT do
    UAmountName[i] := 'AMOUNT';
  for i:= 1 to COLUMNLIMIT do
    AmountType[i] := 'Dr';
  UDateName := 'DATE';
  UVTypeName := 'VTYPE';
  UNarrationName := 'NARRATION';
  UVoucherRefName := 'Voucher Ref';
  UVoucherDateName := 'Voucher Date';
  UVchNoColName := 'VoucherNo';
  UBillRefName := 'Bill Ref';
  inventoryTag := 'INVENTORY';
  UItemName := 'Item';
  UHSNName := 'HSN';
  UUnitName := 'Unit';
  UQtyName := 'Qty';
  URateName := 'Rate';
  UAliasName := 'Alias';
  UGodownName := 'Godown';
  UCategoryName := 'Category';
  USubGroupName := 'SubGroup';
//  UItemAmtName := 'Value';
  UTallyIDName := 'TALLYID';
  UMstGroupName := 'GROUP';
  FRefreshLedMaster := False;
  FToLog := True;
  FToAutoCreateMst := True;
  FdynPgLen := PgLen + Random(16);
end;

destructor TbjMrMc.Destroy;
var
  i, j: integer;
  ditem: pDict;
begin
  bjVchExp.Free;
  bjMstExp.Free;
  bjEnv.Free;

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
  if Assigned(kadb) then
  if kadb.ToSaveFile then
    if Length(ReportFileName) > 0 then
      kadb.Save(ReportFileName);
  kadb.Free;
  Cfgn.Clear;
  inherited;
end;

procedure TbjMrMc.DeclareColNames;
var
  DataFolder: string;
  Database: string;
  VList: string;
  MList: string;
  str: string;
  i: integer;
  dcfg, xxcfg: IbjXml;
  dItem: pDict;
begin
  cfgn.LoadXML(XmlStr);
  cfg := Cfgn.SearchForTag(nil, 'Voucher');
  if not Assigned(cfg) then
    raise Exception.Create('Voucher Configuration not Found');
  xcfg := Cfg.SearchForTag(nil, 'Data');
  DataFolder := xcfg.GetChildContent('Folder');
  Database := xcfg.GetChildContent('Database');
  if Length(DataFolder + Database) <> 0 then
  if Length(dbName) = 0 then
    dbName := DataFolder + Database;
  VList  := xcfg.GetChildContent('VoucherList');
  if (Length(Vlist) > 0) then
  begin
    if Length(FileName) = 0 then
      FileName := VList;
    IsVListDeclared := True;
  end;
  MList  := xcfg.GetChildContent('MasterList');
  if (Length(MList) > 0) then
  begin
    if Length(FileName) = 0 then
      FileName := MList;
    IsMListDeclared := True;
  end;
{
AutoCreateMst affects default group only
}
  if FToAutoCreateMst  then
    DefGroup := xcfg.GetChildContent('DefaultGroup');
{ Round of tag moved from Ledger to Data }
  str := xcfg.GetChildContent('IsMultiRow');
   if  str = 'Yes' then
    IsMultiRowVoucher := True;
   str := xcfg.GetChildContent('IsMultiColumn');
  if  str = 'Yes' then
    IsMultiColumnVoucher := True;

//  str := xcfg.GetChildContent('DictCol');
//  if Length(str) > 0 then

//  if FToAutoCreateMst and (Length(DefGroup) > 0) then
  if (Length(DefGroup) > 0) then
    bjEnv.DefaultGroup := DefGroup
  else
    bjEnv.DefaultGroup := '';

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

    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
      RoundOffCol := str;
    str := xCfg.GetChildContent('Group');
    if Length(str) > 0 then
      RoundOffGroup := str;
    DiRoundOff := xCfg.GetChildContent('Default');
    str := xCfg.GetChildContent('RoundTo');
    if Length(str) > 0 then
      RoundToLimit := StrToInt(str);

    xxCfg := xcfg.SearchForTag(nil, 'GSTN');
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent('Alias');
//      RoundOffGSTN := str;
      UGSTNName[COLUMNLIMIT+1] := str;
      if Length(str) > 0 then
        IsGSTNDeclared[COLUMNLIMIT+1] := True;
    end;
  end;

  xCfg := Cfg.SearchForTag(nil, UVchNoColName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
    UVchNoColName := str;
  end;

  xCfg := Cfg.SearchForTag(nil, UDateName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
    begin
      UDateName := str;
    end;
    DiDateValue := xCfg.GetChildContent('Default');
  end;

  xCfg := Cfg.SearchForTag(nil, UVTypeName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
      UVTypeName := str;
    DiTypeValue := xcfg.GetChildContent('Default');
  end;

  xCfg := Cfg.SearchForTag(nil, 'CrAmtCol');
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent('Alias');
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
    str := xCfg.GetChildContent('Alias');
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
  xxCfg := xCfg.SearchForTag(nil, 'Alias');
  if xxCfg <> nil then
  begin
    str := xxCfg.GetContent;
    if Length(str) > 0 then
    begin
      UNarrationName  := str;
    end;
{ Unused Feature }
{ For Combining tow Narration Texts }
    xxCfg := xCfg.SearchForTag(xxCfg, 'Alias');
    if xxCfg <> nil then
    begin
      str := xxCfg.GetContent;
      if Length(str) > 0 then
      begin
        UNarration2Name  := str;
        IsNarration2Defined := True;
      end;
      xxCfg := xCfg.SearchForTag(xxCfg, 'Alias');
      if xxCfg <> nil then
      begin
        str := xxCfg.GetContent;
        if Length(str) > 0 then
        begin
          UNarration3Name  := str;
          IsNarration3Defined := True;
        end;
      end;
    end;
  end;
  end;

  xCfg := Cfg.SearchForTag(nil, UIdName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
    begin
      UIdName  := str;
    end;
    str := xCfg.GetChildContent('IsGenerated');
    if str = 'Yes' then
      IsIDGenerated  := True;
  end;

  xCfg := cfg.SearchForTag(nil, 'Voucher Ref');
  if Assigned(xCfg) then
  begin
    str := xCfg.GetContent;
    if Length(str) > 0 then
    begin
      UVoucherRefName := str;
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
      str := xCfg.GetChildContent('Alias');
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
        LedgerGroup[i] := xxCfg.GetContent;
        str := xxCfg.GetChildContent('Alias');
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
        str := xxCfg.GetChildContent('Alias');
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
//          ULedgerName[i] := str;
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
            UAmount2Name[i] := xxCfg.GetChildContent('Alias');
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
      str := xxCfg.GetChildContent('Alias');
      if Length(str) > 0 then
        UItemName := str;
    end;

    xxCfg := xcfg.SearchForTag(nil, UUnitName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent('Alias');
      if Length(str) > 0 then
      begin
        UUnitName := str;
      end;
    end;

    xxCfg := xCfg.SearchForTag(nil, UQtyName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent('Alias');
      if Length(str) > 0 then
        UQtyName := str;
    end;

    xxCfg := xCfg.SearchForTag(nil, URateName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent('Alias');
      if Length(str) > 0 then
        URateName := str;
    end;
{
    xxCfg := xCfg.SearchForTag(nil, UItemAmtName);
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetChildContent('Alias');
      if Length(str) > 0 then
        UItemAmtName := str;
    end;
}
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

{ Mandtory Minimum Columns }
  if not IsLedgerDeclared[1] then
    raise Exception.Create(ULedgerName[1] + ' Column is required');
//  if not IsAmtDeclared[1] then
//    raise Exception.Create(UAmountName[2] + ' Column is required');
end;

procedure TbjMrMc.OpenFile;
var
  flds: TStringList;
  idx: Integer;
begin
//  if Length(Host) > 0 then
//    SetHost(pchar(Host));
{ No try except ...
passing Windows Exception as it is }
  if not FileExists(dbName) then
    raise Exception.Create('File ' + dbname + ' not found');
{$IFDEF xlstbl}
  if FileFmt = 'Excel_Table' then
  begin
    kadb := TbjXLSTable.Create;
    kadb.XLSFileName := dbname;
//    kadb.ReportFileName := 'Tally.xls';
    kadb.SetSheet(Filename);
    kadb.ToSaveFile := True;
    if Assigned(FUpdate) then
      FUpdate('Reading '+ FileName);
    if Assigned(FUpdate) then
    FUpdate('Processing '+ FileName);
    flds := TStringList.Create;
    kadb.ParseXml(Cfgn, flds);
    if not flds.Find('ID', idx) then
    flds.Add('ID');
    flds.Add('TALLYID');
//    flds.Add('Tax_rate');
    kadb.GetFields(flds);
    flds.Free;
  end;
{$ENDIF}
  kadb.First;
  if kadb.Eof then
    raise Exception.Create('Table is Empty');;
end;

procedure TbjMrMc.Execute;
var
  StatusMsg: string;
begin
  ProcessedCount := 0;
  DeclareColNames;
  OpenFile;
  if Length(Host) > 0 then
    bjEnv.Host := Host;
  CheckColNames;
  if FRefreshLedMaster then
    bjMstExp.RefreshMstLists;

  kadb.First;
  UIdstr := '';
  vTotal := 0;
  while (not kadb.Eof)  do
  begin
    GenerateID;
    CheckLedMst;
    ExpItemMst;
    if IsMultiRowVoucher then
      CreateRowLedgers;
    if IsMultiColumnVoucher then
      CreateColLedgers;
    kadb.Next;
  end;
  if IsMListDeclared then
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
  kadb.First;
  UIdstr := '';
  kadb.First;
  vTotal := 0;
  NewIdLine;
  IsIdOnlyChecked := True;
{ Make sure id is empty }
  while (not kadb.Eof)  do
  begin
    IsInventoryAssigned := False;
    if IsIdDefined then
    begin
      if (kadb.IsEmptyField(UIdName)) then
        break;
    end
    else
    begin
{ or otherwise Make sure date is empty }
      if not IsMultiRowVoucher then
        if IsDateDefined then
          if (kadb.IsEmptyField(UDateName)) then
            break;
    end;
    Process;
    if IsIdOnlyChecked then
      Continue;
    kadb.Next;
    if not kadb.Eof then
      notoskip := notoskip + 1;
  end;
  WriteStatus;
  MessageDlg(InttoStr(ProcessedCount) + ' Vouchers processed',
      mtInformation, [mbOK], 0);

    StatusMsg := InttoStr(ProcessedCount) + ' Vouchers processed; ' +
    InttoStr(SCount) + ' Success. Check Tally.xls'
  FUpdate(StatusMsg);
  Filter(ProcessedCount - SCount);
end;

procedure TbjMrMc.Process;
var
  FoundNewId: boolean;
begin
  FoundNewId :=  IsIDChanged;
  if not FoundNewId then
  begin
    ProcessRow;
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
  LedgerColvalue := Getledger(1);
  Amt[1] := GetAmt(1);
  if Abs(Amt[1]) >= 0.01 then
  begin
    bjVchExp.AddLine(LedgerColValue, RoundTo(Amt[1], -2));
    if IsAssessableDefined[1] then
      bjVchExp.SetAssessable(kadb.GetFieldFloat(UAssessableName[1]));
//    VTotal := VTotal + StrtoFloat(FormatFloat(TallyAmtPicture, Amt[1]));
    VTotal := VTotal + RoundTo(Amt[1],-2);
    ProcessItem(1, RoundTo(Amt[1], -2));
  end;
  if IsMultiColumnVoucher then
    ProcessCol(2);
end;

procedure TbjMrMc.ProcessCol(const level: integer);
var
  LedgerColValue: string;
begin
  if not IsLedgerDeclared[level] then
      Exit;
  LedgerColValue := GetLedger(level);
  if Length(LedgerColValue) = 0 then
    exit;

  amt[level] := GetAmt(level);
  if abs(Amt[level]) >= 0.01 then
  begin
    bjVchExp.AddLine(LedgerColValue, RoundTo(Amt[level], -2));
    if IsAssessableDefined[level] then
      bjVchExp.SetAssessable(kadb.GetFieldFloat(UAssessableName[level]));
    VTotal := VTotal + RoundTo(Amt[level], -2);
    ProcessItem(level, RoundTo(Amt[level], -2));
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

procedure TbjMrMc.ProcessItem(const level: integer; InvAmt: double);
var
//  invamt: Double;
  ItemColValue: string;
begin
  if not  IsInvDefined[level] then
    Exit;
  if IsInventoryAssigned then
    Exit;
  if not IsItemDefined then
    Exit;
  if kadb.IsEmptyField(UItemName) then
    Exit;
  if kadb.IsEmptyField(UQtyName) then
    Exit;
//    invamt := kadb.GetFieldFloat(UItemAmtName);
{ InvAmt for Purchase }
//if AmountType[level] = 'Dr' then
//  invamt := -invamt;
  ItemColValue := kadb.GetFieldString(UItemName);
  if (Length(ItemColValue) > 0) and
    (not kadb.IsEmptyField(UQtyName)) then
    bjVchExp.SetInvLine(ItemColValue,
    kadb.GetFieldFloat(UQtyName),
    kadb.GetFieldFloat(URateName),
    invamt);
  IsInventoryAssigned := True;
  bjVchExp.InvVch := True;
  RoundOfftoNext := True;
end;

{ Validation of Table Columns in Excel
  Creation of Default Ledgers }
procedure TbjMrMc.CheckColNames;
var
  i, j: integer;
  dItem: pDict;
  str: string;
  strMsg: string;
  LedgerColValue: string;
  DeclaredLedgers: integer;
begin
  DeclaredLedgers := 0;
  if kadb.FindField(UIdName) <> nil then
  begin
    IsIdDefined := True;
    IsMultiRowVoucher := True;
  end;
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
  if kadb.FindField(UItemName) <> nil then
    IsItemDefined := True;
  if kadb.FindField(UHSNName) <> nil then
    IsHSNDefined := True;
  if kadb.FindField(UUnitName) <> nil then
    IsUnitDefined := True;
  if kadb.FindField(UAliasName) <> nil then
    IsAliasDefined := True;
  if kadb.FindField(UGodownName) <> nil then
    IsGodownDefined := True;
  if kadb.FindField(UCategoryName) <> nil then
    IsCategoryDefined := True;
  if kadb.FindField(UMstGroupName) <> nil then
    IsGroupDefined := True;
  if kadb.FindField(USubGroupName) <> nil then
    IsSubGroupDefined := True;
{ Check for TallyId }
  if kadb.FindField(UTallyIDName) <> nil then
    IstALLYidDefined := True
  else
    MessageDlg('Column TallyID is not found', mtError, [mbNo], 0);

{ Fill IsAmtDeclared array
  Needed for Default Amount }
  for j := 1 to COLUMNLIMIT do
    begin
      if kadb.FindField(UAmountName[j]) <> nil then
      begin
        IsAmtDefined[j] := True;
      end;
    end;

{ if a Column is defined it should exist in Table }
  for j := 1 to COLUMNLIMIT do
  begin
      if kadb.FindField(ULedgerName[j]) <> nil then
        IsLedgerDefined[j] := True;
      if IsLedgerDeclared[j] then
        DeclaredLedgers := j;
      end;
  if kadb.FindField(RoundOffCol) <> nil then
    IsRoundOffColDefined := True;

  for i := 0 to kadb.FieldList.Count-1 do
  begin
    str := kadb.FieldList[i];
    if copy(str, 1,3) = 'Cr_' then
    begin
      DeclaredLedgers := DeclaredLedgers + 1;
      IsLedgerDeclared[DeclaredLedgers] := True;
      DiLedgerValue[DeclaredLedgers] := copy(str, 4, Length(str)-3);
      IsAmtDefined[DeclaredLedgers] := True;
      UAmountName[DeclaredLedgers] := str;
      AmountType[DeclaredLedgers] := 'Cr';
      bjMstExp.NewLedger(DiLedgerValue[DeclaredLedgers], 'Indirect Incomes', 0);
    end;
    if copy(str, 1,3) = 'Dr_' then
    begin
      DeclaredLedgers := DeclaredLedgers + 1;
      IsLedgerDeclared[DeclaredLedgers] := True;
      DiLedgerValue[DeclaredLedgers] := copy(str, 4, Length(str)-3);
      IsAmtDefined[DeclaredLedgers] := True;
      UAmountName[DeclaredLedgers] := str;
      AmountType[DeclaredLedgers] := 'Dr';
      bjMstExp.NewLedger(DiLedgerValue[DeclaredLedgers], 'Indirect Expenses', 0);
    end;
  end;
//  if IsMultiRowVoucher then
//    CheckColumn(UIdName);
  if Length(DiLedgerValue[1]) = 0 then
  CheckColumn(ULedgerName[1]);
  if not IsMListDeclared then
  begin
    if Length(DiDateValue) = 0 then
      CheckColumn(UDateName);
//    SetColumnFormat(UDateName, kadb.IDate);
    if Length(DiTypeValue) = 0 then
      if not IsVtypeDefined then
      CheckColumn(UVTypeName);
  end;
  if ToCheckInvCols then
    if IsItemDefined then
    begin
      CheckColumn(UQtyName);
      CheckColumn(URateName);
//      CheckColumn(UItemAmtName);
    end;
  for i := 1 to COLUMNLIMIT+1 do
  begin
        if IsGSTNDeclared[i] then
          if kadb.FindField(UGSTNName[i]) <> nil then
          begin
            IsGSTNDefined[i] := True;
            if not IsLedgerDefined[i] then
              raise Exception.Create('Check CreateColLedgers');
          end;
  end;
  SetGSTSetting;
//  if IsUnitDefined then
//      CheckColumn(UUnitName);
//Shifted from top
// Ledger Creation should be done only when necessary
  SetLength(strMsg, 50);
{ Create Default Ledgers }
  for i := 1 to COLUMNLIMIT do
  begin
    if (Length(LedgerGroup[i]) > 0) then
{ Default Ledger with Amount Column }
      if (Length(DiLedgerValue[i]) > 0) then
        bjMstExp.NewLedger(DiLedgerValue[i], LedgerGroup[i], 0);
  end;
  if Length(RoundOffGroup) > 0 then
{To fix Tin no bug with Round off col }
     if Length(DiRoundOff) > 0 then
       bjMstExp.NewLedger(DiRoundOff, RoundOffGroup, 0);

{ Create Dictionary Ledgers }
{ +1 for RoundOff }
   for i := 1 to COLUMNLIMIT do
   begin
     if Assigned(LedgerDict[i]) then
       for j := 0 to LedgerDict[i].Count-1 do
       begin
         ditem := LedgerDict[i].Items[j];
         if (Length(LedgerGroup[i]) > 0) then
         begin
           bjMstExp.VchType := VchType;
           LedgerColValue := pDict(dItem)^.Value;
           bjMstExp.NewGST(LedgerColValue, LedgerGroup[i], pDict(dItem)^.Token);
         end;
       end;
   end;
  if Assigned(LedgerDict[COLUMNLIMIT+1]) then
    for j := 0 to LedgerDict[COLUMNLIMIT+1].Count-1 do
    begin
      ditem := LedgerDict[COLUMNLIMIT+1].Items[j];
      if (Length(RoundOffGroup) > 0) then
      begin
        LedgerColValue := pDict(dItem)^.Value;
        bjMstExp.NewLedger(LedgerColValue, RoundOffGroup, 0);
      end;
    end;
//  if RoundToLimit > 0 then
//    if (Pos('Sale', TypeColValue) > 0) or (Pos('Purc', TypeColValue) > 0)then
    bjMstExp.NewLedger('RoundOff', 'Indirect Expenses', 0);
end;

procedure TbjMrMc.CreateColLedgers;
var
  i: integer;
  StateColValue: string;
  LedgerColValue: string;
  GroupColValue: string;
  GSTNColValue: string;
  atoken: string;
begin
{
AutoCreateMst does not affect explicit group or roundoff group
}
  for i:= 1 to COLUMNLIMIT do
  begin
    if Length(UGroupName[i]) > 0 then
      GroupColValue := kadb.GetFieldString(UGroupName[i]);
    if Length(GroupColValue) = 0 then
        GroupColValue := LedgerGroup[i];
    if Length(GroupColValue) > 0 then
    begin
      if IsLedgerDefined[i] then
      begin
        LedgerColValue := kadb.GetFieldString(ULedgerName[i]);
        if Length(LedgerColValue) = 0 then
          Continue;
        if IsGSTNDefined[i] then
        begin
          GSTNColValue := kadb.GetFieldString(UGSTNName[i]);
          StateColValue := GetGSTState(GSTNColValue);
          bjMstExp.NewParty(LedgerColValue, GroupColValue, GSTNColValue,
            StateColValue);
        end
        else if IsLedgerDefined[i] then
        begin
            atoken := GetDictToken(i);
            bjMstExp.VchType := VchType;
            if Length(aToken) > 0 then
            bjMstExp.NewGST(LedgerColValue, GroupColValue, aToken)
        else
            bjMstExp.NewLedger(LedgerColValue, GroupColValue, 0);
            FUpdate(LedgerColValue);
        end;
      end;
    end;
  end;
  for i := 1 to COLUMNLIMIT do
    if (Length(LedgerGroup[i]) > 0) then
      if IsLedgerDefined[i] then
        CreateItem(i);

  if Length(RoundOffGroup) > 0 then
    if IsRoundOffColDefined then
    begin
      LedgerColValue := kadb.GetFieldString(RoundOffCol);
      if IsGSTNDefined[COLUMNLIMIT + 1] then
      begin
        GSTNColValue := kadb.GetFieldString(UGSTNName[COLUMNLIMIT+1]);
        StateColValue := GetGSTState(GSTNColValue);
        bjMstExp.NewParty(LedgerColValue, RoundOffGroup, GSTNColValue,
        StateColValue);
      end
      else
        bjMstExp.NewLedger(LedgerColValue, RoundOffGroup, 0);
      FUpdate(LedgerColValue);
    end;
end;

procedure TbjMrMc.CreateItem(const level: integer);
var
  UnitColValue: string;
  ItemColValue: string;
  HSNColValue: string;
  GRate: string;
begin
  if not IsInvDefined[level] then
    Exit;
  if not IsItemDefined then
    Exit;
  ItemColValue := kadb.GetFieldString(UItemName);
  if not IsUnitDefined then
  begin
    bjMstExp.NewUnit('NOs');
    UnitColValue := 'Nos';
  end
  else
  begin
    UnitColValue := kadb.GetFieldString(UUnitName);
    bjMstExp.NewUnit(UnitColValue);
  end;
  if IsHSNDefined then
  begin
    HSNColValue := kadb.GetFieldString('HSN');
    GRate := kadb.GetFieldString('Tax_rate');
    bjMstExp.NewHSN(ItemColValue, UnitColValue, HSNColValue, GRate);
  end
  else
    bjMstExp.NewItem(ItemColValue,
    UnitColValue , 0, 0);
end;

procedure TbjMrMc.GenerateID;
begin
  if not IsIDGenerated then
    Exit;

  if (vTotal = 0) and (kadb.GetFieldFloat(CrAmtCol) +
    kadb.GetFieldFloat(DrAmtCol) > 0) then
    uIdstr :=  IntToStr(kadb.CurrentRow);
  if kadb.IsEmptyField('ID') then
  begin
    kadb.SetFieldVal('ID', uidStr);
  end;
  vTotal := vTotal + kadb.GetFieldFloat(CrAmtCol) -
              kadb.GetFieldFloat(DrAmtCol);
end;

procedure TbjMrMc.CheckLedMst;
var
  dbkLed, wLed, dbGSTN, wGSTN: string;
  IsThere: boolean;
  dbAlias: string;
  OBal: double;
begin
  if not IsMListDeclared then
    Exit;
  if not IsCheckLedMst then
    Exit;
  kadb.SetFieldVal('TALLYID', ' - ');
  OBal := kadb.GetFieldFloat('O_Balance');
  bjMstExp.OBal := OBal;
  if IsLedgerdefined[1] then
  dbkLed := kadb.GetFieldString('Ledger');
  if IsAliasDefined then
  begin
    dbAlias := kadb.GetFieldString(UAliasName);
    bjMstExp.Alias := dbAlias;
  end;
  if Length(dbkLed) > 0 then
  begin
  IsThere := bjMstExp.IsLedger(dbkLed);
  if not IsThere  then
  begin
  if MessageDlg('Create missing Ledger ' + dbkLed +'?', mtConfirmation, mbOKCancel, 0) = mrCancel then
    ToAutoCreateMst := False
  else
    ToAutoCreateMst := True;
  end;
  if not IsThere  then
  begin
    if not ToAutoCreateMst then
    begin
    kadb.SetFieldVal('TALLYID', 'New Ledger');
    missingledgers := missingledgers + 1;
    end
    else
    CreateGSTLedger;
  end
  else
  if IsGSTNDefined[1] then
  if not kadb.IsEmptyField('GSTN') then
  begin
    wGSTN := GetLedgersGSTN(dbkLed);
    if Length(wGSTN) = 0 then
    begin
      kadb.SetFieldVal('TALLYID', 'Update GSTN');
    end;
    dbGSTN := kadb.GetFieldString('GSTN');
    wLed := GetGSTNsLedger(dbGSTN);
    if dbGSTN <> wGSTN then
      kadb.SetFieldVal('TALLYID', 'New GSTN - Repeat Name');
    if dbkLed <> wLed then
      kadb.SetFieldVal('TALLYID', wLed + ' - Repeat GSTN');
  end;
  end;
{
  dbUnit := kadb.FieldByName('Unit').AsString;
  if Length(dbunit) > 0 then
  begin
    bjMstExp.NewUnit(PChar(dbUnit));
    dbItem := kadb.FieldByName('Item').AsString;
    if Length(dbItem) > 0 then
    begin
      bjMstExp.NewItem(PChar(dbItem), PChar(dbUnit), 0, 0);
    end;
  end;
}
end;

procedure TbjMrMc.ExpItemMst;
var
  dbItem, dbUnit: string;
  dbAlias, dbGodown, dbParent, dbCategory: string;
  dbHSN: string;
  OBal, ORate: Double;
  GRate: string;
begin
  if not IsMListDeclared then
    Exit;
  if not IsExpItemMst then
    Exit;
  dbUnit := '';
  if IsUnitDefined then
  begin
    dbUnit := kadb.GetFieldString('Unit');
    bjMstExp.NewUnit(dbUnit);
  end;
  if IsAliasDefined then
  begin
    dbAlias := kadb.GetFieldString(UAliasName);
    bjMstExp.Alias := dbAlias;
  end;
  if IsGodownDefined then
  begin
    dbGodown := kadb.GetFieldString('Godown');
    bjMstExp.NewGodown(dbGodown,'');
    bjMstExp.Godown := dbGodown;
  end;
  if IsCategoryDefined then
  begin
    dbCategory := kadb.GetFieldString('Category');
    bjMstExp.NewCategory(dbCategory,'');
    bjMstExp.Category := dbCategory;
  end;
  if IsGroupDefined then
  begin
    dbParent := kadb.GetFieldString('Group');
    bjMstExp.NewItemGroup(dbParent,'');
    bjMstExp.Group := dbParent;
  end;
  if IsSubGroupDefined then
  begin
    dbParent := kadb.GetFieldString('SubGroup');
    if Length(dbParent) > 0 then
      bjMstExp.NewItemGroup(dbParent,
        kadb.GetFieldString('Group'));
      bjMstExp.Group := dbParent;
  end;
  dbItem := kadb.GetFieldString('Item');
  OBal := kadb.GetFieldFloat('O_Balance');
  ORate := kadb.GetFieldFloat('O_Rate');
  GRate := kadb.GetFieldString('GSTRate');
  bjMstExp.OBal := OBal;
  bjMstExp.ORate := ORate;
  if IsHSNDefined then
    begin
    dbHSN := kadb.GetFieldString('HSN');
      bjMstExp.OBal := OBal;
      bjMstExp.ORate := ORate;
      bjMstExp.NewHSN(dbItem, dbUnit, dbHSN, GRate);
    end
    else
      bjMstExp.NewItem(dbItem, dbUnit, OBal, ORate);
end;

procedure TbjMrMc.CreateRowLedgers;
var
  OB: double;
  StateColValue: string;
  LedgerColValue: string;
  GroupColValue: string;
  GSTNColValue: string;
begin
  OB := 0;
  if not IsGroupDeclared[1] then
    Exit;
{
// Removing OB
  if kadb.FindField(UOBCrName) <> nil then
    if Length(kadb.FieldByName(UOBCrName).AsString) > 0 then
      OB := kadb.FieldByName(UOBCrName).AsFloat;
  if kadb.FindField(UOBDrName) <> nil then
    if Length(kadb.FieldByName(UOBDrName).AsString) > 0 then
      OB := OB - kadb.FieldByName(UOBDrName).AsFloat;
}
{
AutoCreateMst does not affect explicit group or roundoff group
}
  if not kadb.IsEmptyField(UGroupName[1]) then
  begin
    LedgerColValue := kadb.GetFieldString(ULedgerName[1]);
    GroupColValue := kadb.GetFieldString(UGroupName[1]);
    if IsGSTNDefined[1] then
    begin
      GSTNColValue := kadb.GetFieldString(UGSTNName[1]);
      StateColValue := GetGSTState(GSTNColValue);
      bjMstExp.NewParty(LedgerColValue,
        GroupColValue,
        GSTNColValue,
        StateColValue)
    end
    else
      bjMstExp.NewLedger(LedgerColValue,
        GroupColValue, OB);
    FUpdate(LedgerColValue);
  end;
end;

procedure TbjMrMc.NewIdLine;
var
  TId: string;
begin
  if IsIdDefined then
    UIdstr := kadb.GetFieldString(UIdName);
  UIdint := kadb.CurrentRow;
  GetDefaults;
  TID := '';
{
//  Alter is not an Option
  if IsTallyIdDefined then
//  if kadb.FindField('TALLYID') <> nil then
  if Length(kadb.FieldByName('TALLYID').AsString) > 0 then
  begin
    TID := GetFieldstr(kadb.FieldByName('TALLYID'));
  vchAction := 'Alter';
    sint := StrtoInt(tid);
    TId := InttoHex(sint, 8);
  end;
}
{ Let VchUpdate generate random id in case of no id }
{ Natural no as id would interfere will Tall's logic in some versions }
//  StartVch(pchar(tid), pchar(DateColValue),
//  pchar(typeColValue), pchar(NarrationColValue));
//  if kadb.FindField('Voucher No') <> nil then
//    bjVchExp.VchNo(pChar(kadb.FieldByName('Voucher No').AsString));
//  if Length(UVchNoColName) > 0 then
  If IsVchNoDefined then
  bjVchExp.VchNo := kadb.GetFieldString(UVchNoColName);

  if IsVoucherRefDefined then
    bjVchExp.VchRef := kadb.GetFieldString(UVoucherRefName);
  if IsVoucherDateDefined then
  begin
    bjVchExp.Vch_Date := kadb.GetFieldSDate(UVoucherDateName);
    bjVchExp.VchRefDate := kadb.GetFieldSDate(UDateName);
  end;
  if IsBillRefDefined then
    bjVchExp.BillRef := kadb.GetFieldString(UBillRefName);
  bjVchExp.VchNarration := NarrationColValue;
  bjVchExp.vchDate := DateColValue;
  bjVchExp.VchType := typeColValue;
  bjVchExp.VchID := tid;
  RoundOffName := GetRoundOffName;
  notoskip := 0;
end;

{***}
procedure TbjMrMc.GetDefaults;
begin
{  GetSingleValues; }
  DateColValue := '';
  if IsDateDefined then
    if not kadb.IsEmptyField(UDateName) then
    DateColValue := kadb.GetFieldSDate(UDateName);
{
  if Length(DateColValue) = 0 then
    DateColValue := DiDateValue;
}
  if IsVtypeDefined then
{ Find if user set has Voucher type }
    TypeColValue := kadb.GetFieldString(UVTypeName);
{ For reusing Templates }
  if Length(TypeColValue) = 0 then
    TypeColValue := FVchType;
{ With VchType this should not be needed }
  if Length(TypeColValue) = 0 then
    TypeColValue := DiTypeValue;
{
  Bank has only two types
  Daybook has all types
  VchUpdate has defaults to Voucher Type Journal
}
  if IsCrDrAmtColsDefined then
  begin
//    if not kadb.IsEmptyField(CrAmtCol) then
    if kadb.GetFieldFloat(CrAmtCol) > 0 then
      if Length(CrAmtColType) > 0 then
        TypeColValue := CrAmtColType;
//    if not kadb.IsEmptyField(DrAmtCol) then
    if kadb.GetFieldFloat(DrAmtCol) > 0 then
      if Length(DrAmtColType) > 0 then
        TypeColValue := DrAmtColType;
  end;
  if IsNarrationDefined then
    NarrationColValue := kadb.GetFieldString(UNarrationName);

  if IsNarration2Defined then
  if kadb.FindField(UNarration2Name) <> nil then
    NarrationColValue := NarrationColValue + kadb.GetFieldString(UNarration2Name);
  if IsNarration3Defined then
  if kadb.FindField(UNarration3Name) <> nil then
    NarrationColValue := NarrationColValue + kadb.GetFieldString(UNarration3Name);
end;

{
Id can be determined with date and voucher total.
If there is demand...
}
function TbjMrMc.IsIDChanged: boolean;
begin
  Result := False;
  if IsIdDefined then
    if (kadb.GetFieldString(UIdName) <> UIdstr) then
      Result  := True;

  if not IsMultiRowVoucher then
    if kadb.CurrentRow <> uidint then
      Result := True;
{
  Date check is for end of file only
}
end;


function TbjMrMc.GetLedger(const level: integer): string;
var
  lstr: string;
//  i: integer;
//  Item: pDict;
begin
  if IsLedgerDefined[level] then
  begin
    if not kadb.IsEmptyField(ULedgerName[level]) then
      lstr := kadb.GetFieldString(ULedgerName[level]);
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
{
  if Assigned(LedgerDict[level]) then
  begin
    for i := 0 to LedgerDict[level].Count-1 do
    begin
      Item := LedgerDict[level].Items[i];
      if pDict(Item)^.Token = kadb.GetFieldString(pDict(Item)^.TokenCol) then
      begin
        lstr := pDict(Item)^.Value;
        break;
      end;
    end;
}
  lstr := GetDictValue(level);
  if Length(lstr) > 0 then
  begin
    Result := lstr;
    Exit;
  end;
//  end;
  if Length(lstr) = 0 then
    Result := DiLedgerValue[level];
end;

{ Modifies Amtount according to Voucher Types to +ve or -ve }
function TbjMrMc.GetAmt(const level: integer): double;
begin
  Result := 0;
{
  IsMultiRow with Cr Dr Columns
  or
  IsMultiCol with CR Dr Columns
  Cr Dr Col Amt code is exeception to normal logic
  So exit is used
}
  if IsCrDrAmtcolsDefined then
  begin
    if (level = 1) or (level = 2)  then
    begin
      if not kadb.IsEmptyField(DrAmtCol) then
      if kadb.GetFieldFloat(DrAmtCol) <> 0 then
        Result := -kadb.GetFieldFloat(DrAmtCol);
      if not kadb.IsEmptyField(CrAmtCol) then
      if kadb.GetFieldFloat(CrAmtCol) <> 0 then
        Result := kadb.GetFieldFloat(CrAmtCol);
      if (level = 2)  then
        Result := -Result;
    end;
    Exit;
  end;
{ IsMultiCol }
//  if IsAmtDeclared[level] then
  if IsAmtDefined[level] then
  begin
    if not kadb.IsEmptyField(UAmountName[level]) then
    begin
//      Result := StrtoFloat(kadb.FieldByName(UAmountName[level]).AsString);
//      Result := kadb.FieldByName(UAmountName[level]).AsFloat;
      Result := kadb.GetFieldFloat(UAmountName[level]);
      if AmountType[level] = 'Dr' then
//        Result := - StrtoFloat(kadb.FieldByName(UAmountName[level]).AsString);
        Result := - kadb.GetFieldFloat(UAmountName[level]);
{      Exit;}
    end;
    if AmountCols[level] > 1 then
    begin
      if not kadb.IsEmptyField(UAmount2Name[level]) then
      begin
        if Amount2Type[level] = 'Cr' then
          Result := Result + kadb.GetFieldFloat(UAmount2Name[level]);
        if Amount2Type[level] = 'Dr' then
          Result := Result - kadb.GetFieldFloat(UAmount2Name[level]);
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
  if IsLedgerDeclared[i+1] then
  begin
    Result := True;
    break;
  end;
{
  if Assigned(LedgerDict[i+1]) then
  begin
    Result := True;
    break;
  end;
}
  end;
end;

function TbjMrMc.GetRoundOffName: string;
var
//  i: integer;
//  Item: pDict;
  lStr: string;
begin
  Result := '';
  if IsRoundOffColDefined then
  begin
    if not kadb.IsEmptyField(RoundOffCol) then
      lstr := kadb.GetFieldString(RoundOffCol);
    if Length(lstr) > 0 then
    begin
      Result := lstr;
      Exit;
    end;
  end;
{
Depending on token in one column 1 RoundOff ledger is derived
}
{
  if Assigned(LedgerDict[COLUMNLIMIT+1]) then
  begin
    for i := 0 to LedgerDict[COLUMNLIMIT+1].Count-1 do
    begin
      Item := LedgerDict[COLUMNLIMIT+1].Items[i];
      if pDict(Item)^.Token = kadb.GetFieldString(pDict(Item)^.TokenCol) then
      begin
        lStr := pDict(Item)^.Value;
        break;
      end;
    end;
}
    lstr := GetDictValue(COLUMNLIMIT+1);
    if Length(lstr) > 0 then
    begin
      Result := lstr;
      Exit;
    end;
//  end;
  if Length(DiRoundOff) > 0 then
    Result := DiRoundOff;
end;

procedure TbjMrMc.WriteStatus;
var
  i: integer;
  statmsg: string;
//ErrStr: string;
  RoundOffAmount: Double;
begin
  RoundOffAmount := Round(Vtotal) - VTotal;
  if RoundOffAmount < 0 then
  if (VchType = 'Sales') or (VchType = 'Purchase') then
  if RoundOfftoNext then
  begin
    RoundOffAmount := RoundOffAmount + 1;
    VTotal := VTotal + RoundOffAmount;
  end;
//  CheckErrStr := '(FOR OBJECT: ';
  vchAction := 'Create';
  if Abs(VTotal) >= 0.01 then
  begin
    if RoundToLimit > 0 then
    begin
    bjVchExp.AddLine(RoundOffName, - Round(VTotal));
      bjVchExp.AddLine('RoundOff', RoundOffAmount);
    end
    else
      bjVchExp.AddLine(RoundOffName, - VTotal);
//      AddLine('RoundOff', - RoundOffAmount)
  end;
//  StatMsg := TryPost(pChar(VchAction));
{
  TempStr := TryPost(pChar(VchAction));
  SetLength(statmsg, Length(TempStr)+1);
  StrCopy(PChar(StatMsg), TempStr);
  dllRelease(TempStr);
}
  StatMsg := bjVchExp.Post(VchAction, True);
//  ErrStr := GetErrStr(statmsg);
//  if Length(ErrStr) > 0 then
//    StatMsg := ErrStr;
  VTotal := 0;
  if Assigned(FUpdate) then
      FUpdate('Status: ' + Statmsg);
  ProcessedCount := ProcessedCount + 1;

  for i := 1 to notoskip do
    kadb.Prior;
  if ToLog then
  if isTallyIdDefined then
    kadb.SetFieldVal('TALLYID', statmsg);
{
{
    if IsErr then
    begin
      MessageDlg('Error on row no: ' + InttoStr(kadb.CurrentRow + 1),
        mtError, [mbOK],0);
      Abort;
    end;
}
  for i := 1 to notoskip do
    kadb.Next;
  notoskip := 0;
  if (Length(StatMsg) > 0 ) and (Length(StatMsg) < 9 )then
    if StatMsg <> '0' then
      SCount := Scount + 1;
end;
{
Amount column is mandatory Where Ledger is defined
Other Columns when not defined relevent code is skipped
}
procedure TbjMrMc.CheckColumn(const colname: string);
begin
  if kadb.FindField(ColName) = nil  then
  raise Exception.Create(Colname + ' column is Required')
end;
{
procedure TbjMrMc.SetColumnFormat(const colname: string; const fmt:integer);
var
aCol: TColumn;
begin
    aCol := kadb.GetFieldObj(ColName);
    if Assigned(aCol) then
    aCol.FormatStringIndex := fmt;
end;
}
procedure TbjMrMc.SetFirm(const aFirm: string);
begin
  FFirm := aFirm;
  bjEnv.Firm := aFirm;
end;

procedure TbjMrMc.SetHost(const aHost: string);
begin
  FHost := aHost;
  if not Assigned(ClientFns) then
     ClientFns := TbjGSTClientFns.Create;
  ClientFns.Host := Host;
  bjEnv.Host := Host;
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
begin
  if not Assigned(LedgerDict[ctr]) then
  Exit;
  for i := 0 to LedgerDict[ctr].Count-1 do
  begin
    Item := LedgerDict[ctr].Items[i];
    if pDict(Item)^.Token = Trim(kadb.GetFieldString(pDict(Item)^.TokenCol)) then
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
begin
  if not Assigned(LedgerDict[ctr]) then
  Exit;
  for i := 0 to LedgerDict[ctr].Count-1 do
  begin
    Item := LedgerDict[ctr].Items[i];
    if (pDict(Item)^.Token = Trim(kadb.GetFieldString(pDict(Item)^.TokenCol))) then
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
  if (aFailure = 0) then
    Exit;
  if MessageDlg('Copy Unposted only to Tally.xls?', mtWarning, mbYesNoCancel, 0) <> mrYes then
    Exit;
  inErr := True;
  kadb.First;
  while not kadb.EOF do
  begin
    if kadb.IsEmptyField('TallyID')  then
    if not inErr then
    begin
      kadb.Delete;
      Continue;
    end;

    if not kadb.IsEmptyField('TallyID') then
      if kadb.GetFieldFloat('TallyID') >  0 then
      begin
        inErr := False;
        kadb.Delete;
        Continue;
      end
      else
        inErr := True;
    kadb.Next;
  end;
end;

procedure TbjMrMc.CreateGSTLedger;
begin
  if kadb.GetFieldString('Group') = 'Duties & Taxes' then
  begin
    bjMstExp.NewGst(kadb.GetFieldString('Ledger'), 'Duties & Taxes', '12');
    Exit;
  end;
  if (kadb.GetFieldString('Group') = 'Sundry Debtors') or
    (kadb.GetFieldString('Group') = 'Sundry Creditor') then
  begin
    bjMstExp.NewParty(kadb.GetFieldString('Ledger'), kadb.GetFieldString('Group'),
      kadb.GetFieldString('GSTN'), UdefStateName);
    Exit;
  end;
  if (kadb.GetFieldString('Group') = 'Sales Accounts') or
    (kadb.GetFieldString('Group') = 'Purchase Accounts') then
  begin
//    bjMstExp.NewParty(kadb.GetFieldString('Ledger'), kadb.GetFieldString('Group'),'12');
    bjMstExp.NewGST(kadb.GetFieldString('Ledger'), kadb.GetFieldString('Group'),'12');
    Exit;
  end;
  bjMstExp.NewLedger(kadb.GetFieldString('Ledger'), kadb.GetFieldString('Group'),0);
end;

procedure TbjMrMc.SetGSTSetting;
begin
  if VchType = 'Sales' then
  begin
    bjMstExp.VchType := 'Sales';
    bjMstExp.NewGst('GST Sales Exempted', 'Sales Accounts', '0');
    bjMstExp.NewGst('GST 3% Sales', 'Sales Accounts', '3');
    bjMstExp.NewGst('GST 5% Sales', 'Sales Accounts', '5');
//    bjMstExp.NewLedger('GST 5% Sales', 'Sales Accounts', 0);
    bjMstExp.NewGst('GST 12% Sales', 'Sales Accounts', '12');
    bjMstExp.NewGst('GST 18% Sales', 'Sales Accounts', '18');
    bjMstExp.NewGst('GST 28% Sales', 'Sales Accounts', '28');
    bjMstExp.NewGst('IGST Sales Exempted', 'Sales Accounts', '0');
    bjMstExp.NewGst('IGST 3% Sales', 'Sales Accounts', '3');
    bjMstExp.NewGst('IGST 5% Sales', 'Sales Accounts', '5');
    bjMstExp.NewGst('IGST 12% Sales', 'Sales Accounts', '12');
    bjMstExp.NewGst('IGST 18% Sales', 'Sales Accounts', '18');
    bjMstExp.NewGst('IGST 28% Sales', 'Sales Accounts', '28');

    bjMstExp.NewGst('Output SGST 1.5%', 'Duties & Taxes', '3');
    bjMstExp.NewGst('Output CGST 1.5%', 'Duties & Taxes', '3');
    bjMstExp.NewGst('Output IGST 3%', 'Duties & Taxes', '3');
    bjMstExp.NewGst('Output SGST 2.5%', 'Duties & Taxes', '5');
    bjMstExp.NewGst('Output CGST 2.5%', 'Duties & Taxes', '5');
    bjMstExp.NewGst('Output IGST 5%', 'Duties & Taxes', '5');
    bjMstExp.NewGst('Output SGST 6%', 'Duties & Taxes', '12');
    bjMstExp.NewGst('Output CGST 6%', 'Duties & Taxes', '12');
    bjMstExp.NewGst('Output IGST 12%', 'Duties & Taxes', '12');
    bjMstExp.NewGst('Output SGST 9%', 'Duties & Taxes', '18');
    bjMstExp.NewGst('Output CGST 9%', 'Duties & Taxes', '18');
    bjMstExp.NewGst('Output IGST 18%', 'Duties & Taxes', '18');
    bjMstExp.NewGst('Output SGST 14%', 'Duties & Taxes', '28');
    bjMstExp.NewGst('Output CGST 14%', 'Duties & Taxes', '28');
    bjMstExp.NewGst('Output IGST 28%', 'Duties & Taxes', '28');
  end;
  if VchType = 'Purchase' then
  begin
    bjMstExp.VchType := 'Purchase';
    bjMstExp.NewGst('GST Purchase Exempted', 'Purchase Accounts', '0');
    bjMstExp.NewGst('GST 3% Purchase', 'Purchase Accounts', '3');
    bjMstExp.NewGst('GST 5% Purchase', 'Purchase Accounts', '5');
    bjMstExp.NewGst('GST 12% Purchase', 'Purchase Accounts', '12');
    bjMstExp.NewGst('GST 18% Purchase', 'Purchase Accounts', '18');
    bjMstExp.NewGst('GST 28% ', 'Purchase Accounts', '28');
    bjMstExp.NewGst('GST Purchase Exempted', 'Purchase Accounts', '0');
    bjMstExp.NewGst('IGST 3% Purchase', 'Purchase Accounts', '3');
    bjMstExp.NewGst('IGST 5% Purchase', 'Purchase Accounts', '5');
    bjMstExp.NewGst('IGST 12% Purchase', 'Purchase Accounts', '12');
    bjMstExp.NewGst('IGST 18% Purchase', 'Purchase Accounts', '18');
    bjMstExp.NewGst('IGST 28% ', 'Purchase Accounts', '28');

    bjMstExp.NewGst('Input SGST 1.5%', 'Duties & Taxes', '3');
    bjMstExp.NewGst('intput CGST 1.5%', 'Duties & Taxes', '3');
    bjMstExp.NewGst('input IGST 3%', 'Duties & Taxes', '3');
    bjMstExp.NewGst('input SGST 2.5%', 'Duties & Taxes', '5');
    bjMstExp.NewGst('input CGST 2.5%', 'Duties & Taxes', '5');
    bjMstExp.NewGst('input IGST 5%', 'Duties & Taxes', '5');
    bjMstExp.NewGst('input SGST 6%', 'Duties & Taxes', '12');
    bjMstExp.NewGst('input CGST 6%', 'Duties & Taxes', '12');
    bjMstExp.NewGst('input IGST 12%', 'Duties & Taxes', '12');
    bjMstExp.NewGst('input SGST 9%', 'Duties & Taxes', '18');
    bjMstExp.NewGst('input CGST 9%', 'Duties & Taxes', '18');
//    bjMstExp.NewGst('input IGST 18%', 'Duties &amp; Taxes', '18');
    bjMstExp.NewGst('input IGST 18%', 'Duties & Taxes', '18');
    bjMstExp.NewGst('input SGST 14%', 'Duties & Taxes', '28');
    bjMstExp.NewGst('input CGST 14%', 'Duties & Taxes', '28');
    bjMstExp.NewGst('input IGST 28%', 'Duties & Taxes', '28');
  end;
  if (VchType = 'Sales') or (VchType = 'Purchase') then
  begin
    bjMstExp.NewGst('SGST', 'Duties & Taxes', '12');
    bjMstExp.NewGst('CGST', 'Duties & Taxes', '12');
    bjMstExp.NewGst('IGST', 'Duties & Taxes', '12');
  end;
end;

(*
function TbjMrMc.GetErrStr(const astr: string): string;
var
  CheckErrStr: string;
  ErrList: TStringList;
  i: Integer;
begin
  CheckErrStr := '(FOR OBJECT: ';
  if Pos(CheckErrStr, astr) > 0 then
    Result := Copy(aStr, 0, Pos(CheckErrStr, aStr)-1);
  if Length(Result) > 0 then
    Exit;
{
  ErrList := TStringList.Create;
  ErrList.Text := astr;
  try
  for i:= 0 to Errlist.Count-1 do
  begin
    if pos('ERROR:', ErrList[i]) > 0 then
    begin
      Result := ErrList[i+1];
      Exit;
    end;
  end;
  finally
    ErrList.Free;
  end;
}
end;
*)
(*
    TryDt := DateTimeStrEval('mm-dd-yy', Txt);
    Txt := pChar(FormatDateTime('dd-mm-yyyy', TryDt));
*)
end.

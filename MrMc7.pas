{*
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
unit MrMc7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  DB,
  ADODB,
  XlExp,
  Math,
  Client,
  bjXml3_1;

{$DEFINE ADO}

Const
  PGLEN = 7;
//COLUMNLIMIT = 22;
  COLUMNLIMIT = 44;
  TallyAmtPicture = '############.##';

{$IFDEF ADO}
MDBSTR = 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=%s';
XLSSTR = 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=%s;Extended Properties="Excel 12.0;HDR=YES"';
//XLSSTR = 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=%s;Extended Properties="Excel 8.0;HDR=YES";Persist Security Info=False';
{$ENDIF}

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
    FIsMListDeclared: Boolean;
    FIsVListDeclared: Boolean;
    FIsExpItemMst: Boolean;
    FIsCheckLedMst: Boolean;
    FFirm: string;
  protected
    missingledgers: Integer;
    UIdstr: string;
    UIdint: integer;
    cfgn: IbjXml;
    cfg: IbjXml;
    xcfg: IbjXml;
    kadb: TADoTable;
    Logdb: TADoTable;
    IsIdOnlyChecked: boolean;
//    FDomain: string;
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
    LedgerName: array [1..COLUMNLIMIT] of string;
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
//    UGroupName: string;
    UOBDrName: string;
    UOBCrName: string;
    LedgerGroup: array [1..COLUMNLIMIT] of string;
{ +1 for RoundOff }
    LedgerDict: array [1..COLUMNLIMIT + 1] of TList;
    IsGroupDeclared: array [1..COLUMNLIMIT + 1] of boolean;
    IsGSTNDeclared: array [1..COLUMNLIMIT + 1] of boolean;
    IsGSTNDefined: array [1..COLUMNLIMIT + 1] of boolean;
    IsStateDeclared: array [1..COLUMNLIMIT + 1] of boolean;
    IsStateDefined: array [1..COLUMNLIMIT + 1] of boolean;
    IsInvDefined: array [1..COLUMNLIMIT + 1] of boolean;
    UGSTNName: array [1..COLUMNLIMIT + 1] of string;
    UStateName: array [1..COLUMNLIMIT+1] of string;
    UGroupName: array [1..COLUMNLIMIT ] of string;
    UAliasName: string;
    UGodownName: string;
    USubGroupName: string;
    IsIdDefined: boolean;
    IsDateDefined: boolean;
    IsVTypeDefined: boolean;
    IsVoucherRefDefined: boolean;
    IsItemDefined: boolean;
    IsUnitDefined: boolean;
    IsAliasDefined: Boolean;
    IsGodownDefined: Boolean;
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
    UTallyIDName: string;

    IsAssessableDefined: array [1..COLUMNLIMIT] of boolean;
    UAssessableName: array [1..COLUMNLIMIT] of string;
    UInventoryName: string;
    UItemName: string;
    UUnitName: string;
    UQtyName: string;
    URateName: string;
    UItemAmtName: string;
    ToCheckInvCols: boolean;

{ if exosts value if not di}
    DateColValue: string;
    TypeColValue: string;
    LedgerColValue: string;

    IsAmt1Defined: boolean;
{
    IsCrAmt1Defined: boolean;
    IsDrAmt1Defined: boolean;
}
    IsNarrationDefined: boolean;
    IsNarration2Defined: boolean;
    IsNarration3Defined: boolean;
    IsTallyIdDefined: boolean;
    IsLogDBDefined: boolean;
    notoskip: integer;
    ProcessedCount: integer;
//    IdName: string;
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
    procedure ProcessItem(const level: integer);
    function IsIDChanged: boolean;
    procedure GetDefaults;
    procedure WriteStatus;
    function GetLedger(const level: integer): string;
    function GetRoundOffName: string;
    function GetAmt(const level: integer): double;
    function IsMoreColumn(const level: integer): boolean;
    procedure CheckColumn(const colname: string);
    procedure SetFirm(const aFirm: string);
  public
    { Public declarations }
    dbName: string;
    fileName: string;
    XmlFile: string;
    XmlStr: string;
    FileFmt: string;
    IsMultiRowVoucher: boolean;
    IsMultiColumnVoucher: boolean;
    IsDateCheck: boolean;
    SCount: integer;
    FUpdate: TfnUpdate;
    DefGroup: string;
    Host: string;
//    ToCreateMasters: boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
  published
{ Logging is optional }
    property ToLog: boolean read FToLog write FToLog;
{ Auto Create Master is optional }
    property ToAutoCreateMst: boolean read FToAutoCreateMst write FToAutoCreateMst;
    property RefreshLedMaster: Boolean read FRefreshLedMaster write FRefreshLedMaster;
    property Vchtype: string read FVchType write FVchType;
    property IsMListDeclared: Boolean read FIsMListDeclared write FIsMListDeclared;
    property IsVListDeclared: Boolean read FIsVListDeclared write FIsVListDeclared;
    property IsCheckLedMst: Boolean read FIsCheckLedMst write FIsCheckLedMst;
    property IsExpItemMst: Boolean read FIsExpItemMst write FIsExpItemMst;
    property Firm: string read FFirm write setFirm;
  end;

{ Level refers to TokenCol }
{ Token Column can be separate from any Ledger column }
  TDict = Record
    TokenCol: pChar;
    Token: pChar;
    Value: pChar;
  end;
  pDict = ^TDict;

function GetFldDt(fld: TField): string;
function GetFldStr(fld: TField): string;

{$include \TL\ET\src\VchUpdate.int}

implementation

uses
  Datamodule;

Constructor TbjMrMc.Create;
var
  i: integer;
begin
  Inherited;
{  SetDebugMode(0); }
  SetDebugMode(0);
  xmlFile := copy(Application.ExeName, 1, Pos('.exe', Application.ExeName)-1) + '.xml';
  Cfgn := CreatebjXmlDocument;
{  UNarration := '';}
{  Amt1 := '';}
  notoskip := 0;
  ProcessedCount := 0;;
  UIdName := 'ID';
  LedgerName[1] := 'LEDGER';
  ULedgerName[1] := 'LEDGER';

//  UGroupName := 'GROUP';
  UOBDrName := 'O BAL Dr';
  UOBCrName := 'O BAL Cr';

  for i:= 2 to COLUMNLIMIT do
  begin
    LedgerName[i] := 'LEDGER' + InttoStr(i);
    ULedgerName[i] := 'LEDGER' + InttoStr(i);
  end;
  UAmountName[1] := 'AMOUNT';
  for i:= 2 to COLUMNLIMIT do
  begin
    UAmountName[i] := 'AMOUNT' + InttoStr(i);
  end;
  for i:= 1 to COLUMNLIMIT do
    AmountType[i] := 'Dr';
  UDateName := 'DATE';
  UVTypeName := 'VTYPE';
  UNarrationName := 'NARRATION';
  UVoucherRefName := 'Voucher Ref';
  UinventoryName := 'INVENTORY';
  UItemName := 'Item';
  UUnitName := 'Unit';
  UQtyName := 'Qty';
  URateName := 'Rate';
  UAliasName := 'Alias';
  UGodownName := 'Godown';
  USubGroupName := 'SubGroup';
  UItemAmtName := 'Value';
  UTallyIDName := 'TALLYID';
//  FRefreshLedMaster := True;
  FRefreshLedMaster := False;
  FToLog := True;
  FToAutoCreateMst := True;
end;

destructor TbjMrMc.Destroy;
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
      StrDispose(ditem^.TokenCol);
      StrDispose(ditem^.Token);
      StrDispose(ditem^.Value);
    end;
  LedgerDict[i].Clear;
  LedgerDict[i].Free;
  end;
  kadb.Close;

  kadb.Free;
  LogDB.Free;
  dm.ADOConnection.Connected := False;
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
  if XmlStr = 'User' then
    cfgn.loadXmlFile('.\Data\User.xml')
  else
    cfgn.LoadXML(XmlStr);
//  begin
//    if not FileExists(XmlFile) then
//      raise Exception.Create('Configuration file not found');
//    cfgn.loadXmlFile(XmlFile);
//  end;
{
  if XmlStr = 'MySale' then
  if FileExists('.\Data\MySale.xml') then
    cfgn.loadXmlFile('.\Data\MySale.xml');
  if XmlStr = 'MyPurc' then
  if FileExists('.\Data\MyPurc.xml') then
    cfgn.loadXmlFile('.\Data\MyPurc.xml');
}
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

  if (Length(DefGroup) > 0) then
    SetDefaultGroup(pchar(DefGroup))
  else
//    SetDefaultGroup(pchar(''));
    SetDefaultGroup('');

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
//        pDict(dItem)^.TokenCol := StrtoInt(dcfg.GetChildContent('TokenCol'));
        pDict(dItem)^.TokenCol := StrNew(PChar(dcfg.GetChildContent('TokenCol')));
        str := dcfg.GetChildContent('Token');
        pDict(dItem)^.Token := StrNew(pchar(str));
        str := dcfg.GetChildContent('Value');
        pDict(dItem)^.Value := StrNew(pchar(str));
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
      str := xxCfg.GetContent;
//      RoundOffGSTN := str;
      UGSTNName[COLUMNLIMIT+1] := str;
      if Length(str) > 0 then
        IsGSTNDeclared[COLUMNLIMIT+1] := True;
  end;
    xxCfg := xcfg.SearchForTag(nil, 'State');
    if Assigned(xxCfg) then
    begin
      str := xxCfg.GetContent;
      UStateName[COLUMNLIMIT+1] := str;
      if Length(str) > 0 then
        IsStateDeclared[COLUMNLIMIT+1] := True;
    end;
  end;

  xCfg := Cfg.SearchForTag(nil, 'VoucherNo');
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
    UVchNoColName := str;
//    DiDateValue := xCfg.GetChildContent('Default');
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
(*
    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
    UNarrationName  := str;
*)
  xxCfg := xCfg.SearchForTag(nil, 'Alias');
  if xxCfg <> nil then
  begin
    str := xxCfg.GetContent;
    if Length(str) > 0 then
    begin
      UNarrationName  := str;
//      IsNarrationDefined := True;
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

  for i := 1 to COLUMNLIMIT do
  begin
    xCfg := Cfg.SearchForTag(nil, LedgerName[i]);
    if Assigned(xCfg) then
      DiLedgerValue[i] := xcfg.GetChildContent('Default');
    if Length(DiLedgerValue[i]) > 0 then
      IsLedgerDeclared[i] := True;

    str := '';
    xCfg := cfg.SearchForTag(nil, LedgerName[i]);
    if Assigned(xCfg) then
      str := xCfg.GetChildContent('Alias');
    if Length(Str) > 0 then
    begin
      ULedgerName[i] := str;
      IsLedgerDeclared[i] := True;
    end;

    xCfg := cfg.SearchForTag(nil, LedgerName[i]);
    if Assigned(xCfg) then
    begin
//      LedgerGroup[i] := xCfg.GetChildContent('Group');
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
      xxCfg := xcfg.SearchForTag(nil, 'State');
      if Assigned(xxCfg) then
      begin
        str := xxCfg.GetContent;
        UStateName[i] := str;
        if Length(str) > 0 then
          IsStateDeclared[i] := True;
      end;
      xxCfg := xcfg.SearchForTag(nil, 'IsInvCol');
      if Assigned(xxCfg) then
      begin
        str := xxCfg.GetContent;
        if str = 'Yes' then
        begin
          IsInvDefined[i] := True;
          ToCheckInvCols := True;        end;
      end;
    end;

    xCfg := cfg.SearchForTag(nil, LedgerName[i]);
    if Assigned(xCfg) then
    begin
      UAssessableName[i] := xCfg.GetChildContent('Assessable');
      if Length(UAssessableName[i]) > 0 then
      IsAssessableDefined[i] := True;
    end;

    xCfg := cfg.SearchForTag(nil, LedgerName[i]);
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

    xCfg := cfg.SearchForTag(nil, LedgerName[i]);
    if Assigned(xCfg) then
    begin
      dCfg := xcfg.SearchForTag(nil, 'Dict');
      if Assigned(dCfg) then
      begin
        LedgerDict[i] := TList.Create;
        while Assigned(dcfg) do
        begin
          ditem := new (pDict);
          pDict(dItem)^.TokenCol := StrNew(pChar(dcfg.GetChildContent('TokenCol')));
          str := dcfg.GetChildContent('Token');
          pDict(dItem)^.Token := StrNew(pchar(str));
          str := dcfg.GetChildContent('Value');
          pDict(dItem)^.Value := StrNew(pchar(str));
          LedgerDict[i].Add(Ditem);
          dCfg := xcfg.SearchForTag(dcfg, 'Dict');
        end;
        IsLedgerDeclared[i] := True;
      end;
    end;
  end;
  xCfg := Cfg.SearchForTag(nil, UInventoryName);
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

    xxCfg := xCfg.SearchForTag(nil, UItemAmtName);
    if Assigned(xxCfg) then
  begin
      str := xxCfg.GetChildContent('Alias');
      if Length(str) > 0 then
        UItemAmtName := str;
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
    end
    else
    begin
      if IsMoreColumn(i) then
         raise Exception.Create(ULedgerName[i] + ' Column is required');
    end;
  end;

{ Mandtory Minimum Columns }
  if not IsLedgerDeclared[1] then
    raise Exception.Create(ULedgerName[1] + ' Column is required');
//  if not IsAmtDeclared[1] then
//    raise Exception.Create(UAmountName[2] + ' Column is required');
end;

procedure TbjMrMc.OpenFile;
begin
//  if Length(Host) > 0 then
//    SetHost(pchar(Host));
{ No try except ...
passing Windows Exception as it is }
  if not FileExists(dbName) then
    raise Exception.Create('File ' + dbname + ' not found');
{$IFDEF ADO}
  if FileFmt = 'Excel_Table' then
  begin
    DM.AdoConnection.LoginPrompt:=False;//dont ask for the login parameters
//    DM.ADOConnection.ConnectionString := Format(XLSSTR, [dbName+'.xls']);
    DM.ADOConnection.ConnectionString := Format(XLSSTR, [dbName]);
    DM.AdoConnection.Connected:=True; //open the connection
    kadb := TADoTable.Create(nil);
    kadb.Connection := dm.AdoConnection;
    kadb.TableName := '['+ Filename+ '$]';
    kadb.ReadOnly := False;
//    if not FToLog then
//      kadb.ReadOnly := True;
    Kadb.Active := True;
    if Assigned(FUpdate) then
      FUpdate('Reading '+ FileName);
    kadb.Open;
    if Assigned(FUpdate) then
    FUpdate('Processing '+ FileName);
    if FToLog then
    begin
      IsLogDBDefined := True;
      Logdb := TADoTable.Create(nil);
      try
        Logdb.Connection := dm.AdoConnection;
        Logdb.TableName := '['+ 'Log' + '$]';
        Logdb.Active := True;
        Logdb.ReadOnly := False;
        Logdb.Open;
      Except
        IsLogDBDefined := False;
        LogDB.Close;
      end;
    end;
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
  CheckColNames;
  if Length(Host) > 0 then
    SetHost(pchar(Host));
  if FRefreshLedMaster then
    RefreshMstLists;

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
      MessageDlg('Ledgers exist in Tally', mtInformation, [mbOK], 0);
  end;
    if IsExpItemMst then
      MessageDlg('Done', mtInformation, [mbOK], 0);
    Exit;
  end;
  kadb.First;
  UIdstr := '';
{
  if FToLog then
  begin
    LogDB.First;
    while (not Logdb.Eof) do
    begin
      Logdb.Delete;
      Logdb.Next;
    end;
    Logdb.First;
  end;
}
  kadb.First;
  vTotal := 0;
  NewIdLine;
  IsIdOnlyChecked := True;
  while (not kadb.Eof)  do
  begin
{ Make sure id is empty }
    if IsIdDefined then
    begin
//    if (Length(kadb.FieldByName(UIdName).AsString) = 0) then
//      if (Length(GetFldStr(kadb.FieldByName(UIdName))) = 0) then
      if (Length(kadb.FieldByName(UIdName).AsString) = 0) then
        break;
    end
    else
    begin
{ or otherwise Make sure date is empty }
      if not IsMultiRowVoucher then
//        if kadb.FindField(UDateName) <> nil then
        if IsDateDefined then
          if (Length(kadb.FieldByName(UDateName).AsString) = 0) then
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
    InttoStr(SCount) + ' Success. Error detailss in  Log worksheet'




  FUpdate(StatusMsg);
  if IsLogDBDefined then
    if ProcessedCount - SCount > 0 then
    begin
      Logdb.Append;
      Logdb.FieldByName('RECID').AsString := '...';
      Logdb.Post;
    end;
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
begin
  LedgerColvalue := Getledger(1);
  Amt[1] := GetAmt(1);
  if Abs(Amt[1]) >= 0.01 then
  begin
    AddLine(pchar(LedgerColValue), Amt[1]);
    if IsAssessableDefined[1] then
      SetAssessable(kadb.FieldByName(UAssessableName[1]).AsFloat);
//    VTotal := VTotal + StrtoFloat(FormatFloat(TallyAmtPicture, Amt[1]));
    VTotal := VTotal + RoundTo(Amt[1],-2);
    ProcessItem(1);
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
    AddLine(pchar(LedgerColValue),Amt[level]);
    if IsAssessableDefined[level] then
      SetAssessable(kadb.FieldByName(UAssessableName[level]).AsFloat);
//    VTotal := VTotal + StrtoFloat(FormatFloat(TallyAmtPicture, Amt[level]));
    VTotal := VTotal + RoundTo(Amt[level], -2);
    ProcessItem(level);
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
procedure TbjMrMc.ProcessItem(const level: integer);
var
  invamt: Double;
begin
  if not  IsInvDefined[level] then
    Exit;
  if not IsItemDefined then
    Exit;
  if Length(kadb.FieldByName(UItemName).AsString) = 0 then
    Exit;
  if Length(kadb.FieldByName(UQtyName).AsString) = 0 then
    Exit;
    invamt := kadb.FieldByName(UItemAmtName).AsFloat;
{ InvAmt for Purchase }
  if AmountType[level] = 'Dr' then
    invamt := -invamt;
  SetInvLine(pChar(kadb.FieldByName(UItemName).AsString),
    kadb.FieldByName(UQtyName).AsFloat,
    kadb.FieldByName(URateName).AsFloat,
    invamt);
end;

{ Validation of Table Columns in Excel
  Creation of Default Ledgers }
procedure TbjMrMc.CheckColNames;
var
  i, j: integer;
  Col: TFieldDef;
  dItem: pDict;
  str: string;
  strMsg: string;
begin
  if kadb.FindField(UIdName) <> nil then
    IsIdDefined := True;
  if kadb.FindField(UDateName) <> nil then
    IsDateDefined := True;
  if kadb.FindField(UVTypeName) <> nil then
    IsVTypeDefined := True;
  if kadb.FindField(UVoucherRefName) <> nil then
    IsVoucherRefDefined := True;
  if kadb.FindField(UNarrationName) <> nil then
    IsNarrationDefined := True;
  if kadb.FindField(UItemName) <> nil then
    IsItemDefined := True;
  if kadb.FindField(UUnitName) <> nil then
    IsUnitDefined := True;
  if kadb.FindField(UAliasName) <> nil then
    IsAliasDefined := True;
  if kadb.FindField(UGodownName) <> nil then
    IsGodownDefined := True;
  if kadb.FindField(UGroupName[1]) <> nil then
    IsGroupDefined := True;
  if kadb.FindField(USubGroupName) <> nil then
    IsSubGroupDefined := True;
{ Check for TallyId }
{
  for i := 0 to kadb.FieldDefs.Count-1 do
  begin
    Col := kadb.FieldDefs[i];
    if col.Name = 'TALLYID' then
      IstALLYidDefined := True;
  end;
}
  if kadb.FindField(UTallyIDName) <> nil then
    IstALLYidDefined := True;

{ Fill IsAmtDeclared array
  Needed for Default Amount }
  for j := 1 to COLUMNLIMIT do
    for i := 0 to kadb.FieldDefs.Count-1 do
    begin
      Col := kadb.FieldDefs[i];
      if col.Name = UAmountName[j] then
      begin
        IsAmtDefined[j] := True;
        break;
      end;
    end;

{ if a Column is defined it should exist in Table }
  for j := 1 to COLUMNLIMIT do
  begin
    str := '';
    for i := 0 to kadb.FieldDefs.Count-1 do
    begin
      Col := kadb.FieldDefs[i];
      str := Col.Name;
      if col.Name = ULedgerName[j] then
      begin
        IsLedgerDefined[j] := True;
        break;
      end;
    end;
    if str = ULedgerName[j] then
    begin
      Continue;
    end;
    if LedgerName[j] <> UledgerName[j] then
      if Length(DiLedgerValue[j]) = 0 then
      begin
        Raise Exception.Create(ULedgerName[j] + ' Column is required');
      end;
  end;
  if kadb.FindField(RoundOffCol) <> nil then
    IsRoundOffColDefined := True;
  if IsMultiRowVoucher then
    CheckColumn(UIdName);
  if Length(DiLedgerValue[1]) = 0 then
  CheckColumn(ULedgerName[1]);
  if not IsMListDeclared then
  begin
  if Length(DiDateValue) = 0 then
    CheckColumn(UDateName);
  if Length(DiTypeValue) = 0 then
  if not IsVtypeDefined then
    CheckColumn(UVTypeName);
  end;    
  if ToCheckInvCols then
//    if kadb.FindField(UItemName) <> nil then
    if IsItemDefined then
    begin
      CheckColumn(UQtyName);
      CheckColumn(URateName);
      CheckColumn(UItemAmtName);
    end;
  for i := 1 to COLUMNLIMIT do
  begin
        if IsGSTNDeclared[i] then
          if kadb.FindField(UGSTNName[i]) <> nil then
            IsGSTNDefined[i] := True;
        if IsStateDeclared[i] then
          if kadb.FindField(UStateName[i]) <> nil then
            IsStateDefined[i] := True;
  end;
//Shifted from top
// Ledger Creation should be done only when necessary
  SetLength(strMsg, 50);
{ Create Default Ledgers }
  for i := 1 to COLUMNLIMIT do
  begin
    if (Length(LedgerGroup[i]) > 0) then
{ Default Ledger with Amount Column }
      if (Length(DiLedgerValue[i]) > 0) then
        NewLedger(pchar(DiLedgerValue[i]), pchar(LedgerGroup[i]), 0);
  end;
  if Length(RoundOffGroup) > 0 then
{To fix Tin no bug with Round off col }
     if Length(DiRoundOff) > 0 then
       NewLedger(pChar(DiRoundOff), pChar(RoundOffGroup), 0);

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
           NewLedger(pchar(pDict(dItem)^.Value), pchar(LedgerGroup[i]), 0);
         end;
       end;
   end;
  if Assigned(LedgerDict[COLUMNLIMIT+1]) then
    for j := 0 to LedgerDict[COLUMNLIMIT+1].Count-1 do
    begin
      ditem := LedgerDict[COLUMNLIMIT+1].Items[j];
      if (Length(RoundOffGroup) > 0) then
        NewLedger(pchar(pDict(dItem)^.Value), pchar(RoundOffGroup), 0);
    end;
//  if RoundToLimit > 0 then

    NewLedger('RoundOff', 'Indirect Expenses', 0);
end;

procedure TbjMrMc.CreateColLedgers;
var
  i: integer;
  aState: string;
begin
{
AutoCreateMst does not affect explicit group or roundoff group
}
  for i:= 1 to COLUMNLIMIT do
    if (Length(LedgerGroup[i]) > 0) then
    begin
      if IsStateDefined[i] then
        aState := kadb.FieldByName(UStateName[i]).AsString
      else
        aState := '';
      if IsGSTNDefined[i] then
        NewParty(pchar(kadb.FieldByName(ULedgerName[I]).AsString), pchar(LedgerGroup[i]), pChar(kadb.FieldByName(UGSTNName[i]).AsString),
        pChar(aState))
      else if IsLedgerDefined[i] then
        NewLedger(pchar(kadb.FieldByName(ULedgerName[I]).AsString), pchar(LedgerGroup[i]), 0);
    end;

  for i := 1 to COLUMNLIMIT do
    if (Length(LedgerGroup[i]) > 0) then
    begin
      if Assigned(LedgerDict[i]) then
        Continue;
      if IsLedgerDefined[i] then
        NewLedger(pchar(kadb.FieldByName(ULedgerName[i]).AsString), pchar(LedgerGroup[i]), 0);
    end;
  for i := 1 to COLUMNLIMIT do
    if (Length(LedgerGroup[i]) > 0) then
      if IsLedgerDefined[i] then
        CreateItem(i);
  if Length(RoundOffGroup) > 0 then
//      if kadb.FindField(RoundOffCol) <> nil then
    if IsRoundOffColDefined then
    begin
      if IsStateDefined[COLUMNLIMIT + 1] then
        aState := kadb.FieldByName(UStateName[COLUMNLIMIT+1]).AsString
      else
        aState := '';
      if IsGSTNDefined[COLUMNLIMIT + 1] then
//        NewParty(pchar(kadb.FieldByName(RoundOffCol).AsString), pchar(RoundOffGroup), pChar(kadb.FieldByName(RoundOffGSTN).AsString),'')
        NewParty(pchar(kadb.FieldByName(RoundOffCol).AsString), pchar(RoundOffGroup), pChar(kadb.FieldByName(UGSTNName[COLUMNLIMIT+1]).AsString),
        PChar(aState))
      else
        NewLedger(pChar(kadb.FieldByName(RoundOffCol).AsString), pChar(RoundOffGroup), 0);
    end;
end;
procedure TbjMrMc.CreateItem(const level: integer);
begin
  if not IsInvDefined[level] then
    Exit;
  if not IsItemDefined then
    Exit;
  if IsUnitDefined then
  begin
    NewUnit(pChar(kadb.FieldByName(UUnitName).AsString));
    NewItem(pChar(kadb.FieldByName(UItemName).AsString),
    pChar(kadb.FieldByName(UUnitName).AsString) , 0, 0);
    Exit;
  end
  else
  begin
    NewUnit('NOs');
    NewItem(pChar(kadb.FieldByName(UItemName).AsString), 'NOs', 0, 0);
  end;
end;
procedure TbjMrMc.GenerateID;
begin
  if not IsIDGenerated then
    Exit;
      if (vTotal = 0) and (kadb.FieldByName(CrAmtCol).AsFloat +
                  kadb.FieldByName(DrAmtCol).AsFloat > 0) then
        uIdstr :=  IntToStr(kadb.RecNo);
      if Length(kadb.FieldByName('ID').AsString) = 0 then
      begin
        kadb.Edit;
        kadb.FieldByName('ID').AsString :=  uidStr;
        kadb.Post;
      end;
      vTotal := vTotal + kadb.FieldByName(CrAmtCol).AsFloat -
                  kadb.FieldByName(DrAmtCol).AsFloat;
end;
procedure TbjMrMc.CheckLedMst;
var
  dbkLed: string;
  IsThere: Integer;
begin
  if not IsMListDeclared then
    Exit;
  if not IsCheckLedMst then
    Exit;
  if IsLedgerdefined[1] then
  dbkLed := kadb.FieldByName('Ledger').AsString;
  if Length(dbkLed) > 0 then
  begin
  IsThere := IsLedger(pChar(dbkLed));
  if IsThere = 0 then
  begin
    kadb.Edit;
    kadb.FieldByName('TALLYID').AsString :=  dbkLed;
    kadb.Post;
    missingledgers := missingledgers + 1;
  end;
  end;
{
  dbUnit := kadb.FieldByName('Unit').AsString;
  if Length(dbunit) > 0 then
}
end;
procedure TbjMrMc.ExpItemMst;
var
  dbItem, dbUnit: string;
  dbAlias, dbGodown, dbParent: string;
  IsThere: Integer;
  OBal, Rate: Double;
begin
  if not IsMListDeclared then
    Exit;
  if not IsExpItemMst then
    Exit;
  dbUnit := '';
  if IsUnitDefined then
  begin
    dbUnit := kadb.FieldByName('Unit').AsString;
    NewUnit(PChar(dbUnit));
  end;
  if IsAliasDefined then
  begin
    dbAlias := kadb.FieldByName('Alias').AsString;
      SetAlias(PChar(dbAlias));
  end;
  if IsGodownDefined then
  begin
    dbGodown := kadb.FieldByName('Godown').AsString;
    if Length(dbGodown) > 0 then
      NewGodown(pChar(dbGodown),'');
        SetGodown(PChar(dbGodown));
  end;
  if IsGroupDefined then
  begin
    dbParent := kadb.FieldByName('Group').AsString;
    if Length(dbParent) > 0 then
      NewItemGroup(PChar(dbParent),'');
      SetGroup(PChar(dbParent));
  end;
  if IsSubGroupDefined then
  begin
    dbParent := kadb.FieldByName('SubGroup').AsString;
    if Length(dbParent) > 0 then
    NewItemGroup(PChar(dbParent),
      pChar(kadb.FieldByName('Group').AsString));
      SetGroup(PChar(dbParent));
  end;
    dbItem := kadb.FieldByName('Item').AsString;
  OBal := kadb.FieldByName('O_Balance').AsFloat;
  Rate := kadb.FieldByName('O_Rate').AsFloat;
    if Length(dbItem) > 0 then
    begin
    IsThere := IsItem(pChar(dbItem));
    if IsThere = 0 then
      NewItem(PChar(dbItem), PChar(dbUnit), OBal, Rate);
  end;
end;

procedure TbjMrMc.CreateRowLedgers;
var
  OB: double;
  aState: string;
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
  if (Length(kadb.FieldByName(UGroupName[1]).AsString) > 0) then
  begin
    if IsGSTNDefined[1] then
    begin
      if IsStateDefined[1] then
        aState := kadb.FieldByName(UStateName[1]).AsString
      else
        aState := '';
      NewParty(pchar(kadb.FieldByName(ULedgerName[1]).AsString),
        pchar(kadb.FieldByName(UGroupName[1]).AsString),
        pChar(kadb.FieldByName(UGSTNName[1]).AsString),
        PChar(aState))
    end
    else
      NewLedger(pchar(kadb.FieldByName(ULedgerName[1]).AsString),
        pchar(kadb.FieldByName(UGroupName[1]).AsString), OB);
  end;
end;

procedure TbjMrMc.NewIdLine;
var
  TId: string;
begin
//  if ToCreateMasters then
//    CreateColLedgers;
  if IsIdDefined then
//    UIdstr := GetFldStr(kadb.FieldByName(UIdName));
    UIdstr := kadb.FieldByName(UIdName).AsString;
  UIdint := kadb.RecNo;
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
//    SetVchNo(pChar(kadb.FieldByName('Voucher No').AsString));
  if Length(UVchNoColName) > 0 then
  SetVchNo(pChar(kadb.FieldByName(UVchNoColName).AsString));

  if IsVoucherRefDefined then
    SetVchRef(pChar(kadb.FieldByName(UVoucherRefName).AsString));
  SetNarration(pchar(NarrationColValue));
  SetVchDate(pchar(DateColValue));
  SetVchType(pchar(typeColValue));
  SetVchId(pchar(tid));
  RoundOffName := GetRoundOffName;
  notoskip := 0;
end;

{***}
procedure TbjMrMc.GetDefaults;
begin
{  GetSingleValues; }
  DateColValue := '';
  if IsDateDefined then
    if Length(kadb.FieldByName(UDateName).AsString) > 0 then
    DateColValue := GetFldDt(kadb.FieldByName(UDateName));
  if Length(DateColValue) = 0 then
    DateColValue := DiDateValue;
  if IsVtypeDefined then
{ Find if user set has Voucher type }
    TypeColValue := kadb.FieldByName(UVTypeName).AsString;
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
    if Length(kadb.FieldByName(CrAmtCol).AsString) > 0 then
      if Length(CrAmtColType) > 0 then
        TypeColValue := CrAmtColType;
    if Length(kadb.FieldByName(DrAmtCol).AsString) > 0 then
      if Length(DrAmtColType) > 0 then
        TypeColValue := DrAmtColType;
  end;
  if IsNarrationDefined then
    NarrationColValue := kadb.FieldByName(UNarrationName).AsString;

  if IsNarration2Defined then
  if kadb.FindField(UNarration2Name) <> nil then
    NarrationColValue := NarrationColValue + kadb.FieldByName(UNarration2Name).AsString;
  if IsNarration3Defined then
  if kadb.FindField(UNarration3Name) <> nil then
    NarrationColValue := NarrationColValue + kadb.FieldByName(UNarration3Name).AsString;

end;

{
Id can be determined with date and voucher total.
If there is demand...
}
function TbjMrMc.IsIDChanged: boolean;
begin
  Result := False;
  if IsIdDefined then
    if (kadb.FieldByName(UIdName).AsString <> UIdstr) then
      Result  := True;
  if not IsMultiRowVoucher then
    if kadb.RecNo <> uidint then
      Result := True;
{
  Date check is for end of file only
}
end;


function TbjMrMc.GetLedger(const level: integer): string;
var
  lstr: string;
  i: integer;
  Item: pDict;
begin
  if IsLedgerDefined[level] then
  begin
    if (Length(kadb.FieldByName(ULedgerName[level]).AsString) > 0) then
      lstr := kadb.FieldByName(ULedgerName[level]).AsString;
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
  if Assigned(LedgerDict[level]) then
  begin
    for i := 0 to LedgerDict[level].Count-1 do
    begin
      Item := LedgerDict[level].Items[i];
//      if pDict(Item)^.Token = kadb.FieldByName(ULedgerName[pDict(Item)^.TokenCol]).AsString then
      if pDict(Item)^.Token = kadb.FieldByName(pDict(Item)^.TokenCol).AsString then
      begin
        lstr := pDict(Item)^.Value;
        break;
      end;
    end;
    if Length(lstr) > 0 then
    begin
      Result := lstr;
      Exit;
    end;
  end;
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
      if Length(Trim(kadb.FieldByName(DrAmtCol).AsString)) > 0 then
      if kadb.FieldByName(DrAmtCol).AsFloat <> 0 then
        Result := -kadb.FieldByName(DrAmtCol).AsFloat;
      if Length(Trim(kadb.FieldByName(CrAmtCol).AsString)) > 0 then
      if kadb.FieldByName(CrAmtCol).AsFloat<> 0 then
        Result := kadb.FieldByName(CrAmtCol).AsFloat;
      if (level = 2)  then
        Result := -Result;
    end;
    Exit;
  end;
{ IsMultiCol }
//  if IsAmtDeclared[level] then
  if IsAmtDefined[level] then
  begin
    if Length(kadb.FieldByName(UAmountName[level]).AsString) > 0 then
    begin
      Result := StrtoFloat(kadb.FieldByName(UAmountName[level]).AsString);
      if AmountType[level] = 'Dr' then
        Result := - StrtoFloat(kadb.FieldByName(UAmountName[level]).AsString);
{      Exit;}
    end;
    if AmountCols[level] > 1 then
    begin
      if Length(kadb.FieldByName(UAmount2Name[level]).AsString) > 0 then
      begin
        if Amount2Type[level] = 'Cr' then
          Result := Result + StrtoFloat(kadb.FieldByName(UAmount2Name[level]).AsString);
        if Amount2Type[level] = 'Dr' then
          Result := Result - StrtoFloat(kadb.FieldByName(UAmount2Name[level]).AsString);
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
  if IsLedgerDeclared[i+1] then
  begin
    Result := True;
    break;
  end;
end;

function TbjMrMc.GetRoundOffName: string;
var
  i: integer;
  Item: pDict;
  lStr: string;
begin
  Result := '';
  if IsRoundOffColDefined then
  begin
    if (Length(kadb.FieldByName(RoundOffCol).AsString) > 0) then
      lstr := kadb.FieldByName(RoundOffCol).AsString;
    if Length(lstr) > 0 then
    begin
      Result := lstr;
      Exit;
    end;
  end;
{
Depending on token in one column 1 RoundOff ledger is derived
}
  if Assigned(LedgerDict[COLUMNLIMIT+1]) then
  begin
    for i := 0 to LedgerDict[COLUMNLIMIT+1].Count-1 do
    begin
      Item := LedgerDict[COLUMNLIMIT+1].Items[i];
//      if pDict(Item)^.Token = kadb.FieldByName(ULedgerName[pDict(Item)^.TokenCol]).AsString then
      if pDict(Item)^.Token = kadb.FieldByName(pDict(Item)^.TokenCol).AsString then
      begin
        lStr := pDict(Item)^.Value;
        break;
      end;
    end;
    if Length(lstr) > 0 then
    begin
      Result := lstr;
      Exit;
    end;
  end;
  if Length(DiRoundOff) > 0 then
    Result := DiRoundOff;
end;

procedure TbjMrMc.WriteStatus;
var
  i: integer;
  TempStr: pChar;
  statmsg: string;
  CheckErrStr: string;
  RoundOffAmount: Double;
  IsErr: boolean;
begin
  IsErr := False;
  RoundOffAmount := Round(Vtotal) - VTotal;
  CheckErrStr := '(FOR OBJECT: ';
  vchAction := 'Create';
  if Abs(VTotal) >= 0.01 then
  begin
    if RoundToLimit > 0 then
    begin
    AddLine(pChar(RoundOffName), - Round(VTotal));
      AddLine('RoundOff', RoundOffAmount);
    end
    else
      AddLine(pChar(RoundOffName), - VTotal);

  end;

  TempStr := TryPost(pChar(VchAction));
  SetLength(statmsg, Length(TempStr)+1);
  StrCopy(PChar(StatMsg), TempStr);
//  UniqueString(statmsg);
  dllRelease(TempStr);
  if StatMsg = '0' then
    IsErr := True;
  if Pos(CheckErrStr, StatMsg) > 0 then
  begin
    StatMsg := Copy(StatMsg, 0, Pos(CheckErrStr, StatMsg)-1);
    IsErr := True;
  end;
  VTotal := 0;
  if Assigned(FUpdate) then
      FUpdate('Status: ' + Statmsg);
  ProcessedCount := ProcessedCount + 1;

  for i := 1 to notoskip do
    kadb.Prior;
  if ToLog then
  begin
  {
  if isTallyIdDefined then
  begin
    try
      kadb.Edit;
      kadb.FieldByName('TALLYID').AsString := statmsg;
      kadb.Post;
    except
      kadb.Cancel;
      if MessageDlg('Error Writing Status in TallyID, Try Posting anyway?' ,
      mtInformation, [mbOK, mbCancel], 0) = mrCancel then
        Abort;
      isTallyIdDefined := False;
//      on E : Exception do
//      begin
//      MessageDlg(E.Message, mtError, [mbOK], 0);
//      end;
    end;
  end;
  }
  if IsErr then
  if IsLogDBDefined then
  begin
    Logdb.Append;
    IF isIDDefined then
        Logdb.FieldByName('RECID').AsString := UIdstr
    else
      Logdb.FieldByName('RECID').AsString := IntToStr(kadb.RecNo);
    Logdb.FieldByName('DATE').AsString := DateColValue;
    Logdb.FieldByName('TALLYID').AsString := statmsg;
    Logdb.Post;
  end;
  end
  else
    if IsErr then
    begin
      MessageDlg('Error on row no: ' + InttoStr(kadb.RecNo + 1),
        mtError, [mbOK],0);
      Abort;
    end;
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
Var
  ColumnExists: boolean;
  i: integer;
  Colm: TFieldDef;
begin
  ColumnExists := False;
  for i := 0 to kadb.FieldDefs.Count-1 do
  begin
    Colm := kadb.FieldDefs[i];
    if colm.Name = colname then
      Exit;
  end;
  //Showmessage(colname);
//  Showmessage(inttostr(kadb.FieldDefs.Count));
if not ColumnExists then
    raise Exception.Create(Colname + ' column is Required')
end;

procedure TbjMrMc.SetFirm(const aFirm: string);
begin
  SetCompany(pChar(FFirm));
end;
{    'yyyymmdd' 'dd-mmm-yyyy'}
function GetFldDt(fld: TField): string;
var
  newvar: string;
begin
  if fld.DataType = ftDateTime then
  begin
//    newvar := FormatDateTime('dd-MMM-yy', fld.AsDateTime);
    newvar := FormatDateTime('yyyymmdd', fld.AsDateTime);
    Result := pchar(NewVar);
    exit;
  end;
  if (fld.DataType = ftString) then
  begin
    newvar := fld.AsString;
    Result := pchar(NewVar);
    Exit;
  end;
  try
{ ftUnknown }
    newvar := fld.Text;
  except
    NewVar := '  -  -  ';
  end;
  Result := pchar(NewVar);
end;

function GetFldStr(fld: TField): string;
var
  newvar: string;
begin
  if (fld.DataType = ftString) then
  begin
    newvar := fld.AsString;
    Exit;
  end;
  try
{ ftUnknown }
    newvar := fld.Text;
  except
    NewVar := '';
  end;
  Result := pchar(NewVar);
end;

end.

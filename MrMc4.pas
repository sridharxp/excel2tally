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
IsMultiRow - id and single Ledger, Debit + Credit
Optional - Default Ledger

IsMultiCol - Many Ledger, Many Amount
Amount info is now nested within ledger node
optional -  id,
            Default Ledger or
Dr or Cr Col empty)  Single Ledger + Debit + Credit + Default Ledger Col or Name
}
unit MrMc4;

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
  COLUMNLIMIT = 22;
  PGLEN = 4;
//  TallyAmtPicture = '############.##';

{$IFDEF ADO}
MDBSTR = 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=%s';
XLSSTR = 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=%s;Extended Properties="Excel 12.0;HDR=YES"';
//XLSSTR = 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=%s;Extended Properties="Excel 8.0;HDR=YES";Persist Security Info=False';
{$ENDIF}

type
  Tfnupdate = procedure(const msg: string);

  TbjMrMc = class(TinterfacedObject, IbjXlExp, IbjMrMc)
  private
    { Private declarations }
  protected
    UIdstr: string;
    UIdint: integer;
    cfgn: IbjXml;
    cfg: IbjXml;
    xcfg: IbjXml;
    kadb: TADoTable;
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
    RoundOffGroup: string;

    Amt: array [1..COLUMNLIMIT] of double;

{ COLUMNLIMIT - To limit looping  }
    IsLedgerDefined: array [1..COLUMNLIMIT] of boolean;
//    IsGSTNDefined: array [1..COLUMNLIMIT] of boolean;
    IsAmtDefined: array [1..COLUMNLIMIT] of boolean;
    IsCrAmtDefined: array [1..COLUMNLIMIT] of boolean;
    IsDrAmtDefined: array [1..COLUMNLIMIT] of boolean;
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
//    UGroupName: array [1..COLUMNLIMIT] of string;
    UGroupName: string;
    LedgerGroup: array [1..COLUMNLIMIT] of string;
{ +1 for RoundOff }
    LedgerDict: array [1..COLUMNLIMIT + 1] of TList;
    IsGSTNDefined: array [1..COLUMNLIMIT + 1] of boolean;
    UGSTNName: array [1..COLUMNLIMIT + 1] of string;
    UDateName: string;
    UTypeName: string;
    UNarrationName: string;
    UNarration2Name: string;
    UNarration3Name: string;

    IsAssessableDefined: array [1..COLUMNLIMIT] of boolean;
    UAssessableName: array [1..COLUMNLIMIT] of string;

{ if exosts value if not di}
    DateColValue: string;
    TypeColValue: string;
    LedgerColValue: string;

    IsAmt1Defined: boolean;
    IsCrAmt1Defined: boolean;
    IsDrAmt1Defined: boolean;
    IsNarrationDefined: boolean;
    IsNarration2Defined: boolean;
    IsNarration3Defined: boolean;
    IsTallyIdDefined: boolean;
    notoskip: integer;
    ProcessedCount: integer;
    IdName: string;
    UidName: string;
    VTotal: double;
    VchAction: string;
    DrAmtCol: string;
    CrAmtCol: string;
    DrAmtColType: string;
    CrAmtColType: string;
    IsCrDrAmtColsDefined: Boolean;
    RoundOffName: string;
    procedure ReadColNames;
    procedure CheckColNames;
    procedure OpenFile;
    procedure CreateRowLedgers;
    procedure CreateColLedgers;
    procedure NewIdLine;
    procedure Process;
    procedure ProcessRow;
    procedure ProcessCol(const level: integer);
    function IsIDChanged: boolean;
    procedure GetDefaults;
    procedure WriteStatus;
    function GetLedger(const level: integer): string;
    function GetRoundOffName: string;
    function GetAmt(const level: integer): double;
    function IsMoreColumn(const level: integer): boolean;
    procedure CheckColumn(const colname: string);
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
    CCount: integer;
    FUpdate: TfnUpdate;
    DefGroup: string;
    IsUnLocked: boolean;
    Host: string;
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
  end;

{ Level refers to Ledger Column with this Suffix  or Related Amount Colunn }
  TDict = Record
    Level: integer;
    Token: pChar;
    Value: pChar;
  end;
  pDict = ^TDict;

function GetFieldStr(fld: TField): string;

{$include VchUpdate.int}

implementation

uses
  Datamodule;

Constructor TbjMrMc.Create;
var
  i: integer;
begin
  Inherited;
  xmlFile := copy(Application.ExeName, 1, Pos('.exe', Application.ExeName)-1) + '.xml';
//  Cfgn := TbjXml.Create;
  Cfgn := CreatebjXmlDocument;
{  UNarration := '';}
{  Amt1 := '';}
  notoskip := 0;
  ProcessedCount := 0;;
  IdName := 'ID';
  UIdName := IdName;
  LedgerName[1] := 'LEDGER';
  ULedgerName[1] := 'LEDGER';
  UGroupName := 'GROUP';
  for i:= 2 to COLUMNLIMIT do
  begin
    LedgerName[i] := 'LEDGER' + InttoStr(i);
    ULedgerName[i] := 'LEDGER' + InttoStr(i);
  end;
//  for i:= 2 to COLUMNLIMIT do
//    UGroupName[i] := 'GROUP' + InttoStr(i);
  UAmountName[1] := 'AMOUNT';
  for i:= 2 to COLUMNLIMIT do
  begin
    UAmountName[i] := 'AMOUNT' + InttoStr(i);
  end;
  for i:= 1 to COLUMNLIMIT do
    AmountType[i] := 'Dr';
  UDateName := 'DATE';
  UTypeName := 'VTYPE';
  UNarrationName := 'NARRATION';
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
      StrDispose(ditem^.Token);
      StrDispose(ditem^.Value);
    end;
  LedgerDict[i].Clear;
  LedgerDict[i].Free;
  end;
  kadb.Close;
//  kadb.Active := False;
  kadb.Free;
  dm.ADOConnection.Connected := False;
  Cfgn.Clear;
  inherited;
end;

procedure TbjMrMc.ReadColNames;
var
  DataFolder: string;
  Database: string;
  VList: string;
  str: string;
  i: integer;
  dcfg, xxcfg: IbjXml;
  dItem: pDict;
begin
  if Length(XmlStr) > 0 then
    cfgn.LoadXML(XmlStr)
  else
  begin
    if not FileExists(XmlFile) then
      raise Exception.Create('Configuration file not found');
    cfgn.loadXmlFile(XmlFile);
  end;
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
  if Length(Vlist) <> 0 then
  if Length(FileName) = 0 then
    FileName := VList;
  DefGroup := xcfg.GetChildContent('DefaultGroup');
{ Round of tag moved from Ledger to Data }
  str := xcfg.GetChildContent('IsMultiRow');
   if  str = 'Yes' then
    IsMultiRowVoucher := True;
   str := xcfg.GetChildContent('IsMultiColumn');
  if  str = 'Yes' then
    IsMultiColumnVoucher := True;

  if Length(DefGroup) > 0 then
  begin
    SetDefaultGroup(pchar(DefGroup));
//    RefreshMstLists;
  end;

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
        pDict(dItem)^.Level := StrtoInt(dcfg.GetChildContent('Level'));
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

    str :=xCfg.GetChildContent('GSTN');
    UGSTNName[COLUMNLIMIT + 1] := str;
    if Length(str) > 0 then
      IsGSTNDefined[COLUMNLIMIT + 1] := True;
  end;

  xCfg := Cfg.SearchForTag(nil, UGroupName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
    UGroupName := str;
  end;

  xCfg := Cfg.SearchForTag(nil, UDateName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
    UDateName := str;
    DiDateValue := xCfg.GetChildContent('Default');
  end;

  xCfg := Cfg.SearchForTag(nil, UTypeName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
      UTypeName := str;
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
    IsAmtDefined[1] := True;
    IsAmtDefined[2] := True;
  end;

  xCfg := Cfg.SearchForTag(nil, UNarrationName);
  if Assigned(xCfg) then
  begin
//    str := xCfg.GetChildContent('Alias');
//    if Length(str) > 0 then
//    UNarrationName  := str;
  xCfg := Cfg.SearchForTag(xCfg, 'Alias');
  if xCfg <> nil then
  begin
    str := xCfg.GetContent;
    if Length(str) > 0 then
    begin
      UNarrationName  := str;
      IsNarrationDefined := True;
    end;
{ Unused Feature }
{ For Combining tow Narration Texts }
    xCfg := Cfg.SearchForTag(xCfg, 'Alias');
    if xCfg <> nil then
    begin
      str := xCfg.GetContent;
      if Length(str) > 0 then
      begin
        UNarration2Name  := str;
        IsNarration2Defined := True;
      end;
      xCfg := Cfg.SearchForTag(xCfg, 'Alias');
      if xCfg <> nil then
      begin
        str := xCfg.GetContent;
        if Length(str) > 0 then
        begin
          UNarration3Name  := str;
          IsNarration3Defined := True;
        end;
      end;
    end;
  end;
  end;

  xCfg := Cfg.SearchForTag(nil, IdName);
  if Assigned(xCfg) then
  begin
    str := xCfg.GetChildContent('Alias');
    if Length(str) > 0 then
      UIdName  := str;
  end;

  for i := 1 to COLUMNLIMIT do
  begin
    xCfg := Cfg.SearchForTag(nil, LedgerName[i]);
    if Assigned(xCfg) then
      DiLedgerValue[i] := xcfg.GetChildContent('Default');
    if Length(DiLedgerValue[i]) > 0 then
      IsLedgerDefined[i] := True;

    str := '';
    xCfg := cfg.SearchForTag(nil, LedgerName[i]);
    if Assigned(xCfg) then
      str := xCfg.GetChildContent('Alias');
    if Length(Str) > 0 then
    begin
      ULedgerName[i] := str;
      IsLedgerDefined[i] := True;
    end;

    xCfg := cfg.SearchForTag(nil, LedgerName[i]);
    if Assigned(xCfg) then
    begin
      LedgerGroup[i] := xCfg.GetChildContent('Group');

      xxCfg := xcfg.SearchForTag(nil, 'GSTN');
      if Assigned(xxCfg) then
      begin
      str := xxCfg.GetContent;
      UGSTNName[i] := str;
      if Length(str) > 0 then
        IsGSTNDefined[i] := True;
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
          IsAmtDefined[i] := True;
          AmountCols[i] := AmountCols[i] + 1;
        end;
        AmountType[i] := xxCfg.GetChildContent('Type');
        if (AmountType[i] <> 'Cr') and (AmountType[i] <> 'Dr') then
          AmountType[i] := 'Cr';
{ Default Ledger Name thr user defined value in Xml }
        IF xxCfg.GetChildContent('IsLedgerName') = 'Yes' then
          DiLedgerValue[i] := str;
{ Unused Feature }
{ For Combining tow Column Amounts }
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
          pDict(dItem)^.Level := StrtoInt(dcfg.GetChildContent('Level'));
          str := dcfg.GetChildContent('Token');
          pDict(dItem)^.Token := StrNew(pchar(str));
          str := dcfg.GetChildContent('Value');
          pDict(dItem)^.Value := StrNew(pchar(str));
          LedgerDict[i].Add(Ditem);
          dCfg := xcfg.SearchForTag(dcfg, 'Dict');
        end;
      end;
    end;
  end;
//Shifted from ChckcolNames as this is Xml file specific
{ If Ledger is definded corresponding amount column should be defined }
{ gaps should not exist }
  for i := 1 to COLUMNLIMIT do
  begin
    if IsLedgerDefined[i] then
    begin
      if IsLedgerDefined[i+1] then
         if not IsAmtDefined[i] then
           raise Exception.Create(UAmountName[i] + ' Column is required');
    end
    else
    begin
      if IsMoreColumn(i) then
         raise Exception.Create(ULedgerName[i] + ' Column is required');
    end;
  end;

{ Mandtory Minimum Columns }
  if not IsLedgerDefined[1] then
    raise Exception.Create(ULedgerName[1] + ' Column is required');
  if not IsAmtDefined[1] then
    raise Exception.Create(UAmountName[2] + ' Column is required');
end;

procedure TbjMrMc.OpenFile;
begin
//  if Length(Host) > 0 then
//    SetHost(pchar(Host));
{ No try except ...
passing Windows Exception as it is }
  if not FileExists(dbName) then
    raise Exception.Create(dbname + ' not found');
{$IFDEF ADO}
  if FileFmt = 'Excel_80_Table' then
  begin
    DM.AdoConnection.LoginPrompt:=False;//dont ask for the login parameters
//    DM.ADOConnection.ConnectionString := Format(XLSSTR, [dbName+'.xls']);
    DM.ADOConnection.ConnectionString := Format(XLSSTR, [dbName]);
    DM.AdoConnection.Connected:=True; //open the connection
    kadb := TADoTable.Create(nil);
    kadb.Connection := dm.AdoConnection;
    kadb.TableName := '['+ Filename+ '$]';
    Kadb.Active := True;
    if Assigned(FUpdate) then
      FUpdate('Reading '+ FileName);
    kadb.Open;
    if Assigned(FUpdate) then
    FUpdate('Processing '+ FileName);
  end;
{$ENDIF}
{$IFDEF DAO}
//  DAO stuff
  if FileFmt = 'Excel_120_BinaryTable' then
  begin
    kaTalywdb := TKADaoDatabase.Create(nil);
    kaTalywdb.DatabaseType:='Excel 12.0';
    kaTalywdb.RecreateCore;
    kaTalywdb.Database:='.\Data\Talywdb.xls';
    KATalywdb.Connected := True;
    kadb := TKADaoTable.Create(nil);
    kadb.Database := kaTalywdb;
    kadb.TableName := VList + '$';
{  kadb.TableType := DbOpenDynaset; }
    Kadb.Active := True;
  end;
  if FileFmt = 'Excel_120_Table' then
  begin
    kaTalywdb := TKADaoDatabase.Create(nil);
    kaTalywdb.DatabaseType:='Excel 12.0 xml';
    kaTalywdb.RecreateCore;
    kaTalywdb.Database:='.\Data\Talywdb.xls';
    KATalywdb.Connected := True;
    kadb := TKADaoTable.Create(nil);
    kadb.Database := kaTalywdb;
    kadb.TableName := VList + '$';
{  kadb.TableType := DbOpenDynaset; }
    Kadb.Active := True;
  end;
{$ENDIF}
{$IFDEF ADO}
  if FileFmt = 'Jet_3x_Table' then
  begin
    DM.AdoConnection.LoginPrompt:=False;//dont ask for the login parameters
//    DM.ADOConnection.ConnectionString := Format(MDBSTR, [dbName+'.mdb']);
    DM.ADOConnection.ConnectionString := Format(MDBSTR, [dbName]);
    DM.AdoConnection.Connected:=True; //open the connection
    dm.ADOConnection.Connected := True;
    kadb := TADoTable.Create(nil);
    kadb.Connection := dm.AdoConnection;
    kadb.TableName := fileName;
//    kadb.ReadOnly := True;
    Kadb.Active := True;
  end;
{$ENDIF}
//  if frmSetting.FileFmt = 'FoxPro_26_Table' then
{$IFDEF DAO}
  DAO stuff
  if FileFmt = 'dBase III' then
  begin
    kaTalywdb := TKADaoDatabase.Create(nil);
    kaTalywdb.DatabaseType:='dBase III';
    kaTalywdb.RecreateCore;
    kaTalywdb.Database:='.\Data\';
    KATalywdb.Connected := True;
    kadb := TKADaoTable.Create(nil);
    kadb.Database := kaTalywdb;
    kadb.TableName := VList;
{  kadb.TableType := DbOpenDynaset; }
    Kadb.Active := True;
  end;
{$ENDIF}
  kadb.First;
  if kadb.Eof then
    raise Exception.Create('Table is Empty');;
end;

procedure TbjMrMc.Execute;
begin
//  if not TestConnection(Host, 'Tally', '') then
//    Exit;
  ProcessedCount := 0;
  ReadColNames;
  OpenFile;
  CheckColNames;
  if Length(Host) > 0 then
    SetHost(pchar(Host));
//  TestConnection(Host, 'Tally', 'Error connecting to Tally');
(*
  kadb.First;
  while (not kadb.Eof)  do
  begin
    if kadb.FindField(UIdName) <> nil then
    if (Length(kadb.FieldByName(UIdName).AsString) = 0) then
      break;
{ or Make sure date is empty }
    if not IsMultiRowVoucher then
      if kadb.FindField(UDateName) <> nil then
        if (Length(kadb.FieldByName(UDateName).AsString) = 0) then
          break;
    for i:= 1 to COLUMNLIMIT do
      if IsGSTNDefined[i] then
        NewParty(pchar(kadb.FieldByName(ULedgerName[I]).AsString), pchar(LedgerGroup[i]), pChar(kadb.FieldByName(UGSTNName[i]).AsString));
    kadb.Next;
  end;
*)
  RefreshMstLists;
  kadb.First;
  if IsMultiRowVoucher then
  begin
  while (not kadb.Eof)  do
  begin
    CreateRowLedgers;
    kadb.Next;
  end;
  kadb.First;
  end;
  NewIdLine;
  while (not kadb.Eof)  do
  begin
{ Make sure id is empty }
    if kadb.FindField(UIdName) <> nil then
    if (Length(kadb.FieldByName(UIdName).AsString) = 0) then
      break;
{ or Make sure date is empty }
    if not IsMultiRowVoucher then
      if kadb.FindField(UDateName) <> nil then
        if (Length(kadb.FieldByName(UDateName).AsString) = 0) then
          break;
    Process;
    if IsIdOnlyChecked then
      Continue;
    kadb.Next;
    if not kadb.Eof then
      notoskip := notoskip + 1;
  end;
  WriteStatus;
  MessageDlg(InttoStr(CCount) + ' Vouchers processed',
      mtInformation, [mbOK], 0);
  FUpdate(InttoStr(CCount) + ' Vouchers processed');
end;

procedure TbjMrMc.Process;
var
  FoundId: boolean;
begin
  FoundId :=  IsIDChanged;
  if not FoundId then
  begin
    ProcessRow;
  end;
  if FoundId then
  begin
    WriteStatus;
    NewIdline;
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
//  if abs(Amt[1]) > 0.009 then
    VTotal := VTotal + StrtoFloat(FormatFloat(TallyAmtPicture, Amt[1]));
//  VTotal := VTotal + RoundTo(Amt[1], -2);
  end;
  if IsMultiColumnVoucher then
    ProcessCol(2);
  IsIdOnlyChecked := False;
end;

procedure TbjMrMc.ProcessCol(const level: integer);
var
  contraamt: double;
  i: integer;
  LedgerColValue: string;
begin
  if not IsIdOnlyChecked then
    Exit;
  if not IsLedgerDefined[level] then
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
//    if Amt[level] <> 0 then
    VTotal := VTotal + StrtoFloat(FormatFloat(TallyAmtPicture, Amt[level]));
//    VTotal := VTotal + RoundTo(Amt[level], -2);
    ProcessCol(level+1);
  end;
  if Amt[level] = 0 then
  begin
    if IsMoreColumn(level) then
    begin
      ProcessCol(level+1);
      exit;
    end;

    Contraamt := 0;
    for i := 1 to level-1 do
      Contraamt := ContraAmt + amt[i];
    Contraamt := - Contraamt;
    if (abs(ContraAmt) >= 0.01) then
    begin
      AddLine(pchar(LedgerColValue), ContraAmt);
    if IsAssessableDefined[level] then
      SetAssessable(kadb.FieldByName(UAssessableName[level]).AsFloat);
      VTotal := VTotal + StrtoFloat(FormatFloat(TallyAmtPicture, ContraAmt));
    end;
//    VTotal := VTotal + RoundTo(ContraAmt, -2);
  end;
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
{ Check for TallyId }
  for i := 0 to kadb.FieldDefs.Count-1 do
  begin
    Col := kadb.FieldDefs[i];
//    if col.Name = UNarrationName then
//      IsNarrationDefined := True;
    if col.Name = 'TALLYID' then
      IstALLYiDDefined := True;
  end;
//  if not IsTallyIdDefined then
//    kadb.ReadOnly := True;

{ Fill IsAmtDefined array
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
  if IsMultiRowVoucher then
    CheckColumn(UIdName);
  CheckColumn(ULedgerName[1]);
  if Length(DiDateValue) = 0 then
    CheckColumn(UDateName);
  if Length(DiTypeValue) = 0 then
    CheckColumn(UTypeName);

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
//     if Length(RoundOffCol) > 0 then
//       NewLedger(pChar(RoundOffCol), pChar(RoundOffGroup), 0)
//     else
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
end;

procedure TbjMrMc.CreateColLedgers;
var
  i: integer;
begin
  for i:= 1 to COLUMNLIMIT do
    if IsGSTNDefined[i] then
      NewParty(pchar(kadb.FieldByName(ULedgerName[I]).AsString), pchar(LedgerGroup[i]), pChar(kadb.FieldByName(UGSTNName[i]).AsString));
    if IsGSTNDefined[COLUMNLIMIT+1] then
    if Length(RoundOffCol) > 0 then
       NewParty(pChar(kadb.FieldByName(RoundOffCol).AsString), pChar(RoundOffGroup), pChar(kadb.FieldByName(UGSTNName[COLUMNLIMIT+1]).AsString));

  for i := 1 to COLUMNLIMIT do
    if (Length(LedgerGroup[i]) > 0) then
//      if Length(ULedgerName[i]) > 0 then
        if kadb.FindField(ULedgerName[i]) <> nil then
        NewLedger(pchar(kadb.FieldByName(ULedgerName[i]).AsString), pchar(LedgerGroup[i]), 0);
end;

procedure TbjMrMc.CreateRowLedgers;
begin
  if kadb.FindField(UGroupName) <> nil then
    if Length(kadb.FieldByName(UGroupName).AsString) > 0 then
    if IsGSTNDefined[1] then
    NewParty(pchar(kadb.FieldByName(ULedgerName[1]).AsString),
        pchar(kadb.FieldByName(UGroupName).AsString),
        pChar(kadb.FieldByName(UGSTNName[COLUMNLIMIT+1]).AsString))
    else
    NewLedger(pchar(kadb.FieldByName(ULedgerName[1]).AsString),
        pchar(kadb.FieldByName(UGroupName).AsString), 0);
//ShowMessage(kadb.FieldByName(UGroupName).AsString);
end;

procedure TbjMrMc.NewIdLine;
var
  TId: string;
//  sint: integer;
begin
  CreateColLedgers;
  if kadb.FindField(UIdName) <> nil then
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
  StartVch(pchar(tid), pchar(DateColValue),
  pchar(typeColValue), pchar(NarrationColValue));
  RoundOffName := GetRoundOffName;
  notoskip := 0;
  IsIdOnlyChecked := True;
end;

{***}
procedure TbjMrMc.GetDefaults;
begin
{  GetSingleValues; }
  try
  if kadb.FindField(UDateName) <> nil then
    if Length(kadb.FieldByName(UDateName).AsString) > 0 then
    DateColValue := GetFieldStr(kadb.FieldByName(UDateName));
  except
  DateColValue := '';
  end;
  if Length(DateColValue) = 0 then
    DateColValue := DiDateValue;
  if kadb.FindField(UTypeName) <> nil then
    TypeColValue := GetFieldStr(kadb.FieldByName(UTypeName));
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
  if kadb.FindField(UNarrationName) <> nil then
    NarrationColValue := GetFieldStr(kadb.FieldByName(UNarrationName));
  if IsNarration2Defined then
  if kadb.FindField(UNarration2Name) <> nil then
    NarrationColValue := NarrationColValue + GetFieldStr(kadb.FieldByName(UNarration2Name));
  if IsNarration3Defined then
  if kadb.FindField(UNarration3Name) <> nil then
    NarrationColValue := NarrationColValue + GetFieldStr(kadb.FieldByName(UNarration3Name));
end;

{
Id can be determined with date and voucher total.
If there is demand...
}
function TbjMrMc.IsIDChanged: boolean;
begin
  Result := False;
  if kadb.FindField(UIdName) <> nil then
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
//      if pDict(Item)^.Token = kadb.FieldByName(ULedgerName[level]).AsString then
      if pDict(Item)^.Token = kadb.FieldByName(ULedgerName[pDict(Item)^.level]).AsString then
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
  if kadb.FindField(ULedgerName[level]) <> nil then
  if (Length(kadb.FieldByName(ULedgerName[level]).AsString) > 0) then
  begin
    lstr := kadb.FieldByName(ULedgerName[level]).AsString;
    Result := lstr;
  end;

  if Length(lstr) = 0 then
  begin
    lstr := DiLedgerValue[level];
    Result := lstr;
  end;
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
      if Length(Trim(kadb.FieldByName(CrAmtCol).AsString)) > 0 then
      if kadb.FieldByName(CrAmtCol).AsFloat<> 0 then
        Result := kadb.FieldByName(CrAmtCol).AsFloat;
      if Length(Trim(kadb.FieldByName(DrAmtCol).AsString)) > 0 then
      if kadb.FieldByName(DrAmtCol).AsFloat <> 0 then
        Result := -kadb.FieldByName(DrAmtCol).AsFloat;
    end;
    Exit;
  end;
{ IsMultiCol }
  if IsAmtDefined[level] then
  begin
    if Length(kadb.FieldByName(UAmountName[level]).AsString) > 0 then
//    if kadb.FieldByName(UAmountName[level]).AsFloat <> 0 then
    begin
      Result := StrtoFloat(kadb.FieldByName(UAmountName[level]).AsString);
//      Result := kadb.FieldByName(UAmountName[level]).AsFloat;
      if AmountType[level] = 'Dr' then
        Result := - StrtoFloat(kadb.FieldByName(UAmountName[level]).AsString);
//        Result := - kadb.FieldByName(UAmountName[level]).AsFloat;
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
  if IsLedgerDefined[i+1] then
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
{
Depending on token in one column 1 RoundOff ledger is derived
}
  if Assigned(LedgerDict[COLUMNLIMIT+1]) then
  begin
    for i := 0 to LedgerDict[COLUMNLIMIT+1].Count-1 do
    begin
      Item := LedgerDict[COLUMNLIMIT+1].Items[i];
      if pDict(Item)^.Token = kadb.FieldByName(ULedgerName[pDict(Item)^.level]).AsString then
      begin
        lStr := pDict(Item)^.Value;
        break;
      end;
    end;
  end;
  if Length(lstr) > 0 then
  begin
    Result := lstr;
    Exit;
  end;
  if Length(RoundOffCol) > 0 then
    Result := kadb.FieldByName(RoundOffCol).AsString
  else
    if Length(DiRoundOff) <> 0 then
    Result := DiRoundOff;
end;

procedure TbjMrMc.WriteStatus;
var
  i: integer;
  statmsg: integer;
//  RoundOffName: string;
begin
//  RoundOffName := GetRoundOffName;
  vchAction := 'Create';
  if Abs(VTotal) >= 0.01 then
    AddLine(pChar(RoundOffName), - VTotal);

  statmsg := PostVch(pchar(VchAction));
  VTotal := 0;
  if Assigned(FUpdate) then
      FUpdate('Processed ' + InttoStr(statmsg));
  ProcessedCount := ProcessedCount + 1;

  for i := 1 to notoskip do
    kadb.Prior;
  if isTallyIdDefined then
  begin
    kadb.Edit;
//    kadb.FieldByName('TALLYID').AsInteger := StatMsg;
    if StatMsg = 0 then
    kadb.FieldByName('TALLYID').AsString := 'Error';
    kadb.Post;
  end;
  for i := 1 to notoskip do
    kadb.Next;
  notoskip := 0;
  if StatMsg <> 0 then
    CCount := Ccount + 1;
end;

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
      ColumnExists := True;
  end;
  if not ColumnExists then
    raise Exception.Create(Colname + ' column is Required');
end;

function GetFieldStr(fld: TField): string;
var
  newvar: string;
begin
{  if (fld.DataType = ftUnknown) then}
    newvar := fld.Text;
  if (fld.DataType = ftString) then
    newvar := fld.AsString;
  if fld.DataType = ftfloat then
    newvar := FormatFloat(TallyAmtPicture, fld.AsFloat);
  if fld.DataType = ftDateTime then
  begin
    newvar := FormatDateTime('yyyymmdd', fld.AsDateTime);
//    newvar := FormatDateTime('dd-mm-yy', fld.AsDateTime);
  end;
  Result := pchar(NewVar);
end;

end.

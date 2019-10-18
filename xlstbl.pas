unit xlstbl;
{
Index (0-based) Format string
0 General
1 0
2 0.00
3 #,##0
4 ($#,##0_);($#,##0)
5 ($#,##0_);[Red]($#,##0)
6 ($#,##0.00_);($#,##0.00)
7 ($#,##0.00_);[Red]($#,##0.00)
8 0%
9 0.00%
10 0.00E+00
11 # ?/?
12 # ??/??
13 m/d/yy
14 d-mmm-yy
15 d-mmm
16 mmm-yy
17 h:mm AM/PM
18 h:mm:ss AM/PM
19 h:mm
20 h:mm:ss
21 m/d/yy h:mm
22 _($* #,##0_);_($* (#,##0);_($* "-"_);_(@_)
23 _(* #,##0_);_(* (#,##0);_(* "-"_);_(@_)
24 _($* #,##0.00_);_($* (#,##0.00);_($* "-"??_);_(@_)
25 _(* #,##0.00_);_(* (#,##0.00);_(* "-"??_);_(@_)
26 #,##0.00
27 (#,##0_);(#,##0)
28 (#,##0_);[Red](#,##0)
29 (#,##0.00_);(#,##0.00)
30 (#,##0.00_);[Red](#,##0.00)
31 mm:ss
32 [h]:mm:ss
33 mm:ss.0
34 ##0.0E+0
35 @
}
{$DEFINE SM }
{$IFNDEF SM }
{$DEFINE LIBXL }
{$ENDIF SM }

interface
uses
  SysUtils, Classes,
  Windows,
{$IFDEF SM }
  XLSFile,
  XLSWorkbook,
{$ENDIF SM }
{$IFDEF LibXL }
  LibXL,
{$ENDIF }
  bjXml3_1,
  Variants,
  StrUtils,
  Dialogs;

{$IFDEF LibXL }
type
   TColumn = TFilterColumn;
{$ENDIF }

type
(*
  IDataset = interface(IInterface)
    ['{FB7722CC-62D4-4400-B93A-AAA4401246BD}']
    function GetFields: IDataFields; stdcall;
    function GetHead: IDatasetHead; stdcall;
    function GetRecordCount: Integer; stdcall;
    function GetValues: IDataValues; stdcall;
    function IsEmpty:Boolean;
    procedure First;
    procedure Last;
    procedure Next;
    procedure Prior;
    procedure Append;
    procedure Post;
    procedure Edit;
    procedure Open;
    procedure Close;
    procedure Clear;
    function Locate(const KeyFields: string; const KeyValues: Variant):Boolean; stdcall;
    function CopyData(const ASource:IDataset): HResult; stdcall;
    function CopyHead(const ASource:IDatasetHead): HResult; stdcall;
    function GetActive: Boolean;
    function GetBof: Boolean;
    function GetEof: Boolean;
    function RecordState: TMemStarUpdateStatus; stdcall;
    procedure ClearState;
    function GetEditState: Boolean; stdcall;
    procedure ReplaceValue(const AFieldName:string; AOldVal, ARepVal:Variant);
        stdcall;
    procedure SetActive(Value: Boolean);
    procedure SetEditState(const Value: Boolean); stdcall;
    property Active: Boolean read GetActive write SetActive;
    property Bof: Boolean read GetBof;
    property EditState: Boolean read GetEditState write SetEditState;
    property Eof: Boolean read GetEof;
    property Fields: IDataFields read GetFields;
    property Head: IDatasetHead read GetHead;
    property RecordCount: Integer read GetRecordCount;
    property Values: IDataValues read GetValues;
  end;
*)

  TbjXLSTable = class(TInterfacedObject)
//  TbjXLSTable = class
  private
    FO_Row: integer;
    FO_Column: integer;
{    FMaxRow: integer; }
    FxLSFileName: string;
    FSheetName: string;
    FToSaveFile: boolean;
    FOWner: boolean;
  protected
    function IsEmpty: boolean;
    function GetFieldCol(const aName: string): integer;
  public
  { Public declarations }
    IDate: integer;
    BOF: boolean;
    EOF: boolean;
    LastRow:  integer;
{$IFDEF SM }
    XL: TXLSFile;
    Workbook: TWorkbook;
    WorkSheet: TSheet;
{$ENDIF SM }
{$IFDEF LIBXL }
    Workbook: TbOOK;
    WorkSheet: TSheet;
{$ENDIF LIBXL }
    CurrentColumn: integer;
    CurrentRow: integer;
    FieldList: TStringList;
    ColumnList: array of integer;
    procedure SetXLSFile(const aName: string);
    procedure NewFile(const aName: string);
    procedure SetSheet(const aSheet: string);
    procedure Close;
    procedure SetOrigin(const aRow, aColumn: integer);
    function GetFieldVal(const aField: string): variant;
//    function GetFieldStr(const aField: string): string;
    function GetFieldFloat(const aField: string): double;
    function GetFieldString(const aField: string): string;
    function GetFieldSDate(const aField: string): string;
    function GetFieldToken(const aField: string): string;
//    procedure SetFieldType(const aField: string; const aType: integer);
{$IFDEF SM }
    function GetFieldObj(const aField: string): TColumn;
    function GetCellObj(const arow: integer; const aField: string): TCell; overload;
    function GetCellObj(const arow: integer; const aCol: integer): TCell; overload;
    procedure SetFieldFormat(const aField: string; const aFOrmat: Integer);
    procedure SetFormatAt(const aCol: integer; aFOrmat: Integer);
    procedure SetCellFormat(const aField: string; aFOrmat: Integer);
{$ENDIF SM }
    procedure SetFieldVal(const aField: string; const aValue: variant);
    function FindField(const aName: string): pChar;
//    function GetFieldCol(const aName: string): integer;
    procedure SetFields(const aList: TStrings; const ToWrite: boolean);
    function GetFields(const aList: TStrings): Tstrings;
    procedure ParseXml(const aNode: IbjXml; const FldLst: TStringList);
    function IsEmptyField(const aField: string): boolean;
    procedure Insert;
    procedure Delete;
    procedure ClearRow;
    procedure Next;
    procedure Prior;
    procedure First;
    procedure Last;
    procedure Save(const aName: string);
    procedure AtSay(const acol: Integer; const aMsg: Variant);
    constructor Create;
    destructor Destroy; override;

    property O_Row: integer read FO_row;
    property O_Column: integer read FO_Column;
{    property MaxRow: integer read FMaxRow write FMaxRow; }
    property XLSFileName: string write SetXLSFile;
    property ToSaveFile: boolean read FToSaveFile write FToSaveFile;
    property SheetName: string write SetSheet;
    property Owner: boolean read Fowner write Fowner;
//    property FieldVal[aField: string]: variant read GetVal write SetVal;
  end;

implementation


constructor TbjXLSTable.Create;
begin
{
  FO_Row  := 0;
  FO_Column  := 0;
}
  FToSaveFile := False;
  FieldList := TStringList.Create;
  LastRow := -1;
{  FMaxRow := -1; }
end;

destructor TbjXLSTable.Destroy;
begin
  FieldList.Clear;
  FieldList.Free;
if Owner then
begin
{$IFDEF SM }
    WorkSheet := nil;
    Workbook := nil;
    XL.Clear;
    XL.Free;
{$ENDIF SM }
{$IFDEF LibXL }
  Workbook.Free;
{$ENDIF LIBXL }
end;
  Inherited;
end;

procedure TbjXLSTable.Save(const aName  : string);
begin
{$IFDEF SM }
  XL.SaveAs(AName);
{$ENDIF SM }
{$IFDEF LIBXL }
  Workbook.Save(PChar(AName));
{$ENDIF LIBXL}
end;

//procedure TbjXLSTable.SetXLSFile(const aName  : string);
procedure TbjXLSTable.SetXLSFile(const aName  : string);
begin
{$IFDEF SM }
  if Assigned(XL) then
    XL.Clear;
  FXLSFileName := aName;
  if not Assigned(XL) then
  begin
    XL := TXLSFile.Create;
    FOwner := True;
  end;

  if FileExists(FXLSFileName) then
  begin
    XL.OpenFile(FXLSFileName);
  end
  else
    Exit;
  Workbook := XL.Workbook;
  WorkSheet := Workbook.Sheets[0];
//  IDate:= Workbook.FormatStrings.AddFormat('dd/mm/yyyy');
{$ENDIF SM }
{$IFDEF LIBXL }
  FXLSFileName := aName;
  Workbook := TBinBook.Create;
  Workbook.setKey('Sri', 'windows-21212c060ecde40e64bf6569abo5p2h2');
  if FileExists(aName) then
  begin
    Workbook.load(pChar(aName));
    FOwner := True;
  end
  else
    Exit;
  WorkSheet := Workbook.getSheet(0);
{$ENDIF LIBXL}
end;

procedure TbjXLSTable.NewFile(const aName  : string);
begin
{$IFDEF SM }
  if Assigned(XL) then
    XL.Clear;
  FXLSFileName := aName;
  if not Assigned(XL) then
  begin
    XL.Free;
  end;
  XL := TXLSFile.Create;
  FOwner := True;

  Workbook := XL.Workbook;
//  WorkSheet := Workbook.Sheets[0];
{$ENDIF SM }
{$IFDEF LIBXL }
  FXLSFileName := aName;
  Workbook := TBinBook.Create;
  Workbook.setKey('Sri', 'windows-21212c060ecde40e64bf6569abo5p2h2');
    FOwner := True;
//  WorkSheet := Workbook.getSheet(0);
{$ENDIF LIBXL}
end;

procedure TbjXLSTable.close;
begin
  SetXLSFile('');
end;

procedure TbjXLSTable.SetSheet(const aSheet: string);
begin
  if not Assigned(Workbook) then
    Exit;
  if FSheetName = aSheet then
    Exit;
{$IFDEF SM }
  WorkSheet := Workbook.SheetByName(aSheet);
  if not Assigned(WorkSheet) then
  begin
    Workbook.Sheets.Add(aSheet);
    WorkSheet := Workbook.SheetByName(aSheet);
  end;
{$ENDIF SM}
{$IFDEF LIBXL }
  WorkSheet := Workbook.GetSheetbyName(PChar(aSheet));
  if not Assigned(WorkSheet) then
  begin
    Workbook.addSheet(PChar(aSheet));
    WorkSheet := Workbook.GetSheetByName(PChar(aSheet));
  end;
{$ENDIF LIBXL}
end;

procedure TbjXLSTable.SetOrigin(const aRow, aColumn: integer);
begin
  FO_Row := aRow;
  FO_Column :=aColumn;
end;

function TbjXLSTable.GetFieldVal(const aField: string): variant;
{$IFDEF LIBXL }
var
  wCellType: CellType;
  wDateFormat: TFormat;
{$ENDIF LIBXL}
begin
  if FindField(aField) = nil then
  begin
    raise Exception.Create(aField + ' Column not defined');
    Exit;
  end;
{$IFDEF SM }
  Result := WorkSheet.Cells[FO_row + CurrentRow, FO_Column + GetFieldCol(aField)].Value;
//  Result := Encode(WorkSheet.Cells[FO_row + CurrentRow, FO_Column + GetFieldCol(aField)].Value);
{$ENDIF SM}
{$IFDEF LIBXL }
  wCellType := WorkSheet.GetCellType(FO_row + CurrentRow, FO_Column + GetFieldCol(aField));
  if (wCellType = CELLTYPE_EMPTY) or (wCellType = CELLTYPE_BLANK) then
//  if (wCellType = CELLTYPE_EMPTY) then
    Exit;
  if WorkSheet.isDate(FO_row + CurrentRow, FO_Column + GetFieldCol(aField)) then
  begin
    wDateFormat := Workbook.addFormat();
    wDateFormat.setNumFormat(NUMFORMAT_DATE);
    Result := FormatDateTime('dd/mm/yyyy', WorkSheet.ReadNum(FO_row + CurrentRow, FO_Column + GetFieldCol(aField), wDateformat));
    Exit;
  end;
  if wCellType = CELLTYPE_STRING then
    Result := WorkSheet.ReadStr(FO_row + CurrentRow, FO_Column + GetFieldCol(aField));
  if wCellType = CELLTYPE_NUMBER then
    Result := WorkSheet.ReadNum(FO_row + CurrentRow, FO_Column + GetFieldCol(aField));
{$ENDIF LIBXL}
end;
{
function TbjXLSTable.GetFieldStr(const aField: string): string;
var
  v_vt: variant;
  VType  : Integer;
begin
  v_vt := GetFieldVal(aField);
  VType := VarType(V_vt) and VarTypeMask;
  // Set a string to match the type
  case VType of
  varEmpty:
    Exit;
  varDate:
   Result := FormatDateTime('yyyymmdd', V_vt);
  varDouble:
    Result := FormatFloat('############.##', V_vt);
  varCurrency:
    Result := FormatFloat('############.##', V_vt);
  varString:
   Result := V_vt;
  end;
end;
}
function TbjXLSTable.GetFieldSDate(const aField: string): string;
var
  v_vt: variant;
  VType: Integer;
  mnth: integer;
  str: string;
begin
  v_vt := GetFieldVal(aField);
  str := V_vt;
  VType := VarType(V_vt) and VarTypeMask;
  // Set a string to match the type
  case VType of
  varEmpty:
    Exit;
  end;
  if str[1] = '''' then
  begin
    Result := Copy(Str, 2, Length(str)-1);
    Exit;
  end;
  VType := VarType(V_vt) and VarTypeMask;
  // Set a string to match the type
  case VType of
  varDate:
    Result := FormatDateTime('yyyymmdd', V_vt);
  varString:
  begin
     Result := V_vt;
     if (Result[4] in ['0'..'9']) and (Result[5] in ['0'..'9'])
     and not (Result[3] in ['0'..'9']) and not (Result[6] in ['0'..'9']) then
     begin
       mnth := Strtoint(copy(Result, 4, 2));
       if mnth > 12 then
         raise Exception.Create('Invalid Date Format');
     end;
  end;
  end;
end;

function TbjXLSTable.GetFieldFloat(const aField: string): double;
var
  v_vt: variant;
  VType  : Integer;
  str: string;
  iValue: double;
  iCode: Integer;
begin
  Result := 0;
  v_vt := GetFieldVal(aField);
  str := V_vt;
  if Pos(',', str) > 0 then
  begin
    str := stringReplace(Str, ',', '', [rfIgnoreCase, rfReplaceAll]);
    Val(Str, iValue, iCode);
    if iCode = 0 then
    begin
      Result := iValue;
      Exit;
    end;
  end;
  VType := VarType(v_vt) and VarTypeMask;
  // Set a string to match the type
  case VType of
  varEmpty:
    begin
    Result := 0;
    Exit;
    end;
  varInteger:
    begin
    Result := V_vt;
    end;
  varDate:
    begin
    Result := V_vt;
    end;
  varDouble:
    begin
    Result := V_vt;
    end;
  varCurrency:
    begin
    Result := V_vt;
    end;
  varString:
    begin
    Val(Str, iValue, iCode);
    if iCode = 0 then
      Result := iValue;
    end;
  else
    Result := 0;
  end;
end;
function TbjXLSTable.GetFieldToken(const aField: string): string;
var
  v_vt: variant;
  VType  : Integer;
  str: string;
begin
  Result := '';
  v_vt := GetFieldVal(aField);
  VType := VarType(v_vt) and VarTypeMask;
  case VType of
  varEmpty:
    Exit;
  end;
  str := V_vt;
  if Pos('%', str) > 0 then
  begin
    str := stringReplace(Str, '%', '', [rfIgnoreCase, rfReplaceAll]);
    Result := str;
    Exit;
  end;
  if RightStr(str, 3) = '.00' then
  begin
    str := stringReplace(Str, '.00', '', [rfIgnoreCase, rfReplaceAll]);
    Result := str;
    Exit;
  end;
  if RightStr(str, 2) = '.0' then
  begin
    str := stringReplace(Str, '.0', '', [rfIgnoreCase, rfReplaceAll]);
    Result := str;
    Exit;
  end;
  if Pos('.', str) > 0 then
  begin
    if STrtoFloat(str) < 1 then
      Result := FormatFloat('##.##', V_vt * 100);
    Exit;
  end;
{
  else
    Result := '';
}
{$IFDEF SM }
  Result := WorkSheet.Cells[FO_Row + CurrentRow,
    FO_Column + GetFieldCol(aField)].ValueAsString;
{$ENDIF SM }
{$IFDEF LIBXL }
  if WorkSheet.GetCellType(FO_row + CurrentRow, FO_Column + GetFieldCol(aField)) = CELLTYPE_NUMBER then
  begin
    Result := FloattoStr(WorkSheet.ReadNum(FO_Row + CurrentRow,
    FO_Column + GetFieldCol(aField)));
  end;
  if WorkSheet.GetCellType(FO_row + CurrentRow, FO_Column + GetFieldCol(aField)) = CELLTYPE_STRING then
  begin
    Result := WorkSheet.ReadStr(FO_Row + CurrentRow,
    FO_Column + GetFieldCol(aField));
  end;
{$ENDIF LIBXL }
end;

function TbjXLSTable.GetFieldString(const aField: string): string;
begin
  if FindField(AField) = nil then
  begin
    raise Exception.Create(aField + ' Column not defined');
    Exit;
  end;
{$IFDEF SM }
  Result := WorkSheet.Cells[FO_Row + CurrentRow,
    FO_Column + GetFieldCol(aField)].ValueAsString;
{$ENDIF SM }
{$IFDEF LIBXL }
  if WorkSheet.GetCellType(FO_row + CurrentRow, FO_Column + GetFieldCol(aField)) = CELLTYPE_NUMBER then
  begin
    Result := FloattoStr(WorkSheet.ReadNum(FO_Row + CurrentRow,
    FO_Column + GetFieldCol(aField)));
  end;
  if WorkSheet.GetCellType(FO_row + CurrentRow, FO_Column + GetFieldCol(aField)) = CELLTYPE_STRING then
  begin
    Result := WorkSheet.ReadStr(FO_Row + CurrentRow,
    FO_Column + GetFieldCol(aField));
  end;
{$ENDIF LIBXL }
end;


{
procedure TbjXLSTable.SetFieldType(const aField: string; const aType: integer);
var
  ctr: integer;
  ccolumn: TColumn;
begin
  ctr := GetFieldCol(aField);
  Ccolumn := WorkSheet.Columns[FO_Column + ctr];
  Ccolumn.FormatStringIndex:= aType;
end;
}

{$IFDEF SM }
function TbjXLSTable.GetFieldObj(const aField: string): TColumn;
var
  ctr: integer;
begin
  ctr := GetFieldCol(aField);
{.$IFDEF SM }
  Result := WorkSheet.Columns[FO_Column + ctr];
{.$ENDIF SM }
{.$IFDEF LIBXL }
{.$ENDIF LIBXL }
end;
procedure TbjXLSTable.SetFieldFormat(const aField: string; const aFOrmat: Integer);
var
  ctr: integer;
  MyColumn: TColumn;
begin
  ctr := GetFieldCol(aField);
  if ctr = -1 then
    Exit;
  MyColumn:= GetFieldObj(AField);
    MyColumn.FormatStringIndex := aFOrmat;
end;
procedure TbjXLSTable.SetFormatAt(const aCol: integer; aFOrmat: Integer);
var
  MyCell: TCell;
begin
  MyCell:= WorkSheet.Cells[FO_Row + CurrentRow, FO_Column + aCol];
  MyCell.FormatStringIndex := aFOrmat;
end;
procedure TbjXLSTable.SetCellFormat(const aField: string; aFOrmat: Integer);
var
  ctr: integer;
  MyCell: TCell;
begin
  ctr := GetFieldCol(aField);
  if ctr = -1 then
    Exit;
  MyCell := GetCellObj(FO_Row + CurrentRow, aField);
  MyCell.FormatStringIndex := aFOrmat;
end;

function TbjXLSTable.GetCellObj(const arow: integer; const aField: string): TCell;
var
  ctr: integer;
begin
  ctr := GetFieldCol(aField);
  Result := WorkSheet.Cells[FO_Row + aRow, FO_Column + ctr];
end;

function TbjXLSTable.GetCellObj(const arow: integer; const aCol: integer): TCell;
begin
  Result := WorkSheet.Cells[FO_Row + aRow, FO_Column + aCol];
end;
{$ENDIF SM }
procedure TbjXLSTable.SetFieldVal(const aField: string; const aValue: variant);
{$IFDEF LIBXL }
var
  VType  : Integer;
{$ENDIF LIBXL }
begin
  if FindField(AField) = nil then
  begin
    raise Exception.Create(aField + ' Column not defined');
    Exit;
  end;
{$IFDEF SM }
  WorkSheet.Cells[FO_Row + CurrentRow, FO_Column + GetFieldCol(aField)].Value := aValue;
{$ENDIF SM }
{$IFDEF LIBXL }
  VType := VarType(aValue) and VarTypeMask;
  case VType of
  varEmpty:
    Exit;
  varInteger:
    WorkSheet.WriteNum(FO_row + CurrentRow, FO_Column + GetFieldCol(aField), aValue);
  varDate:
    WorkSheet.WriteNum(FO_row + CurrentRow, FO_Column + GetFieldCol(aField), aValue);
  varDouble:
    WorkSheet.WriteNum(FO_row + CurrentRow, FO_Column + GetFieldCol(aField), aValue);
  varCurrency:
    WorkSheet.WriteNum(FO_row + CurrentRow, FO_Column + GetFieldCol(aField), aValue);
  varString:
    WorkSheet.WriteStr(FO_row + CurrentRow, FO_Column + GetFieldCol(aField), pChar(string(aValue)));
  end;
{$ENDIF LIBXL }
//  WorkSheet.Cells[FO_Row + CurrentRow, FO_Column + GetFieldCol(aField)].Value := Decode(aValue);
end;
procedure TbjXLSTable.AtSay(const acol: Integer; const aMsg: Variant);
{$IFDEF LIBXL }
var
  VType  : Integer;
{$ENDIF LIBXL }
begin
{$IFDEF SM }
  WorkSheet.Cells[FO_Row + CurrentRow, FO_Column + aCol].Value := aMsg;
{$ENDIF SM }
{$IFDEF LIBXL }
  VType := VarType(aValue) and VarTypeMask;
  case VType of
  varEmpty:
    Exit;
  varInteger:
    WorkSheet.WriteNum(FO_row + CurrentRow, FO_Column + aCol, aMsg);
  varDate:
    WorkSheet.WriteNum(FO_row + CurrentRow, FO_Column + aCol, aMsg);
  varDouble:
    WorkSheet.WriteNum(FO_row + CurrentRow, FO_Column + aCol, aMsg);
  varCurrency:
    WorkSheet.WriteNum(FO_row + CurrentRow, FO_Column + aCol, aMsg);
  varString:
    WorkSheet.WriteStr(FO_row + CurrentRow, FO_Column + aCol, pChar(string(aMsg)));
  end;
{$ENDIF LIBXL }
end;

procedure TbjXLSTable.Prior;
begin
  if CurrentRow = 1 then
  begin
    BOF := True;
//    if IsEmpty then
//      EOF := True;
  end;
  if CurrentRow > 1 then
  begin
    CurrentRow := CurrentRow - 1;
    EOF := False;
  end;
end;

procedure TbjXLSTable.Next;
begin
{
  if FMaxRow <> -1 then
  if CurrentRow = FMaxRow then
  begin
//    Bof := True;
    Eof := True;
    Exit;
  end;
}
//  if BOF then
//    BOF := False;
  CurrentRow := CurrentRow + 1;
  if IsEmpty then
  begin
    CurrentRow := CurrentRow - 1;
    EOF := True;
  end
  else
  begin
    BOF := False;
  end;
end;

procedure TbjXLSTable.Insert;
begin
  if LastRow = -1 then
  Last;
  CurrentRow := LastRow + 1;
end;

procedure TbjXLSTable.Delete;
begin
//  if LastRow > 1then
//      LastRow := LastRow - 1;
  if not IsEmpty then
    LastRow := - 1
  else
  begin
    EOF := True;
    Exit;
  end;
{$IFDEF SM }
  WorkSheet.Rows.DeleteRows(FO_row + CurrentRow, FO_row + CurrentRow);
{$ENDIF SM }
end;

procedure TbjXLSTable.ClearRow;
begin
{$IFDEF SM }
    WorkSheet.Rows.ClearRows(FO_row + CurrentRow, FO_row + CurrentRow);
{$ENDIF SM }
end;
procedure TbjXLSTable.First;
begin
  CurrentRow := 1;
  BOF := False;
  EOF := False;
  if IsEmpty then
  begin
    BOF := True;
    EOF := True;
  end;
end;

procedure TbjXLSTable.Last;
begin
  EOF := False;
  BOF := False;
  while not EOF do
    Next;
  LastRow := CurrentRow;
  if IsEmpty then
  begin
    BOF := True;
    EOF := True;
  end;
end;

function TbjXLSTable.GetFieldCol(const aName: string): integer;
var
  idx: integer;
  l_str: string;
begin
  Result := -1;
  l_str := LowerCase(aName);
  idx := 0;
  if FieldList.Find(l_str, idx) then
  begin
    Result := ColumnList[idx];
  end;
end;

function TbjXLSTable.FindField(const aName: string): pChar;
begin
  Result := nil;
  if GetFieldCol(aName) <> -1 then
    Result := pChar(aName);
end;

procedure TbjXLSTable.SetFields(const aList: TStrings; const ToWrite: boolean);
var
  ctr, j: integer;
begin
  if not Assigned(aList) then
    Exit;
  FieldList.Clear;
  setLength(ColumnList, aList.Count);
  for ctr := 0 to aList.Count-1 do
  begin
    FieldList.Add(LowerCase(aList.Strings[ctr]));
    if ToWrite then
{$IFDEF SM }
      WorkSheet.Cells[FO_Row, FO_Column + ctr].Value := aList.Strings[ctr];
{$ENDIF SM }
//      WorkSheet.Cells[FO_Row, FO_Column + ctr].Value := Decode(aList.Strings[ctr]);
  end;
  FieldList.Sorted := True;
  setLength(ColumnList, FieldList.Count);
  for ctr := 0 to aList.Count + 29 -1 do
  begin
    if Length(WorkSheet.Cells[FO_Row, FO_Column+ctr].ValueAsString) = 0 then
      Break;
    for j := 0 to FieldList.Count-1 do
    if LowerCase(WorkSheet.Cells[FO_Row, FO_Column+ctr].ValueAsString) =
      LowerCase(FieldList.Strings[j]) then
    begin
        ColumnList[j] := ctr;
        break;
    end;
  end;
  CurrentRow := 1;
  CurrentColumn := 0;
end;

procedure TbjXLSTable.ParseXml(const aNode: IbjXml; const FldLst: TStringList);
var
  aliasNode: IbjXml;
begin
  FldLst.Clear;
  aliasNode := aNode.SearchForTag(nil, 'Alias');
  while Assigned(aliasNode) do
  begin
    FldLst.Add(aliasNode.GetContent);
    aliasNode := aNode.SearchForTag(aliasNode, 'Alias');
  end;
end;

Function TbjXLSTable.GetFields(const aList: TStrings): TStrings;
var
  ctr, j: integer;
begin
  FieldList.Clear;
{$IFDEF SM }
  for ctr := 0 to aList.Count + 29 -1 do
  begin
    if Length(WorkSheet.Cells[FO_Row, FO_Column+ctr].ValueAsString) = 0 then
      Break;
    if Pos('Dr_', WorkSheet.Cells[FO_Row, FO_Column+ctr].ValueAsString) > 0 then
    begin
      FieldList.Add(WorkSheet.Cells[FO_Row, FO_Column+ctr].ValueAsString);
      Continue;
    end;
    if Pos('Cr_', WorkSheet.Cells[FO_Row, FO_Column+ctr].ValueAsString) > 0 then
    begin
      FieldList.Add(WorkSheet.Cells[FO_Row, FO_Column+ctr].ValueAsString);
      Continue;
    end;
    for j := 0 to aList.Count-1 do
    begin
      if LowerCase(WorkSheet.Cells[FO_Row, FO_Column+ctr].ValueAsString) =
        LowerCase(aList.Strings[j]) then
      begin
        FieldList.Add(LowerCase(aList.Strings[j]));
        break;
      end;
    end;
  end;
  FieldList.Sorted := True;
  setLength(ColumnList, FieldList.Count);
  for ctr := 0 to aList.Count + 29 -1 do
  begin
    if Length(WorkSheet.Cells[FO_Row, FO_Column+ctr].ValueAsString) = 0 then
      Break;
    for j := 0 to FieldList.Count-1 do
    if LowerCase(WorkSheet.Cells[FO_Row, FO_Column+ctr].ValueAsString) =
      LowerCase(FieldList.Strings[j]) then
    begin
        ColumnList[j] := ctr;
        break;
    end;
  end;
{$ENDIF SM }
{$IFDEF LIBXL }
  for ctr := 0 to aList.Count + 29 -1 do
  begin
    if Length(WorkSheet.ReadStr(FO_Row, FO_Column+ctr)) = 0 then
      Break;
    if Pos('Dr_', WorkSheet.ReadStr(FO_Row, FO_Column+ctr)) > 0 then
    begin
      FieldList.Add(WorkSheet.ReadStr(FO_Row, FO_Column+ctr));
      Continue;
    end;
    if Pos('Cr_', WorkSheet.ReadStr(FO_Row, FO_Column+ctr)) > 0 then
    begin
      FieldList.Add(WorkSheet.ReadStr(FO_Row, FO_Column+ctr));
      Continue;
    end;
    for j := 0 to aList.Count-1 do
    begin
      if LowerCase(WorkSheet.ReadStr(FO_Row, FO_Column+ctr)) =
        LowerCase(aList.Strings[j]) then
      begin
        FieldList.Add(LowerCase(aList.Strings[j]));
        break;
      end;
    end;
  end;
  FieldList.Sorted := True;
  setLength(ColumnList, FieldList.Count);
  for ctr := 0 to aList.Count + 29 -1 do
  begin
    if Length(WorkSheet.ReadStr(FO_Row, FO_Column+ctr)) = 0 then
      Break;
    for j := 0 to FieldList.Count-1 do
    if LowerCase(WorkSheet.ReadStr(FO_Row, FO_Column+ctr)) =
      LowerCase(FieldList.Strings[j]) then
    begin
        ColumnList[j] := ctr;
        break;
    end;
  end;
{$ENDIF LIBXL }
  Result := FieldList;
end;

function TbjXLSTable.IsEmptyField(const aField: string): boolean;
var
  v_vt: variant;
  VType  : Integer;
begin
  Result := False;
  v_vt := GetFieldVal(aField);
  VType := VarType(V_vt) and VarTypeMask;
  case VType of
  varEmpty:
    Result := True;
  varString:
    if Length(Trim(V_vt)) = 0 then
      Result := True;
  end;
end;


function TbjXLSTable.IsEmpty: boolean;
var
  ctr: integer;
begin
  Result := True;
  for ctr := 0 to FieldList.Count-1 do
  begin
    if not IsEmptyField(FieldList[ctr]) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;


end.

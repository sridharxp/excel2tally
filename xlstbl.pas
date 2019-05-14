unit xlstbl;

interface
uses
  SysUtils, Classes,
  Windows,
  XLSFile,
  XLSWorkbook,
  bjXml3_1,
  Variants,
  Dialogs;

type
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
    XL: TXLSFile;
    Workbook: TWorkbook;
    WorkSheet: TSheet;
    CurrentColumn: integer;
    CurrentRow: integer;
    FieldList: TStringList;
    ColumnList: array of integer;
    procedure SetXLSFile(const aName: string);
    procedure SetSheet(const aSheet: string);
    procedure SetOrigin(const aRow, aColumn: integer);
    function GetFieldVal(const aField: string): variant;
//    function GetFieldStr(const aField: string): string;
    function GetFieldFloat(const aField: string): double;
    function GetFieldString(const aField: string): string;
    function GetFieldSDate(const aField: string): string;
//    procedure SetFieldType(const aField: string; const aType: integer);
    function GetFieldObj(const aField: string): TColumn;
    function GetCellObj(const arow: integer; const aField: string): TCell;
    procedure SetFieldVal(const aField: string; const aValue: variant);
    function FindField(const aName: string): pChar;
//    function GetFieldCol(const aName: string): integer;
    procedure SetFields(const aList: TStrings; const ToWrite: boolean);
    function GetFields(const aList: TStrings): Tstrings;
    procedure ParseXml(const aNode: IbjXml; const FldLst: TStringList);
    function IsEmptyField(const aField: string): boolean;
    procedure Insert;
    procedure Delete;
    procedure Clear;
    procedure Next;
    procedure Prior;
    procedure First;
    procedure Last;
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
  FieldList := TStringList.Create;
  LastRow := -1;
{  FMaxRow := -1; }
end;

destructor TbjXLSTable.Destroy;
begin
  FieldList.Clear;
  FieldList.Free;
  if FOwner then
    XL.Free;
  Inherited;
end;

procedure TbjXLSTable.SetXLSFile(const aName  : string);
begin
  if Assigned(XL) then
    XL.Free;
  FXLSFileName := aName;
  if not Assigned(XL) then
  begin
    XL := TXLSFile.Create;
    FOwner := True;
  end;
  if FileExists(aName) then
    XL.OpenFile(aName);
  Workbook := XL.Workbook;
  WorkSheet := Workbook.Sheets[0];
  IDate:= Workbook.FormatStrings.AddFormat('dd/mm/yyyy');
end;

procedure TbjXLSTable.SetSheet(const aSheet: string);
begin
{$IFDEF SM }
  if not Assigned(Workbook) then
    Exit;
  if FSheetName = aSheet then
    Exit;
  WorkSheet := Workbook.SheetByName(aSheet);
  if not Assigned(WorkSheet) then
  begin
    Workbook.Sheets.Add(aSheet);
    WorkSheet := Workbook.SheetByName(aSheet);
  end;
{$ENDIF SM}
end;

procedure TbjXLSTable.SetOrigin(const aRow, aColumn: integer);
begin
  FO_Row := aRow;
  FO_Column :=aColumn;
end;

function TbjXLSTable.GetFieldVal(const aField: string): variant;
begin
  if FindField(AField) = nil then
  begin
    raise Exception.Create(aField + ' Column not defined');
    Exit;
  end;
{$IFDEF SM }
  Result := WorkSheet.Cells[FO_row + CurrentRow, FO_Column + GetFieldCol(aField)].Value;
//  Result := Encode(WorkSheet.Cells[FO_row + CurrentRow, FO_Column + GetFieldCol(aField)].Value);
{$ENDIF SM}
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
begin
  v_vt := GetFieldVal(aField);
  VType := VarType(V_vt) and VarTypeMask;
  // Set a string to match the type
  case VType of
  varEmpty:
    Exit;
  varDate:
   Result := FormatDateTime('yyyymmdd', V_vt);
  varString:
    begin
     Result := V_vt;
     if (Result[4] in ['0'..'9']) and (Result[4] in ['0'..'9']) then
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
//  ctr: integer;
  iValue: double;
  iCode: Integer;
begin
  v_vt := GetFieldVal(aField);
  VType := VarType(v_vt) and VarTypeMask;
  // Set a string to match the type
  case VType of
  varEmpty:
    begin
    Result := 0;
    Exit;
    end;
  varInteger:
    Result := V_vt;
//  varDate:
//   Result := FormatDateTime('yyyymmdd', V_vt.AsDateTime);
  varDouble:
    Result := V_vt;
  varCurrency:
    Result := V_vt;
  varString:
  begin
    str := V_vt;
    Val(Str, iValue, iCode);
    if iCode = 0 then
      Result := iValue
    else
      Result := 0;
  end;
  else
    Result := 0;
  end;
end;

function TbjXLSTable.GetFieldString(const aField: string): string;
begin
{$IFDEF SM }
  if FindField(AField) = nil then
  begin
    raise Exception.Create(aField + ' Column not defined');
    Exit;
  end;
  Result := WorkSheet.Cells[FO_Row + CurrentRow,
    FO_Column + GetFieldCol(aField)].ValueAsString;
{$ENDIF SM}
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

function TbjXLSTable.GetFieldObj(const aField: string): TColumn;
var
  ctr: integer;
begin
  ctr := GetFieldCol(aField);
  Result := WorkSheet.Columns[FO_Column + ctr];
end;

function TbjXLSTable.GetCellObj(const arow: integer; const aField: string): TCell;
var
  ctr: integer;
begin
  ctr := GetFieldCol(aField);
  Result := WorkSheet.Cells[FO_Row + aRow, FO_Column + ctr];
end;

procedure TbjXLSTable.SetFieldVal(const aField: string; const aValue: variant);
begin
  if FindField(AField) = nil then
  begin
    raise Exception.Create(aField + ' Column not defined');
    Exit;
  end;
  WorkSheet.Cells[FO_Row + CurrentRow, FO_Column + GetFieldCol(aField)].Value := aValue;
//  WorkSheet.Cells[FO_Row + CurrentRow, FO_Column + GetFieldCol(aField)].Value := Decode(aValue);
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
  WorkSheet.Rows.DeleteRows(FO_row + CurrentRow, FO_row + CurrentRow);
end;

procedure TbjXLSTable.Clear;
begin
    WorkSheet.Rows.ClearRows(FO_row + CurrentRow, FO_row + CurrentRow);
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
  ctr: integer;
begin
  if not Assigned(aList) then
    Exit;
  FieldList.Clear;
  setLength(ColumnList, aList.Count);
  for ctr := 0 to aList.Count-1 do
  begin
    FieldList.Add(LowerCase(aList.Strings[ctr]));
    if ToWrite then
      WorkSheet.Cells[FO_Row, FO_Column + ctr].Value := aList.Strings[ctr];
//      WorkSheet.Cells[FO_Row, FO_Column + ctr].Value := Decode(aList.Strings[ctr]);
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
FldLst.Sorted := True;
end;

Function TbjXLSTable.GetFields(const aList: TStrings): TStrings;
var
  ctr, j: integer;
begin
  FieldList.Clear;
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

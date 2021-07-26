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
unit Guess;

interface

uses
  SysUtils, Classes,
  XLSFile,
  XLSWorkbook,
  xlstbl3,
  bjxml3_1,
  PClientFns,
  MstListImp,
  XmlStr_GST_uf,
  VchLib,
  Dialogs;

const
  CrAmtCol = 'Deposits';
  DrAmtCol = 'Withdrawals';
  UIDName = 'ID';
  DescCol = 'Desc';
  DefMatchCol = 'Ledger';
  DefMatchLen = 5;

type
  Tfnupdate = procedure(const msg: string);

type
  TbjGuess = class
  private
    { Private declarations }
    FHost: string;
    FFirm: string;
    FChkLen: integer;
    FIsOverWriteOn: Boolean;
    FIsWrdSearchOn: Boolean;
    FMatchCol: string;
  protected
    { Public declarations }
    StartTime, EndTime, Elapsed: double;
    Hrs, Mins, Secs, Msecs: word;
    SkipCtr: Integer;
    DescStr: string;
  MatchStr: string;
    HasDecColumn: Boolean;
    IBank: IbjXml;
    bankdb: TbjXLSTable;
    PList: TStringList;
    NPList: TStringList;
    procedure SetHost(const aHost: string);
    procedure SetFirm(const aFirm: string);
    procedure SetChkLen(const aNo: Integer);
    procedure CheckMatchCol(const aCol: string);
//    procedure SkipRows;
    procedure OpenFile(const aFile: string);
    function match(const aName: string; aLen: integer): string;
    function WriteMatch(const aName: string): String;
    procedure processDesc;
    procedure WriteDescStr(const aName: string);
  public
    { Public declarations }
    MatchLen: Integer;
    Matches: Integer;
    XmlStr: string;
    dbName: string;
    TableName: string;
    FUpdate: TfnUpdate;
    Flds: TStringList;
    procedure Execute;
    constructor Create;
    destructor Destroy; override;
    property Host: String read FHost write SetHost;
    property Firm: string read FFirm write setFirm;
    property ChlLen: Integer read FChkLen write SetChkLen;
    property IsOverWriteOn: Boolean read FIsOverWriteOn write FIsOverWriteOn;
    property IsWrdSearchOn: Boolean read FIsWrdSearchOn write FIsWrdSearchOn;
    property MatchCol: string read FMatchCol write FMatchCol;
  end;

implementation


Constructor TbjGuess.Create;
begin
  Inherited;
  IBank := CreatebjXmlDocument;
  FHost := 'http://127.0.0.1:9000';
  Flds := TStringList.Create;
  bankdb := TbjXLSTable.Create;
  bankdb.ToSaveFile := True;
  FChkLen := DefMatchLen;
  FIsOverWriteOn := True;
  FIsWrdSearchOn := False;
  Matches := 0;
  MatchCol := DefMatchCol;
end;

destructor TbjGuess.Destroy;
begin
  Flds.Clear;
  Flds.Free;
  bankdb.Free;
  PList.Free;
  NPList.Free;
  IBank.Clear;
  inherited;
end;

procedure TbjGuess.OpenFile(const aFile: string);
var
  Ledobj: TbjMstListImp;
begin
  FUpdate('Reading '+ TableName + ' worksheet');
  bankdb.SetXLSFile(aFile);
  bankdb.XL.Workbook.Sheets.DeleteByName('Sheet1');
  bankdb.SetSheet(TableName);

  Flds.Clear;
  IBank.LoadXML(XmlStr);
{
  bankdb.ParseXml(IBank, Flds);
  Flds.Add('TALLYID');
  Flds.Add('REMOTEID');
  Flds.Delete('ID');
  Flds.Delete('Date');
  Flds.Delete('ChequeNo');
  Flds.Delete('ChequeNo');
  Flds.Delete('BANK LEDGER');
}
  Flds.Add('LEDGER');
  Flds.Add('DEPOSITS');
  Flds.Add('WITHDRAWALS');
  Flds.Add('NARRATION');
  Flds.Add(MatchCol);
  Flds.Add(DescCol);
  Bankdb.GetFields(Flds);
//  Bankdb.SetFields(Flds, False);
  Flds.Clear;
  CheckMatchCol(FMatchCol);
  Bankdb.SkipCount := 0;

  FUpdate('Loading Party, NonParty Ledger Lists ...');
  LedObj := TbjMstListImp.Create;
  Ledobj.ToPack := False;
  LedObj.Host := Host;
  try
    Ledobj.GetPartyList(PList, NPList);
  finally
    ledobj.Free;
  end;
end;

procedure TbjGuess.SetHost(const aHost: string);
begin
  FHost := aHost;
  if not Assigned(ClientFns) then
     ClientFns := TbjGSTClientFns.Create;
  ClientFns.Host := aHost;
end;

procedure TbjGuess.SetFirm(const aFirm: string);
begin
  FFirm := aFirm;
end;

procedure TbjGuess.SetChkLen(const aNo: integer);
begin
  if aNo >= DefMatchLen-1 then
    FChkLen := aNo;
end;

procedure TbjGuess.CheckMatchCol(const aCol: string);
begin
  if (Bankdb.FindField(aCol) = nil) then
    Raise Exception.Create(aCol + ' Column not found');
end;

procedure TbjGuess.Execute;
var
  nRow: Integer;
//  MatchStr: string;
begin
  StartTime := Time;
  OpenFile(dbName);
   HasDecColumn := False;
  if Length(bankdb.FindField(DescCol)) > 0  then
    HasDecColumn := True;
  Bankdb.First;
  skipCtr := 0;
//  DescStr := Bankdb.GetFieldString('NARRATION');
  while (not bankdb.Eof)  do
  begin
    MatchStr := '';
    if (Bankdb.GetFieldCurr(CrAmtCol) <> 0) or
      (Bankdb.GetFieldCurr(DrAmtCol) <> 0) then
//    if not (Bankdb.IsEmptyField(CrAmtCol) and
//      Bankdb.IsEmptyField(DrAmtCol)) then
    BEGIN
      nRow := bankdb.CurrentRow;
      Bankdb.CurrentRow := bankdb.CurrentRow - skipctr;
      processDesc;
      bankdb.CurrentRow := nRow;
      DescStr := Bankdb.GetFieldString('NARRATION');
      SkipCtr := 1;
    end
    else
    begin
      DescStr := DescStr + Bankdb.GetFieldString('NARRATION');
      skipCtr := skipCtr + 1;
    end;
    Bankdb.Next;
//    Bankdb.CurrentRow := bankdb.CurrentRow + 1;
  end;
  bankdb.CurrentRow := bankdb.CurrentRow - skipctr + 1;
  processDesc;
{
  WriteDescStr(DescStr);
  MatchStr := Match(DescStr, FChkLen);
  if Length(MatchStr) > 0 then
  begin
    WriteMatch(MatchStr);
  end;
}
  if bankdb.ToSaveFile then
    bankdb.Save;
  EndTime := Time;
  Elapsed := EndTime - StartTime;
  DecodeTime(Elapsed, Hrs, Mins, Secs, MSecs);
  FUpdate('Successful Matches: '+ IntToStr(Matches) + '; '
  + InttoStr(Mins) + ' Minute(s), ' +InttoStr(Secs) + ' Seconds');
  MessageDlg('Successful Matches: '+ IntToStr(Matches), mtInformation, [mbOK], 0);
end;

function TbjGuess.Match(const aName: string; aLen: integer): String;
var
  i: Integer;
  LName, packName, packDisc: string;
  CurLen, bstlen, llength: Integer;
  bstFit: string;
begin
  Result := '';
  bstlen := 0;
  bstFit := '';
  MatchLen := 0;
  llength := 0;
  if FIsWrdSearchOn then
    packDisc := PackWrd(aName)
  else
    packDisc := PackStr(aName);

  for i := 0 to nPList.Count-1 do
  begin
    LName := nPList.Strings[i];
    if FIsWrdSearchOn then
      packName := Packwrd(LName)
    else
      packName := Packstr(LName);
    if Pos(packName, packDisc) > 0 then
    if Length(packName) > aLen then
    begin
      bstLen := Length(packName);
      bstFit := LName;
      llength := Length(LName);
    end
  end;

  for i := 0 to PList.Count-1 do
  begin
    LName := PList.Strings[i];
    if FIsWrdSearchOn then
      packName := Packwrd(LName)
    else
      packName := Packstr(LName);
    CurLen := PPos(packName, packDisc, aLen);
    if CurLen > 0 then
    begin
      if CurLen > bstLen then
      begin
        bstLen := CurLen;
        bstFit := LName;
        llength := Length(LName);
      end
      else
      begin
        if (CurLen = bstLen) and (Length(LName) > llength) then
        begin
          bstLen := CurLen;
          bstFit := LName;
          llength := Length(LName);
        end;
      end
    end;
  end;
  Result := bstFit;
  MatchLen := bstlen;
end;

{
procedure TbjGuess.SkipRows;
begin
//  if FIsOverWriteOn then
//    Exit;
  while not Bankdb.EOF do
  begin
    FUpdate('Checking Matched Text at line '+ IntToStr(bankdb.CurrentRow));
    if (Bankdb.GetFieldCurr(CrAmtCol) = 0) and
      (Bankdb.GetFieldCurr(DrAmtCol) = 0) then
      bankdb.CurrentRow := bankdb.CurrentRow+ 1
    else
    if not (bankdb.IsEmptyField(MatchCol) or (Bankdb.GetFieldString(MatchCol) = 'Suspense') then
    begin
    if not FIsOverWriteOn then
    begin
      bankdb.CurrentRow := bankdb.CurrentRow + 1;
      skipctr := 0;
      DescStr := '';
    end
    else
      Break;
    end
    else
      Break;
  end;
//  skipctr := 0;
//  DescStr := '';
end;
}

procedure TbjGuess.WriteDescStr(const aName: string);
begin
  if HasDecColumn then
    Bankdb.SetFieldVal(DescCol, DescStr);
end;

procedure TbjGuess.processDesc;
begin
  FUpdate('Processing Description at line ' + IntToStr(bankdb.CurrentRow));
  if (not FIsOverWriteOn) and not
         (bankdb.IsEmptyField(MatchCol) or
         (Bankdb.GetFieldString(MatchCol) = 'Suspense')) then
    Exit;
  if Length(DescStr) = 0 then
    Exit;
  WriteDescStr(DescStr);
  MatchStr := Match(DescStr, FChkLen);
  if Length(MatchStr) > 0 then
    WriteMatch(MatchStr);
  DescStr := '';
end;

function TbjGuess.WriteMatch(const aName: string): String;
begin
  if (bankdb.IsEmptyField(MatchCol)) or (Bankdb.GetFieldString(MatchCol) = 'Suspense') then
  begin
    Bankdb.SetFieldVal(MatchCol, aName);
    FUpdate(' Matched: ' + aName + ' (' + InttoStr(MatchLen) + ')');
    Matches := Matches + 1;
//    ShowMessage(aName);
    Exit;
  end;
  if FIsOverWriteOn then
  begin
    Bankdb.SetFieldVal(MatchCol, aName);
    FUpdate(' Matched: ' + aName + ' (' + InttoStr(MatchLen) + ')');
    Matches := Matches + 1;
//    ShowMessage(aName);
  end;
end;
end.

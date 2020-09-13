(*
Copyright (C) 2013, Sridharan S

This file is part of Integration Tools for Tally.

Integration Tools for Tally is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Integration Tools for Tally is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License version 3
along with Integration Tools for Tally. If not, see <http://www.gnu.org/licenses/>.
*)
unit Repet;

interface

uses
  Windows, SysUtils, Variants, Classes,
  XLSFile,
  XLSWorkbook,
  xlstbl,
  bjxml3_1,
  PClientFns,
  Dialogs;

type
  Tfnupdate = procedure(msg: string);

type
  TRpetGSTN = class
  private
    { Private declarations }
    FHost: string;
  protected
    GSTNList: TList;
    rpetdb: TbjXLSTable;
    procedure SetHost(const aHost: string);
  public
    { Public declarations }
    flds: TStringList;
    procedure OpenFile(const aFile: string);
    procedure GetList(aList: TList);
    procedure WriteXls;
    function GetGSTNParty(const aGSTN: string): string;
    procedure Execute;
    constructor Create;
    destructor Destroy; override;
    property Host: String read FHost write SetHost;
  end;

  GSTNRec = Record
    Name: string;
    GSTN: string;
  end;
  pGSTNRec = ^GSTNRec;

implementation

Constructor TRpetGSTN.Create;
begin
  Inherited;
  FHost := 'http://127.0.0.1:9000';
  flds := TStringList.Create;
  GSTNList := TList.Create;
  if not Assigned(ClientFns) then
   ClientFns := TbjGSTClientFns.Create;

  rpetdb := TbjXLSTable.Create;
  rpetdb.ToSaveFile := True;
(*
  rpetdb.SetXLSFile('.\Data\RpetGSTN.xls');
  rpetdb.XL.Workbook.Sheets.DeleteByName('Sheet1');
  rpetdb.SetSheet('REPEET');
  flds.Clear;
  flds.Add('GSTN');
  flds.Add('Ledger_1');
  flds.Add('Ledger_2');
  flds.Add('Ledger_3');
  rpetdb.SetFields(flds, True);
*)
end;

destructor TRpetGSTN.Destroy;
var
  i: integer;
  item: pGSTNRec;
begin
  for i := 0 to GSTNList.Count-1 do
  begin
    item := GSTNList.Items[i];
    item.Name := '';
    item.GSTN := '';
    Dispose(item);
  end;
  GSTNList.Clear;
  GSTNList.Free;
  flds.Clear;
  flds.Free;
  rpetdb.Free;
  inherited;
end;
procedure TRpetGSTN.OpenFile(const aFile: string);
begin
  rpetdb.SetXLSFile('.\Data\'+ aFile);
  rpetdb.XL.Workbook.Sheets.DeleteByName('Sheet1');
  rpetdb.SetSheet('REPEET');
  flds.Clear;
  flds.Add('GSTN');
  flds.Add('Ledger_1');
  flds.Add('Ledger_2');
  flds.Add('Ledger_3');
  rpetdb.SetFields(flds, True);
end;

procedure TRpetGSTN.SetHost(const aHost: string);
begin
  FHost := aHost;
  ClientFns.Host := aHost;
end;

procedure TRpetGSTN.GetList(aList: TList);
var
  strx: IbjXml;
  strs: string;
  lStr: string;
  OResult: IbjXml;
  //RecNode, LedNode, ParentNode, GSTNNode: IbjXml;
  LedNode, GSTNNode: IbjXml;
  CollName: string;
  LedPList: TStringList;
  item: pGSTNRec;
//  grp: string;
begin
  LedPList := TStringList.Create;
  strx := CreatebjXmlDocument;
  OResult := CreatebjXmlDocument;
  try
  CollName := 'Ledger';
  LedPList.Add('PARENT');
  LedPList.Add('PARTYGSTIN');

  strs := '<CHILDOF>' + TextToXML('Sundry Debtors') + '</CHILDOF>';
  strs := Strs + '<BELONGSTO>' + 'Yes' + '</BELONGSTO>';
  strx.LoadXml(strs);
  lStr := Col2Eval(CollName, 'Ledger', strx, LedPList);
  strs := '<CHILDOF>' + TextToXML('Sundry Creditors') + '</CHILDOF>';
  strs := Strs + '<BELONGSTO>' + 'Yes' + '</BELONGSTO>';
  strx.LoadXml(strs);
  lStr := lStr + Col2Eval(CollName, 'Ledger', strx, LedPList);
  finally
    LedPList.Free;
  end;
  OResult.LoadXml(lStr);
//  RecNode := OResult.SearchforTag(nil, 'COLLECTION');
  LedNode := OResult.SearchforTag(nil , 'LEDGER');
  while Assigned(LedNode) do
  begin
{
    ParentNode := LedNode.SearchforTag(nil, 'PARENT');
    if not Assigned(ParentNode) then
      continue;
    grp := ParentNode.GetContent;
    if (grp <> 'Sundry Debtors') and
      (grp <> 'Sundry Creditors') then
}
    if Length(LedNode.GetContent) = 0 then
    begin
      LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
      Continue;
    end;
    GSTNNode := LedNode.SearchForTag(nil, 'PARTYGSTIN');
    if Assigned(GSTNNode) then
      if Length(GSTNNode.GetContent) > 0 then
      begin
        item := new(pGSTNRec);
        item.GSTN := GSTNNode.GetContent;
        item.Name := LedNode.GetAttrValue('NAME');
        aList.Add(item);
      end;
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
end;

procedure TRpetGSTN.Execute;
begin
  OpenFile('RpetGSTN.xls');
  GetList(GSTNList);
  WriteXls;
  if rpetdb.ToSaveFile then
    rpetdb.Save;
end;

procedure TRpetGSTN.WriteXls;
var
  i, j: integer;
  item_i, item_j: pGSTNRec;
begin
  rpetdb.First;
  for i := 0 to GSTNList.Count-1 do
  begin
    item_i := GSTNList.Items[i];
    if Length(item_i.GSTN) = 0 then
      Continue;
    if Length(item_i.Name) = 0 then
      Continue;
    rpetdb.SetFieldVal('LEDGER_1', item_i.Name);
    rpetdb.SetFieldVal('GSTN', item_i.GSTN);
    for j := 0 to GSTNList.Count-1 do
    begin
      item_j := GSTNList.Items[j];
      if Length(item_j.GSTN) = 0 then
        Continue;
      if Length(item_j.Name) = 0 then
        Continue;
      if (item_i.Name = item_j.Name) and (item_i.GSTN = item_j.GSTN) then
        Continue;
      if (item_i.Name <> item_j.Name) and (item_i.GSTN = item_j.GSTN) then
      begin
        if rpetdb.IsEmptyField('LEDGER_2') then
          rpetdb.SetFieldVal('LEDGER_2', item_j.Name)
        else
          rpetdb.SetFieldVal('LEDGER_3', item_j.Name);
        item_j.Name := '';
      end;
    end;
    rpetdb.CurrentRow := rpetdb.CurrentRow + 1;
    rpetdb.SetFieldVal('GSTN', '');
    rpetdb.SetFieldVal('LEDGER_1', '');
    rpetdb.SetFieldVal('LEDGER_2', '');
    rpetdb.SetFieldVal('LEDGER_3', '');
  end;
end;

function TRpetGSTN.GetGSTNParty(const aGSTN: string): string;
var
  i: integer;
  item: pGSTNRec;
begin
  if GSTNList.Count = 0 then
    GETList(GSTNList);
  Result := '';
  for i := 0 to GSTNList.Count-1 do
  begin
    item := GSTNList.Items[i];
    if item.GSTN = aGSTN then
    begin
      Result := item.Name;
      break;
    end;
  end;
end;

end.


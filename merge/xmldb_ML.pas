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
unit xmldb_ML;

interface

uses
  Classes, SysUtils,
  DateUtils,
  DateFns,
  StrUtils,
  Client,
  bjxml3_1,
  PClientFns,
  Dialogs;

type
  Tfnupdate = procedure(const aMsg: string);

type
  TbjxMerge = class
  private
    { Private declarations }
    FXReq: wideString;
    FHost: string;
    FFirm: String;
    FFrmDt: string;
    FToDT: string;
    FParty: string;
    FDupLed: string;
  protected
    rDB: string;
    xDB: string;
    yDB: string;
    Client: TbjClient;
    aID: Ibjxml;
    vID: Ibjxml;
    LID: Ibjxml;
    PLID: Ibjxml;
    StartTime, EndTime, Elapsed: double;
    Hrs, Mins, Secs, Msecs: word;
    sDups: Integer;
  public
    { Public declarations }
    ndups: Integer;
    IsSaveXMLFileOn: boolean;
    TallyVersion: string;
{    ImportNoDups: Boolean; }
    CurDt: string;
    FUpdate: TfnUpdate;
    Alterid: string;
    FinishedDts: TStringList;
    AlterIDStr: string;
    constructor Create;
    destructor Destroy; override;
    procedure GetLedVchRgtr; virtual;
    procedure GetVouXML; virtual;
    procedure PostVouXML; virtual;
    procedure Process; virtual;
    procedure ReplDupLed; virtual;
    procedure ErrorCheck; virtual;
    procedure SetHost(const aHost: string);
  published
    property Firm: String read FFirm write FFirm;
    property Host: String read FHost write SetHost;
    property FrmDt: string Read FFrmDt write FFrmDt;
    property ToDt: string Read FToDt write FToDt;
    property Party: string Read FParty write FParty;
    property DupLed: string Read FDupLed write FDupLed;
  end;

  TbjFillBillRef = class(TbjxMerge)
  public
    procedure Process; override;
    procedure ReplDupLed; override;
    constructor Create;
    destructor Destroy; override;
  end;
implementation

Constructor TbjxMerge.Create;
begin
  inherited;
  FHost := 'http://127.0.0.1:9000';
  Client := TbjClient.Create;
  FinishedDts :=TStringList.Create;
{  SaveXMLFile := True; }
  AlteriDStr := 'ALTERID';
end;


destructor TbjxMerge.Destroy;
begin
  Client.Free;
  FinishedDts.Free;
  inherited;
end;


Procedure TbjxMerge.ErrorCheck;
begin
  if Client.Response.Size = 0 then
//    ShowMessage(Response.bodyStr)
//  else
    raise exception.Create('Error Getting Data from Tally');
end;
procedure TbjXMerge.SetHost(const aHost: string);
begin
  FHost := aHost;
end;

procedure TbjxMerge.Process;
var
  rDoc: Ibjxml;
  rID: Ibjxml;
  idx: Integer;
begin
  GetLedVchRgtr;
  rDoc := CreatebjXmlDocument;
  rDoc.LoadXML(rDB);
{  ShowMessage(rDoc.GetXML); }
  rID := rDoc.SearchForTag(nil, 'DSPVCHDATE');
  while Assigned(rID) do
  begin
    if CurDt = rID.GetContent then
    begin
      rID := rDoc.SearchForTag(rID, 'DSPVCHDATE');
      Continue;
    end;
    CurDt := rID.GetContent;
    if not FinishedDts.Find(CurDt, idx) then
    begin
      FinishedDts.Add(CurDt);
      GetVouXML;
      ReplDupLed;
    end;
    rID := rDoc.SearchForTag(rID, 'DSPVCHDATE');
  end;
end;

procedure TbjxMerge.GetLedVchRgtr;
begin
  rdb := '';
  FxReq := '<ENVELOPE><HEADER><VERSION>1</VERSION>'+
  '<TALLYREQUEST>Export</TALLYREQUEST>' +
  '<TYPE>DATA</TYPE>'+
  '<ID>Ledger Vouchers</ID>'+
  '</HEADER><BODY><DESC>'+
  '<STATICVARIABLES>';
{
  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';
}
  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';
  if (Length(FFrmDt) <> 0 ) then
  begin
    FxReq := FXReq + '<SVFROMDATE>' + FFrmDt + '</SVFROMDATE>';
  end;
  if ( Length(FToDt) <> 0) then
  begin
    FxReq := FXReq + '<SVTODATE>' + FToDt + '</SVTODATE>';
  end;
  FxReq := FXReq + '<LEDGERNAME>' +  DupLed + '</LEDGERNAME>';
  FxReq := FXReq + '</STATICVARIABLES>'+
  '</DESC></BODY></ENVELOPE>';

  if IsSaveXMLFileOn then
      Client.xmlResponsefile := 'LedVchRgr.xml';
  Client.Host := FHost;
  Client.xmlRequestString := Fxreq;
  Client.post;
  Errorcheck;
  rdb := Client.xmlResponseString;
end;

procedure TbjxMerge.GetVouXML;
var
  xSVar, xStr, xFormula: IbjXml;
  CollName: string;
  OResult: IbjXml;
begin
  xSVar := CreatebjXmlDocument;
  xStr := CreatebjXmlDocument;
  xFormula := CreatebjXmlDocument;

  CollName := 'Ledger Vouchers Coll';
  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  xStr.LoadXML('<FILTER>VDate</FILTER>'
  +'<NATIVEMETHOD>LEDGERNAME</NATIVEMETHOD>'
  +'<NATIVEMETHOD>PARTYLEDGERNAME</NATIVEMETHOD>'
  );
  xFormula.LoadXML(
  '<SYSTEM TYPE="FORMULAE" NAME="VDate">'+
  '$DATE=$$DATE:"' + CurDt + '"</SYSTEM>');
  xdb := ColExEval(CollName, 'Voucher', xSVar, xStr, xFormula);
{

}
end;

procedure TbjxMerge.PostVouXML;
var
  VDoc: Ibjxml;
begin
  FxReq := '<ENVELOPE><HEADER><VERSION>1</VERSION>';
  FxReq := FxReq + '<TALLYREQUEST>IMPORT</TALLYREQUEST>';
  FxReq := FxReq + '<TYPE>DATA</TYPE>';
  FxReq := FxReq + '<ID>Vouchers</ID>';
  FxReq := FxReq + '</HEADER><BODY><DESC>';
  FxReq := FxReq + '<STATICVARIABLES>';

//  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';
{ Not needed }

  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';

  FxReq := FXReq + '<SVOverwriteImpVch>' + 'Yes' + '</SVOverwriteImpVch>';
  FxReq := FxReq + '</STATICVARIABLES>';
  FxReq := FxReq + '</DESC><DATA><TALLYMESSAGE>';

  yDB := FXReq + yDB + '</TALLYMESSAGE></DATA></BODY></ENVELOPE>';
{
  VDoc.SaveXmlFile('Voucher.xml');
}
  Client.Host := FHost;
  Client.xmlRequestString := yDB;
  Client.post;
  Errorcheck;
  ndups := ndups + 1;
    if Assigned(FUpdate) then
      FUpdate(DupLed + ' ' + CurDt +' ' + Alterid);
end;

{ rfReplaceAll rfIgnoreCase }
procedure TbjxMerge.ReplDupLed;
var
  VDoc: Ibjxml;
begin
  VDoc := CreatebjXmlDocument;
  VDoc.LoadXML(xDB);
{
  VDoc.SaveXmlFile('Daybook.xml');
}
  vid := vDoc.SearchForTag(nil, 'VOUCHER');
  if not Assigned(vID) then
    Exit;
  LID := vID.SearchForTag(nil, 'LEDGERNAME');
  PLID := vID.SearchForTag(nil, 'PARTYLEDGERNAME');
//  aID := vID.SearchForTag(nil, 'ALTERID');
  aID := vID.SearchForTag(nil, AlterIDStr);
    if not Assigned(aID) then
  if AlterIDStr = 'ALTERID' then
  begin
      AlterIDStr := 'MASTERID';
      aID := vID.SearchForTag(nil, AlterIDStr);
  end;
  while Assigned(LID) do
  begin
    if LID.GetContent = DupLed then
      Break;
    LID := vID.SearchForTag(LID, 'LEDGERNAME');
  end;
  while Assigned(PLID) do
  begin
    if PLID.GetContent = DupLed then
      Break;
    PLID := vID.SearchForTag(PLID, 'PARTYLEDGERNAME');
  end;
  while Assigned(vID) do
  begin
    if Assigned(LID) then
    if LID.GetContent = DupLed then
    begin
      alterid := aID.GetContent;
      vID.RemoveAttr('ACTION');
      vID.AddAttribute('TAGNAME', AlterIDStr);
      vID.AddAttribute('TAGVALUE', alterid);
      vID.AddAttribute('ACTION', 'Alter');
      while Assigned(lID) do
      begin
        if LID.GetContent = DupLed then
          LID.setContent(Party);
        LID := vID.SearchForTag(LID, 'LEDGERNAME');
      end;
      while Assigned(PLID) do
      begin
        if Assigned(PLID) and (PLID.GetContent = DupLed) then
          PLID.SetContent(Party);
        PLID := vID.SearchForTag(PLID, 'PARTYLEDGERNAME');
      end;
      yDB := vID.GetXML;
      PostVouXML;
    end;
    vID := vDoc.SearchForTag(vID, 'VOUCHER');
    if not Assigned(vID) then
      Exit;
    lID := vID.SearchForTag(nil, 'LEDGERNAME');
    PLID := vID.SearchForTag(nil, 'PARTYLEDGERNAME');
    aID := vID.SearchForTag(nil, AlterIDStr);
    while Assigned(LID) do
    begin
      if LID.GetContent = DupLed then
        Break;
      LID := vID.SearchForTag(LID, 'LEDGERNAME');
    end;
  while Assigned(PLID) do
  begin
    if PLID.GetContent = DupLed then
      Break;
    PLID := vID.SearchForTag(PLID, 'PARTYLEDGERNAME');
  end;
  end;
end;

Constructor TbjFillBillRef.Create;
begin
  inherited;
end;
destructor TbjFillBillRef.Destroy;
begin
  inherited;
end;
procedure TbjFillBillRef.Process;
var
  rDoc: Ibjxml;
  rID: Ibjxml;
  idx: Integer;
  rVTNode: Ibjxml;
begin
  StartTime := Time;
  GetLedVchRgtr;
  rDoc := CreatebjXmlDocument;
  rDoc.LoadXML(rDB);
  rID := rDoc.SearchForTag(nil, 'DSPVCHDATE');
  while Assigned(rID) do
  begin
    if CurDt = rID.GetContent then
    begin
      rID := rDoc.SearchForTag(rID, 'DSPVCHDATE');
      Continue;
    end;                                                               
    rVTNode := rDoc.SearchForTag(rID, 'DSPVCHTYPE');
    CurDt := rID.GetContent;
    if not FinishedDts.Find(CurDt, idx) then
    begin
      FinishedDts.Add(CurDt);
    GetVouXML;
    ReplDupLed;
    end;
    rID := rDoc.SearchForTag(rID, 'DSPVCHDATE');
  end;
  EndTime := Time;
  Elapsed := EndTime - StartTime;
  DecodeTime(Elapsed, Hrs, Mins, Secs, MSecs);
  FUpdate(IntToStr(SDups)+ ' Transformed; ' +IntToStr(Secs) + ' seconds');
end;
procedure TbjFillBillRef.ReplDupLed;
var
  VDoc: Ibjxml;
  rBDoc: Ibjxml;
  rBType: Ibjxml;
  rRefNode: Ibjxml;
  rRef: string;
  rVNoNode: Ibjxml;
  rBNode: Ibjxml;
  rAmtNode: Ibjxml;
  rAmt: string;
  rVno: string;
  rSomeRef: string;
  rIsModified: Boolean;
begin
  VDoc := CreatebjXmlDocument;
  VDoc.LoadXML(xDB);
  vid := vDoc.SearchForTag(nil, 'COLLECTION');
  vid := vDoc.SearchForTag(VID, 'VOUCHER');
  if not Assigned(vID) then
    Exit;
  LID := vID.SearchForTag(nil, 'LEDGERNAME');
  while Assigned(LID) do
  begin
    if LID.GetContent = DupLed then
      Break;
    LID := vID.SearchForTag(LID, 'LEDGERNAME');
  end;
  aID := vID.SearchForTag(nil, AlterIDStr);
  if not Assigned(aID) then
  if AlterIDStr = 'ALTERID' then
  begin
      AlterIDStr := 'MASTERID';
      aID := vID.SearchForTag(nil, AlterIDStr);
  end;
  while Assigned(vID) do
  begin
    rIsModified := False;
    aID := vID.SearchForTag(nil, AlterIDStr);
    rRefNode := vID.SearchForTag(nil, 'REFERENCE');
    if rRefNode <> nil then
      rRef := rRefNode.GetContent;
    rSomeRef := rRef;
    rVNoNode := vID.SearchForTag(nil, 'VOUCHERNUMBER');
    if rVNoNode <> nil then
      rVno := rVNoNode.GetContent;
    if Length(rSomeRef) = 0 then
      rSomeRef := rVno;
    rAmtNode := VID.SearchForTag(LID, 'AMOUNT');
    if rAmtNode <> nil then
      rAmt := rAmtNode.GetContent;
    if Length(rSomeRef) = 0 then
    begin
      vID := vDoc.SearchForTag(vID, 'VOUCHER');
      if not Assigned(vID) then
        Exit;
      lID := vID.SearchForTag(nil, 'LEDGERNAME');
      while Assigned(LID) do
      begin
        if LID.GetContent = DupLed then
          Break;
        LID := vID.SearchForTag(LID, 'LEDGERNAME');
      end;
      Continue;
    end;
    if Assigned(LID) then
    if LID.GetContent = DupLed then
    begin
      Alterid := aID.GetContent;
      vID.RemoveAttr('ACTION');
      vID.RemoveAttr('ACTION');
      vID.AddAttribute('TAGNAME', AlterIDStr);
      vID.AddAttribute('TAGVALUE', Alterid);
      vID.AddAttribute('ACTION', 'Alter');
      rBNode := LID.SearchForTag(nil, 'BILLALLOCATIONS.LIST');
      if Assigned(rBNode) then
      begin
        if Length(rBNode.GetChildContent('NAME')) = 0 then
        begin
          rBNode.NewChild2('NAME', rSomeRef);
          rBNode.NewChild2('BILLTYPE', 'NewRef');
          rBNode.NewChild2('AMOUNT', rAmt);
          rIsModified := True;
        end;
      end;
      yDB := vID.GetXML;
      if rIsModified then
        PostVouXML;
      sDups := sDups + 1;
    end;
    vID := vDoc.SearchForTag(vID, 'VOUCHER');
    if not Assigned(vID) then
    Exit;
    lID := vID.SearchForTag(nil, 'LEDGERNAME');
    while Assigned(LID) do
    begin
      if LID.GetContent = DupLed then
        Break;
      LID := vID.SearchForTag(LID, 'LEDGERNAME');
    end;
  end;
end;
end.

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
  Classes, SysUtils, DateUtils,
  Dialogs,
  DateFns,
  StrUtils,
  Client,
  bjxml3_1,
  PClientFns;

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
  public
    { Public declarations }
    ndups: Integer;
    IsSaveXMLFileOn: boolean;
    TallyVersion: string;
{    ImportNoDups: Boolean; }
    CurDt: string;
    FUpdate: TfnUpdate;
    constructor Create;
    destructor Destroy; override;
    procedure GetLedVchRgtr;
    procedure GetVouXML;
    procedure PostVouXML;
    procedure Process;
    procedure ReplDupLed;
    procedure ErrorCheck;
    procedure SetHost(const aHost: string);
  published
    property Firm: String read FFirm write FFirm;
    property Host: String read FHost write SetHost;
    property FrmDt: string Read FFrmDt write FFrmDt;
    property ToDt: string Read FToDt write FToDt;
    property Party: string Read FParty write FParty;
    property DupLed: string Read FDupLed write FDupLed;
  end;

implementation

Constructor TbjxMerge.Create;
begin
  FHost := 'http://127.0.0.1:9000';
  Client := TbjClient.Create;
{  SaveXMLFile := True; }
end;


destructor TbjxMerge.Destroy;
begin
  Client.Free;
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
begin
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
    CurDt := rID.GetContent;
    if Assigned(FUpdate) then
      FUpdate(DupLed + ' ' + CurDt);
    GetVouXML;
    ReplDupLed;
    rID := rDoc.SearchForTag(rID, 'DSPVCHDATE');
  end;
end;

procedure TbjxMerge.GetLedVchRgtr;
begin
  FxReq := '<ENVELOPE><HEADER><TALLYREQUEST>Export Data</TALLYREQUEST></' +
    'HEADER>'+
  '<BODY><EXPORTDATA><REQUESTDESC>' +
  '<REPORTNAME>Ledger Vouchers</REPORTNAME>'
  +'<STATICVARIABLES>';
{
  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';
}
  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';
  if ( Length(FFrmDt) <> 0 ) and ( Length(FToDt) <> 0 ) then
  begin
    FxReq := FXReq + '<SVFROMDATE>' + FFrmDt + '</SVFROMDATE>';
    FxReq := FXReq + '<SVTODATE>' + FToDt + '</SVTODATE>';
  end;
  FxReq := FXReq + '<LEDGERNAME>' +  DupLed + '</LEDGERNAME>';
  FxReq := FXReq +
  '</STATICVARIABLES>'+
  '</REQUESTDESC>'+
  '</EXPORTDATA></BODY></ENVELOPE>';

  if IsSaveXMLFileOn then
      Client.xmlResponsefile := 'LedVchRgr.xml';
  Client.Host := FHost;
  Client.xmlRequestString := Fxreq;
  Client.post;
  Errorcheck;
  rdb := Client.xmlResponseString;
end;

procedure TbjxMerge.GetVouXML;
begin
  FxReq := '<ENVELOPE><HEADER><VERSION>1</VERSION>';
  FxReq := FxReq + '<TALLYREQUEST>EXPORT</TALLYREQUEST>';
  FxReq := FxReq + '<TYPE>DATA</TYPE>';
  FxReq := FxReq + '<ID>Daybook</ID>';
  FxReq := FxReq + '</HEADER><BODY><DESC>';

  FxReq := FxReq + '<STATICVARIABLES>';
{

}
  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';

  FxReq := FXReq + '<SVCURRENTDATE>' + CurDt + '</SVCURRENTDATE>';

  FxReq := FXReq + '</STATICVARIABLES>';

  FxReq := FXReq + '</DESC></BODY></ENVELOPE>';

  if IsSaveXMLFileon then
    Client.xmlResponsefile := 'Daybook.xml';
  Client.Host := FHost;
  Client.xmlRequestString := Fxreq;
  Client.post;
  Errorcheck;
  xdb := Client.xmlResponseString;
end;

procedure TbjxMerge.PostVouXML;
var
  VDoc: Ibjxml;
begin
    FxReq := '<ENVELOPE><HEADER><TALLYREQUEST>Import Data</TALLYREQUEST></' +
    'HEADER>'+
  '<BODY><IMPORTDATA><REQUESTDESC>' +
  '<REPORTNAME>Vouchers</REPORTNAME>'
  +'<STATICVARIABLES>';

//  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';
{ Not needed }
  FxReq := FXReq + '<SVOverwriteImpVch>' + 'Yes' + '</SVOverwriteImpVch>';

  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';

  FxReq := FXReq +
  '</STATICVARIABLES>'+
  '</REQUESTDESC><REQUESTDATA><TALLYMESSAGE>';
  yDB := FXReq + yDB +
    '</TALLYMESSAGE></REQUESTDATA></IMPORTDATA></BODY></ENVELOPE>';
  VDoc := CreatebjXmlDocument;
  VDoc.LoadXML(ydb);
{
  VDoc.SaveXmlFile('Voucher.xml');
}
  Client.Host := FHost;
  Client.xmlRequestString := yDB;
  Client.post;
  Errorcheck;
  ndups := ndups + 1;
end;

{ rfReplaceAll rfIgnoreCase }
procedure TbjxMerge.ReplDupLed;
var
  VDoc: Ibjxml;
  alterid: string;
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
  aID := vID.SearchForTag(nil, 'ALTERID');
//  aID := vID.SearchForTag(nil, 'MASTERID');
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
      vID.AddAttribute('TAGNAME', 'ALTERID');
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
    aID := vID.SearchForTag(nil, 'ALTERID');
//    aID := vID.SearchForTag(nil, 'MASTERID');
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

end.

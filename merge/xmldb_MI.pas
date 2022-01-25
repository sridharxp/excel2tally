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
unit xmldb_MI;

interface

uses
  Classes, SysUtils, DateUtils,
  Dialogs,
  DateFns,
  StrUtils,
  Client,
  bjxml3_1;


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
    FItem: string;
    FDupItem: string;
  protected
    rDB: string;
    xDB: string;
    yDB: string;
    Client: TbjClient;
    aID: Ibjxml;
    vID: Ibjxml;
    lID: Ibjxml;
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
    procedure GetItemVchRgtr;
    procedure GetVouXML;
    procedure PostVouXML;
    procedure Process;
    procedure ReplDupItem;
    procedure ErrorCheck;
    procedure SetHost(const aHost: string);
  published
    property Firm: String read FFirm write FFirm;
    property Host: String read FHost write SetHost;
    property FrmDt: string Read FFrmDt write FFrmDt;
    property ToDt: string Read FToDt write FToDt;
    property Item: string Read FItem write FItem;
    property DupItem: string Read FDupItem write FDupItem;
  end;

implementation

Constructor TbjxMerge.Create;
begin
  FHost := 'http://127.0.0.1:9000';
  Client := TbjClient.Create;
  IsSaveXMLFileOn := True;
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
procedure TbjxMerge.SetHost(const aHost: string);
begin
  FHost := aHost;
end;

procedure TbjxMerge.Process;
var
  rDoc: Ibjxml;
  rID: Ibjxml;
begin
  GetItemVchRgtr;
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
      FUpdate(DupItem + ' ' + CurDt);
    GetVouXML;
    ReplDupItem;
  rID := rDoc.SearchForTag(rID, 'DSPVCHDATE');
  end;
end;

procedure TbjxMerge.GetItemVchRgtr;
begin
  FxReq := '<ENVELOPE><HEADER><TALLYREQUEST>Export Data</TALLYREQUEST></' +
    'HEADER>'+
  '<BODY><EXPORTDATA><REQUESTDESC>' +
  '<REPORTNAME>Stock Vouchers</REPORTNAME>'
//  '<REPORTNAME>All Stock Items</REPORTNAME>'
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
  FxReq := FXReq + '<STOCKITEMNAME>' +  DupItem + '</STOCKITEMNAME>';
  FxReq := FXReq +
  '</STATICVARIABLES>'+
  '</REQUESTDESC>'+
  '</EXPORTDATA></BODY></ENVELOPE>';

  if IsSaveXMLFileOn then
      Client.xmlResponsefile := 'iTEMVouRgtr.xml';
  Client.Host := FHost;
  Client.xmlRequestString := Fxreq;
  Client.post;
  Errorcheck;
  rdb := Client.xmlResponseString;
//  ShowMessage(rdb);
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
  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';
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
//var
//  VDoc: Ibjxml;
begin
  FxReq := '<ENVELOPE><HEADER><VERSION>1</VERSION>';
  FxReq := FxReq + '<TALLYREQUEST>IMPORT</TALLYREQUEST>';
  FxReq := FxReq + '<TYPE>DATA</TYPE>';
  FxReq := FxReq + '<ID>Vouchers</ID>';
  FxReq := FxReq + '</HEADER><BODY><DESC>';

  FxReq := FxReq + '<STATICVARIABLES>';
{
  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';
}
  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';
  FxReq := FXReq + '</STATICVARIABLES></DESC><DATA><TALLYMESSAGE>';

  yDB := FXReq + yDB +
    '</TALLYMESSAGE></DATA></BODY></ENVELOPE>';
  Client.Host := FHost;
  Client.xmlRequestString := yDB;
{
  VDoc := CreatebjXmlDocument;
  vDoc.LoadXML(yDB);
  vDoc.SaveXmlFile('Voucher.xml');
}
  Client.post;
  Errorcheck;
  ndups := ndups + 1;
end;

{ rfReplaceAll rfIgnoreCase }
procedure TbjxMerge.ReplDupItem;
var
  VDoc: Ibjxml;
  alterid: string;
begin
  VDoc := CreatebjXmlDocument;
  VDoc.LoadXML(xDB);
  vid := vDoc.SearchForTag(nil, 'VOUCHER');
  if not Assigned(vID) then
    Exit;
  lID := vID.SearchForTag(nil, 'STOCKITEMNAME');
  aID := vID.SearchForTag(nil, 'ALTERID');
  while Assigned(lid) do
  begin
    if lID.GetContent = DupItem then
      break;
    lID := vID.SearchForTag(lID, 'STOCKITEMNAME');
  end;
  while Assigned(vID) do
  begin
    if Assigned(lID) then
    if lID.GetContent = DupItem then
    begin
      alterid := aID.GetContent;
      vID.RemoveAttr('ACTION');
      vID.AddAttribute('TAGNAME', 'ALTERID');
      vID.AddAttribute('TAGVALUE', alterid);
      vID.AddAttribute('ACTION', 'Alter');
          lID.setContent(Item);
        lID := vID.SearchForTag(lID, 'STOCKITEMNAME');
      yDB := vID.GetXML;
      PostVouXML;
    end;
    vID := vDoc.SearchForTag(vID, 'VOUCHER');
    if not Assigned(vID) then
      Exit;
    lID := vID.SearchForTag(nil, 'STOCKITEMNAME');
    aID := vID.SearchForTag(nil, 'ALTERID');
    while Assigned(lid) do
    begin
      if lID.GetContent = DupItem then
        break;
      lID := vID.SearchForTag(lID, 'STOCKITEMNAME');
    end;
  end;
end;

end.

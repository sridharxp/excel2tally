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
unit xmldb3ML;

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
    lID: Ibjxml;
    plID: Ibjxml;
  public
    { Public declarations }
    ndups: Integer;
    SaveXMLFile: boolean;
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
  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';
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

  if SaveXMLFile then
      Client.xmlResponsefile := 'LedVchRgr.xml';
  Client.Host := FHost;
  Client.xmlRequestString := Fxreq;
  Client.post;
  Errorcheck;
  rdb := Client.xmlResponseString;
end;

(*
procedure TbjxMerge.GetVouXML;
begin
//  '<REPORTNAME>Day Book</REPORTNAME>'+
//  '<REPORTNAME>All Masters</REPORTNAME>'+

  FxReq := '<ENVELOPE><HEADER><TALLYREQUEST>Export Data</TALLYREQUEST></' +
    'HEADER>'+
  '<BODY><EXPORTDATA><REQUESTDESC>' +
//  '<REPORTNAME>Voucher Register</REPORTNAME>'
  '<REPORTNAME>Day Book</REPORTNAME>'
  +'<STATICVARIABLES>';

//  FxReq := FXReq + '<SVEXPORT>' + 'True' + '</SVEXPORT>';
  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';

  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';

//  if ( Length(FFrmDt) <> 0 ) and ( Length(FToDt) <> 0 ) then
//  begin
//    FxReq := FXReq + '<SVFROMDATE>' + FFrmDt + '</SVFROMDATE>';
//    FxReq := FXReq + '<SVTODATE>' + FToDt + '</SVTODATE>';
//  end;
//    FxReq := FXReq + '<SVCURRENTDATE>' + FormatDateTime('DD-MM-YYYY', CurDate)
    FxReq := FXReq + '<SVCURRENTDATE>' + CurDt + '</SVCURRENTDATE>';

    FxReq := FXReq + '<OnlyAccVouchers>' +  'true' + '</OnlyAccVouchers>';
//    FxReq := FXReq + '<OnlyInvVouchers>' +  'True' + '</OnlyInvVouchers>';
//    FxReq := FXReq + '<$$IsSales:SVVoucherType>' + 'False' +
//      '</$$IsSales:SVVoucherType>';
//    Sort : Default : $Date, $SortPosition, $VoucherTypeName
//  if (Length(FVCHType) <> 0) then
//    FxReq := FXReq + '<VOUCHERTYPENAME>' + FVCHType + '</VOUCHERTYPENAME>';

  FxReq := FXReq +
  '</STATICVARIABLES>'+
  '</REQUESTDESC>'+
  '</EXPORTDATA></BODY></ENVELOPE>';

  if SaveXMLFile then
      Client.xmlResponsefile := 'Daybook.xml';
  Client.Host := FHost;
  Client.xmlRequestString := Fxreq;
  Client.post;
  Errorcheck;
  xdb := Client.xmlResponseString;
end;
*)

procedure TbjxMerge.GetVouXML;
var
  strx: IbjXml;
  varx: IbjXml;
  str: string;
  CollName: string;
  cType: string;
begin
  strx := CreatebjXmlDocument;
  varx := CreatebjXmlDocument;
  strx.LoadXml(str);

  CollName := 'Daybook AccCCInvExplColl';
  str := '<FETCH>Ledgername,Amount</FETCH>';
  str := '<FETCH>AllLedgerEntries</FETCH>';
  str := '<FETCH>LedgerEntries</FETCH>';

  str := str + '<NATIVEMETHOD>*</NATIVEMETHOD>';

  str := str + '<FILTER>CurDt</FILTER>';
  strx.LoadXML(str);
  str := '<SYSTEM TYPE="FORMULAE" NAME="CurDt">$Date=$$Date:"' +
      CurDt + '"</SYSTEM>';
  varx.LoadXML(str);
  xdb := ColExEval(CollName, 'Vouchers', strx, varx);
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
  lID := vID.SearchForTag(nil, 'LEDGERNAME');
  plID := vID.SearchForTag(nil, 'PARTYLEDGERNAME');
  aID := vID.SearchForTag(nil, 'ALTERID');
//  aID := vID.SearchForTag(nil, 'MASTERID');
  while Assigned(lID) do
  begin
    if lID.GetContent = DupLed then
      Break;
    lID := vID.SearchForTag(lID, 'LEDGERNAME');
  end;
  while Assigned(vID) do
  begin
    if Assigned(lID) then
    if lID.GetContent = DupLed then
    begin
      alterid := aID.GetContent;
      vID.RemoveAttr('ACTION');
//      vID.AddAttribute('TAGNAME', 'MASTERID');
      vID.AddAttribute('TAGNAME', 'ALTERID');
      vID.AddAttribute('TAGVALUE', alterid);
      vID.AddAttribute('ACTION', 'Alter');
      lID.setContent(Party);
      if Assigned(plID) and (plID.GetContent = DupLed) then
        plID.SetContent(Party);
      yDB := vID.GetXML;
      PostVouXML;
    end;
    vID := vDoc.SearchForTag(vID, 'VOUCHER');
    if not Assigned(vID) then
      Exit;
    lID := vID.SearchForTag(nil, 'LEDGERNAME');
    plID := vID.SearchForTag(nil, 'PARTYLEDGERNAME');
    aID := vID.SearchForTag(nil, 'ALTERID');
//    aID := vID.SearchForTag(nil, 'MASTERID');
    while Assigned(lID) do
    begin
      if lID.GetContent = DupLed then
        Break;
      lID := vID.SearchForTag(lID, 'LEDGERNAME');
    end;
  end;
end;

end.

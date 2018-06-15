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
  Tfnupdate = procedure(msg: string);

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
//    FLedger: string;
  protected
    rDB: string;
    xDB: string;
    yDB: string;
    Client: TbjClient;
    aID: Ibjxml;
    vID: Ibjxml;
    lID: Ibjxml;
//    plID: Ibjxml;
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
    procedure GetItemVchRgtr;
    procedure GetVouXML;
    procedure PostVouXML;
    procedure Process;
    procedure ReplDupItem;
    procedure ErrorCheck;
  published
    property Firm: String read FFirm write FFirm;
    property Host: String read FHost write FHost;
    property FrmDt: string Read FFrmDt write FFrmDt;
    property ToDt: string Read FToDt write FToDt;
    property Item: string Read FItem write FItem;
    property DupItem: string Read FDupItem write FDupItem;
//    property Ledger: string Read FLedger write FLedger;
  end;

implementation

Constructor TbjxMerge.Create;
begin
  FHost := 'http://127.0.0.1:9000';
  Client := TbjClient.Create;
  SaveXMLFile := True;
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
      FUpdate('Processing ' + CurDt);
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
//  '<REPORTNAME>Ledger Vouchers</REPORTNAME>'
  '<REPORTNAME>Stock Vouchers</REPORTNAME>'
//  '<REPORTNAME>All Stock Items</REPORTNAME>'
  +'<STATICVARIABLES>';
  FxReq := FXReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';
  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';
  if ( Length(FFrmDt) <> 0 ) and ( Length(FToDt) <> 0 ) then
  begin
    FxReq := FXReq + '<SVFROMDATE>' + FFrmDt + '</SVFROMDATE>';
    FxReq := FXReq + '<SVTODATE>' + FToDt + '</SVTODATE>';
  end;
//  FxReq := FXReq + '<LEDGERNAME>' +  Ledger + '</LEDGERNAME>';
    FxReq := FXReq + '<STOCKITEMNAME>' +  DupItem + '</STOCKITEMNAME>';
  FxReq := FXReq +
  '</STATICVARIABLES>'+
  '</REQUESTDESC>'+
  '</EXPORTDATA></BODY></ENVELOPE>';

  if SaveXMLFile then
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
//  '<REPORTNAME>Day Book</REPORTNAME>'+
//  '<REPORTNAME>All Masters</REPORTNAME>'+

  FxReq := '<ENVELOPE><HEADER><TALLYREQUEST>Export Data</TALLYREQUEST></' +
    'HEADER>'+
  '<BODY><EXPORTDATA><REQUESTDESC>' +
  '<REPORTNAME>Voucher Register</REPORTNAME>'
//  '<REPORTNAME>Day Book</REPORTNAME>'
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

    FxReq := FXReq + '<IsStockReport>' +  'true' + '</IsStockReport>';
//    FxReq := FXReq + '<STOCKITEMNAME>' +  DupItem + '</STOCKITEMNAME>';
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
      Client.xmlResponsefile := 'VouReg.xml';
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
  FxReq := FXReq + '<SVOverwriteImpVch>' + 'true' + '</SVOverwriteImpVch>';

  if (Length(FFirm) <> 0) then
    FxReq := FXReq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';

  FxReq := FXReq +
  '</STATICVARIABLES>'+
  '</REQUESTDESC><REQUESTDATA><TALLYMESSAGE>';
  yDB := FXReq + yDB +
    '</TALLYMESSAGE></REQUESTDATA></IMPORTDATA></BODY></ENVELOPE>';
  VDoc := CreatebjXmlDocument;
//  vDoc.LoadXML(yDB);
//  vDoc.SaveXmlFile('Voucher.xml');
  Client.Host := FHost;
  Client.xmlRequestString := yDB;
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
//  plID := vID.SearchForTag(nil, 'PARTYLEDGERNAME');
  aID := vID.SearchForTag(nil, 'ALTERID');
  while Assigned(lID) do
  begin
    if lID.GetContent = DupItem then
      Break;
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
//      if Assigned(plID) and (plID.GetContent = DupItem) then
//        plID.SetContent(Item);
      yDB := vID.GetXML;
      PostVouXML;
    end;
    vID := vDoc.SearchForTag(vID, 'VOUCHER');
    if not Assigned(vID) then
      Exit;
    lID := vID.SearchForTag(nil, 'STOCKITEMNAME');
///    plID := vID.SearchForTag(nil, 'PARTYLEDGERNAME');
    aID := vID.SearchForTag(nil, 'ALTERID');
    while Assigned(lID) do
    begin
      if lID.GetContent = DupItem then
        Break;
      lID := vID.SearchForTag(lID, 'STOCKITEMNAME');
    end;
  end;
//  ydb := stringreplace (xDB, 'ACTION="Create"', 'ACTION="Delete"', [rfReplaceAll]);
end;

end.

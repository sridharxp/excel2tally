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
unit xmldb_pJrnl;

interface

uses
  Classes, SysUtils, DateUtils,
  DateFns,
  StrUtils,
  Client,
  Math,
  bjxml3_1,
  ZS73,
  Dialogs;

type
  Tfnupdate = procedure(const aMsg: string);

type
  TbjPJrnl = class
  private
    { Private declarations }
    FXReq: wideString;
    FHost: string;
    FFirm: String;
    FFrmDt: string;
    FToDT: string;
    FToLed: string;
    FFrmLed: string;
  protected
    rDB: string;
    xDB: string;
    Client: TbjClient;
    rDoc: Ibjxml;
    rTotal: double;
    Env: TbjEnv;
    MstExp: TbjMstExp;
    VchExp: TbjVchExp;
  public
    { Public declarations }
    ndups: Integer;
    IsSaveXMLFileOn: boolean;
    TallyVersion: string;
{    ImportNoDups: Boolean; }
    CurDt: string;
    FUpdate: TfnUpdate;
    procedure GetVchRgr;
//    procedure GetVouXML;
//    procedure PostVouXML;
    procedure Process;
//    procedure ReplDupItem;
    procedure ErrorCheck;
    procedure SetHost(const aHost: string);
    procedure PostJrnl;
    constructor Create;
    destructor Destroy; override;

    property Firm: String read FFirm write FFirm;
    property Host: String read FHost write SetHost;
    property FrmDt: string Read FFrmDt write FFrmDt;
    property ToDt: string Read FToDt write FToDt;
    property ToLed: string Read FToLed write FToLed;
    property FrmLed: string Read FFrmLed write FFrmLed;
  end;

implementation

Constructor TbjPJrnl.Create;
begin
  FHost := 'http://127.0.0.1:9000';
  Client := TbjClient.Create;
{  IsSaveXMLFileOn := True; }
  Env := TbjEnv.Create;
{  Env.IsSaveXmlFileOn := True; }
  MstExp := TbjMstExp.Create;
  MstExp.Env := Env;
  Env.MstExp := MstExp;
  VchExp := TbjVchExp.Create;
  VchExp.Env := Env;
  VchExp.MstExp := MstExp;
  rDoc := CreatebjXmlDocument;
end;


destructor TbjPJrnl.Destroy;
begin
  VchExp.Free;
  MstExp.Free;
  Env.Free;
  Client.Free;
  inherited;
end;


Procedure TbjPJrnl.ErrorCheck;
begin
  if Client.Response.Size = 0 then
    raise exception.Create('Error Getting Data from Tally');
end;

procedure TbjPJrnl.SetHost(const aHost: string);
begin
  FHost := aHost;
  Env.Host := aHost;
end;

procedure TbjPJrnl.Process;
var
  DtID: Ibjxml;
  contraID, crAmtID, drAmtID: IbjXml;
  contra, crStr, drStr: string;
begin
  rTotal := 0;
  GetVchRgr;
  rDoc.Clear;
  rDoc.LoadXML(rDB);
  DtID := rDoc.SearchForTag(nil, 'DSPVCHDATE');
  if not Assigned(DtID) then
    Exit;
  while Assigned(DtID) do
  begin
    drAmtID := rDoc.SearchForTag(DtID, 'DSPVCHDRAMT');
    IF Assigned(drAmtID) then
    begin
      drStr := drAmtID.GetContent;
      if Length(drStr) > 0 then
      rTotal := rTotal + StrtoFloat(drStr);
      drStr := '';
//    ShowMessage(floattostr(rtotal));
    end;
    crAmtID := rDoc.SearchForTag(DrAmtID, 'DSPVCHCRAMT');
    IF Assigned(crAmtID) then
    begin
      crStr := crAmtID.GetContent;
//    ShowMessage(crStr);
      if Length(crStr) > 0 then
      rTotal := rTotal + StrtoFloat(crStr);
      crStr := '';
    end;
    contraID := rDoc.SearchForTag(crAmtID, 'DSPVCHLEDACCOUNT');
    IF Assigned(contraID) then
    begin
      contra := contraID.GetContent;
    end;
    CurDt := DtID.GetContent;
    FUpdate(FrmLed + ' ' + CurDt);
    DtID := rDoc.SearchForTag(crAmtID, 'DSPVCHDATE');
  end;
  PostJrnl;
end;

procedure TbjPJrnl.GetVchRgr;
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
  FxReq := FXReq + '<LEDGERNAME>' +  FrmLed + '</LEDGERNAME>';
  FxReq := FXReq +
  '</STATICVARIABLES>'+
  '</REQUESTDESC>'+
  '</EXPORTDATA></BODY></ENVELOPE>';

  if IsSaveXMLFileOn then
  begin
      rDoc.LoadXML(FxReq);
      rDoc.SaveXmlFile('LedVch.xml');
  end;
  if IsSaveXMLFileOn then
      Client.xmlResponsefile := 'LedVchRgr.xml';
  Client.Host := FHost;
  Client.xmlRequestString := Fxreq;
  Client.post;
  Errorcheck;
  rdb := Client.xmlResponseString;
end;

procedure TbjPJrnl.PostJrnl;
begin
  if RoundTo(rTotal, -2) = 0 then
    Exit;
  VchExp.VchID := '';
  VchExp.vchDate := FToDt;;
  VchExp.VchType := 'Journal';
  VchExp.AddLine(frmLed, -rTotal);
  VchExp.AddLine(ToLed, rTotal);
  VChExp.VchNarration := 'Finalizing...';
  VchExp.Post('Create', True);
  rTotal := 0;
  ndups := ndups + 1;
end;

end.

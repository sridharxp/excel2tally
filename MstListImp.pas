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
unit MstListImp;

interface

uses
  Classes, SysUtils, Dialogs,
  StrUtils,
  OleCtrls,
  Client,
  VchLib,
  PClientFns,
  bjxml3_1;

type
//  TbjMstListImp = class(TComponent)
  TbjMstListImp = class
  private
    { Private declarations }
    FFirm: String;
    FFrmDt: string;
    FToDT: string;
    FDomain: String;
    FPort: Integer;
    FHost: string;
    FToPack: boolean;
   protected
    Client: TbjClient;
    XCMP: IbjXml;
    XMst: IbjXml;
    XInv: IbjXml;
    xcmpreq: string;
    xmstreq: string;
    SaveXMLFile: boolean;
    TallyVersion: string;
    procedure GetMstXML;
    procedure GetinvXML;
    procedure CheckError;
  public
    { Public declarations }
    ToCheckLedAlias: Boolean;
    CashBankLedList: TStringList;
    PartyLedList: TStringList;
    function GetGrpLedText(const aGrp: string): string;
    constructor Create;
    destructor Destroy; override;
    function GetLedPackedList: TStringList;
{    procedure GetGrpLedList; }
//    function GetLedPackedList: TStringList;
    function GetItemPackedList: TStringList;
    function GetUnitPackedList: TStringList;
    function GetItemGroupPackedList: TStringList;
    function GetCategoryPackedList: TStringList;
    function GetGodownPackedList: TStringList;
    function GetLedText: string;
    function GetItemText: string;

//    function GetGroup(const aled:string): string;
    function GetCMPText: string;
//    function GetSalesList: TStringList;
    function GetSalesText: string;
    function GetPurcText: string;
    function GetTaxText: string;
//  function GetParentList: TStringList;
    function GetPartyText(const Include: boolean): string;
    function GetCashBankText(const Include: boolean): string;
    procedure SetHost(const aHost: string);
   procedure GetPartyList(var PList, NPList: TStringList);
  published
    property Firm: String read FFirm write FFirm;
    property Host: string  read FHost write SetHost;
    property ToPack: boolean  read FToPack write FToPack;
  end;

implementation

Constructor TbjMstListImp.Create;
begin
//  inherited;
  FDomain := '127.0.0.1';
  FPort := 9000;
  FHost := 'http://' + FDomain+':'+InttoStr(FPort);
  Client := TbjClient.Create;
  if not Assigned(ClientFns) then
     ClientFns := TbjGSTClientFns.Create;

  SaveXMLFile := False;

  XCMP := CreatebjXmlDocument;
  XMst := CreatebjXmlDocument;
  xInv := CreatebjXmlDocument;
  ToPack := True;
  ToCheckLedAlias := True;
end;


destructor TbjMstListImp.Destroy;
begin
  XCMP.Clear;
  xMst.Clear;
  XInv.Clear;
  Client.Free;
  CashBankLedList.Free;
  PartyLedList.Free;
  inherited;
end;

procedure TbjMstListImp.SetHost(const aHost: string);
begin
  Client.Host := aHost;
  ClientFns.Host := aHost;
  FHost := aHost;
end;

{ Here is where program exits  most}
Procedure TbjMstListImp.CheckError;
begin
  if Client.Response.Size = 0 then
//  if Response <> nil then
//    ShowMessage(Response.bodyStr)
//  if xcmp.Content = 'Tally 9 Server is Running' then
//  else
    raise exception.Create('Error Getting Data from Tally');
end;


Procedure TbjMstListImp.GetMstXML;
begin
  xmstreq := '<ENVELOPE>'+
    '<HEADER>'+
    '<TALLYREQUEST>Export Data</TALLYREQUEST>'+
    '</HEADER><BODY><EXPORTDATA><REQUESTDESC>'+
    '<REPORTNAME>List of Accounts</REPORTNAME>';

  xMstreq := xMstreq + '<STATICVARIABLES>';

  xmstReq := xmstReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';

//  if noofcmps > 0 then
  if (Length(FFirm) <> 0) then
    xMstreq := xMstreq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';

  if ( Length(FFrmDt) <> 0 ) and ( Length(FToDt) <> 0 ) then
  begin
    xmstReq := xmstReq + '<SVFROMDATE>' + FFrmDt + '</SVFROMDATE>';
    xmstReq := xmstReq + '<SVTODATE>' + FToDt + '</SVTODATE>';
  end;

  xMstreq := xMstreq + '</STATICVARIABLES>';

  xmstreq := xmstreq + '</REQUESTDESC></EXPORTDATA></BODY>'+
    '</ENVELOPE>';

  if SaveXMLFile then
    Client.xmlResponsefile := 'MSTReg.xml';

//  Client.Host :=  FHost;
  Client.xmlRequestString := xMstReq;
  Client.Host :=  FHost;
  Client.post;
  CheckError;
  xmst.LoadXml(Client.xmlResponseString);
end;

Procedure TbjMstListImp.GetinvXML;
begin
  xmstreq := '<ENVELOPE>'+
    '<HEADER>'+
    '<TALLYREQUEST>Export Data</TALLYREQUEST>'+
    '</HEADER><BODY><EXPORTDATA><REQUESTDESC>'+
    '<REPORTNAME>List of Accounts</REPORTNAME>';

  xMstreq := xMstreq + '<STATICVARIABLES>';

  xmstReq := xmstReq + '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>';

//  if noofcmps > 0 then
  if (Length(FFirm) <> 0) then
    xMstreq := xMstreq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';

  xMstreq := xMstreq + '<ISSTOCKREPORT>' + 'Yes' + '</ISSTOCKREPORT>';
//  xMstreq := xMstreq + '<ISITEMREPORT>' + 'Yes' + '</ISITEMREPORT>';

  if ( Length(FFrmDt) <> 0 ) and ( Length(FToDt) <> 0 ) then
  begin
    xmstReq := xmstReq + '<SVFROMDATE>' + FFrmDt + '</SVFROMDATE>';
    xmstReq := xmstReq + '<SVTODATE>' + FToDt + '</SVTODATE>';
  end;

  xMstreq := xMstreq + '<ACCOUNTTYPE>StockItems</ACCOUNTTYPE>';

  xMstreq := xMstreq + '</STATICVARIABLES>';

  xmstreq := xmstreq + '</REQUESTDESC></EXPORTDATA></BODY>'+
    '</ENVELOPE>';

  if SaveXMLFile then
    Client.xmlResponsefile := 'MSTReg.xml';

{ For debugging }
  Client.ToSaveResponse := False;
  Client.xmlResponsefile := 'Tally.xml';
  Client.xmlRequestString := xMstReq;
  Client.Host := FHost;
  Client.post;
  CheckError;
  xInv.LoadXml(Client.xmlResponseString);
end;


function TbjMstListImp.GetCMPText: string;
var
  cmpNode: IbjXml;
  CMPList: TStringList;
begin
  xcmpreq := '<ENVELOPE>'+
    '<HEADER>'+
    '<TALLYREQUEST>Export Data</TALLYREQUEST>'+
    '</HEADER>'+
    '<BODY><EXPORTDATA><REQUESTDESC>'+
    '<REPORTNAME>List of Companies</REPORTNAME>'+
    '<STATICVARIABLES>'+
    '<SVEXPORTFORMAT>' + '$$SysName:XML' + '</SVEXPORTFORMAT>'+
   '</STATICVARIABLES>'+
    '</REQUESTDESC></EXPORTDATA></BODY>'+
    '</ENVELOPE>';

  if SaveXMLFile then
      Client.xmlResponsefile := 'CMPReg.xml';

  Client.xmlRequestString := xcmpreq;
  Client.Host := FHost;
  Client.post;
  CheckError;
  xcmp.LoadXml(Client.xmlResponseString);

  CMPList := TStringList.Create;
  cmpNode := XCMP.SearchForTag(nil, 'COMPANYNAME');
  while cmpNode <> nil do
  begin
    CMPList.Add( CMPNode.Content );
    cmpNode:= XCMP.SearchForTag(cmpnode, 'COMPANYNAME');
  end;
  Result := CMPlist.Text;
  CMPList.Free;
end;

function TbjMstListImp.GetLedPackedList: TStringList;
var
  OResult: IbjXml;
  NameListNode, AliasNode: IbjXml;
  CollName: string;
  AliasName: string;
  DNode, RecNode, LedNode: IbjXml;
  LedPList: TStringList;
  i, Children: integer;
begin
  CollName := 'Ledger';
  LedPList := TStringList.Create;
//  StrS.Add('PARENT');
  OResult := CreatebjXmlDocument;
  LedPList.Add('NAME');
  OResult.LoadXml(ColEval(CollName, 'Ledger', LedPList));
  LedPList.Clear;
  LedNode := OResult.SearchforTag(nil, 'COLLECTION');
  LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  while Assigned(LedNode) do
  begin
    if ToPack then
    LedPList.Add(PackStr(LedNode.GetAttrValue('NAME')))
    else
    LedPList.Add(LedNode.GetAttrValue('NAME'));
    if ToCheckLedAlias then
    begin
      AliasName := LedNode.GetAttrValue('NAME');
      NamelistNode := LedNode.SearchForTag(nil, 'NAME.LIST');
      if NameListNode <> nil then
        AliasNode := NamelistNode.SearchForTag(nil, 'NAME');
      while AliasNode <> nil do
      begin
        if AliasNode.GetContent <>  AliasName then
        begin
        if ToPack then
          LedPList.Add(PackStr(AliasNode.GetContent))
        else
          LedPList.Add(AliasNode.GetContent);
        end;
        AliasNode := NamelistNode.SearchForTag(AliasNode, 'NAME');
      end;
    end;
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
  begin
    LedPList.Sorted := True;
//    ShowMessage(Ledplist.text);
  end;
  Result := LedPList;
    Exit;

(*
{ Change for Collection }
{ LedPList := TStringList.Create; }
//  LedPlist.Sorted := True;
  LedPList.Clear;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        if ToPack then
          LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
        else
          LedPList.Add( LedNode.GetAttrValue('NAME'));
        if ToCheckLedAlias then
        begin
          AliasName := LedNode.GetAttrValue('NAME');
          NamelistNode := LedNode.SearchForTag(nil, 'NAME.LIST');
          if NameListNode <> nil then
            AliasNode := NamelistNode.SearchForTag(nil, 'NAME');
          while AliasNode <> nil do
          begin
            if AliasNode.GetContent <>  AliasName then
            begin
            if ToPack then
              LedPList.Add(PackStr(AliasNode.GetContent))
            else
              LedPList.Add(AliasNode.GetContent);
            end;
            AliasNode := NamelistNode.SearchForTag(AliasNode, 'NAME');
          end;
        end;
      end;
    end;
  end;
  LedPlist.Sorted := True;
  Result := LedPList;
*)
end;

function TbjMstListImp.GetGrpLedText(const aGrp: string): string;
var
  strx: IbjXml;
  strs: string;
  OResult: IbjXml;
  CollName: string;
  parentName: string;
  DNode, RecNode, LedNode, ParentNode: IbjXml;
  LedPList: TStringList;
  i, Children: integer;
  LStr: string;
begin
  LedPList := TStringList.Create;

  strx := CreatebjXmlDocument;
  strs := '<CHILDOF>' + TextToXML(aGrp) + '</CHILDOF>';
  strs := Strs + '<BELONGSTO>' + 'Yes' + '</BELONGSTO>';
  strx.LoadXml(strs);
  CollName := 'Ledger';
  LedPList.Add('PARENT');
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(Col2Eval(CollName, 'Ledger', strx, LedPList));
  LedPList.Clear;
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
{
    ParentNode := OResult.SearchforTag(LedNode, 'PARENT');
    if not Assigned(ParentNode) then
      continue;
    ParentName := ParentNode.GetContent;
    if ParentName = aGrp then
}
    lStr := LedNode.GetAttrValue('NAME');
    if Length(lStr) > 0 then
      LedPList.Add(lStr);
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
    LedPList.Sorted := True;
  begin
  end;
    Result := LedPlist.Text;
    LedPList.Free;
    Exit;

(*
  LedPList.Clear;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        ParentNode := LedNode.SearchforTag(nil, 'PARENT');
        if not Assigned(ParentNode) then
          continue;
        ParentName := ParentNode.GetContent;
        if ParentName = aGrp then
          LedPList.Add( LedNode.GetAttrValue('NAME'));
      end;
    end;
    if LedPList.Count > 0 then
      Result := LedPlist.Text;
      LedPList.Free;
  end;
*)
end;

(*
function TbjMstListImp.GetCashLedPackedList: TStringList;
var
  OResult: IbjXml;
  NameListNode, AliasNode: IbjXml;
  CollName: string;
  AliasName: string;
  parentName: string;
  DNode, RecNode, LedNode, ParentNode: IbjXml;
  LedPList: TStringList;
  i, Children: integer;
begin
  CollName := 'Ledger';
  LedPList := TStringList.Create;
  LedPList.Add('PARENT');
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColEval(CollName, 'Ledger', LedPList));
  LedPList.Clear;
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
    ParentNode := OResult.SearchforTag(LedNode, 'PARENT');
    if not Assigned(ParentNode) then
      continue;
    ParentName := ParentNode.GetContent;
    if (ParentName <> 'Cash-in-Hand') and
    (ParentName <> 'Bank Accounts') then
    begin
      LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
      Continue;
    end;
    if ToPack then
    LedPList.Add(PackStr(LedNode.GetAttrValue('NAME')))
    else
    LedPList.Add(LedNode.GetAttrValue('NAME'));
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
  begin
    LedPList.Sorted := True;
    Result := LedPList;
    Exit;
  end;
  LedPList.Clear;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        ParentNode := LedNode.SearchforTag(nil, 'PARENT');
    if not Assigned(ParentNode) then
      continue;
        ParentName := ParentNode.GetContent;
        if (ParentName <> 'Cash-in-Hand') and
          (ParentName <> 'Bank Accounts') then
          Continue;
        if ToPack then
          LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
        else
          LedPList.Add( LedNode.GetAttrValue('NAME'));
      end;
    end;
  end;
  LedPlist.Sorted := True;
  Result := LedPList;
end;
*)

function TbjMstListImp.GetPartyText(const Include: boolean): string;
var
  OResult: IbjXml;
  DNode, RecNode, LedNode, ParentNode: IbjXml;
  CollName: string;
  LedPList: TStringList;
  i, Children: integer;
  grp: string;
  ok: boolean;
begin
  LedPList := TStringList.Create;
  CollName := 'Ledger';
  LedPList.Add('PARENT');
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColEval(CollName, 'Ledger', LedPList));
  LedPList.Clear;
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
    ok := False;
    ParentNode := OResult.SearchforTag(LedNode, 'PARENT');
    if not Assigned(ParentNode) then
      continue;
    grp := ParentNode.GetContent;
    if Include then
    begin
      if (grp = 'Sundry Debtors') or
        (grp = 'Sundry Creditors') then
        ok := True;
    end
    else
     begin
      if (grp <> 'Sundry Debtors') and
        (grp <> 'Sundry Creditors') then
        ok := True;
    end;
    if ok then
    begin
      if ToPack then
        LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
      else
        LedPList.Add( LedNode.GetAttrValue('NAME'));
    end;
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
  begin
    LedPList.Sorted := True;
  end;
    Result := LedPList.Text;
    LedPList.Free;
    Exit;
(*
  LedPList.Clear;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        ok := False;
        grp := LedNode.GetChildContent('PARENT');
        if Include then
        begin
        if (grp = 'Sundry Debtors') or (grp = 'Sundry Creditors') then
            ok := True;
		end
		else
		begin
          if (grp <> 'Sundry Debtors') and (grp <> 'Sundry Creditors') then
            ok := True;
		    end;
        if ok then
        begin
          if ToPack then
            LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
          else
            LedPList.Add( LedNode.GetAttrValue('NAME'));
        end;
      end;
    end;
  end;
  LedPlist.Sorted := True;
  Result := LedPList.Text;
  LedPList.Free;
*)
end;
function TbjMstListImp.GetCashBankText(const Include: boolean): string;
var
  OResult: IbjXml;
  DNode, RecNode, LedNode, ParentNode: IbjXml;
  CollName: string;
  LedPList: TStringList;
  i, Children: integer;
  grp: string;
  ok: boolean;
begin
  if Include then
    Result := GetGrpLedText('Cash-in-Hand') +
      GetGrpLedText('BankAccounts');
  if Length(Result) > 0 then
    Exit;
  LedPList := TStringList.Create;
  CollName := 'Ledger';
  LedPList.Add('PARENT');
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColEval(CollName, 'Ledger', LedPList));
  LedPList.Clear;
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
    ok := False;
    ParentNode := OResult.SearchforTag(LedNode, 'PARENT');
    if not Assigned(ParentNode) then
      continue;
    grp := ParentNode.GetContent;
    if Include then
    begin
      if (grp = 'Cash-in-Hand') or
        (grp = 'Bank Accounts') then
        ok := True;
    end
    else
     begin
      if (grp <> 'Cash-in-Hand') and
        (grp <> 'Bank Accounts') then
        ok := True;
    end;
    if ok then
    begin
      if ToPack then
        LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
      else
        LedPList.Add( LedNode.GetAttrValue('NAME'));
    end;
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
  begin
    LedPList.Sorted := True;
  end;
  Result := LedPList.Text;
    LedPList.Free;
    Exit;

  
(*
  LedPList.Clear;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        ok := False;
        grp := LedNode.GetChildContent('PARENT');
        if Include then
        begin
          if (grp = 'Cash-in-Hand') or (grp = 'Bank Accounts') then
            ok := True;
		    end
		    else
		    begin
          if (grp <> 'Cash-in-Hand') and (grp <> 'Bank Accounts') then
            ok := True;
		end;
        if ok then
        begin
          if ToPack then
            LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
          else
            LedPList.Add( LedNode.GetAttrValue('NAME'));
        end;
      end;
    end;
  end;
  Result := LedPList.Text;
  LedPList.Free;
*)
end;
{
function TbjMstListImp.GetGroup(const aled:string): string;
var
  DNode, RecNode, LedNode: IbjXml;
  i, Children: integer;
  led, grp: string;
begin
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        led := ledNode.GetAttrValue('NAME');
        if (led = aled) then
        begin
          grp := LedNode.GetChildContent('PARENT');
          break;
        end;
      end;
    end;
  end;
  Result := grp;
end;
{
function TbjMstList.GetTaxAcList(const Include: boolean): TStringList;
var
  DNode, RecNode, LedNode: IbjXml;
  LedPList: TStringList;
  i, Children: integer;
  grp: string;
  ok: boolean;
begin
  LedPList := TStringList.Create;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        ok := False;
        grp := LedNode.GetChildContent('PARENT');
        if Include then
        begin
        if (grp = 'Sundry Debtors') or (grp = 'Duties & Taxes') then
          ok := True;
        end;
        if ok then
        begin
          if ToPack then
            LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
          else
            LedPList.Add( LedNode.GetAttrValue('NAME'));
        end;
      end;
    end;
  end;
  LedPlist.Sorted := True;
  Result := LedPList;
end;
}

function TbjMstListImp.GetTaxText: string;
var
  OResult: IbjXml;
  DNode, RecNode, LedNode, ParentNode: IbjXml;
  CollName: string;
  LedPList: TStringList;
  i, Children: integer;
  grp: string;
  ok: boolean;
begin
  LedPList := TStringList.Create;
  CollName := 'Ledger';
  LedPList.Add('PARENT');
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColEval(CollName, 'Ledger', LedPList));
  LedPList.Clear;
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
    ok := False;
    ParentNode := OResult.SearchforTag(LedNode, 'PARENT');
    if not Assigned(ParentNode) then
      continue;
    grp := ParentNode.GetContent;
    if (grp = 'Duties & Taxes') then
      ok := True;
    if ok then
    begin
      if ToPack then
        LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
      else
        LedPList.Add( LedNode.GetAttrValue('NAME'));
    end;
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
  begin
    LedPList.Sorted := True;
  end;
    Result := LedPList.Text;
    LedPList.Free;
    Exit;

(*
  LedPList := TStringList.Create;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        ok := False;
        grp := LedNode.GetChildContent('PARENT');
        if (grp = 'Duties & Taxes') then
          ok := True;
        if ok then
        begin
          if ToPack then
            LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
          else
            LedPList.Add( LedNode.GetAttrValue('NAME'));
        end;
      end;
    end;
  end;
  LedPlist.Sorted := True;
  Result := LedPList.Text;
*)
end;

{
function TbjMstList.GetSalesAcList(const Include: boolean): TStringList;
var
  DNode, RecNode, LedNode: IbjXml;
  LedPList: TStringList;
  i, Children: integer;
  grp: string;
  ok: boolean;
begin
  LedPList := TStringList.Create;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        ok := False;
        grp := LedNode.GetChildContent('PARENT');
        if Include then
        begin
        if (grp = 'Sundry Debtors') or (grp = 'Sales Accounts') then
          ok := True;
        end;
        if ok then
        begin
          if ToPack then
            LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
          else
            LedPList.Add( LedNode.GetAttrValue('NAME'));
        end;
      end;
    end;
  end;
  LedPlist.Sorted := True;
  Result := LedPList;
end;
}
//nction TbjMstListImp.GetSalesList: TStringList;
function  TbjMstListImp.GetSalesText: string;
var
  OResult: IbjXml;
  DNode, RecNode, LedNode, ParentNode: IbjXml;
  CollName: string;
  LedPList: TStringList;
  i, Children: integer;
  grp: string;
  ok: boolean;
begin
  LedPList := TStringList.Create;

  CollName := 'Ledger';
  LedPList.Add('PARENT');
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColEval(CollName, 'Ledger', LedPList));
  LedPList.Clear;
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
    ok := False;
    ParentNode := OResult.SearchforTag(LedNode, 'PARENT');
    if not Assigned(ParentNode) then
      continue;
    grp := ParentNode.GetContent;
    if (grp = 'Sales Accounts') then
      ok := True;
    if ok then
    begin
      if ToPack then
        LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
      else
        LedPList.Add( LedNode.GetAttrValue('NAME'));
    end;
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
  begin
    LedPList.Sorted := True;
  end;
  Result := LedPList.Text;
  LedPList.Free;
  Exit;
  
(*  
  LedPList := TStringList.Create;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        ok := False;
        grp := LedNode.GetChildContent('PARENT');
        if (grp = 'Sales Accounts') then
           ok := True;
        if ok then
        begin
          if ToPack then
            LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
          else
            LedPList.Add( LedNode.GetAttrValue('NAME'));
        end;
      end;
    end;
  end;
  LedPlist.Sorted := True;
  Result := LedPList;
*)
end;

function TbjMstListImp.GetPurcText: string;
var
  OResult: IbjXml;
  DNode, RecNode, LedNode, ParentNode: IbjXml;
  CollName: string;
  LedPList: TStringList;
  i, Children: integer;
  grp: string;
  ok: boolean;
begin
  LedPList := TStringList.Create;

  CollName := 'Ledger';
  LedPList.Add('PARENT');
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColEval(CollName, 'Ledger', LedPList));
  LedPList.Clear;
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
    ok := False;
    ParentNode := OResult.SearchforTag(LedNode, 'PARENT');
    if not Assigned(ParentNode) then
      continue;
    grp := ParentNode.GetContent;
    if (grp = 'Purchase Accounts') then
      ok := True;
    if ok then
    begin
      if ToPack then
        LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
      else
        LedPList.Add( LedNode.GetAttrValue('NAME'));
    end;
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
  begin
    LedPList.Sorted := True;
  end;
  Result := LedPList.Text;
  LedPList.Free;
  Exit;
(*
  LedPList := TStringList.Create;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        ok := False;
        grp := LedNode.GetChildContent('PARENT');
        if (grp = 'Purchase Accounts') then
           ok := True;
        if ok then
        begin
          if ToPack then
            LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
          else
            LedPList.Add( LedNode.GetAttrValue('NAME'));
        end;
      end;
    end;
  end;
*)
end;

//procedure TbjMstList.GetLedText(var Data:pchar; out Size:integer);
function TbjMstListImp.GetLedText: string;
var
  LedNode: IbjXml;
  LedList: TStringList;
//  i, TxtLen: integer;
//  str: string;
begin
  LedList := TStringList.Create;
  GetMstXML;
  LedNode := XMst.SearchForTag(nil, 'LEDGER');
  while LedNode <> nil do
  begin
    LedList.Add(LedNode.GetAttrValue('NAME'));
    LedNode:= XMst.SearchForTag( LedNode, 'LEDGER' );
  end;
  try
  Result := LedList.Text;
  finally
    LedList.Free;
  end;
{
  str := LedList.Text;
  TxtLen := Length(str);
  for i := 1 to Size do
  begin
    if i < TxtLen then
      Data[i] := str[i]
    else
      break;
  end;
  size := TxtLen;
}
end;

(*
function TbjMstList.GetParentList: TStringList;
var
  Node: IbjXml;
  List: TStringList;
begin
  List := TStringList.Create;
{ Updating of Mst lists are likely to happen at the same time }
//  GetMstXML;
  Node := XMst.SearchForTag(nil, 'LEDGER');
  while Node <> nil do
  begin
    List.Add( Node.GetChildContent('PARENT' ));
    Node:= XMst.SearchForTag( Node, 'LEDGER' );
  end;
  Result := List;
end;
*)

function TbjMstListImp.GetItemPackedList: TStringList;
var
  OResult: IbjXml;
  CollName: string;
  strx: IbjXml;
  iStr: string;

  DNode, RecNode: IbjXml;
  i, Children: integer;
  ItemNode: IbjXml;
  ItemPList: TStringList;
begin
  ItemPList := TStringList.Create;

  CollName := 'StockItem';
//  ItemPList.Add('NAME');
//  StrS.Add('PARENT');
  OResult := CreatebjXmlDocument;
//  OResult.LoadXml(ColEval(CollName, 'StockItem', ItemPList));
  OResult.LoadXml(Col2Eval(CollName, 'StockItem', strx, ItemPList));
  ItemPList.Clear;
//  ShowMessage(OResult.GetXML);
  ItemNode := OResult.SearchforTag(nil, 'COLLECTION');
  ItemNode := OResult.SearchforTag(ItemNode, 'STOCKITEM');
  while Assigned(ItemNode) do
  begin
    iStr := ItemNode.GetAttrValue('NAME');
    if Length(iStr) > 0 then
    begin
    if ToPack then
        ItemPList.Add(PackStr(iStr))
    else
        ItemPList.Add(iStr);
    end;
    ItemNode := OResult.SearchforTag(ItemNode, 'STOCKITEM');
  end;
  if ItemPList.Count > 0 then
  begin
    ItemPList.Sorted := True;
  end;
  Result := ItemPList;
    Exit;

(*
{ Change for Collection }
{  ItemPList := TStringList.Create; }
//  ItemPlist.Sorted := True;
  ItemPList.Clear;
  GetInvXML;
  Dnode := xInv.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      ItemNode := RecNode.SearchForTag(nil, 'STOCKITEM');
      if ItemNode <> nil then
      begin
      if ToPack then
        ItemPList.Add( PackStr(ItemNode.GetAttrValue('NAME')))
      else
        ItemPList.Add( ItemNode.GetAttrValue('NAME'));
      end;
    end;
  end;
  ItemPlist.Sorted := True;
  Result := ItemPList;
*)
end;

function TbjMstListImp.GetUnitPackedList: TStringList;
var
  OResult: IbjXml;
  CollName: string;
  strx: IbjXml;
  uStr: string;
  DNode, RecNode: IbjXml;
  i, Children: integer;
  UnitNode: IbjXml;
  UnitPList: TStringList;
begin
  UnitPList := TStringList.Create;

  CollName := 'Unit';
//  UnitPList.Add('NAME');
//  StrS.Add('PARENT');
  OResult := CreatebjXmlDocument;
//  OResult.LoadXml(ColEval(CollName, 'Unit', uNITPList));
  OResult.LoadXml(Col2Eval(CollName, 'Unit', strx, UnitPList));
  uNITPList.Clear;
//  ShowMessage(OResult.GetXML);
  UnitNode := OResult.SearchforTag(nil, 'COLLECTION');
  UnitNode := OResult.SearchforTag(UnitNode, 'UNIT');
  while Assigned(UnitNode) do
  begin
    uStr :=  UnitNode.GetAttrValue('NAME');
    if Length(uStr) > 0 then
    begin
    if ToPack then
        UnitPList.Add(PackStr(uStr))
    else
        UnitPList.Add(uStr);
    end;
    UnitNode := OResult.SearchforTag(UnitNode, 'UNIT');
  end;
  if UnitPList.Count > 0 then
  begin
    UnitPList.Sorted := True;
{   ShowMessage(Unitplist.text); }
  end;
  Result := UnitPList;
  Exit;

(*
{ Change for Collection }
{  UnitPList := TStringList.Create; }
//  ItemPlist.Sorted := True;
  UnitPList.Clear;
  GetInvXML;
  Dnode := xInv.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      UnitNode := RecNode.SearchForTag(nil, 'UNIT');
      if UnitNode <> nil then
      begin
      if ToPack then
        UnitPList.Add( PackStr(UnitNode.GetAttrValue('NAME')))
      else
        UnitPList.Add( UnitNode.GetAttrValue('NAME'));
      end;
    end;
  end;
  UnitPlist.Sorted := True;
  Result := UnitPList;
*)
end;

function TbjMstListImp.GetItemGroupPackedList: TStringList;
var
  OResult: IbjXml;
  CollName: string;
  strx: IbjXml;
  gStr: string;
  DNode, RecNode: IbjXml;
  i, Children: integer;
  GroupNode: IbjXml;
  GrpPList: TStringList;
begin
  GrpPList := TStringList.Create;
//  ItemPlist.Sorted := True;
  CollName := 'STOCKGROUP';
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(Col2Eval(CollName, 'STOCKGROUP', strx, GrpPList));
  GrpPList.Clear;
  GroupNode := OResult.SearchforTag(nil, 'COLLECTION');
  GroupNode := OResult.SearchforTag(GroupNode, 'STOCKGROUP');
  while Assigned(GroupNode) do
  begin
    gStr := GroupNode.GetAttrValue('NAME');
    if Length(gStr) > 0 then
      begin
      if ToPack then
        GrpPList.Add(PackStr(gStr))
      else
        GrpPList.Add(gStr);
      end;
    GroupNode := OResult.SearchforTag(GroupNode, 'STOCKGROUP');
    end;
  if GrpPList.Count > 0 then
  begin
    GrpPList.Sorted := True;
  end;
  Result := GrpPList;
  Exit;
(*
  GrpPlist.Sorted := True;
  Result := GrpPList;
*)
end;

function TbjMstListImp.GetCategoryPackedList: TStringList;
var
  OResult: IbjXml;
  CollName: string;
  strx: IbjXml;
  cStr: string;
  DNode, RecNode: IbjXml;
  i, Children: integer;
  CategoryNode: IbjXml;
  StkCatPList: TStringList;
begin
  StkCatPList := TStringList.Create;
//  ItemPlist.Sorted := True;
  CollName := 'STOCKCATEGORY';
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(Col2Eval(CollName, 'STOCKCATEGORY', strx, StkCatPList));
  StkCatPList.Clear;
  CategoryNode := OResult.SearchforTag(nil, 'COLLECTION');
  CategoryNode := OResult.SearchforTag(CategoryNode, 'STOCKCATEGORY');
  while Assigned(CategoryNode) do
  begin
    cStr := CategoryNode.GetAttrValue('NAME');
    if Length(cStr) > 0 then
      begin
      if ToPack then
        StkCatPList.Add(PackStr(cStr))
      else
        StkCatPList.Add(cStr);
      end;
    CategoryNode := OResult.SearchforTag(CategoryNode, 'STOCKCATEGORY');
    end;
  if StkCatPList.Count > 0 then
  begin
    StkCatPList.Sorted := True;
  end;
  Result := StkCatPList;
  Exit;
(*
  GrpPlist.Sorted := True;
  Result := GrpPList;
*)
end;

function TbjMstListImp.GetGodownPackedList: TStringList;
var
  OResult: IbjXml;
  CollName: string;
  strx: IbjXml;
  gStr: string;
  DNode, RecNode: IbjXml;
  i, Children: integer;
  GodownNode: IbjXml;
  GdnPList: TStringList;
begin
  GdnPList := TStringList.Create;
//  ItemPlist.Sorted := True;
  CollName := 'GODOWN';
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(Col2Eval(CollName, 'GODOWN', strx, GdnPList));
  GdnPList.Clear;
  GodownNode := OResult.SearchforTag(nil, 'COLLECTION');
  GodownNode := OResult.SearchforTag(GodownNode, 'GODOWN');
  while Assigned(GodownNode) do
  begin
    gStr := GodownNode.GetAttrValue('NAME');
    if Length(gStr) > 0 then
      begin
      if ToPack then
        GdnPList.Add(PackStr(gStr))
      else
        GdnPList.Add(gStr);
      end;
    GodownNode := OResult.SearchforTag(GodownNode, 'GODOWN');
    end;
  if GdnPList.Count > 0 then
  begin
    GdnPList.Sorted := True;
  end;
  Result := GdnPList;
  Exit;
(*
  GdnPlist.Sorted := True;
  Result := GdnPList;
*)
end;

//procedure TbjMstList.GetItemText(var data:pchar; out size:integer);
function TbjMstListImp.GetItemText: string;
var
  strx: IbjXml;
  OResult: IbjXml;
  CollName: string;
  iStr: string;
  ItemNode: IbjXml;
  ItemList: TStringList;
//  i, TxtLen: integer;
//  str: string;
begin
  ItemList := TStringList.Create;
  strx := CreatebjXmlDocument;
  CollName := 'STOCKITEM';
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(Col2Eval(CollName, 'STOCKITEM', strx, ItemList));
  ItemList.Clear;
  ItemNode := OResult.SearchforTag(nil, 'STOCKITEM');
  while Assigned(ItemNode) do
  begin
    iStr := ItemNode.GetAttrValue('NAME');
    if Length(iStr) > 0 then
      ItemList.Add(iStr);
    ItemNode := OResult.SearchforTag(ItemNode, 'STOCKITEM');
  end;
  if ItemList.Count > 0 then
  begin
    Result := ItemList.Text;
    ItemList.Free;
    Exit;
  end;
  ItemList.Clear;
  GetInvXML;
  ItemNode := XInv.SearchForTag(nil, 'STOCKITEM');
  while ItemNode <> nil do
  begin
    ItemList.Add(ItemNode.GetAttrValue('NAME'));
    ItemNode:= XInv.SearchForTag( ItemNode, 'STOCKITEM' );
  end;
  try
  Result := ItemList.Text;
  finally
    ItemList.Free;
  end;
//  str := ItemList.Text;
//  TxtLen := Length(str);
//  for i := 1 to Size do
//  begin
//    if i < TxtLen then
//      Data[i] := str[i]
//    else
//      break;
//  end;
//  size := TxtLen;
end;
{
initialization
finalization
  begin
    if vList.Count > 0 then
    for ptrctr := 0 to vList.Count - 1 do
      StrDispose(vList.Items[ptrctr]);
    vList.Clear;
    vList.Free;
  end;
}
procedure TbjMstListImp.GetPartyList(var PList, NPList: TStringList);
var
  OResult: IbjXml;
  DNode, RecNode, LedNode, ParentNode: IbjXml;
  CollName: string;
  LedPList: TStringList;
  i, Children: integer;
  grp: string;
  ok: boolean;
begin
  LedPList := TStringList.Create;
  PList := TStringList.Create;
  NPList := TStringList.Create;
  PList.Clear;
  NPList.Clear;

  CollName := 'Ledger';
  LedPList.Add('PARENT');
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColEval(CollName, 'Ledger', LedPList));
  LedPList.Clear;
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
    ok := False;
    ParentNode := OResult.SearchforTag(LedNode, 'PARENT');
    if not Assigned(ParentNode) then
      continue;
    grp := ParentNode.GetContent;
//    if Include then
//    begin
      if (grp = 'Sundry Debtors') or
        (grp = 'Sundry Creditors') then
        ok := True;
//    end
//    else
//     begin
      if (grp <> 'Sundry Debtors') and
        (grp <> 'Sundry Creditors') then
        ok := False;
//    end;
    if ok then
    begin
      if ToPack then
        PList.Add( PackStr(LedNode.GetAttrValue('NAME')))
      else
        PList.Add( LedNode.GetAttrValue('NAME'));
    end
    else
    begin
      if ToPack then
        NPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
      else
        NPList.Add( LedNode.GetAttrValue('NAME'));
    end;
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if PList.Count > 0 then
  begin
    PList.Sorted := True;
  end;
  if NPList.Count > 0 then
  begin
    NPList.Sorted := True;
  end;
  LedPList.Free;
  Exit;
	
(*
  PList.Clear;
  NPList.Clear;
  GetMstXML;
  Dnode := xMst.SearchForTag(nil, 'REQUESTDATA');
  if Assigned(DNode) then
  begin
    Children := DNode.GetNumChildren;
    for i := 0 to Children - 1 do
    begin
      RecNode := DNode.GetChild(i);
      LedNode := RecNode.SearchForTag(nil, 'LEDGER');
      if LedNode <> nil then
      begin
        ok := False;
        grp := LedNode.GetChildContent('PARENT');
//        if Include then
//        begin
          if (grp = 'Sundry Debtors') or (grp = 'Sundry Creditors') then
            ok := True;
//		    end
//		    else
//		    begin
          if (grp <> 'Sundry Debtors') and (grp <> 'Sundry Creditors') then
            ok := False;
//		    end;
        if ok then
        begin
          if ToPack then
            PList.Add( PackStr(LedNode.GetAttrValue('NAME')))
          else
            PList.Add( LedNode.GetAttrValue('NAME'));
        end
       else
       begin
          if ToPack then
            NPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
          else
            NPList.Add( LedNode.GetAttrValue('NAME'));
       end;
      end;
    end;
  end;
  PList.Sorted := True;
  NPList.Sorted := True;
  LedPList.Free;
*)
end;


end.

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
    function GetItemPackedList: TStringList;
    function GetUnitPackedList: TStringList;
    function GetItemGroupPackedList: TStringList;
    function GetCategoryPackedList: TStringList;
    function GetGodownPackedList: TStringList;
    function GetLedText: string;
    function GetItemText: string;

    function GetCMPText: string;
    function GetVchTypeText: string;
    function GetTaxText: string;
    function GetPartyText(const Include: boolean): string;
    function GetCashBankText(const Include: boolean): string;
    procedure SetHost(const aHost: string);
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

  if (Length(FFirm) <> 0) then
    xMstreq := xMstreq + '<SVCURRENTCOMPANY>' + FFirm + '</SVCURRENTCOMPANY>';

  xMstreq := xMstreq + '<ISSTOCKREPORT>' + 'Yes' + '</ISSTOCKREPORT>';

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


function TbjMstListImp.GetCmpText: string;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  CmpNode: IbjXml;
  CollName: string;
  CmpList: TStringList;
begin
  CmpList := TStringList.Create;
  xSVar := CreatebjXmlDocument;
  CollName := 'List_of_Companies';
  OResult := CreatebjXmlDocument;
  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  OResult.LoadXml(ColeXEval(CollName, 'Company On Disk', xSVar, xStr, xFormula));
  CmpNode := OResult.SearchForTag(nil, 'COLLECTION');
  CmpNode := OResult.SearchForTag(CmpNode, 'COMPANYONDISK');
  while CmpNode <> nil do
  begin
    if ToPack then
      CmpList.Add(PackStr(CmpNode.GetChildContent('NAME')))
    else
      CmpList.Add(CmpNode.GetChildContent('NAME'));
    CmpNode:= OResult.SearchForTag( CmpNode, 'COMPANYONDISK' );
  end;
  Result := CmpList.Text;
  CmpList.Free;
end;

function TbjMstListImp.GetLedPackedList: TStringList;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  CollName: string;
  LedNode: IbjXml;
  NameListNode, AliasNode: IbjXml;
  AliasName: string;
  LedPList: TStringList;
begin
  LedPList := TStringList.Create;
  xSVar := CreatebjXmlDocument;
  xStr := CreatebjXmlDocument;
  CollName := 'Ledger';
  OResult := CreatebjXmlDocument;
  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  xStr.LoadXML('<NATIVEMETHOD>NAME</NATIVEMETHOD>');

  OResult.LoadXml(ColeXEval(CollName, 'Ledger', xSVar, xStr, xFormula));
//  orESULT.SaveXmlFile('aLIAS.XML');
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
{    ShowMessage(LedPList.Text); }
  end;
  Result := LedPList;

end;

function TbjMstListImp.GetGrpLedText(const aGrp: string): string;
var
  xSVar, xStr, xFormula: IbjXml;
  strs: string;
  OResult: IbjXml;
  CollName: string;
  LedNode: IbjXml;
  LedPList: TStringList;
  LStr: string;
begin
  LedPList := TStringList.Create;

  xSVar := CreatebjXmlDocument;
  xStr := CreatebjXmlDocument;
  if Length(aGrp) > 0 then
  begin
  strs := '<CHILDOF>' + TextToXML(aGrp) + '</CHILDOF>';
  strs := Strs + '<BELONGSTO>' + 'Yes' + '</BELONGSTO>';
  end;
  xStr.LoadXml(strs);
  CollName := 'Ledger';
//  LedPList.Add('PARENT');
//  xMethod.LoadXML('<NATIVEMETHOD>Name</NATIVEMETHOD>');
  OResult := CreatebjXmlDocument;

  xSVar.LoadXML('<STATICVARIABLES>'+
'<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
'</STATICVARIABLES>');

  OResult.LoadXml(ColExEval(CollName, 'Ledger', xSVar, xStr, xFormula));
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
    lStr := LedNode.GetAttrValue('NAME');
    if Length(lStr) > 0 then
      LedPList.Add(lStr);
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
    LedPList.Sorted := True;
    Result := LedPlist.Text;
    LedPList.Free;

end;


function TbjMstListImp.GetPartyText(const Include: boolean): string;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  LedNode: IbjXml;
  CollName: string;
  LedPList: TStringList;
begin
  LedPList := TStringList.Create;
  xSVar := CreatebjXmlDocument;
  xStr := CreatebjXmlDocument;
  xFormula := CreatebjXmlDocument;

  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  xStr.LoadXML('<FILTERS>VTYPE</FILTERS>');
  if Include then
    xFormula.LoadXML('<SYSTEM TYPE="Formulae" NAME="VTYPE">'+
  '$Parent="Sundry Debtors" or $Parent="Sundry Creditors"</SYSTEM>')
  else
    xFormula.LoadXML('<SYSTEM TYPE="Formulae" NAME="VTYPE">'+
  '$Parent!="Sundry Debtors" and $Parent!="Sundry Creditors"</SYSTEM>');

  CollName := 'Ledger';
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColExEval(CollName, 'Ledger', xSVar, xStr, xFormula));
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
    if ToPack then
      LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
    else
      LedPList.Add( LedNode.GetAttrValue('NAME'));
     LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
  begin
    LedPList.Sorted := True;
  end;
  Result := LedPList.Text;
  LedPList.Free;
end;


function TbjMstListImp.GetCashBankText(const Include: boolean): string;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  LedNode: IbjXml;
  CollName: string;
  LedPList: TStringList;
begin
  LedPList := TStringList.Create;
  xSVar := CreatebjXmlDocument;
  xStr := CreatebjXmlDocument;
  xFormula := CreatebjXmlDocument;

  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  xStr.LoadXML('<FILTERS>VTYPE</FILTERS>');
  if Include then
    xFormula.LoadXML('<SYSTEM TYPE="Formulae" NAME="VTYPE">'+
  '$Parent="Cash-in-Hand" or $Parent="Bank Accounts"</SYSTEM>')
  else
    xFormula.LoadXML('<SYSTEM TYPE="Formulae" NAME="VTYPE">'+
  '$Parent!="Cash-in-Hand" and $Parent!="Bank Accounts"</SYSTEM>');

  CollName := 'Ledger';
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColExEval(CollName, 'Ledger', xSVar, xStr, xFormula));
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
    if ToPack then
      LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
    else
      LedPList.Add( LedNode.GetAttrValue('NAME'));
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
  begin
    LedPList.Sorted := True;
  end;
  Result := LedPList.Text;
  LedPList.Free;
end;


function TbjMstListImp.GetTaxText: string;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  CollName: string;
  LedNode: IbjXml;
  LedPList: TStringList;
  rTaxGrpName: string;
begin
  LedPList := TStringList.Create;
  xSVar := CreatebjXmlDocument;
  xStr := CreatebjXmlDocument;
  xFormula := CreatebjXmlDocument;
  rTaxGrpName := TexttoXml('Duties & Taxes');
  CollName := 'Ledger';
  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  xStr.LoadXML('<FILTERS>VTYPE</FILTERS>');
    xFormula.LoadXML('<SYSTEM TYPE="Formulae" NAME="VTYPE">'+
  '$Parent="'+rTaxGrpName+'"</SYSTEM>');

  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColExEval(CollName, 'Ledger', xSVar, xStr, xFormula));
  LedNode := OResult.SearchforTag(nil, 'LEDGER');
  while Assigned(LedNode) do
  begin
      if ToPack then
        LedPList.Add( PackStr(LedNode.GetAttrValue('NAME')))
      else
        LedPList.Add( LedNode.GetAttrValue('NAME'));
    LedNode := OResult.SearchforTag(LedNode, 'LEDGER');
  end;
  if LedPList.Count > 0 then
  begin
    LedPList.Sorted := True;
  end;
    Result := LedPList.Text;
    LedPList.Free;

end;


  



//procedure TbjMstList.GetLedText(var Data:pchar; out Size:integer);
function TbjMstListImp.GetLedText: string;
var
  LedPList: TStringList;
begin
  LedPList := GetLedPackedList;
  Result := LedPList.Text;
  LedPList.Free;
end;
function TbjMstListImp.GetVchTypeText: string;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  LedNode: IbjXml;
  CollName: string;
  VTypeList: TStringList;
begin
  VTypeList := TStringList.Create;
  xSVar := CreatebjXmlDocument;
  CollName := 'LedText';
  OResult := CreatebjXmlDocument;
  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  OResult.LoadXml(ColeXEval(CollName, 'Voucher Types', xSVar, xStr, xFormula));
  LedNode := OResult.SearchForTag(nil, 'COLLECTION');
  LedNode := OResult.SearchForTag(LedNode, 'VOUCHERTYPE');
  while LedNode <> nil do
  begin
    if ToPack then
      VTypeList.Add(PackStr(LedNode.GetAttrValue('NAME')))
    else
      VtypeList.Add(LedNode.GetAttrValue('NAME'));
    LedNode:= OResult.SearchForTag( LedNode, 'VOUCHERTYPE' );
  end;
  Result := VTypeList.Text;
  VTypeList.Free;
end;


function TbjMstListImp.GetItemPackedList: TStringList;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  CollName: string;
  iStr: string;
  ItemNode: IbjXml;
  ItemList: TStringList;
begin
  ItemList := TStringList.Create;
  xSVar := CreatebjXmlDocument;

  CollName := 'STOCKITEM';
  OResult := CreatebjXmlDocument;
    xSVar.LoadXML('<STATICVARIABLES>'+
'<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
'</STATICVARIABLES>');
  OResult.LoadXml(ColExEval(CollName, 'STOCKITEM', xSVar, xStr, xFormula));
  ItemNode := OResult.SearchforTag(nil, 'STOCKITEM');
  while Assigned(ItemNode) do
  begin
    iStr := ItemNode.GetAttrValue('NAME');
    if Length(iStr) = 0 then
    begin
      ItemNode := OResult.SearchforTag(ItemNode, 'STOCKITEM');
      Continue;
    end;
    if ToPack then
      ItemList.Add(PackStr(iStr))
    else
      ItemList.Add(iStr);
    ItemNode := OResult.SearchforTag(ItemNode, 'STOCKITEM');
  end;
  if ItemList.Count > 0 then
  begin
    ItemList.Sorted := True;
  end;
  Result := ItemList;

end;

function TbjMstListImp.GetUnitPackedList: TStringList;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  CollName: string;
  uStr: string;
  UnitNode: IbjXml;
  UnitPList: TStringList;
begin
  UnitPList := TStringList.Create;
  xSVar := CreatebjXmlDocument;

  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  CollName := 'Unit';
  OResult := CreatebjXmlDocument;
  OResult.LoadXml(ColExEval(CollName, 'Unit', xSVar, xStr, xFormula));
  UnitNode := OResult.SearchforTag(nil, 'COLLECTION');
  UnitNode := OResult.SearchforTag(UnitNode, 'UNIT');
  while Assigned(UnitNode) do
  begin
    uStr :=  UnitNode.GetAttrValue('NAME');
    if Length(uStr) = 0 then
    begin
      UnitNode := OResult.SearchforTag(UnitNode, 'UNIT');
      continue;
    end;
    if ToPack then
        UnitPList.Add(PackStr(uStr))
    else
        UnitPList.Add(uStr);
    UnitNode := OResult.SearchforTag(UnitNode, 'UNIT');
  end;
  if UnitPList.Count > 0 then
  begin
    UnitPList.Sorted := True;
{   ShowMessage(Unitplist.text); }
  end;
  Result := UnitPList;

end;

function TbjMstListImp.GetItemGroupPackedList: TStringList;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  CollName: string;
  gStr: string;
  GroupNode: IbjXml;
  GrpPList: TStringList;
begin
  GrpPList := TStringList.Create;
  xSVar := CreatebjXmlDocument;
  CollName := 'STOCKGROUP';
  OResult := CreatebjXmlDocument;
  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  OResult.LoadXml(ColExEval(CollName, 'STOCKGROUP', xSVar, xStr, xFormula));
  GroupNode := OResult.SearchforTag(nil, 'COLLECTION');
  GroupNode := OResult.SearchforTag(GroupNode, 'STOCKGROUP');
  while Assigned(GroupNode) do
  begin
    gStr := GroupNode.GetAttrValue('NAME');
    if Length(gStr) = 0 then
      begin
      GroupNode := OResult.SearchforTag(GroupNode, 'STOCKGROUP');
      continue
    end;
      if ToPack then
        GrpPList.Add(PackStr(gStr))
      else
        GrpPList.Add(gStr);
    GroupNode := OResult.SearchforTag(GroupNode, 'STOCKGROUP');
    end;
  if GrpPList.Count > 0 then
  begin
    GrpPList.Sorted := True;
  end;
  Result := GrpPList;
{  ShowMessage(GrpPList.text); }
end;

function TbjMstListImp.GetCategoryPackedList: TStringList;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  CollName: string;
  cStr: string;
  CategoryNode: IbjXml;
  StkCatPList: TStringList;
begin
  StkCatPList := TStringList.Create;
  xSVar := CreatebjXmlDocument;
  CollName := 'STOCKCATEGORY';
  OResult := CreatebjXmlDocument;
  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  OResult.LoadXml(ColExEval(CollName, 'STOCKCATEGORY', xSVar, xStr, xFormula));
  CategoryNode := OResult.SearchforTag(nil, 'COLLECTION');
  CategoryNode := OResult.SearchforTag(CategoryNode, 'STOCKCATEGORY');
  while Assigned(CategoryNode) do
  begin
    cStr := CategoryNode.GetAttrValue('NAME');
    if Length(cStr) = 0 then
      begin
      CategoryNode := OResult.SearchforTag(CategoryNode, 'STOCKCATEGORY');
       continue;
    end;
      if ToPack then
        StkCatPList.Add(PackStr(cStr))
      else
        StkCatPList.Add(cStr);
    CategoryNode := OResult.SearchforTag(CategoryNode, 'STOCKCATEGORY');
    end;
  if StkCatPList.Count > 0 then
  begin
    StkCatPList.Sorted := True;
  end;
  Result := StkCatPList;
{  ShowMessage(StkCatplist.text); }
end;

function TbjMstListImp.GetGodownPackedList: TStringList;
var
  xSVar, xStr, xFormula: IbjXml;
  OResult: IbjXml;
  CollName: string;
  gStr: string;

  GodownNode: IbjXml;
  GdnPList: TStringList;
begin
  GdnPList := TStringList.Create;
  xSVar := CreatebjXmlDocument;
  CollName := 'GODOWN';
  OResult := CreatebjXmlDocument;
  xSVar.LoadXML('<STATICVARIABLES>'+
  '<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>'+
  '</STATICVARIABLES>');
  OResult.LoadXml(ColExEval(CollName, 'GODOWN', xSVar, xStr, xFormula));
  GodownNode := OResult.SearchforTag(nil, 'COLLECTION');
  GodownNode := OResult.SearchforTag(GodownNode, 'GODOWN');
  while Assigned(GodownNode) do
  begin
    gStr := GodownNode.GetAttrValue('NAME');
    if Length(gStr) = 0 then
      begin
      GodownNode := OResult.SearchforTag(GodownNode, 'GODOWN');
      Continue;
    end;
      if ToPack then
        GdnPList.Add(PackStr(gStr))
      else
        GdnPList.Add(gStr);
    GodownNode := OResult.SearchforTag(GodownNode, 'GODOWN');
    end;
  if GdnPList.Count > 0 then
  begin
    GdnPList.Sorted := True;
  end;
  Result := GdnPList;
{  ShowMessage(Gdnplist.text); }
end;

//procedure TbjMstList.GetItemText(var data:pchar; out size:integer);
function TbjMstListImp.GetItemText: string;
var
  ItemPList: TStringList;
begin
  ItemPList := GetItemPackedList;
  Result := ItemPList.Text;
  ItemPList.Free;
{  ShowMessage(Result); }
end;


end.

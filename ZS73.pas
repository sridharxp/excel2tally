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
unit ZS73;
  {
  Creation mode and Updation mode are the same for tally
  For Application vchid is created in Creation mode
  }

interface

uses
  SysUtils, Classes,
  Dialogs, Strutils,
  bjxml3_1,
  Client,
  license,
  MstListImp,
  Math,
  Controls,
  VchLib;

const
  { Simple Bill Software }
  appguid = 'f2e34b5e-467c-4021-a9a3-38bd5bc8c967';
  TallyAmtPicture = '############.##';
  TallyQtyPicture = '###########.###';

type
  TbjMstExp = class;

  TbjEnv = class
  private
    { Private declarations }
    FDomain: String;
    Fport: Integer;
    FHost: string;
    FGUID: string;
    FFirm: String;
    FDefaultGroup: string;
    FExportDependentMasters: boolean;
    FbjMstExp: TbjMstExp;
    FDefaultGSTState: string;
  protected
    { Protected declarations }
    FTLic: string;
    FEMac: string;
    FUSBID: string;
    Client: TbjClient;
    procedure SetFirm(const Name: string);
    procedure SetHost(const aHost: string);
    property ExportDependentMasters: boolean read FExportDependentMasters
      write FExportDependentMasters;
    procedure SetMst(aMst: TbjMstExp);
  public
    { Public declarations }
    FToUpdate: boolean;
    ToSaveXMLFile: boolean;
    ToUpdateMasters: boolean;
    TallyVersion: string;
    Error: string;
    constructor Create;
    destructor Destroy; override;
    function IsTLic(const authentication: string): boolean;
    procedure SetGUID(const ID: string);
    Procedure SetDefaultGroup(const aName: string);
  published
    { Published declarations }
    property Firm: String read FFirm write SetFirm;
    property GUID: String read FGUID write SetGUID;
    property Host: string  read FHost write SetHost;
    property DefaultGroup: string read FDefaultGroup write SetDefaultGroup;
    property ToUpdate: boolean read FToUpdate write FToUpdate;
    property bjMstExp: TbjMstExp read FbjMstExp write SetMst;
    property DefaultGSTState: string read FDefaultGSTState write FDefaultGSTState;
  end;

  TbjMstExp = class
  private
    { Private declarations }
    FVchType: string;
    FLedState: string;
    FAlias: string;
//    FLedgerGroup: string;
    FGroup: string;
    FGodown: string;
    FCategory: string;
    FbjEnv: TbjEnv;
  protected
    { Protected declarations }
    xLdg: IbjXml;
    xLed: IbjXml;
    xLedid: IbjXml;
    LedPList: TStringList;
    ItemPList: TStringList;
    LedGroupPList: TStringList;
    UnitPList: TStringList;
    ItemGroupPList: TStringList;
    CategoryPList: TStringList;
    GodownPList: TStringList;
//    ToSaveXMLFile: boolean;
    TallyVersion: string;
    Error: string;
    procedure XmlHeader(const tgt:string);
    procedure XmlFooter(const tgt:string);
    function CreateLedger(const Ledger, Parent: string; const OpBal: double ): boolean;
    function CreateParty(const Ledger, Parent, GSTN, State: string ): boolean;
    function CreateGST(const Ledger, Parent: string; Const TaxRate: string ): boolean;
    function CreateItem(const Item, BaseUnit: string; const OBal, ORate: double): boolean;
//    function CreateItem(const Item, BaseUnit: string; const OBal, ORate: double): boolean;
    function CreateUnit(const ItemUnit: string): boolean;
    function CreateItemGroup(const Grp, Parent: string): boolean;
    function CreateCategory(const aCategory, Parent: string): boolean;
    function CreateGodown(const Gdn, Parent: string): boolean;
    function IsItemGroup(const Grp: string): boolean;
    function IsCategory(const aCategory: string): boolean;
    function IsGodown(const Gdn: string): boolean;
    function  GetTallyReply: string;
    procedure CheckError;
//    function GetEnv: Tbjenv;
    procedure SetEnv(aEnv: TbjEnv);
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    function IsLedger(Const Ledger: string): boolean;
    procedure NewLedger(const aLedger, aParent: string; OpBal: double);
    procedure NewParty(const aLedger, aParent, aGSTN: string; aState: string = 'Tamil Nadu');
    procedure NewGST(const aLedger, aParent: string; const TaxRate: string);
    function GetHalfof(const TaxRate: string): string;
    function IsItem(const Item: string): boolean;
    procedure NewItem(const aItem, aBaseUnit: string; OpBal, ORate: double);
    function IsUnit(const aUnit: string): boolean;
    procedure NewUnit(const aUnit: string);
    procedure NewItemGroup(const aGrp, aParent: string);
    procedure NewCategory(const aCategory, aParent: string);
    procedure NewGodown(const aGdn, aParent: string);
    function LPost: string;
    procedure RefreshMstLists;
    procedure RefreshInvLists;
  published
    { Published declarations }
//    property Ledgerlias: string read FLedgerAlias write FLedgerAlias;
    property Alias: string read FAlias write FAlias;
//    property LedgerGroup: string read FLedgerGroup write FLedgerGroup;
    property VchType: string read FVchType write FVchType;
    property Group: string read FGroup write FGroup;
    property Godown: string read FGodown write FGodown;
    property Category: string read FCategory write FCategory;
    property LedState: string read FLedState write FLedState;
    property bjEnv: TbjEnv read FbjEnv write SetEnv;
  end;

  TbjVchExp = class
  private
    { Private declarations }
    FvchDate: string;
    FVchType: string;
    FVchNarration: string;
    FVchNo: string;
    FVchRef: string;
    FBillRef: string;
    FVchRefDate: string;
    FbjEnv: TbjEnv;
    FbjMstExp: TbjMStExp;
    Fvchid: string;
  protected
    { Protected declarations }
    Lines: TList;
    ILines: TList;
    GSTNLines: TList;
    partyidx: integer;
    partyamt: double;
    busidx: integer;
    busamt: double;
//    VChID: string;
    VchAction: string;
    xvou: IbjXml;
    xvch: IbjXml;
    xvchid: IbjXml;
    IsVchTypeMatched: Boolean;
    DrCrTotal: double;
    RefLedger: string;
//    ToSaveXMLFile: boolean;
    TallyVersion: string;
    Error: string;
    procedure GetVchType(const aName: string);
    procedure CheckVchType(const ledger; const Amount: double);
    procedure XmlHeader(const tgt:string);
//    procedure XmlHeader(const tgt:string);
    procedure XmlFooter(const tgt:string);
    procedure SetVchHeader;
    function Pack(const Ledger: string; const Amount: double; const Ref, RefType: string): double;
    procedure Unpack;
    procedure AttachInv(const rled: string);
    procedure AttachAssessable(const rled: string);
    procedure AddInDirect(const idx: integer);
    procedure CheckDefGroup;
    function  GetTallyReply: string;
    procedure CheckError;
//    function GetEnv: TbjEnv;
    procedure SetEnv(aEnv: TbjEnv);
//    function GetMst: TbjMstExp;
    procedure SetMst(aMst: TbjMstExp);
    procedure ClearLines;
    procedure SetVchID(const ID: string);
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
//    procedure GetVchHeader(const ID, Date, Name, Narration: string); overload;
//    procedure GetVchHeader(const ID: string); overload;
    function AddLine(const Ledger: string; const Amount: double): double;
    function AddLinewithRef(const Ledger: string; const Amount: double; const Ref, RefType: string): double;
    function SetAssessable(const aAmount: double): double;
    function SetInvLine(const Item: string; const Qty, Rate, Amount: double): double;
    function Post(const Action: string; wem: boolean): string;
  published
    { Published declarations }
    property VchID: string read FVchID write SetVchID;
    property vchDate: string read FVchDate write FVchDate;
    property VchType: string read FVchType write GetVchType;
    property VchNarration: string read FVchNarration write FVchNarration;
    property VchNo: string read FVchNo write FVchNo;
    property VchRef: string read FVchRef write FVchRef;
    property BillRef: string read FBillRef write FBillRef;
    property VchRefDate: string read FVchRefDate write FVchRefDate;
    property bjEnv: TbjEnv read FbjEnv write SetEnv;
    property bjMstExp: TbjMstExp read FbjMstExp write SetMst;
  end;

(*
type
  Tbjxmlupdate = class
  private
    { Private declarations }
//    FConnectionStatus: boolean;
//    FLedgerAlias: string;
  protected
    IsShareWare: boolean;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
  published
  end;
*)
  TLine = Record
    Ledger: string;
    Amount: double;
    Ref: string;
    RefType: string;
  end;
  PLine = ^Tline;

  TInvLine = Record
    Ledger: string;
    Item: string;
    Qty: double;
    Rate: double;
    Amount: double;
  end;
  PInvLine = ^TInvline;

  TGSTNLine = Record
    Ledger: string;
    Amount: double;
  end;
  pGSTNLine = ^TGSTNline;

{
threadvar
  bjEnv: TbjEnv;
  bjMstExp: TbjMstExp;
  bjVchExp: TbjVchExp;
}
implementation

Constructor TbjEnv.Create;
begin
//  Inherited;
  FDomain := '127.0.0.1';
  Fport := 9000;
  FHost := 'http://'+FDomain+':'+InttoStr(FPort);
  Client := TbjClient.Create;
  FExportDependentMasters := False;
  fGuID := appguid;
  FTLic := '711031608';
  ToSaveXMLFile := False;
  FToUpdate := False;
end;

destructor TbjEnv.Destroy;
begin
  Client.Free;
  inherited;
end;

Constructor TbjMstExp.Create;
begin
//  Inherited;
  xLed := CreatebjXmlDocument;
  xLedid := CreatebjXmlDocument;
//  xvchid := CreatebjXmlDocument;
//  if not Assigned(bjEnv) then
//    bjEnv := TbjEnv.Create;
end;

destructor TbjMstExp.Destroy;
begin
  xLed.Clear;
  xLedid.Clear;
  ItemPList.Free;
  UnitPList.Free;
  GodownPList.Free;
  ItemGroupPList.Free;
  CategoryPList.Free;
  LedPList.Free;
  LedGroupPList.Free;
  inherited;
end;

Constructor TbjVchExp.Create;
begin
//  Inherited;
  xvch := CreatebjXmlDocument;
  xvchid := CreatebjXmlDocument;
  Lines := TList.Create;
  ILines := TList.Create;
  GSTNLines := TList.Create;
{   DrCrTotal := 0;}
  partyidx := -1;
  busidx := -1;
{    partyamt := 0.0; }
//  if not Assigned(bjMstExp) then
//    bjMstExp := TbjMstExp.Create;
  randomize;
{ No Default Group;
  It should be defined by Callinf functions
  For simple usage, that is}
end;

destructor TbjVchExp.Destroy;
begin
  xvch.Clear;
  xvchid.Clear;
  ClearLines;
  ILines.Free;
  Lines.Free;
  GSTNLines.Free;
  inherited;
end;

(*
Constructor Tbjxmlupdate.Create;
begin
  Inherited;

{ For debugging }
{  FBatchMode := False;}

end;

destructor Tbjxmlupdate.Destroy;
begin
  inherited;
end;
*)
//For better exception handling removed
Procedure TbjMstExp.CheckError;
begin
  if bjEnv.Client.Response.Size = 0 then
      MessageDlg('Error Posting Data to Tally', mtError, [mbOK], 0);
end;

//For better exception handling removed
Procedure TbjVchExp.CheckError;
begin
  if bjEnv.Client.Response.Size = 0 then
      MessageDlg('Error Posting Data to Tally', mtError, [mbOK], 0);
end;

{
Create, Update logic is in VchUpdate.dpr
Low level funcntion should be Minimalist
}
function TbjMstExp.CreateLedger(const Ledger, Parent: string; const OpBal: double): boolean;
begin
{  Result := False; }
{
  If Length(Ledger) = 0 then
    Exit;
}
  xmlHeader('L');
  xLdg := xLdg.NewChild('TALLYMESSAGE','');

  xLdg := xLdg.NewChild('LEDGER','');
  xLdg.AddAttribute('NAME', ledger);
  xLdg.AddAttribute('ACTION','Create');
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', ledger );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  xLdg.NewChild2('PARENT', parent );
{  if OpBal > 0 then }
    xLdg.NewChild2('OPENINGBALANCE', FormatFloat(TallyAmtPicture, OpBal));
  { LEDGER }
  xLdg := xLdg.GetParent;

  { TALLYMESSAGE }
  xLdg := xLdg.GetParent;

  XMLFooter('L');
  LPost;

  Result := True;
end;

function TbjMstExp.CreateGST(const Ledger, Parent: string; const TaxRate: string): boolean;
var
  IsTax: boolean;
  percentage: string;
begin
{  Result := False; }
{
  If Length(Ledger) = 0 then
    Exit;
}
  IsTax := False;
  if Parent = 'Duties & Taxes' then
    IsTax := True;
  xmlHeader('L');
  xLdg := xLdg.NewChild('TALLYMESSAGE','');

  xLdg := xLdg.NewChild('LEDGER','');
  xLdg.AddAttribute('NAME', ledger);
  xLdg.AddAttribute('ACTION','Create');
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', ledger );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  xLdg.NewChild2('PARENT', parent );
  if IsTax then
  begin
  xLdg.NewChild2('TAXTYPE', 'GST' );
    if Pos('CGST', ledger) > 0 then
    begin
      xLdg.NewChild2('GSTDUTYHEAD', 'Central Tax');
      percentage := GetHalfof(TaxRate);
    end;
    if Pos('SGST', ledger) > 0 then
    begin
//      xLdg.NewChild2('GSTDUTYHEAD', 'State Tax');
      xLdg.NewChild2('GSTDUTYHEAD', 'UT Tax');
      percentage := GetHalfof(TaxRate);
    end;
    if Pos('IGST', ledger) > 0 then
    begin
      xLdg.NewChild2('GSTDUTYHEAD', 'Integrated Tax');
      percentage := TaxRate;
    end;
    xLdg.NewChild2('RATEOFTAXCALCULATION', percentage);
  end;
  if (not IsTax) and (Length(TaxRate) > 0) then
  begin
    xLdg.NewChild2('GSTAPPLICABLE', #4 +' Applicable' );
//    xLdg.NewChild2('TAXTYPE', 'Others' );
    xLdg.NewChild2('GSTTYPEOFSUPPLY', 'Goods');
    xLdg := xLdg.NewChild('GSTDETAILS.LIST', '');
    xLdg.NewChild2('APPLICABLEFROM', '20180701');
    xLdg.NewChild2('TAXABILITY', 'Taxable');
    if VchType = 'Sales' then
      xLdg.NewChild2('GSTNATUREOFTRANSACTION', 'Sales Taxable');
    if VchType = 'Purchase' then
      xLdg.NewChild2('GSTNATUREOFTRANSACTION', 'Purchase Taxable');
    xLdg := xLdg.NewChild('STATEWISEDETAILS.LIST', '');
    xLdg.NewChild2('STATENAME', #4 +' Any' );

    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'Central Tax');
    xLdg.NewChild2('GSTRATE', GetHalfof(TaxRate));
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;
(*
    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'State Tax');
    xLdg.NewChild2('GSTRATE', GetHalfof(TaxRate));
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;
*)
    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'UT Tax');
    xLdg.NewChild2('GSTRATE', GetHalfof(TaxRate));
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;

    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'Integrated Tax');
    xLdg.NewChild2('GSTRATE', TaxRate);
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;

(*
    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'Cess');
    xLdg.NewChild2('GSTRATE', '0');
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;
*)
  { STATEWISEDETAILS.LIST }
   xLdg := xLdg.GetParent;
  { GSTDETAILS.LIST }
  xLdg := xLdg.GetParent;
  end;
  { LEDGER }
  xLdg := xLdg.GetParent;

  { TALLYMESSAGE }
  xLdg := xLdg.GetParent;

  XMLFooter('L');
  LPost;

  Result := True;
end;

function TbjMstExp.CreateItemGroup(const Grp, Parent: string): boolean;
begin
{   Result := False; }
{
   If Length(Grp) = 0 then
    Exit;
}
  xmlHeader('L');
  xLdg := xLdg.NewChild('TALLYMESSAGE','');
  xLdg := xLdg.NewChild('STOCKGROUP','');
  xLdg.AddAttribute('NAME', Grp);
  xLdg.AddAttribute('ACTION','Create');
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', Grp );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  xLdg.NewChild2('PARENT', parent );
  { LEDGER }
  xLdg := xLdg.GetParent;

  { TALLYMESSAGE }
  xLdg := xLdg.GetParent;
  XMLFooter('L');
  LPost;
  Result := True;
end;

function TbjMstExp.CreateCategory(const aCategory, Parent: string): boolean;
begin
{  Result := False; }
{
  If Length(aCategory) = 0 then
    Exit;
}
  xmlHeader('L');
  xLdg := xLdg.NewChild('TALLYMESSAGE','');
  xLdg := xLdg.NewChild('STOCKCATEGORY','');
  xLdg.AddAttribute('NAME', aCategory);
  xLdg.AddAttribute('ACTION','Create');
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', aCategory );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  xLdg.NewChild2('PARENT', parent );
  { LEDGER }
  xLdg := xLdg.GetParent;

  { TALLYMESSAGE }
  xLdg := xLdg.GetParent;
  XMLFooter('L');
  LPost;
  Result := True;
end;

function TbjMstExp.CreateGodown(const Gdn, Parent: string): boolean;
begin
{  Result := False; }
{
  If Length(Gdn) = 0 then
    Exit;
}
  xmlHeader('L');
  xLdg := xLdg.NewChild('TALLYMESSAGE','');

  xLdg := xLdg.NewChild('GODOWN','');
  xLdg.AddAttribute('NAME', Gdn);
  xLdg.AddAttribute('ACTION','Create');
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', Gdn );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  xLdg.NewChild2('PARENT', parent );
  { LEDGER }
  xLdg := xLdg.GetParent;

  { TALLYMESSAGE }
  xLdg := xLdg.GetParent;

  XMLFooter('L');
  LPost;

  Result := True;
end;

function TbjMstExp.CreateParty(const Ledger, Parent, GSTN, State: string ): boolean;
begin
{  Result := False; }
{
  If Length(Ledger) = 0 then
    Exit;
}
  xmlHeader('L');
  xLdg := xLdg.NewChild('TALLYMESSAGE','');

  xLdg := xLdg.NewChild('LEDGER','');
  xLdg.AddAttribute('NAME', ledger);
  xLdg.AddAttribute('ACTION','Create');
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', ledger );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  xLdg.NewChild2('SALESTAXNUMBER', GSTN);
  xLdg.NewChild2('COUNTRYNAME', 'India');
  if Length(GSTN) > 0 then
    xLdg.NewChild2('GSTREGISTRATIONTYPE', 'Regular')
  else
    xLdg.NewChild2('GSTREGISTRATIONTYPE', 'Unregistered');
  xLdg.NewChild2('PARENT', parent );
  if Length(GSTN) > 0 then
    xLdg.NewChild2('PARTYGSTIN', GSTN);
//  xLdg.NewChild2('SERVICECATEGORY', '&#4; Not Applicable');
  xLdg.NewChild2('LEDSTATENAME', State);
  { LEDGER }
  xLdg := xLdg.GetParent;

  { TALLYMESSAGE }
  xLdg := xLdg.GetParent;

  XMLFooter('L');
  LPost;

  Result := True;
end;

function TbjMstExp.CreateItem(const Item, BaseUnit: string; const OBal, ORate: double): boolean;
begin
{  Result := False; }
{
  If Length(Item) = 0 then
    Exit;
}
  xmlHeader('L');
  xLdg := xLdg.NewChild('TALLYMESSAGE','');

  xLdg := xLdg.NewChild('STOCKITEM','');
  xLdg.AddAttribute('NAME', Item);
  xLdg.AddAttribute('ACTION','Create');
  If Length(Group) > 0 then
  xLdg.NewChild2('PARENT', Group );
  If Length(category) > 0 then
    xLdg.NewChild2('CATEGORY', Category );
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', Item );
  If Length(Alias) > 0 then
  xLdg.NewChild2('NAME', Alias );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  xLdg.NewChild2('BASEUNITS', BaseUnit );
  xLdg.NewChild2('OPENINGBALANCE', FormatFloat(TallyAmtPicture, OBal)+' '+BaseUnit);
  if ORate > 0 then
    xLdg.NewChild2('OPENINGRATE', FormatFloat(TallyAmtPicture,ORate)+'/'+BaseUnit);;
  If Length(Godown) > 0 then
  begin
  xLdg := xLdg.NewChild('BATCHALLOCATIONS.LIST','');
  xLdg.NewChild2('GODOWNNAME', Godown );
  xLdg.NewChild2('BATCHNAME', 'Primary Batch');
  xLdg.NewChild2('BATCHNAME', 'Primary Batch');
  xLdg.NewChild2('OPENINGBALANCE', FormatFloat(TallyAmtPicture, OBal)+' '+BaseUnit);
  { BATCHALLOCATIONS }
  xLdg := xLdg.GetParent;
  end;
  { STOCKITEM }
  xLdg := xLdg.GetParent;

  { TALLYMESSAGE }
  xLdg := xLdg.GetParent;

  XMLFooter('L');
  LPost;

  Result := True;
end;

function TbjMstExp.CreateUnit(const ItemUnit: string): boolean;
begin
{  Result := False; }
{
  If Length(ItemUnit) = 0 then
    Exit;
}
  xmlHeader('L');
  xLdg := xLdg.NewChild('TALLYMESSAGE','');

  xLdg := xLdg.NewChild('uNIT','');
  xLdg.AddAttribute('NAME', ItemUnit);
  xLdg.AddAttribute('RESERVEDNAME','');
  xLdg.NewChild2('NAME', ItemUnit );
  xLdg.NewChild2('ISSIMPLEUNIT', 'Yes' );

  { Unit }
  xLdg := xLdg.GetParent;

  { TALLYMESSAGE }
  xLdg := xLdg.GetParent;

  XMLFooter('L');
  LPost;

  Result := True;
end;

{
  Since Ledger List is sorted;
  Parent List if created would not be in sync
  parent parameter may still be needed for correctness
  function Tbjxmlupdate.LedgerExists(var Ledger, Parent: string): boolean;
}
function TbjMstExp.IsLedger(const Ledger: string): boolean;
var
  Ledobj: TbjMstListImp;
  index: integer;
//  Date: pointer;
begin
{  Result := False; }
  if not Assigned(LedPList) then
  begin
    ledObj := TbjMstListImp.Create;
    LedObj.Host := bjEnv.Host;
    try
      LedPList := LedObj.GetLedPackedList;
    finally
      ledobj.Free;
    end;
  end;
  Result := LedPList.Find( PackStr(Ledger), index );
{ Idea to return existing ledger does not work as it is already packed }
//    Ledger := LedPList.Strings[Index];
end;

function TbjMstExp.IsItem(const Item: string): boolean;
var
  Ledobj: TbjMstListImp;
  index: integer;
begin
{  Result := False; }
  if not Assigned(ItemPList) then
  begin
    ledObj := TbjMstListImp.Create;
    LedObj.Host := bjEnv.Host;
    try
      ItemPList := LedObj.GetItemPackedList;
    finally
      ledobj.Free;
    end;
  end;
  Result := ItemPList.Find( PackStr(Item), index );
end;

function TbjMstExp.IsUnit(const aUnit: string): boolean;
var
  Ledobj: TbjMstListImp;
  index: integer;
begin
{  Result := False; }
  if not Assigned(UnitPList) then
  begin
    ledObj := TbjMstListimp.Create;
    LedObj.Host := bjEnv.Host;
    try
      UnitPList := LedObj.GetUnitPackedList;
    finally
      ledobj.Free;
    end;
  end;
  Result := UnitPList.Find( PackStr(aUnit), index );
end;

function TbjMstExp.IsItemGroup(const Grp: string): boolean;
var
  Ledobj: TbjMstListImp;
  index: integer;
begin
{  Result := False; }
  if not Assigned(ItemGroupPList) then
  begin
    ledObj := TbjMstListImp.Create;
    LedObj.Host := bjEnv.Host;
    try
      ItemGroupPList := LedObj.GetItemGroupPackedList;
    finally
      ledobj.Free;
    end;
  end;
  Result := ItemGroupPList.Find( PackStr(Grp), index );
end;

function TbjMstExp.IsCategory(const aCategory: string): boolean;
var
  Ledobj: TbjMstListImp;
  index: integer;
begin
{  Result := False; }
  if not Assigned(CategoryPList) then
  begin
    ledObj := TbjMstListImp.Create;
    LedObj.Host := bjEnv.Host;
    try
      CategoryPList := LedObj.GetCategoryPACKEDList;;
    finally
      ledobj.Free;
    end;
  end;
  Result := CategoryPList.Find( PackStr(aCategory), index );
end;

function TbjMstExp.IsGodown(const Gdn: string): boolean;
var
  Ledobj: TbjMstListImp;
  index: integer;
begin
{  Result := False; }
  if not Assigned(GodownPList) then
  begin
    ledObj := TbjMstListImp.Create;
    LedObj.Host := bjEnv.Host;
    try
      GodownPList := LedObj.GetGodownPackedList;
    finally
      ledobj.Free;
    end;
  end;
  Result := GodownPList.Find( PackStr(Gdn), index );
end;

Procedure TbjMstExp.XmlHeader(const tgt:string);
begin
  if tgt = 'L' then
  begin
    xLed.Clear;
    xLdg := xLed.NewChild('ENVELOPE','');
    xLdg := xLdg.NewChild('HEADER','');
    xLdg.NewChild2('TALLYREQUEST','Import Data');
    xLdg := xLdg.GetParent;
    xLdg := xLdg.NewChild('BODY','');
    xLdg := xLdg.NewChild('IMPORTDATA','');
    xLdg := xLdg.NewChild('REQUESTDESC','');
    xLdg.NewChild2('REPORTNAME', 'All Masters');
    xLdg := xLdg.NewChild('STATICVARIABLES','');
    xLdg.NewChild2('SVEXPORTFORMAT', '$$SysName:XML');
    if length(bjEnv.FFirm) > 0 then
    begin
      xLdg.NewChild2('SVCURRENTCOMPANY',bjEnv.Firm);
    end;
  { STATICVARIABLES }
      xLdg := xLdg.GetParent;
  { REQUESTDESC }
    xLdg := xLdg.GetParent;
    xLdg := xLdg.NewChild('REQUESTDATA','');
  end;
end;

Procedure TbjVchExp.XmlHeader(const tgt:string);
begin
  if tgt = 'V' then
  begin
    xvch.Clear;
    xvou := xVch.NewChild('ENVELOPE','');
    xvou := xvou.NewChild('HEADER','');
    xvou.NewChild2('TALLYREQUEST','Import Data');
    xVou := xVou.GetParent;
    xvou := xvou.NewChild('BODY','');
    xvou := xvou.NewChild('IMPORTDATA','');
    xvou := xvou.NewChild('REQUESTDESC','');
    xvou.NewChild2('REPORTNAME', 'All Masters');
    xvou := xvou.NewChild('STATICVARIABLES','');
    xvou.NewChild2('SVEXPORTFORMAT', '$$SysName:XML');
    if length(bjEnv.FFirm) > 0 then
    begin
      xvou.NewChild2('SVCURRENTCOMPANY',bjEnv.Firm);
      
    end;
  { STATICVARIABLES }
      xVou := xVou.GetParent;
  { REQUESTDESC }
    xvou := xvou.GetParent;
    xvou := xvou.NewChild('REQUESTDATA','');
  end;
end;

{
 Daybook order
 id, Type, Action, date, id, narration, type, alterid,
}
procedure TbjVchExp.SetVchHeader;
var
  sid: string;
begin
  xmlHeader('V');

    sid := bjEnv.GUID+'-'+ RightStr('00000000' +
      vchid, 8);

  xvou := xvou.NewChild('TALLYMESSAGE','');
  xvou := xvou.NewChild('VOUCHER','');
  xvou.AddAttribute('REMOTEID', sid);
  xvou.AddAttribute('VCHTYPE', vchType);
  xvou.AddAttribute('ACTION', vchAction);
  xvou.NewChild2('DATE',vchDate);
  if Length(VchRefDate) > 0 then
  begin
    xvou.NewChild2('REFERENCEDATE',VchRefDate);
    VchRefDate := '';
  end
  else
  xvou.NewChild2('REFERENCEDATE',vchDate);
{ GuId is important to track vouchers }
  xvou.NewChild2('GUID',sid);
  if Length(VChNarration) > 0 then
  begin
    xvou.NewChild2('NARRATION',VchNarration);
    VchNarration := '';
  end;
  xvou.NewChild2('VOUCHERTYPENAME',VchType);
  if Length(VchNo) > 0 then
  begin
    xvou.NewChild2('VOUCHERNUMBER',VchNo);
    VchNo := '';
  end;
  if (VchType = 'Purchase')  or (VchType = 'Sales') then
  begin
{    xvou.NewChild2('PERSISTEDVIEW','Invoice Voucher View'); }
    xvou.NewChild2('ISINVOICE','Yes');
  end;
  if Length(VchRef) > 0 then
  begin
    xvou.NewChild2('REFERENCE',VchRef);
    VchRef := '';
  end
  else
    xvou.NewChild2('REFERENCE',VchNo);
{ Effective Date is crucial; Without which dll crashes }
  xvou.NewChild2('EFFECTIVEDATE',vchDate);
  IsVchTypeMatched := False;
  DrCrTotal := 0;
end;
{
procedure TbjVchExp.GetVchHeader(const ID, Date, Name, Narration: string);
begin
  if length(id) = 0 then
    Fvchid := InttoStr(random(100000000))
  else
    Fvchid := id;
  VchDate := Date;
  GetVchType(Name);
  VchNarration := Narration;
end;

procedure TbjVchExp.GetVchHeader(const ID: string);
begin
  if length(id) = 0 then
    Fvchid := InttoStr(random(100000000))
  else
    Fvchid := id;
end;
}
procedure TbjVchExp.SetVchID(const ID: string);
begin
  if length(id) = 0 then
    Fvchid := InttoStr(random(100000000))
  else
    Fvchid := id;
end;

procedure TbjVchExp.GetVchType(const aName: string);
begin
   FVchType := aName;
  if (PackStr(aName) <> Packstr('Receipt')) and
  (PackStr(aName) <> PackStr('Payment')) and
  (PackStr(aName) <> PackStr('Sales')) and
  (PackStr(aName) <> PackStr('Sales Order')) and
  (PackStr(aName) <> PackStr('Purchase')) and
  (PackStr(aName) <> PackStr('Purchase Order')) and
  (PackStr(aName) <> PackStr('Journal')) and
  (PackStr(aName) <> PackStr('Contra')) and
  (PackStr(aName) <> PackStr('Debit Note')) and
  (PackStr(aName) <> PackStr('Credit Note')) and
  (PackStr(aName) <> PackStr('Memorandum')) and
  (PackStr(aName) <> PackStr('Reversing Journal')) and
  (PackStr(aName) <> PackStr('Stock Journal')) then
  begin
   FVchType := 'Journal';
  end;
end;

Procedure TbjMstExp.XmlFooter(const tgt:string);
begin
  if tgt = 'L' then
  begin
{ REQUESTDATA }
    xLdg := xLdg.GetParent;
{ IMPORTDATA }
    xLdg := xLdg.GetParent;
{ BODY }
    xLdg := xLdg.GetParent;
{ ENVELOPE }
    xLdg := xLdg.GetParent;
  end;
end;

Procedure TbjVchExp.XmlFooter(const tgt:string);
begin
  if tgt = 'V' then
  begin
{ REQUESTDATA }
    xVou := xVou.GetParent;
{ IMPORTDATA }
    xVou := xVou.GetParent;
{ BODY }
    xVou := xVou.GetParent;
{ ENVELOPE }
    xVou := xVou.GetParent;
  end;
end;

procedure TbjVchExp.CheckVchType(const Ledger; const Amount: double);
begin
  IsVchTypeMatched := True;
  if  (VchType = 'Receipt') then
    if Amount <= 0 then
      IsVchTypeMatched := False;
  if  (VchType = 'Payment') then
    if Amount >= 0 then
      IsVchTypeMatched := False;
  if  (VchType = 'Sales') then
    if Amount >= 0 then
      IsVchTypeMatched := False;
  if  (VchType = 'Purchase') then
    if Amount <= 0 then
      IsVchTypeMatched := False;
  if  (VchType = 'Journal') then
    if Amount >= 0 then
      IsVchTypeMatched := False;
  if  (VchType = 'Contra') then
    if Amount <= 0 then
      IsVchTypeMatched := False;
end;

function TbjVchExp.AddLine(const Ledger: string; const Amount: double): double;
begin
//  CheckVchType(Ledger, Amount);
//  cAmt := Pack(Ledger, Amount,'','');
  Pack(Ledger, Amount,'','');
{
  if IsVchTypeMatched then
  begin
    if partyamt = 0 then
    begin
      partyamt := Abs(cAmt);
      partyidx := Lines.Count-1;
    end
    else
    if Abs(cAmt) > partyamt then
    begin
      partyamt := Abs(cAmt);
      partyidx := Lines.Count-1;
    end;
  end
  else
  begin
    if busamt = 0 then
    begin
      Busamt := Abs(cAmt);
      busidx := Lines.Count-1;
    end
    else
    if Lines.Count-1 <> partyidx then
    if Abs(cAmt) > busamt then
    begin
      busamt := Abs(cAmt);
      busidx := Lines.Count-1;
    end;
  end;
}
  DrCrTotal := DrCrTotal + amount;
  RefLedger := Ledger;
  Result := DrCrTotal;
end;

function TbjVchExp.SetInvLine(const Item: string; const Qty, Rate, Amount: double): double;
var
  pline: pInvLine;
begin
  Result := 0;
   If length(RefLedger) = 0 then
     Exit;
  pline := new(pInvLine);
  pline^.Ledger :=  RefLedger;
  pline^.Item :=  Item;

//  if Length(Item) > 0 then
  pline^.Qty :=  Qty;
  pline^.Rate :=  Rate;
  pline^.Amount :=  Amount;
  ILines.Add(pline);
  Result := Amount;
end;

function TbjVchExp.SetAssessable(const aAmount: double): double;
var
  pline: pGSTNLine;
begin
  Result := 0;
   If length(RefLedger) = 0 then
     Exit;
  pline := new(pGSTNLine);

  pline^.Ledger :=  RefLedger;
  pline^.Amount :=  aAmount;
  GSTNLines.Add(pline);
  Result := aAmount;
end;

{ Ro combine repeat Ledger Entries }
//procedure Tbjxmlupdate.Pack(const Ledger: string; const Amount: double; const Ref, RefType: string);
function TbjVchExp.Pack(const Ledger: string; const Amount: double; const Ref, RefType: string): double;
var
  item: pLine;
  step: integer;
begin
  for Step := 1 to Lines.Count do
  begin
    Item := Lines.Items[Step - 1];
    if (Item^.Ledger = Ledger) and
      (Item^.Ref = Ref) and
      (Item^.RefType = RefType) then
    begin
      Item^. Amount := Item^. Amount + Amount;
      Result := Item^. Amount;
      Exit;
    end;
  end;
  Item := new(pLine);
  Item^.Ledger :=  Ledger;

  Item^.Amount :=  Amount;
//  if Length(Ref) > 0 then
  Item^.Ref :=  Ref;
//  if Length(RefType) > 0 then
  Item^.RefType :=  RefType;
  Lines.Add(Item);
  Result := Amount;
end;

{ To push largest (Cr or Dr) entries to the top of the voucher }
Procedure TbjVchExp.UnPack;
var
  Item: pLine;
  i: Integer;
begin
  for i := 0 to Lines.Count-1 do
  begin
    Item := Lines.Items[i];
    CheckVchType(Item^.Ledger, Item^.Amount);
    if IsVchTypeMatched then
    begin
      if Abs(Item^.Amount) > partyamt then
      begin
        partyamt := Abs(Item^.Amount);
        partyidx := i;
        Item^.Ref := BillRef;
        Item^.RefType := 'New Ref';
      end;
    end
  end;
  for i := 0 to Lines.Count-1 do
  begin
    Item := Lines.Items[i];
    if i <> partyidx then
    if Abs(Item^.Amount) > busamt then
    begin
      busamt := Abs(Item^.Amount);
      busidx := i;
    end;
  end;
  if Lines.Count > 0 then
  begin
    if partyidx <> -1 then
    begin
      AddInDirect(partyidx);
    end;
    if busidx <> -1 then
    begin
      AddInDirect(busidx);
    end;
    for i:= 0 to Lines.count-1 do
    begin
      if i = partyidx then
        continue;
      if i = busidx then
        continue;
      AddInDirect(i);
    end;
    IsVchTypeMatched := True;
  end;
  ClearLines;
  partyidx := -1;
  partyamt := 0;
  busidx := -1;
  busamt := 0;
end;

procedure TbjVchExp.ClearLines;
var
  i: Integer;
  lItem: PLine;
  iItem: PInvLine;
  gItem: pGSTNLine;
begin
  for i:= 0 to Lines.Count-1 do
  begin
    litem := Lines.Items[i];
    lItem.Ledger := '';
    lItem.Ref := '';
    lItem.RefType := '';
    Dispose(lItem);
  end;
  Lines.Clear;
  for i:= 0 to ILines.Count-1 do
  begin
    iitem := iLines.Items[i];
    iItem.Ledger := '';
    iItem.Item := '';
    Dispose(iItem);
  end;
  ILines.Clear;
  for i:= 0 to GSTNLines.Count-1 do
  begin
    gitem := GSTNLines.Items[i];
    gItem.Ledger := '';
    Dispose(gItem);
  end;
  GSTNLines.Clear;
end;

procedure TbjVchExp.AddInDirect(const idx: integer);
begin
  xvou := xvou.NewChild('ALLLEDGERENTRIES.LIST','');
  if (pLine(Lines.Items[idx])^.Amount < 0) then
    xvou.NewChild2('ISDEEMEDPOSITIVE','Yes')
  else
    xvou.NewChild2('ISDEEMEDPOSITIVE','No');
    xvou.NewChild2('LEDGERNAME', pLine(Lines.Items[idx])^.Ledger);
    xvou.NewChild2('AMOUNT', FormatFloat(TallyAmtPicture,
    pLine(Lines.Items[idx])^.Amount));

  if Length(pLine(Lines.Items[idx])^.Ref) > 0 then
  begin
    xvou := xvou.NewChild('BILLALLOCATIONS.LIST','');
    xvou.NewChild2('NAME', pLine(Lines.Items[idx])^.Ref);
    xvou.NewChild2('BILLTYPE', pLine(Lines.Items[idx])^.Reftype);
    xvou.NewChild2('AMOUNT', FormatFloat(TallyAmtPicture, pLine(Lines.Items[idx])^.Amount));
  { BILLALLOCATIONS.LIST }
    xVou := xVou.GetParent;
  end;
    { ALLLEDGERENTRIES.LIST }
  AttachAssessable(pLine(Lines.Items[idx])^.Ledger);
  AttachInv(pLine(Lines.Items[idx])^.Ledger);
  xVou := xVou.GetParent;
end;

procedure TbjVchExp.AttachInv(const rled: string);
var
  idx: integer;
begin
  if ILines.Count > 0 then
  for idx := 0 to ilines.Count-1 do
  begin
    if pInvLine(iLines.Items[idx])^.Ledger <> rled then
      Continue;
    xvou := xvou.NewChild('INVENTORYALLOCATIONS.LIST', '');
    if pInvLine(iLines.Items[idx])^.Amount < 0 then
      xvou.NewChild2('ISDEEMEDPOSITIVE', 'Yes')
    else
      xvou.NewChild2('ISDEEMEDPOSITIVE', 'No');
      xvou.NewChild2('STOCKITEMNAME', pInvLine(iLines.Items[idx])^.Item);
      xvou.NewChild2('AMOUNT', FormatFloat(TallyAmtPicture, pInvLine(iLines.Items[idx])^.Amount));
      xvou.NewChild2('ACTUALQTY', FormatFloat(TallyQtyPicture, pInvLine(iLines.Items[idx])^.Qty));
      xvou.NewChild2('BILLEDQTY', FormatFloat(TallyQtyPicture, pInvLine(iLines.Items[idx])^.Qty));
      xvou.NewChild2('RATE', FormatFloat(TallyAmtPicture, pInvLine(iLines.Items[idx])^.Rate));
      xvou.NewChild2('GODOWNNAME', 'Main Location');
    { INVENTORYALLOCATIONS.LIST }
      xvou := xvou.GetParent;
  end;
end;

procedure TbjVchExp.AttachAssessable(const rled: string);
var
  idx: integer;
begin
  for idx := 0 to GSTNlines.Count-1 do
  begin
    if pGSTNLine(GSTNLines.Items[idx])^.Ledger <> rled then
      Continue;
    xvou.NewChild2('VATASSESSABLEVALUE', FormatFloat(TallyAmtPicture, pGSTNLine(GSTNLines.Items[idx])^.aMOUNT));
  end;
end;

function TbjVchExp.AddLinewithRef(const Ledger: string; const Amount: double; const Ref, RefType: string): double;
begin
//  CheckVchType(Ledger, Amount);
  Pack(Ledger, Amount, Ref, RefType);
{
  if IsVchTypeMatched then
  begin
    if partyamt = 0 then
    begin
      partyamt := Abs(Amount);
      partyidx := Lines.Count;
    end
    else
    if Abs(Amount) > partyamt then
    begin
      partyamt := Abs(Amount);
      partyidx := Lines.Count;
    end;
  end
  else
  begin
    if busamt = 0 then
    begin
      busamt := Abs(Amount);
      busidx := Lines.Count;
    end
    else
    if Abs(Amount) > busamt then
    begin
      busamt := Abs(Amount);
      busidx := Lines.Count;
    end;
  end;
}
  DrCrTotal := DrCrTotal + amount;
  Result := DrCrTotal;
end;

function TbjMstExp.LPost: string;
begin
  bjEnv.Client.Host := bjEnv.Host;
  bjEnv.Client.xmlRequestString :=  xLdg.GetXml;
{ To debug }
//  MessageDlg(xLDG.GetXML, mtInformation, [mbOK], 0);
  if bjEnv.ToSaveXmlFile then
    xLdg.SaveXmlFile('Ledger.xml');
  bjEnv.Client.post;
  Result := GetTallyReply;

  Error := Result;

  CheckError;
{  xvch.Clear;}
  xLed.Clear;
end;

function TbjVchExp.Post(const Action: string; wem: boolean): string;
var
  Tallyid: IbjXml;
  LErr: string;
  Tid: string;
begin
  if (vchAction <> 'Create') and
    (vchAction <> 'Alter') and
    (VchAction <> 'Delete') then
  VchAction := 'Create';
  SetVchHeader;
  CheckDefGroup;
  unpack;
  xmlFooter('V');
  bjEnv.Client.Host :=  bjEnv.Host;
  bjEnv.Client.xmlRequestString :=  xvch.GetXml;
{ For debugging }
  if bjEnv.ToSaveXmlFile then
    xvch.SaveXmlFile('Voucher.xml');
{ For debugging }
//  MessageDlg(xvch.GetXML, mtInformation, [mbOK], 0);
  bjEnv.Client.post;

  xvchid.Clear;
  xvchid.LoadXml(bjEnv.Client.GetxmlResponseString);
//  MessageDlg(xvchID.GetXML, mtInformation, [mbOK], 0);
  if bjEnv.ToSaveXmlFile then
    xvchid.SaveXmlFile('Tally.xml');

  Tallyid := xvchid.SearchForTag(nil, 'LASTVCHID');
  if Assigned(Tallyid) then
  begin
    tid := TallyId.GetContent;
{ If this Visual feedback is not required then set ToUpdate to false }
    Result := TId;
    if bjEnv.ToUpdate then
      MessageDlg(Tid, mtInformation, [mbOK], 0);
  end;

  if wem then
  begin
  Tallyid := xvchid.SearchForTag(nil, 'LINEERROR');
  if Assigned(Tallyid) then
      LErr := TallyId.GetContent;
  if Length(LErr) > 0 then
     Result := Lerr;
  end;

//Dll Function should be simple to use, So no debug info
  CheckError;
  xvch.Clear;
end;

procedure TbjVchExp.CheckDefGroup;
var
  i: integer;
  StrLedger: string;
begin
{
  if Length(bjEnv.DefaultGroup) = 0 then
    exit;
}
  if not Assigned(bjMstExp) then
    Exit;
  for i := 0 to Lines.Count-1 do
  begin
    StrLedger := pLine(Lines.Items[i])^.Ledger;
//    if not LedgerExists(StrLedger) then
//      CreateLedger(StrLedger, DefaultGroup, 0);
      bjMstExp.NewLedger(StrLedger, bjEnv.DefaultGroup, 0);
  end;
end;

function TbjMstExp.GetTallyReply: string;
var
  Tallyid: IbjXml;
begin
    xLedid.Clear;
    xLedid.LoadXml(bjEnv.Client.GetxmlResponseString);

    Tallyid := xLedid.SearchForTag(nil, 'CREATED');
    if Assigned(Tallyid) then
      Result := TallyId.GetContent;

    Tallyid := xLedid.SearchForTag(nil, 'ALTERED');
    if Assigned(Tallyid) then
      Result := TallyId.GetContent;
end;


function TbjVchExp.GetTallyReply: string;
var
  Tallyid: IbjXml;
begin
//    xLedid.Clear;
//    xLedid.LoadXml(bjEnv.Client.GetxmlResponseString);

    Tallyid := xvchid.SearchForTag(nil, 'CREATED');
    if Assigned(Tallyid) then
      Result := TallyId.GetContent;

    Tallyid := xvchid.SearchForTag(nil, 'ALTERED');
    if Assigned(Tallyid) then
      Result := TallyId.GetContent;
end;

{ Vissual Feedback has nothing to do with checking Tally Serial No }
function TbjEnv.IsTLic(const authentication: string): boolean;
var
  obj: Tbjxmllicense;
begin
  FTlIC := authentication;
  Result := False;
  obj := Tbjxmllicense.Create;
  try
    if FTLic = obj.GetLicenseNo then
    begin
      Result := True;
    end;  
  finally
    obj.Free;
  end;
end;

Procedure TbjEnv.SetDefaultGroup(const aName: string);
begin
  FDefaultGroup := aName;
end;


Procedure TbjEnv.SetGUID(const ID: string);
begin
  if Length(id) = 36 then
    FGuid := ID;
end;


Procedure TbjEnv.SetFirm(const Name: string);
begin
  if FFirm = Name then
    exit;
  if Assigned(bjMstExp) then
    bjMstExp.RefreshMstLists;
  FFirm := Name;
end;

Procedure TbjEnv.SetHost(const aHost: string);
begin
  FHost := aHost;
end;


procedure TbjMstExp.RefreshMstLists;
var
  Ledobj: TbjMstListImp;
begin
  LedPList.Free;
  ItemPlist.Free;
  UnitPList.Free;
  ledObj := TbjMstListImp.Create;
  LedObj.Host := bjEnv.Host;
  try
    LedPList := LedObj.GetLedPackedList;
    ItemPList := LedObj.GetItemPackedList;
    UnitPList := LedObj.GetUnitPackedList;
  finally
    ledobj.Free;
  end;
end;

procedure TbjMstExp.RefreshInvLists;
var
  Ledobj: TbjMstListImp;
begin
  UnitPList.Free;
  ItemPList.Free;
  ItemGroupPList.Free;
  CategoryPList.Free;
  GodownPList.Free;
  ledObj := TbjMstListImp.Create;
  LedObj.Host := bjEnv.Host;
  try
    UnitPList :=  LedObj.GetUnitPackedList;
    ItemPList := LedObj.GetItemPackedList;
    ItemGroupPList := LedObj.GetItemGroupPackedList;
    CategoryPList := Ledobj.GetCategoryPackedList;
    GodownPList := LedObj.GetGodownPackedList;
  finally
    ledobj.Free;
  end;
end;

procedure TbjMstExp.NewLedger(const aLedger, aParent: string; OpBal: double);
var
  Found: boolean;
begin
{  Found := False; }
  If Length(aLedger) = 0 then
    Exit;
  If Length(aParent) = 0 then
    Exit;
  Found := IsLedger(aLedger);
  if Found then
    if bjEnv.ToUpdateMasters then
      CreateLedger(aLedger, aParent, OpBal);
  if not Found then
  begin
    CreateLedger(aLedger, aParent, OpBal);
    LedPList.Add(PackStr(aLedger));
  end;
end;

procedure TbjMstExp.NewItem(const aItem, aBaseUnit: string; OpBal, ORate: double);
var
  Found: boolean;
begin
  If Length(aItem) = 0 then
    Exit;
  If Length(aBaseUnit) = 0 then
    Exit;
  Found := IsItem(aItem);
  if Found then
    if bjEnv.ToUpdateMasters then
      CreateItem(aItem, aBaseUnit, OpBal, ORate);
  if not found then
  begin
    CreateItem(aItem, aBaseUnit, OpBal, ORate);
    ItemPList.Add(PackStr(aItem));
  end;
end;

procedure TbjMstExp.NewUnit(const aUnit: string);
var
  Found: boolean;
begin
  If Length(aUnit) = 0 then
    Exit;
  Found := IsUnit(aUnit);
  if Found then
    if bjEnv.ToUpdateMasters then
      CreateUnit(aUnit);
  if not found then
  begin
    CreateUnit(aUnit);
    UnitPList.Add(PackStr(aUnit));
  end;
end;

procedure TbjMstExp.NewItemGroup(const aGrp, aParent: string);
var
  Found: boolean;
begin
   If Length(aGrp) = 0 then
    Exit;
  Found := IsItemGroup(aGrp);
  if Found then
    if bjEnv.ToUpdateMasters then
      CreateItemGroup(aGrp, aParent);
  if not found then
  begin
      CreateItemGroup(aGrp, aParent);
    ItemGroupPList.Add(PackStr(aGrp));
  end;
end;

procedure TbjMstExp.NewCategory(const aCategory, aParent: string);
var
  Found: boolean;
begin
  If Length(aCategory) = 0 then
    Exit;
  Found := IsCategory(aCategory);
  if Found then
    if bjEnv.ToUpdateMasters then
      CreateCategory(aCategory, aParent);
  if not found then
  begin
      CreateCategory(aCategory, aParent);
    CategoryPList.Add(PackStr(aCategory));
  end;
end;

procedure TbjMstExp.NewGodown(const aGdn, aParent: string);
var
  Found: boolean;
begin
  If Length(aGdn) = 0 then
    Exit;
  Found := IsGodown(aGdn);
  if Found then
    if bjEnv.ToUpdateMasters then
      CreateGodown(aGdn, aParent);
  if not found then
  begin
    CreateGodown(aGdn, aParent);
    GodownPList.Add(PackStr(aGdn));
  end;
end;

procedure TbjMstExp.NewParty(const aLedger, aParent, aGSTN: string; aState: string = 'Tamil Nadu');
var
  Found: boolean;
begin
  If Length(aLedger) = 0 then
    Exit;
  Found := IsLedger(aLedger);
  if Length(aState) = 0 then
    aState := bjEnv.DefaultGSTState;
  if Length(aState) = 0 then
    aState := 'Tamil Nadu';
  if not Found then
  begin
     CreateParty(aLedger, aParent, aGSTN, aState);
     LedPList.Add(PackStr(aLedger));
  end;
end;

procedure TbjMstExp.NewGST(const aLedger, aParent: string; const TaxRate: string);
var
  Found: boolean;
begin
  If Length(aLedger) = 0 then
    Exit;
  Found := IsLedger(aLedger);
  if not Found then
  begin
     CreateGST(aLedger, aParent, TaxRate);
     LedPList.Add(PackStr(aLedger));
  end;
end;

function TbjMstExp.GetHalfof(const TaxRate: string): string;
begin
  if TaxRate = '28' then
    Result := '14';
  if TaxRate = '18' then
    Result := '9';
  if TaxRate = '12' then
    Result := '6';
  if TaxRate = '5' then
    Result := '2.5';
end;

{
function TbjVch.GeMst: TbjMst;
begin
Result := bjMsExpt;
end;
function TbjMstExp.GetEnv: TbjEnv;
begin
Result := bjEnv;
end;

function TbjVch.GetEnv: TbjEnv;
begin
Result := bjEnv;
end;
function TbjVch.GeMst: TbjMst;
begin
Result := bjMsExpt;
end;
}

procedure TbjMstExp.SetEnv(aEnv: TbjEnv);
begin
  FbjEnv := aEnv;
// if Assigned(aEnv) then
//  aEnv.bjMstExp := Self;
end;

procedure TbjVchExp.SetEnv(aEnv: TbjEnv);
begin
  FbjEnv := aEnv;
end;

procedure TbjVchExp.SetMst(aMst: TbjMstExp);
begin
  FbjMstExp := aMst;
end;

procedure TbjEnv.SetMst(aMst: TbjMstExp);
begin
  FbjMstExp := aMst;
end;
{
procedure Register;
begin
  RegisterComponents('Samples', [TbjEnv]);
  RegisterComponents('Samples', [TbjMstExp]);
  RegisterComponents('Samples', [TbjVchExp]);
end;
}

{
initialization
begin
  if not Assigned(bjEnv) then
  begin
    bjEnv := TbjEnv.Create;
  end;
  if not Assigned(bjMstExp) then
  begin
    bjMstExp := TbjMstExp.Create;
    bjMstExp.bjEnv := bjEnv;
  end;
  if not Assigned(bjVchExp) then
  begin
    bjVchExp := TbjVchExp.Create;
    bjVchExp.bjEnv := bjEnv;
    bjVchExp.bjMstExp := bjMstExp;
  end;
end;
finalization
begin
  bjVchExp.Free;
  bjMstExp.Free;
  bjEnv.Free;
end;
}
end.

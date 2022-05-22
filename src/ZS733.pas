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
unit ZS733;
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
  Repet,
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

  GSTNRec = Record
    Name: string;
    GSTN: string;
    State: string;
    _Name: string;
  end;
  pGSTNRec = ^GSTNRec;

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
    FMstExp: TbjMstExp;
    FDefaultGSTState: string;
    FIsPostto1stLedgerwithGSTNon: boolean;
    FIsUniqueVchRefon: boolean;
    FGSTLedType: string;
    FLastAction: string;
    Fvch_Date: string;
  protected
    { Protected declarations }
    FTLic: string;
    FEMac: string;
    FUSBID: string;
    Client: TbjClient;
    ip: TStringList;
    op: TStringList;
    ActionStrs: array [1..5] of string;
    procedure SetFirm(const Name: string);
    procedure SetHost(const aHost: string);
    property ExportDependentMasters: boolean read FExportDependentMasters
      write FExportDependentMasters;
    procedure SetMst(aMst: TbjMstExp);
  public
    { Public declarations }
    FNotifyVchID: boolean;
    IsSaveXMLFileOn: boolean;
    ToUpdateMasters: boolean;
    TallyVersion: string;
    constructor Create;
    destructor Destroy; override;
    function IsTLic(const authentication: string): boolean;
    procedure SetGUID(const ID: string);
    Procedure SetDefaultGroup(const aName: string);
    property Firm: String read FFirm write SetFirm;
    property GUID: String read FGUID write SetGUID;
    property Host: string  read FHost write SetHost;
    property DefaultGroup: string read FDefaultGroup write SetDefaultGroup;
    property NotifyVchID: boolean read FNotifyVchID write FNotifyVchID;
    property MstExp: TbjMstExp read FMstExp write SetMst;
    property DefaultGSTState: string read FDefaultGSTState write FDefaultGSTState;
    property IsPostto1stLedgerwithGSTNon: boolean read FIsPostto1stLedgerwithGSTNon write FIsPostto1stLedgerwithGSTNon;
  	property IsUniqueVchRefon: boolean read FIsUniqueVchRefon write FIsUniqueVchRefon;
    property GSTLedType: string read FGSTLedType write FGSTLedType;
    property LastAction: string read FLastAction write FLastAction;
    property Vch_Date: string read FVch_Date write FVch_Date;
  end;

  TbjMstExp = class
  private
    { Private declarations }
    FAlias: string;
    FMailingName: string;
    FGroup: string;
    FGodown: string;
    FCategory: string;
    FEnv: TbjEnv;
    FOBal: currency;
    FOBatch: string;
    FORate: currency;
    FMRPRate: currency;
    FAddress: string;
    FAddress1: string;
    FAddress2: string;
    FAddress3: string;
    FAddress4: string;
    FPincode: string;
    FMobile: string;
    FeMail: string;
    FIsBatchwiseOn: boolean;
    FUserDesc: string;
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
    GSTNList: TList;
    procedure XmlHeader(const tgt:string);
    procedure XmlFooter(const tgt:string);
    function CreateLedger(const Ledger, Parent: string; const OpBal: currency ): boolean;
    function CreateParty(const Ledger, Parent, GSTN, State: string ): boolean;
    function CreateGST(const Ledger, Parent: string; Const TaxRate: string ): boolean;
    function CreateItem(const Item, BaseUnit: string; const OpBal, OpRate: currency): boolean;
    function CreateHSN(const Item, BaseUnit, aHSN: string; const GRate: string): boolean;
    function CreateUnit(const ItemUnit: string): boolean;
    function CreateItemGroup(const Grp, Parent: string): boolean;
    function CreateCategory(const aCategory, Parent: string): boolean;
    function CreateGodown(const Gdn, Parent: string): boolean;
    function IsItemGroup(const Grp: string): boolean;
    function IsCategory(const aCategory: string): boolean;
    function IsGodown(const Gdn: string): boolean;
    procedure CheckError;
    procedure SetEnv(aEnv: TbjEnv);
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    function IsLedger(Const Ledger: string): boolean;
    procedure NewLedger(const aLedger, aParent: string; OpBal: currency);
    function GetGSTNParty(const aGSTN: string): string;
    function GetDupPartyGSTN(const aDup: string): string;
    function GetPartyState(const aDup: string): string;
    function NewParty(const aLedger, aParent, aGSTN: string; aState: string): string;
    procedure NewGST(const aLedger, aParent: string; const TaxRate: string);
    function GetHalfof(const TaxRate: string): string;
    function IsItem(const Item: string): boolean;
    procedure NewItem(const aItem, aBaseUnit: string; OpBal, OpRate: currency);
    procedure NewHSN(const aItem, aBaseUnit, aHSN: string; const GRate: string);
    function IsUnit(const aUnit: string): boolean;
    procedure NewUnit(const aUnit: string);
    procedure NewItemGroup(const aGrp, aParent: string);
    procedure NewCategory(const aCategory, aParent: string);
    procedure NewGodown(const aGdn, aParent: string);
    function LPost: string;
    procedure RefreshMstLists;
    procedure RefreshInvLists;
    property Alias: string write FAlias;
    property MailingName: string write FMailingName;
    property Group: string write FGroup;
    property Godown: string write FGodown;
    property Category: string write FCategory;
    property Env: TbjEnv read FEnv write SetEnv;
    property OBal: currency write FOBal;
    property OBatch: string write FOBatch;
    property ORate: currency write FORate;
    property MRPRate: currency write FMRPRate;
    property Address: string write FAddress;
    property Mobile: string write FMobile;
    property eMail: string write FeMail;
    property IsBatchwiseOn: boolean write FIsBatchwiseOn;
    property UserDesc: string read FUserDesc write FUserDesc;
    property Address1: string write FAddress1;
    property Address2: string write FAddress2;
    property Address3: string write FAddress3;
    property Address4: string write FAddress4;
    property Pincode: string write FPincode;
  end;

  TbjVchExp = class
  private
    { Private declarations }
    FvchDate: string;
    FVouDate: string;
    FVchType: string;
    FWSType: string;
    FInvVch: boolean;
    FVchNarration: string;
    FVchChequeNo: string;
    FVchNo: string;
    FVchRef: string;
    FBillRef: string;
    FVchRefDate: string;
    FEnv: TbjEnv;
    FMstExp: TbjMStExp;
    Fvchid: string;
    FIsContra: boolean;
    FBatch: string;
    FVchGSTN: string;
    FVchAction: string;
    FRemoteID: string;
    FVchState: string;
    FPartyState: string;
  protected
    { Protected declarations }
    Lines: TList;
    ILines: TList;
    GSTNLines: TList;
    partyidx: integer;
    partyamt: currency;
    busidx: integer;
    busamt: currency;
    xvou: IbjXml;
    xvch: IbjXml;
    xvchid: IbjXml;
    IsVchTypeMatched: Boolean;
    DrCrTotal: currency;
    RefLedger: string;
    CrLine, DrLine: integer;
    IsVchMode4Vch: boolean;

    CashBankPList: TStringList;
    procedure CheckVchType(const ledger; const Amount: currency);
    procedure XmlHeader(const tgt:string);
    procedure XmlFooter(const tgt:string);
    procedure SetVchHeader;
    function Pack(const Ledger: string; const Amount: currency; const Ref, RefType: string; const aTType: boolean): currency;
    procedure Unpack;
//    procedure SetGSTLedType;
    procedure AttachInv(const rled: string);
    procedure AttachAssessable(const rled: string);
    procedure AddInDirect(const idx: integer);
    procedure AddInOut(const idx: integer);
    procedure CheckDefGroup;
    procedure CheckError;
    procedure SetEnv(aEnv: TbjEnv);
    procedure SetMst(aMst: TbjMstExp);
    procedure ClearLines;
    procedure SetVchID(const ID: string);
    function GetWSType: string;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    function AddLine(const Ledger: string; const Amount: currency; const aTType: boolean): currency;
    function AddLinewithRef(const Ledger: string; const Amount: currency; const Ref, RefType: string): currency;
    function SetAssessable(const aAmount: currency): currency;
    function SetInvLine(const Item: string; const Qty, Rate, Amount: currency; const Godown, Batch, UserDesc:string): currency;
    function Post(const Action: string; wem: boolean): string;
    function SPost(const Action: string; wem: boolean): string;

    property VchID: string read FVchID write SetVchID;
    property vchDate: string read FVchDate write FVchDate;
    property vOuDate: string read FVouDate write FVouDate;
    property WSType: string read GetWSType write FWSType;
    property VchType: string read FVchType write FVchType;
    property InvVch: boolean read FInvVch write FInvVch;
    property VchNarration: string read FVchNarration write FVchNarration;
    property VchChequeNo: string read FVchChequeNo write FVchChequeNo;
    property VchNo: string read FVchNo write FVchNo;
    property VchRef: string read FVchRef write FVchRef;
    property BillRef: string read FBillRef write FBillRef;
    property VchRefDate: string read FVchRefDate write FVchRefDate;
    property Env: TbjEnv read FEnv write SetEnv;
    property MstExp: TbjMstExp read FMstExp write SetMst;
    property IsContra: boolean read FIsContra write FIsContra;
    property Batch: string write FBatch;
    property VchGSTN: string read FVchGSTN write FVchGSTN;
    property VchAction: string read FVchAction write FVchAction;
    property RemoteID: string read FRemoteID write FRemoteID;
    property VchState: string read FVchState write FVchState;
    property PartyState: string read FPartyState write FPartyState;
  end;

  TLine = Record
    Ledger: string;
    Amount: currency;
    Ref: string;
    RefType: string;
    IsNegative: boolean;
  end;
  PLine = ^Tline;

  TInvLine = Record
    Ledger: string;
    Item: string;
    Qty: currency;
    Rate: currency;
    Amount: currency;
    Godown: string;
    Batch: string;
    UserDesc: string;
  end;
  PInvLine = ^TInvline;

  TGSTNLine = Record
    Ledger: string;
    Amount: currency;
  end;
  pGSTNLine = ^TGSTNline;

implementation
{$DEFINE Newformat}

Constructor TbjEnv.Create;
begin
  Inherited;
  FDomain := '127.0.0.1';
  Fport := 9000;
  FHost := 'http://'+FDomain+':'+InttoStr(FPort);
  Client := TbjClient.Create;
  FExportDependentMasters := False;
  fGuID := appguid;
  FTLic := '711031608';
  IsSaveXMLFileOn := False;
  FNotifyVchID := False;
  FDefaultGSTState := 'Tamil Nadu';
  ip := TStringList.Create;
  op := TStringList.Create;
  ip.Add('Input SGST 1.5%');
  ip.Add('intput CGST 1.5%');
  ip.Add('input IGST 3%');
  ip.Add('input SGST 2.5%');
  ip.Add('input CGST 2.5%');
  ip.Add('input IGST 5%');
  ip.Add('input SGST 6%');
  ip.Add('input CGST 6%');
  ip.Add('input IGST 12%');
  ip.Add('input SGST 9%');
  ip.Add('input CGST 9%');
  ip.Add('input IGST 18%');
  ip.Add('input SGST 14%');
  ip.Add('input CGST 14%');
  ip.Add('input IGST 28%');
  ip.Sorted := True;

  op.Add('Output SGST 1.5%');
  op.Add('Output CGST 1.5%');
  op.Add('Output IGST 3%');
  op.Add('Output SGST 2.5%');
  op.Add('Output CGST 2.5%');
  op.Add('Output IGST 5%');
  op.Add('Output SGST 6%');
  op.Add('Output CGST 6%');
  op.Add('Output IGST 12%');
  op.Add('Output SGST 9%');
  op.Add('Output CGST 9%');
  op.Add('Output IGST 18%');
  op.Add('Output SGST 14%');
  op.Add('Output CGST 14%');
  op.Add('Output IGST 28%');
  op.Sorted := True;
  ActionStrs[1] := 'CREATED';
  ActionStrs[2] := 'ALTERED';
  ActionStrs[3] := 'COMBINED';
  ActionStrs[4] := 'IGNORED';
  ActionStrs[5] := 'ERRORS';
end;

destructor TbjEnv.Destroy;
begin
  Client.Free;
  ip.Free;
  op.Free;
  inherited;
end;

Constructor TbjMstExp.Create;
begin
  Inherited;
  xLed := CreatebjXmlDocument;
  xLedid := CreatebjXmlDocument;
end;

destructor TbjMstExp.Destroy;
var
  i: integer;
  item: pGSTNRec;
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
  if Assigned(GSTNList) then
  begin
  for i := 0 to GSTNList.Count-1 do
  begin
    item := GSTNList.Items[i];
    item.Name := '';
    item.GSTN := '';
    item.State := '';
    item._Name := '';
    Dispose(item);
  end;
  GSTNList.Clear;
  end;
  GSTNList.Free;
  inherited;
end;

Constructor TbjVchExp.Create;
begin
  Inherited;
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
  FInvVch := False;
  IsVchMode4Vch := True;
end;

destructor TbjVchExp.Destroy;
begin
  xvch.Clear;
  xvchid.Clear;
  ClearLines;
  ILines.Free;
  Lines.Free;
  GSTNLines.Free;
  CashBankPList.Free;
  inherited;
end;

//For better exception handling removed
Procedure TbjMstExp.CheckError;
begin
  if Env.Client.Response.Size = 0 then
      MessageDlg('Error Posting Data to Tally', mtError, [mbOK], 0);
end;

//For better exception handling removed
Procedure TbjVchExp.CheckError;
begin
  if Env.Client.Response.Size = 0 then
      MessageDlg('Error Posting Data to Tally', mtError, [mbOK], 0);
end;

{
Create, Update logic is in VchUpdate.dpr
Low level funcntion should be Minimalist
}
function TbjMstExp.CreateLedger(const Ledger, Parent: string; const OpBal: currency): boolean;
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
  xLdg := xLdg.NewChild('ADDRESS.LIST','');
  If Length(FAddress) > 0 then
  begin
  xLdg.NewChild2('ADDRESS', FAddress);
  end;
  { ADDRESS.LIST }
  xLdg := xLdg.GetParent;
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', ledger );
  If Length(FAlias) > 0 then
  xLdg.NewChild2('NAME', FAlias );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
{
  if Length(FPincode) > 0 then
    xLdg.NewChild2('PINCODE', FPincode);
}  
  if Length(FeMail) > 0 then
    xLdg.NewChild2('EMAIL', FeMail);
  xLdg.NewChild2('PARENT', parent );
  if Length(FMobile) > 0 then
    xLdg.NewChild2('LEDGERMOBILE', FMobile);
{  if OpBal > 0 then }
    xLdg.NewChild2('OPENINGBALANCE', FormatCurr(TallyAmtPicture, FOBal));
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
  If Length(FAlias) > 0 then
  xLdg.NewChild2('NAME', FAlias );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  xLdg.NewChild2('PARENT', parent );
(*
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
      xLdg.NewChild2('GSTDUTYHEAD', 'State Tax');
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
    if FVchType = 'Sales' then
      xLdg.NewChild2('GSTNATUREOFTRANSACTION', 'Sales Taxable');
    if FVchType = 'Purchase' then
      xLdg.NewChild2('GSTNATUREOFTRANSACTION', 'Purchase Taxable');
    xLdg := xLdg.NewChild('STATEWISEDETAILS.LIST', '');
    xLdg.NewChild2('STATENAME', #4 +' Any' );
    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'Central Tax');
    xLdg.NewChild2('GSTRATE', GetHalfof(TaxRate));
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;
    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'State Tax');
    xLdg.NewChild2('GSTRATE', GetHalfof(TaxRate));
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;
    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'Integrated Tax');
    xLdg.NewChild2('GSTRATE', TaxRate);
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;
  { STATEWISEDETAILS.LIST }
   xLdg := xLdg.GetParent;
  { GSTDETAILS.LIST }
  xLdg := xLdg.GetParent;
  end;
*)
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
  xmlHeader('L');
  xLdg := xLdg.NewChild('TALLYMESSAGE','');

  xLdg := xLdg.NewChild('LEDGER','');
  xLdg.AddAttribute('NAME', ledger);
  xLdg.AddAttribute('ACTION','Create');
  xLdg := xLdg.NewChild('ADDRESS.LIST','');
  If Length(FAddress) > 0 then
  begin
  xLdg.NewChild2('ADDRESS', FAddress );
  end
  else
  begin
  If Length(FAddress1) > 0 then
  xLdg.NewChild2('ADDRESS', FAddress1);
  If Length(FAddress2) > 0 then
  xLdg.NewChild2('ADDRESS', FAddress2);
  If Length(FAddress3) > 0 then
  xLdg.NewChild2('ADDRESS', FAddress3);
  If Length(FAddress4) > 0 then
  xLdg.NewChild2('ADDRESS', FAddress4);
  end;
  { ADDRESS.LIST }
  xLdg := xLdg.GetParent;
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', ledger );
  If Length(FAlias) > 0 then
  xLdg.NewChild2('NAME', FAlias );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  if Length(FPincode) > 0 then
    xLdg.NewChild2('PINCODE', FPincode);
  if Length(FeMail) > 0 then
    xLdg.NewChild2('EMAIL', FeMail);
  xLdg.NewChild2('SALESTAXNUMBER', GSTN);
  xLdg.NewChild2('COUNTRYNAME', 'India');
  if Length(GSTN) > 0 then
    xLdg.NewChild2('GSTREGISTRATIONTYPE', 'Regular')
  else
    xLdg.NewChild2('GSTREGISTRATIONTYPE', 'Unregistered');
  xLdg.NewChild2('PARENT', parent );
  if Length(FMobile) > 0 then
    xLdg.NewChild2('LEDGERMOBILE', FMobile);
  xLdg.NewChild2('OPENINGBALANCE', FormatCurr(TallyAmtPicture, FOBal));
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

function TbjMstExp.CreateItem(const Item, BaseUnit: string; const OpBal, OpRate: currency): boolean;
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
  If Length(FMailingName) > 0 then
  begin
    xLdg := xLdg.NewChild('MAILINGNAME.LIST','');
    xLdg.NewChild2('MAILINGNAME', FMailingName );
    { MAILINGNAME.LIST }
    xLdg := xLdg.GetParent;
  end;
  If Length(FGroup) > 0 then
  xLdg.NewChild2('PARENT', FGroup );
  If Length(Fcategory) > 0 then
    xLdg.NewChild2('CATEGORY', FCategory );
  If Length(FUserDesc) > 0 then
    xLdg.NewChild2('DESCRIPTION', FUserDesc );
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', Item );
  If Length(FAlias) > 0 then
  xLdg.NewChild2('NAME', FAlias );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  xLdg.NewChild2('BASEUNITS', BaseUnit);
{
  if FIsBatchwiseOn then
  xldg.NewChild2('IsBatchWiseOn', 'Yes');
}
  xLdg.NewChild2('OPENINGBALANCE', FormatCurr(TallyQtyPicture, FOBal)+' '+BaseUnit);
  if FORate > 0 then
  begin
    xLdg.NewChild2('OPENINGVALUE', FormatCurr(TallyQtyPicture,-FORate * FOBal));;
    xLdg.NewChild2('OPENINGRATE', FormatCurr(TallyQtyPicture,FORate)+'/'+BaseUnit);;
  end;
  If Length(FGodown) > 0 then
  begin
    xLdg := xLdg.NewChild('BATCHALLOCATIONS.LIST','');
    if Length(FGodown) > 0 then
    xLdg.NewChild2('GODOWNNAME', FGodown )
    else
    xLdg.NewChild2('GODOWNNAME', 'Main Location' );
    if Length(FOBatch) > 0 then
    xLdg.NewChild2('BATCHNAME', FObatch)
    else
    xLdg.NewChild2('BATCHNAME', 'Primary Batch');
//    xLdg.NewChild2('BATCHNAME', 'Primary Batch');
    xLdg.NewChild2('OPENINGBALANCE', FormatCurr(TallyQtyPicture, FOBal)+' '+BaseUnit);
    xLdg.NewChild2('OPENINGVALUE', FormatCurr(TallyQtyPicture, -FORate * FOBal));;
    xLdg.NewChild2('OPENINGRATE', FormatCurr(TallyQtyPicture,FORate)+'/'+BaseUnit);;
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

{ Function to replace CreateItem }
function TbjMstExp.CreateHSN(const Item, BaseUnit, aHSN: string; const GRate: string): boolean;
begin
  xmlHeader('L');
  xLdg := xLdg.NewChild('TALLYMESSAGE','');

  xLdg := xLdg.NewChild('STOCKITEM','');
  xLdg.AddAttribute('NAME', Item);
  xLdg.AddAttribute('ACTION','Create');
  If Length(FMailingName) > 0 then
  begin
    xLdg := xLdg.NewChild('MAILINGNAME.LIST','');
    xLdg.NewChild2('MAILINGNAME', FMailingName );
    { MAILINGNAME.LIST }
    xLdg := xLdg.GetParent;
  end;
  If Length(FGroup) > 0 then
  xLdg.NewChild2('PARENT', FGroup );
  If Length(Fcategory) > 0 then
    xLdg.NewChild2('CATEGORY', FCategory );
// GST
  If Length(aHSN) > 0 then
    xLdg.NewChild2('GSTAPPLICABLE', #4 +' Applicable' );
  If Length(FUserDesc) > 0 then
    xLdg.NewChild2('DESCRIPTION', FUserDesc );
  If Length(aHSN) > 0 then
    xLdg.NewChild2('GSTTYPEOFSUPPLY', 'Goods');
  xLdg := xLdg.NewChild('NAME.LIST','');
  xLdg.NewChild2('NAME', Item );
  If Length(FAlias) > 0 then
  xLdg.NewChild2('NAME', FAlias );
  { NAME.LIST }
  xLdg := xLdg.GetParent;
  xLdg.NewChild2('BASEUNITS', BaseUnit);
{
  if FIsBatchwiseOn then
  xldg.NewChild2('IsBatchWiseOn', 'Yes');
}
  xLdg.NewChild2('OPENINGBALANCE', FormatCurr(TallyAmtPicture, FOBal)+' '+BaseUnit);
  if FORate > 0 then
  begin
    xLdg.NewChild2('OPENINGVALUE', FormatCurr(TallyQtyPicture, -FORate * FOBal));;
    xLdg.NewChild2('OPENINGRATE', FormatCurr(TallyQtyPicture,FORate)+'/'+BaseUnit);;
  end;
  If Length(FGodown) > 0 then
  begin
  xLdg := xLdg.NewChild('BATCHALLOCATIONS.LIST','');
//  xLdg.NewChild2('GODOWNNAME', FGodown );
    if Length(FGodown) > 0 then
    xLdg.NewChild2('GODOWNNAME', FGodown )
    else
    xLdg.NewChild2('GODOWNNAME', 'Main Location' );
  if Length(FOBatch) > 0 then
  xLdg.NewChild2('BATCHNAME', FOBatch)
  else
  xLdg.NewChild2('BATCHNAME', 'Primary Batch');
//  xLdg.NewChild2('BATCHNAME', 'Primary Batch');
    xLdg.NewChild2('OPENINGBALANCE', FormatCurr(TallyAmtPicture, FOBal)+' '+BaseUnit);
    if FORate > 0 then
    begin
    xLdg.NewChild2('OPENINGVALUE', FormatCurr(TallyQtyPicture, -FORate * FOBal));;
    xLdg.NewChild2('OPENINGRATE', FormatCurr(TallyQtyPicture, FORate)+' '+BaseUnit);
    end;
  { BATCHALLOCATIONS }
  xLdg := xLdg.GetParent;
  end;
//hsn
  If Length(aHSN) > 0 then
  begin
    xLdg := xLdg.NewChild('GSTDETAILS.LIST', '');
    xLdg.NewChild2('APPLICABLEFROM', '20180701');
    xLdg.NewChild2('HSNCODE', aHSN);
    if StrToIntDef(GRate, 0) = 0 then
    xLdg.NewChild2('TAXABILITY', 'Exempt')
    else
    if Length(GRate) > 0 then
    xLdg.NewChild2('TAXABILITY', 'Taxable');
    xLdg := xLdg.NewChild('STATEWISEDETAILS.LIST', '');
    xLdg.NewChild2('STATENAME', #4 +' Any' );
    if Length(GRate) > 0 then
    begin
    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'Central Tax');
    xLdg.NewChild2('GSTRATE', GetHalfof(GRate));
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;
    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'State Tax');
    xLdg.NewChild2('GSTRATE', GetHalfof(GRate));
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;

    xLdg := xLdg.NewChild('RATEDETAILS.LIST', '');
    xLdg.NewChild2('GSTRATEDUTYHEAD', 'Integrated Tax');
    xLdg.NewChild2('GSTRATE', GRate);
  { RATEDETAILS.LIST }
    xLdg := xLdg.GetParent;
    end;
  { STATEWISEDETAILS.LIST }
   xLdg := xLdg.GetParent;
  { GSTDETAILS }
  xLdg := xLdg.GetParent;
  end;
  if fMRPRate > 0 then
  begin
    xLdg := xLdg.NewChild('MRPDETAILS.LIST', '');
    xLdg.NewChild2('FROMDATE', FormatDateTime('YYYYMMDD', Now));
    xLdg := xLdg.NewChild('MRPRATEDETAILS.LIST', '');
    xLdg.NewChild2('MRPRATE', FormatCurr(TallyAmtPicture, FMRPRate));
  { MRPRATEDETAILS.LIST }
   xLdg := xLdg.GetParent;

  { MRPDETAILS.LIST }
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
    LedObj.Host := Env.Host;
    try
      LedPList := LedObj.GetLedPackedList;
    finally
      ledobj.Free;
    end;
  end;

  Result := LedPList.Find( PackStr(Ledger), index );
{ Idea to return existing ledger does not work as it is already packed }
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
    LedObj.Host := Env.Host;
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
    LedObj.Host := Env.Host;
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
    LedObj.Host := Env.Host;
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
    LedObj.Host := Env.Host;
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
    LedObj.Host := Env.Host;
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
{$IFNDEF Newformat}
    xLdg.NewChild2('TALLYREQUEST','Import Data');
{$ELSE}
    xLdg.NewChild2('VERSION','1');
    xLdg.NewChild2('TALLYREQUEST','IMPORT');
    xLdg.NewChild2('TYPE','DATA');
    xLdg.NewChild2('ID','All Masters');
{$ENDIF}
    xLdg := xLdg.GetParent;
    xLdg := xLdg.NewChild('BODY','');
{$IFNDEF Newformat}
    xLdg := xLdg.NewChild('IMPORTDATA','');
    xLdg := xLdg.NewChild('REQUESTDESC','');
    xLdg.NewChild2('REPORTNAME', 'All Masters');
{$ELSE}
    xLdg := xLdg.NewChild('DESC','');
{$ENDIF}
    xLdg := xLdg.NewChild('STATICVARIABLES','');
    xLdg.NewChild2('SVEXPORTFORMAT', '$$SysName:XML');
    if length(Env.FFirm) > 0 then
    begin
//      xLdg.NewChild2('SVCURRENTCOMPANY',TextToXML(Env.Firm));
      xLdg.NewChild2('SVCURRENTCOMPANY',Env.Firm);
    end;
  { STATICVARIABLES }
      xLdg := xLdg.GetParent;
  { REQUESTDESC }
    xLdg := xLdg.GetParent;
{$IFNDEF Newformat}
    xLdg := xLdg.NewChild('REQUESTDATA','');
{$ELSE}
    xLdg := xLdg.NewChild('DATA','');
{$ENDIF}
  end;
end;

Procedure TbjVchExp.XmlHeader(const tgt:string);
begin
  if tgt = 'V' then
  begin
    xvch.Clear;
    xvou := xVch.NewChild('ENVELOPE','');
    xvou := xvou.NewChild('HEADER','');
{$IFNDEF Newformat}
    xvou.NewChild2('TALLYREQUEST','Import Data');
{$ELSE}
    xvou.NewChild2('VERSION','1');
    xvou.NewChild2('TALLYREQUEST','IMPORT');
    xvou.NewChild2('TYPE','DATA');
    xvou.NewChild2('ID','All Masters');
{$ENDIF}
    xVou := xVou.GetParent;
    xvou := xvou.NewChild('BODY','');
{$IFNDEF Newformat}
    xvou := xvou.NewChild('IMPORTDATA','');
    xvou := xvou.NewChild('REQUESTDESC','');
    xvou.NewChild2('REPORTNAME', 'All Masters');
{$ELSE}
    xvou := xvou.NewChild('DESC','');
{$ENDIF}
    xvou := xvou.NewChild('REQUESTDESC','');
    xvou.NewChild2('REPORTNAME', 'All Masters');
    xvou := xvou.NewChild('STATICVARIABLES','');
    xvou.NewChild2('SVEXPORTFORMAT', '$$SysName:XML');
    if length(Env.FFirm) > 0 then
    begin
//      xvou.NewChild2('SVCURRENTCOMPANY',TextToXML(Env.Firm));
      xvou.NewChild2('SVCURRENTCOMPANY',Env.Firm);
    end;
  { STATICVARIABLES }
      xVou := xVou.GetParent;
  { REQUESTDESC }
    xvou := xvou.GetParent;
{$IFNDEF Newformat}
    xvou := xvou.NewChild('REQUESTDATA','');
{$ELSE}
    xvou := xvou.NewChild('DATA','');
{$ENDIF}
  end;
end;

{
 Daybook order
 id, Type, Action, date, id, narration, type, alterid,
}
procedure TbjVchExp.SetVchHeader;
var
  sid: string;
  Item: pLine;
  i: Integer;
begin
  if IsContra then
  begin
  if (VchType = 'Receipt') or (VchType = 'Payment') then
    Vchtype := 'Contra';
  end;
  xmlHeader('V');
  if Length(VchId) < 8 then
    sid := Env.GUID+'-'+ RightStr('00000000' +
      vchid, 8)
  else
    sid := Env.GUID + '-' + vchid;

  xvou := xvou.NewChild('TALLYMESSAGE','');
  xvou := xvou.NewChild('VOUCHER','');
  xvou.AddAttribute('REMOTEID', sid);
  xvou.AddAttribute('VCHTYPE', vchType);
  xvou.AddAttribute('ACTION', vchAction);
  if Length(VouDate) > 0 then
  xvou.NewChild2('DATE',vouDate)
  else
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
  if Length(PartyState) > 0 then
    xvou.NewChild2('STATENAME', PartyState);
  if Length(VChNarration) > 0 then
  begin
    xvou.NewChild2('NARRATION',VchNarration);
  end;
  if Length(PartyState) > 0 then
    xvou.NewChild2('COUNTRYOFRESIDENCE', 'India');
  if Length(VchGSTN) > 0 then
  xvou.NewChild2('PARTYGSTIN', VchGSTN);
  if Length(VchState) > 0 then
  begin
    xvou.NewChild2('PLACEOFSUPPLY', VchState);
  end;
  xvou.NewChild2('VOUCHERTYPENAME',VchType);
  if Length(VchNo) > 0 then
  begin
    xvou.NewChild2('VOUCHERNUMBER',VchNo);
    VchNo := '';
  end;
  if (WSType = 'Purchase')  or (WSType = 'Sales') then
  begin

    CrLine := 0;
    DrLine := 0;
    for i := 0 to Lines.Count-1 do
    begin
      Item := Lines.Items[i];
      if (Item^.Amount > 0) and not (Item^.IsNegative) then
        CrLine := CrLine + 1;
      if (Item^.Amount < 0) and not (Item^.IsNegative) then
        DrLine := DrLine + 1;
    end;


    if IsVchMode4Vch then
    begin
    if (WSType = 'Sales')  and (DrLine > 1) then
      InvVch := False;
    if (WSType = 'Purchase')  and (CrLine > 1) then
      InvVch := False;
    end;


    if InvVch then
    xvou.NewChild2('ISINVOICE','Yes');
  end;
  if Length(VchRef) > 0 then
  begin
    xvou.NewChild2('REFERENCE',VchRef);
    VchRef := '';
  end
  else
    xvou.NewChild2('REFERENCE',VchNo);
{
  if Length(VchState) > 0 then
  xvou.NewChild2('CONSIGNEESTATENAME',VchState);
}
{ Effective Date is crucial; Without which dll crashes }
  if Length(VouDate) > 0 then
  xvou.NewChild2('EFFECTIVEDATE',vouDate)
  else
  xvou.NewChild2('EFFECTIVEDATE',vchDate);
  IsVchTypeMatched := False;
  DrCrTotal := 0;
end;

procedure TbjVchExp.SetVchID(const ID: string);
var
  wref: string;
begin
  if length(id) = 0 then
  begin
    Fvchid := InttoHex(random(10000000000),8);
    if Env.IsUniqueVchRefon and (Length(VchRef) > 0)then
    begin
      if (WsType = 'Sales') then
      begin
//        wRef := RightStr('00000000'+StrtoHexDigitStr(VchRef),8);
        wRef := HexKey(VchRef);
        FVchId := wRef;
      end;
      if (WsType = 'Purchase') then
      if Length(VchGSTN) > 0 then
      begin
//        wRef := RightStr(StrtoHexDigitStr(VchGSTN+VchRef),8);
        wRef := HexKey(RightStr(VchGSTN,3) + LeftStr(VchGSTN,12) + VchRef);
        FVchId := wRef;
      end;
    end;
  end
  else
    Fvchid := id;
  IsContra := True;
  if VchAction = 'Create' then
    RemoteID := FVchID;
  if VchAction = 'Delete' then
    FVchID := RemoteID;
end;

function TbjVchExp.GetWSType: string;
begin
  Result := FWSType;
  if Length(FWSType) = 0 then
    Result := FVchType;
end;

Procedure TbjMstExp.XmlFooter(const tgt:string);
begin
  if tgt = 'L' then
  begin
{$IFNDEF Newformat}
{ REQUESTDATA }
    xLdg := xLdg.GetParent;
{$ENDIF}
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

procedure TbjVchExp.CheckVchType(const Ledger; const Amount: currency);
begin
  IsVchTypeMatched := True;
  if  (WSType = 'Receipt') then
    if Amount <= 0 then
      IsVchTypeMatched := False;
  if  (WSType = 'Payment') then
    if Amount >= 0 then
      IsVchTypeMatched := False;
  if  (WSType = 'Sales') then
    if Amount >= 0 then
      IsVchTypeMatched := False;
  if  (WSType = 'Purchase') then
    if Amount <= 0 then
      IsVchTypeMatched := False;
  if  (WSType = 'Journal') then
    if Amount >= 0 then
      IsVchTypeMatched := False;
  if  (WSType = 'Contra') then
    if Amount <= 0 then
      IsVchTypeMatched := False;
  if  (WSType = 'Debit Note') then
    if Amount >= 0 then
      IsVchTypeMatched := False;
  if  (WSType = 'Credit Note') then
    if Amount <= 0 then
      IsVchTypeMatched := False;
end;

function TbjVchExp.AddLine(const Ledger: string; const Amount: currency; const aTType: boolean): currency;
begin
  Pack(Ledger, Amount,'','', aTType);
  DrCrTotal := DrCrTotal + amount;
  RefLedger := Ledger;
  Result := DrCrTotal;
end;
{
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

  pline^.Qty :=  Qty;
  pline^.Rate :=  Rate;
  pline^.Amount :=  Amount;
  pline^.Batch :=  Batch;
  ILines.Add(pline);
  Result := Amount;
end;
}
function TbjVchExp.SetInvLine(const Item: string; const Qty, Rate, Amount: currency; const Godown, Batch, UserDesc: string): currency;
var
  pline: pInvLine;
begin
  Result := 0;
  if VchType <> 'Stock Journal' then
   If length(RefLedger) = 0 then
     Exit;
  pline := new(pInvLine);
  pline^.Ledger :=  RefLedger;
  pline^.Item :=  Item;

  pline^.Qty :=  Qty;
  pline^.Rate :=  Rate;
  pline^.Amount :=  Amount;
  pline^.Godown :=  Godown;
  pline^.Batch :=  Batch;
  pLine^.UserDesc := UserDesc;
  ILines.Add(pline);
  Result := Amount;
end;

function TbjVchExp.SetAssessable(const aAmount: currency): currency;
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

{ To combine repeat Ledger Entries }
function TbjVchExp.Pack(const Ledger: string; const Amount: currency; const Ref, RefType: string; const aTType: boolean): currency;
var
  item: pLine;
  step: integer;
  idx: integer;
  Obj: TbjMstListImp;
  aLedger: string;
begin
  if not Assigned(CashBankPList) then
  begin
    Obj := TbjMstListImp.Create;
    CashBankPList := TStringList.Create;
    try
      Obj.ToPack := False;
      Obj.Host := Env.Host;
      CashBankPList.Text := Obj.GetCashBankText(True);
      CashBankPList.Sorted := True;
    Finally
      Obj.Free;
    end;
  end;
   if IsContra then
   if not CashBankPList.Find(ledger, idx) then
     IsContra := False;

  aLedger := Ledger;
  if (Env.GSTLedType = 'Min') or (Env.GSTLedType = 'Mean') then
  begin
    if (Env.ip.Find(Ledger, idx)) or (Env.op.Find(Ledger, idx)) then
    begin
      if (pos('SGST', Ledger) > 0) then
        aLedger := 'SGST'
      else if (pos('CGST', Ledger) > 0) then
        aLedger := 'CGST'
      else if (pos('IGST', Ledger) > 0) then
        aLedger := 'IGST';
      if  (Env.GSTLedType = 'Mean') then
      begin
        if WsType = 'Sales' then
          aLedger := 'Output ' + aLedger;
        if WsType = 'Purchase' then
          aLedger := 'Input ' + aLedger;
      end;
    end;
  end;

  for Step := 1 to Lines.Count do
  begin
    Item := Lines.Items[Step - 1];
    if (Item^.Ledger = aLedger) and
      (Item^.Ref = Ref) and
      (Item^.RefType = RefType) and
      (Item^.IsNegative = aTType) then
    begin
      Item^. Amount := Item^. Amount + Amount;
      Result := Item^. Amount;
      Exit;
    end;
  end;
  Item := new(pLine);
  Item^.Ledger :=  aLedger;
  Item^.Amount :=  Amount;
  Item^.Ref :=  Ref;
  Item^.RefType :=  RefType;
  Item^.IsNegative := aTType;
  Lines.Add(Item);
  Result := Amount;
end;

{
Procedure TbjVchExp.SetGSTLedType;
var
  Item: pLine;
  i: Integer;
  idx: integer;
begin
  if Env.GSTLedType = 'Max' then
  Exit;
  if Env.GSTLedType = 'Min' then
  begin
    for i := 0 to Lines.Count-1 do
    begin
      Item := Lines.Items[i];
      if (Env.ip.Find(Item.Ledger, idx)) and (pos('SGST', Item.Ledger) > 0) then
        Item.Ledger := 'SGST';
      if (Env.ip.Find(Item.Ledger, idx)) and (pos('CGST', Item.Ledger) > 0) then
        Item.Ledger := 'CGST';
      if (Env.ip.Find(Item.Ledger, idx)) and (pos('IGST', Item.Ledger) > 0) then
        Item.Ledger := 'IGST';

      if (Env.op.Find(Item.Ledger, idx)) and (pos('SGST', Item.Ledger) > 0) then
        Item.Ledger := 'SGST';
      if (Env.op.Find(Item.Ledger, idx)) and (pos('CGST', Item.Ledger) > 0) then
        Item.Ledger := 'CGST';
      if (Env.op.Find(Item.Ledger, idx)) and (pos('IGST', Item.Ledger) > 0) then
        Item.Ledger := 'IGST';
    end;
  end;
end;
}
{
To push largest (Cr or Dr) entries to the top of the voucher
For Reference old version is kept here
Procedure TbjVchExp.UnPack;
var
  Item: pLine;
  i: Integer;
begin
  SetGSTLedType;
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
        if (WSType = 'Receipt')  or (WSType = 'Payment') then
          Item^.RefType := 'Agst Ref';
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
}
Procedure TbjVchExp.UnPack;
var
  Item: pLine;
  i, j: Integer;
  PartyisDebit: Boolean;
begin
  PartyisDebit := False;
  j := -1;
//  SetGSTLedType;
  for i := 0 to Lines.Count-1 do
  begin
    Item := Lines.Items[i];
    CheckVchType(Item^.Ledger, Item^.Amount);
    if IsVchTypeMatched then
    begin
      if Abs(Item^.Amount) > partyamt then
      begin
        partyamt := Abs(Item^.Amount);
        if  Item^.Amount < 0 then
        begin
          PartyisDebit := True;
        end;
        partyidx := i;
        Item^.Ref := BillRef;
        Item^.RefType := 'New Ref';
        if (WSType = 'Receipt')  or (WSType = 'Payment') then
          Item^.RefType := 'Agst Ref';
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
    for i:= 0 to Lines.count-1 do
    begin
      Item := Lines.Items[i];
      if Item^.Amount = 0 then
        Continue;
      if i = partyidx then
        continue;
      if i = busidx then
        continue;
      If PartyisDebit then
      begin
        If Item^.Amount < 0 then
        begin
          AddInDirect(i);
          j := i + 1;
        end
        else
        begin
          j := i;
          Break;
        end;
      end;
      If not PartyisDebit then
      begin
        If Item^.Amount > 0 then
        begin
          AddInDirect(i);
          j := i + 1;
        end
        else
        begin
          j := i;
          Break;
        end;
      end;
    end;
    if busidx <> -1 then
    begin
      AddInDirect(busidx);
    end;
	if j = -1 then
	  j := 0;
    for i:= j to Lines.count-1 do
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
    iItem.UserDesc := '';
    iItem.Godown := '';
    iItem.Batch := '';
    iItem.UserDesc := '';
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
  if InvVch and (pLine(Lines.Items[idx])^.IsNegative) then
  begin
  if (pLine(Lines.Items[idx])^.Amount > 0) then
    xvou.NewChild2('ISDEEMEDPOSITIVE','Yes')
  else
    xvou.NewChild2('ISDEEMEDPOSITIVE','No');
  end
  else
  begin
  if (pLine(Lines.Items[idx])^.Amount < 0) then
    xvou.NewChild2('ISDEEMEDPOSITIVE','Yes')
  else
    xvou.NewChild2('ISDEEMEDPOSITIVE','No');
  end;
  xvou.NewChild2('LEDGERNAME', pLine(Lines.Items[idx])^.Ledger);
  xvou.NewChild2('AMOUNT', FormatCurr(TallyAmtPicture,
  pLine(Lines.Items[idx])^.Amount));

  IF (wsType = 'Receipt') or (wsType = 'Payment') then
  begin
    xvou := xvou.NewChild('BANKALLOCATIONS.LIST','');
    xvou.NewChild2('INSTRUMENTDATE', VchDate);
    xvou.NewChild2('TRANSACTIONTYPE', 'Cheque');
    if Length(vchChequeNo) > 0 then
      xvou.NewChild2('INSTRUMENTNUMBER', vchChequeNo)
    else
      xvou.NewChild2('INSTRUMENTNUMBER', '');
    xvou.NewChild2('AMOUNT', FormatCurr(TallyAmtPicture, pLine(Lines.Items[idx])^.Amount));
  { BANKALLOCATIONS.LIST }
    xVou := xVou.GetParent;
  end;
  if Length(pLine(Lines.Items[idx])^.Ref) > 0 then
  begin
    xvou := xvou.NewChild('BILLALLOCATIONS.LIST','');
    xvou.NewChild2('NAME', pLine(Lines.Items[idx])^.Ref);
    xvou.NewChild2('BILLTYPE', pLine(Lines.Items[idx])^.Reftype);
    xvou.NewChild2('AMOUNT', FormatCurr(TallyAmtPicture, pLine(Lines.Items[idx])^.Amount));
  { BILLALLOCATIONS.LIST }
    xVou := xVou.GetParent;
  end;
    { ALLLEDGERENTRIES.LIST }
  AttachAssessable(pLine(Lines.Items[idx])^.Ledger);
  AttachInv(pLine(Lines.Items[idx])^.Ledger);
  xVou := xVou.GetParent;
end;

procedure TbjVchExp.AddInOut(const idx: integer);
begin
  if (pInvLine(iLines.Items[idx])^.Amount < 0) then
    xvou := xvou.NewChild('INVENTORYENTRIESIN.LIST','');
  if (pInvLine(iLines.Items[idx])^.Amount > 0 ) then
    xvou := xvou.NewChild('INVENTORYENTRIESOUT.LIST','');
  xvou.NewChild2('STOCKITEMNAME',pInvLine(iLines.Items[idx])^.Item);
  if (pInvLine(iLines.Items[idx])^.Amount < 0) then
    xvou.NewChild2('ISDEEMEDPOSITIVE','Yes');
  if (pInvLine(iLines.Items[idx])^.Amount > 0) then
    xvou.NewChild2('ISDEEMEDPOSITIVE','No');
  xvou.NewChild2('RATE', FormatCurr(TallyAmtPicture, pInvLine(iLines.Items[idx])^.Rate));
  xvou.NewChild2('AMOUNT', FormatCurr(TallyAmtPicture, pInvLine(iLines.Items[idx])^.Amount));
  xvou.NewChild2('ACTUALQTY', FormatCurr(TallyQtyPicture, pInvLine(iLines.Items[idx])^.Qty));
  xvou.NewChild2('BILLEDQTY', FormatCurr(TallyQtyPicture, pInvLine(iLines.Items[idx])^.Qty));

  xvou := xvou.NewChild('BATCHALLOCATIONS.LIST','');
  if Length(pInvLine(iLines.Items[idx])^.Godown) > 0 then
    xvou.NewChild2('GODOWNNAME', pInvLine(iLines.Items[idx])^.Godown )
  else
    xvou.NewChild2('GODOWNNAME', 'Main Location' );
  if Length(pInvLine(iLines.Items[idx])^.Batch) > 0 then
    xvou.NewChild2('BATCHNAME', pInvLine(iLines.Items[idx])^.Batch)
  else
    xvou.NewChild2('BATCHNAME', 'Primary Batch');
  xvou.NewChild2('AMOUNT', FormatCurr(TallyAmtPicture, pInvLine(iLines.Items[idx])^.Amount));
  xvou.NewChild2('ACTUALQTY', FormatCurr(TallyQtyPicture, pInvLine(iLines.Items[idx])^.Qty));
  xvou.NewChild2('BILLEDQTY', FormatCurr(TallyQtyPicture, pInvLine(iLines.Items[idx])^.Qty));
  { BATCHALLOCATIONS.LIST }
  xVou := xVou.GetParent;

  { INVENTORYENTRIES IN OUT.LIST }
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
    xvou := xvou.NewChild('BASICUSERDESCRIPTION.LIST', '');
    xvou.NewChild2('BASICUSERDESCRIPTION', pInvLine(iLines.Items[idx])^.UserDesc);
    { BASICUSERDESCRIPTION.LIST }
      xvou := xvou.GetParent;
    xvou.NewChild2('STOCKITEMNAME', pInvLine(iLines.Items[idx])^.Item);
    if pInvLine(iLines.Items[idx])^.Amount < 0 then
      xvou.NewChild2('ISDEEMEDPOSITIVE', 'Yes')
    else
      xvou.NewChild2('ISDEEMEDPOSITIVE', 'No');
      xvou.NewChild2('AMOUNT', FormatCurr(TallyAmtPicture, pInvLine(iLines.Items[idx])^.Amount));
      xvou.NewChild2('ACTUALQTY', FormatCurr(TallyQtyPicture, pInvLine(iLines.Items[idx])^.Qty));
      xvou.NewChild2('BILLEDQTY', FormatCurr(TallyQtyPicture, pInvLine(iLines.Items[idx])^.Qty));
      xvou.NewChild2('RATE', FormatCurr(TallyAmtPicture, pInvLine(iLines.Items[idx])^.Rate));
      if Length(pInvLine(iLines.Items[idx])^.Batch) > 0 then
      begin
      xvou := xvou.NewChild('BATCHALLOCATIONS.LIST', '');
      if Length(pInvLine(iLines.Items[idx])^.Godown)  > 0 then
        xvou.NewChild2('GODOWNNAME', pInvLine(iLines.Items[idx])^.Godown)
      else
        xvou.NewChild2('GODOWNNAME', 'Main Location');
      xvou.NewChild2('BATCHNAME', pInvLine(iLines.Items[idx])^.Batch);
      xvou.NewChild2('AMOUNT', FormatCurr(TallyAmtPicture, pInvLine(iLines.Items[idx])^.Amount));
      xvou.NewChild2('ACTUALQTY', FormatCurr(TallyQtyPicture, pInvLine(iLines.Items[idx])^.Qty));
      xvou.NewChild2('BILLEDQTY', FormatCurr(TallyQtyPicture, pInvLine(iLines.Items[idx])^.Qty));
    { BATCHALLOCATIONS.LIST }
      xvou := xvou.GetParent;
      end
      else
      if Length(pInvLine(iLines.Items[idx])^.Godown)  > 0 then
        xvou.NewChild2('GODOWNNAME', pInvLine(iLines.Items[idx])^.Godown)
      else
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
    xvou.NewChild2('VATASSESSABLEVALUE', FormatCurr(TallyAmtPicture, pGSTNLine(GSTNLines.Items[idx])^.aMOUNT));
  end;
end;

function TbjVchExp.AddLinewithRef(const Ledger: string; const Amount: currency; const Ref, RefType: string): currency;
begin
//  CheckVchType(Ledger, Amount);
  Pack(Ledger, Amount, Ref, RefType, False);
  DrCrTotal := DrCrTotal + amount;
  Result := DrCrTotal;
end;

function TbjMstExp.LPost: string;
begin
  Env.Client.Host := Env.Host;
  Env.Client.xmlRequestString :=  xLdg.GetXml;
{ To debug }
  if Env.IsSaveXmlFileOn then
    xLdg.SaveXmlFile('Ledger.xml');
  Env.Client.post;

  CheckError;
{  xvch.Clear;}
  xLed.Clear;
end;

function TbjVchExp.Post(const Action: string; wem: boolean): string;
var
  Tallyid: IbjXml;
  LErr: string;
  Tid: string;
  i: integer;
begin
  Env.LastAction := '';
  if (vchAction <> 'Create') and
    (vchAction <> 'Alter') and
    (VchAction <> 'Delete') then
  VchAction := 'Create';
  SetVchHeader;
  CheckDefGroup;
  unpack;
  xmlFooter('V');
  Env.Client.Host :=  Env.Host;
  Env.Client.xmlRequestString :=  xvch.GetXml;
{ For debugging }
  if Env.IsSaveXmlFileOn then
    xvch.SaveXmlFile('Voucher.xml');
{ For debugging }
  Env.Client.post;

  xvchid.Clear;
  xvchid.LoadXml(Env.Client.GetxmlResponseString);
  if Env.IsSaveXmlFileOn then
    xvchid.SaveXmlFile('Tally.xml');

  Tallyid := xvchid.SearchForTag(nil, 'LASTVCHID');
  if Assigned(Tallyid) then
  begin
    tid := TallyId.GetContent;
{ If this Visual feedback is not required then set ToUpdate to false }
    Result := TId;
    if Env.NotifyVchID then
      MessageDlg(Tid, mtInformation, [mbOK], 0);
  end;
  for i := 1 to 4 do
  begin
  Tallyid := xvchid.SearchForTag(nil, Env.ActionStrs[i]);
  if Assigned(Tallyid) then
  begin
    tid := TallyId.GetContent;
    if tid <> '0' then
      Env.LastAction := Env.ActionStrs[i];
  end;
  end;
  if wem then
  begin
  Tallyid := xvchid.SearchForTag(nil, 'LINEERROR');
  if Assigned(Tallyid) then
      LErr := TallyId.GetContent;
  if Length(LErr) > 0 then
     Result := Lerr;
  end;

  CheckError;
  xvch.Clear;
end;

function TbjVchExp.SPost(const Action: string; wem: boolean): string;
var
  Tallyid: IbjXml;
  LErr: string;
  Tid: string;
  item: pInvLine;
  i: Integer;
begin
  if (vchAction <> 'Create') and
    (vchAction <> 'Alter') and
    (VchAction <> 'Delete') then
  VchAction := 'Create';
  SetVchHeader;
  for i := 0 to ILines.Count-1 do
  begin
    Item := ILines.Items[i];
    AddInOut(i);
  end;
  ClearLines;
  xmlFooter('V');
  Env.Client.Host :=  Env.Host;
  Env.Client.xmlRequestString :=  xvch.GetXml;
{ For debugging }
  if Env.IsSaveXmlFileOn then
    xvch.SaveXmlFile('Voucher.xml');
{ For debugging }
//  MessageDlg(xvch.GetXML, mtInformation, [mbOK], 0);
  Env.Client.post;

  xvchid.Clear;
  xvchid.LoadXml(Env.Client.GetxmlResponseString);
  if Env.IsSaveXmlFileOn then
    xvchid.SaveXmlFile('Tally.xml');

  Tallyid := xvchid.SearchForTag(nil, 'LASTVCHID');
  if Assigned(Tallyid) then
  begin
    tid := TallyId.GetContent;
{ If this Visual feedback is not required then set ToUpdate to false }
    Result := TId;
    if Env.NotifyVchID then
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

  CheckError;
  xvch.Clear;
end;

procedure TbjVchExp.CheckDefGroup;
var
  i: integer;
  StrLedger: string;
begin
  if not Assigned(MstExp) then
    Exit;
  for i := 0 to Lines.Count-1 do
  begin
    StrLedger := pLine(Lines.Items[i])^.Ledger;
//    if not LedgerExists(StrLedger) then
//      CreateLedger(StrLedger, DefaultGroup, 0);
      MstExp.NewLedger(StrLedger, Env.DefaultGroup, 0);
  end;
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
  if Assigned(MstExp) then
    MstExp.RefreshMstLists;
  FFirm := Name;
end;

Procedure TbjEnv.SetHost(const aHost: string);
begin
  FHost := aHost;
end;


procedure TbjMstExp.RefreshMstLists;
var
  Ledobj: TbjMstListImp;
  Rpet: TRpetGSTN;
  i: integer;
  item: pGSTNRec;
begin
  LedPList.Free;
  ItemPlist.Free;
  UnitPList.Free;
  ledObj := TbjMstListImp.Create;
  LedObj.Host := Env.Host;
  try
    LedPList := LedObj.GetLedPackedList;
    ItemPList := LedObj.GetItemPackedList;
    UnitPList := LedObj.GetUnitPackedList;
  finally
    ledobj.Free;
  end;
  if Assigned(GSTNList) then
  begin
  for i := 0 to GSTNList.Count-1 do
  begin
    item := GSTNList.Items[i];
    item.Name := '';
    item.GSTN := '';
    Dispose(item);
  end;
  GSTNList.Clear;
  end
  else
    GSTNList := TList.Create;
  Rpet := TRpetGSTN.Create;
  try
  Rpet.Host := Env.Host;
  Rpet.GetList(GSTNList);
  finally
    Rpet.Free;
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
  LedObj.Host := Env.Host;
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

procedure TbjMstExp.NewLedger(const aLedger, aParent: string; OpBal: currency);
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
    if Env.ToUpdateMasters then
      CreateLedger(aLedger, aParent, OpBal);
  if not Found then
  begin
    CreateLedger(aLedger, aParent, OpBal);
    LedPList.Add(PackStr(aLedger));
  end;
end;

procedure TbjMstExp.NewItem(const aItem, aBaseUnit: string; OpBal, OpRate: currency);
var
  Found: boolean;
begin
  If Length(aItem) = 0 then
    Exit;
  Found := IsItem(aItem);
  if Found then
    if Env.ToUpdateMasters then
      CreateItem(aItem, aBaseUnit, OpBal, OpRate);
  if not found then
  begin
    CreateItem(aItem, aBaseUnit, OpBal, OpRate);
    ItemPList.Add(PackStr(aItem));
  end;
end;

procedure TbjMstExp.NewHSN(const aItem, aBaseUnit, aHSN: string; const GRate: string);
var
  Found: boolean;
begin
  If Length(aItem) = 0 then
    Exit;
  Found := IsItem(aItem);
  if Found then
    if Env.ToUpdateMasters then
      CreateHSN(aItem, aBaseUnit, aHSN, GRate);
  if not found then
  begin
    CreateHSN(aItem, aBaseUnit, aHSN, GRate);
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
    if Env.ToUpdateMasters then
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
    if Env.ToUpdateMasters then
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
    if Env.ToUpdateMasters then
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
    if Env.ToUpdateMasters then
      CreateGodown(aGdn, aParent);
  if not found then
  begin
    CreateGodown(aGdn, aParent);
    GodownPList.Add(PackStr(aGdn));
  end;
end;

//procedure TbjMstExp.NewParty(const aLedger, aParent, aGSTN: string; aState: string);
function TbjMstExp.NewParty(const aLedger, aParent, aGSTN: string; aState: string): string;
var
  Found: boolean;
  SystemLedName: string;
  SystemGSTN: string;
  item: pGSTNRec;
  dupName: boolean;
begin
  dupName := False;
  If Length(aLedger) = 0 then
    Exit;
  if Length(aState) = 0 then
    aState := Env.DefaultGSTState;
	{ Trim the space }
  if Length(Trim(aGSTN)) > 0 then
  begin
    SystemLedName := GetGSTNParty(aGSTN);
{
There is a logic using SystemLedName.
It does not use GetDupPartyGSTN 
}
    if Length(SystemLedName) > 0 then
    if aLedger <> SystemLedName then
      dupName := True
    else
    begin
{ Same Name Sake GSTN}
      Result := aLedger;
      Exit;
    end;
  end;
{ Different Name Sake GSTN - one part }
  if dupName then
  begin
    if Env.ToUpdateMasters then
    begin
      CreateParty(aLedger, aParent, aGSTN, aState);
      Result := aLedger;
      Exit;
    end
    else  if Env.IsPostto1stLedgerwithGSTNon then
     begin
//       if aLedger <> SystemLedName then
         Result := SystemLedName;
       Exit;
     end;
  end;
  Found := IsLedger(aLedger);
{ Different Name Sake GSTN Different GSTN}
{ Different Name Sake GSTN - one part }
  if not Found then
  begin
//    GSTNParent := aParent;
//    if (Length(aGSTN) > 0) and (aParent = 'Suspense A/c') then
//    begin
//      GSTNParent := 'Sundry Debtors';
//    end;
    CreateParty(aLedger, aParent, aGSTN, aState);
    LedPList.Add(PackStr(aLedger));
    if Length(aGSTN) > 0 then
    begin
      item := new(pGSTNRec);
      item.Name := aLedger;
      item.GSTN := aGSTN;
      gstnlIST.Add(item);
      Result := aLedger;
    end;
    Exit;
  end;
  if found then
  begin
    if Env.ToUpdateMasters then
    begin
      CreateParty(aLedger, aParent, aGSTN, aState);
      Result := aLedger;
      Exit;
    end;
    SystemGSTN := GetDupPartyGSTN(aLedger);
{ Same Name Different GSTN}
  if (not dupName) and (aGSTN <> SystemGSTN) then
  begin
      if aLedger = 'Cash' then
       Exit;
    if not IsLedger(aLedger+'_'+aGSTN) then
      CreateParty(aLedger+'_'+aGSTN, aParent, aGSTN, aState);
    if Length(aGSTN) > 0 then
    begin
      item := new(pGSTNRec);
      item.Name := aLedger+'_'+aGSTN;
      item.GSTN := aGSTN;
      gstnlIST.Add(item);
      Result := aLedger+'_'+aGSTN;
    end;
      Exit;
    end;
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
var
  ntr: Integer;
begin
  ntr := StrToInt(TaxRate);
  if (TaxRate = '28') or (ntr = 28) then
    Result := '14';
  if (TaxRate = '18') or (ntr = 18) then
    Result := '9';
  if (TaxRate = '12') or (ntr = 12) then
    Result := '6';
  if (TaxRate = '5') or (ntr = 5) then
    Result := '2.5';
  if (TaxRate = '3') or (ntr = 3) then
    Result := '1.5';
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
  FEnv := aEnv;
end;

procedure TbjVchExp.SetEnv(aEnv: TbjEnv);
begin
  FEnv := aEnv;
end;

procedure TbjVchExp.SetMst(aMst: TbjMstExp);
begin
  FMstExp := aMst;
end;

procedure TbjEnv.SetMst(aMst: TbjMstExp);
begin
  FMstExp := aMst;
end;

function TbjMstExp.GetGSTNParty(const aGSTN: string): string;
var
  Rpet: TRpetGSTN;
  i: integer;
  item: pGSTNRec;
begin
{  Result := '' }
  if not Assigned(GSTNList) then
  begin
  Rpet := TRpetGSTN.Create;
  try
    Rpet.Host := Env.Host;
    Rpet.GetList(GSTNList);
  finally
    Rpet.Free;
  end;
  end;
  if GSTNList.Count = 0 then
    Rpet.GETList(GSTNList);
  if Length(agstn) = 0 then
    Exit;
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

function TbjMstExp.GetDupPartyGSTN(const aDup: string): string;
var
  Rpet: TRpetGSTN;
  i: integer;
  item: pGSTNRec;
  rName: string;
begin
{  Result := '' }
  if not Assigned(GSTNList) then
  begin
  Rpet := TRpetGSTN.Create;
  try
    Rpet.Host := Env.Host;
    Rpet.GetList(GSTNList);
  finally
    Rpet.Free;
  end;
  end;
  if GSTNList.Count = 0 then
    Rpet.GETList(GSTNList);
  if Length(aDup) = 0 then
    Exit;
  rName := PackStr(aDup);
  for i := 0 to GSTNList.Count-1 do
  begin
    item := GSTNList.Items[i];
    if item^._Name = rName then
    begin
      Result := item^.GSTN;
      break;
    end;
  end;
end;
function TbjMstExp.GetPartyState(const aDup: string): string;
var
  Rpet: TRpetGSTN;
  i: integer;
  item: pGSTNRec;
  rName: string;
begin
{  Result := '' }
  if not Assigned(GSTNList) then
  begin
  Rpet := TRpetGSTN.Create;
  try
    Rpet.Host := Env.Host;
    Rpet.GetList(GSTNList);
  finally
    Rpet.Free;
  end;
  end;
  if GSTNList.Count = 0 then
    Rpet.GETList(GSTNList);
  if Length(aDup) = 0 then
    Exit;
  rName := PackStr(aDup);
  for i := 0 to GSTNList.Count-1 do
  begin
    item := GSTNList.Items[i];
    if item^._Name = rName then
    begin
      Result := item^.State;
      break;
    end;
  end;
end;
{
procedure Register;
begin
  RegisterComponents('Samples', [TbjEnv]);
  RegisterComponents('Samples', [TbjMstExp]);
  RegisterComponents('Samples', [TbjVchExp]);
end;
}

end.

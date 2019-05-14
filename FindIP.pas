unit FindIP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Winsock;


type
  TfrmFindIP = class(TForm)
    btn1: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFindIP: TfrmFindIP;

implementation

{$R *.dfm}

Function GetIPAddress():String;
type
  pu_long = ^u_long;
var
  varTWSAData : TWSAData;
  varPHostEnt : PHostEnt;
  varTInAddr : TInAddr;
  namebuf : Array[0..255] of char;
begin
  If WSAStartup($101,varTWSAData) <> 0 Then
  Result := 'No. IP Address'
  Else Begin
    gethostname(namebuf,sizeof(namebuf));
    varPHostEnt := gethostbyname(namebuf);
    varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list^)^);
//    Result := 'IP Address: '+inet_ntoa(varTInAddr);
    Result := inet_ntoa(varTInAddr);
  End;
  WSACleanup;
end;

procedure TfrmFindIP.btn1Click(Sender: TObject);
begin
  Lbl1.Caption := GetIPAddress;
end;


end.

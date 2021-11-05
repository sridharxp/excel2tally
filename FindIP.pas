unit FindIP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  Client,IdSSLOpenSSL,
  Winsock;


type
  TfrmFindIP = class(TForm)
    btn1: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lblStatus: TLabel;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetIPAddress:String;
function GetmyIP:String;
var
  frmFindIP: TfrmFindIP;

implementation

{$R *.dfm}

function GetIPAddress:String;
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
  Lbl4.Caption := GetmyIP;
end;

function GetmyIP:String;
var
  Client: TbjClient;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  Client := TbjClient.Create;
  try
    try
    Client.Host := 'https://ip.5ec.nl';
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(Client.Id);
    SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    Client.Id.IOHandler := SSL;
    Client.Get;
    Result := Client.xmlResponseString;
  except
      on E:Exception do
      MessageDlg(E.message, mtError, [mbOK], 0);
  end;
  finally
  Client.Free;
  end;
end;

end.

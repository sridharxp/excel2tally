unit CFig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmCFig = class(TForm)
    ckb6: TCheckBox;
    ckb7: TCheckBox;
    ckb8: TCheckBox;
    ckbGSTSettings: TCheckBox;
    cmbState: TComboBox;
    lbl1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCFig: TfrmCFig;

implementation

{$R *.dfm}

end.

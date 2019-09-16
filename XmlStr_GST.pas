{
Column Names are Case Sensitive
Avoid dot in Column Name
}
unit XmlStr_GST;

interface

const
CONTRA = '<Voucher>'+
'<Data>'+
'<VoucherList>Contra</VoucherList>'+
'<DefaultGroup>Bank Accounts</DefaultGroup>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<LEDGER>'+
'<Default>Cash</Default>'+
'<Alias>CREDIT LEDGER</Alias>'+
'<AmtCol>'+
'<Alias>AMOUNT</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Group>Bank Accounts</Group>'+
'</LEDGER>'+
'<LEDGER>'+
'<Default>Cash</Default>'+
'<Alias>DEBIT LEDGER</Alias>'+
'<AmtCol>'+
'<Alias>AMOUNT</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Group>Bank Accounts</Group>'+
'</LEDGER>'+
'<VTYPE>>'+
'<Default>Contra</Default>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

RCPT ='<Voucher>'+
'<Data>'+
'<VoucherList>Receipt</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+
'<RoundOff>'+
'<Alias>PARTY LEDGER</Alias>'+
'</RoundOff>'+
'+<LEDGER>'+
'<Alias>RECEIPT LEDGER</Alias>'+
'<Group>Bank Accounts</Group>'+
'<AmtCol>'+
'<Alias>RECEIPT AMOUNT</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<VTYPE>>'+
'<Alias>VTYPE</Alias>'+
'<Default>Receipt</Default>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

PYMT = '<Voucher>'+
'<Data>'+
'<VoucherList>Payment</VoucherList>'+
'<DefaultGroup>Sundry Creditors</DefaultGroup>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+
'<LEDGER>'+
'<Alias>PAYMENT LEDGER</Alias>'+
'<Group>Bank Accounts</Group>'+
'<AmtCol>'+
'<Alias>PAYMENT AMOUNT</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<RoundOff>'+
'<Alias>PARTY LEDGER</Alias>'+
'</RoundOff>'+
'<VTYPE>>'+
'<Alias>VTYPE</Alias>'+
'<Default>Payment</Default>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

JRNL = '<Voucher>'+
'<Data>'+
'<VoucherList>Journal</VoucherList>'+
//'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<LEDGER>'+
'<Alias>CREDIT LEDGER</Alias>'+
'<AmtCol>'+
'<Alias>AMOUNT</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Group>'+
'<Alias>CREDIT GROUP</Alias>'+
'</Group>'+
'</LEDGER>'+
'<LEDGER>'+
'<Alias>DEBIT LEDGER</Alias>'+
'<AmtCol>'+
'<Alias>AMOUNT</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Group>'+
'<Alias>DEBIT GROUP</Alias>'+
'</Group>'+
'</LEDGER>'+
'<VTYPE>>'+
'<Default>Journal</Default>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

BANK = '<Voucher>'+
'<Data>'+
'<VoucherList>Bank</VoucherList>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+
'<LEDGER>'+
'<Alias>LEDGER</Alias>'+
'<Default>Party</Default>'+
'<Group>Sundry Debtors</Group>'+
'</LEDGER>'+
'<CrAmtCol>'+
'<Alias>DEPOSITS</Alias>'+
'<Type>Receipt</Type>'+
'</CrAmtCol>'+
'<DrAmtCol>'+
'<Alias>WITHDRAWALS</Alias>'+
'<Type>Payment</Type>'+
'</DrAmtCol>'+

'<RoundOff>'+
'<Alias>BANK</Alias>'+
'<Default>Bank Account</Default>'+
'<Group>Bank Accounts</Group>'+
'</RoundOff>'+

'<VTYPE>>'+
'<Default>Receipt</Default>'+
//'<Alias>VCH TYPE</Alias>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

DAYBOOK = '<Voucher>'+
'<Data>'+
'<VoucherList>Daybook</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'<IsGenerated>Yes</IsGenerated>'+
'</ID>'+

'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<CrAmtCol>'+
'<Alias>CREDIT AMOUNT</Alias>'+
'</CrAmtCol>'+
'<DrAmtCol>'+
'<Alias>DEBIT AMOUNT</Alias>'+
'</DrAmtCol>'+

'<LEDGER>'+
'<Alias>LEDGER</Alias>'+
'<Group>'+
'<Alias>GROUP</Alias>'+
' </Group>'+
'</LEDGER>'+
'<VTYPE>>'+
'<Alias>VTYPE</Alias>'+
'<Default>Journal</Default>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

MYSALE = '<Voucher>'+
'<Data>'+
'<VoucherList>MySales</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Voucher Ref</Alias>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<DATE>'+
'<Alias>Date</Alias>'+
'</DATE>'+
'<NARRATION>'+
'<Alias>Narration</Alias>'+
'</NARRATION>'+

'<RoundOff>'+
'<Alias>Party</Alias>'+
'<Group>Sundry Debtors</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<RoundTo>1</RoundTo>'+
'</RoundOff>'+
{
'<LEDGER>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Output IGST 3%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output IGST 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Output IGST 12%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Output IGST 18%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Output IGST 28%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Sales_Value</Assessable>'+
'</LEDGER>'+
}
'+<LEDGER>'+
'<Default>GST 3% Sales</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>GST Sales 3</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 1.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 1_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 1.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 1_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 3% Sales</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 3</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 3%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 3</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 5% Sales</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>GST Sales 5</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 2.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 2_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 2.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 2_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>IGST 5% Sales</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 5</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 12% Sales</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>GST Sales 12</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 6%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 6</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 6%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 6</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 12% Sales</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 12</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 12%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 12</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 18% Sales</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>GST Sales 18</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 9%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 9</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 9%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 9</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>IGST 18% Sales</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 18</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 18%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 18</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 28% Sales</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>GST Sales 28</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 14%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 14</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 14%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 14</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>IGST 28% Sales</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 28</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 28%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 28</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>CESS</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>GST Sales Exempted</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>IGST Sales Exempted</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>>'+
'<Alias>VTYPE</Alias>'+
'<Default>Sales</Default>'+
'</VTYPE>'+
'<INVENTORY>>'+
'<ITEM>>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<UNIT>>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>>'+
'<Alias>Bill_Value</Alias>'+
'</Value>'+
'</INVENTORY>'+
'</Voucher>';

MYPURC = '<Voucher>'+
'<Data>'+
'<VoucherList>MyPurchase</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<VoucherDate>'+
'<Alias>Voucher Date</Alias>'+
'</VoucherDate>'+
'<VoucherRef>'+
'<Alias>Voucher Ref</Alias>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<DATE>'+
'<Alias>Date</Alias>'+
'</DATE>'+
'<NARRATION>'+
'<Alias>Narration</Alias>'+
'</NARRATION>'+

'<RoundOff>'+
'<Alias>Party</Alias>'+
'<Group>Sundry Creditors</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<RoundTo>1</RoundTo>'+
'</RoundOff>'+

{
'<LEDGER>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
//'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Input SGST 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
//'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input SGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
//'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Input SGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
//'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Input SGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
//'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Input SGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Purchase_Value</Assessable>'+
'</LEDGER>'+
}

'+<LEDGER>'+
'<Default>GST 3% Purchase</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>GST Purchase 3</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input SGST 1.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 1_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input CGST 1.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 1_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 3% Purchase</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>IGST Purchase 3</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input IGST 3%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 3</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 5% Purchase</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>GST Purchase 5</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input SGST 2.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 2_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input CGST 2.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 2_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 5% Purchase</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>IGST Purchase 5</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input IGST 5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 12% Purchase</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>GST Purchase 12</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input SGST 6%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 6</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input CGST 6%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 6</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 12% Purchase</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>IGST Purchase 12</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input IGST 12%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 12</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 18% Purchase</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>GST Purchase 18</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input SGST 9%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 9</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input CGST 9%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 9</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 18% Purchase</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>IGST Purchase 18</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input IGST 18%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 18</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 28% Purchase</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>GST Purchase 28</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input SGST 14%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 14</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input CGST 14%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 14</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 28% Purchase</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>IGST Purchase 28</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input IGST 28%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 28</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>CESS</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>GST Purchase Exempted</Alias>'+
'<Group>Purchase Accounts</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>IGST Purchase Exempted</Alias>'+
'<Group>Purchase Accounts</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>>'+
'<Alias>VTYPE</Alias>'+
'<Default>Purchase</Default>'+
'</VTYPE>'+
'<INVENTORY>>'+
'<ITEM>>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<UNIT>>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>>'+
'<Alias>Bill_Value</Alias>'+
'</Value>'+
'</INVENTORY>'+
'</Voucher>';

SBILL = '<Voucher>'+
'<Data>'+
'<VoucherList>SBill</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Voucher Ref</Alias>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+
'<DATE>'+
'<Alias>Date</Alias>'+
'</DATE>'+
'<NARRATION>'+
'<Alias>Narration</Alias>'+
'</NARRATION>'+

'<RoundOff>'+
'<Alias>Party</Alias>'+
'<Group>Sundry Debtors</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<RoundTo>1</RoundTo>'+
'</RoundOff>'+

'+<LEDGER>'+
'<Alias>Bill_Ledger</Alias>'+
'<Default>Sales Account</Default>'+
'<IsInvCol>Yes</IsInvCol>'+
'<AmtCol>'+
'<Alias>Bill_Value</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>CGST</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+
{
'+<LEDGER>'+
'<Default>Output SGST 1.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 1_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 1.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 1_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 3%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 3</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>Output SGST 2.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 2_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 2.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 2_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>Output SGST 6%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 6</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 6%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 6</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 12%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 12</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>Output SGST 9%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 9</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 9%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 9</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 18%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 18</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>Output SGST 14%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 14</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 14%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 14</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 28%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 28</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+
}
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>CESS</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>>'+
'<Alias>VTYPE</Alias>'+
'<Default>Sales</Default>'+
'</VTYPE>'+

'<INVENTORY>>'+
'<ITEM>>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<UNIT>>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>>'+
'<Alias>Bill_Value</Alias>'+
'</Value>'+
'</INVENTORY>'+
'</Voucher>';

PBILL = '<Voucher>'+
'<Data>'+
'<VoucherList>SBill</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Voucher Ref</Alias>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<DATE>'+
'<Alias>Date</Alias>'+
'</DATE>'+
'<NARRATION>'+
'<Alias>Narration</Alias>'+
'</NARRATION>'+

'<RoundOff>'+
'<Alias>Party</Alias>'+
'<Group>Sundry Debtors</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<RoundTo>1</RoundTo>'+
'</RoundOff>'+

'+<LEDGER>'+
'<Alias>Bill_Ledger</Alias>'+
'<Default>Purchase Account</Default>'+
'<IsInvCol>Yes</IsInvCol>'+
'<AmtCol>'+
'<Alias>Bill_Value</Alias>'+
'<Group>Purchase Accounts</Group>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>CGST</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+
{
'+<LEDGER>'+
'<Default>Output SGST 1.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 1_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 1.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 1_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 3%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 3</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>Output SGST 2.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 2_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 2.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 2_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>Output SGST 6%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 6</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 6%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 6</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 12%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 12</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>Output SGST 9%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 9</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 9%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 9</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 18%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 18</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>Output SGST 14%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 14</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 14%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 14</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 28%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 28</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+
}
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>CESS</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>>'+
'<Alias>VTYPE</Alias>'+
'<Default>Sales</Default>'+
'</VTYPE>'+

'<INVENTORY>>'+
'<ITEM>>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<UNIT>>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>>'+
'<Alias>Bill_Value</Alias>'+
'</Value>'+
'</INVENTORY>'+
'</Voucher>';

FINANCE = '<Voucher>'+
'<Data>'+
'<VoucherList>Finance</VoucherList>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<CrAmtCol>'+
'<Alias>DEPOSITS</Alias>'+
'<Type>Receipt</Type>'+
'</CrAmtCol>'+
'<DrAmtCol>'+
'<Alias>WITHDRAWALS</Alias>'+
'<Type>Payment</Type>'+
'</DrAmtCol>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<LEDGER>'+
'<Alias>PARTY</Alias>'+
'<Group>Sundry Creditors</Group>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Fund Account</Default>'+
'<Group>Current Liabilities</Group>'+
'<Alias>LEDGER</Alias>'+
'+</LEDGER>'+
'<VTYPE>>'+
'<Default>Receipt</Default>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

GSTSALE = '<Voucher>'+
'<Data>'+
'<VoucherList>Sales</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Voucher Ref</Alias>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+

'<RoundOff>'+
'<Alias>Name_of_buyer</Alias>'+
'<Group>Sundry Debtors</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<RoundTo>1</RoundTo>'+
'</RoundOff>'+

'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Sales_Ledger</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Default>Sales Account</Default>'+
'<IsInvCol>Yes</IsInvCol>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>0</Token>'+
'<Value>GST Sales Exempted</Value>'+
'</Dict>'+

'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>GST 3% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>GST 5% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>GST 12% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>GST 18% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>GST 28% Sales</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>Sales_Value</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>SGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Output SGST 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output SGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Output SGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Output SGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Output SGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Sales_Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>CGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Output CGST 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output CGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Output CGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Output CGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Output CGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>CGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Sales_Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Alias>Sales_Ledger</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Default>Sales Account</Default>'+
'<IsInvCol>Yes</IsInvCol>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>0</Token>'+
'<Value>IGST Sales Exempted</Value>'+
'</Dict>'+

'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>IGST 3% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>IGST 5% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>IGST 12% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>IGST 18% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>IGST 28% Sales</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST Sales Value</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>IGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Output IGST 3%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output IGST 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Output IGST 12%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Output IGST 18%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Output IGST 28%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>IGST Sales Value</Assessable>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>CESS</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<GSTRate>'+
'<Alias>Tax_rate</Alias>'+
'</GSTRate>'+

'+<LEDGER>'+
'<Group>Bank Accounts</Group>'+
'<AmtCol>'+
'<Alias>Card Receipts</Alias>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'+</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>>'+
'<Alias>VTYPE</Alias>'+
'<Default>Sales</Default>'+
'</VTYPE>'+


'<INVENTORY>>'+
'<ITEM>>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<UNIT>>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
{
'<Value>>'+
'<Alias>Sales_Value</Alias>'+
'</Value>'+
}
'</INVENTORY>'+
'</Voucher>'+
'</Voucher>';

GSTPURC = '<Voucher>'+
'<Data>'+
'<VoucherList>Purchase</VoucherList>'+
'<DefaultGroup>Sundry Creditors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<VoucherDate>'+
'<Alias>Voucher Date</Alias>'+
'</VoucherDate>'+
'<VoucherRef>'+
'<Alias>Voucher Ref</Alias>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+

'<RoundOff>'+
'<Alias>Name_of_seller</Alias>'+
'<Group>Sundry Creditors</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<RoundTo>1</RoundTo>'+
'</RoundOff>'+

'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Purchase_Ledger</Alias>'+
'<Group>Purchase Accounts</Group>'+
'<Default>Purchase Account</Default>'+
'<IsInvCol>Yes</IsInvCol>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>0</Token>'+
'<Value>GST Purchase Exempted</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>GST 3% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>GST 5% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>GST 12% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>GST 18% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>GST 28% Purchase</Value>'+
'</Dict>'+
{
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>IGST 5% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>IGST 12% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>IGST 18% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>IGST 28% Purchase</Value>'+
'</Dict>'+
}
'<AmtCol>'+
'<Alias>Purchase_Value</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>SGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Input SGST 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input SGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Input SGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Input SGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Input SGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Purchase_Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>CGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Input CGST 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input CGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Input CGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Input CGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Input CGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>CGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Purchase_Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Alias>Purchase_Ledger</Alias>'+
'<Group>Purchase Accounts</Group>'+
'<Default>Purchase Account</Default>'+
'<IsInvCol>Yes</IsInvCol>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>0</Token>'+
'<Value>IGST Purchase Exempted</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>IGST 3% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>IGST 5% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>IGST 12% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>IGST 18% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>IGST 28% Purchase</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST Purchase Value</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>IGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Input IGST 3%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input IGST 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Input IGST 12%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Input IGST 18%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Input IGST 28%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>IGST Purchase Value</Assessable>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>CESS</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<GSTRate>'+
'<Alias>Tax_rate</Alias>'+
'</GSTRate>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>>'+
'<Alias>VTYPE</Alias>'+
'<Default>Purchase</Default>'+
'</VTYPE>'+

'<INVENTORY>>'+
'<ITEM>>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<UNIT>>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
{
'<Value>>'+
'<Alias>Purchase_Value</Alias>'+
'</Value>'+
}
'</INVENTORY>'+
'</Voucher>';

ACCMASTER = '<Voucher>'+
'<Data>'+
'<MasterList>LMaster</MasterList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'</Data>'+

'<LEDGER>'+
'<Alias>LEDGER</Alias>'+
'<AliasName>'+
'<Alias>Alias</Alias>'+
'</AliasName>'+
'<Group>'+
'<Alias>GROUP</Alias>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<O_BALANCE>'+
'<Alias>O_Balance</Alias>'+
'</O_BALANCE>'+
'</LEDGER>'+
'</Voucher>';

INVMASTER = '<Voucher>'+
'<Data>'+
'<MasterList>IMaster</MasterList>'+
'<DefaultUnit>NOs</DefaultUnit>'+
'<IsMultiRow>No</IsMultiRow>'+
'</Data>'+

'<LEDGER>'+
'<Alias>LEDGER</Alias>'+
'</LEDGER>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'<HSN>>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<GSTRate>>'+
'<Alias>GSTRate</Alias>'+
'</GSTRate>'+
'<AliasName>'+
'<Alias>Alias</Alias>'+
'</AliasName>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<O_BALANCE>'+
'<Alias>O_Balance</Alias>'+
'</O_BALANCE>'+
'<O_RATE>'+
'<Alias>O_Rate</Alias>'+
'</O_RATE>'+
'<GROUP>'+
'<Alias>Group</Alias>'+
'</GROUP>'+
'<SUBGROUP>'+
'<Alias>SubGroup</Alias>'+
'</SUBGROUP>'+
'<GODOWN>'+
'<Alias>Godown</Alias>'+
'</GODOWN>'+
'</ITEM>'+
'</Voucher>';

CNOTE = '<Voucher>'+
'<Data>'+
'<VoucherList>CNote</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Voucher Ref</Alias>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+

'<RoundOff>'+
'<Alias>Name_of_buyer</Alias>'+
'<Group>Sundry Debtors</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<RoundTo>1</RoundTo>'+
'</RoundOff>'+

'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Sales_Ledger</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Default>Sales Account</Default>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>0</Token>'+
'<Value>Sales Account</Value>'+
'</Dict>'+

'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>GST 3% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>GST 5% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>GST 12% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>GST 18% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>GST 28% Sales</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>Return Value</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>SGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Output SGST 1.5%</Value>'+
//'<Value>Input SGST 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output SGST 2.5%</Value>'+
//'<Value>Input SGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Output SGST 6%</Value>'+
//'<Value>Input SGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Output SGST 9%</Value>'+
//'<Value>Input SGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Output SGST 14%</Value>'+
//'<Value>Input SGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>CGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Output CGST 1.5%</Value>'+
//'<Value>Input CGST 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output CGST 2.5%</Value>'+
//'<Value>Input CGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Output CGST 6%</Value>'+
//'<Value>Input CGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Output CGST 9%</Value>'+
//'<Value>Input CGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Output CGST 14%</Value>'+
//'<Value>Input CGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>CGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Alias>Sales_Ledger</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Default>Sales Account</Default>'+
'<IsInvCol>Yes</IsInvCol>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>0</Token>'+
'<Value>IGST Sales Exempted</Value>'+
'</Dict>'+

'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>IGST 3% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>IGST 5% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>IGST 12% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>IGST 18% Sales</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>IGST 28% Sales</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST Sales Value</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>IGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Output IGST 3%</Value>'+
//'<Value>Input IGST 3%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output IGST 5%</Value>'+
//'<Value>Input IGST 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Output IGST 12%</Value>'+
//'<Value>Input IGST 12%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Output IGST 18%</Value>'+
//'<Value>Input IGST 18%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Output IGST 28%</Value>'+
//'<Value>Input IGST 28%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>IGST Sales Value</Assessable>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>CESS</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<GSTRate>'+
'<Alias>Tax_rate</Alias>'+
'</GSTRate>'+

'+<LEDGER>'+
'<Group>Bank Accounts</Group>'+
'<AmtCol>'+
'<Alias>Card Receipts</Alias>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'+</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>>'+
'<Default>Credit Note</Default>'+
'</VTYPE>'+

'<INVENTORY>>'+
'<ITEM>>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<UNIT>>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>>'+
'<Alias>Return Value</Alias>'+
'</Value>'+
'</INVENTORY>'+
'</Voucher>';

DNOTE = '<Voucher>'+
'<Data>'+
'<VoucherList>DNote</VoucherList>'+
'<DefaultGroup>Sundry Creditors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Voucher Ref</Alias>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill Ref</Alias>'+
'</BillRef>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+

'<RoundOff>'+
'<Alias>Name_of_seller</Alias>'+
'<Group>Sundry Creditors</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<RoundTo>1</RoundTo>'+
'</RoundOff>'+

'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Purchase_Ledger</Alias>'+
'<Group>Purchase Accounts</Group>'+
'<Default>Purchase Account</Default>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>0</Token>'+
'<Value>Purchase Account</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>GST 3% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>GST 5% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>GST 12% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>GST 18% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>GST 28% Purchase</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>Return Value</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>SGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Input SGST 1.5%</Value>'+
//'<Value>Output SGST 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input SGST 2.5%</Value>'+
//'<Value>Output SGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Input SGST 6%</Value>'+
//'<Value>Output SGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Input SGST 9%</Value>'+
//'<Value>Output SGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Input SGST 14%</Value>'+
//'<Value>Output SGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>cGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Input CGST 1.5%</Value>'+
//'<Value>Output CGST 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input CGST 2.5%</Value>'+
//'<Value>Output CGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Input CGST 6%</Value>'+
//'<Value>Output CGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Input CGST 9%</Value>'+
//'<Value>Output CGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Input CGST 14%</Value>'+
//'<Value>Output CGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>CGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Alias>Purchase_Ledger</Alias>'+
'<Group>Purchase Accounts</Group>'+
'<Default>Purchase Account</Default>'+
'<IsInvCol>Yes</IsInvCol>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>0</Token>'+
'<Value>IGST Purchase Exempted</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>IGST 3% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>IGST 5% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>IGST 12% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>IGST 18% Purchase</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>IGST 28% Purchase</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST Purchase Value</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>IGST</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>3</Token>'+
'<Value>Input IGST 3%</Value>'+
//'<Value>Output IGST 3%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input IGST 5%</Value>'+
//'<Value>Output IGST 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>12</Token>'+
'<Value>Input IGST 12%</Value>'+
//'<Value>Output IGST 12%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>18</Token>'+
'<Value>Input IGST 18%</Value>'+
//'<Value>Output IGST 18%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>Tax_rate</TokenCol>'+
'<Token>28</Token>'+
'<Value>Input IGST 28%</Value>'+
//'<Value>Output IGST 28%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>CESS</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<GSTRate>'+
'<Alias>Tax_rate</Alias>'+
'</GSTRate>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>>'+
'<Default>Debit Note</Default>'+
'</VTYPE>'+

'<INVENTORY>>'+
'<ITEM>>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<UNIT>>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>>'+
'<Alias>Return Value</Alias>'+
'</Value>'+
'</INVENTORY>'+
'</Voucher>';

implementation

end.

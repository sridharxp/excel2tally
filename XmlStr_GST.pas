unit XmlStr_GST;

interface

const
CONTRA = '<Voucher>'+
'<Data>'+
'<VoucherList>Ne</VoucherList>'+
'<DefaultGroup>Bank Accounts</DefaultGroup>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<LEDGER2>'+
'<Default>Cash</Default>'+
'<Alias>CREDIT LEDGER</Alias>'+
'<AmtCol>'+
'<Alias>CREDIT AMOUNT</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
 '<Group>Bank Accounts</Group>'+
'</LEDGER2>'+
'<LEDGER>'+
'<Default>Cash</Default>'+
'<Alias>DEBIT LEDGER</Alias>'+
'<AmtCol>'+
'<Alias>DEBIT AMOUNT</Alias>'+
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
'<VoucherList>Ne</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<LEDGER>'+
'<Alias>PARTY LEDGER</Alias>'+
'<AmtCol>'+
'<Alias>PARTY AMOUNT</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER2>'+
'<Alias>RECEIPT LEDGER</Alias>'+
'<Group>Bank Accounts</Group>'+
'<AmtCol>'+
'<Alias>RECEIPT AMOUNT</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER2>'+
'<VTYPE>>'+
'<Default>Receipt</Default>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

PYMT = '<Voucher>'+
'<Data>'+
'<VoucherList>Ne</VoucherList>'+
'<DefaultGroup>Sundry Creditors</DefaultGroup>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<LEDGER2>'+
'<Alias>PAYMENT LEDGER</Alias>'+
'<Group>Bank Accounts</Group>'+
'<AmtCol>'+
'<Alias>PAYMENT AMOUNT</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER2>'+
'<LEDGER>'+
'<Alias>PARTY LEDGER</Alias>'+
'<AmtCol>'+
'<Alias>PARTY AMOUNT</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<VTYPE>>'+
'<Default>Payment</Default>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

VATSALE = '<Voucher>'+
'<Data>'+
'<VoucherList>Annex_II</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<VoucherNo>'+
'<Alias>Invoice_No</Alias>'+
'</VoucherNo>'+

'<RoundOff>'+
'<Alias>Name_of_buyer</Alias>'+
'<Group>Sundry Debtors</Group>'+
'<GSTN>Buyer_TIN</GSTN>'+
'</RoundOff>'+

'<ID>'+
 '<Alias>Invoice_No</Alias>'+
'</ID>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+
'<NARRATION>>'+
'<Alias>Invoice_No</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Tax_rate</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>1.5</Token>'+
'<Value>Output Tax 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>Output Tax 2%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>4</Token>'+
'<Value>Output Tax 4%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output Tax 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5.5</Token>'+
'<Value>Output Tax 5.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12.5</Token>'+
'<Value>Output Tax 12.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>14</Token>'+
'<Value>Output Tax 14%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>14.5</Token>'+
'<Value>Output Tax 14.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>15</Token>'+
'<Value>Output Tax 15%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>VAT_CST_paid</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Sales_Value</Assessable>'+
'</LEDGER>'+

'<LEDGER2>'+
'<Default>Sales Account</Default>'+
'<Group>Sales Accounts</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>0</Token>'+
'<Value>Sales Account</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>1.5</Token>'+
'<Value>VAT Sales 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>VAT Sales 2%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>4</Token>'+
'<Value>VAT Sales 4%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>VAT Sales 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5.5</Token>'+
'<Value>VAT Sales 5.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12.5</Token>'+
'<Value>VAT Sales 12.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>14</Token>'+
'<Value>VAT Sales 14%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>14.5</Token>'+
'<Value>VAT Sales 14.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>15</Token>'+
'<Value>VAT Sales 15%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>Sales_Value</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER2>'+

'<VTYPE>>'+
'<Default>Sales</Default>'+
'</VTYPE>'+
'</Voucher>';

VATPURC = '<Voucher>'+
'<Data>'+
'<VoucherList>Annex_I</VoucherList>'+
'<DefaultGroup>Sundry Creditors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<VoucherNo>'+
'<Alias>Invoice_No</Alias>'+
'</VoucherNo>'+

'<RoundOff>'+
'<Alias>Name_of_seller </Alias>'+
'<Group>Sundry Creditors</Group>'+
'<GSTN>Seller_TIN</GSTN>'+
'</RoundOff>'+

'<ID>'+
'<Alias>Invoice_No</Alias>'+
'</ID>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+
'<NARRATION>>'+
'<Alias>Invoice_No</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Tax_rate</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>1.5</Token>'+
'<Value>Input Tax 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>Input Tax 2%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>4</Token>'+
'<Value>Input Tax 4%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input Tax 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5.5</Token>'+
'<Value>Input Tax 5.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12.5</Token>'+
'<Value>Input Tax 12.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>14</Token>'+
'<Value>Input Tax 14%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>14.5</Token>'+
'<Value>Input Tax 14.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>15</Token>'+
'<Value>Input Tax 15%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>VAT_CST_paid</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER2>'+
'<Default>Purchase Account</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>Purchase_Value</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>0</Token>'+
'<Value>Purchase Account</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>1.5</Token>'+
'<Value>VAT Purchase 1.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>VAT Purchase 2%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>4</Token>'+
'<Value>VAT Purchase 4%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>VAT Purchase 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5.5</Token>'+
'<Value>VAT Purchase 5.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12.5</Token>'+
'<Value>VAT Purchase 12.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>14</Token>'+
'<Value>VAT Purchase 14%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>14.5</Token>'+
'<Value>VAT Purchase 14.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>15</Token>'+
'<Value>VAT Purchase 15%</Value>'+
'</Dict>'+
'</LEDGER2>'+
'<VTYPE>>'+
'<Default>Purchase</Default>'+
'</VTYPE>'+
'</Voucher>';

JRNL = '<Voucher>'+
'<Data>'+
'<VoucherList>Ne</VoucherList>'+
//'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<LEDGER2>'+
'<Alias>CREDIT LEDGER</Alias>'+
'<AmtCol>'+
'<Alias>CREDIT AMOUNT</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
// '<Group>Sundry Creditors</Group>'+
'</LEDGER2>'+
'<LEDGER>'+
'<Alias>DEBIT LEDGER</Alias>'+
'<AmtCol>'+
'<Alias>DEBIT AMOUNT</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
// '<Group>Sundry Debtors</Group>'+
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
'<VoucherList>Ne</VoucherList>'+
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
'<Alias>LEDGER</Alias>'+
'<Default>Party</Default>'+
'<Group>Sundry Debtors</Group>'+
'</LEDGER>'+
'<RoundOff>'+
'<Alias>BANK</Alias>'+
'<Default>Bank Account</Default>'+
'<Group>Bank Accounts</Group>'+
'</RoundOff>'+
'<VTYPE>>'+
'<Default>Receipt</Default>'+
'<Alias>VCH TYPE</Alias>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

DAYBOOK = '<Voucher>'+
'<Data>'+
'<VoucherList>Ne</VoucherList>'+
//'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'</Data>'+
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
'<Default>Journal</Default>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

MYSALE = '<Voucher>'+
'<Data>'+
'<VoucherList>Annex_II</VoucherList>'+
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

'<DATE>'+
'<Alias>Date</Alias>'+
'</DATE>'+
'<NARRATION>'+
'<Alias>Narration</Alias>'+
'</NARRATION>'+

'+<LEDGER>'+
'<Alias>Ledger</Alias>'+
'<Group>Sundry Debtors</Group>'+
'<AmtCol>'+
'<Alias>Bill Value</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<GSTN>TIN Number</GSTN>'+
'</LEDGER>'+

'+<LEDGER2>'+
'<Default>VAT Sales 5%</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>VAT Sales 5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER2>'+
'+<LEDGER3>'+
'<Default>Output Tax 5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>VAT Output 5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER3>'+

'+<LEDGER4>'+
'<Default>VAT Sales 14.5%</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>VAT Sales 14_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER4>'+
'+<LEDGER5>'+
'<Default>Output Tax 14.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>VAT Output 14_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER5>'+
'+<LEDGER6>'+
'<AmtCol>'+
'<Alias>Sales Exempted</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER6>'+

'+<LEDGER7>'+
'<Default>CST Sales @ 5%</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>CST Sales 5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER7>'+
'+<LEDGER8>'+
'<Default>CST Output @ 5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CST Output 5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER8>'+

'+<LEDGER9>'+
'<Default>CST Sales @ 14.5%</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>CST Sales 14_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER9>'+
'+<LEDGER10>'+
'<Default>CST Output @ 14.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CST Output 14_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER10>'+

'+<LEDGER11>'+
'<Default>CST Sales @ 2%</Default>'+
'<Group>Sales Accounts</Group>'+
'<AmtCol>'+
'<Alias>CST Sales 2</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER11>'+
'+<LEDGER12>'+
'<Default>CST Output @ 2%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CST Output 2</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER12>'+

'+<LEDGER13>'+
'<AmtCol>'+
'<Alias>Service Tax</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER13>'+
'+<LEDGER14>'+
'<AmtCol>'+
'<Alias>Service Tax Payable</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER14>'+

'+<LEDGER15>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Expenses</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER15>'+

'+<LEDGER16>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER16>'+

'<VTYPE>>'+
'<Default>Sales</Default>'+
'</VTYPE>'+
'</Voucher>';

MYPURC = '<Voucher>'+
'<Data>'+
'<VoucherList>Annex_I</VoucherList>'+
'<DefaultGroup>Sundry Creditors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<VoucherNo>'+
'<Alias>Voucher No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Voucher Ref</Alias>'+
'</VoucherRef>'+

'<DATE>'+
'<Alias>Date</Alias>'+
'</DATE>'+
'<NARRATION>>'+
'<Alias>Narration</Alias>'+
'</NARRATION>'+

'+<LEDGER>'+
'<Alias>Ledger</Alias>'+
'<Group>Sundry Creditors</Group>'+
'<AmtCol>'+
'<Alias>Bill Value</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<GSTN>TIN Number</GSTN>'+
'</LEDGER>'+

'+<LEDGER2>'+
'<Default>VAT Purchase 5%</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>VAT Purchase 5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER2>'+
'+<LEDGER3>'+
'<Default>Input Tax 5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>VAT Input 5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER3>'+

'+<LEDGER4>'+
'<Default>VAT Purchase 14.5%</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>VAT Purchase 14_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER4>'+
'+<LEDGER5>'+
'<Default>Input Tax 14_5</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>VAT Input 14_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER5>'+
'+<LEDGER6>'+
'<AmtCol>'+
'<Alias>Purchase Exempted</Alias>'+
'<Group>Purchase Accounts</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER6>'+

'+<LEDGER7>'+
'<Default>CST Purchase @ 5%</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>CST Purchase 5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER7>'+
'+<LEDGER8>'+
'<Default>CST Input @ 5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CST Input 5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER8>'+

'+<LEDGER9>'+
'<Default>CST Purchase @ 14.5%</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>CST Purchase 14_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER9>'+
'+<LEDGER10>'+
'<Default>CST Input @ 14.5%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CST Input 14_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER10>'+

'+<LEDGER11>'+
'<Default>CST Purchase @ 2%</Default>'+
'<Group>Purchase Accounts</Group>'+
'<AmtCol>'+
'<Alias>CST Purchase 2</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER11>'+
'+<LEDGER12>'+
'<Default>CST Input @ 2%</Default>'+
'<Group>Duties &amp; Taxes</Group>'+
'<AmtCol>'+
'<Alias>CST Input 2</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER12>'+

'+<LEDGER13>'+
'<AmtCol>'+
'<Alias>Service Tax</Alias>'+
'<Group>Purchase Accounts</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER13>'+
'+<LEDGER14>'+
'<AmtCol>'+
'<Alias>Service Tax Input</Alias>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER14>'+

'+<LEDGER15>'+
'<AmtCol>'+
'<Alias>Discount</Alias>'+
'<Group>Indirect Incomes</Group>'+
'<Type>Cr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER15>'+
'+<LEDGER16>'+
'<AmtCol>'+
'<Alias>Delivery Charges</Alias>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'</AmtCol>'+
'</LEDGER16>'+

'<VTYPE>>'+
'<Default>Purchase</Default>'+
'</VTYPE>'+
'</Voucher>';

FINANCE = '<Voucher>'+
'<Data>'+
'<VoucherList>Ne</VoucherList>'+
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
'+<LEDGER2>'+
'<Default>Fund Account</Default>'+
'<Group>Current Liabilities</Group>'+
'<Alias>LEDGER</Alias>'+
'+</LEDGER2>'+
'<VTYPE>>'+
'<Default>Receipt</Default>'+
'</VTYPE>'+
'<NARRATION>>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

GSTSALE = '<Voucher>'+
'<Data>'+
'<VoucherList>Annex_II</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<VoucherNo>'+
'<Alias>Invoice_No</Alias>'+
'</VoucherNo>'+

'<RoundOff>'+
'<Alias>Name_of_buyer</Alias>'+
'<Group>Sundry Debtors</Group>'+
'<GSTN>Buyer_TIN</GSTN>'+
'</RoundOff>'+

'<ID>'+
 '<Alias>Invoice_No</Alias>'+
'</ID>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+
'<NARRATION>>'+
'<Alias>Invoice_No</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Tax_rate</Alias>'+
'<Default>Sales Account</Default>'+
'<Group>Sales Accounts</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>0</Token>'+
'<Value>Sales Account</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>GST Sales 2%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>GST Sales 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12</Token>'+
'<Value>GST Sales 12%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>18</Token>'+
'<Value>GST Sales 18%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>28</Token>'+
'<Value>GST Sales 28%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>Sales_Value</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER2>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>Output SGST 1%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output SGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12</Token>'+
'<Value>Output SGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>18</Token>'+
'<Value>Output SGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>28</Token>'+
'<Value>Output SGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Sales_Value</Assessable>'+
'</LEDGER2>'+

'<LEDGER3>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>Output CGST 1%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output CGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12</Token>'+
'<Value>Output CGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>18</Token>'+
'<Value>Output CGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>28</Token>'+
'<Value>Output CGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>CGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Sales_Value</Assessable>'+
'</LEDGER3>'+

'<LEDGER4>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>Output IGST 2%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>Output IGST 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12</Token>'+
'<Value>Output IGST 12%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>18</Token>'+
'<Value>Output IGST 18%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>28</Token>'+
'<Value>Output IGST 28%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Sales_Value</Assessable>'+
'</LEDGER4>'+

'<VTYPE>>'+
'<Default>Sales</Default>'+
'</VTYPE>'+
'</Voucher>';

GSTPURC = '<Voucher>'+
'<Data>'+
'<VoucherList>Annex_I</VoucherList>'+
'<DefaultGroup>Sundry Creditors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<VoucherNo>'+
'<Alias>Invoice_No</Alias>'+
'</VoucherNo>'+

'<RoundOff>'+
'<Alias>Name_of_seller</Alias>'+
'<Group>Sundry Creditors</Group>'+
'<GSTN>Seller_TIN</GSTN>'+
'</RoundOff>'+

'<ID>'+
 '<Alias>Invoice_No</Alias>'+
'</ID>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+
'<NARRATION>>'+
'<Alias>Invoice_No</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Tax_rate</Alias>'+
'<Default>Purchase Account</Default>'+
'<Group>Purchase Accounts</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>0</Token>'+
'<Value>Purchase Account</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>GST Purchase 2%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>GST Purchase 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12</Token>'+
'<Value>GST Purchase 12%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>18</Token>'+
'<Value>GST Purchase 18%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>28</Token>'+
'<Value>GST Purchase 28%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>Purchase_Value</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER2>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>Input SGST 1%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input SGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12</Token>'+
'<Value>Input SGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>18</Token>'+
'<Value>Input SGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>28</Token>'+
'<Value>Input SGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Purchase_Value</Assessable>'+
'</LEDGER2>'+

'<LEDGER3>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>Input CGST 1%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input CGST 2.5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12</Token>'+
'<Value>Input CGST 6%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>18</Token>'+
'<Value>Input CGST 9%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>28</Token>'+
'<Value>Input CGST 14%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>CGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Purchase_Value</Assessable>'+
'</LEDGER3>'+

'<LEDGER4>'+
'<Group>Duties &amp; Taxes</Group>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>2</Token>'+
'<Value>Input IGST 2%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>5</Token>'+
'<Value>Input IGST 5%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>12</Token>'+
'<Value>Input IGST 12%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>18</Token>'+
'<Value>Input IGST 18%</Value>'+
'</Dict>'+
'<Dict>'+
'<TokenCol>1</TokenCol>'+
'<Token>28</Token>'+
'<Value>Input IGST 28%</Value>'+
'</Dict>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Purchase_Value</Assessable>'+
'</LEDGER4>'+

'<VTYPE>>'+
'<Default>Purchase</Default>'+
'</VTYPE>'+
'</Voucher>';

implementation

end.

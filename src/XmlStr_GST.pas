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
'<Alias>Credit_Ledger</Alias>'+
'<AmtCol>'+
'<Alias>AMOUNT</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Group>'+
'<Default>Bank Accounts</Default>'+
'</Group>'+
'</LEDGER>'+
'<LEDGER>'+
'<Default>Cash</Default>'+
'<Alias>Debit_Ledger</Alias>'+
'<AmtCol>'+
'<Alias>AMOUNT</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Group>'+
'<Default>Bank Accounts</Default>'+
'</Group>'+
'</LEDGER>'+
'<VTYPE>'+
'<Default>Contra</Default>'+
'</VTYPE>'+
'<NARRATION>'+
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
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
'</BillRef>'+
'<RoundOff>'+
'<Alias>Receipt_Ledger</Alias>'+
'<Group>'+
'<Default>Bank Accounts</Default>'+
'</Group>'+
'</RoundOff>'+
'+<LEDGER>'+
'<Alias>Party_Ledger</Alias>'+
'<AmtCol>'+
'<Alias>Receipt_Amount</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Group>'+
'<Alias>Party_Group</Alias>'+
'<Default>Suspense A/c</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'</LEDGER>'+
'<ChequeNo>'+
'<Alias>ChequeNo</Alias>'+
'</ChequeNo>'+
'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Receipt</Default>'+
'</VTYPE>'+
'<NARRATION>'+
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
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
'</BillRef>'+
'<RoundOff>'+
'<Alias>Payment_Ledger</Alias>'+
'<Group>'+
'<Default>Bank Accounts</Default>'+
'</Group>'+
'</RoundOff>'+
'<LEDGER>'+
'<Alias>Party_Ledger</Alias>'+
'<AmtCol>'+
'<Alias>Payment_Amount</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+


'<Group>'+
'<Alias>Party_Group</Alias>'+
'<Default>Suspense A/c</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'</LEDGER>'+
'<ChequeNo>'+
'<Alias>ChequeNo</Alias>'+
'</ChequeNo>'+
'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Payment</Default>'+
'</VTYPE>'+
'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

JRNL = '<Voucher>'+
'<Data>'+
'<VoucherList>Journal</VoucherList>'+
//'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<VoucherRef>'+
'<Alias>Voucher_Ref</Alias>'+
'</VoucherRef>'+

'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<VoucherNo>'+
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
'</BillRef>'+
'<LEDGER>'+
'<Alias>Credit_Ledger</Alias>'+
'<AmtCol>'+
'<Alias>AMOUNT</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Group>'+
'<Alias>CREDIT_GROUP</Alias>'+
'<Default>Suspense A/c</Default>'+
'</Group>'+
'</LEDGER>'+
'<LEDGER>'+
'<Alias>Debit_Ledger</Alias>'+
'<AmtCol>'+
'<Alias>AMOUNT</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Group>'+
'<Alias>DEBIT_GROUP</Alias>'+
'<Default>Suspense A/c</Default>'+
'</Group>'+
'</LEDGER>'+
'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Journal</Default>'+
'</VTYPE>'+
'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

BANK = '<Voucher>'+
'<Data>'+
'<VoucherList>Bank</VoucherList>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'<KeyCol>CrAmtCol</KeyCol>'+
'<KeyCol>DrAmtCol</KeyCol>'+
'<KeyCol>NARRATION</KeyCol>'+
'<KeyCol>ID</KeyCol>'+
'<KeyCol>DATE</KeyCol>'+
'<ListCol>NARRATION</ListCol>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'<IsGenerated>Yes</IsGenerated>'+
'<IsBank>Yes</IsBank>'+
'</ID>'+

'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<VoucherNo>'+
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
'</BillRef>'+
'<LEDGER>'+
'<Alias>LEDGER</Alias>'+
'<Default>Suspense</Default>'+
'<Group>Suspense A/c</Group>'+
'</LEDGER>'+
'<CrAmtCol>'+
'<Alias>DEPOSITS</Alias>'+
'<Type>BReceipt</Type>'+
'</CrAmtCol>'+
'<DrAmtCol>'+
'<Alias>WITHDRAWALS</Alias>'+
'<Type>BPayment</Type>'+
'</DrAmtCol>'+
'<ChequeNo>'+
'<Alias>ChequeNo</Alias>'+
'</ChequeNo>'+

'<RoundOff>'+
'<Alias>BANK_LEDGER</Alias>'+
'<Default>Bank Account</Default>'+
'<Group>'+
'<Default>Bank Accounts</Default>'+
'</Group>'+
'</RoundOff>'+

'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Journal</Default>'+
'</VTYPE>'+
'<NARRATION>'+
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
'<IsDaybook>Yes</IsDaybook>'+
'</ID>'+

'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<VoucherNo>'+
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<CrAmtCol>'+
'<Alias>CREDIT_AMOUNT</Alias>'+
'</CrAmtCol>'+
'<DrAmtCol>'+
'<Alias>DEBIT_AMOUNT</Alias>'+
'</DrAmtCol>'+

'<LEDGER>'+
'<Alias>LEDGER</Alias>'+
'<Group>'+
'<Alias>GROUP</Alias>'+
' </Group>'+
'</LEDGER>'+
'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Journal</Default>'+
'</VTYPE>'+
'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

MYSALE = '<Voucher>'+
'<Data>'+
'<VoucherList>MySales</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'<KeyCol>VoucherRef</KeyCol>'+
'<KeyCol>Sales_Value</KeyCol>'+
'<KeyCol>Invoice_Date</KeyCol>'+
'</Data>'+

'<VoucherNo>'+
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Invoice_No</Alias>'+
'<IsReference>Yes</IsReference>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
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
'<Alias>Party_Ledger</Alias>'+
'<Group>'+
'<Default>Sundry Debtors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<AliasName>'+
'<Alias>Alias</Alias>'+
'</AliasName>'+
'</RoundOff>'+
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
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 1_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 1.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 1_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 3% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 3</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 3%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 3</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 5% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Sales 5</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 2.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 2_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 2.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 2_5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>IGST 5% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 5</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 5</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 12% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Sales 12</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 6%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 6</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 6%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 6</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 12% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 12</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 12%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 12</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 18% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Sales 18</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 9%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 9</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 9%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 9</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>IGST 18% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 18</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 18%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 18</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 28% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Sales 28</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 14%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 14</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 14%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 14</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>IGST 28% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 28</Alias>'+
'<Type>Cr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 28%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'+<LEDGER>'+
'<Default>TCS on Sales</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>TCS</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Sales</Default>'+
'</VTYPE>'+

'<INVENTORY>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<GODOWN>'+
'<Alias>Godown</Alias>'+
'</GODOWN>'+
'<BATCH>'+
'<Alias>Batch</Alias>'+
'</BATCH>'+
'<UserDesc>'+
'<Alias>UserDesc</Alias>'+
'</UserDesc>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<DiscRate>'+
'<Alias>Disc_Rate</Alias>'+
'</DiscRate>'+
'<Value>'+
'<Alias>Bill_Value</Alias>'+
'</Value>'+
'<GSTRate>'+
'<Alias>Tax_rate</Alias>'+
'</GSTRate>'+
'<STATE>'+
'<Alias>State</Alias>'+
'</STATE>'+
'</INVENTORY>'+
'</Voucher>';

MYPURC = '<Voucher>'+
'<Data>'+
'<VoucherList>MyPurchase</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'<KeyCol>VoucherRef</KeyCol>'+
'<KeyCol>Purchase_Value</KeyCol>'+
'<KeyCol>Invoice_Date</KeyCol>'+
'</Data>'+

'<VoucherNo>'+
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<VoucherDate>'+
'<Alias>Voucher_Date</Alias>'+
'</VoucherDate>'+
'<VoucherRef>'+
'<Alias>Invoice_No</Alias>'+
'<IsReference>Yes</IsReference>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
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
'<Alias>Party_Ledger</Alias>'+
'<Group>'+
'<Default>Sundry Creditors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<AliasName>'+
'<Alias>Alias</Alias>'+
'</AliasName>'+
'</RoundOff>'+


'+<LEDGER>'+
'<Default>GST 3% Purchase</Default>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Purchase 3</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input SGST 1.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 1_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input CGST 1.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 1_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 3% Purchase</Default>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Purchase 3</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input IGST 3%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 3</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 5% Purchase</Default>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Purchase 5</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input SGST 2.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 2_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input CGST 2.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 2_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 5% Purchase</Default>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Purchase 5</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input IGST 5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 12% Purchase</Default>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Purchase 12</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input SGST 6%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 6</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input CGST 6%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 6</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 12% Purchase</Default>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Purchase 12</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input IGST 12%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 12</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 18% Purchase</Default>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Purchase 18</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input SGST 9%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 9</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input CGST 9%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 9</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 18% Purchase</Default>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Purchase 18</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input IGST 18%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 18</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 28% Purchase</Default>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Purchase 28</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input SGST 14%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 14</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input CGST 14%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 14</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 28% Purchase</Default>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Purchase 28</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Input IGST 28%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'+<LEDGER>'+
'<Default>TCS on Purchase</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>TCS</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Purchase</Default>'+
'</VTYPE>'+

'<INVENTORY>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<GODOWN>'+
'<Alias>Godown</Alias>'+
'</GODOWN>'+
'<BATCH>'+
'<Alias>Batch</Alias>'+
'</BATCH>'+
'<UserDesc>'+
'<Alias>UserDesc</Alias>'+
'</UserDesc>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>'+
'<Alias>Bill_Value</Alias>'+
'</Value>'+
'<GSTRate>'+
'<Alias>Tax_rate</Alias>'+
'</GSTRate>'+
'<STATE>'+
'<Alias>State</Alias>'+
'</STATE>'+
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
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Invoice_No</Alias>'+
'<IsReference>Yes</IsReference>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
'</BillRef>'+
'<DATE>'+
'<Alias>Date</Alias>'+
'</DATE>'+

'<NARRATION>'+
'<Alias>Narration</Alias>'+
'</NARRATION>'+

'<RoundOff>'+
'<Alias>Party_Ledger</Alias>'+
'<Group>'+
'<Default>Sundry Debtors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'</RoundOff>'+

'+<LEDGER>'+
'<Alias>Bill_Ledger</Alias>'+
'<Default>Sales Account</Default>'+
'<IsInvCol>Yes</IsInvCol>'+
'<AmtCol>'+
'<Alias>Bill_Value</Alias>'+
'<Group><Default>Sales Accounts</Default></Group>'+
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
'+<LEDGER>'+
'<Default>TCS on Sales</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>TCS</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Sales</Default>'+
'</VTYPE>'+

'<INVENTORY>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>'+
'<Alias>Bill_Value</Alias>'+
'</Value>'+
'<STATE>'+
'<Alias>State</Alias>'+
'</STATE>'+
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
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Invoice_No</Alias>'+
'<IsReference>Yes</IsReference>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
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
'<Alias>Party_Ledger</Alias>'+
'<Group>'+
'<Default>Sundry Debtors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'</RoundOff>'+

'+<LEDGER>'+
'<Alias>Bill_Ledger</Alias>'+
'<Default>Purchase Account</Default>'+
'<IsInvCol>Yes</IsInvCol>'+
'<AmtCol>'+
'<Alias>Bill_Value</Alias>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
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
'+<LEDGER>'+
'<Default>TCS on Purchase</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>TCS</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Purchase</Default>'+
'</VTYPE>'+

'<INVENTORY>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>'+
'<Alias>Bill_Value</Alias>'+
'</Value>'+
'<STATE>'+
'<Alias>State</Alias>'+
'</STATE>'+
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
'<Alias>Party_Ledger</Alias>'+
'<Group>Sundry Creditors</Group>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Fund Account</Default>'+
'<Group>Current Liabilities</Group>'+
'<Alias>LEDGER</Alias>'+
'+</LEDGER>'+
'<VTYPE>'+
'<Default>Receipt</Default>'+
'</VTYPE>'+
'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

GSTSALE = '<Voucher>'+
'<Data>'+
'<VoucherList>Sales</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'<KeyCol>VoucherRef</KeyCol>'+
'<KeyCol>Sales_Value</KeyCol>'+
'<KeyCol>Invoice_Date</KeyCol>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<VoucherNo>'+
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Invoice_No</Alias>'+
'<IsReference>Yes</IsReference>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
'</BillRef>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+

'<RoundOff>'+
'<Alias>Name_of_buyer</Alias>'+
'<Group>'+
'<Default>Sundry Debtors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<AmtCol>'+
'<Alias>Invoice_Amt</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<AliasName>'+
'<Alias>Alias</Alias>'+
'</AliasName>'+
'</RoundOff>'+

'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Sales_Ledger</Alias>'+
'<Group><Default>Sales Accounts</Default></Group>'+
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
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Group><Default>Sales Accounts</Default></Group>'+
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
'<Alias>IGST_Sales_Value</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>IGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Assessable>IGST_Sales_Value</Assessable>'+
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
'+<LEDGER>'+
'<Default>TCS on Sales</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>TCS</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Sales</Default>'+
'</VTYPE>'+

'<INVENTORY>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<GODOWN>'+
'<Alias>Godown</Alias>'+
'</GODOWN>'+
'<BATCH>'+
'<Alias>Batch</Alias>'+
'</BATCH>'+
'<UserDesc>'+
'<Alias>UserDesc</Alias>'+
'</UserDesc>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<DiscRate>'+
'<Alias>Disc_Rate</Alias>'+
'</DiscRate>'+
'<GSTRate>'+
'<Alias>Tax_rate</Alias>'+
'</GSTRate>'+
'<STATE>'+
'<Alias>State</Alias>'+
'</STATE>'+
'</INVENTORY>'+
'</Voucher>';

GSTPURC = '<Voucher>'+
'<Data>'+
'<VoucherList>Purchase</VoucherList>'+
'<DefaultGroup>Sundry Creditors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'<KeyCol>VoucherRef</KeyCol>'+
'<KeyCol>Purchase_Value</KeyCol>'+
'<KeyCol>Invoice_Date</KeyCol>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<VoucherNo>'+
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<VoucherDate>'+
'<Alias>Voucher_Date</Alias>'+
'</VoucherDate>'+
'<VoucherRef>'+
'<Alias>Invoice_No</Alias>'+
'<IsReference>Yes</IsReference>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
'</BillRef>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+

'<RoundOff>'+
'<Alias>Name_of_seller</Alias>'+
'<Group>'+
'<Default>Sundry Creditors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<AmtCol>'+
'<Alias>Invoice_Amt</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'<AliasName>'+
'<Alias>Alias</Alias>'+
'</AliasName>'+
'</RoundOff>'+

'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Purchase_Ledger</Alias>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
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
'<AmtCol>'+
'<Alias>Purchase_Value</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>SGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Group><Default>Purchase Accounts</Default></Group>'+
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
'<Alias>IGST_Purchase_Value</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>IGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Assessable>IGST_Purchase_Value</Assessable>'+
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
'+<LEDGER>'+
'<Default>TCS on Purchase</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>TCS</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Purchase</Default>'+
'</VTYPE>'+

'<INVENTORY>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<GODOWN>'+
'<Alias>Godown</Alias>'+
'</GODOWN>'+
'<BATCH>'+
'<Alias>Batch</Alias>'+
'</BATCH>'+
'<UserDesc>'+
'<Alias>UserDesc</Alias>'+
'</UserDesc>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
{
'<Value>'+
'<Alias>Purchase_Value</Alias>'+
'</Value>'+
}
'<GSTRate>'+
'<Alias>Tax_rate</Alias>'+
'</GSTRate>'+
'<STATE>'+
'<Alias>State</Alias>'+
'</STATE>'+
'</INVENTORY>'+
'</Voucher>';

ACCMASTER = '<Voucher>'+
'<Data>'+
'<MasterList>LMaster</MasterList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<KeyCol>LEDGER</KeyCol>'+
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
'<ADDRESS>'+
'<Alias>Address</Alias>'+
'</ADDRESS>'+
'<ADDRESS1>'+
'<Alias>Address1</Alias>'+
'</ADDRESS1>'+
'<ADDRESS2>'+
'<Alias>Address2</Alias>'+
'</ADDRESS2>'+
'<ADDRESS3>'+
'<Alias>Address3</Alias>'+
'</ADDRESS3>'+
'<ADDRESS4>'+
'<Alias>Address4</Alias>'+
'</ADDRESS4>'+
'<STATE>'+
'<Alias>State</Alias>'+
'</STATE>'+
'<PINCODE>'+
'<Alias>Pincode</Alias>'+
'</PINCODE>'+
'<Mobile>'+
'<Alias>Mobile</Alias>'+
'</Mobile>'+
'<EMail>'+
'<Alias>EMail</Alias>'+
'</EMail>'+
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
'<MAILINGNAME>'+
'<Alias>PartNo</Alias>'+
'</MAILINGNAME>'+
'<HSN>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<O_BATCH>'+
'<Alias>O_Batch</Alias>'+
'</O_BATCH>'+
'<UserDesc>'+
'<Alias>ItemDesc</Alias>'+
'</UserDesc>'+
'<GSTRate>'+
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
'<MRPRATE>'+
'<Alias>MRP_Rate</Alias>'+
'</MRPRATE>'+
'<GROUP>'+
'<Alias>Group</Alias>'+
'</GROUP>'+
'<SUBGROUP>'+
'<Alias>SubGroup</Alias>'+
'</SUBGROUP>'+
'<GODOWN>'+
'<Alias>Godown</Alias>'+
'</GODOWN>'+
'<CATEGORY>'+
'<Alias>Category</Alias>'+
'</CATEGORY>'+
'</ITEM>'+
'</Voucher>';

CNOTE = '<Voucher>'+
'<Data>'+
'<VoucherList>CNote</VoucherList>'+
'<DefaultGroup>Sundry Debtors</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'<KeyCol>VoucherRef</KeyCol>'+
'<KeyCol>Sales_Value</KeyCol>'+
'<KeyCol>Invoice_Date</KeyCol>'+
'</Data>'+

'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<VoucherDate>'+
'<Alias>Voucher_Date</Alias>'+
'</VoucherDate>'+
'<VoucherNo>'+
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Invoice_No</Alias>'+
'<IsReference>Yes</IsReference>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
'</BillRef>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+

'<RoundOff>'+
'<Alias>Name_of_buyer</Alias>'+
'<Group>'+
'<Default>Sundry Debtors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'</RoundOff>'+

'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Sales_Ledger</Alias>'+
'<Group><Default>Sales Accounts</Default></Group>'+
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
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>CGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Alias>Sales_Ledger</Alias>'+
'<Group><Default>Sales Accounts</Default></Group>'+
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
'<Alias>IGST_Sales_Value</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>IGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Type>Dr</Type>'+
'</AmtCol>'+
'<Assessable>IGST_Sales_Value</Assessable>'+
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

'<VTYPE>'+
'<Default>Credit Note</Default>'+
'</VTYPE>'+

'<INVENTORY>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<BATCH>'+
'<Alias>Batch</Alias>'+
'</BATCH>'+
'<UserDesc>'+
'<Alias>UserDesc</Alias>'+
'</UserDesc>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>'+
'<Alias>Return Value</Alias>'+
'</Value>'+
'<GSTRate>'+
'<Alias>Tax_rate</Alias>'+
'</GSTRate>'+
'<STATE>'+
'<Alias>State</Alias>'+
'</STATE>'+
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
'<VoucherDate>'+
'<Alias>Voucher_Date</Alias>'+
'</VoucherDate>'+
'<VoucherNo>'+
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Invoice_No</Alias>'+
'<IsReference>Yes</IsReference>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
'</BillRef>'+
'<DATE>'+
'<Alias>Invoice_Date</Alias>'+
'</DATE>'+

'<RoundOff>'+
'<Alias>Name_of_seller</Alias>'+
'<Group>'+
'<Default>Sundry Creditors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'</RoundOff>'+

'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+

'<LEDGER>'+
'<Alias>Purchase_Ledger</Alias>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
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
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Default>cGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Type>Cr</Type>'+
'</AmtCol>'+
'<Assessable>Return Value</Assessable>'+
'</LEDGER>'+

'<LEDGER>'+
'<Alias>Purchase_Ledger</Alias>'+
'<Group><Default>Purchase Accounts</Default></Group>'+
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
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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

'<VTYPE>'+
'<Default>Debit Note</Default>'+
'</VTYPE>'+

'<INVENTORY>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<BATCH>'+
'<Alias>Batch</Alias>'+
'</BATCH>'+
'<UserDesc>'+
'<Alias>UserDesc</Alias>'+
'</UserDesc>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>'+
'<Alias>Return Value</Alias>'+
'</Value>'+
'<GSTRate>'+
'<Alias>Tax_rate</Alias>'+
'</GSTRate>'+
'<STATE>'+
'<Alias>State</Alias>'+
'</STATE>'+
'</INVENTORY>'+
'</Voucher>';

StkJrnl = '<Voucher>'+
'<Data>'+
'<StkVchList>StkJrnl</StkVchList>'+
//'<DefaultGroup>Primary Batch</DefaultGroup>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+

'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<CrITEM>'+
'<Alias>Out Item</Alias>'+
'</CrITEM>'+
'<CrGODOWN>'+
'<Alias>Out Godown</Alias>'+
'</CrGODOWN>'+
'<CrBATCH>'+
'<Alias>Out Batch</Alias>'+
'</CrBATCH>'+
'<CrUNIT>'+
'<Alias>Out Unit</Alias>'+
'</CrUNIT>'+
'<CrQTY>'+
'<Alias>Out Qty</Alias>'+
'</CrQTY>'+
'<CrRATE>'+
'<Alias>Out Rate</Alias>'+
'</CrRATE>'+
'<CrAMOUNT>'+
'<Alias>Out Amount</Alias>'+
'</CrAMOUNT>'+

'<DrITEM>'+
'<Alias>In Item</Alias>'+
'</DrITEM>'+
'<DrGODOWN>'+
'<Alias>In Godown</Alias>'+
'</DrGODOWN>'+
'<DrBATCH>'+
'<Alias>In Batch</Alias>'+
'</DrBATCH>'+
'<DrUNIT>'+
'<Alias>In Unit</Alias>'+
'</DrUNIT>'+
'<DrQTY>'+
'<Alias>In Qty</Alias>'+
'</DrQTY>'+
'<DrRATE>'+
'<Alias>In Rate</Alias>'+
'</DrRATE>'+
'<DrAMOUNT>'+
'<Alias>In Amount</Alias>'+
'</DrAMOUNT>'+
'<VTYPE>'+
'<Default>Journal</Default>'+
'</VTYPE>'+
'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';

MYCNOTE = '<Voucher>'+
'<Data>'+
'<VoucherList>MySales</VoucherList>'+
'<DefaultGroup>SunCry Debtors</DefaultGroup>'+
'<IsMultiRow>No</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+

'<VoucherDate>'+
'<Alias>Voucher_Date</Alias>'+
'</VoucherDate>'+
'<VoucherNo>'+
'<Alias>Voucher_No</Alias>'+
'</VoucherNo>'+
'<VoucherRef>'+
'<Alias>Invoice_No</Alias>'+
'<IsReference>Yes</IsReference>'+
'</VoucherRef>'+
'<BillRef>'+
'<Alias>Bill_Ref</Alias>'+
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
'<Alias>Party_Ledger</Alias>'+
'<Group>'+
'<Default>SunCry Debtors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+

'</RoundOff>'+
'+<LEDGER>'+
'<Default>GST 3% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Sales 3</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 1.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 1_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 1.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 1_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 3% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 3</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 3%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 3</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 5% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Sales 5</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 2.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 2_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 2.5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 2_5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>IGST 5% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 5</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 5%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 5</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 12% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Sales 12</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 6%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 6</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 6%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 6</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>IGST 12% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 12</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 12%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 12</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 18% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Sales 18</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 9%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 9</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 9%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 9</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>IGST 18% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 18</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 18%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST Tax 18</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+

'+<LEDGER>'+
'<Default>GST 28% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>GST Sales 28</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output SGST 14%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST Tax 14</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output CGST 14%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST Tax 14</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>IGST 28% Sales</Default>'+
'<Group><Default>Sales Accounts</Default></Group>'+
'<AmtCol>'+
'<Alias>IGST Sales 28</Alias>'+
'<Type>Dr</Type>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<Default>Output IGST 28%</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
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
'<Alias>GST Sales Exempted</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'<IsInvCol>Yes</IsInvCol>'+
'</AmtCol>'+
'</LEDGER>'+
'+<LEDGER>'+
'<AmtCol>'+
'<Alias>IGST Sales Exempted</Alias>'+
'<Group>Sales Accounts</Group>'+
'<Type>Dr</Type>'+
'<IsLedgerName>Yes</IsLedgerName>'+
'<IsInvCol>Yes</IsInvCol>'+
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

'<VTYPE>'+
'<Alias>VTYPE</Alias>'+
'<Default>Sales</Default>'+
'</VTYPE>'+

'<INVENTORY>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<HSN>'+
'<Alias>HSN</Alias>'+
'</HSN>'+
'<GODOWN>'+
'<Alias>Godown</Alias>'+
'</GODOWN>'+
'<BATCH>'+
'<Alias>Batch</Alias>'+
'</BATCH>'+
'<UserDesc>'+
'<Alias>UserDesc</Alias>'+
'</UserDesc>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'<Value>'+
'<Alias>Bill_Value</Alias>'+
'</Value>'+
'<STATE>'+
'<Alias>State</Alias>'+
'</STATE>'+
'</INVENTORY>'+
'</Voucher>';

StkIn = '<Voucher>'+
'<Data>'+
'<InOutVchList>InOut</InOutVchList>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<REFNO>'+
'<Alias>Ref_No</Alias>'+
'</REFNO>'+
'<REFDATE>'+
'<Alias>Ref_Date</Alias>'+
'</REFDATE>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<GODOWN>'+
'<Alias>Godown</Alias>'+
'</GODOWN>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'+<LEDGER>'+
'<Alias>Party_Ledger</Alias>'+
'<Group>'+
'<Default>SunCry Debtors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<IsInvCol>Yes</IsInvCol>'+
'<AmtCol>'+
'<Alias>Amount</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<LEDGER>'+
'<Default>SGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<LEDGER>'+
'<Default>CGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<LEDGER>'+
'<Default>IGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<VTYPE>'+
'<Default>Journal</Default>'+
'</VTYPE>'+
'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';
StkOut = '<Voucher>'+
'<Data>'+
'<InOutVchList>InOut</InOutVchList>'+
'<IsMultiRow>Yes</IsMultiRow>'+
'<IsMultiColumn>Yes</IsMultiColumn>'+
'</Data>'+
'<ID>'+
'<Alias>ID</Alias>'+
'</ID>'+
'<DATE>'+
'<Alias>DATE</Alias>'+
'</DATE>'+
'<REFNO>'+
'<Alias>Ref_No</Alias>'+
'</REFNO>'+
'<REFDATE>'+
'<Alias>Ref_Date</Alias>'+
'</REFDATE>'+
'<ITEM>'+
'<Alias>Item</Alias>'+
'</ITEM>'+
'<GODOWN>'+
'<Alias>Godown</Alias>'+
'</GODOWN>'+
'<UNIT>'+
'<Alias>Unit</Alias>'+
'</UNIT>'+
'<QTY>'+
'<Alias>Qty</Alias>'+
'</QTY>'+
'<RATE>'+
'<Alias>Rate</Alias>'+
'</RATE>'+
'+<LEDGER>'+
'<Alias>Party_Ledger</Alias>'+
'<Group>'+
'<Default>SunCry Debtors</Default>'+
'</Group>'+
'<GSTN>'+
'<Alias>GSTN</Alias>'+
'</GSTN>'+
'<IsInvCol>Yes</IsInvCol>'+
'<AmtCol>'+
'<Alias>Amount</Alias>'+
'<Type>Dr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<LEDGER>'+
'<Default>SGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>SGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<LEDGER>'+
'<Default>CGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>CGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<LEDGER>'+
'<Default>IGST</Default>'+
'<Group>'+
'<Default>Duties &amp; Taxes</Default>'+
'</Group>'+
'<AmtCol>'+
'<Alias>IGST</Alias>'+
'<Type>Cr</Type>'+
'</AmtCol>'+
'</LEDGER>'+
'<VTYPE>'+
'<Default>Journal</Default>'+
'</VTYPE>'+
'<NARRATION>'+
'<Alias>NARRATION</Alias>'+
'</NARRATION>'+
'</Voucher>';
implementation

end.

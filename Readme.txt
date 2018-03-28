Excel to Tally

What it does
Exports data (Accounting vouchers) from Excel  to Tally.

Works in 'Create' mode.

How it does
Converts Excel data into Vouchers using Xml rules.
Uses VchUpdate.dll to post vouchers to Tally

What it does not do
It does not modify of existing vouchers or synchronize data.
It does not check for the correctness of entries or calculation.

Architecture
Collection of vouchers are posted at one go through predefined templates.
Template:
	Each worksheet is a template and a database. Not a PROGRAM. Column Names trigger actions to post data in the columns to Tally. The names are linked to Xml rules. Irrelevant columns are mostly not colored to differentiate. Each row in a worksheet has all the data necessary to build a voucher. Exception is Daybook.
scalable Design:
Columns can be added without coding.
Scope and Limitation
Easy of use and greater applicability rather than flexibility and corner cases are kept in mind when designing templates.

Who needs this software
	The software is ideal for importing third party data to Tally. End users rather than programmers.

Requirement
	MS Office (Excel) or MS ADO library (free)
ADO Library = Microsoft Access Database Engine 2016 Redistributable.
Windows 7 users are encouraged to install Microsoft Access Database Engine 2016 Redistributable

Known Incompatibility
	This is a 32 Bit tool. With 64 bit Ado provider / S Excel fails.  


How to use
    Tally should be running.
	Required company should be active.
    Open Samples.xls in Data folder
    Select appropriate Worksheet.
    Copy data in the appropriate columns
    CLOSE the xls file.
In Excel to Tally
    Enter Excel file name if some other file name is desired
	Select Voucher type from combo
 	Click Post

Result
After processing you will get a message as to the number of vouchers processed and number of successes. Error details is appended to Log Worksheet. When importing, Tally records these error details in Tally.imp file.

Ledger Master
The Ledger master is created automatically if it does not exist in Tally.
Exception is when it could not guess Group  in Journal and Daybook template.
So for Journal create the Ledger first before posting Vouchers.
In Daybook worksheet there are optional Group column to help Master creation.

Possible errors:
        Tally is not running or two or more Tally are open.
        Firewall blocking port 
	Insufficient User Access Rights to Data folder in Windows 7 etc
        Typo in file name
        Typos  in Worksheet Column names
        Ado component not installed: Install MS Office or Download and Insall free
        MS ADO Database Engine Redistributable
        Wrong Excel file or Worksheet :-(
        Company active is not target company :-(
        Posting the same data multiple times.

Silent failure happens
1. Due to Educational version limitation.
2. Invalid Cell Format.
This happens more when some Pdf to Excel software is used.
Hint:
	Invoice_No is Text
	Date should be in
		1. Date format
			or
		2. in Text mode either as yyyymmdd or Indian (for eg dd-mm-yyyy)
	Amount is Number
	and so on

About last updates
Programmable Excel to Tally
Extend with out writing code.
Just a few lines of  Xml will do.
For example extend  Journal template  by adding more columns with default groups  or  groups columns.
For details write to excel2tallyerp@ gmail.com.
Inventory in Sales and Purchase
GST ready
Speed improvement when thousands of ledgers exist in Tally.

When reporting error please describe the environment
      Operating System - 32 / 64
      Processor
      MS Office Version
      Firewall, Anti Virus etc
Send Sample.xls file to test and Tally.imp also.

ToDo
1. Substitution Table for automatically created ledgers.
2. Rule based validation


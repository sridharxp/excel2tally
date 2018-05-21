Excel to Tally
Copyright (C) 2013, Sridharan S,
+91 98656 82910,
excel2tallyerp@ gmail.com

What it does
Exports data (Accounting vouchers) from Excel  to Tally.
Works in 'Create' mode.

How it does
Converts Excel data rows Vouchers using Xml rules.
Uses VchUpdate.dll to post vouchers to Tally.

What it does not do
It does not modify of existing vouchers or synchronize data.
It does not check for the correctness of entries or calculation.

Design:
Tally creates / replaces entire document in Data mode.
Template:
	Each worksheet is a template that also holds data
Do not change worksheet name or Column names.
Multi line vouchers like Daybook need  ID column to find start and end rows. Sales and Purchase vouchers need Date values in addition.
The Ledger master is created automatically if it does not exist in Tally. This fails when it could not guess Group  in Journal and Daybook template.

Scope and Limitation
Easy of use and greater applicability rather than flexibility.

Who needs this software
	The software is ideal for importing third party data to Tally. Accountants are largest users.

Requirement
	MS ADO library (free)
ADO Library = Microsoft Access Database Engine Redistributable.
Versions: 2016 / 2010

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

Possible source of errors:
        Tally is not running or two or more Tally are open.
        Firewall blocking port 
	Insufficient User Access Rights to Data folder in Windows 7 etc
        Typo in file name
        Typos  in Worksheet Column names
        Ado component not installed: 
	Download and Install free MS ADO Database Engine Redistributable
        Wrong Excel file or Worksheet :-(
        Company active is not target company :-(
        Posting the same data multiple times.

Silent failure happens
1. When Voucher date is out of range to Tally accounting period.
2. Due to Educational version limitation.
3. Invalid Cell Format.
This happens more in Date formats when some Pdf to Excel software is used.
Hint:
Any cell value not to be used for any calculations like GSTN No should better be Text. Text or date information formatted as numeric will fail. So, 
	Invoice_No is Text
	Date should be in
		1. Date format
			or
		2. in Text mode either as yyyymmdd or Indian (for eg dd-mm-yyyy)
	Amount is Number
Text format works for all types.

About last updates
Item Master Export
Nerge Duplicate Ledger

When reporting error please describe the environment
      Operating System - 32 / 64
      Processor
      MS Office Version
      Firewall, Anti Virus etc
Send Sample.xls file to test and Tally.imp also.

Write to us your suggestions.
Bug fix gets highest priority.
If a feature benefits large number of users it is done before others.
Feature requests from paid customers are the next.
Always implementation is done with easy usage in mind.
So some requests may wait for good design.
ToDo
1. Ledger Master Export
2. Substitution Table for automatically created ledgers.

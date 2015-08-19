Excel to Tally
Copyright (C) 2013, Sridharan S, 
+91 98656 82910,
aurosridhar@ gmail.com 

Exports data from Excel and Jet (mdb) to Tally.

Converts Excel rows and columns into Vouchers using Xml rules.
Uses VchUpdate.dll to post vouchers to Tally

Most accounting vouchers can be exported,

Requirement
	MS Excel or MS ADO library
	Excel Worksheet WorkSheet, Column Names should not be changed.

How to use
	Tally should be active
	Required company should be open
	Enter data to worksheet columns
Open the application.
In Excel to Tally 
	Enter your Excel file name if changed.
 	click Post

If everything goes well you will get a message finally
as to the number of vouchers processed.

Possible errors:
        Tally is not open or two or more Tally are open,
        Firewall blocking port.
        Error in file name
        Typos  in Worksheet Column names         Ado component not available in the system.
        Wrong Excel file or Worksheet :-(.
        Open company is not target company :-(.
      Posting the same data multiple times.	

When reporting error please describe the environment
      Operating System - 32 / 64
      Processor
      MS Office Version
      MS ADO Database Engine 32 / 64 Redistributable
      Firewall, Anti Virus etc
Excel to Tally
Copyright (C) 2013, Sridharan S, aurosridhar at gmail dot com

Free Software. Free to use and redistribute.
Redistribute he entire archive.

Exports data from Excel and Jet (mdb) to Tally.

Converts Excel rows and columns into Vouchers using Xml rules.
Uses VchUpdate.dll to post vouchers to Tally

Most accounting (with Inventory) vouchers can be exported,

Requirement
	MS Excel or MS ADO library
	Excel Worksheet Column Names should not be changed.

How to use
	Tally should be active
	Required company should be open
	Enter data to worksheet coumns
Open the application.
In Excel to Tally 
	Enter your Excel file name if changed.
	Enter your Worksheet name in Table name if changed.
 	click Post

If everything goes well you will get a message finally
as to the number of vouchers processed.

Possible errors:
        Tally is not open or two or more Tally are open,
        Firewall blocking port.
        Error in file name
        Typos (Worksheet Column names are case sensitive).
        Ado component not available in the system.
        Wrong Exccel file or Worksheet :-(.
        Open company is not target company :-(.	
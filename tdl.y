%{
(*
Copyright (C) 2014, Sridharan S

This file is part of Excel to Tally.

Excel to Tally is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Excel to Tally is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License version 3
along with Excel to Tally.  If not, see <http://www.gnu.org/licenses/>.
*)
unit tdl;

interface

uses
  SysUtils, LexLib, YaccLib, tdllex, Contnrs;
%}

%token  LSB RSB COMMA COLON QUOTE
%token TEXT QTEXT AMOUNT COMMENT SEMI
%token ALIAS AMTCOL ATYPE GROUP
%token LEDGER VDATE ID VTYPE DATA
%token BTRUE BFALSE DEFAULT
%token FOLDER DB VL MR MC
%{
type YYSType = AnsiString;
%}
%%
root:    stmt_list
        ;

stmt_list:      stmt 
        |       stmt_list stmt 
        ;                

stmt:      LSB objtype COLON objname RSB
           bson_list SEMI
	;

bson_list:      bson
        |       bson_list bson 
        ;                

bson:           attribute COLON list
        ;

attribute: ALIAS | AMTCOL | ATYPE | GROUP | DEFAULT
        | FOLDER | DB | VL | MR | MC
         ;

objtype:   DATA | LEDGER | VDATE | ID | VTYPE 
        ;

objname: TEXT
        ;

list:   TEXT
        | list COMMA TEXT
        ;

%%
end.

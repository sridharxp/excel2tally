%{
(*
{Copyright (C) 2014, Sridharan S

This file is part of Excel2 to Tally.

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
unit tdllex;

//program tdllex;
//{$APPTYPE CONSOLE}
interface

uses
  SysUtils, LexLib;

const LSB = 257;
const RSB = 258;
const COMMA = 259;
const COLON = 260;
const QUOTE = 261;
const TEXT = 262;
const QTEXT = 263;
const AMOUNT = 264;
const COMMENT = 265;
const SEMI = 266;
const ALIAS = 267;
const AMTCOL = 268;
const ATYPE = 269;
const GROUP = 270;
const LEDGER = 271;
const VDATE = 272;
const ID = 273;
const VTYPE = 274;
const DATA = 275;
const BTRUE = 276;
const BFALSE = 277;
const DEFAULT = 278;
const FOLDER = 279;
const DB = 280;
const VL = 281;
const MR = 282;
const MC = 283;
%}
WS      [ \t\n]
D       [0..9]

%start STR CMNT AVAL

 function yylex: integer;

 implementation
%%
<CMNT>\n        begin
        start(0);
        end;

<CMNT>[^\n]+   ;

\;        begin
        start(CMNT);
        return(SEMI);
        end;

<STR>\"     begin
              start(0);
              return(QUOTE);
            end;

\"          begin
              start(STR);
              return(QUOTE);
            end;

<STR>[^"\n]+   begin
                  return(QTEXT);
               end;

\[          begin
              return(LSB);
            end;

\]           begin
              return(RSB);
            end;

<AVAL>[^" \n:;,\]]+   begin
              return(TEXT);
            end;

:           begin
                start(AVAL);
              return(COLON);
            end;

\,           begin
              return(COMMA);
            end;

{D}+\.?{D}+      begin
                          return(AMOUNT);
                        end;

(I|i)(S|s)(M|m)(U|u)(L|l)(T|t)(I|i)(R|r)(O|o)(W|w)  begin
                        return(MR);
                     end;

(I|i)(S|s)(M|m)(U|u)(L|l)(T|t)(I|i)(C|c)(O|o)(L|l)(U|u)(M|m)(N|n)  begin
                        return(MC);
                     end;

(T|t)(Y|y)(P|p)(E|e) begin
                        return(ATYPE);
                     end;

(A|a)(L|l)(I|i)(A|a)(S|s)  begin
                        return(ALIAS);
                     end;

(A|a)(M|m)(T|t)(C|c)(O|o)(L|l)  begin
                        return(AMTCOL);
                     end;

(G|g)(R|r)(O|o)(U|u)(P|p)  begin
                        return(GROUP);
                     end;

(L|l)(E|e)(D|d)(G|g)(E|e)(R|r)  begin
                        return(LEDGER);
                     end;

(D|d)(A|a)(T|t)(E|e)  begin
                        return(VDATE);
                     end;

(I|i)(D|d)  begin
                        return(ID);
                     end;

(V|v)(T|t)(Y|y)(P|p)(E|e)  begin
                        return(VTYPE);
                     end;

(D|d)(A|a)(T|t)(A|a)  begin
                        return(DATA);
                     end;


(T|t)(R|r)(U|u)(E|e)  begin
                        return(BTRUE);
                     end;

(F|f)(A|a)(L|l)(S|s)(E|e)  begin
                        return(BFALSE);
                     end;

(Y|y)(E|e)(S|s)  begin
                        return(BTRUE);
                     end;

(N|n)(O|o)  begin
                        return(BFALSE);
                     end;

(D|d)(E|e)(F|f)(A|a)(L|l)(T|t)  begin
                        return(DEFAULT);
                     end;

(F|f)(O|o)(L|l)(D|d)(E|e)(R|r)  begin
                        return(FOLDER);
                     end;

(D|d)(A|a)(T|t)(A|a)(B|b)(A|a)(S|s)(E|e)  begin
                        return(DB);
                     end;

(V|v)(O|o)(U|u)(C|c)(H|h)(E|e)(R|r)(L|l)(I|i)(S|s)(T|t)  begin
                        return(VL);
                     end;

[^" \n:;,\]]+   begin
              return(TEXT);
            end;

{WS}+       start(0);

%%
//begin
//yylex;
end.


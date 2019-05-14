(*
Copyright (C) 2013, Sridharan S

This file is part of Integration Tools for Tally.

Integration Tools for Tally is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Integration Tools for Tally is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License version 3
along with Integration Tools for Tally. If not, see <http://www.gnu.org/licenses/>.
*)
unit VchLib;

interface

function PackStr(const s:string): string;

implementation

{ More generalized function than UpperCase or LowerCase functions}
// #
// !
// Space 32 Checked
// % 37 Failed
// & 38 Checked
// ( 40 Checked
// ) 41 Checked
// * 42 Checked
// + 43 Checked
// , 44 Checked
// - 45 Checked
// . 46 Checked
// / 47 Checked
// ; 59 Checked
// = 61 Checked
// @ 64 Failed
// _ 95 Failed
function PackStr(const s:string): string;
var
d: string;
i, j: Integer;
begin
j := Length(s);
SetLength(d, j);
//  d := s;
  j := 0;
  for i := 1 to Length(s) do
  begin
//    if Ord(s[i]) in [65..90, 97..122, 48..57, 37, 40, 41, 45, 46, 47, 64, 95] then
    if Ord(s[i]) in [32, 38, 40, 41, 42, 43, 44, 45, 46, 47, 59, 61] then
      Continue;
    inc(j);
    if Ord(s[i]) in [65..90] then
      d[j] := Chr(Ord(s[i]) + 32)
    else
      d[j] := s[i];
  end;
  SetLength(d, j);
  Result := d;
end;

end.

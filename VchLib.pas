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

uses SysUtils,
    StrUtils,
    Dialogs;
function PackStr(const s:string): string;
function ExtractDigits(const s:string): string;
  function StrtoHexStr(const Str: string): string;
function StrtoHexDigitStr(Str: string): string;
function SumHexStr(const str: string): string;
Function HexKey(const hstr: string): string;
function Capitalize(const s: string; const CapitalizeFirst: Boolean = True): string;

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

function ExtractDigits(const s:string): string;
var
  str: string;
  i: integer;
  StartZeros: boolean;
begin
  Startzeros := True;
  str := LowerCase(s);
  for i:= 1 to Length(str) do
  begin
    if StartZeros then
    if str[i] = '0' then
      Continue;
    if str[i] in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] then
    Result := Result + str[i]
    else
    begin
      Startzeros := True;
      continue;
    end;
    StartZeros := False;
  end;
end;

function StrtoHexStr(const Str: string): string;
const hexdigit = '0123456789ABCDEF';
var
  i, b: integer;
begin
  Result := '';
  for i := 1 to length(Str) do begin
    b := ord(Str[i]);
    Result := result +
      hexdigit[(b shr 4) and $0F + 1] + hexdigit[b and $0F + 1];
  end;
end;
function StrtoHexDigitStr(Str: string): string;
const hexdigit = '0123456789ABCDEF';
var
  i, b: integer;
  iStr: string;
begin
  Result := '';
  for i := Length(Str) downto 1 do
  begin
      if Str[i] in ['0','1','2','3','4','5','6','7','8','9'] then
        iStr := Str[i] + iStr
      else
      begin
        str := LeftSTr(Str, i);
        iStr := InttoHex(StrtoInt(istr), Length(iStr));
        break;
      end;
  end;
  for i := 1 to Length(iStr) do
  begin
    if iStr[i] <> '0' then
    begin
      iStr := copy(istr, i, Length(iStr)-i+1);
      break;
    end;
  end;
  for i := 1 to length(Str) do begin
    if Str[i] in ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'] then
    begin
      Result := result + Str[i];
      Continue;
    end;
    b := ord(Str[i]);
    Result := result +
      hexdigit[(b shr 4) and $0F + 1] + hexdigit[b and $0F + 1];
  end;
  Result := Result + iStr;
end;
function SumHexStr(const str: string): string;
var
  i: integer;
  nres, buf: integer;
begin
  if Length(str) <= 16 then
   buf := 2
  else
    buf := 3;
  for i := 1 to Length(str)do
  begin
    nres := nres + StrtoInt('$' + str[i]);
  end;
  Result := InttoHex(nres, buf);
end;
Function HexKey(const hstr: string): string;
var
  hlen: integer;
begin
  Result := StrtoHexDigitStr(hStr);
  hLen := Length(Result);
  if hLen <= 8 then
    Result := RightStr('00000000'+ Result, 8)
  else if hLen <= 22 then
    Result := SumHexStr(LeftStr(Result, hLen-6)) + RightStr(Result, 6)
  else
    Result := SumHexStr(LeftStr(Result, hLen-5)) + RightStr(Result, 5);
end;
function Capitalize(const s: string; const CapitalizeFirst: Boolean = True): string;
const
  ALLOWEDCHARS = ['a'..'z'];
var
  Idx: Integer;
  ToCapitalizeNext: Boolean;
begin
  ToCapitalizeNext := CapitalizeFirst;
  Result := LowerCase(s);
  if Result <> EmptyStr then
    for Idx := 1 to Length(Result) do
      if ToCapitalizeNext then begin
        Result[Idx] := UpCase(Result[Idx]);
        ToCapitalizeNext := False;
      end else
      if NOT (Result[Idx] in  ALLOWEDCHARS) then
        ToCapitalizeNext := True;
end;
end.

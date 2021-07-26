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
unit XlExp;

interface

type
  IbjxlExp = interface
    procedure OpenFile;
    procedure Process;
    procedure GetDefaults;
    procedure WriteStatus;
    procedure Execute;
  end;

  IbjDSLParser = interface
    procedure DeclareColName;
    procedure CheckColName;
    procedure CheckColumn(const colname: string);
  end;
  IbjMrMc = interface
    procedure NewIdLine;
    procedure ProcessRow;
    procedure ProcessCol(const level: integer);
    function IsIDChanged: boolean;
    function GetLedger(const level: integer): string;
    function GetAmt(const level: integer): currency;
    function IsMoreColumn(const level: integer): boolean;
  end;

implementation

end.

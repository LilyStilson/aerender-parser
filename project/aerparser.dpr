program aerparser;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  AErenderDataParser;

const
  TestString = 'PROGRESS:  0:00:00:00 (1): 0 Seconds';

begin
  try
    Writeln (ParseAErenderLogString(TestString).InitialMessage);
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

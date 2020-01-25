program aerparser;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  AErenderDataParser;

const
  TestString = 'PROGRESS:  0:00:03:18 (199): 0 Seconds';

var
  AERD: TAErenderFrameData;

begin
  try
    Writeln ('Initial String    = ' + TestString);

    AERD := ParseAErenderFrameLogString(TestString);

    Writeln ('Current Frame     = ' + AERD.Frame.ToString);
    Writeln ('Elapsed Time      = ' + AERD.ElapsedTime.ToString);

    Writeln;
    Writeln ('Timecode');
    Writeln ('H: ' + AERD.Timecode.H.ToString + '   M: ' + AERD.Timecode.MM.ToString + '   S: '
              + AERD.Timecode.SS.ToString + '   FR: ' + AERD.Timecode.FR.ToString);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.

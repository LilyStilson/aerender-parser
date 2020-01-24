unit AErenderDataParser;

interface

uses
  System.SysUtils;

type
  TAErenderLogType = record
    const
      Information: Integer = 0;
      Rendering: Integer = 1;
      Error: Integer = 2;
  end;

  TTimecode = record
    H, MM, SS, FR: Cardinal;
  end;

  AErenderData = record
    LogData: TAErenderLogType;
    Timecode: TTimecode;
    Frame: Cardinal;
    InitialMessage: String;
  end;

  function ParseAErenderLogString (const LogString: String): AErenderData;

implementation

function ParseAErenderLogString (const LogString: String): AErenderData;
begin
  if LogString.Contains('PROGRESS: ') then begin
    Result.InitialMessage := LogString.Replace('PROGRESS:  ', '');


  end;
end;

end.

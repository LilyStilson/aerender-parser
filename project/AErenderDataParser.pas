unit AErenderDataParser;

interface

uses
  System.SysUtils;

type
  ///<summary>
  ///A set of constants that will determine current aerender state.
  ///</summary>
  TAErenderLogType = record
    const
      Information: Integer = 0;
      Rendering: Integer = 1;
      Error: Integer = 2;
  end;

  ///<summary>
  ///Record that represents standard After Effects timecode data.
  ///</summary>
  TTimecode = record
    H, MM, SS, FR: Cardinal;
  end;

  ///<summary>
  ///Parsed aerender string data type
  ///</summary>
  TAErenderData = record
    LogData: TAErenderLogType;
    Timecode: TTimecode;
    Frame: Cardinal;
    InitialMessage: String;
  end;

  function ParseAErenderLogString (const LogString: String): TAErenderData;

implementation

function ParseAErenderLogString (const LogString: String): TAErenderData;
begin
  if LogString.Contains('PROGRESS: ') then begin
    Result.InitialMessage := LogString.Replace('PROGRESS:  ', '');
  end;
end;

end.

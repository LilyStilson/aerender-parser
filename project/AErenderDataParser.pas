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
  
  ///<summary>
  ///Parses aerender log string and returns record of it's contents
  ///</summary>
  function ParseAErenderLogString (const LogString: String): TAErenderData;

implementation

function ParseAErenderLogString (const ILogString: String): TAErenderData;
var 
  AString: String;
begin
  Result.InitialMessage := ILogString;
  AString := ILogString;
  {  AString = 'PROGRESS:  0:00:00:00 (1): 0 Seconds'  }
  if ILogString.Contains('PROGRESS: ') then begin
    //Get rid of PROGRESS response in initial string
    AString := ILogString.Replace('PROGRESS:  ', '');
    {  AString = '0:00:00:00 (1): 0 Seconds'  }

    //Read hours from timecode and remove it from temporary string
    Result.Timecode.H := StrToInt(AString[1]);
    AString.Remove(2);
    {  AString = '00:00:00 (1): 0 Seconds'  }

    //Read minutes from timecode and remove it from temporary string
    Result.Timecode.MM := StrToInt(AString[1] + AString[2]);
    AString.Remove(3);
    {  AString = '00:00 (1): 0 Seconds'  }

    //Read seconds from timecode and remove it from temporary string
    Result.Timecode.SS := StrToInt(AString[1] + AString[2]);
    AString.Remove(3);
    {  AString = '00 (1): 0 Seconds'  }

    //Read frames from timecode and remove it from temporary string
    Result.Timecode.FR := StrToInt(AString[1] + AString[2]);
    AString.Remove(4);
    {  AString = '1): 0 Seconds'  }

    //Read current render frame from timecode and remove it from temporary string
    var AFrame: String;
    var ACounter: Integer;
    for var i := 1 to Length(AString) do begin
      if not AString[i] = ')' then begin
          AFrame := AFrame + AString[i];
      end
      else
        break;
    end;
    Result.Frame := StrToInt(AFrame);
    
    {  AString = '1): 0 Seconds'  }
  end;
end;

end.

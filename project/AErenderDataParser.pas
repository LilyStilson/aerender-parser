unit AErenderDataParser;

interface
  type
    TAErenderLogType = record
      const
        Information: Integer = 0;
        Rendering: Integer = 1;
        Error: Integer = 3;
    end;

    TTimecode = record
      H, MM, SS, FR: Cardinal;
    end;

    AErenderData = record
      LogData: TAErenderLogType;
      Timecode: TTimecode;
      Frame: TFrame;
    end;

implementation

end.
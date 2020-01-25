unit AErenderDataParser;

(*        AErender Data Parser                                                              *)
(*        Lily Stilson // 2020                                                              *)
(*        MIT License                                                                       *)
(*                                                                                          *)
(*        Copyright (c) 2020 Alice Romanets                                                 *)
(*                                                                                          *)
(*        Permission is hereby granted, free of charge, to any person obtaining a copy      *)
(*        of this software and associated documentation files (the "Software"), to deal     *)
(*        in the Software without restriction, including without limitation the rights      *)
(*        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell         *)
(*        copies of the Software, and to permit persons to whom the Software is             *)
(*        furnished to do so, subject to the following conditions:                          *)
(*                                                                                          *)
(*        The above copyright notice and this permission notice shall be included in all    *)
(*        copies or substantial portions of the Software.                                   *)
(*                                                                                          *)
(*        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR        *)
(*        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,          *)
(*        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE       *)
(*        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER            *)
(*        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,     *)
(*        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     *)
(*        SOFTWARE.                                                                         *)

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
  ///Parsed aerender frame string data type.
  ///</summary>
  TAErenderFrameData = record
    Timecode: TTimecode;
    Frame: Cardinal;
    ElapsedTime: Cardinal;
    InitialMessage: String;
  end;
  
  ///<summary>
  ///Parses aerender log string and returns record of it's contents.
  ///</summary>
  function ParseAErenderFrameLogString (const ILogString: String): TAErenderFrameData;

implementation

function ParseAErenderFrameLogString (const ILogString: String): TAErenderFrameData;
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
    Delete(AString, 1, 2);
    {  AString = '00:00:00 (1): 0 Seconds'  }

    //Read minutes from timecode and remove it from temporary string
    Result.Timecode.MM := StrToInt(AString[1] + AString[2]);
    Delete(AString, 1, 3);
    {  AString = '00:00 (1): 0 Seconds'  }

    //Read seconds from timecode and remove it from temporary string
    Result.Timecode.SS := StrToInt(AString[1] + AString[2]);
    Delete(AString, 1, 3);
    {  AString = '00 (1): 0 Seconds'  }

    //Read frames from timecode and remove it from temporary string
    Result.Timecode.FR := StrToInt(AString[1] + AString[2]);
    Delete(AString, 1, 4);
    {  AString = '1): 0 Seconds'  }

    //Read current render frame from timecode and remove it from temporary string
    var AFrame: String;
    while AString[1] <> ')' do begin
      AFrame := AFrame + AString[1];
      Delete(AString, 1, 1);
    end;
    Result.Frame := StrToInt(AFrame);
    Delete(AString, 1, 3);
    {  AString = '0 Seconds'  }

    //Read elapsed time to render one frame and clear the string
    var AElapsedTime: String;
    while AString[2] <> 'S' do begin
      AElapsedTime := AElapsedTime + AString[1];
      Delete(AString, 1, 1);
    end;
    Result.ElapsedTime := StrToInt(AElapsedTime);
    {  AString = ' Seconds'  }
  end;
end;

end.

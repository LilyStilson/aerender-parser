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
    private
      {Private declartions}
    public
      /// <summary>
      /// Converts parsed timecode to string with 'H:MM:SS:FR' format
      /// </summary>
      function ToSingleString(): String;

      /// <summary>
      /// Converts parsed timecode to string with H, MM, SS, FR being separated
      /// </summary>
      function ToExpandedString(Delimeter: String): String;
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

  /// <summary>
  /// Transforms string with 'H:MM:SS:FR' format to TTimecode
  /// </summary>
  function StrToTimecode (const ITimecodeString: String; var ATimecode: TTimecode): String;

  ///<summary>
  ///Parses aerender log string and returns record of it's contents.
  ///</summary>
  function ParseAErenderFrameLogString (const ILogString: String): TAErenderFrameData;

implementation

function TTimecode.ToSingleString(): String;
begin
  Result := Result + Self.H.ToString + ':';

  if Self.MM < 10 then
    Result := Result + '0' + Self.MM.ToString + ':'
  else
    Result := Result + Self.MM.ToString + ':';

  if Self.SS < 10 then
    Result := Result + '0' + Self.SS.ToString + ':'
  else
    Result := Result + Self.SS.ToString + ':';

  if Self.FR < 10 then
    Result := Result + '0' + Self.FR.ToString
  else
    Result := Result + Self.FR.ToString;
end;

function TTimecode.ToExpandedString(Delimeter: String): String;
begin
  Result := Result + 'H: ' + Self.H.ToString + Delimeter;

  if Self.MM < 10 then
    Result := Result + 'M: ' + '0' + Self.MM.ToString + Delimeter
  else
    Result := Result + 'M: ' + Self.MM.ToString + ':';

  if Self.SS < 10 then
    Result := Result + 'S: ' + '0' + Self.SS.ToString + Delimeter
  else
    Result := Result + 'S: ' + Self.SS.ToString + Delimeter;

  if Self.FR < 10 then
    Result := Result + 'FR: ' + '0' + Self.FR.ToString
  else
    Result := Result + 'FR: ' + Self.FR.ToString;
end;

function StrToTimecode (const ITimecodeString: String; var ATimecode: TTimecode): String;
var
  ATimecodeString: String;
begin
  ATimecodeString := ITimecodeString;

  //Read hours from timecode and remove it from temporary string
  ATimecode.H := StrToInt(ATimecodeString[1]);
  Delete(ATimecodeString, 1, 2);
  {  AString = '00:00:00 (1): 0 Seconds'  }

  //Read minutes from timecode and remove it from temporary string
  ATimecode.MM := StrToInt(ATimecodeString[1] + ATimecodeString[2]);
  Delete(ATimecodeString, 1, 3);
  {  AString = '00:00 (1): 0 Seconds'  }

  //Read seconds from timecode and remove it from temporary string
  ATimecode.SS := StrToInt(ATimecodeString[1] + ATimecodeString[2]);
  Delete(ATimecodeString, 1, 3);
  {  AString = '00 (1): 0 Seconds'  }

  //Read frames from timecode and remove it from temporary string
  ATimecode.FR := StrToInt(ATimecodeString[1] + ATimecodeString[2]);
  Delete(ATimecodeString, 1, 4);
  {  AString = '1): 0 Seconds'  }

  Result := ATimecodeString;
end;

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

    AString := StrToTimecode(AString, Result.Timecode);

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

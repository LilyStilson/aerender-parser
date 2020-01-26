program aerparser;

(*        AErender Data Parser Example Project                                              *)
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

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  AErenderDataParser in '..\AErenderDataParser.pas';

const
  ProgressString  = 'PROGRESS:  0:00:03:18 (199): 0 Seconds';
  DurationString  = 'PROGRESS:  Duration: 0:00:10:00';
  FrameRateString = 'PROGRESS:  Frame Rate: 60.00 (comp)';

begin
  try
    Writeln ('AErenderDataParser Example' + #13#10 + 'Lily Stilson // 2020' + #13#10 + '---------------------------' + #13#10);

    Writeln ( 'Progress String    = "' + ProgressString + '"' + #13#10 +
              'Duration String    = "' + DurationString + '"' + #13#10 +
              'Frame Rate String  = "' + FrameRateString + '"' + #13#10);

    var SavedProgress: TAErenderFrameData := ParseAErenderFrameLogString(ProgressString);
    Writeln ( 'Extracted Progress Data' + #13#10 + '---------------------------' + #13#10 +
              'Timecode      = ' + SavedProgress.Timecode.ToSingleString + #13#10 +
              'Frame         = ' + SavedProgress.Frame.ToString + #13#10 +
              'Time          = ' + SavedProgress.ElapsedTime.ToString + #13#10);

    var SavedTimecode: TTimecode := ParseAErenderDurationLogString(DurationString);
    Writeln ('Duration      = ' + SavedTimecode.ToSingleString);

    var SavedFrameRate: TFrameRate := ParseAErenderFrameRateLogString(FrameRateString);
    Writeln ('Frame Rate    = ' + SavedFrameRate.ToString);

    Writeln ('Total Frames  = ' + TimecodeToFrames(SavedTimecode, SavedFrameRate).ToString);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.

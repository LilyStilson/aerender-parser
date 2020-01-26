program aerparser;

(*        AErender Data Parser Test Program                                                 *)
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
  AErenderDataParser;

const
  TestString = 'PROGRESS:  0:00:03:18 (199): 0 Seconds';
  FramesTestString =  'PROGRESS:  Start: 0:00:00:00' + #13#10 +
                      'PROGRESS:  End: 0:00:09:59' + #13#10 +
                      'PROGRESS:  Duration: 0:00:10:00' + #13#10 +
                      'PROGRESS:  Frame Rate: 60.00 (comp)';

begin
  try
    Writeln ('Initial String      = ' + TestString);

    var AERD: TAErenderFrameData := ParseAErenderFrameLogString(TestString);

    Writeln ('Processed timecode  = ' + AERD.Timecode.ToSingleString);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.

<h1 align="center">AErender Data Parser</h1>
<p align="center">Simple Pascal-based aerender log parser. Made specifically for AErender Launcher.</p>
<p align="center"><b>Lily Stilson // 2020</b></p>
<hr>

## Usage
This unit is meant to be working with RAD Studio 10.3.2. Other remain untested, but probably will work too.</p>

### TTimecode
```Pascal
TTimecode = record
  H, MM, SS, FR: Cardinal;
end;
```
Represents aerender timecode.
- **H** - Hours
- **MM** - Minutes
- **SS** - Seconds
- **FR** - Frames

### TAErenderFrameData
```Pascal
TAErenderFrameData = record
  Timecode: TTimecode;
  Frame: Cardinal;
  ElapsedTime: Cardinal;
  InitialMessage: String;
end;
```
Returning value of parsed string.
- **Timecode** - Represents aerender timecode.
- **Frame** - Represents current frame.
- **ElapsedTime** - Represents time elapsed to render one frame
- **InitialMessage** - Represents source log string

### ParseAErenderFrameLogString
Parses strings with the following format `PROGRESS: H:MM:SS:FR: SS Seconds`

```Pascal
function ParseAErenderFrameLogString (const ILogString: String): TAErenderFrameData;
```
- **ILogString** - Initial log string.

<hr>

## Examples
```Pascal
uses
  AErenderDataParser;

const
  TestString = 'PROGRESS:  0:00:03:18 (199): 0 Seconds';

var
  AERD: TAErenderFrameData;

begin  
  AERD := ParseAErenderFrameLogString(TestString);
  
  Writeln ('Initial String    = ' + AERD.InitialMessage);

  Writeln ('Current Frame     = ' + AERD.Frame.ToString);
  Writeln ('Elapsed Time      = ' + AERD.ElapsedTime.ToString);

  Writeln ('Timecode');
  Writeln ('H: ' + AERD.Timecode.H.ToString + '   M: ' + AERD.Timecode.MM.ToString + '   S: '
            + AERD.Timecode.SS.ToString + '   FR: ' + AERD.Timecode.FR.ToString);
end.
```

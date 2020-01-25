<h1 align="center">AErender Data Parser</h1>
<p align="center">Simple Pascal-based aerender log parser. Made specifically for AErender Launcher.</p>
<p align="center"><b>Lily Stilson // 2020</b></p>
<hr>

## Usage
This unit is meant to be working with RAD Studio 10.3.2. Other remain untested, but probably will work too.</p>

### ParseAErenderFrameLogString
Parses strings with the following format `PROGRESS: H:MM:SS:FR: SS Seconds`

```Pascal
function ParseAErenderFrameLogString (const ILogString: String): TAErenderFrameData;
```

- **ILogString** - Initial log string.

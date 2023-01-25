[![pub package](https://img.shields.io/pub/v/vdf.svg)](https://pub.dartlang.org/packages/vdf)

An encoder and decoder for Valve's [KeyValue format (VDF)](https://developer.valvesoftware.com/wiki/KeyValues).

## Usage

A [VdfCodec](https://pub.dev/documentation/vdf/latest/vdf/VdfCodec-class.html) encodes input json using Valve's [KeyValue format (VDF)](https://developer.valvesoftware.com/wiki/KeyValues) and decodes KeyValue string to json.

The [vdf](https://pub.dev/documentation/vdf/latest/vdf/vdf-constant.html) is the default implementation of [VdfCodec](https://pub.dev/documentation/vdf/latest/vdf/VdfCodec-class.html).

Example:

```dart
var encoded = vdf.encode({"sampleData":{"foo":"bar"}});

var decoded = vdf.decode(r'''
"sampleData"
{
	"foo"		"bar"
}
''');
```

You can use shorthands [vdfEncode](https://pub.dev/documentation/vdf/latest/vdf/vdfEncode.html) and [vdfDecode](https://pub.dev/documentation/vdf/latest/vdf/vdfDecode.html). Useful if a local variable shadows the global [vdf](https://pub.dev/documentation/vdf/latest/vdf/vdf-constant.html) constant:

```dart
var encoded = vdfEncode({"sampleData":{"foo":"bar"}});

var decoded = vdfDecode(r'''
"sampleData"
{
	"foo"		"bar"
}
''');
```

For more information, see also [VdfEncoder](https://pub.dev/documentation/vdf/latest/vdf/VdfEncoder-class.html) and [VdfDecoder](https://pub.dev/documentation/vdf/latest/vdf/VdfDecoder-class.html).

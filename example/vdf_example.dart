import 'package:vdf/vdf.dart';

void main() {
  var decoded1 = vdf.decode(r'''
"sampleData"
{
	"foo"		"bar"
}
''');
  print(decoded1);
  // {"sampleData":{"foo":"bar"}}

  var decoded2 = vdfDecode(r'''
"sampleData"
{
	"foo"		"bar"
}
''');
  print(decoded2);
  // {"sampleData":{"foo":"bar"}}

  var encoded1 = vdf.encode({
    "sampleData": {
      "foo": "bar",
    }
  });
  print(encoded1);
  // "sampleData"
  //{
  //	"foo"		"bar"
  //}

  var encoded2 = vdfEncode({
    "sampleData": {
      "foo": "bar",
    }
  });
  print(encoded2);
  // "sampleData"
  //{
  //	"foo"		"bar"
  //}
}

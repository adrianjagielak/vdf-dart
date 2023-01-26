import 'dart:convert';

/// A Valve's [KeyValue format (VDF)](https://developer.valvesoftware.com/wiki/KeyValues)
/// encoder and decoder.
///
/// The top-level [vdfEncode] and [vdfDecode] functions may be used
/// instead if a local variable shadows the [vdf] constant.
const VdfCodec vdf = VdfCodec();

/// Encodes [input] using Valve's [KeyValue format (VDF)](https://developer.valvesoftware.com/wiki/KeyValues)
/// encoding.
///
/// Shorthand for `vdf.encode(input)`. Useful if a local variable shadows
/// the global [vdf] constant.
String vdfEncode(Map<String, dynamic> input) => vdf.encode(input);

/// Decodes Valve's [KeyValue format (VDF)](https://developer.valvesoftware.com/wiki/KeyValues)
/// encoded string.
///
/// Shorthand for `vdf.decode(input)`. Useful if a local variable shadows the
/// global [vdf] constant.
Map<String, dynamic> vdfDecode(String input) => vdf.decode(input);

/// A Valve's [KeyValue format (VDF)](https://developer.valvesoftware.com/wiki/KeyValues)
/// encoder and decoder.
class VdfCodec extends Codec<Map<String, dynamic>, String> {
  const VdfCodec();

  @override
  VdfEncoder get encoder => const VdfEncoder();

  @override
  VdfDecoder get decoder => const VdfDecoder();
}

class VdfEncoder extends Converter<Map<String, dynamic>, String> {
  const VdfEncoder();

  @override
  String convert(Map<String, dynamic> input) {
    return _decode(input);
  }

  String _decode(Map input, [int level = 0]) {
    const x = '\t';
    var result = '';
    var indent = '';

    indent = List.generate(level, (_) => x).join();

    for (final key in input.keys) {
      if (input[key] is Map) {
        result += [
          indent,
          '"',
          key,
          '"\n',
          indent,
          '{\n',
          _decode(input[key], level + 1),
          indent,
          '}\n'
        ].join();
      } else {
        result += [
          indent,
          '"',
          key,
          '"',
          x,
          x,
          '"',
          input[key].toString(),
          '"\n'
        ].join();
      }
    }

    return result;
  }
}

class VdfDecoder extends Converter<String, Map<String, dynamic>> {
  const VdfDecoder();

  @override
  Map<String, dynamic> convert(String input) {
    List<String> lines = input.split('\n');
    Map<String, dynamic> object = {};
    List<dynamic> stack = [object];
    bool expect = false;

    final regex = RegExp(
      '^("((?:\\\\.|[^\\\\"])+)"|([a-z0-9\\-\\_]+))([ \t]*("((?:\\\\.|[^\\\\"])*)(")?|([a-z0-9\\-\\_]+)))?',
    );

    int i = 0;
    final j = lines.length;

    bool comment = false;

    for (; i < j; i++) {
      var line = lines[i].trim();

      if (line.startsWith('/*') && line.endsWith('*/')) {
        continue;
      }

      if (line.startsWith('/*')) {
        comment = true;
        continue;
      }

      if (line.endsWith('*/')) {
        comment = false;
        continue;
      }

      if (comment) {
        continue;
      }
      if (line == '' || line[0] == '/') {
        continue;
      }
      if (line[0] == '{') {
        expect = false;
        continue;
      }
      if (expect) {
        throw FormatException('Invalid syntax on line ${i + 1}.');
      }
      if (line[0] == '}') {
        stack.removeLast();
        continue;
      }

      while (true) {
        var m = regex.firstMatch(line);
        if (m == null) {
          throw FormatException('Invalid syntax on line ${i + 1}.');
        }
        dynamic key = (m[2] != null) ? m[2] : m[3];
        dynamic val = (m[6] != null) ? m[6] : m[8];

        if (val == null) {
          if ((stack[stack.length - 1] as Map)[key] == null) {
            (stack[stack.length - 1] as Map)[key] = {};
          }
          stack.add((stack[stack.length - 1] as Map)[key]);
          expect = true;
        } else {
          if (m[7] == null && m[8] == null) {
            line += '\n${lines[++i]}';
            continue;
          }

          if (val != '' && num.tryParse(val) != null) {
            val = num.parse(val);
          }
          if (val == 'true') {
            val = true;
          }
          if (val == 'false') {
            val = false;
          }
          if (val == 'null') {
            val = null;
          }
          if (val == 'undefined') {
            val = null;
          }

          (stack[stack.length - 1] as Map)[key] = val;
        }
        break;
      }
    }

    if (stack.length != 1) {
      throw FormatException('Open parentheses somewhere.');
    }

    return object;
  }
}

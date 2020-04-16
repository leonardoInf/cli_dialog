import 'dart:io';

class StdoutService {
  bool mock;

  StdoutService({this.mock: false});

  void write(str) {
    if (mock) {
      _buffer += str;
      _flush();
    } else {
      stdout.write(str);
    }
  }

  void writeln(str) {
    if (mock) {
      _buffer += str + '\n';
      _flush();
    } else {
      stdout.writeln(str);
    }
  }

  //Remove blank lines at the end
  List getOutput() {
    List ret = [];
    _output.forEach((element) {
      if (element.length > 0) {
        ret.add(element);
      }
    });
    return ret;
  }

  String getStringOutput() => getOutput().join('\n');

  // END OF PUBLIC API

  var _buffer = '';
  var _cursor = {'x': 0, 'y': 0};
  var _output = [''];

  void _addChar() {
    var currLine = _output[_cursor['y']].split('');
    if (_cursor['x'] < currLine.length) {
      currLine.removeAt(_cursor['x']);
      currLine.insert(_cursor['x'], _buffer[0]);
    } else
      currLine.add(_buffer[0]);
    _output[_cursor['y']] = currLine.join('');
    _cursor['x'] += 1;
  }

  void _flush() {
    var bufferCpy = _buffer; // copy of buffer

    for (var i = 0; i < bufferCpy.length; i++) {
      var utf16char = bufferCpy[i];

      switch (utf16char) {
        case '\n':
          _handleNewline();
          break;
        case '\r':
          _handleCarriageReturn();
          break;
        case '\u001b':
          var found = _handleEscapeSequence();
          if (found) {
            var toSkip = _removeSequenceFromBuffer();
            i += toSkip;
            continue;
          } else {
            _addChar();
          }
          break;
        default:
          _addChar();
      }
      _removeCharFromBuffer();
    }
  }

  // not all escape sequences have the m delimiter
  int _getDelimiterIndex() {
    var delims = ['A', 'm', 'K'];
    for (var i = 0; i < _buffer.length; i++) {
      if (delims.contains(_buffer[i])) return i;
    }
    return 0;
  }

  void _handleCarriageReturn() {
    _cursor['x'] = 0;
  }

  bool _handleEscapeSequence() {
    final sequence = _buffer.substring(1, _getDelimiterIndex() + 1);

    if (sequence == '[0K') {
      //blank remaning
      _output[_cursor['y']] = _output[_cursor['y']].substring(0, _cursor['x']);
      return true;
    }
    if (RegExp(r'\[\dA').hasMatch(sequence)) {
      _cursor['x'] = 0;
      var stepsUp =
          int.parse(RegExp(r'\[\dA').firstMatch(sequence).group(0)[1]);
      if (_cursor['y'] - stepsUp >= 0) {
        _cursor['y'] -= stepsUp;
      }
      return true;
    }
    return false;
  }

  void _handleNewline() {
    _output.add('');
    _cursor['x'] = 0;
    _cursor['y'] += 1;
  }

  void _removeCharFromBuffer() {
    if (_buffer.length > 1)
      _buffer = _buffer.substring(1);
    else
      _buffer = '';
  }

  int _removeSequenceFromBuffer() {
    var delimIndex = _getDelimiterIndex();
    _buffer = _buffer.substring(delimIndex + 1);
    return delimIndex;
  }
}

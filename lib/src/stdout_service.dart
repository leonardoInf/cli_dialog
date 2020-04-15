import 'dart:io';

class StdoutService {
  bool isMock;
  var buffer = '';
  var output = [''];
  var cursor = {'x': 0, 'y': 0};

  StdoutService({this.isMock: false});

  void write(str) {
    if (isMock) {
      buffer += str;
      _flush();
    } else {
      stdout.write(str);
    }
  }

  void writeln(str) {
    if (isMock) {
      buffer += str + '\n';
      _flush();
    } else {
      stdout.writeln(str);
    }
  }

  //Remove blank lines at the end
  List getOutput() {
    List ret = [];
    output.forEach((element) {
      if (element.length > 0) {
        ret.add(element);
      }
    });
    return ret;
  }

  String getStringOutput() => getOutput().join('\n');

  // END OF PUBLIC API

  void _flush() {
    var _buffer = buffer; // copy of buffer

    for (var i = 0; i < _buffer.length; i++) {
      var utf16char = _buffer[i];

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

  void _addChar() {
    var currLine = output[cursor['y']].split('');
    if (cursor['x'] < currLine.length) {
      currLine.removeAt(cursor['x']);
      currLine.insert(cursor['x'], buffer[0]);
    } else
      currLine.add(buffer[0]);
    output[cursor['y']] = currLine.join('');
    cursor['x'] += 1;
  }

  void _removeCharFromBuffer() {
    if (buffer.length > 1)
      buffer = buffer.substring(1);
    else
      buffer = '';
  }

  int _removeSequenceFromBuffer() {
    var delimIndex = _getDelimiterIndex();
    buffer = buffer.substring(delimIndex + 1);
    return delimIndex;
  }

  void _handleNewline() {
    output.add('');
    cursor['x'] = 0;
    cursor['y'] += 1;
  }

  void _handleCarriageReturn() {
    cursor['x'] = 0;
  }

  // not all escape sequences have the m delimiter
  int _getDelimiterIndex() {
    var delims = ['A', 'm', 'K'];
    for (var i = 0; i < buffer.length; i++) {
      if (delims.contains(buffer[i])) return i;
    }
    return 0;
  }

  bool _handleEscapeSequence() {
    final sequence = buffer.substring(1, _getDelimiterIndex() + 1);

    if (sequence == '[0K') {
      //blank remaning
      output[cursor['y']] = output[cursor['y']].substring(0, cursor['x']);
      return true;
    }
    if (RegExp(r'\[\dA').hasMatch(sequence)) {
      cursor['x'] = 0;
      var stepsUp =
          int.parse(RegExp(r'\[\dA').firstMatch(sequence).group(0)[1]);
      if (cursor['y'] - stepsUp >= 0) {
        cursor['y'] -= stepsUp;
      }
      return true;
    }
    return false;
  }
}

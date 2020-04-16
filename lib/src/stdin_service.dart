// Small wrapper class for Stdin to allow tesing

import 'dart:io';
import 'package:cli_dialog/src/stdout_service.dart';

class StdinService {
  bool mock;
  StdoutService informStdout;

  StdinService({this.mock: false, this.informStdout});

  void addToBuffer(elements) {
    if (elements is Iterable)
      _mockBuffer.addAll(elements);
    else
      _mockBuffer.add(elements); // that is, if it is only one element
  }

  int readByteSync() {
    if (mock) {
      var ret = _mockBuffer[0];
      _mockBuffer.removeAt(0);
      return (ret is int ? ret : int.parse(ret));
    }
    return stdin.readByteSync();
  }

  String readLineSync({encoding}) {
    if (mock) {
      var ret = _mockBuffer[0];
      _mockBuffer.removeAt(0);
      if (informStdout != null && _getEchomode()) {
        informStdout.write(ret);
      }
      return ret;
    }
    return stdin.readLineSync(encoding: encoding);
  }

  // END OF PUBLIC API

  var _mockBuffer = [];
  bool _getEchomode() {
    if (!stdin.hasTerminal)
      return false;
    else
      return stdin.echoMode;
  }
}

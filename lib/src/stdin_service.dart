// Small wrapper class for Stdin to allow tesing

import 'dart:io';
import 'package:cli_dialog/src/stdout_service.dart';

class StdinService {
  bool isMock;
  var _mockBuffer = [];
  StdoutService informStdout;

  StdinService({this.isMock: false, this.informStdout});

  int readByteSync() {
    if (isMock) {
      var ret = _mockBuffer[0];
      _mockBuffer.removeAt(0);
      return (ret is int ? ret : int.parse(ret));
    }
    return stdin.readByteSync();
  }

  String readLineSync({encoding}) {
    if (isMock) {
      var ret = _mockBuffer[0];
      _mockBuffer.removeAt(0);
      if (informStdout != null) {
        informStdout.write(ret);
      }
      return ret;
    }
    return stdin.readLineSync(encoding: encoding);
  }

  void addToBuffer(elements) {
    _mockBuffer.addAll(elements);
  }
}

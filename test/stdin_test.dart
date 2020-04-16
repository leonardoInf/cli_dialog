import 'package:test/test.dart';
import 'package:cli_dialog/src/xterm.dart';
import 'test_utils.dart';

void main() {
  StdinService std_in;

  test('Basic functionality', () {
    std_in = StdinService(mock: true);
    var entries = ["Entry1\n", "Entry2\r", Keys.enter];
    std_in.addToBuffer(entries);
    var line1 = std_in.readLineSync();
    var line2 = std_in.readLineSync();
    var byte1 = std_in.readByteSync();
    expect([line1, line2, byte1], equals(entries));
  });

  test('Informs stdout', () {
    var std_out = StdoutService(mock: true);
    var std_in = StdinService(mock: true, informStdout: std_out);
    std_in.addToBuffer(['1337', ...Keys.arrowDown]);
    std_in.readLineSync();
    for (var i = 0; i < 3; i++) {
      std_in.readByteSync();
    }
    expect(std_out.getOutput(), equals(['1337']));
  });
}

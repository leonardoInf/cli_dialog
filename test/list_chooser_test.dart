import 'package:test/test.dart';
import 'package:cli_dialog/src/list_chooser.dart';
import 'package:cli_dialog/src/services.dart';
import 'package:cli_dialog/src/xterm.dart';

void main() {
  StdinService std_input;
  StdoutService std_output;
  List<String> options;

  setUp(() {
    std_input = StdinService(isMock: true);
    std_output = StdoutService(isMock: true);
    options = ['A', 'B', 'C', 'D'];
  });

  test('Basic functionality', () {
    std_input.addToBuffer(
        [...Keys.arrowDown, ...Keys.arrowDown, ...Keys.arrowDown, Keys.enter]);
    var chooser = ListChooser.std(std_input, std_output, options);
    var expectedStdout = getMarkedStdout(options, 3);

    expect(chooser.choose(), equals('D'));
    expect(std_output.getOutput(), equals(expectedStdout));
  });

  test('Many options', () {});

  test('Only one option', () {});

  test('Throws exception if no option is given', () {});

  test('Upper bound is respected', () {
    std_input.addToBuffer([
      ...Keys.arrowUp,
      ...Keys.arrowUp,
      ...Keys.arrowUp,
      ...Keys.arrowUp,
      ...Keys.arrowUp,
      Keys.enter
    ]);
    var chooser = ListChooser.std(std_input, std_output, options);
    expect(chooser.choose(), equals('A'));
  });

  test('Lower bound is respected', () {
    std_input.addToBuffer([
      ...Keys.arrowDown,
      ...Keys.arrowDown,
      ...Keys.arrowDown,
      ...Keys.arrowDown,
      ...Keys.arrowDown,
      Keys.enter
    ]);
    var chooser = ListChooser.std(std_input, std_output, options);
    expect(chooser.choose(), equals('D'));
  });
}

String getMarkedStdout(options, index) {
  var output = StringBuffer();

  for (var i = 0; i < options.length; i++) {
    if (i == index)
      output.writeln(XTerm.teal(options[i]));
    else
      output.writeln(options[i]);
  }
  return output.toString();
}

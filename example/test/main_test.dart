import 'package:test/test.dart';
import 'package:example/main.dart';
import 'package:cli_dialog/src/services.dart';
import 'package:cli_dialog/src/xterm.dart';

void main() {
  var answers = {};

  test('Result', () {
    var mockStdout = StdoutService(isMock: true);
    var mockStdin = StdinService(isMock: true, informStdout: mockStdout);

    mockStdin.addToBuffer([
      'Some project\n',
      "Yes\n",
      ...Keys.arrowDown,
      ...Keys.arrowDown,
      ...Keys.arrowUp,
      Keys.enter
    ]);
    var expectedOutput = {
      'project_name': 'Some project',
      'routing': true,
      'stylesheet':
          'SCSS   [ https://sass-lang.com/documentation/syntax#scss                ]'
    };
    answers = runExample(mockStdin, mockStdout);
    print(mockStdout.getStringOutput());
    expect(answers, equals(expectedOutput));
  });

  test('Reporting', () {
    expect(report(answers, do_print: false), equals('''

Your project name is ${answers['project_name']}.
You ${(answers['routing'] ? '' : 'do not ')}want to use routing.
Your preferred stylesheet format is ${answers["stylesheet"].split(' ')[0]}.
'''));
  });
}

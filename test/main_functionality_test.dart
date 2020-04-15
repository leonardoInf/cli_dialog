import 'package:test/test.dart';
import 'package:cli_dialog/cli_dialog.dart';
import 'package:cli_dialog/src/services.dart';

void main() {
  test('Main functionality', () {
    var std_input = StdinService(isMock: true);
    var std_output = StdoutService(isMock: true);

    //key codes
    const enter = 10;
    const arrowUp = [27, 91, 65];
    const arrowDown = [27, 91, 66];

    std_input.addToBuffer([
      'My project\n',
      "No\n",
      ...arrowDown,
      ...arrowDown,
      ...arrowDown,
      ...arrowDown,
      ...arrowUp,
      enter
    ]);

    var expectedOutput = {
      'project_name': 'My project',
      'routing': false,
      'stylesheet':
          'Less   [ http://lesscss.org                                             ]'
    };

    var questions = [
      ['What name would you like to use for the project?', 'project_name']
    ];
    var booleanQuestions = [
      ['Would you like to add AngularDart routing?', 'routing']
    ];

    var listQuestions = [
      [
        {
          'question': 'Which stylesheet format would you like to use?',
          'options': [
            'CSS',
            'SCSS   [ https://sass-lang.com/documentation/syntax#scss                ]',
            'Sass   [ https://sass-lang.com/documentation/syntax#the-indented-syntax ]',
            'Less   [ http://lesscss.org                                             ]',
            'Stylus [ http://stylus-lang.com                                         ]'
          ]
        },
        'stylesheet'
      ]
    ];

    expect(
        CLI_Dialog.std(std_input, std_output,
                questions: questions,
                booleanQuestions: booleanQuestions,
                listQuestions: listQuestions)
            .ask(),
        equals(expectedOutput));
  });
}

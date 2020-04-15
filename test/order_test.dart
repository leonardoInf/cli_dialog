import 'package:test/test.dart';
import 'package:cli_dialog/src/services.dart';
import 'package:cli_dialog/src/dialog.dart';
import 'test_utils.dart';

void main() {
  StdoutService std_output;
  StdinService std_input;

  setUp(() {
    std_output = StdoutService(isMock: true);
    std_input = StdinService(isMock: true, informStdout: std_output);
  });

  test('Order is respected', () {
    var questions = [
      ["Whats´up?", "B"]
    ];

    var booleanQuestions = [
      ["Are you serious right now?", "C"],
      ["Really?", "A"],
    ];

    var order = ["C", "A", "B"];

    std_input.addToBuffer(["Not really\n", "Yes\n", "Nothing\n"]);

    var dialog = CLI_Dialog.std(std_input, std_output,
        questions: questions, booleanQuestions: booleanQuestions, order: order);
    dialog.ask();

    var expectedStr = '''
${booleanQnA('Are you serious right now?', 'No')}
${booleanQnA('Really?', 'Yes')}
${QnA('Whats´up?', 'Nothing')}''';

    expect(std_output.getStringOutput(), equals(expectedStr));
  });
}

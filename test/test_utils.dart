export 'package:cli_dialog/src/services.dart';
import 'package:cli_dialog/src/xterm.dart';

String markedList(options, index) {
  var output = StringBuffer();

  for (var i = 0; i < options.length; i++) {
    if (i == index)
      output.writeln(XTerm.rightIndicator() + ' ' + XTerm.teal(options[i]));
    else
      output.writeln('  ' + options[i]);
  }
  var outputStr = output.toString();
  return outputStr.substring(
      0, outputStr.length - 1); // remove trailing newline
}

String booleanQnA(question, answer) =>
    XTerm.green('?') +
    ' ' +
    XTerm.bold(question) +
    ' ' +
    XTerm.gray('(y/N)') +
    ' ' +
    XTerm.teal(answer);

String QnA(question, answer) =>
    XTerm.green('?') + ' ' + XTerm.bold(question) + ' ' + XTerm.teal(answer);

String questionNList(question, options, index) =>
    XTerm.green('?') +
    ' ' +
    XTerm.bold(question) +
    ' ' +
    XTerm.gray('(Use arrow keys)') +
    '\n' +
    markedList(options, index);

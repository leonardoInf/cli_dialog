import 'dart:io';
import 'services.dart';
import 'xterm.dart';

class ListChooser {
  List<String> items;
  var std_input = StdinService();
  var std_output = StdoutService();

  ListChooser(this.items) {
    if (stdin.hasTerminal) {
      //relevant when running from IntelliJ console pane for example
      stdin.echoMode = false;
      stdin.lineMode = false;
    }
  }

  ListChooser.std(this.std_input, this.std_output, this.items) {
    if (stdin.hasTerminal) {
      stdin.echoMode = false;
      stdin.lineMode = false;
    }
  }

  void deletePreviousList() {
    for (var i = 0; i < items.length; i++) {
      std_output.write(XTerm.moveUp(1) + XTerm.blankRemaining());
    }
  }

  void resetStdin() {
    if (stdin.hasTerminal) {
      //see default ctor
      stdin.echoMode = true;
      stdin.lineMode = true;
    }
  }

  void renderList(index, {initial: false}) {
    if (!initial) {
      deletePreviousList();
    }
    for (var i = 0; i < items.length; i++) {
      if (i == index) {
        std_output.writeln(XTerm.rightIndicator() + ' ' + XTerm.teal(items[i]));
        continue;
      }
      std_output.writeln('  ' + items[i]);
    }
  }

  int userInput() {
    for (var i = 0; i < 2; i++) {
      if (std_input.readByteSync() == 10) {
        return 10;
      }
    }
    return std_input.readByteSync();
  }

  String choose() {
    int input;
    int index = 0;

    renderList(0, initial: true);

    while ((input = userInput()) != 10) {
      if (input == 65) {
        if (index > 0) {
          index--;
        }
      } else if (input == 66) {
        if (index < items.length - 1) {
          index++;
        }
      }
      renderList(index);
    }
    resetStdin();
    return items[index];
  }
}

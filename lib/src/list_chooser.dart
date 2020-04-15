import 'dart:io';
import 'services.dart';
import 'xterm.dart';

class ListChooser {
  List<String> items;
  var std_input = StdinService();
  var std_output = StdoutService();

  ListChooser(this.items) {
    _checkItems();
    if (stdin.hasTerminal) {
      //relevant when running from IntelliJ console pane for example
      stdin.echoMode = false;
      stdin.lineMode = false;
    }
  }

  ListChooser.std(this.std_input, this.std_output, this.items) {
    _checkItems();
    if (stdin.hasTerminal) {
      stdin.echoMode = false;
      stdin.lineMode = false;
    }
  }

  String choose() {
    int input;
    int index = 0;

    _renderList(0, initial: true);

    while ((input = _userInput()) != 10) {
      if (input == 65) {
        if (index > 0) {
          index--;
        }
      } else if (input == 66) {
        if (index < items.length - 1) {
          index++;
        }
      }
      _renderList(index);
    }
    _resetStdin();
    return items[index];
  }

  // END OF PUBLIC API

  void _checkItems(){
    if(items == null){
      throw ArgumentError('No options for list dialog given');
    }
  }

  void _deletePreviousList() {
    for (var i = 0; i < items.length; i++) {
      std_output.write(XTerm.moveUp(1) + XTerm.blankRemaining());
    }
  }

  void _renderList(index, {initial: false}) {
    if (!initial) {
      _deletePreviousList();
    }
    for (var i = 0; i < items.length; i++) {
      if (i == index) {
        std_output.writeln(XTerm.rightIndicator() + ' ' + XTerm.teal(items[i]));
        continue;
      }
      std_output.writeln('  ' + items[i]);
    }
  }

  void _resetStdin() {
    if (stdin.hasTerminal) {
      //see default ctor
      stdin.echoMode = true;
      stdin.lineMode = true;
    }
  }

  int _userInput() {
    for (var i = 0; i < 2; i++) {
      if (std_input.readByteSync() == 10) {
        return 10;
      }
    }
    return std_input.readByteSync();
  }
}

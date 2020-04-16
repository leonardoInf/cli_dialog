import 'dart:convert';
import 'list_chooser.dart';
export 'list_chooser.dart';
import 'services.dart';
import 'xterm.dart';

class CLI_Dialog {
  Map answers = {};
  List<List<String>> booleanQuestions;
  List listQuestions;
  List<String> order;
  List<List<String>> questions;
  bool trueByDefault;

  CLI_Dialog(
      {this.questions,
      this.booleanQuestions,
      this.listQuestions,
      this.order,
      this.trueByDefault = false}) {
    _checkQuestions();
  }
  CLI_Dialog.std(this._std_input, this._std_output,
      {this.questions,
      this.booleanQuestions,
      this.listQuestions,
      this.order,
      this.trueByDefault = false}) {
    _checkQuestions();
  }

  void addQuestion(p_question, key, {is_boolean = false}) {
    if (is_boolean) {
      booleanQuestions.add([p_question, key]);
    } else {
      questions.add([p_question, key]);
    }
  }

  void addQuestions(p_questions, {is_boolean = false}) {
    if (is_boolean) {
      booleanQuestions.addAll(p_questions);
    } else {
      questions.addAll(p_questions);
    }
  }

  Map ask() {
    if (order == null) {
      _standardOrder();
    } else {
      for (var i = 0; i < order.length; i++) {
        final questionAndFunction = _findQuestion(order[i]);
        if (questionAndFunction != null) {
          questionAndFunction[1](
              questionAndFunction[0][0], questionAndFunction[0][1]);
        }
      }
    }

    return answers;
  }

  // END OF PUBLIC API

  var _std_input = StdinService();
  var _std_output = StdoutService();

  void _askBooleanQuestion(question, key) {
    _std_output.write(_booleanQuestion(question));
    _getBooleanAnswer(question, key);
  }

  void _askListQuestion(optionsMap, key) {
    _std_output.writeln(_listQuestion(optionsMap['question']));
    _getListAnswer(optionsMap['options'], key);
  }

  void _askQuestion(question, key) {
    _std_output.write(_question(question));
    _getAnswer(question, key);
  }

  String _booleanQuestion(str) =>
      _question(str) + _comment(trueByDefault ? '(Y/n)' : '(y/N)') + ' ';

  void _checkDuplicateKeys() {
    var keyList = [];

    [questions, booleanQuestions, listQuestions].forEach((entry) {
      if (entry != null) {
        entry.forEach((element) {
          keyList.add(element[1]);
        });
      }
    });

    //check for duplicates
    if (keyList.length != keyList.toSet().length) {
      throw ArgumentError('You have two or more keys with the same name.');
    }
  }

  void _checkQuestions() {
    [questions, booleanQuestions, listQuestions].forEach((entry) {
      if (entry != null) {
        entry.forEach((element) {
          if (element != null) {
            if (element.length != 2) {
              throw ArgumentError(
                  'Each question entry must be a list consisting of a question and a key.');
            }
          } else {
            throw ArgumentError('All questions and keys must be Strings.');
          }
        });
      }
    });

    [questions, booleanQuestions].forEach((entry) {
      if (entry != null) {
        entry.forEach((element) {
          if (element[0] is! String || element[1] is! String) {
            throw ArgumentError('All questions and keys must be Strings.');
          }
        });
      }
    });

    if (listQuestions != null) {
      listQuestions.forEach((element) {
        if (element[0]['question'] is! String) {
          throw ArgumentError('Your question must be a String.');
        }
        if (element[0]['options'] is! List<String>) {
          throw ArgumentError('Your list options must be a list of Strings.');
        }

        if (element[0].length != 2) {
          throw ArgumentError(
              'Your list dialog map must have exactly two entries.');
        }
      });
    }
    _checkDuplicateKeys();
  }

  String _comment(str) => XTerm.gray(str);

  dynamic _findQuestion(key) {
    dynamic ret;
    [
      [questions, _askQuestion],
      [booleanQuestions, _askBooleanQuestion],
      [listQuestions, _askListQuestion]
    ].forEach((element) {
      if (element[0] != null) {
        var retVal = _search(element[0], element[1], key);
        if (retVal != null) {
          ret = retVal;
          return;
        }
      }
    });
    return ret;
  }

  void _getAnswer(question, key) {
    answers[key] = _getInput(_question(question));
    _std_output.writeln('\r' +
        _question(question) +
        XTerm.teal(answers[key]) +
        XTerm.blankRemaining());
  }

  void _getBooleanAnswer(question, key) {
    var input = _getInput(_booleanQuestion(question), acceptEmptyAnswer: true);
    if (input.isEmpty) {
      answers[key] = trueByDefault;
    } else {
      answers[key] = (input[0] == 'y' || input[0] == 'Y');
    }
    var replaceStr = '\r' + _booleanQuestion(question) + XTerm.blankRemaining();
    replaceStr += (answers[key] ? XTerm.teal('Yes') : XTerm.teal('No'));
    _std_output.writeln(replaceStr);
  }

  String _getInput(formattedQuestion, {acceptEmptyAnswer: false}) {
    var input = '';
    if (!acceptEmptyAnswer) {
      while (input.length == 0) {
        input = _std_input
            .readLineSync(encoding: Encoding.getByName('utf-8'))
            .trim();
        _std_output.write(XTerm.moveUp(1) + formattedQuestion);
      }
    } else {
      input =
          _std_input.readLineSync(encoding: Encoding.getByName('utf-8')).trim();
      _std_output.write(XTerm.moveUp(1) + formattedQuestion);
    }
    return input;
  }

  void _getListAnswer(options, key) {
    var chooser = ListChooser.std(_std_input, _std_output, options);
    answers[key] = chooser.choose();
  }

  int _getSize(some_collection) =>
      (some_collection != null ? some_collection.length : 0);

  String _listQuestion(str) => _question(str) + _comment('(Use arrow keys)');

  String _question(str) => XTerm.green('?') + ' ' + XTerm.bold(str) + ' ';

  dynamic _search(list, fn, key) {
    dynamic ret;
    list.forEach((element) {
      if (element[1] == key) {
        ret = [element, fn];
        return;
      }
    });
    return ret;
  }

  // Standard behaviour if no order is given
  void _standardOrder() {
    for (var i = 0; i < _getSize(questions); i++) {
      _askQuestion(questions[i][0], questions[i][1]);
    }
    for (var i = 0; i < _getSize(booleanQuestions); i++) {
      _askBooleanQuestion(booleanQuestions[i][0], booleanQuestions[i][1]);
    }
    for (var i = 0; i < _getSize(listQuestions); i++) {
      _askListQuestion(listQuestions[i][0], listQuestions[i][1]);
    }
  }
}

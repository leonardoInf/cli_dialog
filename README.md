# cli_dialog
[![Build Status](https://travis-ci.com/leonardoInf/cli_dialog.svg?branch=master)](https://travis-ci.com/leonardoInf/cli_dialog)

A Dart package which allows you to easily create Angular CLI style CLI dialogs.
This package does not have any direct dependencies. The following GIF shows a CLI dialog which was created using this library.

![Demo of cli_dialog](doc/cli_dialog_demo.gif)

You can find the source for this example [here](example/lib/main.dart)

* [Usage](#usage)
  * [Basic usage](#basic-Usage) 
  * [Boolean questions](#boolean-questions)
  * [List questions](#list-questions)
  * [Order](#order)
* [Testing](#testing)
* [How it works](#how-it-works)
* [Contributing](#contributing)
* [Known issues on Windows](#known-issues-on-windows)
* [Acknowledgements](#acknowledgements)


## Usage

### Basic Usage

```dart
import 'package:cli_dialog/cli_dialog.dart';

void main() {
  final dialog = CLI_Dialog(questions: [
    ['What is your name?', 'name']
  ]);
  final name = dialog.ask()['name'];
}
```

Whenever you want to create a CLI dialog you create a `CLI_Dialog()` instance.

The `CLI_Dialog` class supports multiple keyword arguments amongst which `questions` is the most basic one.
`questions` is a list of questions and corresponding keys to retreive the answers.

Thus, each list entry for `questions` has the following syntax: 
``
[<question>, <key<]
``.

Then you will want to call the `ask()` method. It performs the CLI dialog and returns a map with the keys you provided and the values it received from the user.
 
### Boolean questions
```dart
import 'package:cli_dialog/cli_dialog.dart';

void main() {
  final dialog = CLI_Dialog(booleanQuestions: [
    ['Are you happy with this package?', 'isHappy']
  ]);
  final answer = dialog.ask()['isHappy'];
}
```
As the name suggests, boolean questions just asks the user for (y/N) answers and always returns `bool` values.

The N in (y/N) indicates that the default answer is no. You can change this by passing `trueByDefault: true` to the constructor.

### List questions
```dart
import 'package:cli_dialog/cli_dialog.dart';

void main() {
  const listQuestions = [
    [
      {
        'question': 'What is your favourite colour?',
        'options': ['Red', 'Blue', 'Green']
      },
      'colour'
    ]
  ];

  final dialog = CLI_Dialog(listQuestions: listQuestions);
  final answer = dialog.ask();
  final colour = answer['colour'];
}
```

List questions allow the user to make a selection amongst several strings. `'question'` is the question that will be printed before the selection. `'options'` are the options from which the user chooses exactly one. `'colour'` is the key used to retreive the answer.

### Order
```dart
import 'package:cli_dialog/cli_dialog.dart';

void main() {
  const listQuestions = [
    [
      {
        'question': 'Where are you from?',
        'options': ['Africa', 'Asia', 'Europe', 'North America', 'South Africa']
      },
      'origin'
    ]
  ];

  const booleanQuestions = [
    ['Do you want to continue?', 'continue']
  ];

  final dialog = CLI_Dialog(
      booleanQuestions: booleanQuestions,
      listQuestions: listQuestions,
      order: ['origin', 'continue']);

  dialog.ask();
}
```

The optional keyword parameter `order` for the constructor allows you to set a custom order for your questions in the dialog by passing a list with keys in your required order.

If you do not indicate any order then the standard order is applied:
1. All regular questions as they appear in the `questions` list.
2. All boolean questions.
3. All list questions.

We used the `order` parameter in the this example because otherwise the question 'Do you want to continue' would be asked before 'Where are you from?' according to standard order.

## Testing

This package also provides a small infrastructure for testing your dialogs. 

For this purpose, there is the named constructor `CLI_Dialog.std()` which has two required arguments:
 - std_input = a StdinService
 - std_output = a StdoutService

`StdinService` and `StdoutService` are classes which are provided with this library. There are always used internally for i/o. If you explicitly use these classes then you will probably want to set the `mock` parameter to `true` which will make these services mock objects. 

Furtermore, it is mostly advised to pass `std_output` to `std_input` using the `informStdout` parameter to inform the StdoutService about standard input in echo mode.
Details can be observed in the numerous tests I have written (`test/`).

## How it works

This library uses ANSI/XTerm escape sequences and regular escape sequences. You can take a look at them in [this file](lib/src/xterm.dart) 

## Contributing

Of course you are welcome to contribute to this project by issuing a pull request on Github.

Please write unit tests (`test/`) for new functionality and make sure that `test.sh` and `lint.sh` (`tool/`) run succesfully before submitting. 

Please format your code using `dartfmt -w .` (this is also covered by `lint.sh`).

## Known issues on Windows

cli_dialog currently can not be tested with Travis CI on Windows (I guess there is something wrong with the 
interpretation of escape codes in their system). Nonetheless, cli_dialog also works on Windows with the 
following caveats:

- Use 'W' and 'S' keys instead of arrow up and arrow down
- Colors are a little different
- the unicode right indicator is replaced by a simple >

You can run the tests locally on your WIndows machine and they should pass.

## Acknowledgements

The design used for the dialog is copied from the initial dialog in the `ng` tool. Click [here](https://cli.angular.io/) for more information about Angular CLI.


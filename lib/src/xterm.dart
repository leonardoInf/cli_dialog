abstract class XTerm {
  static var reset = '\u001b[0m';

  static String bold(str) => '\u001b[1m' + str + reset;

  static String green(str) => '\u001b[32m' + str + reset;

  static String gray(str) => '\u001b[38;5;246m' + str + reset;

  static String teal(str) => '\u001b[38;5;6m' + str + reset;

  static String moveUp(n) => '\u001b[${n}A';

  static String blankRemaining() => '\u001b[0K';

  static String replacePreviousLine(str) => moveUp(1) + str + blankRemaining();

  static String rightIndicator() => teal('\u276F');
}

//key codes
abstract class Keys {
  static const enter = 10;
  static const arrowUp = [27, 91, 65];
  static const arrowDown = [27, 91, 66];
}

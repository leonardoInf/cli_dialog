/// Abstract class providing some key codes which can be statically accessed.
abstract class Keys {
  /// Arrow down. Consists of three bytes.
  static const arrowDown = [27, 91, 66];
  /// Arrows up. Consists of three bytes.
  static const arrowUp = [27, 91, 65];
  /// Enter key. Single byte.
  static const enter = 10;
}

/// Abstract class providing XTerm escape sequences
abstract class XTerm {
  /// This is actually just a string but it does something
  /// so I decided to wrap it into a method
  static String blankRemaining() => '\u001b[0K';

  /// Bold output.
  static String bold(str) => '\u001b[1m' + str + reset;

  /// Gray color.
  static String gray(str) => '\u001b[38;5;246m' + str + reset;

  /// Green color.
  static String green(str) => '\u001b[32m' + str + reset;

  /// The reverse of '\n'. Goes to the beginning of the previous line.
  static String moveUp(n) => '\u001b[${n}A';

  /// Use [moveUp], concatenate your string ([str]) and then blank the remaining line.
  static String replacePreviousLine(str) => moveUp(1) + str + blankRemaining();

  /// Reset XTerm sequence. This is always applied after using some other sequence.
  static var reset = '\u001b[0m';

  /// UTF-16 char for selecting an item in [ListChooser].
  /// Formally called HEAVY RIGHT-POINTING ANGLE QUOTATION MARK ORNAMENT
  /// See: https://codepoints.net/U+276F
  static String rightIndicator() => teal('\u276F');

  /// Teal (=blue/green) color.
  static String teal(str) => '\u001b[38;5;6m' + str + reset;
}

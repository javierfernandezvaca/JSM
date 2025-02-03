class AnsiColor {
  static const _esc = '\x1B[';
  static const _reset = '${_esc}0m';

  final int? fg;
  final int? bg;
  final bool bold;
  final bool italic;
  final bool underline;

  const AnsiColor({
    this.fg,
    this.bg,
    this.bold = false,
    this.italic = false,
    this.underline = false,
  });

  AnsiColor.fg(int code) : this(fg: code);

  String get code {
    final codes = <String>[];
    if (fg != null) codes.add('38;5;${fg}m');
    if (bg != null) codes.add('48;5;${bg}m');
    if (bold) codes.add('1m');
    if (italic) codes.add('3m');
    if (underline) codes.add('4m');
    return codes.isEmpty ? '' : '$_esc${codes.join(_esc)}';
  }

  String call(String msg) => '$code$msg$_reset';

  static const none = AnsiColor();
}

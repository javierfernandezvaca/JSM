/// Clase utilitaria para aplicar estilos de texto basados en códigos ANSI.
///
/// Esta clase permite definir colores de primer plano (foreground) y fondo (background),
/// así como estilos como negrita, cursiva y subrayado. Los estilos se aplican a mensajes
/// de texto para mejorar la legibilidad en terminales compatibles con ANSI.
///
/// Nota: Los códigos ANSI pueden no funcionar en todas las plataformas o terminales
/// (por ejemplo, ciertos IDEs o dispositivos móviles). Se recomienda probar en terminales
/// compatibles con ANSI para obtener la mejor experiencia.
class AnsiColor {
  /// Secuencia de escape ANSI para iniciar un estilo.
  static const _esc = '\x1B[';

  /// Secuencia de escape ANSI para restablecer todos los estilos.
  static const _reset = '${_esc}0m';

  /// Código de color de primer plano (foreground).
  ///
  /// Rango válido: 0-255. Si es `null`, no se aplica ningún color de primer plano.
  final int? fg;

  /// Código de color de fondo (background).
  ///
  /// Rango válido: 0-255. Si es `null`, no se aplica ningún color de fondo.
  final int? bg;

  /// Indica si el texto debe mostrarse en negrita.
  final bool bold;

  /// Indica si el texto debe mostrarse en cursiva.
  final bool italic;

  /// Indica si el texto debe mostrarse subrayado.
  final bool underline;

  /// Constructor principal para crear una instancia de [AnsiColor].
  ///
  /// Parámetros:
  /// - [fg]: Código de color de primer plano (foreground). Rango válido: 0-255.
  /// - [bg]: Código de color de fondo (background). Rango válido: 0-255.
  /// - [bold]: Indica si el texto debe mostrarse en negrita.
  /// - [italic]: Indica si el texto debe mostrarse en cursiva.
  /// - [underline]: Indica si el texto debe mostrarse subrayado.
  ///
  /// Lanza una excepción en tiempo de desarrollo si los valores de [fg] o [bg] están fuera del rango válido.
  const AnsiColor({
    this.fg,
    this.bg,
    this.bold = false,
    this.italic = false,
    this.underline = false,
  })  : assert(
          fg == null || (fg >= 0 && fg <= 255),
          'Foreground color (fg) must be in range 0-255',
        ),
        assert(
          bg == null || (bg >= 0 && bg <= 255),
          'Background color (bg) must be in range 0-255',
        );

  /// Constructor conveniente para definir solo el color de primer plano.
  ///
  /// Este constructor simplifica la creación de instancias cuando solo se necesita
  /// especificar el color de primer plano.
  ///
  /// Ejemplo:
  /// ```dart
  /// final green = AnsiColor.fg(34);
  /// print(green('Este texto es verde'));
  /// ```
  AnsiColor.fg(int code) : this(fg: code);

  /// Genera el código ANSI completo basado en las propiedades configuradas.
  ///
  /// Este método construye dinámicamente la secuencia de escape ANSI que representa
  /// los estilos definidos (colores, negrita, cursiva, subrayado).
  String get code {
    final codes = <String>[];
    if (fg != null) codes.add('38;5;${fg}m');
    if (bg != null) codes.add('48;5;${bg}m');
    if (bold) codes.add('1m');
    if (italic) codes.add('3m');
    if (underline) codes.add('4m');
    return codes.isEmpty ? '' : '$_esc${codes.join(_esc)}';
  }

  /// Aplica el estilo ANSI al mensaje proporcionado.
  ///
  /// Este método devuelve el mensaje envuelto en las secuencias de escape ANSI
  /// correspondientes, asegurando que el estilo se aplique correctamente y se
  /// restablezca al final del mensaje.
  ///
  /// Parámetros:
  /// - [msg]: El mensaje al que se aplicará el estilo.
  ///
  /// Ejemplo:
  /// ```dart
  /// final redBold = AnsiColor(fg: 196, bold: true);
  /// print(redBold('Este texto es rojo y negrita'));
  /// ```
  String call(String msg) => '$code$msg$_reset';

  /// Instancia predeterminada sin estilos aplicados.
  ///
  /// Útil cuando no se desea aplicar ningún estilo especial al texto.
  static const none = AnsiColor();
}

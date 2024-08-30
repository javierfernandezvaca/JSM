import 'dart:math';

/// Tipos de archivos
enum JFileType {
  video, // Video files
  image, // Image files
  audio, // Audio files
  ppt, // PowerPoint files
  word, // Word files
  excel, // Excel files
  apk, // Android package files
  pdf, // PDF files
  txt, // Text files
  chm, // Compiled HTML Help files
  vector, // Vector files
  html, // HTML files
}

/// Clase JUtils
///
/// Una clase que proporciona varias funciones de utilidad de todo tipo.
class JUtils {
  /// Genera un ID único de longitud variable.
  ///
  /// Esta función genera un ID único que consta de una mezcla de letras
  /// mayúsculas y números. Utiliza el generador de números aleatorios
  /// seguros de Dart para garantizar la aleatoriedad de los caracteres
  /// generados.
  ///
  /// Parámetros:
  /// - `idLength`: La longitud del ID que se generará. Por defecto es 16.
  ///
  /// Retorna un String que representa el ID único generado.
  static String generateUniqueID([int idLength = 16]) {
    final random = Random.secure();
    final codeUnits = List.generate(idLength, (index) {
      // 0 para letra, 1 para número
      final type = random.nextInt(2);
      if (type == 0) {
        // Genera un número aleatorio entre 0 y 25, luego lo convierte en
        // una letra mayúscula (A-Z) sumando 65.
        return random.nextInt(26) + 65;
      } else {
        // Genera un número aleatorio entre 0 y 9, luego lo convierte en
        // un dígito (0-9) sumando 48.
        return random.nextInt(10) + 48;
      }
    });
    // Convierte la lista de unidades de código en un String
    // y lo retorna.
    return String.fromCharCodes(codeUnits);
  }

  // ...

  /// Determina si un valor dinámico probablemente tiene el método o
  /// getter `isEmpty`.
  ///
  /// Esta función verifica los tipos estándar de Dart que contienen
  /// `isEmpty`.
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  ///
  /// Devuelve `true` si el valor es una cadena, iterable o mapa y
  /// está vacío, `false` en caso contrario.
  static bool? _isEmpty(dynamic value) {
    if (value is String) {
      return value.toString().trim().isEmpty;
    }
    if (value is Iterable || value is Map) {
      return value.isEmpty as bool?;
    }
    return false;
  }

  /// Devuelve si un valor dinámico probablemente tiene el método o getter
  /// de longitud al verificar los tipos estándar de Dart que lo contienen.
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  ///
  /// Devuelve `true` si el valor es Iterable, String o Map, `false` en
  /// caso contrario.
  static bool _hasLength(dynamic value) {
    return value is Iterable || value is String || value is Map;
  }

  /// Obtiene la longitud de un valor dinámico después de validar
  /// previamente su tipo.
  ///
  /// Si el [value] es double/int; se tomará la longitud del valor para
  /// su método "toString".
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  ///
  /// Devuelve la longitud del valor si es posible obtenerla, `null` en caso
  /// contrario.
  static int? _obtainDynamicLength(dynamic value) {
    if (value == null) {
      return null;
    }
    if (_hasLength(value)) {
      return value.length as int?;
    }
    if (value is int) {
      return value.toString().length;
    }
    if (value is double) {
      return value.toString().replaceAll('.', '').length;
    }
    return null;
  }

  // ...

  /// Comprueba si una cadena coincide con un patrón de expresión regular.
  ///
  /// Parámetros:
  /// - `value`: La cadena a verificar.
  /// - `pattern`: El patrón de expresión regular.
  ///
  /// Este método toma una cadena y un patrón de expresión regular,
  /// y devuelve `true` si la cadena coincide con el patrón, y `false`
  /// en caso contrario.
  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  // ...

  /// Verifica si un valor es nulo.
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  ///
  /// Devuelve `true` si el valor es nulo, `false` en caso contrario.
  static bool isNull(dynamic value) => value == null;

  /// Verifica si un valor es nulo o en blanco (vacío o solo contiene
  /// espacios en blanco).
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  ///
  /// Devuelve `true` si el valor es nulo o en blanco, `false` en
  /// caso contrario.
  static bool? isNullOrBlank(dynamic value) {
    if (isNull(value)) {
      return true;
    }
    return _isEmpty(value);
  }

  /// Verifica si un valor es en blanco (vacío o solo contiene espacios
  /// en blanco).
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  ///
  /// Devuelve `true` si el valor es en blanco, `false` en caso contrario.
  static bool? isBlank(dynamic value) {
    return _isEmpty(value);
  }

  /// Verifica si una cadena es un número entero o decimal.
  ///
  /// Parámetros:
  /// - `value`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena puede ser parseada a un número, `false`
  /// en caso contrario.
  static bool isNum(String value) {
    if (isNull(value)) {
      return false;
    }
    return num.tryParse(value) is num;
  }

  /// Verifica si una cadena consiste solo en números.
  ///
  /// Note que solo numérico no acepta "." que el tipo de datos double tiene.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena solo contiene números, `false` en caso
  /// contrario.
  static bool isNumericOnly(String s) => hasMatch(s, r'^\d+$');

  /// Verifica si una cadena consiste solo en letras del alfabeto; sin
  /// espacios en blanco.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena solo contiene letras del alfabeto,
  /// `false` en caso contrario.
  static bool isAlphabetOnly(String s) => hasMatch(s, r'^[a-zA-Z]+$');

  /// Verifica si una cadena contiene al menos una letra mayúscula.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena contiene al menos una letra mayúscula,
  /// `false` en caso contrario.
  static bool hasCapitalLetter(String s) => hasMatch(s, r'[A-Z]');

  /// Verifica si una cadena es booleana.
  ///
  /// Parámetros:
  /// - `value`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena es 'true' o 'false', `false` en caso
  /// contrario.
  static bool isBool(String value) {
    if (isNull(value)) {
      return false;
    }
    return (value == 'true' || value == 'false');
  }

  // ...

  // Map associating each file type with its corresponding extensions
  static const Map<JFileType, List<String>> _extensions = {
    JFileType.video: ['.mp4', '.avi', '.wmv', '.rmvb', '.mpg', '.mpeg', '.3gp'],
    JFileType.image: ['.jpg', '.jpeg', '.png', '.gif', '.bmp'],
    JFileType.audio: ['.mp3', '.wav', '.wma', '.amr', '.ogg'],
    JFileType.ppt: ['.ppt', '.pptx'],
    JFileType.word: ['.doc', '.docx'],
    JFileType.excel: ['.xls', '.xlsx'],
    JFileType.apk: ['.apk'],
    JFileType.pdf: ['.pdf'],
    JFileType.txt: ['.txt'],
    JFileType.chm: ['.chm'],
    JFileType.vector: ['.svg'],
    JFileType.html: ['.html'],
  };

  /// Verifica si una cadena es algún tipo de archivo específico
  ///
  /// Parámetros:
  /// - `filePath`: La ruta del archivo a verificar.
  /// - `type`: El tipo de archivo a verificar.
  ///
  /// Devuelve `true` si la extensión del archivo coincide con las
  /// extensiones conocidas para el tipo de archivo especificado,
  /// `false` en caso contrario.
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// bool isVideo = isFileType(filePath, JFileType.video);
  /// bool isImage = isFileType(filePath, JFileType.image);
  /// ```
  static bool isFileType(String filePath, JFileType type) {
    final ext = filePath.toLowerCase();
    return _extensions[type]!.contains(ext);
  }

  // ...

  /// Verifica si una cadena es un nombre de usuario válido.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de un nombre de usuario válido,
  /// `false` en caso contrario.
  static bool isUsername(String s) =>
      hasMatch(s, r'^[a-zA-Z0-9][a-zA-Z0-9_.]+[a-zA-Z0-9]$');

  /// Verifica si una cadena es una URL válida.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de una URL válida,
  /// `false` en caso contrario.
  static bool isURL(String s) => hasMatch(s,
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$");

  /// Verifica si una cadena es un correo electrónico válido.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de un correo
  /// electrónico válido, `false` en caso contrario.
  static bool isEmail(String s) => hasMatch(s,
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// Verifica si una cadena es un número de teléfono válido.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de un número de
  /// teléfono válido, `false` en caso contrario.
  static bool isPhoneNumber(String s) {
    if (s.length > 16 || s.length < 9) return false;
    return hasMatch(s, r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  }

  /// Verifica si una cadena es una fecha y hora válida (UTC o Iso8601).
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de una fecha y
  /// hora válida, `false` en caso contrario.
  static bool isDateTime(String s) =>
      hasMatch(s, r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}Z?$');

  /// Verifica si una cadena es un hash MD5 válido.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de un hash MD5
  /// válido, `false` en caso contrario.
  static bool isMD5(String s) => hasMatch(s, r'^[a-f0-9]{32}$');

  /// Verifica si una cadena es un hash SHA1 válido.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de un hash SHA1
  /// válido, `false` en caso contrario.
  static bool isSHA1(String s) =>
      hasMatch(s, r'(([A-Fa-f0-9]{2}\:){19}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{40})');

  /// Verifica si una cadena es un hash SHA256 válido.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de un hash
  /// SHA256 válido, `false` en caso contrario.
  static bool isSHA256(String s) =>
      hasMatch(s, r'([A-Fa-f0-9]{2}\:){31}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{64}');

  /// Verifica si una cadena es un número de Seguridad Social válido.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de un número de
  /// Seguridad Social válido, `false` en caso contrario.
  static bool isSSN(String s) => hasMatch(s,
      r'^(?!0{3}|6{3}|9[0-9]{2})[0-9]{3}-?(?!0{2})[0-9]{2}-?(?!0{4})[0-9]{4}$');

  /// Verifica si una cadena es binaria.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de una cadena
  /// binaria, `false` en caso contrario.
  static bool isBinary(String s) => hasMatch(s, r'^[0-1]+$');

  /// Verifica si una cadena es una dirección IPv4 válida.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de una dirección
  /// IPv4 válida, `false` en caso contrario.
  static bool isIPv4(String s) =>
      hasMatch(s, r'^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$');

  /// Verifica si una cadena es una dirección IPv6 válida.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de una dirección
  /// IPv6 válida, `false` en caso contrario.
  static bool isIPv6(String s) => hasMatch(s,
      r'^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$');

  /// Verifica si una cadena es hexadecimal.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de una cadena
  /// hexadecimal, `false` en caso contrario.
  ///
  /// Ejemplo:
  ///
  /// ```dart
  /// bool isColorCode = isHexadecimal("#34A853");
  /// ```
  static bool isHexadecimal(String s) =>
      hasMatch(s, r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  /// Verifica si una cadena es un número de pasaporte válido.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de un número de
  /// pasaporte válido, `false` en caso contrario.
  static bool isPassport(String s) =>
      hasMatch(s, r'^(?!^0+$)[a-zA-Z0-9]{6,9}$');

  /// Verifica si una cadena es una moneda válida.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena coincide con el patrón de una moneda
  /// válida, `false` en caso contrario.
  static bool isCurrency(String s) => hasMatch(s,
      r'^(S?\$|\₩|Rp|\¥|\€|\₹|\₽|fr|R\$|R)?[ ]?[-]?([0-9]{1,3}[,.]([0-9]{3}[,.])*[0-9]{3}|[0-9]+)([,.][0-9]{1,2})?( ?(USD?|AUD|NZD|CAD|CHF|GBP|CNY|EUR|JPY|IDR|MXN|NOK|KRW|TRY|INR|RUB|BRL|ZAR|SGD|MYR|CUP|CUC|MLC))?$');

  // ...

  /// Verifica si la longitud de un valor es mayor que maxLength.
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  /// - `maxLength`: La longitud máxima a comparar.
  ///
  /// Devuelve `true` si la longitud del valor es mayor que maxLength,
  /// `false` en caso contrario.
  static bool isLengthGreaterThan(dynamic value, int maxLength) {
    final length = _obtainDynamicLength(value);
    if (length == null) {
      return false;
    }
    return length > maxLength;
  }

  /// Verifica si la longitud de un valor es mayor o igual que maxLength.
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  /// - `maxLength`: La longitud máxima a comparar.
  ///
  /// Devuelve `true` si la longitud del valor es mayor o igual que
  /// maxLength, `false` en caso contrario.
  static bool isLengthGreaterOrEqual(dynamic value, int maxLength) {
    final length = _obtainDynamicLength(value);
    if (length == null) {
      return false;
    }
    return length >= maxLength;
  }

  /// Verifica si la longitud de un valor es menor que maxLength.
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  /// - `maxLength`: La longitud máxima a comparar.
  ///
  /// Devuelve `true` si la longitud del valor es menor que maxLength,
  /// `false` en caso contrario.
  static bool isLengthLessThan(dynamic value, int maxLength) {
    final length = _obtainDynamicLength(value);
    if (length == null) {
      return false;
    }
    return length < maxLength;
  }

  /// Verifica si la longitud de un valor es menor o igual que maxLength.
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  /// - `maxLength`: La longitud máxima a comparar.
  ///
  /// Devuelve `true` si la longitud del valor es menor o igual que
  /// maxLength, `false` en caso contrario.
  static bool isLengthLessOrEqual(dynamic value, int maxLength) {
    final length = _obtainDynamicLength(value);
    if (length == null) {
      return false;
    }
    return length <= maxLength;
  }

  /// Verifica si la longitud de un valor es igual a otherLength.
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  /// - `otherLength`: La longitud a comparar.
  ///
  /// Devuelve `true` si la longitud del valor es igual a otherLength,
  /// `false` en caso contrario.
  static bool isLengthEqualTo(dynamic value, int otherLength) {
    final length = _obtainDynamicLength(value);
    if (length == null) {
      return false;
    }
    return length == otherLength;
  }

  /// Verifica si la longitud de un valor está entre minLength y maxLength.
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  /// - `minLength`: La longitud mínima a comparar.
  /// - `maxLength`: La longitud máxima a comparar.
  ///
  /// Devuelve `true` si la longitud del valor está entre minLength y
  /// maxLength, `false` en caso contrario.
  static bool isLengthBetween(dynamic value, int minLength, int maxLength) {
    if (isNull(value)) {
      return false;
    }
    return isLengthGreaterOrEqual(value, minLength) &&
        isLengthLessOrEqual(value, maxLength);
  }

  // ...

  /// Verifica si una cadena es un palíndromo.
  ///
  /// Un palíndromo es una palabra, número o frase que se lee igual lo mismo
  /// hacia adelante que hacia atrás, ignorando los espacios, la puntuación
  /// y las diferencias de mayúsculas y minúsculas.
  ///
  /// Parámetros:
  /// - `s`: La cadena a verificar.
  ///
  /// Devuelve `true` si la cadena es un palíndromo, `false` en caso
  /// contrario.
  static bool isPalindrom(String s) {
    final cleanString = s
        .toLowerCase()
        .replaceAll(RegExp(r"\s+"), '')
        .replaceAll(RegExp(r"[^0-9a-zA-Z]+"), "");
    for (var i = 0; i < cleanString.length; ++i) {
      if (cleanString[i] != cleanString[cleanString.length - i - 1]) {
        return false;
      }
    }
    return true;
  }

  /// Verifica si todos los elementos de un valor son iguales.
  ///
  /// Un valor puede ser una cadena, una lista o un número entero. En el caso
  /// de una cadena o una lista, verifica si todos los caracteres o elementos
  /// son iguales. En el caso de un número entero, verifica si todos los
  /// dígitos son iguales.
  ///
  /// Parámetros:
  /// - `value`: El valor a verificar.
  ///
  /// Devuelve `true` si todos los elementos del valor son iguales, `false`
  /// en caso contrario.
  ///
  /// Ejemplos:
  ///
  /// ```dart
  /// bool isUnic1 = isOneAKind('1111111');
  /// bool isUnic2 = isOneAKind('www');
  /// bool isUnic3 = isOneAKind([1234,1234,1234,1234]);
  /// bool isUnic4 = isOneAKind(1111);
  /// ```
  static bool isOneAKind(dynamic value) {
    if ((value is String || value is List) && !isNullOrBlank(value)!) {
      final first = value[0];
      final len = value.length as num;
      for (var i = 0; i < len; i++) {
        if (value[i] != first) {
          return false;
        }
      }
      return true;
    }
    if (value is int) {
      final stringValue = value.toString();
      final first = stringValue[0];
      for (var i = 0; i < stringValue.length; i++) {
        if (stringValue[i] != first) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  // ...

  /// Verifica si una cadena contiene otra cadena (interpretando las letras
  /// mayúsculas y minúsculas como iguales).
  ///
  /// Parámetros:
  /// - `a`: La cadena principal.
  /// - `b`: La cadena a buscar dentro de la cadena principal.
  ///
  /// Devuelve `true` si la cadena `a` contiene la cadena `b` (ignorando
  /// las diferencias de mayúsculas y minúsculas), `false` en caso
  /// contrario.
  static bool isCaseInsensitiveContains(String a, String b) {
    final lowA = a.toLowerCase();
    final lowB = b.toLowerCase();
    return lowA.contains(lowB);
  }

  /// Verifica si una cadena contiene otra cadena o viceversa (interpretando
  /// las letras mayúsculas y minúsculas como iguales).
  ///
  /// Parámetros:
  /// - `a`: La primera cadena.
  /// - `b`: La segunda cadena.
  ///
  /// Devuelve `true` si la cadena `a` contiene la cadena `b` o viceversa
  /// (ignorando las diferencias de mayúsculas y minúsculas), `false` en
  /// caso contrario.
  static bool isCaseInsensitiveContainsAny(String a, String b) {
    final lowA = a.toLowerCase();
    final lowB = b.toLowerCase();
    return lowA.contains(lowB) || lowB.contains(lowA);
  }

  /// Convierte a mayúsculas la primera letra dentro de una cadena y deja
  /// las demás en minúsculas.
  ///
  /// Parámetros:
  /// - `s`: La cadena a convertir.
  ///
  /// Devuelve la cadena con la primera letra en mayúsculas y las demás
  /// en minúsculas, `null` si la cadena es nula.
  static String? capitalizeFirst(String s) {
    if (isNull(s)) return null;
    if (isBlank(s)!) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  /// Convierte a mayúsculas la primera letra de cada palabra dentro de
  /// una cadena.
  ///
  /// Parámetros:
  /// - `s`: La cadena a convertir.
  ///
  /// Devuelve la cadena con la primera letra de cada palabra en mayúsculas,
  /// `null` si la cadena es nula.
  static String? capitalize(String s) {
    if (isNull(s)) return null;
    if (isBlank(s)!) return s;
    return s.split(' ').map(capitalizeFirst).join(' ');
  }

  /// Elimina todos los espacios en blanco dentro de una cadena.
  ///
  /// Parámetros:
  /// - `s`: La cadena a modificar.
  ///
  /// Devuelve la cadena sin espacios en blanco.
  static String removeAllWhitespace(String s) {
    return s.replaceAll(' ', '');
  }

  /// Convierte una cadena a camelCase.
  ///
  /// Parámetros:
  /// - `value`: La cadena a convertir.
  ///
  /// Devuelve la cadena en camelCase,
  /// `null` si la cadena es nula o en blanco.
  static String? camelCase(String value) {
    if (isNullOrBlank(value)!) {
      return null;
    }
    final separatedWords =
        value.split(RegExp(r'[!@#<>?":`~;[\]\\|=+)(*&^%-\s_]+'));
    var newString = '';
    for (final word in separatedWords) {
      newString += word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return newString[0].toLowerCase() + newString.substring(1);
  }

  static final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
  static final _symbolSet = {' ', '.', '/', '_', '\\', '-'};

  /// Agrupa una cadena en palabras.
  ///
  /// Esta función divide una cadena en palabras basándose en ciertos
  /// caracteres (como espacios, puntos, barras, guiones bajos, etc.) y
  /// letras mayúsculas.
  ///
  /// Parámetros:
  /// - `text`: La cadena a agrupar en palabras.
  ///
  /// Devuelve una lista de palabras.
  static List<String> _groupIntoWords(String text) {
    var sb = StringBuffer();
    var words = <String>[];
    var isAllCaps = text.toUpperCase() == text;

    for (var i = 0; i < text.length; i++) {
      var char = text[i];
      var nextChar = i + 1 == text.length ? null : text[i + 1];
      if (_symbolSet.contains(char)) {
        continue;
      }
      sb.write(char);
      var isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          _symbolSet.contains(nextChar);
      if (isEndOfWord) {
        words.add('$sb');
        sb.clear();
      }
    }
    return words;
  }

  /// Convierte una cadena a snake_case.
  ///
  /// Parámetros:
  /// - `text`: La cadena a convertir.
  /// - `separator`: El separador a utilizar. Por defecto es '_'.
  ///
  /// Devuelve la cadena en snake_case, `null` si la cadena es nula o
  /// en blanco.
  static String? snakeCase(String? text, {String separator = '_'}) {
    if (isNullOrBlank(text)!) {
      return null;
    }
    return _groupIntoWords(text!)
        .map((word) => word.toLowerCase())
        .join(separator);
  }

  /// Convierte una cadena a param-case.
  ///
  /// Parámetros:
  /// - `text`: La cadena a convertir.
  ///
  /// Devuelve la cadena en param-case, `null` si la cadena es nula o
  /// en blanco.
  static String? paramCase(String? text) => snakeCase(text, separator: '-');

  // ...

  /// Extrae el valor numérico de una cadena.
  ///
  /// Esta función recorre cada carácter de la cadena. Si el carácter es
  /// numérico, lo agrega a una nueva cadena. Si el carácter no es numérico,
  /// lo omite.
  ///
  /// Parámetros:
  /// - `s`: La cadena de la que se extraerán los números.
  /// - `firstWordOnly`: Un parámetro opcional que, si se establece como
  /// verdadero, hará que la función se detenga después de encontrar el
  /// primer grupo de números.
  ///
  /// Devuelve una cadena que contiene solo los números de la cadena
  /// original. Si `firstWordOnly` es verdadero, devuelve solo el primer
  /// grupo de números encontrado.
  ///
  /// Ejemplos:
  ///
  /// ```dart
  /// String numeros = numericOnly('OTP 12312 27/04/2020');
  /// String primerGrupoNumeros = numericOnly(
  ///   'OTP 12312 27/04/2020',
  ///   firstWordOnly: true,
  /// );
  /// ```
  static String numericOnly(String s, {bool firstWordOnly = false}) {
    var numericOnlyStr = '';
    for (var i = 0; i < s.length; i++) {
      if (isNumericOnly(s[i])) {
        numericOnlyStr += s[i];
      }
      if (firstWordOnly && numericOnlyStr.isNotEmpty && s[i] == " ") {
        break;
      }
    }
    return numericOnlyStr;
  }

  // ...
}

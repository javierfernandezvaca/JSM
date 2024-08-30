/// Una enumeración para representar los eventos que pueden ocurrir
/// en un estado.
///
/// Los eventos pueden ser `init` para la inicialización y `update`
/// para las actualizaciones.
enum JEvent {
  init,
  update,
  // ...
}

/// Una clase para representar el estado de un objeto.
///
/// El estado contiene una marca de tiempo y un evento.
class JState {
  /// La marca de tiempo del estado.
  final int datetime;

  /// El evento del estado.
  final JEvent event;

  // La lista de identificadores de los JBuilders
  final List<String>? ids;

  /// Crea un estado con una marca de tiempo y un evento.
  JState({
    required this.datetime,
    required this.event,
    this.ids,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JState &&
        other.datetime == datetime &&
        other.event == event;
  }

  @override
  int get hashCode {
    return datetime.hashCode ^ event.hashCode;
  }

  @override
  String toString() {
    return 'Updated: $datetime, Event: ${event.toString()}';
  }
}

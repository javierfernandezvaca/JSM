/// Un alias de tipo para una función que actualiza un valor.
typedef JValueUpdater<T> = T Function();

/// Una clase para almacenar una función de actualización de valor.
///
/// Esta clase proporciona un método para llamar a la función de
/// actualización de valor.
class JInternalFinalCallback<T> {
  /// La función de actualización de valor.
  JValueUpdater<T>? _callback;

  /// Crea un callback con una función de actualización de valor.
  JInternalFinalCallback({
    JValueUpdater<T>? callback,
  }) {
    _callback = callback;
  }

  /// Llama a la función de actualización de valor.
  T call() => _callback!.call();
}

/// Una mezcla para proporcionar un ciclo de vida a un objeto.
///
/// Esta mezcla proporciona métodos para iniciar y cerrar un objeto, y
/// para configurar su ciclo de vida.
mixin JLifeCycleBase {
  final _onStartRef = JInternalFinalCallback();
  final _onDeleteRef = JInternalFinalCallback();

  void onInit() {}
  void onReady() {}
  void onClose() {}

  bool _initialized = false;

  void _onStart() {
    if (_initialized) {
      return;
    } else {
      onInit();
    }
    _initialized = true;
  }

  bool _isClosed = false;

  void _onDelete() {
    if (_isClosed) {
      return;
    }
    _isClosed = true;
    onClose();
  }

  void _configureLifeCycle() {
    if (!_initialized) {
      _onStartRef._callback = _onStart;
      _onDeleteRef._callback = _onDelete;
    }
  }
}

/// Una clase abstracta para representar un objeto con un ciclo de vida.
///
/// Esta clase proporciona métodos para iniciar y cerrar un objeto, y
/// para configurar su ciclo de vida.
abstract class JLifeCycle with JLifeCycleBase {
  /// Crea un objeto con un ciclo de vida.
  JLifeCycle() {
    _configureLifeCycle();
  }
}

/// Una interfaz para representar un objeto que puede ser desechado.
///
/// Esta interfaz extiende de `JLifeCycle` y proporciona métodos para
/// iniciar y cerrar un objeto.
abstract class JDisposableInterface extends JLifeCycle {
  @override
  void onInit() {}

  @override
  void onReady() {}

  @override
  void onClose() {}
}

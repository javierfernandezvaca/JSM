
# **JSM**

Librería de código abierto para Flutter que integra la **gestión de estado**, la **inyección de dependencias** y la **gestión de rutas** en una sola solución.

Su principal objetivo es permitir un desacoplamiento completo de la interfaz de usuario y la lógica de negocio, lo que facilita la creación de aplicaciones robustas y escalables.

Está diseñada con un enfoque basado en el rendimiento y la productividad, al minimizar el consumo de recursos mientras proporciona una sintaxis sencilla y fácil de usar.

<br>

## Características

- [Instalación](#instalación)
- [Configuración inicial](#instalación)
  - `JMaterialApp`
  - `JPage`
- Bases de **JSM**
  - [Gestión de estado](#gestión-de-estado)    
    - [Simple](#administración-de-estado-simple)
      - `JBuilderWidget` or `.builder`
      - `update()`
    - [Reactiva](#administración-de-estado-reactiva)
      - `JObserverWidget` or `.observer`
      - `.observable`
  - [Inyección de dependencias](#inyección-de-dependencias) - `JDependency`
  - [Gestión de rutas](#gestión-de-rutas) - `JRouter`
  - [Gestión de servicios](#gestión-de-servicios) - `JService`
- [Utilidades](#utilidades)
  - [Internacionalización](#internacionalización)
    - `JTranslations`
    - `.tr`
    - `JTranslateWidget` or `.translate`
    - `JTranslateMultipleWidget` or `.translateList`
  - [Temas Visuales](#temas-visuales) - `JTheme`
  - [Diálogos](#jdialog) - `JDialog`
  - [Consola de Depuración](#jconsole) - `JConsole`
  - [Trabajadores](#jworker) - `JWorker`
  - [Utilidades Generales](#jutils) - `JUtils`
- [Ejemplos](#ejemplos)

<br>

## Instalación

Añada la librería a su archivo `pubspec.yaml`:

```yaml
dependencies:
  jsm:
    git:
      url: https://github.com/javierfernandezvaca/JSM.git
      ref: master
```

Luego, importe la librería en cada uno de los archivos en los se utilizará:

```dart
import 'package:jsm/jsm.dart';
```

<br>

## Acerca de JSM

Para utilizar el poder y las bondades de JSM debe:

> Agregar `J` antes de su `MaterialApp`, convirtiéndolo en `JMaterialApp`

```dart
void main() => runApp(JMaterialApp(/* ... */));
```

<br>

### JMaterialApp

`JMaterialApp` es la puerta de entrada a tu aplicación JSM. Simplemente reemplazando **MaterialApp** por **JMaterialApp** en tu función `main()`, desbloqueas todo el potencial de JSM para la gestión de estado, inyección de dependencias y enrutamiento sin necesidad de configuraciones adicionales.

Ejemplo:

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return JMaterialApp(
      routes: [
        JRoute(route: '/login', page: const LoginPage()),
        JRoute(route: '/register', page: const RegisterPage()),
        // ...
      ],
      initialRoute: '/login',
    );
  }
}
```

Explicación:

En este ejemplo, `JMaterialApp` no solo configura tu aplicación, sino que también integra la gestión de rutas de JSM, permitiéndote navegar fácilmente entre sus páginas declaradas en `routes`.

<br>

### JPage

`JPage` simplifica la creación de páginas en tu aplicación JSM al proporcionar una forma estructurada de conectar una vista con su controlador asociado. Esto promueve la separación de la interfaz de usuario (UI) y la lógica de negocio, mejorando la organización y el mantenimiento de tu código.

Al crear una `JPage`, defines un controlador y una función builder que recibe el controlador como argumento. JPage utiliza JDependency para asegurar que el controlador esté disponible para la vista, permitiéndote acceder a sus métodos y propiedades.

Ejemplo:

```dart
class LoginController extends JController {
  String message = "Hello...";

  @override
  void onInit() {}

  @override
  void onReady() {}

  @override
  void onClose() {}
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JPage<LoginController>(
      create: () => LoginController(),
      builder: (context, controller) {
        return Scaffold(
          body: Center(
            child: Text(controller.message),
          ),
        );
      },
    );
  }
}
```

Explicación:

En este ejemplo, LoginPage utiliza JPage para mostrar un mensaje proporcionado por LoginController. La función builder accede al controlador y utiliza su propiedad message para mostrarla en la pantalla.

<br>

## Gestión de estado

La gestión de estado es un componente esencial en el desarrollo de aplicaciones. Esta se refiere a cómo se manejan los datos que determinan la interfaz de usuario y cómo estos cambian en respuesta a las interacciones del usuario. JSM ofrece dos formas diferentes de administrar el estado:

- [Administración de estado simple](#administración-de-estado-simple)
- [Administración de estado reactiva](#administración-de-estado-reactiva)

<br>

### Administración de estado simple

El mecanismo de la administración de estado simple de JSM, es una herramienta poderosa que utiliza el método `update()` con una lista opcional de identificadores de cada widget especial `JBuilderWidget`, que ofrece varias ventajas que lo hacen una opción eficiente y flexible para actualizar la interfaz de usuario; asi como:

- **Actualizaciones precisas**:
  - Permite realizar actualizaciones específicas en lugar de una actualización completa `setState()`, optimizando el rendimiento y la experiencia del usuario.
  - Si no se proporciona la lista de identificadores, se realiza una actualización completa, lo que garantiza que la interfaz de usuario se mantenga consistente.

- **Control granular**:
  - La lista de identificadores permite actualizar solo los `JBuilderWidget` que se necesitan, minimizando el impacto en la interfaz de usuario y evitando redibujados innecesarios.
  - Es ideal para escenarios donde solo una parte de la interfaz de usuario necesita ser actualizada en respuesta a un cambio de estado.

- **Mejora del rendimiento**:
  - Al evitar actualizaciones completas de la interfaz de usuario, se reduce el consumo de recursos y se mejora la fluidez de la aplicación.
  - Es especialmente útil para aplicaciones con interfaces de usuario complejas o con un alto volumen de actualizaciones de estado.

- **Flexibilidad y adaptabilidad**:
  - El mecanismo se adapta a diferentes necesidades de actualización, ya sea que se requiera un cambio completo o solo una actualización específica.
  - Permite un control más preciso sobre cómo se actualiza la interfaz de usuario en respuesta a los cambios de estado.

<br>

Ejemplo:

> **Lógica de negocio**

```dart
class MiControlador extends JController {
  String mensaje = 'Hola mundo';

  void actualizarMensaje(String texto) {
    mensaje = texto;
    update(['msgId']);
  }
}
```

Explicación:

- `MiControlador`: Es la clase controladora que maneja el estado y la lógica de negocio.
- `mensaje`: Es una variable de estado que contiene el mensaje a mostrar en la interfaz de usuario.
- `actualizarMensaje`: Es el método que actualiza el mensaje y llama a `update` para notificar a los widgets que necesitan actualizarse.

<br>

> **Interfaz de usuario**

```dart
// Método #1
// Utilizando el widget especializado (JBuilderWidget)
JBuilderWidget<MiControlador>(
  id: 'msgId',
  onChange: (context, controller) {
    return Text(controller.mensaje);
  },
)
```

Explicación:

- `JBuilderWidget`: Es el widget especializado que se actualiza en respuesta a los cambios en el estado del controlador.
- `id`: Es el identificador único que se usa para asociar este widget con el estado específico del controlador que debe observar.
- `onChange`: Una función que se llama cuando el estado cambia, permitiendo actualizar el widget con el nuevo estado.

<br>

```dart
// Método #2
// Utilizando la extensión (.builder)
var controller = JDependency.find<MiControlador>();

controller.builder(
  id: 'msgId',
  onChange: (context, controller) => Text(controller.mensaje),
);
```

Explicación:

- `controller`: La instancia del controlador que maneja el estado y la lógica de negocio.
- `controller.builder`: La extensión o método que construye el widget basado en el estado actual del controlador.
- `id`: Es el identificador único que se usa para asociar este widget con el estado específico del controlador que debe observar.
- `onChange`: Una función que se llama cuando el estado cambia, permitiendo actualizar el widget con el nuevo estado.

<br>

### Administración de estado reactiva

La administración de estado reactiva de JSM, es una herramienta poderosa que permite crear interfaces de usuario dinámicas y sensibles a los cambios de estado de forma intuitiva y eficiente.

A diferencia de la administración de estado simple, este enfoque se basa en el paradigma reactivo (liberándote de las actualizaciones manuales), donde cada widget especial `JObserverWidget` se actualiza automáticamente en respuesta a cambios en su respectiva variable observable `.observable`. Todo esto permite crear aplicaciones fluidas, eficientes y adaptables que se actualizan en tiempo real y ofrece varias ventajas para actualizar la interfaz de usuario; asi como:

- **Fluidez y rendimiento**:
  - El mecanismo realiza actualizaciones precisas, donde solo se actualizan los `JObserverWidget` que dependen de sus respectivas variables modificadas `.observable`, optimizando el rendimiento y la experiencia del usuario.
  - Realiza menos consumo de recursos evitando los redibujados innecesarios, provocando el desarrollo de aplicaciones más eficientes y responsables.

- **Versátilidad**:
  - Este enfoque permite la creación de aplicaciones escalables y robustas, que se adaptan a las necesidades del usuario, que van desde aplicaciones simples hasta interfaces complejas con un alto volumen de datos.
  - Es fácil de integrar y se puede combinar JSM con su flujo de trabajo actual y comenzar a disfrutar de sus beneficios de inmediato.

### IMPORTANTE:

> Actualización manual para tipos complejos

JSM utiliza un enfoque simplificado para la detección de cambios en los 
observables:  

- Para los tipos de datos primitivos (`int`, `double`, `String`, `bool`), 
  la actualización de la UI es automática.
- Sin embargo, para **todos los demás tipos de datos**, incluyendo 
  listas, mapas y objetos personalizados, **debes llamar manualmente a 
  `refresh()` después de modificar su contenido** para asegurar que la UI se actualice correctamente.

Esta decisión de diseño, que prioriza la robustez, la eficiencia en escenarios de alta demanda de actualización, y la facilidad de comprensión, se fundamenta en un control preciso sobre la actualización de la interfaz de usuario. JSM adopta un enfoque pragmático para la detección de cambios: mientras que los tipos de datos primitivos se actualizan automáticamente, los tipos complejos (como listas, mapas y objetos personalizados) requieren una llamada explícita a `refresh()` después de cada modificación.

Si bien esto implica una pequeña carga adicional para el desarrollador, aporta beneficios significativos:

- **Mayor control y previsibilidad**: Los desarrolladores tienen un control granular sobre cuándo y cómo se actualiza la UI, evitando actualizaciones innecesarias y previniendo comportamientos inesperados.
- **Optimización para aplicaciones de alto rendimiento**: En escenarios donde las modificaciones de datos son frecuentes, este enfoque puede mejorar significativamente el rendimiento al evitar la sobrecarga de procesamiento asociada a la detección automática de cambios en estructuras de datos complejas.

<br>

Ejemplo:

> Lógica de negocio:

```dart
class MiControlador extends JController {
  var mensaje = 'Hola mundo'.observable;
  var notas = [95, 100, 98].observable;

  void actualizarMensaje(String texto) {
    mensaje.value = texto;
  }
  
  void agregarNota(int nota) {
    notas.value.add(nota);
    notas.refresh();
  }
}
```

Explicación:

- `MiControlador`: Es la clase controladora que maneja el estado y la lógica de negocio.
- `mensaje`: Es la variable observable que contiene el mensaje a mostrar en la interfaz de usuario. Al ser observable, cualquier cambio en su valor notificará automáticamente a los widgets que dependen de ella.
- `actualizarMensaje`: Es el método que actualiza el valor de mensaje. Al cambiar el valor de mensaje, los widgets observadores se actualizarán automáticamente.
- `notas`: Es una lista observable que contiene las notas. Al igual que mensaje, cualquier cambio en esta lista notificará a los widgets dependientes.
- `agregarNota`: Este método añade una nueva nota a la lista notas y luego llama a `refresh()` para asegurar que los cambios se reflejen en la interfaz de usuario.

<br>

> Interfaz de usuario:

```dart
// Método #1
// Utilizando el widget especializado (JObserverWidget)
var controller = JDependency.find<MiControlador>();
// ...
JObserverWidget<String>(
  observable: controller.mensaje,
  onChange: (String mensaje) {
    return Text(mensaje);
  },
)
```

Explicación:

- `controller`: Es la instancia del controlador que maneja el estado y la lógica de negocio.
- `JObserverWidget`: Un widget especializado que se actualiza automáticamente en respuesta a los cambios en la variable observable.
- `observable`: La variable observable del controlador que este widget observará.
- `onChange`: Una función que se llama cada vez que el valor de la variable observable cambia, permitiendo actualizar el widget con el nuevo valor.

<br>

```dart
// Método #2
// Utilizando la extensión (.observer)
var controller = JDependency.find<MiControlador>();
// ...
controller.mensaje.observer((String mensaje) => Text(mensaje))
```

Explicación:

- `controller`: Una instancia del controlador que maneja el estado y la lógica de negocio.
- `controller.mensaje.observer`: La extensión o método que permite observar los cambios en la variable observable `mensaje` y actualizar el widget en consecuencia.

<br>

### Resumen

Ya sea que usted elija una de estas dos formas de administración de estado (simple o reactiva) y las utilice de manera separada o combinada, se dará cuenta que:

- **No necesitará StreamControllers**: Simplemente convierte cualquier dato en un observable con la extensión `.observable`.
- **No necesitará un StreamBuilder para cada variable**: Usa `JObserverWidget` para actualizar la interfaz de usuario cuando cambia el valor de una variable.
- **No necesitará una clase para cada estado**: Maneja el estado directamente en tu controlador.
- **No necesitará un get para un valor inicial**: Asigna un valor inicial directamente a la variable.
- **No necesitará generadores de código**: Todo el manejo del estado se realiza en tiempo de ejecución.

Estas formas pueden simplificar la administración del estado en tu aplicación, permitiéndote centrarte en la lógica de tu programa.

<br>

## Inyección de dependencias

La clase **JDependency** de JSM es una herramienta eficiente para gestionar las dependencias. Utiliza un mapa para almacenar y administrar las dependencias, permitiendo un manejo más dinámico y flexible en comparación con la gestión de dependencias tradicional. **JDependency** permite que las dependencias sean permanentes o no permanentes. Las dependencias no permanentes pueden ser eliminadas, mientras que las dependencias permanentes no pueden ser eliminadas.

Las ventajas de usar JDependency incluyen:

- **Eficiencia**: Al utilizar un mapa para almacenar las dependencias, JDependency permite un acceso rápido y eficiente a las dependencias cuando se necesitan.

- **Flexibilidad**: Con la capacidad de marcar dependencias como permanentes o no permanentes, tienes un control total sobre el ciclo de vida de tus dependencias.

- **Manejo de Múltiples Instancias**: Permite manejar múltiples dependencias del mismo tipo utilizando nombres de instancia opcionales.

<br>

Ejemplos:

> **Definición de una dependencia**

```dart
class MiDependencia {
  // ...
  MiDependencia();
}
```

> **Añadir una dependencia**

```dart
// Añadir una dependencia sin nombre de instancia
JDependency.put<MiDependencia>(MiDependencia());

// Añadir una dependencia con nombre de instancia
JDependency.put<MiDependencia>(MiDependencia(), instanceName: 'D1');
```

> **Encontrar una dependencia**

```dart
// Encontrar una dependencia sin nombre de instancia
var miDependencia = JDependency.find<MiDependencia>();

// Encontrar una dependencia con nombre de instancia
var miDependenciaNamed = JDependency.find<MiDependencia>(instanceName: 'D1');
```
> **Verificar la existencia de una dependencia**

```dart
// Verificar si una dependencia existe sin nombre de instancia
bool exists = JDependency.exists<MiDependencia>();

// Verificar si una dependencia existe con nombre de instancia
bool existsNamed = JDependency.exists<MiDependencia>(instanceName: 'D1');
```

> **Eliminar una dependencia**

```dart
// Eliminar una dependencia (no permanente) sin nombre de instancia
JDependency.delete<MiDependencia>();

// Eliminar una dependencia (no permanente) con nombre de instancia
JDependency.delete<MiDependencia>(instanceName: 'D1');
```

> **Eliminar todas las dependencias**
```dart
// Eliminar todas las dependencias (permanentes y no permanentes)
JDependency.clear();
```

<br>

## Gestión de rutas

La clase **JRouter** de JSM proporciona una serie de métodos para facilitar la navegación entre diferentes rutas en una aplicación. A continuación se presentan algunos ejemplos de cómo utilizar estos métodos:

> **Navegar a una nueva pantalla**

Para navegar a una nueva pantalla, puedes utilizar el método `toNamed()`. Este método toma el nombre de la ruta como argumento. Por ejemplo:

```dart
JRouter.toNamed('/next-screen');
```

> **Cerrar elementos de la interfaz de usuario**

Si necesitas cerrar snackbars, diálogos, bottomsheets o cualquier otro elemento que normalmente cerrarías con `Navigator.pop(context)`, puedes utilizar el método `back()`. Por ejemplo:

```dart
JRouter.back();
```

> **Navegar a la siguiente pantalla sin opción a volver**

Si necesitas navegar a una nueva pantalla y asegurarte de que el usuario no pueda volver a la pantalla anterior (útil, por ejemplo, en SplashScreens, LoginScreen, etc.), puedes utilizar el método `offNamed()`. Este método reemplaza la ruta actual con la nueva ruta. Por ejemplo:

```dart
JRouter.offNamed('/next-screen');
```

> **Navegar a la siguiente pantalla y cancelar todas las rutas anteriores**

Si necesitas navegar a una nueva pantalla y eliminar todas las rutas anteriores de la pila de navegación (útil en carritos de compras, encuestas y exámenes), puedes utilizar el método `offAllNamed()`. Por ejemplo:

```dart
JRouter.offAllNamed('/next-screen');
```

> **Navegar a la siguiente ruta y recibir o actualizar datos tan pronto como se regrese de ella**

Si necesitas navegar a una nueva ruta y esperar un resultado cuando se regrese de ella, puedes utilizar el método `toNamed()` y esperar el resultado. Por ejemplo:

```dart
var datos = await JRouter.toNamed('/next-screen');
```

<br>

## Gestión de servicios

La clase **JService** de JSM es una herramienta abstracta para gestionar los servicios de manera eficiente. Utiliza un mapa para almacenar y administrar los servicios, proporcionando métodos para iniciar, detener, obtener y verificar si un servicio está en ejecución. Cada servicio se almacena con una clave única que se genera a partir del tipo del servicio y un nombre de instancia opcional.

Las ventajas de usar JService incluyen:

- **Eficiencia**: Al utilizar un mapa para almacenar los servicios, JService permite un acceso rápido y eficiente a los servicios cuando se necesitan.

- **Flexibilidad**: Con la capacidad de manejar múltiples instancias de servicios mediante nombres de instancia opcionales, tienes un control total sobre el ciclo de vida de tus servicios.

- **Modularidad**: Facilita la gestión modular de los servicios, permitiendo iniciar y detener servicios de manera independiente.

<br>

Ejemplos:

> **Definición de un servicio**

```dart
class MiServicio extends JService {  
  @override
  Future<void> onInit() async {
    // Inicialización del servicio
  }

  @override
  Future<void> onClose() async {
    // Cierre del servicio
  }
}
```

> **Iniciar un servicio**

```dart
// Iniciar un servicio sin nombre de instancia
await JService.start<MiServicio>(MiServicio());

// Iniciar un servicio con nombre de instancia
await JService.start<MiServicio>(MiServicio(), instanceName: 'S1');
```

> **Detener un servicio**

```dart
// Detener un servicio sin nombre de instancia
await JService.stop<MiServicio>();

// Detener un servicio con nombre de instancia
await JService.stop<MiServicio>(instanceName: 'S1');
```

> **Encontrar un servicio**

```dart
// Encontrar un servicio sin nombre de instancia
var miServicio = JService.find<MiServicio>();

// Encontrar un servicio con nombre de instancia
var miServicioNamed = JService.find<MiServicio>(instanceName: 'S1');
```

> **Verificar si un servicio está en ejecución**

```dart
// Verificar si un servicio está en ejecución sin nombre de instancia
bool isRunning = JService.isRunning<MiServicio>();

// Verificar si un servicio está en ejecución con nombre de instancia
bool isRunningNamed = JService.isRunning<MiServicio>(instanceName: 'S1');
```

> **Detener todos los servicios**

```dart
// Detener todos los servicios
JService.stopAll();
```

<br>

##  Utilidades

<br>

###  Temas Visuales

La clase `JTheme` de JSM te permite gestionar los temas de tu aplicación de forma sencilla y dinámica. Puedes cambiar entre temas predefinidos (claro y oscuro) o crear tus propios temas personalizados. Gracias a su naturaleza reactiva, la interfaz de usuario se actualizará automáticamente al cambiar de tema.

**Características**:

- **Temas predefinidos**: JSM incluye temas claros y oscuros por defecto.
- **Temas personalizados**: Puedes definir y cambiar a tus propios temas `ThemeData`.
- **Cambio de tema dinámico**: Utiliza  `JTheme.changeTheme(nuevoTema)` para cambiar el tema en tiempo de ejecución.
- **Alternancia entre temas**: `JTheme.toggleTheme()` alterna entre el tema claro y oscuro.
- **Integración reactiva**: `JTheme.currentTheme` es un `JObservable` que te permite reaccionar a los cambios de tema en tus widgets utilizando `JObserverWidget`.

**Ejemplo**:

```dart
// Alternar entre el tema claro y oscuro al presionar un botón.
ElevatedButton(
  onPressed: () {
    JTheme.toggleTheme(); 
  },
  child: JObserverWidget(
    observable: JTheme.currentTheme,
    onChange: (ThemeData theme) {
      bool isLightTheme = theme == JTheme.lightTheme;
      return Text(isLightTheme ? 'Activar tema oscuro' : 'Activar tema claro');
    },
  ),
),
```

<br>

### Internacionalización

JSM proporciona un sistema de internacionalización sencillo pero potente, permitiéndote crear aplicaciones que se adaptan a diferentes idiomas.

**Características**:

- **Definición de traducciones**: Define tus traducciones utilizando las clases `JLanguage` y `JTranslation`.
- **Cambio de idioma**: Utiliza `JTranslations.changeLocale(nuevoIdioma)` para cambiar el idioma en tiempo de ejecución.
- **Acceso a traducciones**: La extensión `tr` en la clase String te permite acceder fácilmente a las traducciones desde cualquier parte de tu código, incluyendo controladores, widgets y clases de utilidad.
- **Widgets de traducción**: `JTranslateWidget` y `JTranslateMultipleWidget` simplifican la visualización de traducciones y la actualización dinámica de la interfaz de usuario.

Ejemplos:

```dart
// Mostrar un saludo en el idioma actual
Text('Hola Mundo'.tr),

// Cambiar el idioma al presionar un botón
ElevatedButton(
  onPressed: () {
    // Cambiar a español
    JTranslations.changeLocale(Locale('es', 'ES'));
  },
  child: Text('Cambiar a Español'),
),

// Mostrar un diálogo con mensajes traducidos
void mostrarDialogoConfirmacion(BuildContext context) {
  JDialog.confirm(
    context: context,
    title: Text('Confirmación'.tr),
    content: Text('¿Estás seguro de que quieres continuar?'.tr),
    confirmText: Text('Sí'.tr),
    cancelText: Text('No'.tr),
    onConfirm: () {
      // Acción a realizar al confirmar
    },
  );
}
```

**Configuración**:

1. Crea una lista de `JLanguage`, cada uno con su locale y lista de `JTranslation`.
2. Asigna esta lista de `JLanguage` en el inicio de tu aplicación.

<br>

### JDialog

La clase `JDialog` proporciona una interfaz sencilla para mostrar diálogos y snackbars en tu aplicación, permitiéndote elegir entre estilos Material y Cupertino.

**Características**:

- **Snackbars**: Muestra mensajes informativos breves en la parte inferior de la pantalla.
- **Alertas**: Presenta información importante al usuario con un solo botón de confirmación.
- **Diálogos de confirmación**: Pide al usuario que confirme una acción con botones de "Confirmar" y "Cancelar".
- **Hojas de acciones (Action Sheets)**: Muestra una lista de acciones en una hoja emergente desde la parte inferior.
- **Diálogos personalizados**: Te permite mostrar cualquier widget personalizado dentro de un diálogo.

**Métodos**:

- **`snackBar()`**: Muestra un Snackbar con un mensaje y una acción opcional.
- **`materialAlertDialog()`**: Muestra un diálogo de alerta con estilo Material.
- **`cupertinoAlertDialog()`**: Muestra un diálogo de alerta con estilo Cupertino.
- **`materialConfirmationDialog()`**: Muestra un diálogo de confirmación con estilo Material.
- **`cupertinoConfirmationDialog()`**: Muestra un diálogo de confirmación con estilo Cupertino.
- **`materialActionSheet()`**: Muestra una hoja de acciones con estilo Material (usando `ListTile`).
- **`cupertinoActionSheet()`**: Muestra una hoja de acciones con estilo Cupertino.
- **`customDialog()`**: Muestra un diálogo personalizado con el widget que le pases.

**Ejemplo**:

```dart
// Mostrar un snackbar
JDialog.snackBar(content: Text('¡Operación exitosa!'));

// Mostrar un diálogo de alerta con estilo Material
JDialog.materialAlertDialog(
  title: Text('Alerta'),
  content: Text('Esto es un mensaje de alerta.'),
);

// Mostrar un diálogo de confirmación con estilo Cupertino
JDialog.cupertinoConfirmationDialog(
  title: Text('Confirmación'),
  content: Text('¿Estás seguro de que quieres continuar?'),
  onConfirm: () {
    // ...
  },
);
```

**Consideraciones**:

Puedes personalizar los textos de los botones, el contenido y el comportamiento de los diálogos utilizando los parámetros opcionales de cada método.

La clase `JDialog` utiliza el contexto del Navigator principal de tu aplicación (JRouter.navigatorKey) para mostrar los diálogos.

<br>

### JConsole

La clase `JConsole` te ofrece herramientas para facilitar la depuración y el análisis de tu aplicación JSM. Proporciona métodos para registrar mensajes en la consola con diferentes niveles de severidad, visualizar objetos JSON con formato, medir el tiempo de ejecución de operaciones y examinar la pila de llamadas.

**Características**:

- **Mensajes de registro**: Registra mensajes informativos (`log`), de error (`error`) y de advertencia (`info`) con colores distintivos en la consola.
- **Visualización de JSON**: Formatea y muestra objetos JSON de forma legible.
- **Medición de tiempo**: Permite medir el tiempo de ejecución de secciones de código.
- **Inspección de la pila de llamadas**: Imprime la pila de llamadas actual para ayudarte a identificar el origen de un problema.

**Métodos**:

- **`log(obj, {name})`**: Registra un mensaje general en la consola (color verde). 
- **`error(obj, {name})`**: Registra un mensaje de error en la consola (color rojo).
- **`info(obj, {name})`**: Registra un mensaje informativo en la consola (color amarillo).
- **`logJson(data, {name, indent})`**: Formatea y muestra un objeto JSON en la consola con indentación personalizada.
- **`timeStart(id)`**: Inicia un temporizador con un ID único.
- **`timeEnd(id)`**: Detiene el temporizador con el ID especificado e imprime el tiempo transcurrido.
- **`trace()`**: Imprime la pila de llamadas actual en la consola.

**Ejemplos**:

```dart
// Registrar un mensaje simple
JConsole.log('Iniciando la aplicación...');

// Registrar un error
JConsole.error('Error al cargar los datos.');

// Registrar información
JConsole.info('Usuario autenticado correctamente.');

// Mostrar un objeto JSON formateado
Map<String, dynamic> usuario = {'nombre': 'Juan', 'edad': 30};
JConsole.logJson(usuario);

// Medir el tiempo de ejecución de una operación
JConsole.timeStart('ordenarLista');
// ... código para ordenar una lista
JConsole.timeEnd('ordenarLista');

// Mostrar la pila de llamadas
JConsole.trace();
```

**Configuración**:

- **debugShowReactiveLogs**: Habilita o deshabilita el registro de información detallada sobre los observables y observadores de JSM en la consola.

**Consejos**:

- Utiliza `JConsole` para depurar tu código, analizar el rendimiento y comprender el flujo de ejecución de tu aplicación.

- Habilita `debugShowReactiveLogs` durante el desarrollo para obtener información detallada sobre el funcionamiento interno del sistema reactivo de JSM.

<br>

## JWorker

`JWorker` te permite gestionar las suscripciones a `JObservable` y controlar la ejecución de funciones en respuesta a los cambios en los observables. Esto te da un control preciso sobre cómo y cuándo reaccionan tus componentes a las actualizaciones de estado.

**Características**:

- **Control de suscripciones**: `JWorker` encapsula la lógica de suscripción y desuscripción a un `JObservable`. 
- **Frecuencia de ejecución**: JSM ofrece funciones para controlar la frecuencia con la que se ejecutan las funciones en respuesta a los cambios en el observable: ejecutar siempre (`ever`), ejecutar solo una vez (`once`), ejecutar a intervalos regulares (`interval`) y ejecutar después de un retraso (`debounce`). 

**Uso**:

1. **Crear un `JWorker`**: Se crea un `JWorker` utilizando una de las funciones proporcionadas (`ever`, `once`, `interval`, `debounce`), especificando el `JObservable` a observar y la función a ejecutar.
2. **Desuscribirse**: Cuando ya no necesites la suscripción, puedes llamar al método `dispose()` del `JWorker` para cancelar la suscripción al observable.

**Funciones**:

- **`ever(observable, onChange)`**: Ejecuta la función `onChange` cada vez que cambia el valor del `observable`.
- **`once(observable, onChange)`**: Ejecuta la función `onChange` solo la primera vez que cambia el valor del `observable`.
- **`interval(observable, onChange, duration)`**: Ejecuta la función `onChange` después de un intervalo de tiempo especificado (`duration`) desde el último cambio del `observable`.
- **`debounce(observable, onChange, duration)`**: Ejecuta la función `onChange` solo después de que el `observable` ha dejado de cambiar durante un período de tiempo especificado (`duration`).

**Ejemplos**:

```dart
// Contador
var contador = 0.observable;

// Ejecutar una función cada vez que cambia el valor de un observable
var trabajadorEver = ever<int>(
  observable: contador,
  onChange: (valor) => JConsole.log('El contador ha cambiado a: $valor'),
);

// Ejecutar una función solo una vez cuando cambia el valor de un observable
var trabajadorOnce = once<int>(
  observable: contador,
  onChange: (valor) => JConsole.log('El valor inicial del contador es: $valor'),
);

// Ejecutar una función cada segundo después de que el observable cambie
var trabajadorInterval = interval<int>(
  observable: contador,
  onChange: (valor) => JConsole.log('Valor del contador después de 1 segundo: $valor'),
  duration: const Duration(seconds: 1),
);

// Ejecutar una función solo después de que el observable deje de cambiar durante 1 segundo
var trabajadorDebounce = debounce<int>(
  observable: contador,
  onChange: (valor) => JConsole.log('Valor final del contador: $valor'),
  duration: const Duration(seconds: 1),
);

// Desuscribirse de un trabajador
trabajadorEver.dispose();
```

**Uso en controladores**:

`JWorker` es especialmente útil en controladores para realizar acciones en respuesta a cambios en los observables, como actualizar la UI, realizar peticiones de red o ejecutar lógica de negocio.

```dart
class MiControlador extends JController {
  var datos = [].observable;
  late JWorker trabajadorDatos;

  @override
  void onInit() {
    // Suscribirse al observable 'datos' y actualizar la UI cuando cambie
    trabajadorDatos = ever<List>(
      observable: datos,
      onChange: (nuevosDatos) {
        // Actualizar la UI con los nuevos datos
        update();
      },
    );
  }

  @override
  void onClose() {
    // Desuscribirse del observable al cerrar el controlador
    trabajadorDatos.dispose(); 
  }
}
```

<br>

### JUtils

La clase `JUtils` ofrece una amplia gama de funciones de utilidad para simplificar tareas comunes en tu aplicación Flutter, desde la generación de IDs únicos hasta la validación de datos y la manipulación de cadenas.

**Categorías de funciones**:

- **Generación de IDs**: Crea identificadores únicos para tus datos.
- **Validación de datos**: Verifica la validez de diferentes tipos de datos, como correos electrónicos, URLs, números de teléfono, etc.
- **Manipulación de cadenas**: Realiza operaciones de transformación y análisis de cadenas.
- **Utilidades generales**: Funciones para comprobar la longitud de valores, trabajar con tipos de archivos y otras operaciones útiles.

**Métodos**:

**Generación de IDs**:

- **`generateUniqueID([idLength])`**: Genera un ID único aleatorio de la longitud especificada (por defecto 16 caracteres).

**Validación de datos**:

- **`isNull(value)`**: Comprueba si un valor es nulo.
- **`isNullOrBlank(value)`**: Comprueba si un valor es nulo o una cadena vacía o con solo espacios en blanco.
- **`isBlank(value)`**: Comprueba si un valor es una cadena vacía o con solo espacios en blanco.
- **`isNum(value)`**: Comprueba si una cadena representa un número (entero o decimal).
- **`isNumericOnly(s)`**: Comprueba si una cadena contiene solo dígitos numéricos (sin puntos decimales).
- **`isAlphabetOnly(s)`**: Comprueba si una cadena contiene solo letras del alfabeto (sin espacios).
- **`hasCapitalLetter(s)`**: Comprueba si una cadena contiene al menos una letra mayúscula.
- **`isBool(value)`**: Comprueba si una cadena representa un valor booleano ("true" o "false").
- **`isFileType(filePath, type)`**: Comprueba si una ruta de archivo corresponde a un tipo de archivo específico (video, imagen, audio, etc.).
- **`isUsername(s)`**: Comprueba si una cadena es un nombre de usuario válido.
- **`isURL(s)`**: Comprueba si una cadena es una URL válida.
- **`isEmail(s)`**: Comprueba si una cadena es una dirección de correo electrónico válida.
- **`isPhoneNumber(s)`**: Comprueba si una cadena es un número de teléfono válido.
- **`isDateTime(s)`**: Comprueba si una cadena representa una fecha y hora válidas (formato UTC o ISO8601).
- **`isMD5(s)`**: Comprueba si una cadena es un hash MD5 válido.
- **`isSHA1(s)`**: Comprueba si una cadena es un hash SHA1 válido.
- **`isSHA256(s)`**: Comprueba si una cadena es un hash SHA256 válido.
- **`isSSN(s)`**: Comprueba si una cadena es un número de Seguridad Social válido (formato estadounidense).
- **`isBinary(s)`**: Comprueba si una cadena contiene solo caracteres binarios (0 o 1).
- **`isIPv4(s)`**: Comprueba si una cadena es una dirección IPv4 válida.
- **`isIPv6(s)`**: Comprueba si una cadena es una dirección IPv6 válida.
- **`isHexadecimal(s)`**: Comprueba si una cadena es un valor hexadecimal válido (con o sin prefijo "#").
- **`isPassport(s)`**: Comprueba si una cadena es un número de pasaporte válido.
- **`isCurrency(s)`**: Comprueba si una cadena representa una cantidad de moneda válida.

**Manipulación de cadenas**:

- **`capitalizeFirst(s)`**: Convierte la primera letra de una cadena a mayúscula y el resto a minúsculas.
- **`capitalize(s)`**: Convierte la primera letra de cada palabra de una cadena a mayúscula.
- **`removeAllWhitespace(s)`**: Elimina todos los espacios en blanco de una cadena.
- **`camelCase(value)`**: Convierte una cadena a formato camelCase (ejemplo: "miVariableEjemplo").
- **`snakeCase(text, {separator})`**: Convierte una cadena a formato snake_case (ejemplo: "mi_variable_ejemplo").
- **`paramCase(text)`**: Convierte una cadena a formato param-case (ejemplo: "mi-variable-ejemplo").
- **`numericOnly(s, {firstWordOnly})`**: Extrae los números de una cadena, opcionalmente solo el primer grupo de números.

**Utilidades generales**:

- **`isLengthGreaterThan(value, maxLength)`**: Comprueba si la longitud de un valor (cadena, lista o número) es mayor que la longitud máxima especificada.
- **`isLengthGreaterOrEqual(value, maxLength)`**: Comprueba si la longitud de un valor es mayor o igual que la longitud máxima especificada.
- **`isLengthLessThan(value, maxLength)`**: Comprueba si la longitud de un valor es menor que la longitud máxima especificada.
- **`isLengthLessOrEqual(value, maxLength)`**: Comprueba si la longitud de un valor es menor o igual que la longitud máxima especificada.
- **`isLengthEqualTo(value, otherLength)`**: Comprueba si la longitud de un valor es igual a la longitud especificada.
- **`isLengthBetween(value, minLength, maxLength)`**: Comprueba si la longitud de un valor está entre dos longitudes especificadas.
- **`isPalindrom(s)`**: Comprueba si una cadena es un palíndromo (se lee igual de izquierda a derecha que de derecha a izquierda).
- **`isOneAKind(value)`**: Comprueba si todos los elementos de un valor (cadena, lista o número) son iguales.
- **`isCaseInsensitiveContains(a, b)`**: Comprueba si una cadena contiene otra cadena, ignorando las mayúsculas y minúsculas.
- **`isCaseInsensitiveContainsAny(a, b)`**: Comprueba si una cadena contiene otra cadena o viceversa, ignorando las mayúsculas y minúsculas.

**Ejemplos**:

```dart
// Generar un ID único
String nuevoId = JUtils.generateUniqueID();

// Validar una dirección de correo electrónico
bool esCorreoValido = JUtils.isEmail('ejemplo@correo.com');

// Convertir una cadena a snake_case
String textoEnSnakeCase = JUtils.snakeCase('MiTextoDeEjemplo');

// Comprobar si una lista tiene más de 5 elementos
bool listaLarga = JUtils.isLengthGreaterThan([1, 2, 3, 4, 5, 6], 5);
```

<br>

## Ejemplos

- [`Reactive State Counter`](https://github.com/javierfernandezvaca/JSM/tree/master/examples/reactive_state_counter) : Aplicación clásica del contador que utiliza la **gestión de estado reactiva** haciendo uso del sistema de `observables` y `observadores` de JSM. Patrón de diseño de software utilizado: `Clean Architecture`.

- [`Simple State Counter`](https://github.com/javierfernandezvaca/JSM/tree/master/examples/simple_state_counter) : Aplicación clásica del contador que utiliza la **gestión de estado simple** haciendo uso del método `update()` y `JBuilderWidget` de JSM. Patrón de diseño de software utilizado: `Clean Architecture`.


- [`TODOS`](https://github.com/javierfernandezvaca/JSM/tree/master/examples/todos) : Aplicación de lista de tareas que utiliza la **gestión de estado reactiva** de JSM. Esta aplicación permite a los usuarios agregar, eliminar y marcar tareas como completadas, utilizando el sistema de `observables` y `observadores` de JSM para actualizar automáticamente la interfaz de usuario en respuesta a los cambios de estado. Patrón de diseño de software utilizado: `Clean Architecture`.

- [`Translations and Themes`](https://github.com/javierfernandezvaca/JSM/tree/master/examples/translations_and_themes) : Aplicación sencilla que utiliza JSM para manejar la `internacionalización` y los `temas visuales`, permitiendo a los usuarios cambiar entre diferentes idiomas y temas. Patrón de diseño de software utilizado: `Clean Architecture`.

- [`Modals and Dialogs`](https://github.com/javierfernandezvaca/JSM/tree/master/examples/modals_and_dialogs) : Aplicación sencilla que utiliza JSM para manejar la apertura y cierre de `modales y diálogos`, permitiendo a los usuarios interactuar con diferentes tipos de elementos emergentes en la interfaz de usuario. Patrón de diseño de software utilizado: `Clean Architecture`.

- [`Chat`](https://github.com/javierfernandezvaca/JSM/tree/master/examples/modals_and_dialogs) : Aplicación de chat en tiempo real desarrollada con el enfoque MVC (Modelo-Vista-Controlador) y la gestión de estado reactiva de JSM. Esta aplicación permite a los usuarios enviar y recibir mensajes instantáneamente. Utiliza el sistema de observables y observadores de JSM y poder de Firebase, garantizando una experiencia de chat fluida y eficiente. Patrón de diseño de software utilizado: `MVC (Model-View-Controller)`.

- [`Tic Tac Toe`](https://github.com/javierfernandezvaca/JSM/tree/master/examples/tic_tac_toe) : Juego de Tic Tac Toe que utiliza la **gestión de estado reactiva** y el patrón de diseño MVVM (Model-View-ViewModel) de JSM. Esta aplicación permite a los usuarios jugar al Tic Tac Toe con una interfaz de usuario reactiva que se actualiza automáticamente en respuesta a los cambios de estado. Patrón de diseño de software utilizado: `MVVM (Model-View-ViewModel)`.

<br>

## Agradecimientos

Muchas gracias por tu interés en JSM. Espero que esta biblioteca te sea útil para crear aplicaciones Flutter robustas y escalables.


# **JSM**

Librería de código abierto para Flutter que integra la **gestión de estado**, la **inyección de dependencias** y la **gestión de rutas** en una sola solución.

Su principal objetivo es permitir un desacoplamiento completo de la interfaz de usuario y la lógica de negocio, lo que facilita la creación de aplicaciones robustas y escalables.

Está diseñada con un enfoque basado en el rendimiento y la productividad, al minimizar el consumo de recursos mientras proporciona una sintaxis sencilla y fácil de usar.

<br>

## Características

- [Instalación](#instalación)
- [Configuración inicial](#instalación)
- Bases de **JSM**
  - [Gestión de estado](#gestión-de-estado)
  - [Inyección de dependencias](#inyección-de-dependencias)
  - [Gestión de rutas](#gestión-de-rutas)
  - [Gestión de servicios](#gestión-de-servicios)
- [Utilidades](#utilidades)
  - [Internacionalización](#internacionalización) - `No`
  - [Temas Visuales](#temas-visuales) - `No`
- [Ejemplos](#ejemplos)

<br>

## Instalación

Añada la librería **JSM** a su archivo `pubspec.yaml`:

```yaml
dependencies:
  jsm:
    git:
      url: https://github.com/javierfernandezvaca/JSM.git
      ref: master
```

Luego, importe la librería **JSM** en cada uno de los archivos en los se utilizará:

```dart
import 'package:jsm/jsm.dart';
```

<br>

## Gestión de estado

La gestión de estado es un componente esencial en el desarrollo de aplicaciones. Esta se refiere a cómo se manejan los datos que determinan la interfaz de usuario y cómo estos cambian en respuesta a las interacciones del usuario. **JSM** ofrece dos formas diferentes de administrar el estado:

- [Administración de estado simple](#administración-de-estado-simple)
- [Administración de estado reactiva](#administración-de-estado-reactiva)

<br>

### Administración de estado simple

El mecanismo de la administración de estado simple de **JSM**, es una herramienta poderosa que utiliza el método `update()` con una lista opcional de identificadores de cada widget especial `JBuilderWidget`, que ofrece varias ventajas que lo hacen una opción eficiente y flexible para actualizar la interfaz de usuario; asi como:

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
class MyController extends JController {
  String message = "Hola mundo";

  void setMessage(String text) {
    message = text;
    update(['messageId']);
  }
}
```
Explicación:

- `MyController`: Es la clase controladora que maneja el estado y la lógica de negocio.
- `message`: Es una variable de estado que contiene el mensaje a mostrar en la interfaz de usuario.
- `setMessage`: Es el método que actualiza el mensaje y llama a `update(['messageId'])` para notificar a los widgets que necesitan actualizarse.

<br>

> **Interfaz de usuario**

```dart
// Método #1
JBuilderWidget<MyController>(
  id: 'messageId',
  onChange: (context, controller) {
    return Text(controller.message);
  },
)
```

Explicación:

- `JBuilderWidget`: Es el widget especializado que se actualiza en respuesta a los cambios en el estado del controlador.
- `id`: Es el identificador único que se usa para asociar este widget con el estado específico del controlador que debe observar.
- `onChange`: Una función que se llama cuando el estado cambia, permitiendo actualizar el widget con el nuevo estado.

```dart
// Método #2
var controller = JDependency.find<MyController>();

controller.builder(
  id: 'messageId',
  onChange: (context, controller) => Text(controller.counter),
);
```

Explicación:

- `controller`: La instancia del controlador que maneja el estado y la lógica de negocio.
- `controller.builder`: La extensión o método que construye el widget basado en el estado actual del controlador.
- `id`: Es el identificador único que se usa para asociar este widget con el estado específico del controlador que debe observar.
- `onChange`: Una función que se llama cuando el estado cambia, permitiendo actualizar el widget con el nuevo estado.

<br>

### Administración de estado reactiva

La administración de estado reactiva de **JSM**, es una herramienta poderosa que permite crear interfaces de usuario dinámicas y sensibles a los cambios de estado de forma intuitiva y eficiente.

A diferencia de la administración de estado simple, este enfoque se basa en el paradigma reactivo (liberándote de las actualizaciones manuales), donde cada widget especial `JObserverWidget` se actualiza automáticamente en respuesta a cambios en su respectiva variable observable `.observable`. Todo esto permite crear aplicaciones fluidas, eficientes y adaptables que se actualizan en tiempo real y ofrece varias ventajas para actualizar la interfaz de usuario; asi como:

- **Fluidez y rendimiento**:
  - El mecanismo realiza actualizaciones precisas, donde solo se actualizan los `JObserverWidget` que dependen de sus respectivas variables modificadas `.observable`, optimizando el rendimiento y la experiencia del usuario.
  - Realiza menos consumo de recursos evitando los redibujados innecesarios, provocando el desarrollo de aplicaciones más eficientes y responsables.

- **Versátilidad**:
  - Este enfoque permite la creación de aplicaciones escalables y robustas, que se adaptan a las necesidades del usuario, que van desde aplicaciones simples hasta interfaces complejas con un alto volumen de datos.
  - Es fácil de integrar y se puede combinar JSM con su flujo de trabajo actual y comenzar a disfrutar de sus beneficios de inmediato.

<br>

Ejemplo:

> Lógica de negocio:

```dart
class MyController extends JController {
  var message = "Hola mundo".observable;

  void setMessage(String text) {
    message.value = text;
  }
}
```

Explicación:

- `MyController`: Es la clase controladora que maneja el estado y la lógica de negocio.
- `message`: Es la variable observable que contiene el mensaje a mostrar en la interfaz de usuario. Al ser observable, cualquier cambio en su valor notificará automáticamente a los widgets que dependen de ella.
- `setMessage`: Es el método que actualiza el valor de message. Al cambiar el valor de message, los widgets observadores se actualizarán automáticamente.

<br>

> Interfaz de usuario:
```dart
// Método #1
var controller = JDependency.find<MyController>();
// ...
JObserverWidget<String>(
  observable: controller.message,
  onChange: (String message) {
    return Text(message);
  },
)
```

Explicación:

- `controller`: Es la instancia del controlador que maneja el estado y la lógica de negocio.
- `JObserverWidget`: Un widget especializado que se actualiza automáticamente en respuesta a los cambios en la variable observable.
- `observable`: La variable observable del controlador que este widget observará.
- `onChange`: Una función que se llama cada vez que el valor de la variable observable cambia, permitiendo actualizar el widget con el nuevo valor.


```dart
// Método #2
var controller = JDependency.find<MyController>();
// ...
controller.message.observer((String message) => Text(message))
```

Explicación:

- `controller`: Una instancia del controlador que maneja el estado y la lógica de negocio.
- `controller.message.observer`: La extensión o método que permite observar los cambios en la variable observable `message` y actualizar el widget en consecuencia.

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

La clase **JDependency** de **JSM** es una herramienta eficiente para gestionar las dependencias. Utiliza un mapa para almacenar y administrar las dependencias, permitiendo un manejo más dinámico y flexible en comparación con la gestión de dependencias tradicional. **JDependency** permite que las dependencias sean permanentes o no permanentes. Las dependencias no permanentes pueden ser eliminadas, mientras que las dependencias permanentes no pueden ser eliminadas.

Las ventajas de usar JDependency incluyen:

- **Eficiencia**: Al utilizar un mapa para almacenar las dependencias, JDependency permite un acceso rápido y eficiente a las dependencias cuando se necesitan.

- **Flexibilidad**: Con la capacidad de marcar dependencias como permanentes o no permanentes, tienes un control total sobre el ciclo de vida de tus dependencias.

- **Manejo de Múltiples Instancias**: Permite manejar múltiples dependencias del mismo tipo utilizando nombres de instancia opcionales.

<br>

Ejemplos:

> **Definición de una dependencia**

```dart
class MyDependency {
  // ...
  MyDependency();
}
```

> **Añadir una dependencia**

```dart
// Añadir una dependencia sin nombre de instancia
JDependency.put<MyDependency>(MyDependency());

// Añadir una dependencia con nombre de instancia
JDependency.put<MyDependency>(MyDependency(), instanceName: 'D1');
```

> **Encontrar una dependencia**

```dart
// Encontrar una dependencia sin nombre de instancia
var myDependency = JDependency.find<MyDependency>();

// Encontrar una dependencia con nombre de instancia
var myDependencyNamed = JDependency.find<MyDependency>(instanceName: 'D1');
```
> **Verificar la existencia de una dependencia**

```dart
// Verificar si una dependencia existe sin nombre de instancia
bool exists = JDependency.exists<MyDependency>();

// Verificar si una dependencia existe con nombre de instancia
bool existsNamed = JDependency.exists<MyDependency>(instanceName: 'D1');
```

> **Eliminar una dependencia**

```dart
// Eliminar una dependencia (no permanente) sin nombre de instancia
JDependency.delete<MyDependency>();

// Eliminar una dependencia (no permanente) con nombre de instancia
JDependency.delete<MyDependency>(instanceName: 'D1');
```

> **Eliminar todas las dependencias**
```dart
// Eliminar todas las dependencias (permanentes y no permanentes)
JDependency.clear();
```

<br>

## Gestión de rutas

La clase **JRouter** de **JSM** proporciona una serie de métodos para facilitar la navegación entre diferentes rutas en una aplicación. A continuación se presentan algunos ejemplos de cómo utilizar estos métodos:

> **Navegar a una nueva pantalla**

Para navegar a una nueva pantalla, puedes utilizar el método `toNamed()`. Este método toma el nombre de la ruta como argumento. Por ejemplo:

```dart
JRouter.toNamed('/NextScreen');
```

> **Cerrar elementos de la interfaz de usuario**

Si necesitas cerrar snackbars, diálogos, bottomsheets o cualquier otro elemento que normalmente cerrarías con `Navigator.pop(context)`, puedes utilizar el método `back()`. Por ejemplo:

```dart
JRouter.back();
```

> **Navegar a la siguiente pantalla sin opción a volver**

Si necesitas navegar a una nueva pantalla y asegurarte de que el usuario no pueda volver a la pantalla anterior (útil, por ejemplo, en SplashScreens, LoginScreen, etc.), puedes utilizar el método `offNamed()`. Este método reemplaza la ruta actual con la nueva ruta. Por ejemplo:

```dart
JRouter.offNamed('/NextScreen');
```

> **Navegar a la siguiente pantalla y cancelar todas las rutas anteriores**

Si necesitas navegar a una nueva pantalla y eliminar todas las rutas anteriores de la pila de navegación (útil en carritos de compras, encuestas y exámenes), puedes utilizar el método `offAllNamed()`. Por ejemplo:

```dart
JRouter.offAllNamed('/NextScreen');
```

> **Navegar a la siguiente ruta y recibir o actualizar datos tan pronto como se regrese de ella**

Si necesitas navegar a una nueva ruta y esperar un resultado cuando se regrese de ella, puedes utilizar el método `toNamed()` y esperar el resultado. Por ejemplo:

```dart
var data = await JRouter.toNamed('/Payment');
```

<br>

## Gestión de servicios

La clase **JService** de **JSM** es una herramienta abstracta para gestionar los servicios de manera eficiente. Utiliza un mapa para almacenar y administrar los servicios, proporcionando métodos para iniciar, detener, obtener y verificar si un servicio está en ejecución. Cada servicio se almacena con una clave única que se genera a partir del tipo del servicio y un nombre de instancia opcional.

Las ventajas de usar JService incluyen:

- **Eficiencia**: Al utilizar un mapa para almacenar los servicios, JService permite un acceso rápido y eficiente a los servicios cuando se necesitan.

- **Flexibilidad**: Con la capacidad de manejar múltiples instancias de servicios mediante nombres de instancia opcionales, tienes un control total sobre el ciclo de vida de tus servicios.

- **Modularidad**: Facilita la gestión modular de los servicios, permitiendo iniciar y detener servicios de manera independiente.

<br>

Ejemplos:

> **Definición de un servicio**

```dart
class MyService extends JService {  
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
await JService.start<MyService>(MyService());

// Iniciar un servicio con nombre de instancia
await JService.start<MyService>(MyService(), instanceName: 'S1');
```

> **Detener un servicio**

```dart
// Detener un servicio sin nombre de instancia
await JService.stop<MyService>();

// Detener un servicio con nombre de instancia
await JService.stop<MyService>(instanceName: 'S1');
```

> **Encontrar un servicio**

```dart
// Encontrar un servicio sin nombre de instancia
var myService = JService.find<MyService>();

// Encontrar un servicio con nombre de instancia
var myServiceNamed = JService.find<MyService>(instanceName: 'S1');
```

> **Verificar si un servicio está en ejecución**

```dart
// Verificar si un servicio está en ejecución sin nombre de instancia
bool isRunning = JService.isRunning<MyService>();

// Verificar si un servicio está en ejecución con nombre de instancia
bool isRunningNamed = JService.isRunning<MyService>(instanceName: 'S1');
```

> **Detener todos los servicios**

```dart
// Detener todos los servicios
JService.stopAll();
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

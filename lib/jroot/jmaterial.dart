import 'package:flutter/material.dart';

import '../jdialog/jdialog.dart';
import '../jreactive/jwidgets.dart';
import '../jrouter/jroute.dart';
import '../jrouter/jrouter.dart';
import '../jrouter/jrouter_observer.dart';
import '../jtheme/jtheme.dart';
import '../jtranslation/jlanguage.dart';
import '../jtranslation/jtranslation.dart';

/// Una clase que extiende `StatefulWidget` y proporciona una interfaz
/// para configurar una aplicación de Material Design.
///
/// Esta clase toma varios parámetros que permiten personalizar la
/// apariencia y el comportamiento de la aplicación, incluyendo el
/// tema, las rutas, la localización, y varias opciones de depuración.
class JMaterialApp extends StatefulWidget {
  const JMaterialApp({
    super.key,
    this.home,
    this.routes = const <JRoute>[],
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.translations,
  })  : routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        backButtonDispatcher = null,
        routerConfig = null;

  final Widget? home;
  final List<JRoute> routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;
  final RouterConfig<Object>? routerConfig;
  final TransitionBuilder? builder;
  final String title;
  final GenerateAppTitle? onGenerateTitle;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final ThemeMode? themeMode;
  final Color? color;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior? scrollBehavior;
  final bool debugShowMaterialGrid;

  static HeroController createMaterialHeroController() {
    return HeroController(
      createRectTween: (Rect? begin, Rect? end) {
        return MaterialRectArcTween(begin: begin, end: end);
      },
    );
  }

  final List<JLanguage>? translations;

  @override
  State<JMaterialApp> createState() => _JMaterialAppState();
}

/// `_JMaterialAppState` es una clase que extiende `State` y representa
/// el estado de un objeto `JMaterialApp`.
///
/// Esta clase maneja la inicialización y la limpieza de los recursos
/// de la aplicación, así como la construcción de la interfaz de usuario
/// de la aplicación.
class _JMaterialAppState extends State<JMaterialApp> {
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    if (!_localeInitialized) {
      // Configurar la internacionalización
      JTranslations.locale.value = widget.locale ?? JTranslations.defaultLocale;
      _localeInitialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Configurar los idiomas
    var map = <String, Map<String, String>>{};
    if (widget.translations != null && widget.translations!.isNotEmpty) {
      for (var language in widget.translations!) {
        var translationsMap = <String, String>{};
        for (var translation in language.translations) {
          translationsMap[translation.key] = translation.value;
        }
        String countryKey = language.locale.countryCode != null
            ? '_${language.locale.countryCode}'
            : '';
        map[language.locale.languageCode + countryKey] = translationsMap;
      }
    }
    JTranslations.keys = map;
    // Configurar las rutas
    JRouter.routes.clear();
    JRouter.routes.addAll(widget.routes);
    final appRoutes = JRouter.routesToMap(context);
    // Configurar los temas
    return JObserverWidget<ThemeData>(
      observable: JTheme.currentTheme,
      onChange: (_) {
        // MaterialApp clásico
        return MaterialApp(
          navigatorKey: JRouter.navigatorKey,
          scaffoldMessengerKey: JDialog.scaffoldMessengerKey,
          home: widget.home,
          routes: appRoutes,
          initialRoute: widget.initialRoute ?? JRouter.initialRoute,
          onGenerateRoute: widget.onGenerateRoute,
          onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
          onUnknownRoute: widget.onUnknownRoute,
          navigatorObservers: [JRouterObserver()],
          builder: widget.builder,
          title: widget.title,
          onGenerateTitle: widget.onGenerateTitle,
          color: widget.color,
          theme: JTheme.currentTheme.value,
          // darkTheme: JTheme.darkTheme,
          highContrastTheme: widget.highContrastTheme,
          highContrastDarkTheme: widget.highContrastDarkTheme,
          themeMode: widget.themeMode,
          locale: JTranslations.locale.value,
          localizationsDelegates: widget.localizationsDelegates,
          localeListResolutionCallback: widget.localeListResolutionCallback,
          localeResolutionCallback: widget.localeResolutionCallback,
          supportedLocales: widget.supportedLocales,
          debugShowMaterialGrid: widget.debugShowMaterialGrid,
          showPerformanceOverlay: widget.showPerformanceOverlay,
          checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
          showSemanticsDebugger: widget.showSemanticsDebugger,
          debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
          shortcuts: widget.shortcuts,
          actions: widget.actions,
          restorationScopeId: widget.restorationScopeId,
          scrollBehavior: widget.scrollBehavior,
        );
      },
    );
  }
}

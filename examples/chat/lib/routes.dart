import 'package:jsm/jsm.dart';

import 'package:chat/pages/chat/view.dart';
import 'package:chat/pages/login/view.dart';

String initialRoute = '/login';

List<JRoute> routes = <JRoute>[
  JRoute(route: initialRoute, page: const LoginPage()),
  JRoute(route: '/chat', page: const ChatPage()),
];

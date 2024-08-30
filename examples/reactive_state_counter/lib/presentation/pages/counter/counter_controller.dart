import 'package:jsm/jsm.dart';

class CounterController extends JController {
  var counter = 0.observable;

  void increment() {
    counter.value++;
  }
}

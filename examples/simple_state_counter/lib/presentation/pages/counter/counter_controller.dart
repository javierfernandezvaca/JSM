import 'package:jsm/jsm.dart';

class CounterController extends JController {
  var counter = 0;

  void increment() {
    counter++;
    // update();
    update(['counter']);
  }
}

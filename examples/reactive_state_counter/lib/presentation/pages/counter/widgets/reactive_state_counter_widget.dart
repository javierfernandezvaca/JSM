import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import '../counter_controller.dart';

class ReactiveStateCounterWidget extends StatelessWidget {
  const ReactiveStateCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ...
    final controller = JDependency.find<CounterController>();
    // ...
    // Use Widget
    // ...
    return JObserverWidget<int>(
      observable: controller.counter,
      onChange: (int counter) {
        return Text(
          '$counter',
          style: Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
    // ...
    // Use Extension
    // ...
    // return controller.counter.observer(
    //   (int counter) => Text(
    //     '$counter',
    //     style: Theme.of(context).textTheme.headlineMedium,
    //   ),
    // );
    // ...
  }
}

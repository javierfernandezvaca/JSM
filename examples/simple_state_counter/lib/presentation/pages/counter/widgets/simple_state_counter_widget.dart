import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import '../counter_controller.dart';

class SimpleStateCounterWidget extends StatelessWidget {
  const SimpleStateCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ...
    // Use Widget
    // ...
    // return JBuilderWidget<CounterController>(
    //   id: 'counter',
    //   onChange: (BuildContext _, CounterController controller) {
    //     return Text(
    //       '${controller.counter}',
    //       style: Theme.of(context).textTheme.headlineMedium,
    //     );
    //   },
    // );
    // ...
    // Use Extension
    // ...
    final controller = JDependency.find<CounterController>();
    // ...
    return controller.builder(
      id: 'counter',
      onChange: (BuildContext _, CounterController ctrl) => Text(
        '${ctrl.counter}',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
    // ...
  }
}

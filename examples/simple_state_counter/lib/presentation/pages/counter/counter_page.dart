import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'counter_controller.dart';
import 'widgets/simple_state_counter_widget.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return JPage(
      create: () => CounterController(),
      builder: (BuildContext _, CounterController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Simple State Counter'),
          ),
          body: const Center(
            child: SimpleStateCounterWidget(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.increment,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

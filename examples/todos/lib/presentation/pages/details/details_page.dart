import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'details_controller.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return JPage(
      create: () => DetailsController(),
      builder: (context, controller) {
        return Scaffold(
          appBar: AppBar(
            title: controller.edition
                ? const Text('Edit Task')
                : const Text('New Task'),
          ),
          body: Center(
            child: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: controller.title,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: controller.description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  JObserverWidget(
                    observable: controller.completed,
                    onChange: (completed) {
                      return CheckboxListTile(
                        title: const Text('Completed'),
                        value: completed,
                        onChanged: (value) {
                          controller.completed.value = value!;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              controller.addTodo();
            },
            label:
                controller.edition ? const Text('Update') : const Text('Save'),
          ),
        );
      },
    );
  }
}

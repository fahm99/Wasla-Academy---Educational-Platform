import 'package:flutter/material.dart';
import 'package:waslaacademy/src/user/widgets/custom_button.dart';

class TestButtonScreen extends StatelessWidget {
  const TestButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Custom Button'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomButton(
              text: 'Gold Button with Black Text',
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Gold Button with Icon',
              icon: Icons.star,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text:
                  'This is a very long text that should be fully visible and properly displayed within the button',
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Loading Button',
              isLoading: true,
            ),
          ],
        ),
      ),
    );
  }
}

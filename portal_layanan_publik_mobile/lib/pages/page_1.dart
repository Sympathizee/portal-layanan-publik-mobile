import 'package:flutter/material.dart';
import '../core/widgets/buttons/custom_button.dart';
import '../core/widgets/navigation/custom_app_bar.dart';
import 'page_1_1.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Page 1'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is Page 1',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Go to Page 1.1',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Page1_1()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/widgets/navigation/custom_app_bar.dart';

class Page1_1 extends StatelessWidget {
  const Page1_1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Page 1.1'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'This is Page 1.1',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/buttons/custom_button.dart';
import '../core/widgets/inputs/custom_text_field.dart';
import '../core/widgets/layout/custom_card.dart';
import '../core/widgets/navigation/custom_app_bar.dart';

class PageTest extends StatelessWidget {
  const PageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Components Gallery (Page Test)',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buttons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Primary Button',
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Secondary Button',
              type: CustomButtonType.secondary,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Outline Button',
              type: CustomButtonType.outline,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Text Button',
              type: CustomButtonType.text,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Custom Styled Button',
              backgroundColor: AppColors.positive600,
              textColor: Colors.white,
              borderRadius: 24,
              shadow: [
                BoxShadow(
                  color: AppColors.positive600.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
              icon: const Icon(Icons.check, color: Colors.white, size: 20),
              onPressed: () {},
            ),
            const SizedBox(height: 32),
            const Text(
              'Text Fields',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const CustomTextField(
              label: 'Standard Input',
              hintText: 'Enter some text...',
              prefixIcon: Icon(Icons.search, color: AppColors.contentSecondary),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Custom Styled Input',
              hintText: 'Custom border radius and fill...',
              borderRadius: 24,
              fillColor: AppColors.guide100,
              borderColor: AppColors.guide600,
            ),
            const SizedBox(height: 32),
            const Text(
              'Cards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Standard Card',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This is a custom card using the default parameters. It has a subtle border and shadow.',
                    style: TextStyle(color: AppColors.contentSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomCard(
              backgroundColor: AppColors.brandPrimary,
              borderRadius: 20,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Custom Styled Card',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This card overrides the default background color, padding, and border radius.',
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Action',
                    type: CustomButtonType.secondary,
                    onPressed: () {},
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

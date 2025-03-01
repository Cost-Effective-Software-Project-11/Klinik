import 'package:flutter/material.dart';
import 'package:flutter_gp5/design_system/molecules/button/primary_button/primary_button.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.primaryButtonTitle,
    this.scrollable = false,
  });

  final String title;
  final String content;
  final bool scrollable;
  final String primaryButtonTitle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: scrollable,
      title: Center(child: Text(title)),
      content: Text(content),
      actions: [
        PrimaryButton.small(
          title: primaryButtonTitle,
          onPressed: () => context.pop(),
        )
      ],
    );
  }
}

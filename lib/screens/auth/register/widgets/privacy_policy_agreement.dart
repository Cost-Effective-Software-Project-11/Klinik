import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gp5/design_system/atoms/dimensions.dart';
import 'package:flutter_gp5/design_system/atoms/spaces.dart';
class PrivacyPolicyAgreement extends FormField<bool> {
  final void Function() onShowTermsOfServiceDialog;
  final void Function(BuildContext) onShowPrivacyPolicyDialog;

  PrivacyPolicyAgreement({
    super.key,
    required this.onShowTermsOfServiceDialog,
    required this.onShowPrivacyPolicyDialog,
  }) : super(
    initialValue: false,
    validator: (value) =>
    value == true ? null : 'You must accept the Terms',
    builder: (FormFieldState<bool> state) {
      final theme = Theme.of(state.context);
      final isError = state.hasError && state.value == false;

      return Padding(
        padding: dimen.horizontal.sm + dimen.vertical.xxs,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: state.value,
                  onChanged: (value) {
                    state.didChange(value);
                  },
                  side: BorderSide(
                    color: isError
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    width: nano,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      _clickableText(
                        'Terms of \nUse',
                        theme.colorScheme.primary,
                            () => onShowTermsOfServiceDialog(),
                      ),
                      const TextSpan(text: ' and '),
                      _clickableText(
                        'Privacy Policy',
                        theme.colorScheme.primary,
                            () => onShowPrivacyPolicyDialog(state.context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: micro),
                child: Text(
                  state.errorText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: xxsPlus,
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );

  static TextSpan _clickableText(String text, Color color, VoidCallback onTap) {
    return TextSpan(
      text: text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
      recognizer: TapGestureRecognizer()..onTap = onTap,
    );
  }
}

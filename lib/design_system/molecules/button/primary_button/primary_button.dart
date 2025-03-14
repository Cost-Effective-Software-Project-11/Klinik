import 'package:flutter/material.dart';
import 'package:flutter_gp5/design_system/atoms/spaces.dart';
import 'package:flutter_gp5/design_system/molecules/button/action_button.dart';
import 'package:flutter_gp5/design_system/themes/klinik_colors.dart';
import 'package:flutter_gp5/enums/action_button_size.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton._({
    super.key,
    required this.title,
    required this.isLoading,
    required ActionButtonSize buttonType,
    this.onPressed,
    this.icon,
  }) : _buttonType = buttonType;

  factory PrimaryButton.responsive({
    Key? key,
    required String title,
    bool isLoading = false,
    VoidCallback? onPressed,
    Widget? icon,
  }) =>
      PrimaryButton._(
        key: key,
        title: title,
        isLoading: isLoading,
        buttonType: ActionButtonSize.responsive,
        onPressed: onPressed,
        icon: icon,
      );

  factory PrimaryButton.blocked({
    Key? key,
    required String title,
    bool isLoading = false,
    VoidCallback? onPressed,
    Widget? icon,
  }) =>
      PrimaryButton._(
        key: key,
        title: title,
        isLoading: isLoading,
        buttonType: ActionButtonSize.blocked,
        onPressed: onPressed,
        icon: icon,
      );

  factory PrimaryButton.small({
    Key? key,
    required String title,
    bool isLoading = false,
    VoidCallback? onPressed,
    Widget? icon,
  }) =>
      PrimaryButton._(
        key: key,
        title: title,
        isLoading: isLoading,
        buttonType: ActionButtonSize.small,
        onPressed: onPressed,
        icon: icon,
      );

  final String title;
  final VoidCallback? onPressed;
  final ActionButtonSize _buttonType;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = KlinikColors(context);
    final primaryColor = Theme.of(context).primaryColor;


    return PortalActionButton(
      title: title,
      onPressed: onPressed,
      activeTitleColor: colors.texts.inverse,
      disabledTitleColor: colors.texts.tertiary,
      isLoading: isLoading,
      loaderColor: colors.icons.inverse,
      buttonType: _buttonType,
      icon: icon,
      loadingButtonColor:
      colors.backgrounds.brand.withAlpha(Color.getAlphaFromOpacity(tiny)),
      disabledButtonColor: colors.backgrounds.subtle,
      buttonColor: primaryColor,
    );
  }
}

extension ActionButtonSizeExtension on ActionButtonSize {
  double get height {
    switch (this) {
      case ActionButtonSize.small:
        return md;
      case ActionButtonSize.blocked:
      case ActionButtonSize.responsive:
        return xl;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gp5/design_system/atoms/dimensions.dart';
import 'package:flutter_gp5/design_system/atoms/spaces.dart';
import 'package:flutter_gp5/design_system/field_validators.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 0,
    this.labelText = '',
    this.hintText = '',
    this.prefixIcon,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          suffixIcon: _buildSuffixIcon(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    // If it's a password field, show toggle visibility button
    if (widget.obscureText) {
      return Padding(
        padding: dimen.horizontal.micro,
        child: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: _togglePasswordVisibility,
        ),
      );
    }

    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}

class CustomDropdownFormField<T> extends StatefulWidget {
  const CustomDropdownFormField({
    super.key,
    required this.padding,
    required this.borderRadius,
    required this.items,
    required this.dropdownValues,
    this.isExpanded = false,
    this.value,
    this.labelText = '',
    this.hintText = '',
    this.prefixIcon,
    this.focusNode,
    this.onSaved,
  });

  final FocusNode? focusNode;
  final EdgeInsetsGeometry padding;
  final IconData? prefixIcon;
  final bool isExpanded;
  final T? value;
  final List<T> items;
  final String labelText;
  final String hintText;
  final double borderRadius;
  final FormFieldSetter<T>? onSaved;
  final String Function(T item) dropdownValues;

  @override
  State<CustomDropdownFormField<T>> createState() =>
      _CustomDropdownFormFieldState<T>();
}

class _CustomDropdownFormFieldState<T> extends State<CustomDropdownFormField<T>> {
  T? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: DropdownButtonFormField<T>(
        validator: FieldValidators.notEmptyObject(),
        menuMaxHeight: imageWidth,
        focusNode: widget.focusNode,
        isExpanded: widget.isExpanded,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIcon),
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        value: _selectedValue,
        items: _dropdownItems(),
        onChanged: _onChanged,
        onSaved: widget.onSaved,
      ),
    );
  }

  void _onChanged(T? value) {
    setState(() {
      _selectedValue = value;
    });
  }

  List<DropdownMenuItem<T>> _dropdownItems() {
    return widget.items
        .map(
          (item) => DropdownMenuItem(
            value: item,
            child: Text(
              widget.dropdownValues(item),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
  }
}

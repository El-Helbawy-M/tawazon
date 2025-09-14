import 'package:flutter/material.dart';

class RadioInputField extends StatefulWidget {
  final String? labelText;
  final String? errorText;
  final bool hasError;
  final String? selectedValue;
  final List<String> options;
  final Function(String)? onChange;
  final bool withBottomPadding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? focusBorderColor;
  final Color? enableBorderColor;

  const RadioInputField({
    super.key,
    required this.options,
    this.labelText,
    this.selectedValue,
    this.onChange,
    this.errorText,
    this.hasError = false,
    this.withBottomPadding = true,
    this.backgroundColor,
    this.borderRadius,
    this.focusBorderColor,
    this.enableBorderColor,
  });

  @override
  State<RadioInputField> createState() => _RadioInputFieldState();
}

class _RadioInputFieldState extends State<RadioInputField> {
  String? selectedValue;

  @override
  void initState() {
    selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.selectedValue == null
        ? (widget.enableBorderColor ?? Colors.grey[400]!)
        : (widget.focusBorderColor ?? Theme.of(context).colorScheme.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        if (widget.labelText != null) const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.options.map((option) {
              return Expanded(
                child: RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    option,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  value: option,
                  groupValue: selectedValue,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (val) {
                    setState(() {
                      selectedValue = val;
                    });
                    widget.onChange?.call(val!);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        if (widget.hasError) const SizedBox(height: 8),
        if (widget.hasError)
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.errorText ?? "Error",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        if (widget.withBottomPadding) const SizedBox(height: 16),
      ],
    );
  }
}

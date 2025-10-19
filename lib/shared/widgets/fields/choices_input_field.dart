import 'package:flutter/material.dart';
import '../../models/select_option.dart';

class ChoicesInputField extends StatefulWidget {
  final String label;
  final SelectOption? selectedOption;
  final List<SelectOption> options;
  final Function(SelectOption) onChange;
  final bool withError;
  final String? errorText;
  final bool withBottomPadding;

  /// New: if true, options will be displayed vertically
  final bool isVerticalLayout;

  const ChoicesInputField({
    super.key,
    required this.label,
    required this.options,
    required this.onChange,
    this.selectedOption,
    this.withBottomPadding = true,
    this.withError = false,
    this.errorText,
    this.isVerticalLayout = false, // default is horizontal
  });

  @override
  State<ChoicesInputField> createState() => _ChoicesInputFieldState();
}

class _ChoicesInputFieldState extends State<ChoicesInputField> {
  SelectOption? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        if(widget.withError) SizedBox(height: 4),
        if(widget.withError) Text(
          widget.errorText ?? 'هذا الحقل مطلوب',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 12),
        widget.isVerticalLayout
            ? Column(
          children: widget.options.map((option) {
            final isSelected = selectedOption?.value == option.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = option;
                  });
                  widget.onChange(option);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected
                        ? selectedColor.withOpacity(0.1)
                        : Colors.grey.shade100,
                    border: Border.all(
                      color: isSelected
                          ? selectedColor
                          : Colors.grey.shade400,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? selectedColor
                          : Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.options.map((option) {
            final isSelected = selectedOption?.value == option.value;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = option;
                    });
                    widget.onChange(option);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? selectedColor.withOpacity(0.1)
                          : Colors.grey.shade100,
                      border: Border.all(
                        color: isSelected
                            ? selectedColor
                            : Colors.grey.shade400,
                        width: 1.2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        option.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: isSelected
                              ? selectedColor
                              : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.withBottomPadding) const SizedBox(height: 16),
      ],
    );
  }
}

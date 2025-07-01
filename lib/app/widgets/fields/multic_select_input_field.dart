import 'dart:developer';

import 'package:flutter/material.dart';
import '../../models/select_option.dart';

class MultiSelectInputField extends StatefulWidget {
  const MultiSelectInputField({
    super.key,
    this.label,
    this.onSelect,
    this.hint = "Select ",
    this.hasError = false,
    this.withBottomPadding = true,
    this.errorText,
    required this.valueSet,
  });

  final Function(DateTime)? onSelect;
  final List<SelectOption> valueSet;
  final String hint;
  final String? label;
  final String? errorText;
  final bool hasError;
  final bool withBottomPadding;


  @override
  State<MultiSelectInputField> createState() => _MultiSelectInputFieldState();
}

class _MultiSelectInputFieldState extends State<MultiSelectInputField> {
  List<SelectOption> options = [];

  String get _selectedOptionsLabels {
    String labels = "";
    for (var option in options) {
      if (option.isSelected) labels += option.label + ", ";
    }
    return labels;
  }

  @override
  void initState() {
    options = widget.valueSet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.label != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.label!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        if (widget.label != null) const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            options = await showMultiOptionsBottomSheet(
              context: context,
              label: widget.label!,
              valueSet: options,
            );
            setState(() {});
          },
          child: Container(
            height: 48,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedOptionsLabels.isEmpty ? widget.hint : _selectedOptionsLabels,
                    style: TextStyle(
                      color: _selectedOptionsLabels.isEmpty ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Icon(Icons.arrow_circle_down)
              ],
            ),
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
                  )),
            ],
          ),
        if (widget.withBottomPadding) const SizedBox(height: 16),

      ],
    );
  }
}

Future<List<SelectOption>> showMultiOptionsBottomSheet({
  required BuildContext context,
  required String label,
  required List<SelectOption> valueSet,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            // Title Row
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context, valueSet),
                ),
                Expanded(
                  child: Text(
                    "Select $label",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // for symmetrical spacing with close button
              ],
            ),

            const SizedBox(height: 8),

            // Option List
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: valueSet.length,
                separatorBuilder: (context, index) => const SizedBox(),
                itemBuilder: (context, index) {
                  return BottomSheetOptionView(
                    option: valueSet[index],
                    onSelect: (option) {
                      // Optionally do something here
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return valueSet;
}


class BottomSheetOptionView extends StatefulWidget {
  const BottomSheetOptionView({
    super.key,
    required this.option,
    required this.onSelect,
  });

  final SelectOption option;
  final Function(SelectOption) onSelect;

  @override
  State<BottomSheetOptionView> createState() => _BottomSheetOptionViewState();
}

class _BottomSheetOptionViewState extends State<BottomSheetOptionView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: widget.option.isSelected ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: widget.option.isSelected ? 1.5 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              widget.option.isSelected = !widget.option.isSelected;
              widget.onSelect(widget.option);
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  Icons.label_outline,
                  size: 22,
                  color: widget.option.isSelected
                      ? Colors.blue
                      : Colors.grey.shade400,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.option.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: widget.option.isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    widget.option.isSelected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    key: ValueKey(widget.option.isSelected),
                    color: widget.option.isSelected
                        ? Colors.blue
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

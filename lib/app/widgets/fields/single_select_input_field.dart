import 'package:flutter/material.dart';
import '../../models/select_option.dart';

class SingleSelectInputField extends StatefulWidget {
  final String label;
  final String hint;
  final SelectOption? selectedValue;
  final List<SelectOption> valueSet;
  final Function(SelectOption) onChange;
  final bool withBottomPadding;
  final String? errorText;
  final bool hasError;
  const SingleSelectInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.valueSet,
    required this.onChange,
    this.selectedValue,
    this.withBottomPadding = true,
    this.errorText,
    this.hasError = false,
  });

  @override
  State<SingleSelectInputField> createState() => _SingleSelectInputFieldState();
}

class _SingleSelectInputFieldState extends State<SingleSelectInputField> {
  late SelectOption? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            )),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final result = await showSingleOptionBottomSheet(
              context: context,
              label: widget.label,
              valueSet: widget.valueSet,
              selected: selected,
            );

            if (result != null) {
              setState(() {
                selected = result;
              });
              widget.onChange(result);
            }
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected == null
                    ? Colors.grey[400]!
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected?.label ?? widget.hint,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: selected == null ? Colors.grey : Colors.black,
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



Future<SelectOption?> showSingleOptionBottomSheet({
  required BuildContext context,
  required String label,
  required List<SelectOption> valueSet,
  SelectOption? selected,
}) async {
  return await showModalBottomSheet<SelectOption>(
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
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    "اختر $label",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: valueSet.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final option = valueSet[index];
                  final isSelected = selected?.value == option.value;

                  return Material(
                    color: isSelected ? Colors.blue.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    elevation: isSelected ? 1.5 : 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pop(context, option);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Icon(
                              Icons.label_outline,
                              size: 22,
                              color: isSelected ? Colors.blue : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option.label,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                isSelected
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked,
                                key: ValueKey(isSelected),
                                color: isSelected ? Colors.blue : Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

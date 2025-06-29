import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';


/// Please make sure you have added the [`currency_picker`](https://pub.dev/packages/currency_picker) package to your `pubspec.yaml` file.
class CurrencyInputField extends StatefulWidget {
  CurrencyInputField({
    super.key,
    TextStyle? hintStyle,
    TextStyle? textStyle,
    required this.onCurrencySelected,
    this.hintText = "Choose country",
    this.labelText = "",
    this.isRequired = false,
    this.errorText,
    this.withBottomPadding = true,
    this.hasError = false,
  }) {
    this.hintStyle = hintStyle ??
        TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[400]);
    this.textStyle = textStyle ?? TextStyle(fontWeight: FontWeight.w300);
  }

  late final TextStyle hintStyle;
  late final TextStyle textStyle;
  final String hintText;
  final String labelText;
  final String? errorText;
  final bool isRequired;
  final bool hasError;
  final bool withBottomPadding;
  final Function(Currency) onCurrencySelected;

  @override
  State<CurrencyInputField> createState() => _CurrencyInputFieldState();
}

class _CurrencyInputFieldState extends State<CurrencyInputField> {
  Currency? currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                showCurrencyPicker(
                  context: context,
                  showFlag: true,
                  showCurrencyName: true,
                  showCurrencyCode: true,
                  onSelect: (Currency value) {
                    currency = value;
                    setState(() {});
                    widget.onCurrencySelected(value);
                  },
                );
              },
              child: Container(
                height: 56,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: currency != null
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[400]!),
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        currency == null ? "Choose currency" : currency!.code,
                        style:
                        currency == null ? widget.hintStyle : widget.textStyle,
                      ),
                    ),
                    if (currency != null)
                      IconButton(
                        onPressed: () {
                          currency = null;
                          setState(() {});
                        },
                        icon: Icon(Icons.close, size: 16),
                      ),
                    if (currency == null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.keyboard_arrow_up_rounded, size: 16),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                        ],
                      ),
                    if (currency == null) SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            if(widget.labelText.isNotEmpty)Positioned(
              top: -6,
              left: 14,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: RichText(
                  text: TextSpan(
                    text: widget.labelText,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary, //
                        fontSize: 10// Label color
                    ),
                    children: [
                      if(widget.isRequired)TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),),
                color: Colors.white,
              ),
            ),
          ],
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
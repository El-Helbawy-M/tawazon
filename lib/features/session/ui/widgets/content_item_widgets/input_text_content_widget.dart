import 'package:flutter/material.dart';
import '../../../core/entities/content_item_entity.dart';
import '../../../../../shared/widgets/fields/text_input_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/session_bloc.dart';

class InputTextContentWidget extends StatefulWidget {
  final ContentItemEntity contentItem;
  final String stepId;

  const InputTextContentWidget({super.key, required this.stepId, required this.contentItem});

  @override
  State<InputTextContentWidget> createState() => _InputTextContentWidgetState();
}

class _InputTextContentWidgetState extends State<InputTextContentWidget> {
  String? value;

  @override
  void initState() {
    super.initState();
    value = widget.contentItem.content;
    context.read<SessionBloc>().setInput(widget.stepId, widget.contentItem.id, value);
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.contentItem.metadata ?? const {};
    final label = metadata['label'] as String?;
    final hint = metadata['hint'] as String?;
    final maxLength = metadata['maxLength'] as int?;
    final required = (metadata['required'] as bool?) ?? false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TextInputField(
        labelText: label,
        hintText: hint,
        initialValue: value,
        maxLength: maxLength,
        validator: required
            ? (v) {
                final val = (v ?? '').trim();
                if (val.isEmpty) return 'هذا الحقل مطلوب';
                return null;
              }
            : null,
        onChange: (val) {
          setState(() => value = val);
          context.read<SessionBloc>().setInput(widget.stepId, widget.contentItem.id, val);
        },
      ),
    );
  }
}

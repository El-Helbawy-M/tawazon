import 'package:flutter/material.dart';
import '../../../core/entities/content_item_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/session_bloc.dart';

class InputLongTextContentWidget extends StatefulWidget {
  final ContentItemEntity contentItem;
  final String stepId;

  const InputLongTextContentWidget({super.key, required this.stepId, required this.contentItem});

  @override
  State<InputLongTextContentWidget> createState() => _InputLongTextContentWidgetState();
}

class _InputLongTextContentWidgetState extends State<InputLongTextContentWidget> {
  late String value;

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
    final minLines = (metadata['minLines'] as int?) ?? 4;
    final maxLines = metadata['maxLines'] as int?;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                required ? '$label *' : label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          TextFormField(
            initialValue: value,
            validator: required
                ? (v) {
                    final val = (v ?? '').trim();
                    if (val.isEmpty) return 'هذا الحقل مطلوب';
                    return null;
                  }
                : null,
            onChanged: (val) {
              setState(() => value = val);
              context.read<SessionBloc>().setInput(widget.stepId, widget.contentItem.id, val);
            },
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: minLines,
            maxLines: maxLines ?? 10,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[400]),
              contentPadding: const EdgeInsets.all(16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}

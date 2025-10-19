import 'package:flutter/material.dart';
import '../../../core/entities/content_item_entity.dart';
import '../../../../../shared/models/select_option.dart';
import '../../../../../shared/widgets/fields/single_select_input_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/session_bloc.dart';

class SingleSelectContentWidget extends StatefulWidget {
  final ContentItemEntity contentItem;
  final String stepId;

  const SingleSelectContentWidget({super.key, required this.stepId, required this.contentItem});

  @override
  State<SingleSelectContentWidget> createState() => _SingleSelectContentWidgetState();
}

class _SingleSelectContentWidgetState extends State<SingleSelectContentWidget> {
  SelectOption? selected;

  @override
  void initState() {
    super.initState();
    final md = widget.contentItem.metadata ?? const {};
    final selectedValue = md['selected']?.toString();
    final options = _mapOptions(md['options']);
    if (selectedValue != null) {
      try {
        selected = options.firstWhere((o) => o.value == selectedValue);
      } catch (_) {
        selected = null;
      }
    }
    context.read<SessionBloc>().setInput(widget.stepId, widget.contentItem.id, selected?.value);
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.contentItem.metadata ?? const {};
    final label = metadata['label'] as String? ?? '';
    final hint = metadata['hint'] as String? ?? '';
    final options = _mapOptions(metadata['options']);
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
      child: FormField<SelectOption?>(
        validator: required
            ? (val) {
                final s = selected ?? val;
                if (s == null) return 'هذا الحقل مطلوب';
                return null;
              }
            : null,
        builder: (ffState) {
          final hasError = ffState.hasError;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleSelectInputField(
                label: required && label.isNotEmpty ? '$label *' : label,
                hint: hint,
                valueSet: options,
                selectedValue: selected,
                hasError: hasError,
                errorText: ffState.errorText,
                onChange: (opt) {
                  setState(() => selected = opt);
                  ffState.didChange(opt);
                  context.read<SessionBloc>().setInput(widget.stepId, widget.contentItem.id, opt.value);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  List<SelectOption> _mapOptions(dynamic raw) {
    final list = (raw as List?) ?? const [];
    return list.map<SelectOption>((e) {
      if (e is Map) {
        final value = e['value']?.toString() ?? '';
        final label = e['label']?.toString() ?? value;
        return SelectOption(value, label);
      }
      return SelectOption(e?.toString() ?? '', e?.toString() ?? '');
    }).toList();
  }
}

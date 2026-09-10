import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/app_icons.dart';

/// A field row inside a paper card, styled exactly like the read-only rows on
/// the details screen but editable: 96px label column, 13.5/500 value.
class EditableFieldRow extends StatelessWidget {
  const EditableFieldRow({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.labelWidth = 96,
    this.last = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.onChanged,
    this.textCapitalization = TextCapitalization.sentences,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final double labelWidth;
  final bool last;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.ruleInner)),
      ),
      child: Row(
        crossAxisAlignment:
            maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: maxLines == 1 ? 0 : 13),
            child: SizedBox(
              width: labelWidth,
              child: Text(
                label,
                style: AppText.sans(size: 12.5, color: AppColors.muted2),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              minLines: 1,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              textCapitalization: textCapitalization,
              onChanged: onChanged,
              cursorColor: AppColors.accent,
              cursorWidth: 1.5,
              style: AppText.sans(size: 13.5, weight: 500),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                hintText: hint,
                hintStyle: AppText.sans(size: 13.5, color: AppColors.faint),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A row that opens a picker rather than a keyboard — dates, currencies and
/// enumerated values.
class PickerFieldRow extends StatelessWidget {
  const PickerFieldRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.labelWidth = 96,
    this.last = false,
    this.placeholder,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;
  final double labelWidth;
  final bool last;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final empty = value == null || value!.isEmpty;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            border: last
                ? null
                : const Border(bottom: BorderSide(color: AppColors.ruleInner)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: labelWidth,
                child: Text(
                  label,
                  style: AppText.sans(size: 12.5, color: AppColors.muted2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  empty ? (placeholder ?? '—') : value!,
                  style: AppText.sans(
                    size: 13.5,
                    weight: 500,
                    color: empty ? AppColors.faint : AppColors.ink,
                  ),
                ),
              ),
              const AppIcon(
                AppIcons.chevronRight,
                size: 14,
                color: AppColors.chevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The modal-screen top bar: Cancel / title / Save.
class ModalTopBar extends StatelessWidget {
  const ModalTopBar({
    super.key,
    required this.title,
    required this.onCancel,
    required this.onSave,
    this.saveLabel = 'Save',
    this.saveEnabled = true,
  });

  final String title;
  final VoidCallback onCancel;
  final VoidCallback? onSave;
  final String saveLabel;
  final bool saveEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onCancel,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'Cancel',
              style: AppText.sans(
                size: 14.5,
                weight: 600,
                color: AppColors.accent,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.sans(size: 14.5, weight: 600),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: saveEnabled ? onSave : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              saveLabel,
              style: AppText.sans(
                size: 14.5,
                weight: 600,
                color: saveEnabled ? AppColors.accent : AppColors.faintest,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

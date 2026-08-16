import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/algerian_wilayas.dart';
import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/string_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';
import 'app_text_field.dart';

class SearchableWilayaField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  /// Fired whenever the selected wilaya text changes, so the parent can rebuild
  /// dependent fields (e.g. narrow the hospital list to the chosen wilaya).
  final ValueChanged<String>? onChanged;

  const SearchableWilayaField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) =>
          filterWilayas(textEditingValue.text),
      onSelected: (selection) => _syncExternalController(selection),
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            _syncInitialValue(textEditingController);
            return AppTextField(
              hintText: AppStrings.searchWilaya.tr(),
              prefixSvg: SvgAssets.wilaya,
              controller: textEditingController,
              focusNode: focusNode,
              validator: validator,
              onChanged: _syncExternalController,
            );
          },
      optionsViewBuilder: (context, onSelected, options) {
        final width = MediaQuery.of(context).size.width - AppSize.s40;
        return Material(
          elevation: 4,
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppSize.radiusMedium),
          child: Container(
            constraints: const BoxConstraints(maxHeight: AppSize.s250),
            width: width,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
              shrinkWrap: true,
              itemCount: options.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final wilaya = options.elementAt(index);
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    dense: true,
                    title: Text(
                      wilaya,
                      textAlign: TextAlign.right,
                      style: getRegularStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.textPrimary,
                      ),
                    ),
                    onTap: () => onSelected(wilaya),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _syncInitialValue(TextEditingController fieldController) {
    final external = controller;
    if (external == null) return;
    if (external.text != fieldController.text) {
      fieldController.text = external.text;
    }
  }

  void _syncExternalController(String value) {
    controller?.text = value;
    onChanged?.call(value);
  }
}

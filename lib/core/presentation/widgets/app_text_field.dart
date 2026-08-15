import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/values_manager.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final String? prefixSvg;
  final String? obscureSvg;
  final String? visibleSvg;
  final bool isPassword;
  final bool isMultiline;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.prefixSvg,
    this.obscureSvg,
    this.visibleSvg,
    this.isPassword = false,
    this.isMultiline = false,
    this.validator,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      maxLines: widget.isMultiline ? 4 : 1,
      obscureText: widget.isPassword ? _obscure : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: _buildPrefixIcon(),
        prefixIconConstraints: const BoxConstraints(
          minWidth: AppSize.s48,
          minHeight: AppSize.s20,
        ),
        suffixIcon: widget.isPassword ? _buildVisibilityToggle() : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: AppSize.s48,
          minHeight: AppSize.s20,
        ),
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixSvg != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p14),
        child: SvgPicture.asset(
          widget.prefixSvg!,
          width: AppSize.s20,
          height: AppSize.s20,
        ),
      );
    }
    if (widget.prefixIcon != null) {
      return Icon(widget.prefixIcon);
    }
    return null;
  }

  Widget _buildVisibilityToggle() {
    final svg = _obscure ? widget.obscureSvg : widget.visibleSvg;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _obscure = !_obscure),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p14),
        child: svg != null
            ? SvgPicture.asset(svg, width: AppSize.s20, height: AppSize.s20)
            : Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: AppSize.s20,
              ),
      ),
    );
  }
}

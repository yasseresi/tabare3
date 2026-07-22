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
        suffixIcon: widget.isPassword ? _buildVisibilityToggle() : null,
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixSvg != null) {
      return Padding(
        padding: const EdgeInsets.all(AppPadding.p14),
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
    if (svg != null) {
      return IconButton(
        icon: Padding(
          padding: const EdgeInsets.all(AppPadding.p14),
          child: SvgPicture.asset(svg, width: AppSize.s20, height: AppSize.s20),
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    }
    return IconButton(
      icon: Icon(
        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      ),
      onPressed: () => setState(() => _obscure = !_obscure),
    );
  }
}

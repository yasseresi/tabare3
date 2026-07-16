import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final bool _isOutlined;
  final bool _isText;

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
  })  : _isOutlined = false,
        _isText = false;

  const AppButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
  })  : _isOutlined = true,
        _isText = false;

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
  })  : _isOutlined = false,
        _isText = true;

  @override
  Widget build(BuildContext context) {
    final button = _buildButton();

    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    return SizedBox(width: double.infinity, child: button);
  }

  Widget _buildButton() {
    if (_isOutlined) {
      return OutlinedButton(onPressed: onPressed, child: Text(label));
    }
    if (_isText) {
      return TextButton(onPressed: onPressed, child: Text(label));
    }
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}

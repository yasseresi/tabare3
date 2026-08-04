import 'package:flutter/material.dart';

import 'profile_screen.dart';

class RequesterProfileScreen extends StatelessWidget {
  final VoidCallback? onAbout;
  final VoidCallback? onNotifications;
  final VoidCallback? onQrCode;

  const RequesterProfileScreen({
    super.key,
    this.onAbout,
    this.onNotifications,
    this.onQrCode,
  });

  @override
  Widget build(BuildContext context) => ProfileScreen(
    showRecipientIdentityDetails: true,
    onAbout: onAbout,
    onNotifications: onNotifications,
    onQrCode: onQrCode,
  );
}

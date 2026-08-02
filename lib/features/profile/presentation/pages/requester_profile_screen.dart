import 'package:flutter/material.dart';

import 'profile_screen.dart';

class RequesterProfileScreen extends StatelessWidget {
  final VoidCallback? onAbout;
  final VoidCallback? onNotifications;

  const RequesterProfileScreen({super.key, this.onAbout, this.onNotifications});

  @override
  Widget build(BuildContext context) => ProfileScreen(
    showRecipientIdentityDetails: true,
    onAbout: onAbout,
    onNotifications: onNotifications,
  );
}

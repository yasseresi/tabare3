import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabare3/core/utils/string_manager.dart';
import 'edit_request_screen.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
              ),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.welcomeUser.tr(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            AppStrings.getWellSoon.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: AppStrings.searchRequests.tr(),
                      hintStyle: const TextStyle(color: Colors.grey),
                      // suffixIcon appears on the left in RTL
                      suffixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildRequestCard(
                    context,
                    status: AppStrings.activeStatus.tr(),
                    statusColor: Colors.green,
                    isCritical: true,
                    bags: '1/3',
                    bagsText: AppStrings.bagsProvided.tr(namedArgs: {'provided': '1', 'total': '3'}),
                    progress: 0.33,
                    showDonorsButton: true,
                  ),
                  const SizedBox(height: 20),
                  _buildRequestCard(
                    context,
                    status: AppStrings.doneStatus.tr(),
                    statusColor: const Color(0xFFE53935),
                    backgroundColor: const Color(0xFFFFEBEE),
                    isCritical: true,
                    bags: '3/3',
                    bagsText: AppStrings.bagsProvided.tr(namedArgs: {'provided': '3', 'total': '3'}),
                    progress: 1.0,
                    showDonorsButton: false,
                  ),
                  const SizedBox(height: 100), // Padding for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(
    BuildContext context, {
    required String status,
    required Color statusColor,
    Color? backgroundColor,
    required bool isCritical,
    required String bags,
    required String bagsText,
    required double progress,
    required bool showDonorsButton,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/icon8.svg',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'علي بن محمد',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  if (isCritical) _buildBadge(AppStrings.veryUrgent.tr(), Colors.red),
                  const SizedBox(width: 8),
                  _buildBadge(
                    status,
                    statusColor,
                    backgroundColor: backgroundColor,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(AppStrings.bloodType.tr(), 'O+'),
          _buildInfoRow(AppStrings.requestDate.tr(), '01 جانفي 2026'),
          _buildInfoRow(AppStrings.deadline.tr(), '15 جانفي 2026'),
          _buildInfoRow('مستشفى مصطفى باشا', 'الجزائر'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bagsText,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              Text(
                bags,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B1D1D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF8B1D1D),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showDonorsButton) ...[
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B1D1D),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        AppStrings.availableDonors.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditRequestScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      AppStrings.editRequest.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color, {Color? backgroundColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:tabare3/core/utils/string_manager.dart';

class DonorRequestsScreen extends StatefulWidget {
  const DonorRequestsScreen({super.key});

  @override
  State<DonorRequestsScreen> createState() => _DonorRequestsScreenState();
}

class _DonorRequestsScreenState extends State<DonorRequestsScreen> {
  final bool _hasRequests = true; // Toggle this to test empty state

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_rounded, color: Colors.red, size: 80),
                const SizedBox(height: 20),
                Text(
                  AppStrings.confirmAcceptRequestMsg.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  AppStrings.acceptRequestNotice.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSuccessDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B1D1D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      AppStrings.confirm.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      AppStrings.cancel.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.requestAccepted.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  AppStrings.acceptRequestThanks.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B1D1D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      AppStrings.confirm.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                            AppStrings.donationLifeChance.tr(),
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
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              AppStrings.allRequests.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: _hasRequests ? _buildRequestsList() : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildCampaignCard(),
        const SizedBox(height: 20),
        _buildRequestCard(
          name: 'علي بن محمد',
          urgency: AppStrings.veryUrgent.tr(),
          urgencyColor: Colors.red,
          bloodType: 'O+',
          requestDate: '01 جانفي 2026',
          deadline: '15 جانفي 2026',
          hospital: 'مستشفى مصطفى باشا',
          location: 'الجزائر',
          bagsInfo: AppStrings.bagsProvided.tr(namedArgs: {'count': '1', 'total': '3'}),
          progress: 0.33,
        ),
        const SizedBox(height: 20),
        _buildRequestCard(
          name: 'علي بن محمد',
          urgency: AppStrings.urgent.tr(),
          urgencyColor: Colors.orange,
          bloodType: 'O+',
          requestDate: '01 جانفي 2026',
          deadline: '15 جانفي 2026',
          hospital: 'مستشفى مصطفى باشا',
          location: 'الجزائر',
          bagsInfo: AppStrings.bagsProvided.tr(namedArgs: {'count': '1', 'total': '3'}),
          progress: 0.33,
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Image.asset(
            'assets/images/demo.png', // This should be the patient in bed illustration
            height: 200,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.bloodtype,
              size: 150,
              color: Color(0xFF8B1D1D),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.noRequestsYet.tr(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Text(
            AppStrings.noRequestsDescription.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 15),
          Text(
            AppStrings.thanksForDonating.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard() {
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
                  const Icon(
                    Icons.assignment_ind,
                    color: Colors.grey,
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.campaignDonation.tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              _buildBadge(AppStrings.veryUrgent.tr(), Colors.red),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(AppStrings.campaignDate.tr(), '01 جانفي 2026', isCampaign: true),
          _buildInfoRow(
            AppStrings.startTime.tr(),
            '09:00 صباحاً',
            valueColor: const Color(0xFF8B1D1D),
            isCampaign: true,
          ),
          _buildInfoRow(
            AppStrings.endTime.tr(),
            '04:00 مساءاً',
            valueColor: const Color(0xFF8B1D1D),
            isCampaign: true,
          ),
          _buildInfoRow(
            AppStrings.place.tr(),
            'المركز الثقافي - قاعة المؤتمرات، قسنطينة',
            valueColor: const Color(0xFF8B1D1D),
            isCampaign: true,
          ),
          _buildInfoRow(
            AppStrings.organizingEntity.tr(),
            'جمعية تبرع',
            valueColor: const Color(0xFF8B1D1D),
            isCampaign: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required String name,
    required String urgency,
    required Color urgencyColor,
    required String bloodType,
    required String requestDate,
    required String deadline,
    required String hospital,
    required String location,
    required String bagsInfo,
    required double progress,
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
                      child: Image.asset(
                        'assets/images/icon8.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _buildBadge(urgency, urgencyColor),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(AppStrings.bloodType.tr(), bloodType),
          _buildInfoRow(AppStrings.requestDate.tr(), requestDate),
          _buildInfoRow(AppStrings.deadline.tr(), deadline),
          _buildInfoRow(hospital, location),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bagsInfo,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const Text(
                '1/3',
                style: TextStyle(
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
          SizedBox(
            width: 200,
            height: 45,
            child: ElevatedButton(
              onPressed: _showConfirmationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                AppStrings.acceptRequest.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
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

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isCampaign = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

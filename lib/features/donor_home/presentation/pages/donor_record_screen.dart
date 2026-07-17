import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:tabare3/core/utils/string_manager.dart';

class DonorRecordScreen extends StatelessWidget {
  const DonorRecordScreen({super.key});

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
                  // Red Banner Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B1D1D),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.donationRecord.tr(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppStrings.donationRecordDescription.tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.local_hospital_rounded,
                          color: Colors.white,
                          size: 60,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              AppStrings.donationCard.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildRecordCard(
                    hospital: 'مستشفى مصطفى باشا',
                    patient: 'علي بن محمد',
                    date: '15 جانفي 2026',
                    location: 'الجزائر العاصمة',
                  ),
                  const SizedBox(height: 20),
                  _buildRecordCard(
                    hospital: 'مستشفى الحراش',
                    patient: 'فاطمة الزهراء',
                    date: '22 جانفي 2026',
                    location: 'البليدة',
                  ),
                  const SizedBox(height: 20),
                  _buildRecordCard(
                    hospital: 'مستشفى عين النعجة',
                    patient: 'يوسف بن سعيد',
                    date: '30 جانفي 2026',
                    location: 'الجزائر العاصمة',
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard({
    required String hospital,
    required String patient,
    required String date,
    required String location,
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
                  const Icon(Icons.circle, color: Colors.green, size: 10),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.donationSuccessful.tr(),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const Icon(Icons.assignment_rounded, color: Colors.red, size: 30),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              hospital,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          _buildInfoRow(AppStrings.patient.tr(), patient, valueColor: const Color(0xFF8B1D1D)),
          _buildInfoRow(
            AppStrings.donationDate.tr(),
            date,
            valueColor: const Color(0xFF8B1D1D),
          ),
          _buildInfoRow(
            AppStrings.location.tr(),
            location,
            valueColor: const Color(0xFF8B1D1D),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DonorAppointmentsScreen extends StatefulWidget {
  const DonorAppointmentsScreen({super.key});

  @override
  State<DonorAppointmentsScreen> createState() => _DonorAppointmentsScreenState();
}

class _DonorAppointmentsScreenState extends State<DonorAppointmentsScreen> {
  final bool _hasAppointments = true; // Toggle for empty state demo

  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_rounded, color: Colors.red, size: 80),
                const SizedBox(height: 20),
                const Text(
                  'هل أنت متأكد من إلغاء هذا الطلب؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  'إلغاء للطلب سيتم إشعار صاحب الطلب بأنك غير مستعد للتبرع بالدم.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle cancellation logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B1D1D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text('تأكيد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text('إلغاء', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'مرحباً، أحمد',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'كل تبرع بالدم هو فرصة جديدة للحياة',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color(0xFFF5F5F5), shape: BoxShape.circle),
                        child: const Icon(Icons.notifications_none_rounded, color: Colors.black),
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
                            children: const [
                              Text(
                                'مواعيدي',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'إدارة ومتابعة جميع مواعيد التبرع بالدم الخاصة بك بسهولة، والاطلاع على تفاصيل المواعيد القادمة والسابقة.',
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
                        const Icon(Icons.local_hospital_rounded, color: Colors.white, size: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'المواعيد القادمة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: _hasAppointments ? _buildAppointmentsList() : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildAppointmentCard(
          hospital: 'مستشفى مصطفى باشا',
          patientName: 'علي بن محمد',
          deadline: '15 جانفي 2026',
          bagsInfo: 'تم توفير 1 من 3 أكياس',
          progress: 0.33,
        ),
        const SizedBox(height: 20),
        _buildAppointmentCard(
          hospital: 'مستشفى مصطفى باشا',
          patientName: 'علي بن محمد',
          deadline: '15 جانفي 2026',
          bagsInfo: 'تم توفير 1 من 3 أكياس',
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
          const Icon(Icons.assignment_rounded, size: 100, color: Colors.grey),
          const SizedBox(height: 40),
          const Text(
            'لا توجد مواعيد قادمة',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Text(
            'ليس لديك أي موعد تبرع مجدول حالياً. يمكنك استعراض الطلبات المتاحة وحجز موعد جديد للمساهمة في مساعدة المحتاجين.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String hospital,
    required String patientName,
    required String deadline,
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
                  const Icon(Icons.assignment_rounded, color: Colors.grey, size: 40),
                  const SizedBox(width: 12),
                  Text(
                    hospital,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('المريض', patientName, valueColor: Colors.red),
          _buildInfoRow('آخر أجل', deadline, valueColor: Colors.red),
          _buildInfoRow('أكياس الدم', bagsInfo, valueColor: Colors.grey),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B1D1D)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            height: 45,
            child: ElevatedButton(
              onPressed: _showCancelConfirmationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('إلغاء', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor ?? Colors.black),
          ),
        ],
      ),
    );
  }
}

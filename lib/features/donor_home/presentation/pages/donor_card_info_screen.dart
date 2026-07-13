import 'package:flutter/material.dart';

class DonorCardInfoScreen extends StatelessWidget {
  const DonorCardInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'مرحباً، أحمد',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'كل تبرع بالدم هو فرصة جديدة للحياة',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Title Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.card_giftcard, color: Colors.deepPurple, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'بطاقة المتبرع',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Purple Drop Character
                Image.asset(
                  'assets/images/avatar.png',
                  height: 164,
                  width: 150,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.water_drop,
                    size: 150,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                const SizedBox(height: 30),
                // Info Section
                _buildSection(
                  title: 'ماهي بطاقة المتبرع',
                  content:
                      'بطاقة المتبرع هي ملفك الشخصي التفاعلي داخل المنصة، حيث تعرض مستوى عطائك، عدد تبرعاتك، النقاط التي حصلت عليها، والإنجازات التي حققتها خلال رحلتك الإنسانية. اكسب النقاط من خلال التبرع والالتزام والمشاركة، وارتق عبر خمسة مستويات تعكس مدى تأثيرك في المجتمع، فمع كل تبرع جديد تقترب أكثر من تحقيق إنجازات أكبر والوصول إلى لقب "أسطورة التبرع". لأن كل قطرة دم تمنح الأمل وتساهم في إنقاذ الأرواح.',
                ),
                const SizedBox(height: 30),
                // How to earn points
                _buildSectionTitle('كيف تكسب النقاط'),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildPointChip('التبرع بالدم', '+8', Colors.green),
                    _buildPointChip('الالتزام بالموعد', '+2', Colors.green),
                    _buildPointChip('الالغاء', '-5', Colors.red),
                    _buildPointChip('التبرع المستعجل', '+10', Colors.green),
                    _buildPointChip('3 اشهر و الحساب مغلق', '-3', Colors.red),
                  ],
                ),
                const SizedBox(height: 30),
                // Levels
                _buildSectionTitle('المستويات'),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      _buildLevelRow('قطرة امل', '0-10'),
                      const Divider(color: Colors.white10, height: 20),
                      _buildLevelRow('متبرع نشط', '10-50'),
                      const Divider(color: Colors.white10, height: 20),
                      _buildLevelRow('متبرع ملتزم', '50-90'),
                      const Divider(color: Colors.white10, height: 20),
                      _buildLevelRow('متبرع متميز', '90-120'),
                      const Divider(color: Colors.white10, height: 20),
                      _buildLevelRow('تستحق جائزة', '+120'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            content,
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.grey, height: 1.6, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }

  Widget _buildPointChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelRow(String label, String range) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.circle, size: 8, color: Colors.deepPurpleAccent),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        Text(range, style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../features/requester_home/presentation/pages/requester_home_screen.dart';
import '../../../../features/donor_home/presentation/pages/donor_home_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning Icon
                  const Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                    'تأكيد تحديث الحالة !',
                  ),
                  const SizedBox(height: 15),
                  // Description
                  Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                    'عند تقديم طلب للحصول على الدم، سيتم إلغاء حالة "أنا متبرع" تلقائياً ولن تظهر ضمن قائمة المتبرعين النشطين، يمكنك إعادة تفعيلها لاحقاً بعد انتهاء طلبك.',
                  ),
                  const SizedBox(height: 30),
                  // Confirm Button
                  SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const RequesterHomeScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('تأكيد'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Cancel Button
                  SizedBox(
                    width: 220,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'إلغاء',
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(40),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo/App Name
                    Image.asset(
                      'assets/images/icon6.png',
                      height: 80,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.bloodtype_outlined,
                        size: 80,
                        color: Color(0xFF8B1D1D),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Religious Quote Title
                    Text(
                      'قال رسول الله ﷺ:',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '«مَنْ نَفَّسَ عَنْ مُؤْمِنٍ كُرْبَةً مِنْ كُرَبِ الدُّنْيَا، نَفَّسَ اللهُ عَنْهُ كُرْبَةً مِنْ كُرَبِ يَوْمِ الْقِيَامَةِ، وَمَنْ يَسَّرَ عَلَى مُعْسِرٍ، يَسَّرَ اللهُ عَلَيْهِ فِي الدُّنْيَا وَالْآخِرَةِ، وَمَنْ سَتَرَ مُسْلِمًا، سَتَرَه اللهُ فِي الدُّنْيَا وَالْآخِرَةِ، وَاللهُ فِي عَوْنِ الْعَبْدِ مَا كَانَ الْعَبْدُ فِي عَوْنِ أَخِيهِ»',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Question
                    Text(
                      'هل انت',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    // "I need blood" Button
                    SizedBox(
                      width: 220,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () => _showConfirmationDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: theme.primaryColor,
                          elevation: 2,
                          shadowColor: Colors.black26,
                        ),
                        child: const Text('أحتاج دم'),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // "I am a donor" Button
                    SizedBox(
                      width: 220,
                      height: 55,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const DonorHomeScreen()),
                            (route) => false,
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                        ),
                        child: const Text(
                          'أنا متبرع',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

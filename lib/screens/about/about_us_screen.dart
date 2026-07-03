import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/about/member_detail_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const List<Map<String, String>> anggota = [
    {
      "nama": "Mikel Fatih Dewantara",
      "nim": "19240532 | Sistem Informasi",
      "peran": "Project Manager",
      "deskripsi": "As a Project Manager, responsible for planning project workflow, managing task distribution, and ensuring team collaboration runs effectively. Has strong leadership skills, good communication, and the ability to organize project timelines efficiently. Known as a disciplined, responsible, and solution-oriented individual who helps the team stay focused on project goals.",
      "quote": "Great things never come from comfort zones.",
      "gambar": "https://i.ibb.co.com/mCzMjdFG/1777970370223.jpg",
    },
    {
      "nama": "Ahmad Bayu Nugroho",
      "nim": "19240347 | Sistem Informasi",
      "peran": "Frontend Developer",
      "deskripsi": "As a Frontend Developer, responsible for implementing user interface components and ensuring application layouts function properly. Focuses on design consistency, interactive elements, and user-friendly experiences. Known as a detail-oriented, adaptive, and creative individual with strong problem-solving abilities in interface development.",
      "quote": "Design is intelligence made visible.",
      "gambar": "https://i.ibb.co.com/rGzmxwkd/foto-by.jpg",
    },
    {
      "nama": "Kanaya Aghnia Ramadhani",
      "nim": "19240615 | Sistem Informasi",
      "peran": "Quality Assurance",
      "deskripsi": "As a Quality Assurance specialist, responsible for maintaining application quality, testing features, and ensuring consistency across pages and user flows. Plays an important role in identifying issues before deployment. Known as a meticulous, observant, and organized individual who values precision and continuous improvement.",
      "quote": "Details create perfection.",
      "gambar": "https://i.ibb.co.com/qY67TnS8/Kanaya.jpg",
    },
    {
      "nama": "Nabila Vita Febrilian",
      "nim": "19242376 | Sistem Informasi",
      "peran": "UI/UX Designer",
      "deskripsi": "As a UI/UX Designer, responsible for designing visual interfaces and improving user experience throughout the application. Focuses on layout structure, visual hierarchy, and intuitive navigation. Known as a creative, thoughtful, and user-centered individual who prioritizes aesthetics and usability equally.",
      "quote": "Simplicity is the ultimate sophistication.",
      "gambar": "https://i.ibb.co.com/5PRRZ0W/Whats-App-Image-2026-05-06-at-15-47-19.jpg",
    },
    {
      "nama": "Pradipta Danu Wicaksono",
      "nim": "19240698 | Sistem Informasi",
      "peran": "Backend Developer",
      "deskripsi": "As a Backend Developer, responsible for designing application logic, data structure preparation, and supporting future system integration. Ensures the application architecture is scalable and maintainable. Known as an analytical, dependable, and logical thinker who approaches technical challenges systematically.",
      "quote": "Logic will get you from A to B.",
      "gambar": "https://i.ibb.co.com/gZMYQwmG/Whats-App-Image-2026-05-06-at-15-19-28.jpg",
    },
  ];

  // Warna peran
  static Color _roleColor(String peran) {
    switch (peran) {
      case 'Project Manager':    return const Color(0xFF3A86C8);
      case 'Frontend Developer': return const Color(0xFF16A34A);
      case 'Quality Assurance':  return const Color(0xFFC08800);
      case 'UI/UX Designer':     return const Color(0xFF9333EA);
      case 'Backend Developer':  return const Color(0xFFEF4444);
      default:                   return AppColors.grey;
    }
  }

  static Color _roleBg(String peran) => _roleColor(peran).withOpacity(0.1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.lightGrey, height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          // ── App intro card ───────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.black, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Snap',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Book',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'SnapBook is a mobile application designed to simplify photo studio booking. Users can explore studio packages, book sessions, manage schedules, and monitor booking history efficiently in one platform.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.6,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Section title ────────────────────────────────────
          const Text(
            'Meet Our Developers',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tim di balik SnapBook 👋',
            style: TextStyle(fontSize: 13, color: AppColors.grey),
          ),
          const SizedBox(height: 14),

          // ── Member cards ─────────────────────────────────────
          ...anggota.map((item) {
            final roleColor = _roleColor(item['peran']!);
            final roleBg = _roleBg(item['peran']!);
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MemberDetailScreen(data: item),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          item['gambar']!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.background,
                            child: const Icon(Icons.person_rounded,
                                color: AppColors.grey, size: 28),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['nama']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item['nim']!,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.grey),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: roleBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item['peran']!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: roleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(Icons.chevron_right,
                        size: 20, color: AppColors.grey),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
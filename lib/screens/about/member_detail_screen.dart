import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';

class MemberDetailScreen extends StatelessWidget {
  final Map<String, String> data;
  const MemberDetailScreen({super.key, required this.data});

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

  @override
  Widget build(BuildContext context) {
    final roleColor = _roleColor(data['peran']!);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Collapsing hero ────────────────────────────────────
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  surfaceTintColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Foto
                        Image.network(
                          data['gambar']!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.background,
                            child: const Icon(Icons.person_rounded,
                                size: 80, color: AppColors.grey),
                          ),
                        ),
                        // Gradient bawah
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                                Colors.black.withOpacity(0.2),
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Content ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + role badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                data['nama']!,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.black,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: roleColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                data['peran']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: roleColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // NIM
                        Text(
                          data['nim']!,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.grey),
                        ),

                        const SizedBox(height: 20),
                        Container(height: 1, color: AppColors.lightGrey),
                        const SizedBox(height: 20),

                        // About
                        const Text(
                          'Tentang',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['deskripsi']!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.grey,
                            height: 1.7,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Quote card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.format_quote_rounded,
                                  color: AppColors.primary, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                '"${data['quote']!}"',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.grey,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
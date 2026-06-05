import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'EditProfile.dart';
import 'LoginPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notifEnabled = true;
  bool biometricEnabled = true;

  bool get _isDark => themeNotifier.value == ThemeMode.dark;

  void _toggleTheme(bool value) {
    themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                ),
                child: Icon(Icons.logout, color: colors.text, size: 25),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Avatar ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AvatarGlow(
                    glowColor: colors.primary,
                    glowRadiusFactor: 0.3,
                    duration: const Duration(seconds: 2),
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: NetworkImage(box.read('profile')),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                box.read('Name').toString(),
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.bold, color: colors.text),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // ── Stat cards ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: Row(
                  children: [
                    _statCard(context, colors, Icons.crisis_alert_outlined,
                        const Color(0xFF0278FF), 'Complete Task', '2.2k'),
                    _statCard(context, colors, Icons.join_inner_outlined,
                        colors.primary, 'Pending Task', '2.2k'),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),

              // ── Settings card ────────────────────────────────────────
              Container(
                height: MediaQuery.of(context).size.height * 0.40,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Notification toggle
                    _settingRow(
                      context, colors,
                      icon: Icons.notifications_active,
                      label: 'Notification',
                      spaceFactor: 0.12,
                      value: notifEnabled,
                      onChanged: (v) => setState(() => notifEnabled = v),
                    ),
                    _divider(colors),
                    // Theme (dark mode) toggle
                    _settingRow(
                      context, colors,
                      icon: Icons.dark_mode_outlined,
                      label: 'Dark Mode',
                      spaceFactor: 0.16,
                      value: _isDark,
                      onChanged: _toggleTheme,
                    ),
                    _divider(colors),
                    // Biometric toggle
                    _settingRow(
                      context, colors,
                      icon: Icons.fingerprint,
                      label: 'Biometric unlock',
                      spaceFactor: 0.07,
                      value: biometricEnabled,
                      onChanged: (v) => setState(() => biometricEnabled = v),
                    ),
                    _divider(colors),
                    // Edit Profile
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EditProfile()),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: colors.primary),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text('Edit Profile',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: colors.text)),
                            ),
                            const Spacer(),
                            Icon(Icons.chevron_right_rounded,
                                size: 35, color: colors.primary),
                          ],
                        ),
                      ),
                    ),
                    _divider(colors),
                    // Share
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.share_outlined, color: colors.primary),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text('Share',
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: colors.text)),
                          ),
                          const Spacer(),
                          Icon(Icons.chevron_right_rounded,
                              size: 40, color: colors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text('V.1.0',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: colors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider(AppColors colors) => Divider(
        height: 1,
        color: colors.textMuted.withOpacity(0.15),
        indent: 20,
        endIndent: 20,
      );

  Widget _statCard(BuildContext context, AppColors colors, IconData icon,
      Color iconColor, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Icon(icon, color: iconColor),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colors.text)),
                const SizedBox(height: 4),
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingRow(
    BuildContext context,
    AppColors colors, {
    required IconData icon,
    required String label,
    required double spaceFactor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colors.text)),
          const Spacer(),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

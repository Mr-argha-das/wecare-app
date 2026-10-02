import 'package:flutter/material.dart';
import 'package:healthcare/core/theme/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  // final String ward;
  final String nurseType;
  final String status;
  final String profile;
  final String workedTime;
  final VoidCallback? onProfilePressed;

  const ProfileHeader({
    super.key,
    required this.name,
    // required this.ward,
    required this.nurseType,
    required this.status,
    required this.profile,
    required this.workedTime,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    print("profile: $profile");
    final active = status == "ACTIVE";
    final String p = profile;
    final hasProfile = profile.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          /// Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),

            child: CircleAvatar(
              radius: 38,
              backgroundColor: Colors.white,
              backgroundImage: hasProfile ? NetworkImage(profile) : null,
              child: hasProfile
                  ? null
                  : const Icon(Icons.person, size: 38, color: AppTheme.primary),
            ),
          ),

          const SizedBox(width: 16),

          /// Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 0),

                Text(
                  "Nurse Type • $nurseType",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              "Tap this card to open your profile",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onProfilePressed != null)
                      ElevatedButton.icon(
                        onPressed: onProfilePressed,
                        icon: const Icon(Icons.person, size: 16),
                        label: const Text(
                          "Profile",
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Pill(
                      label: status,
                      color: active
                          ? Colors.indigoAccent
                          : Colors.white.withOpacity(1),
                    ),
                    const SizedBox(width: 8),
                    _Pill(
                      label: workedTime,
                      color: Colors.white,
                      darkText: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final bool darkText;

  const _Pill({
    required this.label,
    required this.color,
    this.darkText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: darkText ? Colors.white : color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: darkText ? Colors.black : color,
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/campus_theme.dart';

/// Reusable student avatar widget supporting:
/// - Base64 data URIs (local gallery photos)
/// - Network HTTPS URLs (custom links or presets)
/// - Asset images
/// - Initials fallback (when avatar is null/empty or optional)
/// - Interactive edit badge overlay
class StudentAvatarWidget extends StatelessWidget {
  final String displayName;
  final String? avatarUrl;
  final double radius;
  final bool showEditBadge;
  final VoidCallback? onEdit;
  final Color? borderColor;
  final Color? backgroundColor;

  const StudentAvatarWidget({
    super.key,
    required this.displayName,
    this.avatarUrl,
    this.radius = 24,
    this.showEditBadge = false,
    this.onEdit,
    this.borderColor,
    this.backgroundColor,
  });

  static const List<Map<String, String>> presetAvatars = [
    {
      'name': 'Tech Scholar',
      'url':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Campus Coder',
      'url':
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Data Scientist',
      'url':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Campus Lead',
      'url':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'UI/UX Designer',
      'url':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Software Engineer',
      'url':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Researcher',
      'url':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Student Athlete',
      'url':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Club President',
      'url':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Innovator',
      'url':
          'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=400&q=80',
    },
  ];

  ImageProvider? _resolveImageProvider(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final trimmed = raw.trim();
    try {
      if (trimmed.startsWith('data:image')) {
        final commaIndex = trimmed.indexOf(',');
        if (commaIndex != -1) {
          final b64 = trimmed.substring(commaIndex + 1);
          return MemoryImage(base64Decode(b64));
        }
      } else if (trimmed.startsWith('http://') ||
          trimmed.startsWith('https://')) {
        return NetworkImage(trimmed);
      } else if (trimmed.startsWith('assets/')) {
        return AssetImage(trimmed);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _resolveImageProvider(avatarUrl);
    final initial = displayName.trim().isNotEmpty
        ? displayName.trim()[0].toUpperCase()
        : 'U';

    Widget avatarWidget = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? CampusTheme.deepTeal.withValues(alpha: 0.35),
          width: radius > 30 ? 2.5 : 1.5,
        ),
        color: backgroundColor ?? CampusTheme.deepTeal.withValues(alpha: 0.2),
      ),
      child: ClipOval(
        child: imageProvider != null
            ? Image(
                image: imageProvider,
                fit: BoxFit.cover,
                width: radius * 2,
                height: radius * 2,
                errorBuilder: (ctx, err, stack) => _buildInitials(initial),
              )
            : _buildInitials(initial),
      ),
    );

    if (!showEditBadge) {
      return avatarWidget;
    }

    final badgeSize = (radius * 0.72).clamp(24.0, 36.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onEdit,
          child: avatarWidget,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(badgeSize / 2),
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [CampusTheme.primaryOrange, CampusTheme.coral],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: CampusTheme.darkSurface,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: badgeSize * 0.52,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitials(String initial) {
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.85,
          fontWeight: FontWeight.w700,
          color: CampusTheme.deepTeal,
        ),
      ),
    );
  }

  /// Opens modern modal sheet to choose from gallery, select preset avatar, or enter custom image URL.
  static Future<void> showPickerSheet({
    required BuildContext context,
    required String currentAvatar,
    required ValueChanged<String> onAvatarSelected,
    required VoidCallback onAvatarRemoved,
  }) async {
    final urlCtrl = TextEditingController(
      text: currentAvatar.startsWith('http') ? currentAvatar : '',
    );
    String previewUrl = currentAvatar;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: CampusTheme.primaryOrange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.account_circle_outlined,
                          color: CampusTheme.primaryOrange,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile Picture',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Optional · Choose preset, upload photo, or URL',
                              style: TextStyle(
                                fontSize: 12,
                                color: CampusTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (currentAvatar.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            onAvatarRemoved();
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 16, color: CampusTheme.coral),
                          label: const Text(
                            'Remove',
                            style: TextStyle(
                              fontSize: 12,
                              color: CampusTheme.coral,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Option 1: Gallery Upload Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library_rounded, size: 20),
                      label: const Text(
                        'Choose from Photo Gallery',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CampusTheme.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 512,
                            maxHeight: 512,
                            imageQuality: 82,
                          );
                          if (picked != null) {
                            final bytes = await picked.readAsBytes();
                            final b64 =
                                'data:image/jpeg;base64,${base64Encode(bytes)}';
                            onAvatarSelected(b64);
                            if (ctx.mounted) Navigator.pop(ctx);
                          }
                        } catch (e) {
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text('Could not load image: $e'),
                                backgroundColor: CampusTheme.coral,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Or Pick a Student Avatar Preset',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: presetAvatars.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (ctx, i) {
                        final preset = presetAvatars[i];
                        final url = preset['url']!;
                        final isSelected = previewUrl == url;
                        return GestureDetector(
                          onTap: () {
                            setSheetState(() => previewUrl = url);
                            urlCtrl.text = url;
                            onAvatarSelected(url);
                            Navigator.pop(ctx);
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? CampusTheme.primaryOrange
                                        : Colors.white24,
                                    width: isSelected ? 3 : 1.5,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.person,
                                      color: CampusTheme.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                preset['name']!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? CampusTheme.primaryOrange
                                      : CampusTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 10),

                  // Option 3: Custom Web URL
                  const Text(
                    'Or Enter Custom Image URL',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: urlCtrl,
                          decoration: InputDecoration(
                            hintText: 'https://... (GitHub, Drive, Unsplash)',
                            prefixIcon: const Icon(Icons.link_rounded, size: 20),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (val) {
                            setSheetState(() => previewUrl = val.trim());
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CampusTheme.mint,
                          foregroundColor: CampusTheme.darkSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          final text = urlCtrl.text.trim();
                          if (text.isNotEmpty) {
                            onAvatarSelected(text);
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

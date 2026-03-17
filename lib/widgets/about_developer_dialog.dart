import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDeveloperDialog extends StatelessWidget {
  const AboutDeveloperDialog({super.key});

  static const String _name = 'Setianingbudi';
  static const String _linkedInUsername = 'setianingbudi';
  static const String _linkedInUrl =
      'https://www.linkedin.com/in/$_linkedInUsername';

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AboutDeveloperDialog(),
    );
  }

  Future<void> _openLinkedIn(BuildContext context) async {
    final uri = Uri.parse(_linkedInUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka LinkedIn'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'About Developer',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 52,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: const AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(height: 16),
            Text(
              _name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => _openLinkedIn(context),
              icon: const Icon(Icons.link, size: 18),
              label: Text(
                'linkedin.com/in/$_linkedInUsername',
                style: const TextStyle(fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}

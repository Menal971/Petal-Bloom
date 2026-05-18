import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PetalLoader extends StatelessWidget {
  final String message;
  const PetalLoader({super.key, this.message = 'Loading your notes…'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_florist, size: 48, color: AppTheme.rosePetal),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
              color: AppTheme.rosePetal, strokeWidth: 2.5),
          const SizedBox(height: 16),
          Text(message,
              style: GoogleFonts.dmSans(color: AppTheme.inkMid, fontSize: 14)),
        ],
      ),
    );
  }
}

class PetalError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const PetalError({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: AppTheme.blushMid, shape: BoxShape.circle),
              child: const Icon(Icons.wifi_off_rounded,
                  size: 40, color: AppTheme.rosePetal),
            ),
            const SizedBox(height: 20),
            Text('Oops!',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.inkDark)),
            const SizedBox(height: 8),
            Text(message.replaceFirst('Exception: ', ''),
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.dmSans(fontSize: 13, color: AppTheme.inkMid)),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.rosePetal,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text('Try again',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PetalEmpty extends StatelessWidget {
  const PetalEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.filter_vintage_outlined,
              size: 64, color: AppTheme.blushDeep),
          const SizedBox(height: 16),
          Text('No notes yet',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.inkDark)),
          const SizedBox(height: 8),
          Text('Tap the button to add your first petal note.',
              style: GoogleFonts.dmSans(fontSize: 14, color: AppTheme.inkMid)),
        ],
      ),
    );
  }
}

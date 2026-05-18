import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/note_card.dart';
import 'add_edit_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPosts();
    });
  }

  Future<void> _confirmDelete(BuildContext context, int postId) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.blushDeep,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: AppTheme.blushMid, shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline,
                  color: Color(0xFFD32F2F), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'Delete this note?',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.inkDark),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style:
                  GoogleFonts.dmSans(color: AppTheme.inkMid, fontSize: 13),
            ),
            const SizedBox(height: 28),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.blushDeep),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('Cancel',
                      style: GoogleFonts.dmSans(
                          color: AppTheme.inkMid,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text('Delete',
                      style:
                          GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      final ok = await context.read<PostProvider>().deletePost(postId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(ok ? '🌸 Note deleted' : 'Could not delete note'),
          backgroundColor:
              ok ? AppTheme.rosePetal : const Color(0xFFD32F2F),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.blushLight,
            elevation: 0,
            actions: [
              Consumer<PostProvider>(
                builder: (_, p, __) => IconButton(
                  icon: const Icon(Icons.refresh_rounded,
                      color: AppTheme.rosePetal),
                  tooltip: 'Refresh',
                  onPressed: p.isLoading ? null : p.fetchPosts,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _HeaderBanner(),
            ),
          ),
          Consumer<PostProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const SliverFillRemaining(child: PetalLoader());
              }
              if (provider.hasError) {
                return SliverFillRemaining(
                  child: PetalError(
                    message: provider.errorMessage,
                    onRetry: provider.fetchPosts,
                  ),
                );
              }
              if (provider.posts.isEmpty) {
                return const SliverFillRemaining(child: PetalEmpty());
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final post = provider.posts[i];
                    return NoteCard(
                      post: post,
                      index: i,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(post: post),
                        ),
                      ),
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditScreen(post: post),
                        ),
                      ),
                      onDelete: () => _confirmDelete(context, post.id),
                    );
                  },
                  childCount: provider.posts.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditScreen()),
        ),
        backgroundColor: AppTheme.rosePetal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text('New Note',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD6E7), Color(0xFFFFF0F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                const Icon(Icons.local_florist,
                    color: AppTheme.rosePetal, size: 16),
                const SizedBox(width: 6),
                Text(
                  'PETAL NOTES',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.rosePetal,
                    letterSpacing: 1.6,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                'My Journal',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.inkDark,
                ),
              ),
              const SizedBox(height: 4),
              Consumer<PostProvider>(
                builder: (_, p, __) => Text(
                  p.posts.isEmpty
                      ? 'No notes yet'
                      : '${p.posts.length} notes saved',
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: AppTheme.inkMid),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

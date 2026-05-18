// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../theme/app_theme.dart';

class AddEditScreen extends StatefulWidget {
  final Post? post;
  const AddEditScreen({super.key, this.post});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  late final TextEditingController _userIdCtrl;

  bool get _isEditing => widget.post != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.post?.title ?? '');
    _bodyCtrl = TextEditingController(text: widget.post?.body ?? '');
    _userIdCtrl =
        TextEditingController(text: widget.post?.userId.toString() ?? '1');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _userIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<PostProvider>();
    bool success;

    if (_isEditing) {
      success = await provider.updatePost(
        widget.post!.copyWith(
          title: _titleCtrl.text.trim(),
          body: _bodyCtrl.text.trim(),
          userId: int.tryParse(_userIdCtrl.text.trim()) ?? 1,
        ),
      );
    } else {
      success = await provider.createPost(
        userId: int.tryParse(_userIdCtrl.text.trim()) ?? 1,
        title: _titleCtrl.text.trim(),
        body: _bodyCtrl.text.trim(),
      );
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? (_isEditing ? '🌸 Note updated!' : '🌸 Note created!')
            : 'Something went wrong. Try again.'),
        backgroundColor: success ? AppTheme.rosePetal : const Color(0xFFD32F2F),
      ));
      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blushLight,
      appBar: AppBar(
        backgroundColor: AppTheme.blushLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.rosePetal, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Edit Note' : 'New Note',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.inkDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Decorative top card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.blushMid, AppTheme.blushLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_florist,
                        color: AppTheme.rosePetal, size: 28),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing ? 'Update your note' : 'Write a new note',
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.inkDark),
                        ),
                        Text(
                          'Fill in the details below',
                          style: GoogleFonts.dmSans(
                              fontSize: 12, color: AppTheme.inkMid),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const _FieldLabel(label: 'Title'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleCtrl,
                textCapitalization: TextCapitalization.sentences,
                style:
                    GoogleFonts.dmSans(color: AppTheme.inkDark, fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Give your note a title…',
                  prefixIcon: Icon(Icons.title, color: AppTheme.rosePetal),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 20),

              const _FieldLabel(label: 'Content'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bodyCtrl,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.dmSans(
                    color: AppTheme.inkDark, fontSize: 15, height: 1.6),
                decoration: const InputDecoration(
                  hintText: 'Write your thoughts here…',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.notes, color: AppTheme.rosePetal),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Content is required'
                    : null,
              ),
              const SizedBox(height: 20),

              const _FieldLabel(label: 'User ID'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _userIdCtrl,
                keyboardType: TextInputType.number,
                style:
                    GoogleFonts.dmSans(color: AppTheme.inkDark, fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'e.g. 1',
                  prefixIcon:
                      Icon(Icons.person_outline, color: AppTheme.rosePetal),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'User ID is required';
                  }
                  if (int.tryParse(v.trim()) == null) return 'Must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 36),

              Consumer<PostProvider>(
                builder: (_, provider, __) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.rosePetal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: provider.isSubmitting ? null : _submit,
                    child: provider.isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            _isEditing ? 'Save Changes' : 'Create Note',
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppTheme.inkDark,
        letterSpacing: 0.3,
      ),
    );
  }
}

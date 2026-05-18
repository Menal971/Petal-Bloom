import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../services/api_service.dart';

enum PostStatus { initial, loading, success, error }

class PostProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Post> _posts = [];
  PostStatus _status = PostStatus.initial;
  String _errorMessage = '';
  bool _isSubmitting = false;

  List<Post> get posts => List.unmodifiable(_posts);
  PostStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isSubmitting => _isSubmitting;
  bool get isLoading => _status == PostStatus.loading;
  bool get hasError => _status == PostStatus.error;

  Future<void> fetchPosts() async {
    _status = PostStatus.loading;
    notifyListeners();
    try {
      _posts = await _api.fetchPosts();
      _status = PostStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = PostStatus.error;
    }
    notifyListeners();
  }

  Future<bool> createPost(
      {required int userId,
      required String title,
      required String body}) async {
    _isSubmitting = true;
    notifyListeners();
    try {
      final created = await _api.createPost(
          userId: userId, title: title, body: body);
      // Assign a unique negative id so it doesn't clash with existing ids
      final localId =
          _posts.isEmpty ? -1 : (_posts.map((p) => p.id).reduce((a, b) => a < b ? a : b) - 1);
      _posts.insert(0, created.copyWith(id: localId));
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePost(Post post) async {
    _isSubmitting = true;
    notifyListeners();
    try {
      final updated = await _api.updatePost(post);
      final idx = _posts.indexWhere((p) => p.id == post.id);
      if (idx != -1) _posts[idx] = updated.copyWith(id: post.id);
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePost(int id) async {
    try {
      await _api.deletePost(id);
      _posts.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = '';
    _status = PostStatus.initial;
    notifyListeners();
  }
}

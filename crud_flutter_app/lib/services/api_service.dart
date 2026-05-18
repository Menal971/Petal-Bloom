import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/posts?_limit=20'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    }
    throw Exception('Failed to load notes (${response.statusCode})');
  }

  Future<Post> createPost(
      {required int userId,
      required String title,
      required String body}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'title': title, 'body': body}),
    );
    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create note (${response.statusCode})');
  }

  Future<Post> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/posts/${post.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to update note (${response.statusCode})');
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/posts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete note (${response.statusCode})');
    }
  }
}

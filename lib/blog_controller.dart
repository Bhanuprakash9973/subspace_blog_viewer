// import 'dart:convert';

// import 'package:blog_explorer/databasehelper.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:sqflite/sqflite.dart';

// class Blog {
//   final String title;
//   final String imageUrl;
//   bool isFavorite;

//   Blog({
//     required this.title,
//     required this.imageUrl,
//     required this.isFavorite,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'imageUrl': imageUrl,
//       'isFavorite': isFavorite ? 1 : 0,
//     };
//   }

//   factory Blog.fromMap(Map<String, dynamic> map) {
//     return Blog(
//       title: map['title'],
//       imageUrl: map['imageUrl'],
//       isFavorite: map['isFavorite'] == 1,
//     );
//   }
// }

// class BlogController extends GetxController {
//   var blogs = <Blog>[].obs;

//   void fetchBlogs() async {
//     const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
//     const String adminSecret =
//         '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

//     try {
//       final response = await http.get(Uri.parse(url), headers: {
//         'x-hasura-admin-secret': adminSecret,
//       });

//       if (response.statusCode == 200) {
//         final List<dynamic> blogData = json.decode(response.body)["blogs"];
//         blogs.value = blogData
//             .map((blog) => Blog(
//                   title: blog['title'],
//                   imageUrl: blog['image_url'],
//                   isFavorite: false,
//                 ))
//             .toList();
//       } else {
//         print('Request failed with status code: ${response.statusCode}');
//         print('Response data: ${response.body}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Future<void> _insertBlog(Blog blog) async {
//     final Database db = await DatabaseHelper.database;
//     await db.insert(
//       'blogs',
//       blog.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   void toggleFavorite(int index) {
//     blogs[index].isFavorite = !blogs[index].isFavorite;
//     _insertBlog(blogs[index]);
//     update();
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

import 'package:blog_explorer/blog_card.dart';
import 'package:blog_explorer/databasehelper.dart';
import 'package:blog_explorer/detailed_blog_view.dart';

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

// class BlogListScreen extends StatefulWidget {
//   const BlogListScreen({Key? key}) : super(key: key);

//   @override
//   _BlogListScreenState createState() => _BlogListScreenState();
// }

// class _BlogListScreenState extends State<BlogListScreen> {
//   List<Blog> blogs = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchBlogs();
//   }

//   Future<void> _fetchBlogsfromsql() async {
//     final Database db = await DatabaseHelper.database;
//     final List<Map<String, dynamic>> maps = await db.query('blogs');

//     setState(() {
//       blogs = List.generate(maps.length, (i) {
//         return Blog.fromMap(maps[i]);
//       });
//     });

//     if (blogs.isEmpty) {
//       fetchBlogs();
//     }
//   }

//   void fetchBlogs() async {
//     const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
//     const String adminSecret =
//         '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

//     try {
//       final response = await http.get(Uri.parse(url), headers: {
//         'x-hasura-admin-secret': adminSecret,
//       });

//       if (response.statusCode == 200) {
//         // print(response.body);
//         final List<dynamic> blogData = json.decode(response.body)["blogs"];
//         // print(blogData);
//         setState(() {
//           blogs = blogData
//               .map((blog) => Blog(
//                     title: blog['title'],
//                     imageUrl: blog['image_url'],
//                     isFavorite: false,
//                   ))
//               .toList();
//         });
//       } else {
//         // Request failed
//         print('Request failed with status code: ${response.statusCode}');
//         print('Response data: ${response.body}');
//       }
//     } catch (e) {
//       // Handle any errors that occurred during the request
//       _fetchBlogsfromsql();
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

//   // Inside _BlogListScreenState
//   void toggleFavorite(int index) {
//     setState(() {
//       blogs[index].isFavorite = !blogs[index].isFavorite;
//       _insertBlog(blogs[index]);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SvgPicture.asset(
//               'assets/subspace_hor.svg',
//               height: 30,
//             ),
//             const Text('Blog Explorer')
//           ],
//         ),
//         backgroundColor: Colors.black,
//       ),
//       body: blogs.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: blogs.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final blog = blogs[index];
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DetailedBlogView(
//                           title: blog.title,
//                           imageUrl: blog.imageUrl,
//                           index: index,
//                         ),
//                       ),
//                     );
//                   },
//                   child: BlogCard(
//                     title: blog.title,
//                     imageUrl: blog.imageUrl,
//                     index: index,
//                     isFavorite: blog.isFavorite,
//                     toggleFavorite: () => toggleFavorite(index),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

class Blog {
  final String id;
  final String title;
  final String imageUrl;
  final RxBool isFavorite;

  Blog({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.isFavorite,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite.value ? 1 : 0,
    };
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      isFavorite: RxBool(map['isFavorite'] == 1),
    );
  }
}

class BlogListController extends GetxController {
  var blogs = <Blog>[].obs;
  var isFavorite = false.obs;

  void fetchBlogs() async {
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        clearDatabase();
        final List<dynamic> blogData = json.decode(response.body)["blogs"];
        blogs.assignAll(blogData
            .map((blog) => Blog(
                  id: blog['id'],
                  title: blog['title'],
                  imageUrl: blog['image_url'],
                  isFavorite: RxBool(false),
                ))
            .toList());
        for (var blog in blogs) {
          await _insertBlog(blog);
        }
      } else {
        _showErrorDialog("${response.statusCode} | ${response.body}");
      }
    } on SocketException {
      _showOfflineDialog();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<void> clearDatabase() async {
    final Database db = await DatabaseHelper.database;
    await db.rawDelete('DELETE FROM blogs');
  }

  void _showOfflineDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Offline'),
        content: const Text(
            'You are offline. Do you want to fetch locally saved blogs?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () async {
              AppSettings.openAppSettings(type: AppSettingsType.wifi);
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              fetchLocallySavedBlogs();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void toggleFavorite(int index) {
    blogs[index].isFavorite.value = !blogs[index].isFavorite.value;
    _insertBlog(blogs[index]);
    update();
  }

  Future<void> _insertBlog(Blog blog) async {
    final Database db = await DatabaseHelper.database;
    await db.rawInsert(
        '''INSERT OR REPLACE INTO blogs (id, title, imageUrl, isFavorite)
    VALUES (?, ?, ?, ?)''',
        [
          blog.id,
          blog.title,
          blog.imageUrl,
          blog.isFavorite.value ? 1 : 0,
        ]);
  }

  Future<void> fetchLocallySavedBlogs() async {
    try {
      final Database db = await DatabaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('blogs');
      print(maps);

      blogs.assignAll(List.generate(maps.length, (i) {
        return Blog.fromMap(maps[i]);
      }));
    } catch (e) {
      print('Error fetching locally saved blogs: $e');
    }
  }
}

void _showErrorDialog(String message) {
  Get.dialog(
    AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ),
  );
}

class BlogListScreen extends StatelessWidget {
  final BlogListController controller = Get.put(BlogListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/subspace_hor.svg',
              height: 30,
            ),
            const Text('Blog Explorer')
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: GetX(
          init: controller,
          builder: (_) {
            if (controller.blogs.isEmpty) {
              controller.fetchBlogs();
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: controller.blogs.length,
                itemBuilder: (BuildContext context, int index) {
                  final blog = controller.blogs[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedBlogView(
                            title: blog.title,
                            imageUrl: blog.imageUrl,
                            index: index,
                          ),
                        ),
                      );
                    },
                    child: BlogCard(
                      title: blog.title,
                      imageUrl: blog.imageUrl,
                      index: index,
                      isFavorite: blog.isFavorite,
                      toggleFavorite: () => controller.toggleFavorite(index),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}

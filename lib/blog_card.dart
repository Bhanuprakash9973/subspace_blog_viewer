import 'package:blog_explorer/detailed_blog_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int index;
  final RxBool isFavorite;
  final VoidCallback toggleFavorite;

  BlogCard({
    required this.title,
    required this.imageUrl,
    required this.index,
    required this.isFavorite,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedBlogView(
                title: title,
                imageUrl: imageUrl,
                index: index,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Image not available when you are offline!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: ((context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      }),
                    )
                  : const Center(
                      child: Text(
                          'Images are not available when you are offline!'),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 8,
                    child: Hero(
                      tag: 'text_$index',
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      icon: Icon(
                        isFavorite.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite.value ? Colors.red : Colors.black,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailedBlogView extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int index;

  DetailedBlogView({
    required this.title,
    required this.imageUrl,
    required this.index,
  });

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
            Text('#${index + 1}')
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'image_$index',
              child: Image.network(
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    heightFactor: 10,
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
                height: 200,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: 'text_$index',
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

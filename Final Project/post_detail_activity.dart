import 'dart:io';
import 'package:flutter/material.dart';
import 'post_model.dart';

class PostDetailActivity extends StatelessWidget {
  final Post post;

  const PostDetailActivity({super.key, required this.post});

  void _showFullScreenImage(BuildContext context, String imagePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: imagePath.startsWith('http')
                ? Image.network(imagePath)
                : Image.file(File(imagePath)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${post.price}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              post.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            if (post.imagePaths.isNotEmpty) ...[
              Text(
                'Images:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.imagePaths.length,
                  itemBuilder: (context, index) {
                    final path = post.imagePaths[index];
                    return GestureDetector(
                      onTap: () => _showFullScreenImage(context, path),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: path.startsWith('http')
                            ? Image.network(
                                path,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(path),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}



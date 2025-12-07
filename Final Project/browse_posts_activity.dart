import 'package:flutter/material.dart';
import 'post_activity.dart';
import 'post_detail_activity.dart';
import 'firestore_helper.dart';
import 'post_model.dart';

class BrowsePostsActivity extends StatefulWidget {
  const BrowsePostsActivity({super.key});

  @override
  State<BrowsePostsActivity> createState() => _BrowsePostsActivityState();
}

class _BrowsePostsActivityState extends State<BrowsePostsActivity> {
  Stream<List<Post>>? _postsStream;

  @override
  void initState() {
    super.initState();
    _postsStream = FirestoreHelper().getPosts();
  }

  void _navigateToNewPost() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NewPostActivity()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HyperGarageSale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToNewPost,
            tooltip: 'New Post',
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: _postsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts yet'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text('\$${post.price} - ${post.description}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostDetailActivity(post: post),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewPost,
        child: const Icon(Icons.add),
      ),
    );
  }
}


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'post_model.dart';

class FirestoreHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addPost(Post post, List<String> localImagePaths) async {
    List<String> downloadUrls = [];

    for (String path in localImagePaths) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('post_images').child(fileName);
      UploadTask uploadTask = ref.putFile(File(path));
      TaskSnapshot snapshot = await uploadTask;
      String url = await snapshot.ref.getDownloadURL();
      downloadUrls.add(url);
    }

    // Create a new map with the download URLs instead of local paths
    Map<String, dynamic> data = post.toMap();
    data['imagePaths'] = downloadUrls.join('|'); // Keeping the same format for simplicity
    // Or better, store as array in Firestore
    data['images'] = downloadUrls; // Store as array for Firestore
    data.remove('imagePaths'); // Remove the string version if we use array, but let's keep it consistent with the model for now or update model.
    // Let's stick to the model's toMap which uses 'imagePaths' string.
    // But Firestore supports arrays. Let's use the string for compatibility with the existing model logic for now.
    data['imagePaths'] = downloadUrls.join('|');

    await _db.collection('posts').add(data);
  }

  Stream<List<Post>> getPosts() {
    return _db.collection('posts').orderBy('id', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        // Ensure ID is handled if we want to use Firestore ID or keep the int ID.
        // The current model uses int ID. Firestore uses String ID.
        // We might need to adjust the model to support String ID or just ignore it for display.
        // For now, let's just map what we can.
        return Post.fromMap(data);
      }).toList();
    });
  }
}


class Post {
  final int? id;
  final String title;
  final double price;
  final String description;
  final List<String> imagePaths;

  Post({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imagePaths,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'imagePaths': imagePaths.join('|'),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      description: map['description'],
      imagePaths: map['imagePaths'] != null && map['imagePaths'].toString().isNotEmpty
          ? map['imagePaths'].toString().split('|')
          : [],
    );
  }
}


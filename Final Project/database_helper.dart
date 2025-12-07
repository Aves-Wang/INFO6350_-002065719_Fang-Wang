import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'post_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('posts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE posts ( 
  id $idType, 
  title $textType,
  price $doubleType,
  description $textType,
  imagePaths TEXT
  )
''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE posts ADD COLUMN imagePaths TEXT');
    }
  }

  Future<int> create(Post post) async {
    final db = await instance.database;
    return await db.insert('posts', post.toMap());
  }

  Future<List<Post>> readAllPosts() async {
    final db = await instance.database;
    final result = await db.query('posts', orderBy: 'id DESC');
    return result.map((json) => Post.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}


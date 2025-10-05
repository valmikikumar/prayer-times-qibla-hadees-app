import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/hadees.dart';

/// Database service for managing SQLite database
/// 
/// Handles database initialization, CRUD operations for Hadees
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  /// Get database instance
  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'prayer_times_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    // Create Hadees table
    await db.execute('''
      CREATE TABLE hadees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        arabic_text TEXT NOT NULL,
        english_text TEXT NOT NULL,
        source TEXT NOT NULL,
        book TEXT NOT NULL,
        chapter TEXT,
        hadith_number TEXT,
        narrator TEXT,
        category TEXT,
        keywords TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Create Duas table
    await db.execute('''
      CREATE TABLE duas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        arabic_text TEXT NOT NULL,
        english_text TEXT NOT NULL,
        transliteration TEXT,
        category TEXT NOT NULL,
        reference TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Create Tasbeeh table
    await db.execute('''
      CREATE TABLE tasbeeh (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        count INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Insert sample Hadees
    await _insertSampleHadees(db);
    
    // Insert sample Duas
    await _insertSampleDuas(db);
  }

  /// Insert sample Hadees data
  Future<void> _insertSampleHadees(Database db) async {
    final sampleHadees = [
      {
        'arabic_text': 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
        'english_text': 'Actions are according to intentions',
        'source': 'Bukhari',
        'book': 'Sahih al-Bukhari',
        'chapter': 'Beginning of Revelation',
        'hadith_number': '1',
        'narrator': 'Umar ibn al-Khattab',
        'category': 'Faith',
        'keywords': 'intention, actions, faith',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'arabic_text': 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
        'english_text': 'Whoever believes in Allah and the Last Day should speak good or remain silent',
        'source': 'Bukhari',
        'book': 'Sahih al-Bukhari',
        'chapter': 'Good Manners',
        'hadith_number': '6018',
        'narrator': 'Abu Huraira',
        'category': 'Manners',
        'keywords': 'speech, silence, manners',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'arabic_text': 'الْحَيَاءُ شُعْبَةٌ مِنَ الإِيمَانِ',
        'english_text': 'Modesty is a branch of faith',
        'source': 'Bukhari',
        'book': 'Sahih al-Bukhari',
        'chapter': 'Faith',
        'hadith_number': '9',
        'narrator': 'Abu Huraira',
        'category': 'Faith',
        'keywords': 'modesty, faith, character',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'arabic_text': 'مَنْ لَا يَرْحَمُ النَّاسَ لَا يَرْحَمُهُ اللَّهُ',
        'english_text': 'Whoever does not show mercy to people, Allah will not show mercy to him',
        'source': 'Bukhari',
        'book': 'Sahih al-Bukhari',
        'chapter': 'Mercy',
        'hadith_number': '7376',
        'narrator': 'Jarir ibn Abdullah',
        'category': 'Mercy',
        'keywords': 'mercy, compassion, Allah',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'arabic_text': 'الْعِلْمُ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ',
        'english_text': 'Seeking knowledge is obligatory upon every Muslim',
        'source': 'Ibn Majah',
        'book': 'Sunan Ibn Majah',
        'chapter': 'Knowledge',
        'hadith_number': '224',
        'narrator': 'Anas ibn Malik',
        'category': 'Knowledge',
        'keywords': 'knowledge, learning, obligation',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    for (final hadees in sampleHadees) {
      await db.insert('hadees', hadees);
    }
  }

  /// Insert sample Duas data
  Future<void> _insertSampleDuas(Database db) async {
    final sampleDuas = [
      {
        'arabic_text': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        'english_text': 'Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire',
        'transliteration': 'Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina adhaban-nar',
        'category': 'General',
        'reference': 'Quran 2:201',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'arabic_text': 'اللَّهُمَّ بَارِكْ لِي فِي صَبَاحِي',
        'english_text': 'O Allah, bless me in my morning',
        'transliteration': 'Allahumma barik li fi sabahi',
        'category': 'Morning',
        'reference': 'Hadith',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'arabic_text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        'english_text': 'Glory be to Allah and praise be to Him',
        'transliteration': 'Subhanallahi wa bihamdihi',
        'category': 'Dhikr',
        'reference': 'Hadith',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    for (final dua in sampleDuas) {
      await db.insert('duas', dua);
    }
  }

  /// Initialize database (public method)
  Future<void> initializeDatabase() async {
    await database;
  }

  /// Close database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

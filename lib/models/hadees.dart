/// Model class for Hadees data
/// 
/// Represents a single Hadees with Arabic text, English translation, and metadata
class Hadees {
  final int? id;
  final String arabicText;
  final String englishText;
  final String source;
  final String book;
  final String? chapter;
  final String? hadithNumber;
  final String? narrator;
  final String? category;
  final String? keywords;
  final DateTime createdAt;

  const Hadees({
    this.id,
    required this.arabicText,
    required this.englishText,
    required this.source,
    required this.book,
    this.chapter,
    this.hadithNumber,
    this.narrator,
    this.category,
    this.keywords,
    required this.createdAt,
  });

  /// Create Hadees from database map
  factory Hadees.fromMap(Map<String, dynamic> map) {
    return Hadees(
      id: map['id']?.toInt(),
      arabicText: map['arabic_text'] ?? '',
      englishText: map['english_text'] ?? '',
      source: map['source'] ?? '',
      book: map['book'] ?? '',
      chapter: map['chapter'],
      hadithNumber: map['hadith_number'],
      narrator: map['narrator'],
      category: map['category'],
      keywords: map['keywords'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'arabic_text': arabicText,
      'english_text': englishText,
      'source': source,
      'book': book,
      'chapter': chapter,
      'hadith_number': hadithNumber,
      'narrator': narrator,
      'category': category,
      'keywords': keywords,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get formatted reference
  String get reference {
    final parts = <String>[];
    if (book.isNotEmpty) parts.add(book);
    if (hadithNumber != null && hadithNumber!.isNotEmpty) {
      parts.add('Hadith $hadithNumber');
    }
    return parts.join(', ');
  }

  /// Get short description
  String get shortDescription {
    if (englishText.length > 100) {
      return '${englishText.substring(0, 100)}...';
    }
    return englishText;
  }

  @override
  String toString() {
    return 'Hadees(id: $id, source: $source, book: $book)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hadees && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Model class for Duas data
class Dua {
  final int? id;
  final String arabicText;
  final String englishText;
  final String? transliteration;
  final String category;
  final String? reference;
  final DateTime createdAt;

  const Dua({
    this.id,
    required this.arabicText,
    required this.englishText,
    this.transliteration,
    required this.category,
    this.reference,
    required this.createdAt,
  });

  /// Create Dua from database map
  factory Dua.fromMap(Map<String, dynamic> map) {
    return Dua(
      id: map['id']?.toInt(),
      arabicText: map['arabic_text'] ?? '',
      englishText: map['english_text'] ?? '',
      transliteration: map['transliteration'],
      category: map['category'] ?? '',
      reference: map['reference'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'arabic_text': arabicText,
      'english_text': englishText,
      'transliteration': transliteration,
      'category': category,
      'reference': reference,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Dua(id: $id, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Dua && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Model class for Tasbeeh data
class Tasbeeh {
  final int? id;
  final String name;
  final int count;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Tasbeeh({
    this.id,
    required this.name,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create Tasbeeh from database map
  factory Tasbeeh.fromMap(Map<String, dynamic> map) {
    return Tasbeeh(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      count: map['count']?.toInt() ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Tasbeeh(id: $id, name: $name, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tasbeeh && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/hadees.dart';
import '../services/database_service.dart';

/// Provider for Hadees management
/// 
/// Handles CRUD operations for Hadees, Duas, and Tasbeeh
class HadeesProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  
  // State variables
  List<Hadees> _hadees = [];
  List<Dua> _duas = [];
  List<Tasbeeh> _tasbeehList = [];
  Hadees? _todaysHadees;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Hadees> get hadees => _hadees;
  List<Dua> get duas => _duas;
  List<Tasbeeh> get tasbeehList => _tasbeehList;
  Hadees? get todaysHadees => _todaysHadees;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize Hadees provider
  Future<void> initialize() async {
    await _loadAllHadees();
    await _loadAllDuas();
    await _loadAllTasbeeh();
    await _setTodaysHadees();
  }

  /// Load all Hadees from database
  Future<void> _loadAllHadees() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query('hadees');

      _hadees = List.generate(maps.length, (i) {
        return Hadees.fromMap(maps[i]);
      });
      
    } catch (e) {
      _error = 'Failed to load Hadees: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all Duas from database
  Future<void> _loadAllDuas() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query('duas');

      _duas = List.generate(maps.length, (i) {
        return Dua.fromMap(maps[i]);
      });
      
    } catch (e) {
      _error = 'Failed to load Duas: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Load all Tasbeeh from database
  Future<void> _loadAllTasbeeh() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query('tasbeeh');

      _tasbeehList = List.generate(maps.length, (i) {
        return Tasbeeh.fromMap(maps[i]);
      });
      
    } catch (e) {
      _error = 'Failed to load Tasbeeh: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Set today's Hadees (random selection)
  Future<void> _setTodaysHadees() async {
    if (_hadees.isNotEmpty) {
      // Use date-based seed for consistent daily selection
      final today = DateTime.now();
      final seed = today.year * 10000 + today.month * 100 + today.day;
      final random = seed % _hadees.length;
      _todaysHadees = _hadees[random];
      notifyListeners();
    }
  }

  /// Search Hadees by keyword
  Future<List<Hadees>> searchHadees(String keyword) async {
    if (keyword.isEmpty) return _hadees;
    
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'hadees',
        where: 'arabic_text LIKE ? OR english_text LIKE ? OR keywords LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%'],
      );

      return List.generate(maps.length, (i) {
        return Hadees.fromMap(maps[i]);
      });
      
    } catch (e) {
      _error = 'Failed to search Hadees: ${e.toString()}';
      return [];
    }
  }

  /// Filter Hadees by source
  Future<List<Hadees>> filterHadeesBySource(String source) async {
    if (source.isEmpty) return _hadees;
    
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'hadees',
        where: 'source = ?',
        whereArgs: [source],
      );

      return List.generate(maps.length, (i) {
        return Hadees.fromMap(maps[i]);
      });
      
    } catch (e) {
      _error = 'Failed to filter Hadees: ${e.toString()}';
      return [];
    }
  }

  /// Filter Hadees by category
  Future<List<Hadees>> filterHadeesByCategory(String category) async {
    if (category.isEmpty) return _hadees;
    
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'hadees',
        where: 'category = ?',
        whereArgs: [category],
      );

      return List.generate(maps.length, (i) {
        return Hadees.fromMap(maps[i]);
      });
      
    } catch (e) {
      _error = 'Failed to filter Hadees: ${e.toString()}';
      return [];
    }
  }

  /// Get Duas by category
  List<Dua> getDuasByCategory(String category) {
    if (category.isEmpty) return _duas;
    return _duas.where((dua) => dua.category == category).toList();
  }

  /// Get all categories
  List<String> getCategories() {
    final categories = <String>{};
    for (final hadees in _hadees) {
      if (hadees.category != null && hadees.category!.isNotEmpty) {
        categories.add(hadees.category!);
      }
    }
    return categories.toList()..sort();
  }

  /// Get all sources
  List<String> getSources() {
    final sources = <String>{};
    for (final hadees in _hadees) {
      sources.add(hadees.source);
    }
    return sources.toList()..sort();
  }

  /// Get Dua categories
  List<String> getDuaCategories() {
    final categories = <String>{};
    for (final dua in _duas) {
      categories.add(dua.category);
    }
    return categories.toList()..sort();
  }

  /// Add new Tasbeeh
  Future<void> addTasbeeh(String name) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now();
      
      final tasbeeh = Tasbeeh(
        name: name,
        count: 0,
        createdAt: now,
        updatedAt: now,
      );
      
      await db.insert('tasbeeh', tasbeeh.toMap());
      await _loadAllTasbeeh();
      
    } catch (e) {
      _error = 'Failed to add Tasbeeh: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Update Tasbeeh count
  Future<void> updateTasbeehCount(int id, int count) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        'tasbeeh',
        {
          'count': count,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      
      await _loadAllTasbeeh();
      
    } catch (e) {
      _error = 'Failed to update Tasbeeh: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Delete Tasbeeh
  Future<void> deleteTasbeeh(int id) async {
    try {
      final db = await _databaseService.database;
      await db.delete(
        'tasbeeh',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      await _loadAllTasbeeh();
      
    } catch (e) {
      _error = 'Failed to delete Tasbeeh: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await initialize();
  }
}

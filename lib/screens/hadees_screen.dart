import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/hadees_provider.dart';
import '../widgets/hadees_list.dart';
import '../widgets/hadees_search.dart';
import '../widgets/hadees_filter.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

/// Hadees screen for browsing and searching Hadees
/// 
/// Provides search, filter, and list functionality for Hadees collection
class HadeesScreen extends StatefulWidget {
  const HadeesScreen({super.key});

  @override
  State<HadeesScreen> createState() => _HadeesScreenState();
}

class _HadeesScreenState extends State<HadeesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSource = '';
  String _selectedCategory = '';
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadHadees();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Load Hadees data
  Future<void> _loadHadees() async {
    final hadeesProvider = Provider.of<HadeesProvider>(context, listen: false);
    await hadeesProvider.initialize();
  }

  /// Perform search
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final hadeesProvider = Provider.of<HadeesProvider>(context, listen: false);
    final results = await hadeesProvider.searchHadees(query);
    
    setState(() {
      _searchResults = results.map((h) => h.id.toString()).toList();
    });
  }

  /// Apply filters
  Future<void> _applyFilters() async {
    final hadeesProvider = Provider.of<HadeesProvider>(context, listen: false);
    
    if (_selectedSource.isNotEmpty) {
      final results = await hadeesProvider.filterHadeesBySource(_selectedSource);
      setState(() {
        _searchResults = results.map((h) => h.id.toString()).toList();
      });
    } else if (_selectedCategory.isNotEmpty) {
      final results = await hadeesProvider.filterHadeesByCategory(_selectedCategory);
      setState(() {
        _searchResults = results.map((h) => h.id.toString()).toList();
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  /// Clear filters
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedSource = '';
      _selectedCategory = '';
      _searchResults = [];
    });
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hadees Collection',
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Consumer<HadeesProvider>(
        builder: (context, hadeesProvider, child) {
          if (hadeesProvider.isLoading) {
            return const LoadingWidget(message: 'Loading Hadees...');
          }

          if (hadeesProvider.error != null) {
            return CustomErrorWidget(
              error: hadeesProvider.error!,
              onRetry: () => hadeesProvider.refresh(),
            );
          }

          return Column(
            children: [
              // Search bar
              _buildSearchBar(),
              
              // Filter chips
              if (_selectedSource.isNotEmpty || _selectedCategory.isNotEmpty)
                _buildFilterChips(),
              
              // Hadees list
              Expanded(
                child: _searchResults.isNotEmpty
                    ? HadeesList(
                        hadees: hadeesProvider.hadees
                            .where((h) => _searchResults.contains(h.id.toString()))
                            .toList(),
                      )
                    : HadeesList(hadees: hadeesProvider.hadees),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Hadees...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                    _performSearch('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _performSearch(value);
        },
      ),
    );
  }

  /// Build filter chips
  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_selectedSource.isNotEmpty)
            Chip(
              label: Text('Source: $_selectedSource'),
              onDeleted: () {
                setState(() {
                  _selectedSource = '';
                });
                _applyFilters();
              },
            ),
          if (_selectedCategory.isNotEmpty)
            Chip(
              label: Text('Category: $_selectedCategory'),
              onDeleted: () {
                setState(() {
                  _selectedCategory = '';
                });
                _applyFilters();
              },
            ),
          if (_selectedSource.isNotEmpty || _selectedCategory.isNotEmpty)
            Chip(
              label: const Text('Clear All'),
              onDeleted: _clearFilters,
            ),
        ],
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => HadeesFilter(
        onSourceSelected: (source) {
          setState(() {
            _selectedSource = source;
            _selectedCategory = '';
          });
          _applyFilters();
        },
        onCategorySelected: (category) {
          setState(() {
            _selectedCategory = category;
            _selectedSource = '';
          });
          _applyFilters();
        },
      ),
    );
  }
}

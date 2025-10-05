import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Hadees search widget
/// 
/// Provides search functionality for Hadees collection
class HadeesSearch extends StatefulWidget {
  final Function(String) onSearch;
  final Function() onClear;

  const HadeesSearch({
    super.key,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<HadeesSearch> createState() => _HadeesSearchState();
}

class _HadeesSearchState extends State<HadeesSearch> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search Hadees by keyword...',
          hintStyle: GoogleFonts.roboto(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          widget.onSearch(value);
        },
      ),
    );
  }

  /// Clear search
  void _clearSearch() {
    _controller.clear();
    setState(() {
      _searchQuery = '';
    });
    widget.onClear();
  }
}

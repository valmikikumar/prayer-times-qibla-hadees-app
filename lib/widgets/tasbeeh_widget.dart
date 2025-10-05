import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/hadees_provider.dart';
import '../models/hadees.dart';

/// Tasbeeh counter widget
/// 
/// Digital Tasbeeh counter for Dhikr with multiple counters
class TasbeehWidget extends StatefulWidget {
  const TasbeehWidget({super.key});

  @override
  State<TasbeehWidget> createState() => _TasbeehWidgetState();
}

class _TasbeehWidgetState extends State<TasbeehWidget> {
  final TextEditingController _nameController = TextEditingController();
  int _currentCount = 0;
  String _currentTasbeehName = 'Subhan Allah';

  @override
  void initState() {
    super.initState();
    _loadTasbeehData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Load Tasbeeh data
  Future<void> _loadTasbeehData() async {
    final hadeesProvider = Provider.of<HadeesProvider>(context, listen: false);
    await hadeesProvider.initialize();
  }

  /// Increment counter
  void _incrementCounter() {
    setState(() {
      _currentCount++;
    });
  }

  /// Reset counter
  void _resetCounter() {
    setState(() {
      _currentCount = 0;
    });
  }

  /// Save counter
  Future<void> _saveCounter() async {
    if (_currentCount > 0) {
      final hadeesProvider = Provider.of<HadeesProvider>(context, listen: false);
      await hadeesProvider.addTasbeeh(_currentTasbeehName);
      await hadeesProvider.updateTasbeehCount(
        hadeesProvider.tasbeehList.last.id!,
        _currentCount,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tasbeeh saved: $_currentTasbeehName - $_currentCount'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
  }

  /// Show add Tasbeeh dialog
  void _showAddTasbeehDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Tasbeeh',
          style: GoogleFonts.amiri(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter Tasbeeh name...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                setState(() {
                  _currentTasbeehName = _nameController.text;
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HadeesProvider>(
        builder: (context, hadeesProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Current Tasbeeh counter
                _buildCurrentTasbeeh(),
                
                const SizedBox(height: 24),
                
                // Tasbeeh list
                _buildTasbeehList(hadeesProvider.tasbeehList),
                
                const SizedBox(height: 24),
                
                // Quick Dhikr buttons
                _buildQuickDhikrButtons(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTasbeehDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build current Tasbeeh counter
  Widget _buildCurrentTasbeeh() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Tasbeeh name
            Text(
              _currentTasbeehName,
              style: GoogleFonts.amiri(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Counter display
            Text(
              _currentCount.toString(),
              style: GoogleFonts.roboto(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _incrementCounter,
                  icon: const Icon(Icons.add),
                  label: const Text('Count'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _resetCounter,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _saveCounter,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build Tasbeeh list
  Widget _buildTasbeehList(List<Tasbeeh> tasbeehList) {
    if (tasbeehList.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.touch_app,
                size: 64,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(height: 16),
              Text(
                'No Tasbeeh counters yet',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the + button to add a new Tasbeeh counter',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Tasbeeh Counters',
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...tasbeehList.map((tasbeeh) => _buildTasbeehItem(tasbeeh)),
      ],
    );
  }

  /// Build individual Tasbeeh item
  Widget _buildTasbeehItem(Tasbeeh tasbeeh) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            tasbeeh.count.toString(),
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        title: Text(
          tasbeeh.name,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Count: ${tasbeeh.count}',
          style: GoogleFonts.roboto(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteTasbeeh(tasbeeh),
        ),
      ),
    );
  }

  /// Delete Tasbeeh
  Future<void> _deleteTasbeeh(Tasbeeh tasbeeh) async {
    final hadeesProvider = Provider.of<HadeesProvider>(context, listen: false);
    await hadeesProvider.deleteTasbeeh(tasbeeh.id!);
  }

  /// Build quick Dhikr buttons
  Widget _buildQuickDhikrButtons() {
    final quickDhikr = [
      'Subhan Allah',
      'Alhamdulillah',
      'Allahu Akbar',
      'La ilaha illa Allah',
      'Astaghfirullah',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Dhikr',
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quickDhikr.map((dhikr) {
            return ActionChip(
              label: Text(dhikr),
              onPressed: () {
                setState(() {
                  _currentTasbeehName = dhikr;
                });
              },
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              labelStyle: GoogleFonts.roboto(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

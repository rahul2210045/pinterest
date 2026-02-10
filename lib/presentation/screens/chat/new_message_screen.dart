import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  // To track selected users (multi-selection)
  final Set<int> _selectedIndices = {};
  final FocusNode _searchFocus = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      setState(() {
        _isSearching = _searchFocus.hasFocus;
      });
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isNextActive = _selectedIndices.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'New message',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Center(
            child: InkWell(
              onTap: isNextActive ? () => context.push('/chat-screen') : null,
              child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
                ),
                decoration: BoxDecoration(
                color: isNextActive ? Colors.red : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'Next',
                  style: TextStyle(
                  color: isNextActive ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  ),
                ),
                ),
              ),
              ),
            ),
            ),
          // ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: TextField(
              focusNode: _searchFocus,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by name or email',
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                prefixIcon: _isSearching
                    ? null
                    : Icon(Icons.search, color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.grey.shade900,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // People List
          Expanded(
            child: ListView(
              children: [
                _buildPersonTile(
                  0,
                  'Ishika Shukla',
                  'assets/images/profile.jpg',
                ),
                _buildPersonTile(1, 'Agam Tyagi', 'assets/images/profile.jpg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonTile(int index, String name, String imagePath) {
    bool isAdded = _selectedIndices.contains(index);

    return InkWell(
      onTap: () => _toggleSelection(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(radius: 24, backgroundImage: AssetImage(imagePath)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isAdded ? Colors.white : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isAdded ? 'Added' : 'Add',
                style: TextStyle(
                  color: isAdded ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

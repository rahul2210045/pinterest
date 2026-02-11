import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onTap;

  const SearchBarWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        height: 46,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.white70),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search for ideas',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
            Icon(Icons.camera_alt_outlined, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
class SearchInputOverlay extends StatefulWidget {
  const SearchInputOverlay({super.key});

  @override
  State<SearchInputOverlay> createState() => _SearchInputOverlayState();
}

class _SearchInputOverlayState extends State<SearchInputOverlay> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => focusNode.requestFocus());
  }

  void _submit(String value) {
    if (value.trim().isEmpty) return;
    Navigator.pop(context);
    context.push('/search-results', extra: value.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onSubmitted: _submit,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const SizedBox(), // hide search icon
                    suffixIcon: const Icon(Icons.camera_alt_outlined),
                    hintText: 'Search for ideas',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

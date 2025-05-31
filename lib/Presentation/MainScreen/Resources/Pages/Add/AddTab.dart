import 'package:flutter/material.dart';

void showAddTabModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xff1b1b1b),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Start creating now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 48), // space to balance layout
              ],
            ),
            const SizedBox(height: 20),

            // The 3 buttons (Pin, Collage, Board)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                AddOption(icon: Icons.push_pin, label: 'Pin'),
                AddOption(icon: Icons.cut, label: 'Collage'),
                AddOption(icon: Icons.grid_view, label: 'Board'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

// Button widget
class AddOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const AddOption({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

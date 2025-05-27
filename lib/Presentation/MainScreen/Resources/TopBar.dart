import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/cubit/main_screen_cubit.dart';

class PinterestCategoryBar extends StatelessWidget {
  // List of categories shown in the bar
  final List<String> categories;

  const PinterestCategoryBar({
    Key? key,
    this.categories = const [
      "All", "My saves", "Gardening", "Food", "Art", "Nature", "Travel", "Style"
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,       // Black background for the bar
      height: 48,                // Fixed height
      child: BlocBuilder<MainScreenCubit, MainScreenState>(
        builder: (context, state) {
          // Get cubit instance to read and update state
          final cubit = context.read<MainScreenCubit>();

          return ListView.separated(
            scrollDirection: Axis.horizontal,               // Scroll horizontally
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,                    // Number of categories
            separatorBuilder: (_, __) => const SizedBox(width: 12), // Space between items
            itemBuilder: (context, index) {
              // Check if this category is selected
              final isSelected = cubit.selectedCategoryIndex == index;

              return GestureDetector(
                onTap: () {
                  // Update selected category in cubit
                  cubit.selectCategory(index);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Category text
                      Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[400],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Bottom underline indicator for selected category
                      Container(
                        height: 3,
                        width: isSelected ? 24 : 0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

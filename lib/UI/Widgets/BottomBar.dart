import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final PageController pageController;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomBar({
    required this.pageController,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        onItemTapped(index);
        pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 0 ? Icons.home : Icons.home_outlined),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 1 ? Icons.search : Icons.search_outlined),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 2 ? Icons.video_collection : Icons.video_collection_outlined),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 3 ? Icons.person : Icons.person_outline),
          label: "",

        ),

      ],
    );
  }
}

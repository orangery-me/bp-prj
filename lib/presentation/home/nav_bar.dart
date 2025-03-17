import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:blood_pressure/common/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      height: 76,
      itemCount: 4,
      tabBuilder: (int index, bool isActive) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
              isActive ? const Color(0xFF193A4A) : const Color(0xFFB7B8C5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: SvgPicture.asset(
              IconConstants.iconPaths[index],
              color: Colors.white,
              fit: BoxFit.scaleDown,
            ),
          ),
        );
      },
      activeIndex: selectedIndex,
      onTap: onItemTapped,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.smoothEdge,
      shadow: const Shadow(
        color: Colors.black12,
        blurRadius: 20,
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfilesapp/screens/FolderScreen.dart';
import 'package:gfilesapp/screens/PhotoScreen.dart';
import 'package:gfilesapp/services/FileService.dart';

final screens = [const PhotoScreen(), const FolderScreen()];
final fileService = FileService();

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState<int>(0);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: screens[currentIndex.value],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 60,
            curve: Curves.easeInOut,
            child: BottomNavigationBar(
              onTap: (value) => currentIndex.value = value,
              currentIndex: currentIndex.value,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.photo), label: "Photos"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.folder), label: "Folders")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

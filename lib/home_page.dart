import 'package:converter_youtube/Screens/music_link_page.dart';
import 'package:converter_youtube/Screens/video_link_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Text('music video downloader Tubi'),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: pages[_currentIndex],
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.red,
      items: items,
      onTap: (value) {
        setState(() {
          _currentIndex = value;
        });
      },
    );
  }

  List<Widget> pages = [
    MusicLinkPage(),
    VideoLinkPage(),
  ];
  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.music_note_outlined), label: "Music"),
    BottomNavigationBarItem(icon: Icon(Icons.video_file_outlined), label: "Video"),
  ];
}

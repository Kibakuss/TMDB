import 'package:flutter/material.dart';
import 'package:lazyload/Library/Widgets/Inherited/provider.dart';
import 'package:lazyload/domain/data_providers/session_data_provider.dart';
import 'package:lazyload/widgets/movie_list/movie_list_widget.dart';
import 'main_screen_model.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;

  void onSelectedTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<MainScreenModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TMDB"),
        actions: [
          IconButton(
              onPressed: () => SessionDataProvider().setSessionId(null),
              icon: const Icon(Icons.search))
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: const [
          Text(
            'Новости',
          ),
          MovieListWidget(),
          Text(
            'Сериалы',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation),
            label: 'Фильмы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined),
            label: 'Сериалы',
          ),
        ],
        onTap: (onSelectedTab),
      ),
    );
  }
}

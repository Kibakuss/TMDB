import 'package:flutter/material.dart';
import 'package:lazyload/ui/navigation/main_navigation.dart';


class Movie {
  final int id;
  final String imageName;
  final String title;
  final String time;
  final String description;

  Movie({
    required this.id,
    required this.imageName,
    required this.title,
    required this.time,
    required this.description,
  });
}

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({Key? key}) : super(key: key);

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  final _movies = [
    Movie(
      id: 1,
      imageName: "images/a.jpg",
      title: "Отряд самоубийц",
      time: "April 7,2021",
      description:
          "MMa fither colub in England very good film with top actors Tom Hardy and Mstr Putin.Very satisfaction film about adventure somebody guys who live in England in 1970 ",
    ),
    Movie(
      id: 2,
      imageName: "images/a.jpg",
      title: "Острые козырьки",
      time: "April 7,2021",
      description:
          "MMa fither colub in England very good film with top actors Tom Hardy and Mstr Putin.Very satisfaction film about adventure somebody guys who live in England in 1970 ",
    ),
    Movie(
      id: 3,
      imageName: "images/a.jpg",
      title: "Железный человек",
      time: "April 7,2021",
      description:
          "MMa fither colub in England very good film with top actors Tom Hardy and Mstr Putin.Very satisfaction film about adventure somebody guys who live in England in 1970 ",
    ),
    Movie(
      id: 4,
      imageName: "images/a.jpg",
      title: "Отпуск",
      time: "April 7,2021",
      description:
          "MMa fither colub in England very good film with top actors Tom Hardy and Mstr Putin.Very satisfaction film about adventure somebody guys who live in England in 1970 ",
    ),
    Movie(
      id: 5,
      imageName: "images/a.jpg",
      title: "Hulk",
      time: "April 7,2021",
      description:
          "MMa fither colub in England very good film with top actors Tom Hardy and Mstr Putin.Very satisfaction film about adventure somebody guys who live in England in 1970 ",
    ),
    Movie(
      id: 6,
      imageName: "images/a.jpg",
      title: "Бриллиантовая рука",
      time: "April 7,2021",
      description:
          "MMa fither colub in England very good film with top actors Tom Hardy and Mstr Putin.Very satisfaction film about adventure somebody guys who live in England in 1970 ",
    ),
    Movie(
      id: 7,
      imageName: "images/a.jpg",
      title: "Приключения Шурика",
      time: "April 7,2021",
      description:
          "MMa fither colub in England very good film with top actors Tom Hardy and Mstr Putin.Very satisfaction film about adventure somebody guys who live in England in 1970 ",
    ),
    Movie(
      id: 8,
      imageName: "images/a.jpg",
      title: "Операция Ы",
      time: "April 7,2021",
      description:
          "MMa fither colub in England very good film with top actors Tom Hardy and Mstr Putin.Very satisfaction film about adventure somebody guys who live in England in 1970 ",
    ),
    Movie(
      id: 9,
      imageName: "images/a.jpg",
      title: "Gang Shit",
      time: "April 7,2021",
      description:
          "MMa fither colub in England very good film with top actors Tom Hardy and Mstr Putin.Very satisfaction film about adventure somebody guys who live in England in 1970 ",
    ),
    Movie(
      id: 10,
      imageName: "images/a.jpg",
      title: "Hallo Jim",
      time: "April 7,2021",
      description:
          "MMa fither colub in England very good film with top actors Tom Hardy and Mstr Putin.Very satisfaction film about adventure somebody guys who live in England in 1970 ",
    ),
  ];
  var _filtredMovies = <Movie>[];

  final _searchController = TextEditingController();
  void _searchMovies() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      _filtredMovies = _movies.where((Movie movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      _filtredMovies = _movies;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _filtredMovies = _movies;
    _searchController.addListener(_searchMovies);
  }

  void _onMovieTap(int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(top: 70),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: _filtredMovies.length,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index) {
            final movie = _filtredMovies[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 5),
                            blurRadius: 8),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage(movie.imageName),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                movie.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                movie.time,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14.4, color: Colors.grey[600]),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                movie.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _onMovieTap(index),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Поиск",
              filled: true,
              fillColor: Colors.white.withAlpha(235),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

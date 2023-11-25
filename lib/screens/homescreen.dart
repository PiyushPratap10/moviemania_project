import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moviesphere_app/screens/detailscreen.dart';
import 'dart:convert';

import 'package:moviesphere_app/screens/searchscreen.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      setState(() {
        movies = List<Map<String, dynamic>>.from(responseData);
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/MovieMania.png',
              width: 200,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildMovieGrid(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }

  Widget _buildMovieGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final show = movie['show'];

        if (show != null &&
            show['image'] != null &&
            show['image']['medium'] != null) {
          final imageUrl = show['image']['medium'];
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(movie: show),
                  ),
                );
              },
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    FadeInImage(
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(imageUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black54,
                        child: Column(children: [
                          Text(
                            show['name'],
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          // Text(
                          //   show['summary'],
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: const TextStyle(
                          //       color: Color.fromARGB(255, 137, 137, 137)),
                          // ),
                        ]),
                      ),
                    )
                  ],
                ),
              ));
        } else {
          return Container();
        }
      },
    );
  }
}

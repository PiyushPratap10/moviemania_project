import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:moviesphere_app/screens/detailscreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> searchResults = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Your Delight'),
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchMovies(searchController.text);
                  },
                ),
              ),
            ),
          ),

          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Future<void> searchMovies(String searchTerm) async {
    try {
      final response = await http.get(
          Uri.parse('https://api.tvmaze.com/search/shows?q=${searchTerm}'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        setState(() {
          searchResults = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (error) {
      print('Error searching movies: $error');
    }
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final result = searchResults[index];
        final show = result['show'];

        
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
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image(
                    image: NetworkImage(imageUrl),
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        
                        Text(
                          show['name'],
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        
                        Text(
                          show['summary'],
                          maxLines: 3, 
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

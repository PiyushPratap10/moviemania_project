import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie['image']['original'];
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FadeInImage(
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 450,
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(imageUrl)),
              ),
              const SizedBox(height: 20),
              Text(
                movie['name'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    movie['summary'],
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

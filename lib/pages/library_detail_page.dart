import 'package:flutter/material.dart';
import '../models/library_film.dart';

class LibraryDetailPage extends StatelessWidget {
  final LibraryFilm film;

  const LibraryDetailPage({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(film.judul)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(film.gambar, height: 300, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                film.judul,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(film.deskripsi, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

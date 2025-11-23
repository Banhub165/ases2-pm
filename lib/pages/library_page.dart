import 'package:flutter/material.dart';
import '../models/library_film.dart';
import 'library_detail_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LibraryFilm> films = [
      LibraryFilm(
        judul: "The Dark Knight",
        gambar: "assets/images/dark_knight.jpg",
        deskripsi: "Film superhero dari DC Studios.",
      ),
      LibraryFilm(
        judul: "Interstellar",
        gambar: "assets/images/interstellar.jpg",
        deskripsi: "Kisah epik time travel.",
      ),
      LibraryFilm(
        judul: "Inception",
        gambar: "assets/images/inception.jpg",
        deskripsi: "Film thriller karya Christopher Nolan.",
      ),
      LibraryFilm(
        judul: "Tenet",
        gambar: "assets/images/tenet.jpg",
        deskripsi: "Film karya Christopher Nolan.",
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Library Film")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: films.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 kolom
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.65, // proporsional tinggi VS lebar
        ),
        itemBuilder: (context, index) {
          final film = films[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LibraryDetailPage(film: film),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.asset(film.gambar, fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      film.judul,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

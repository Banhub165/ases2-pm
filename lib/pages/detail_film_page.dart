import 'package:flutter/material.dart';
import '../models/film.dart';
import 'edit_film_page.dart';

class DetailFilmPage extends StatelessWidget {
  final Film film;

  const DetailFilmPage({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(film.judul)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: "film_${film.id}",
              child: Image.network(film.gambar, height: 350, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                film.judul,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                film.deskripsi?.isNotEmpty == true
                    ? film.deskripsi!
                    : "Tidak ada deskripsi.",
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditFilmPage(film: film)),
                  );

                  if (updated == true) {
                    Navigator.pop(context, true);
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Film"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

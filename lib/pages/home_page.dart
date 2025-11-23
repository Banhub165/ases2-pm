import 'package:flutter/material.dart';
import '../models/film.dart';
import '../db/db_helper.dart';
import 'add_film_page.dart';
import 'detail_film_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomePage({super.key, required this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Film> films = [];
  final db = DBHelper();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    films = await db.getFilms();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Film Saya"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFilmPage()),
          );
          if (result == true) {
            loadData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Film berhasil ditambahkan")),
            );
          }
        },
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : films.isEmpty
          ? const Center(child: Text("Belum ada film"))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: films.length,
              itemBuilder: (context, index) {
                final film = films[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailFilmPage(film: film),
                        ),
                      );
                      if (updated == true) {
                        loadData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Film diperbarui")),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Hero(
                          tag: "film_${film.id}",
                          child: ClipRRect(
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(12),
                            ),
                            child: Image.network(
                              film.gambar,
                              width: 100,
                              height: 140,
                              fit: BoxFit.cover,
                              errorBuilder: (a, b, c) => Container(
                                width: 100,
                                height: 140,
                                color: Colors.grey,
                                child: const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  film.judul,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  film.deskripsi ?? "-",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await db.deleteFilm(film.id!);
                            loadData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Film dihapus")),
                            );
                          },
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

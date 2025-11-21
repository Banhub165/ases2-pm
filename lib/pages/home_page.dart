import 'package:flutter/material.dart';
import '../models/film.dart';
import '../db/db_helper.dart';
import 'add_film_page.dart';
import 'detail_film_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Film> films = [];
  final db = DBHelper();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => _loading = true);
    try {
      films = await db.getFilms();
    } catch (e) {
      print('HomePage: loadData ERROR -> $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Film')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFilmPage()),
          );
          if (result == true) {
            await loadData();
          }
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : films.isEmpty
          ? const Center(child: Text('Belum ada data film'))
          : ListView.builder(
              itemCount: films.length,
              itemBuilder: (context, index) {
                final film = films[index];
                return ListTile(
                  leading: Image.network(
                    film.gambar,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, st) => const Icon(Icons.broken_image),
                  ),
                  title: Text(film.judul),
                  subtitle: Text(film.deskripsi ?? '-'),
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailFilmPage(film: film),
                      ),
                    );
                    if (updated == true) {
                      await loadData();
                    }
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        await db.deleteFilm(film.id!);
                        await loadData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Film dihapus')),
                        );
                      } catch (e) {
                        print('HomePage: delete ERROR -> $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal hapus: $e')),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}

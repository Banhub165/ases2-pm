import 'package:flutter/material.dart';

void main() => runApp(FilmFavoriteApp());

class FilmFavoriteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Favorit',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 0, 0),
        ),
      ),
      home: FilmFavoritePage(),
    );
  }
}

class FilmFavoritePage extends StatefulWidget {
  @override
  _FilmFavoritePageState createState() => _FilmFavoritePageState();
}

class _FilmFavoritePageState extends State<FilmFavoritePage> {
  final List<Map<String, String>> filmFavorit = [];

  final TextEditingController judulController = TextEditingController();
  final TextEditingController gambarController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  void showFilmDialog({Map<String, String>? film, int? index}) {
    if (film != null) {
      judulController.text = film['judul']!;
      gambarController.text = film['gambar']!;
      deskripsiController.text = film['deskripsi']!;
    } else {
      judulController.clear();
      gambarController.clear();
      deskripsiController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(film == null ? 'Tambah Film' : 'Edit Film'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: judulController,
                decoration: InputDecoration(labelText: 'Judul Film'),
              ),
              TextField(
                controller: gambarController,
                decoration: InputDecoration(labelText: 'URL Gambar'),
              ),
              TextField(
                controller: deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newFilm = {
                'judul': judulController.text,
                'gambar': gambarController.text,
                'deskripsi': deskripsiController.text,
              };

              setState(() {
                if (film == null) {
                  filmFavorit.add(newFilm);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Film berhasil ditambahkan')),
                  );
                } else {
                  filmFavorit[index!] = newFilm;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Film berhasil diperbarui')),
                  );
                }
              });

              Navigator.pop(context);
            },
            child: Text(film == null ? 'Tambah' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  void hapusFilm(int index) {
    setState(() {
      filmFavorit.removeAt(index);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Film berhasil dihapus')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Film Gacor'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showFilmDialog(),
        label: Text('Tambah Film'),
        icon: Icon(Icons.add),
      ),
      body: filmFavorit.isEmpty
          ? Center(child: Text('Belum ada film favorit.'))
          : ListView.builder(
              itemCount: filmFavorit.length,
              itemBuilder: (context, index) {
                final film = filmFavorit[index];
                return Card(
                  margin: EdgeInsets.all(12),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          film['gambar']!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 200,
                                color: const Color.fromARGB(255, 0, 76, 255),
                                child: Icon(Icons.broken_image),
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              film['judul']!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(film['deskripsi']!),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () =>
                                      showFilmDialog(film: film, index: index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => hapusFilm(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

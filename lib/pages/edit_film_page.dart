import 'package:flutter/material.dart';
import '../models/film.dart';
import '../db/db_helper.dart';

class EditFilmPage extends StatefulWidget {
  final Film film;

  const EditFilmPage({super.key, required this.film});

  @override
  State<EditFilmPage> createState() => _EditFilmPageState();
}

class _EditFilmPageState extends State<EditFilmPage> {
  late TextEditingController judulC;
  late TextEditingController gambarC;
  late TextEditingController deskripsiC;

  final db = DBHelper();

  @override
  void initState() {
    super.initState();

    judulC = TextEditingController(text: widget.film.judul);
    gambarC = TextEditingController(text: widget.film.gambar);
    deskripsiC = TextEditingController(text: widget.film.deskripsi ?? "");
  }

  void updateFilm() async {
    if (judulC.text.isEmpty || gambarC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan URL Gambar wajib diisi")),
      );
      return;
    }

    Film updatedFilm = Film(
      id: widget.film.id,
      judul: judulC.text.trim(),
      gambar: gambarC.text.trim(),
      deskripsi: deskripsiC.text.trim(),
    );

    await db.updateFilm(updatedFilm);

    Navigator.pop(
      context,
      true,
    ); // kembali ke halaman sebelumnya dengan sinyal update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Film")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: judulC,
              decoration: const InputDecoration(labelText: "Judul Film"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: gambarC,
              decoration: const InputDecoration(labelText: "URL Gambar Film"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: deskripsiC,
              decoration: const InputDecoration(labelText: "Deskripsi Film"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateFilm,
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}

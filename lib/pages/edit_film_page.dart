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

  Future<void> updateFilm() async {
    if (judulC.text.isEmpty || gambarC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan URL Gambar wajib diisi")),
      );
      return;
    }

    // PENTING: ID harus disertakan!
    Film updatedFilm = Film(
      id: widget.film.id,
      judul: judulC.text.trim(),
      gambar: gambarC.text.trim(),
      deskripsi: deskripsiC.text.trim(),
    );

    await db.updateFilm(updatedFilm);

    Navigator.pop(context, true); // kirim sinyal sukses
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
              decoration: InputDecoration(
                labelText: "Judul Film",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: gambarC,
              decoration: InputDecoration(
                labelText: "URL GAMBAR",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: deskripsiC,
              decoration: InputDecoration(
                labelText: "Deskripsi Film",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateFilm,
              child: const Text("Perbarui Film"),
            ),
          ],
        ),
      ),
    );
  }
}

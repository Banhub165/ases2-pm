import 'package:flutter/material.dart';
import '../models/film.dart';
import '../db/db_helper.dart';

class AddFilmPage extends StatefulWidget {
  const AddFilmPage({super.key});

  @override
  State<AddFilmPage> createState() => _AddFilmPageState();
}

class _AddFilmPageState extends State<AddFilmPage> {
  final TextEditingController judulC = TextEditingController();
  final TextEditingController gambarC = TextEditingController();
  final TextEditingController deskripsiC = TextEditingController();

  final db = DBHelper();
  bool _saving = false;

  Future<void> saveFilm() async {
    print('AddFilmPage: saveFilm called');
    if (judulC.text.isEmpty || gambarC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan URL Gambar wajib diisi')),
      );
      return;
    }

    final newFilm = Film(
      judul: judulC.text.trim(),
      gambar: gambarC.text.trim(),
      deskripsi: deskripsiC.text.trim(),
    );

    setState(() => _saving = true);

    try {
      final id = await db.insertFilm(newFilm);
      print('AddFilmPage: inserted id=$id');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Film berhasil disimpan')));
      Navigator.pop(context, true);
    } catch (e, st) {
      print('AddFilmPage: insert ERROR -> $e\n$st');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan film: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    judulC.dispose();
    gambarC.dispose();
    deskripsiC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Film')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: judulC,
              decoration: const InputDecoration(labelText: 'Judul Film'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: gambarC,
              decoration: const InputDecoration(labelText: 'URL Gambar Film'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: deskripsiC,
              decoration: const InputDecoration(labelText: 'Deskripsi Film'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _saving
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: saveFilm,
                    child: const Text('Simpan Film'),
                  ),
          ],
        ),
      ),
    );
  }
}

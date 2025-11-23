class Film {
  int? id;
  String judul;
  String gambar;
  String? deskripsi;

  Film({this.id, required this.judul, required this.gambar, this.deskripsi});

  Map<String, dynamic> toMap() {
    return {'id': id, 'judul': judul, 'gambar': gambar, 'deskripsi': deskripsi};
  }

  factory Film.fromMap(Map<String, dynamic> map) {
    return Film(
      id: map['id'] is int
          ? map['id'] as int
          : (map['id'] != null ? int.tryParse(map['id'].toString()) : null),
      judul: map['judul'] ?? '',
      gambar: map['gambar'] ?? '',
      deskripsi: map['deskripsi'],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const FilmFavoriteApp());

class FilmFavoriteApp extends StatelessWidget {
  const FilmFavoriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NETPLIK',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 17, 0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Map<String, String>> filmList = [
    {'judul': 'Inception', 'gambar': 'assets/images/inception.jpg'},
    {'judul': 'Interstellar', 'gambar': 'assets/images/interstellar.jpg'},
    {'judul': 'The Dark Knight', 'gambar': 'assets/images/dark_knight.jpg'},
    {'judul': 'Tenet', 'gambar': 'assets/images/tenet.jpg'},
  ];

  final List<Map<String, String>> favoriteList = [];
  final List<Map<String, String>> customList = [];

  void addToFavorite(Map<String, String> film) {
    if (!favoriteList.contains(film)) {
      setState(() {
        favoriteList.add(film);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${film['judul']} ditambahkan ke favorit')),
        );
      });
    }
  }

  void removeFromFavorite(Map<String, String> film) {
    setState(() {
      favoriteList.remove(film);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${film['judul']} dihapus dari favorit')),
      );
    });
  }

  void showInputDialog() {
    String judul = '';
    String urlGambar = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Film Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => judul = value,
              decoration: const InputDecoration(labelText: 'Judul Film'),
            ),
            TextField(
              onChanged: (value) => urlGambar = value,
              decoration: const InputDecoration(labelText: 'URL Gambar'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Simpan'),
            onPressed: () {
              if (judul.isNotEmpty && urlGambar.isNotEmpty) {
                setState(() {
                  customList.add({'judul': judul, 'gambar': urlGambar});
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Film "$judul" ditambahkan')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentList = selectedIndex == 0
        ? [...filmList, ...customList]
        : selectedIndex == 1
            ? favoriteList
            : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedIndex == 0
              ? 'Film'
              : selectedIndex == 1
                  ? 'Favorit'
                  : 'Pengaturan',
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Film'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: selectedIndex == 2
            ? SettingsScreen(
                onAddData: showInputDialog,
                customList: customList,
              )
            : currentList.isEmpty
                ? const Center(child: Text('Belum ada list favorit, isi dulu kalo mo ada.'))
                : GridView.builder(
                    itemCount: currentList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final film = currentList[index];
                      final isFavorite = favoriteList.contains(film);
                      return FilmCard(
                        judul: film['judul']!,
                        gambar: film['gambar']!,
                        isFavorite: isFavorite,
                        onAdd: () => addToFavorite(film),
                        onRemove: () => removeFromFavorite(film),
                        showFavoriteButton: selectedIndex == 0,
                      );
                    },
                  ),
      ),
    );
  }
}

class FilmCard extends StatelessWidget {
  final String judul;
  final String gambar;
  final bool isFavorite;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool showFavoriteButton;

  const FilmCard({
    required this.judul,
    required this.gambar,
    required this.isFavorite,
    required this.onAdd,
    required this.onRemove,
    required this.showFavoriteButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              gambar,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              judul,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          if (showFavoriteButton)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton.icon(
                onPressed: isFavorite ? onRemove : onAdd,
                icon: Icon(isFavorite ? Icons.remove : Icons.favorite),
                label: Text(isFavorite ? 'Hapus Favorit' : 'Tambah Favorit'),
              ),
            ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final VoidCallback onAddData;
  final List<Map<String, String>> customList;

  const SettingsScreen({
    required this.onAddData,
    required this.customList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.exit_to_app),
            label: const Text('Keluar Aplikasi'),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.info),
            label: const Text('Tentang Kami'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Us'),
                  content: const Text('Dibuat oleh Adil dan Syaban'),
                  actions: [
                    TextButton(
                      child: const Text('Tutup'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Tambah Data'),
            onPressed: onAddData,
          ),
          const SizedBox(height: 30),
          const Text('Film Tambahan:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...customList.map((film) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: Image.network(
                    film['gambar']!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                  title: Text(film['judul']!),
                ),
              )),
        ],
      ),
    );
  }
}
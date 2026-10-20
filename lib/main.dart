import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'drawing_screen.dart'; // Добавляем импорт нашего нового экрана

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage(); // Инициализируем хранилище (пока просто готовим его)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мои Заметки',
      debugShowCheckedModeBanner: false, // Убираем лишнюю надпись "DEBUG"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои Заметки'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // При нажатии открываем экран рисования
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DrawingScreen()),
            );
          },
          icon: const Icon(Icons.edit_note, size: 28),
          label: const Text('Создать заметку', style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ),
    );
  }
}
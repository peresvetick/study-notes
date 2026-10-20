import 'package:flutter/material.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  // Список всех завершенных штрихов (каждый штрих - это список точек)
  final List<List<Offset>> _strokes = [];
  // Текущий штрих, который мы рисуем прямо сейчас
  final List<Offset> _currentStroke = [];

  // Когда палец или Apple Pencil коснулся экрана
  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _currentStroke.clear();
      _currentStroke.add(event.localPosition);
    });
  }

  // Когда палец или Apple Pencil двигается по экрану
  void _onPointerMove(PointerMoveEvent event) {
    setState(() {
      _currentStroke.add(event.localPosition);
    });
  }

  // Когда палец или Apple Pencil оторвался от экрана
  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      if (_currentStroke.isNotEmpty) {
        _currentStroke.add(event.localPosition);
        _strokes.add(List.from(_currentStroke));
        _currentStroke.clear();
      }
    });
  }

  // Очистить холст
  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя заметка'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearCanvas,
            tooltip: 'Очистить холст',
          ),
        ],
      ),
      // Listener идеально ловит события Apple Pencil и мыши
      body: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        child: CustomPaint(
          painter: _DrawingPainter(
            strokes: _strokes,
            currentStroke: _currentStroke,
          ),
          child: Container(), // Занимает всё доступное место
        ),
      ),
    );
  }
}

// Класс, который рисует линии на экране
class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;

  _DrawingPainter({required this.strokes, required this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    // Настраиваем "кисть": черный цвет, толщина 3, скругленные края
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Рисуем все завершенные штрихи
    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      
      final path = Path();
      path.moveTo(stroke[0].dx, stroke[0].dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }

    // Рисуем текущий штрих (пока палец еще на экране)
    if (currentStroke.length >= 2) {
      final path = Path();
      path.moveTo(currentStroke[0].dx, currentStroke[0].dy);
      for (int i = 1; i < currentStroke.length; i++) {
        path.lineTo(currentStroke[i].dx, currentStroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
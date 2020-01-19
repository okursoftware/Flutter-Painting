import 'package:flutter/material.dart';
import 'package:painting/color_box.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        /* appBar: AppBar(
          title: Text('Flutter Painting AppBar'),
        ),*/
        body: MainView(),
      ),
    );
  }
}

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Offset> _offsets = [];
  Color activeColor;

  void onChangeColor(Color value) {
    activeColor = value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox _object = context.findRenderObject();
          Offset _locationPoints =
              _object.globalToLocal(details.globalPosition);

          _offsets.add(_locationPoints);
        });
      },
      onPanEnd: (details) {
        _offsets.add(null);
      },
      child: Stack(
        children: <Widget>[
          CustomPaint(
            painter: MyPainter(_offsets, activeColor),
            size: Size.infinite,
          ),
          new ListTile(
            title: new ColorBoxGroup(
              width: 25.0,
              height: 25.0,
              spacing: 10.0,
              colors: [
                Colors.red,
                Colors.orange,
                Colors.green,
                Colors.purple,
                Colors.blue,
                Colors.yellow,
              ],
              groupValue: activeColor,
              onTap: (color) {
                setState(() {
                  onChangeColor(color);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<Offset> offsets;
  final Color activeColor;
  final brush = Paint()
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 4.0
    ..color = Colors.red
    ..isAntiAlias = true;

  MyPainter(this.offsets, this.activeColor);

  @override
  void paint(Canvas canvas, Size size) {
    brush.color = activeColor == null ? Colors.red : activeColor;
    for (int i = 0; i < offsets.length - 1; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        canvas.drawLine(offsets[i], offsets[i + 1], brush);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/cupertino.dart';
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
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.save),
        ),
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
  List<Color> _colors = [];
  List<double> _brushSizes = [];
  double brushSize = 4;
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
          _colors.add(activeColor);
          _brushSizes.add(brushSize);
        });
      },
      onPanEnd: (details) {
        _offsets.add(null);
        _colors.add(null);
        _brushSizes.add(null);
      },
      child: Stack(
        children: <Widget>[
          CustomPaint(
            painter: MyPainter(
                offsets: _offsets, colors: _colors, brushSizes: _brushSizes),
            size: Size.infinite,
          ),
          SafeArea(
            top: true,
            child: new ListTile(
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new CircleButton(
                  onTap: () {
                    setState(() {
                      brushSize = 4;
                    });
                  },
                  iconData: Icons.brush,
                  iconSize: 30,
                ),
                new CircleButton(
                  onTap: () {
                    setState(() {
                      brushSize = 7;
                    });
                  },
                  iconData: Icons.brush,
                  iconSize: 40,
                ),
                new CircleButton(
                  onTap: () {
                    setState(() {
                      brushSize = 10;
                    });
                  },
                  iconData: Icons.brush,
                  iconSize: 50,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<Offset> offsets;
  //final Color activeColor;
  final List<Color> colors;
  final List<double> brushSizes;
  final brush = Paint()
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 4.0
    ..color = Colors.red
    ..isAntiAlias = true;

  MyPainter(
      {@required this.offsets,
      @required this.colors,
      @required this.brushSizes});

  @override
  void paint(Canvas canvas, Size size) {
    //debugPrint(offsets.length.toString() + " " + colors.length.toString());
    for (int i = 0; i < offsets.length - 1; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        brush.color = colors[i] == null ? Colors.red : colors[i];
        brush.strokeWidth = brushSizes[i];
        canvas.drawLine(offsets[i], offsets[i + 1], brush);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;
  final double iconSize;

  const CircleButton({Key key, this.onTap, this.iconData, this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = iconSize;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: Colors.black,
          size: iconSize,
        ),
      ),
    );
  }
}

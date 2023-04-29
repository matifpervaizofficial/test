// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:whiteboard/whiteboard.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui';
import 'dart:typed_data';

class DrawingBoard extends StatefulWidget {
  static const routeName = "/drawing-board";
  const DrawingBoard({Key? key}) : super(key: key);

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  double drawBoard = 100;
  double _boardSize = 200.0;

  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  GlobalKey _globalKey = GlobalKey();

  List<Color> colors = [
    Colors.pink,
    Colors.black87,
    Colors.yellow,
    Colors.red,
    Colors.amberAccent,
    Colors.purple,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Drawing Board",
              style: TextStyle(color: Colors.black)),
          backgroundColor: const Color.fromRGBO(178, 145, 186, 1),
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {})),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Slider(
            value: _boardSize,
            min: 100.0,
            max: 500.0,
            onChanged: (double value) {
              setState(() {
                _boardSize = value;
              });
            },
          ),
          Container(
            height: 500,
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              height: _boardSize,
              width: _boardSize,
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    drawingPoints.add(
                      DrawingPoint(
                        details.localPosition,
                        Paint()
                          ..color = selectedColor
                          ..isAntiAlias = true
                          ..strokeWidth = strokeWidth
                          ..strokeCap = StrokeCap.round,
                      ),
                    );
                  });
                },
                onPanUpdate: (details) {
                  RenderBox renderBox = _globalKey.currentContext!
                      .findRenderObject() as RenderBox;
                  Offset localPosition =
                      renderBox.globalToLocal(details.globalPosition);

                  setState(() {
                    drawingPoints.add(
                      DrawingPoint(
                        details.localPosition,
                        Paint()
                          ..color = selectedColor
                          ..isAntiAlias = true
                          ..strokeWidth = strokeWidth
                          ..strokeCap = StrokeCap.round,
                      ),
                    );
                  });
                },
                onPanEnd: (val) {
                  setState(() {
                    drawingPoints.add(null);
                  });
                },
                child: RepaintBoundary(
                  key: _globalKey,
                  child: CustomPaint(
                    painter: DrawingPainter(drawingPoints),
                    child: Container(
                      height: 100,
                      //width: _boardSize
                      width: 100,
                    ),
                  ),
                ),
              ),
            ),
          ),
          BottomAppBar(
            child: Row(
              children: [
                Container(
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      colors.length,
                      (index) => _buildColorChoose(colors[index]),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildColorChoose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        height: isSelected ? 47 : 40,
        width: isSelected ? 47 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }

  Future<void> saveImage() async {
    RenderRepaintBoundary? boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Image saved to gallery')));
      }
    }
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  DrawingPainter(this.drawingPoints);
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      DrawingPoint? current = drawingPoints[i];
      DrawingPoint? next = drawingPoints[i + 1];
      if (current != null && next != null) {
        canvas.drawLine(current.offset, next.offset, current.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}

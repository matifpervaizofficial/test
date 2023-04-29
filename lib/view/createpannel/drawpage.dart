// ignore_for_file: sized_box_for_whitespace

import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../models/drawingmode.dart';
import '../../models/sketch.dart';
import '../../utils/mycolors.dart';
import '../../widgets/create.dart';
import '../../widgets/draingcanvas.dart';

class DrawingPage extends HookWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _sliderValue = useState(50.0);
    void _updateSlider(double value) {
      _sliderValue.value = value;
    }

    final selectedColor = useState(Colors.black);
    final strokeSize = useState<double>(10);
    final eraserSize = useState<double>(30);
    final drawingMode = useState(DrawingMode.pencil);
    final filled = useState<bool>(false);
    final polygonSides = useState<int>(3);
    final backgroundImage = useState<Image?>(null);

    final canvasGlobalKey = GlobalKey();

    ValueNotifier<Sketch?> currentSketch = useState(null);
    ValueNotifier<List<Sketch>> allSketches = useState([]);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      initialValue: 1,
    );
    return Scaffold(
      backgroundColor: kCanvasColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Container(
              color: Colors.white,
              height: 500,
              child: Stack(
                children: [
                  Container(
                    color: kCanvasColor,
                    width: MediaQuery.of(context).size.height,
                    height: MediaQuery.of(context).size.height,
                    child: DrawingCanvas(
                      // width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height,
                      drawingMode: drawingMode,
                      selectedColor: selectedColor,
                      strokeSize: strokeSize,
                      eraserSize: eraserSize,
                      // sideBarController: animationController,
                      currentSketch: currentSketch,
                      allSketches: allSketches,
                      canvasGlobalKey: canvasGlobalKey,
                      filled: filled,
                      polygonSides: polygonSides,
                      backgroundImage: backgroundImage,
                    ),
                  ),
                  // Positioned(
                  //   top: kToolbarHeight + 10,
                  //   // left: -5,
                  //   child: SlideTransition(
                  //     position: Tween<Offset>(
                  //       begin: const Offset(-1, 0),
                  //       end: Offset.zero,
                  //     ).animate(animationController),
                  //     child: CanvasSideBar(
                  //       drawingMode: drawingMode,
                  //       selectedColor: selectedColor,
                  //       strokeSize: strokeSize,
                  //       eraserSize: eraserSize,
                  //       currentSketch: currentSketch,
                  //       allSketches: allSketches,
                  //       canvasGlobalKey: canvasGlobalKey,
                  //       filled: filled,
                  //       polygonSides: polygonSides,
                  //       backgroundImage: backgroundImage,
                  //     ),
                  //   ),
                  // ),
                  _CustomAppBar(animationController: animationController),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 100,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: Slider(
                      label: _sliderValue.toString(),
                      value: _sliderValue.value,
                      min: 50,
                      max: 1000,
                      onChanged: _updateSlider,
                    ),
                  ),
                ),
                Expanded(
                  child: MyDrawing(
                      selectedColor: selectedColor,
                      strokeSize: strokeSize,
                      eraserSize: eraserSize,
                      drawingMode: drawingMode,
                      currentSketch: currentSketch,
                      allSketches: allSketches,
                      canvasGlobalKey: canvasGlobalKey,
                      filled: filled,
                      polygonSides: polygonSides,
                      backgroundImage: backgroundImage),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final AnimationController animationController;

  const _CustomAppBar({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (animationController.value == 0) {
                  animationController.forward();
                } else {
                  animationController.reverse();
                }
              },
              icon: const Icon(Icons.menu),
            ),
            const Text(
              'Let\'s Draw',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

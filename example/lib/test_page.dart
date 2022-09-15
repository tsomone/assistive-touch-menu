import 'package:assistive_touch_menu/assistive_touch_menu.dart';
import 'package:example/test_page_two.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final EdgeInsets safeAreaPadding = MediaQuery.of(context).padding;
    final double safeAreaHeight =
        height - safeAreaPadding.top - safeAreaPadding.bottom;

    return Scaffold(
        // color: Theme.of(context).primaryColor,
        body: CustomPaint(
      painter: CenterGuidelinePainter(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'width: $width',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'height: $height',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'SafeArea left padding: ${safeAreaPadding.left}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'SafeArea top padding: ${safeAreaPadding.top}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'SafeArea right padding: ${safeAreaPadding.right}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'SafeArea bottom padding: ${safeAreaPadding.bottom}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'SafeArea height: $safeAreaHeight',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Draggable offset Y min boundary: ${safeAreaPadding.top}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Draggable offset Y max boundary: ${height - safeAreaPadding.bottom}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Draggable offset X min boundary: 0',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Draggable offset X max boundary: $width',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  AssistiveTouchMenu.of(context)
                      .animateTo(AnchoringSide.topLeft);
                },
                child: const Text('Top Left'),
              ),
              OutlinedButton(
                onPressed: () {
                  AssistiveTouchMenu.of(context)
                      .animateTo(AnchoringSide.topRight);
                },
                child: const Text('Top Right'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  AssistiveTouchMenu.of(context)
                      .animateTo(AnchoringSide.bottomLeft);
                },
                child: const Text('Bottom Left'),
              ),
              OutlinedButton(
                onPressed: () {
                  AssistiveTouchMenu.of(context)
                      .animateTo(AnchoringSide.bottomRight);
                },
                child: const Text('Bottom Right'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  AssistiveTouchMenu.of(context).show(context);
                  // return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TestPageTwo()),
                  );
                },
                child: const Text('Navigate to Test Page Two'),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class CenterGuidelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Vertical line
    Paint paint_0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.50, 0);
    path_0.lineTo(size.width * 0.50, size.height);

    canvas.drawPath(path_0, paint_0);

    // Horizontal line
    Paint paint_1 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Path path_1 = Path();
    path_1.moveTo(0, size.height * 0.50);
    path_1.lineTo(size.width, size.height * 0.50);

    canvas.drawPath(path_1, paint_1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';

class AssistantMenu extends StatefulWidget {
  const AssistantMenu({
    Key? key,
    required this.overlaySize,
    this.onChange,
  }) : super(key: key);

  final Size overlaySize;
  final VoidCallback? onChange;

  @override
  State<AssistantMenu> createState() => _AssistantMenuState();
}

class _AssistantMenuState extends State<AssistantMenu> {
  double _opacity = 0.3;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   AssistiveTouchMenu.of(context)
    //       .animationController
    //       .addStatusListener((status) {
    //     log('status $status');
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('AssistantMenu build');
    return GestureDetector(
      onTap: () {
        final ThemeData theme = Theme.of(context);
        // TODO show dialog
        showModalBottomSheet<void>(
          context: context,
          enableDrag: false,
          builder: (BuildContext context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    title: Text('Select action'),
                  ),
                  ListTile(
                      leading: Icon(theme.brightness == Brightness.dark
                          ? Icons.light_mode
                          : Icons.dark_mode),
                      title: Text(theme.brightness == Brightness.dark
                          ? 'Switch Theme to Light'
                          : 'Switch Theme to Dark'),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onChange?.call();
                      }),
                  // ListTile(
                  //   leading: const Icon(Icons.dark_mode),
                  //   title: const Text('Theme light'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     widget.onChange?.call();
                  //   },
                  // ),
                ],
              ),
            );
          },
        );
      },
      onPanDown: (details) {
        log('onPanDown');
        setState(() {
          _opacity = 1;
        });
      },
      onPanUpdate: (details) {
        log('onPanUpdate');
      },
      onPanEnd: (details) async {
        log('onPanEnd');
        await Future.delayed(const Duration(seconds: 3));
        if (_opacity != 1) return;
        setState(() {
          _opacity = 0.3;
        });
      },
      onPanCancel: () async {
        log('onPanCancel');
        // TODO dialog closed
        await Future.delayed(const Duration(seconds: 3));
        if (_opacity != 1) return;
        setState(() {
          _opacity = 0.3;
        });
      },
      onPanStart: (details) {
        log('onPanStart');
      },
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 200),
        onEnd: () {
          log('onEnd');
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.overlaySize.width,
              height: widget.overlaySize.height,
              decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
            ),
            Container(
              width: widget.overlaySize.width / 2 + 16,
              height: widget.overlaySize.height / 2 + 16,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: widget.overlaySize.width / 2 + 8,
              height: widget.overlaySize.height / 2 + 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: widget.overlaySize.width / 2,
              height: widget.overlaySize.height / 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:assistive_touch_menu/src/anchoring_position.dart';
import 'package:assistive_touch_menu/src/anchoring_side_enum.dart';
import 'package:assistive_touch_menu/src/debug.dart';
import 'package:assistive_touch_menu/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AssistiveTouchMenu extends StatefulWidget {
  const AssistiveTouchMenu(
      {Key? key,
      required this.overlayChild,
      required this.overlaySize,
      required this.child})
      : super(key: key);

  final Widget overlayChild;
  final Size overlaySize;
  final Widget child;

  static AssistiveTouchMenuState of(BuildContext context) {
    assert(debugCheckHasAssistiveTouchMenu(context));

    final _DraggableOverlayScope scope =
        context.dependOnInheritedWidgetOfExactType<_DraggableOverlayScope>()!;
    return scope._assistiveTouchMenuState;
  }

  @override
  State<AssistiveTouchMenu> createState() => AssistiveTouchMenuState();
}

class AssistiveTouchMenuState extends State<AssistiveTouchMenu>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  AnchoringPosition anchoringPosition = AnchoringPosition(Offset.zero);

  AnchoringSide anchoringSide = AnchoringSide.topLeft;

  late AnimationController animationController;
  late Animation animation;
  late EdgeInsets safeAreaPadding;
  late Size boundarySize;

  Orientation? _orientation;
  bool _isAnimateToCorner = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAreaPadding = MediaQuery.of(context).padding;
      boundarySize = getBoundarySize(context);

      animationController = AnimationController(
        value: 1,
        vsync: this,
        duration: const Duration(milliseconds: 150),
      )
        ..addListener(() {
          if (_isAnimateToCorner) {
            anchoringPosition.offset = animateToAnchoringSideCorner(
              anchoringSide,
              anchoringPosition.offset,
              widget.overlaySize,
              safeAreaPadding,
              boundarySize,
              animation.value,
            );
          } else {
            anchoringPosition.offset = animateToAnchoringSideBoundary(
              anchoringSide,
              anchoringPosition.offset,
              widget.overlaySize,
              safeAreaPadding,
              boundarySize,
              animation.value,
            );
          }

          _overlayEntry?.markNeedsBuild();
        })
        ..addStatusListener(
          (status) {
            if (status == AnimationStatus.forward) {
              boundarySize = getBoundarySize(context);
            }
            if (status == AnimationStatus.completed) {
              if (isMobile) return;

              updateAttachedStatus();
            }
          },
        );

      animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: animationController, curve: Curves.easeInOut));

      show(context);
    });
  }

  void updateAttachedStatus() {
    anchoringPosition.isAttachedToRightBoundary = false;
    anchoringPosition.isAttachedToBottomBoundary = false;

    if (anchoringPosition.offset.dx ==
        boundarySize.width - widget.overlaySize.width) {
      anchoringPosition.isAttachedToRightBoundary = true;
    }
    if (anchoringPosition.offset.dy ==
        boundarySize.height - widget.overlaySize.height) {
      anchoringPosition.isAttachedToBottomBoundary = true;
    }
  }

  void show(BuildContext context) {
    boundarySize = getBoundarySize(context);
    anchoringPosition.offset = calculateAnchoringOffset(
      anchoringPosition.offset,
      widget.overlaySize,
      boundarySize,
      anchoringSide,
      safeAreaPadding,
    );

    try {
      _overlayEntry = OverlayEntry(builder: (context) {
        return Positioned(
          top: anchoringPosition.offset.dy,
          left: anchoringPosition.offset.dx,
          child: Listener(
            child: widget.overlayChild,
            onPointerMove: (event) {
              if (_isAnimateToCorner) _isAnimateToCorner = false;

              anchoringPosition.offset = Offset(
                anchoringPosition.offset.dx + event.delta.dx,
                anchoringPosition.offset.dy + event.delta.dy,
              );

              final Size boundarySize = getBoundarySize(context);
              anchoringSide = calculateAnchoringSide(
                  anchoringPosition.offset, widget.overlaySize, boundarySize);

              _overlayEntry?.markNeedsBuild();
            },
            onPointerUp: (_) {
              animateOffsetToNearestBoundary();
            },
          ),
        );
      });
      Overlay.of(context)?.insert(_overlayEntry!);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isMobile) {
      // if IOS or Android
      handleOrientationChanges();
    } else {
      // if web or desktop
      handleResponsiveChanges();
    }
  }

  void handleOrientationChanges() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation != _orientation) {
      _orientation = orientation;

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        safeAreaPadding = MediaQuery.of(context).padding;
        boundarySize = getBoundarySize(context);
        anchoringSide = calculateAnchoringSide(
            anchoringPosition.offset, widget.overlaySize, boundarySize);

        animateOffsetToNearestBoundary();
      });
    }
  }

  void handleResponsiveChanges() {
    log('changed');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final Offset overlayBottomRightOffset = Offset(
        anchoringPosition.offset.dx + widget.overlaySize.width,
        anchoringPosition.offset.dy + widget.overlaySize.height,
      );

      final Size boundarySize = getBoundarySize(context);

      if (anchoringPosition.isAttachedToRightBoundary) {
        anchoringPosition.offset = Offset(
            boundarySize.width - widget.overlaySize.width,
            anchoringPosition.offset.dy);
      } else if (boundarySize.width < overlayBottomRightOffset.dx) {
        anchoringPosition.offset = Offset(
            boundarySize.width - widget.overlaySize.width,
            anchoringPosition.offset.dy);
        anchoringPosition.isAttachedToRightBoundary = true;
      }

      if (anchoringPosition.isAttachedToBottomBoundary) {
        anchoringPosition.offset = Offset(anchoringPosition.offset.dx,
            boundarySize.height - widget.overlaySize.height);
      } else if (boundarySize.height < overlayBottomRightOffset.dy) {
        anchoringPosition.offset = Offset(anchoringPosition.offset.dx,
            boundarySize.height - widget.overlaySize.height);
        anchoringPosition.isAttachedToBottomBoundary = true;
      }

      _overlayEntry?.markNeedsBuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _DraggableOverlayScope(
      assistiveTouchMenuState: this,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    _overlayEntry!.remove();
    super.dispose();
  }

  void animateOffsetToNearestBoundary() {
    if (animationController.isAnimating) {
      animationController.stop();
    }
    animationController.reset();
    animationController.forward();
  }

  void animateTo(AnchoringSide anchoringSide) {
    _isAnimateToCorner = true;
    this.anchoringSide = anchoringSide;
    animateOffsetToNearestBoundary();
  }
}

class _DraggableOverlayScope extends InheritedWidget {
  const _DraggableOverlayScope({
    Key? key,
    required Widget child,
    required AssistiveTouchMenuState assistiveTouchMenuState,
  })  : _assistiveTouchMenuState = assistiveTouchMenuState,
        super(key: key, child: child);

  final AssistiveTouchMenuState _assistiveTouchMenuState;

  @override
  bool updateShouldNotify(_DraggableOverlayScope old) =>
      _assistiveTouchMenuState != old._assistiveTouchMenuState;
}

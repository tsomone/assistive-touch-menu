import 'dart:ui';

class AnchoringPosition {
  Offset offset;
  bool isAttachedToRightBoundary;
  bool isAttachedToBottomBoundary;

  AnchoringPosition(
    this.offset, {
    this.isAttachedToRightBoundary = false,
    this.isAttachedToBottomBoundary = false,
  });
}

import 'package:assistive_touch_menu/src/anchoring_side_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
/// boundarySize example:
///
/// final double width = MediaQuery.of(context).size.width;
/// final double height = MediaQuery.of(context).size.height;
/// final Size boundarySize = Size(width, height);
///
AnchoringSide calculateAnchoringSide(
    Offset offset, Size overlaySize, Size boundarySize) {
  if (offset == Offset.zero) return AnchoringSide.topLeft;

  final Offset overlayCenter = Offset(
    offset.dx + overlaySize.width / 2, // overlay center x
    offset.dy + overlaySize.height / 2, // overlay center y
  );

  final Offset boundaryCenter =
      Offset(boundarySize.width / 2, boundarySize.height / 2);

  final bool isTopLeft = overlayCenter.dx < boundaryCenter.dx &&
      overlayCenter.dy < boundaryCenter.dy;
  final bool isTopRight = overlayCenter.dx > boundaryCenter.dx &&
      overlayCenter.dy < boundaryCenter.dy;
  final bool isBottomLeft = overlayCenter.dx < boundaryCenter.dx &&
      overlayCenter.dy > boundaryCenter.dy;
  final bool isBottomRight = overlayCenter.dx > boundaryCenter.dx &&
      overlayCenter.dy > boundaryCenter.dy;

  if (isTopLeft) return AnchoringSide.topLeft;
  if (isTopRight) return AnchoringSide.topRight;
  if (isBottomLeft) return AnchoringSide.bottomLeft;
  if (isBottomRight) return AnchoringSide.bottomRight;

  return AnchoringSide.topLeft;
}

Offset calculateAnchoringOffset(
    Offset overlayOffset,
    Size overlaySize,
    Size boundarySize,
    AnchoringSide anchoringSide,
    EdgeInsets safeAreaPadding) {
  // TODO screen orientation
  // TODO anchoring side
  // TODO safe area padding
  if (overlayOffset == Offset.zero) {
    overlayOffset = Offset(0, safeAreaPadding.top);
  }

  if (anchoringSide == AnchoringSide.topRight) {
    final double overlayOffsetX = boundarySize.width - overlaySize.width;
    print('---------------');
    print(overlayOffsetX);
    print(overlayOffset.dx);

    if (overlayOffsetX <= overlayOffset.dx) {}

    overlayOffset = Offset(overlayOffsetX, overlayOffset.dy);

    // final double remainingDistanceX =
    //     boundarySize.width - overlaySize.width - overlayOffset.dx;
    // final double remainingDistanceY = overlayOffset.dy - safeAreaPadding.top;
    // // if distance near to top boundary
    // if (remainingDistanceY < remainingDistanceX) {
    //   // move to top boundary in y direction
    //   final double updatedOffsetY = (1 - animationValue) * overlayOffset.dy;
    //   final double boundaryPadding = safeAreaPadding.top * animationValue;
    //   final double overlayOffsetY = updatedOffsetY + boundaryPadding;

    //   overlayOffset = Offset(overlayOffset.dx, overlayOffsetY);
    // } else
    // // if distance near to right boundary
    // {
    //   // move to right boundary in x direction
    //   final double remainingDX = animationValue * remainingDistanceX;
    //   final double overlayOffsetX = overlayOffset.dx + remainingDX;
    //   overlayOffset = Offset(overlayOffsetX, overlayOffset.dy);
    // }
  }

  return overlayOffset;
}

Offset animateToAnchoringSideBoundary(
  AnchoringSide anchoringSide,
  Offset overlayOffset,
  Size overlaySize,
  EdgeInsets safeAreaPadding,
  Size boundarySize,
  double animationValue,
) {
  if (anchoringSide == AnchoringSide.topLeft) {
    final double remainingDistanceY = overlayOffset.dy - safeAreaPadding.top;
    final double remainingDistanceX = overlayOffset.dx - safeAreaPadding.left;
    // if distance near to top boundary
    if (remainingDistanceY < remainingDistanceX) {
      // move to top boundary in y direction
      final double updatedOffsetY = (1 - animationValue) * overlayOffset.dy;
      final double boundaryPadding = safeAreaPadding.top * animationValue;
      final double overlayOffsetY = updatedOffsetY + boundaryPadding;

      overlayOffset = Offset(overlayOffset.dx, overlayOffsetY);
    } else
    // if distance near to left boundary
    {
      // move to left boundary in x direction
      final double updatedOffsetX = (1 - animationValue) * overlayOffset.dx;
      final double boundaryPadding = safeAreaPadding.left * animationValue;
      final double overlayOffsetX = updatedOffsetX + boundaryPadding;

      overlayOffset = Offset(overlayOffsetX, overlayOffset.dy);
    }
  }

  if (anchoringSide == AnchoringSide.topRight) {
    final double remainingDistanceX =
        boundarySize.width - overlaySize.width - overlayOffset.dx;
    final double remainingDistanceY = overlayOffset.dy - safeAreaPadding.top;
    // if distance near to top boundary
    if (remainingDistanceY < remainingDistanceX - safeAreaPadding.right) {
      // move to top boundary in y direction
      final double updatedOffsetY = (1 - animationValue) * overlayOffset.dy;
      final double boundaryPadding = safeAreaPadding.top * animationValue;
      final double overlayOffsetY = updatedOffsetY + boundaryPadding;

      overlayOffset = Offset(overlayOffset.dx, overlayOffsetY);
    } else
    // if distance near to right boundary
    {
      // move to right boundary in x direction
      final double remainingDX = animationValue * remainingDistanceX;
      final double boundaryPadding = safeAreaPadding.right * animationValue;
      final double overlayOffsetX =
          overlayOffset.dx + remainingDX - boundaryPadding;
      overlayOffset = Offset(overlayOffsetX, overlayOffset.dy);
    }
  }

  if (anchoringSide == AnchoringSide.bottomLeft) {
    final double remainingDistanceY =
        boundarySize.height - overlaySize.height - overlayOffset.dy;
    final double remainingDistanceX = overlayOffset.dx - safeAreaPadding.left;

    // if distance near to bottom boundary
    if (remainingDistanceY - safeAreaPadding.bottom < remainingDistanceX) {
      // move to bottom boundary in y direction
      final double remainingDY = animationValue * remainingDistanceY;
      final double boundaryPadding = safeAreaPadding.bottom * animationValue;
      final double overlayOffsetY =
          overlayOffset.dy + remainingDY - boundaryPadding;
      overlayOffset = Offset(overlayOffset.dx, overlayOffsetY);
    } else
    // if distance near to left boundary
    {
      // move to left boundary in x direction
      final double updatedOffsetX = (1 - animationValue) * overlayOffset.dx;
      final double boundaryPadding = safeAreaPadding.left * animationValue;
      final double overlayOffsetX = updatedOffsetX + boundaryPadding;

      overlayOffset = Offset(overlayOffsetX, overlayOffset.dy);
    }
  }

  if (anchoringSide == AnchoringSide.bottomRight) {
    double remainingDistanceY =
        boundarySize.height - overlaySize.height - overlayOffset.dy;
    double remainingDistanceX =
        boundarySize.width - overlaySize.width - overlayOffset.dx;

    // if distance near to bottom boundary
    if (remainingDistanceY - safeAreaPadding.bottom <
        remainingDistanceX - safeAreaPadding.right) {
      // move to bottom boundary in y direction
      final double remainingDY = animationValue * remainingDistanceY;
      final double boundaryPadding = safeAreaPadding.bottom * animationValue;
      final double overlayOffsetY =
          overlayOffset.dy + remainingDY - boundaryPadding;
      overlayOffset = Offset(overlayOffset.dx, overlayOffsetY);
    } else
    // if distance near to right boundary
    {
      // move to right boundary in x direction
      final double remainingDX = animationValue * remainingDistanceX;
      final double boundaryPadding = safeAreaPadding.right * animationValue;
      final double overlayOffsetX =
          overlayOffset.dx + remainingDX - boundaryPadding;
      overlayOffset = Offset(overlayOffsetX, overlayOffset.dy);
    }
  }

  return overlayOffset;
}

Offset animateToAnchoringSideCorner(
  AnchoringSide anchoringSide,
  Offset overlayOffset,
  Size overlaySize,
  EdgeInsets safeAreaPadding,
  Size boundarySize,
  double animationValue,
) {
  if (anchoringSide == AnchoringSide.topLeft) {
    // move to top boundary in y direction
    final double updatedOffsetY = (1 - animationValue) * overlayOffset.dy;
    final double boundaryPaddingY = safeAreaPadding.top * animationValue;
    final double overlayOffsetY = updatedOffsetY + boundaryPaddingY;

    // move to left boundary in x direction
    final double updatedOffsetX = (1 - animationValue) * overlayOffset.dx;
    final double boundaryPaddingX = safeAreaPadding.left * animationValue;
    final double overlayOffsetX = updatedOffsetX + boundaryPaddingX;

    overlayOffset = Offset(overlayOffsetX, overlayOffsetY);
  }

  if (anchoringSide == AnchoringSide.topRight) {
    final double remainingDistanceX =
        boundarySize.width - overlaySize.width - overlayOffset.dx;
    // move to top boundary in y direction
    final double updatedOffsetY = (1 - animationValue) * overlayOffset.dy;
    final double boundaryPaddingY = safeAreaPadding.top * animationValue;
    final double overlayOffsetY = updatedOffsetY + boundaryPaddingY;

    // move to right boundary in x direction
    final double remainingDX = animationValue * remainingDistanceX;
    final double boundaryPaddingX = safeAreaPadding.right * animationValue;
    final double overlayOffsetX =
        overlayOffset.dx + remainingDX - boundaryPaddingX;
    overlayOffset = Offset(overlayOffsetX, overlayOffsetY);
  }

  if (anchoringSide == AnchoringSide.bottomLeft) {
    final double remainingDistanceY =
        boundarySize.height - overlaySize.height - overlayOffset.dy;

    // move to bottom boundary in y direction
    final double remainingDY = animationValue * remainingDistanceY;
    final double boundaryPaddingY = safeAreaPadding.bottom * animationValue;
    final double overlayOffsetY =
        overlayOffset.dy + remainingDY - boundaryPaddingY;

    // move to left boundary in x direction
    final double updatedOffsetX = (1 - animationValue) * overlayOffset.dx;
    final double boundaryPaddingX = safeAreaPadding.left * animationValue;
    final double overlayOffsetX = updatedOffsetX + boundaryPaddingX;

    overlayOffset = Offset(overlayOffsetX, overlayOffsetY);
  }

  if (anchoringSide == AnchoringSide.bottomRight) {
    double remainingDistanceY =
        boundarySize.height - overlaySize.height - overlayOffset.dy;
    double remainingDistanceX =
        boundarySize.width - overlaySize.width - overlayOffset.dx;

    // move to bottom boundary in y direction
    final double remainingDY = animationValue * remainingDistanceY;
    final double boundaryPaddingY = safeAreaPadding.bottom * animationValue;
    final double overlayOffsetY =
        overlayOffset.dy + remainingDY - boundaryPaddingY;
    overlayOffset = Offset(overlayOffset.dx, overlayOffsetY);

    // move to right boundary in x direction
    final double remainingDX = animationValue * remainingDistanceX;
    final double boundaryPaddingX = safeAreaPadding.right * animationValue;
    final double overlayOffsetX =
        overlayOffset.dx + remainingDX - boundaryPaddingX;

    overlayOffset = Offset(overlayOffsetX, overlayOffsetY);
  }

  return overlayOffset;
}

Size getBoundarySize(BuildContext context) {
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;
  return Size(width, height);
}

bool get isMobile =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.android;

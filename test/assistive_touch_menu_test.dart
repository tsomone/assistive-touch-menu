import 'package:assistive_touch_menu/src/anchoring_side_enum.dart';
import 'package:assistive_touch_menu/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Anchroring side', () {
    test('should be top left when default', () {
      Size overlaySize = const Size(50, 50);
      Size boundarySize = const Size(375, 812);
      Offset offset = Offset.zero;

      AnchoringSide anchoringSide =
          calculateAnchoringSide(offset, overlaySize, boundarySize);

      expect(anchoringSide, AnchoringSide.topLeft);
    });

    test('should be top left', () {
      Size overlaySize = const Size(50, 50);
      Offset offset = const Offset(50, 50);
      Size boundarySize = const Size(375, 812);

      AnchoringSide anchoringSide =
          calculateAnchoringSide(offset, overlaySize, boundarySize);

      expect(anchoringSide, AnchoringSide.topLeft);
    });

    test('should be top right', () {
      Size overlaySize = const Size(50, 50);
      Offset offset = const Offset(200, 50);
      Size boundarySize = const Size(375, 812);

      AnchoringSide anchoringSide =
          calculateAnchoringSide(offset, overlaySize, boundarySize);

      expect(anchoringSide, AnchoringSide.topRight);
    });

    test('should be bottom left', () {
      Size overlaySize = const Size(50, 50);
      Offset offset = const Offset(50, 450);
      Size boundarySize = const Size(375, 812);

      AnchoringSide anchoringSide =
          calculateAnchoringSide(offset, overlaySize, boundarySize);

      expect(anchoringSide, AnchoringSide.bottomLeft);
    });

    test('should be bottom right', () {
      Size overlaySize = const Size(50, 50);
      Offset offset = const Offset(200, 450);
      Size boundarySize = const Size(375, 812);

      AnchoringSide anchoringSide =
          calculateAnchoringSide(offset, overlaySize, boundarySize);

      expect(anchoringSide, AnchoringSide.bottomRight);
    });
  });
}

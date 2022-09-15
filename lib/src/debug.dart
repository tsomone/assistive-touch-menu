import 'package:assistive_touch_menu/assistive_touch_menu.dart';
import 'package:flutter/widgets.dart';

/// Asserts that the given context has a [AssistiveTouchMenu] ancestor.
///
/// Used by various widgets to make sure that they are only used in an
/// appropriate context.
///
/// To invoke this function, use the following pattern, typically in the
/// relevant Widget's build method:
///
/// ```dart
/// assert(debugCheckHasAssistiveTouchMenu(context));
/// ```
///
/// This method can be expensive (it walks the element tree).
///
/// Does nothing if asserts are disabled. Always returns true.
bool debugCheckHasAssistiveTouchMenu(BuildContext context) {
  assert(() {
    if (context.findAncestorWidgetOfExactType<AssistiveTouchMenu>() == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('No AssistiveTouchMenu widget found.'),
        ErrorDescription(
            '${context.widget.runtimeType} widgets require a AssistiveTouchMenu widget ancestor.'),
        ...context.describeMissingAncestor(
          expectedAncestorType: AssistiveTouchMenu,
        ),
      ]);
    }
    return true;
  }());
  return true;
}

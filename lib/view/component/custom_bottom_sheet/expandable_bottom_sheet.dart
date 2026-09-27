import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A bottom sheet that initially takes only the space its content needs.
///
/// If the content is taller than [maxHeightFactor], it becomes scrollable. The
/// drag handle can then be used to resize the sheet between [collapseHeight]
/// and the available maximum height.
class ExpandableBottomSheet extends StatefulWidget {
  final double collapseHeight;
  final double maxHeightFactor;
  final Widget child;
  final VoidCallback? onClose;

  const ExpandableBottomSheet({
    super.key,
    this.collapseHeight = 80,
    this.maxHeightFactor = 0.9,
    required this.child,
    this.onClose,
  }) : assert(maxHeightFactor > 0 && maxHeightFactor <= 1);

  @override
  State<ExpandableBottomSheet> createState() => _ExpandableBottomSheetState();
}

class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
  static const double _dragHandleHeight = 40;

  final GlobalKey _sheetKey = GlobalKey();
  double? _currentHeight;

  double _maximumHeight(BoxConstraints constraints) {
    return constraints.maxHeight * widget.maxHeightFactor;
  }

  void _onDragStart(DragStartDetails details) {
    final renderedHeight = _sheetKey.currentContext?.size?.height;
    if (renderedHeight != null) {
      _currentHeight = renderedHeight;
    }
  }

  void _onDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final renderedHeight = _sheetKey.currentContext?.size?.height;
    final startingHeight = _currentHeight ?? renderedHeight;
    if (startingHeight == null) return;

    final maximumHeight = _maximumHeight(constraints);
    final minimumHeight = math.min(widget.collapseHeight, maximumHeight);

    setState(() {
      _currentHeight = (startingHeight - details.delta.dy).clamp(
        minimumHeight,
        maximumHeight,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maximumHeight = _maximumHeight(constraints);
        final minimumHeight = math.min(widget.collapseHeight, maximumHeight);
        final sheetHeight = _currentHeight?.clamp(minimumHeight, maximumHeight);

        return Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            key: _sheetKey,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            height: sheetHeight,
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: maximumHeight),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragStart: _onDragStart,
                  onVerticalDragUpdate: (details) =>
                      _onDragUpdate(details, constraints),
                  child: SizedBox(
                    height: _dragHandleHeight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 6,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        if (widget.onClose != null)
                          Positioned(
                            right: 12,
                            child: IconButton(
                              onPressed: widget.onClose,
                              icon: const Icon(Icons.close),
                              tooltip: MaterialLocalizations.of(
                                context,
                              ).closeButtonTooltip,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

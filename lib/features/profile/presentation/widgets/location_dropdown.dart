import 'package:flutter/material.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'dart:math' as math;

class LocationDropdown extends StatefulWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String> onChanged;

  const LocationDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  State<LocationDropdown> createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _targetKey = GlobalKey();
  OverlayEntry? _entry;
  late final AnimationController _controller;

  bool get _isOpen => _entry != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
  }

  @override
  void didUpdateWidget(covariant LocationDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggle() => _isOpen ? _removeOverlay() : _showOverlay();

  void _showOverlay() {
    final overlay = Overlay.of(context);
    _entry = _createOverlayEntry();
    overlay.insert(_entry!);
    _controller.forward(from: 0);
  }

  void _removeOverlay() {
    if (_entry == null) return;
    _controller.reverse();
    _entry?.remove();
    _entry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final box = _targetKey.currentContext!.findRenderObject() as RenderBox;
    final size = box.size;
    final screenHeight = MediaQuery.of(context).size.height;
    // точка, где начинается меню (под полем + отступ)
    final overlayTop = box.localToGlobal(Offset.zero).dy + size.height + 8;
    // доступная высота до низа экрана с небольшим запасом
    final availableHeight = math.max(0.0, screenHeight - overlayTop - 8);

    // Высота выпадашки — не больше 35% экрана и не больше доступной
    final maxHeight = math.min(screenHeight * 0.35, availableHeight);

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
              ),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 8),
                child: Material(
                  color: Colors.transparent,
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeOut,
                    ),
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.98, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeOut,
                        ),
                      ),
                      alignment: Alignment.topCenter,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 20,
                              offset: Offset(0, 10),
                              color: Color(0x22000000),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: maxHeight),
                                  child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    shrinkWrap: true,
                                    itemCount: widget.items.length,
                                    separatorBuilder: (_, __) => const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0xFFE9E9E9),
                                    ),
                                    itemBuilder: (context, i) {
                                      final item = widget.items[i];
                                      final isSelected = item == widget.value;

                                      return InkWell(
                                        onTap: () {
                                          widget.onChanged(item);
                                          _removeOverlay();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item,
                                                  style: AppTextStyles.labelL1,
                                                ),
                                              ),
                                              if (isSelected)
                                                const Icon(
                                                  Icons.check,
                                                  size: 22,
                                                  color: Color(0xFF2F6BFF),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            key: _targetKey,
            onTap: _toggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE6E6E6)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      (widget.value ?? '').isEmpty
                          ? 'Select location'
                          : (widget.value ?? ''),
                      style: AppTextStyles.inputText,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 160),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 28,
                      color: Color(0xFF2F6BFF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


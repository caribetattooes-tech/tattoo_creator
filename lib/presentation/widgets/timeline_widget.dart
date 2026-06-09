import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class TimelineWidget extends StatefulWidget {
  final List<TimelineClip> clips;
  final double duration;
  final double currentPosition;
  final Function(double)? onSeek;
  final Function(int)? onClipTap;

  const TimelineWidget({
    super.key,
    required this.clips,
    required this.duration,
    this.currentPosition = 0,
    this.onSeek,
    this.onClipTap,
  });

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  double _scale = 1.0;
  double _scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.surfaceLight),
          bottom: BorderSide(color: AppColors.surfaceLight),
        ),
      ),
      child: Column(
        children: [
          // Timeline header
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Línea de tiempo',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _scale = (_scale - 0.2).clamp(0.5, 3.0)),
                      icon: const Icon(Icons.remove, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(_scale * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => setState(() => _scale = (_scale + 0.2).clamp(0.5, 3.0)),
                      icon: const Icon(Icons.add, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Timeline content
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _scrollOffset += details.delta.dx;
                  _scrollOffset = _scrollOffset.clamp(-500.0, 500.0);
                });
              },
              child: Stack(
                children: [
                  // Clips
                  Positioned(
                    left: 50 + _scrollOffset,
                    top: 10,
                    right: 50,
                    bottom: 10,
                    child: Row(
                      children: widget.clips.asMap().entries.map((entry) {
                        final index = entry.key;
                        final clip = entry.value;
                        return GestureDetector(
                          onTap: () => widget.onClipTap?.call(index),
                          child: Container(
                            width: 80 * _scale,
                            height: 60,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    'Clip ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      '${clip.duration.inSeconds}s',
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Playhead
                  Positioned(
                    left: 45 + (_scale * 50) + (widget.currentPosition * _scale),
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  // Time markers
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      height: 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(11, (index) {
                          return Text(
                            '${index}s',
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.textHint,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineClip {
  final String id;
  final Duration duration;
  final Color color;

  const TimelineClip({
    required this.id,
    required this.duration,
    this.color = AppColors.cardBackground,
  });
}
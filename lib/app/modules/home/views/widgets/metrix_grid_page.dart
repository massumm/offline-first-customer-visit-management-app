
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'fitness_dashboard_widgets/heart_rate_card_widget.dart';
import 'fitness_dashboard_widgets/hydration_card.dart';
import 'fitness_dashboard_widgets/steps_card.dart';
import 'health_dashboard_widgets/health_deshboard_widget.dart';


class GridItem {
  final String title;
  final Color color;
  final int heightCells;
  final int widthCells; // new: how many columns to span
  GridItem(this.title, this.color, this.heightCells, [this.widthCells = 1]);
}

class MetricsGridPage extends StatefulWidget {
  // You can add parameters here for customization, e.g. items, editMode, etc.
  const MetricsGridPage({super.key});

  @override
  State<MetricsGridPage> createState() => _MetricsGridPageState();
}

class _MetricsGridPageState extends State<MetricsGridPage> {
  List<GridItem> items = [
    GridItem("Steps", Colors.red.shade300, 2, 1), // spans 2 columns
    GridItem("Hydration", Colors.blue.shade300, 1, 1),
    GridItem("Heart Rate", Colors.green.shade300, 1, 1),
    GridItem("Calories", Colors.orange.shade300, 1, 1), // spans 2 columns
    GridItem("Sleep", Colors.purple.shade300, 2, 1),
    GridItem("Protein", Colors.teal.shade300, 1, 1),
  ];

  int crossAxisCount = 2;
  double spacing = 12;
  double baseCellHeight = 100;

  bool isEditMode = false;

  int? draggingIndex;
  Offset? dragOffset;

  void enterEditMode() {
    if (!isEditMode) {
      setState(() => isEditMode = true);
    }
  }

  void exitEditMode() {
    if (isEditMode) {
      setState(() => isEditMode = false);
    }
  }

  void addMetric() {
    final next = items.length + 1;
    final tall = next % 4 == 0;

    setState(() {
      items.add(
        GridItem(
          "Metric $next",
          Colors.primaries[next % Colors.primaries.length].shade300,
          tall ? 2 : 1,
        ),
      );
    });
  }

  void swapItems(int from, int to) {
    if (from == to) return;
    setState(() {
      final item = items.removeAt(from);
      items.insert(to, item);
    });
  }

  double tileHeight(int h) => baseCellHeight * h + spacing * (h - 1);

  double tileWidth(BuildContext context) {
    final totalPad = 12 * 2;
    final spacingTotal = spacing * (crossAxisCount - 1);
    final width = MediaQuery.of(context).size.width;
    return (width - totalPad - spacingTotal) / crossAxisCount;
  }

// ... existing code from _MetricsGridPageState ...

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => exitEditMode(),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          if (isEditMode)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "Add" button
                  GestureDetector(
                    onTap: addMetric,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                    ),
                  ),
                  // "Done" button
                  TextButton(
                    onPressed: () => exitEditMode(),
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text("Done"),
                  ),
                ],
              ),
            ),
          // The grid or empty state
          if (items.isEmpty && !isEditMode)
            _buildEmptyStateCard()
          else
            Padding(
              padding: const EdgeInsets.all(12),
              child: MasonryGridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return buildDragTile(item, index, context);
                },
              ),
            ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Empty State Card
  Widget _buildEmptyStateCard() {
    return GestureDetector(
      onTap: enterEditMode,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dashboard_customize_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              "Customize Your Health Board",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap here to add your first metric and start tracking.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Calories Card
  Widget _caloriesCard() {
    return _card(
      borderColor: const Color(0xff098C26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Calories",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              const Text(
                "1,420",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                "kcal",
                style: TextStyle(
                  color: Color(0xff098C26),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // const Spacer(),
              // Expanded(
              //   child: CircularPercentIndicator(
              //     radius: 18,
              //     lineWidth: 2,
              //     percent: 0.72,
              //     progressColor: const Color(0xff098C26),
              //     backgroundColor: const Color(0xffEBFFF0),
              //     center: const Text(
              //       "72%",
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
            ],
          ),
          const Row(
            children: [
              Icon(Icons.restaurant_menu, color: Colors.orange, size: 16),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  "Stay fueled — Dinner planned 600 kcal.",
                  maxLines: 2,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Protein Card
  Widget _proteinCard([double progress = 0.57]) {
    const cardColor = Color(0xff098C26);
    final screenWidth = MediaQuery.of(context).size.width;

    final double gaugeWidth = screenWidth * 0.16;
    final double gaugeHeight = gaugeWidth / 2;
    final double fontSize = screenWidth * 0.036;

    return _card(
      borderColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Protein",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "On track!",
                      style: TextStyle(
                        color: cardColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CustomPaint(
                  painter: GaugePainter(progress),
                  child: SizedBox(
                    width: gaugeWidth,
                    height: gaugeHeight,
                    child: Center(
                      child: Text(
                        "${(progress * 100).round()}%",
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Sleep Card
  Widget _sleepCard() {
    return _card(
      borderColor: const Color(0xff0064A7),
      child: SizedBox(
        height: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sleep",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Text(
              "7h 20m",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "Last Night",
              style: TextStyle(
                color: Color(0xff0064A7),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Row(
              children: [
                Icon(Icons.bedtime, color: Colors.grey, size: 16),
                SizedBox(width: 4),
                Text("Bedtime: 11:15 PM", style: TextStyle(fontSize: 10)),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.wb_sunny, color: Colors.orange, size: 16),
                SizedBox(width: 4),
                Text("Wake-up:  6:35 AM", style: TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Shared Card UI
  Widget _card({required Widget child, required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withAlpha(13),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget buildDragTile(GridItem item, int index, BuildContext context) {
    final tile = buildTile(item);

    // When not in edit mode, just show the tile with a long-press gesture
    // to enter edit mode.
    if (!isEditMode) {
      return GestureDetector(onLongPress: enterEditMode, child: tile);
    }

    // In edit mode, wrap the tile in a Stack to add a delete button.
    final editableTile = Stack(
      clipBehavior: Clip.none,
      children: [
        tile,
        Positioned(
          top: -8,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                items.removeAt(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(Icons.remove, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );

    // In edit mode, make the tile draggable for reordering.
    return LongPressDraggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: buildTile(
          item,
          isFeedback: true,
          feedbackWidth: tileWidth(context),
          feedbackHeight: tileHeight(item.heightCells),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: tile),
      onDragStarted: () => setState(() => draggingIndex = index),
      onDragUpdate: (d) => setState(() => dragOffset = d.globalPosition),
      onDragEnd: (d) {
        // Simplified: just reset dragging state. Deletion is handled by the icon.
        setState(() {
          draggingIndex = null;
          dragOffset = null;
        });
      },
      child: DragTarget<int>(
        onWillAcceptWithDetails: (d) => d.data != index,
        onAcceptWithDetails: (d) => swapItems(d.data, index),
        builder: (_, _, _) => editableTile,
      ),
    );
  }

  Widget buildTile(
    GridItem item, {
    bool isFeedback = false,
    double? feedbackWidth,
    double? feedbackHeight,
  }) {
    double width = feedbackWidth ?? tileWidth(context);
    // FIX: Calculate height consistently, regardless of feedback state.
    double height = feedbackHeight ?? tileHeight(item.heightCells);

    // The user's original width adjustments are preserved.
    if (item.heightCells == 1) {
      width *= 1.5;
    } else if (item.heightCells == 2) {
      width *= 0.85;
    }

    // The specific card widgets below have their own intrinsic height,
    // so they don't need an explicit height set on the SizedBox.
    if (item.title == "Steps") {
      return SizedBox(width: width, child: const StepsCard());
    }
    if (item.title == "Hydration") {
      return SizedBox(
        width: width,
        child: HydrationWaveProvider(
          child: HydrationCard(onAddWater: () {}, remainingLiters: 3.5),
        ),
      );
    }
    if (item.title == "Heart Rate") {
      return SizedBox(width: width, child: const HeartRateCard());
    }
    if (item.title == "Calories") {
      return SizedBox(width: width, child: _caloriesCard());
    }
    if (item.title == "Protein") {
      // Pass the context to _proteinCard for responsive sizing.
      return SizedBox(width: width, child: _proteinCard());
    }
    if (item.title == "Sleep") {
      return SizedBox(width: width, child: _sleepCard());
    }

    // This is the fallback tile for generic items like "Metric 7".
    final tile = Container(
      width: width,
      // FIX: Apply the calculated height here.
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            item.heightCells == 2 ? "Tall" : "Short",
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );

    if (isFeedback) {
      return Transform.scale(scale: 1.05, child: tile);
    }

    return tile;
  }
}

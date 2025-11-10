import 'package:flutter/material.dart';
import 'package:icon/generated/assets.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

class MuscleHeatMapCard extends StatefulWidget {
  const MuscleHeatMapCard({super.key});
  @override
  State<MuscleHeatMapCard> createState() => _MuscleHeatMapCardState();
}

class _MuscleHeatMapCardState extends State<MuscleHeatMapCard> {
  bool _expanded = true;

  Map<String, Color> frontHighlights = {
    'abs': const Color(0xFFF59E0B),
    'chest': const Color(0xFF7C3AED),
    'quad_left': const Color(0xFFEF4444),
    'quad_right': const Color(0xFFEF4444),
  };

  Map<String, Color> backHighlights = {
    'deltoid_l': const Color(0xFF2563EB),
    'deltoid_r': const Color(0xFF2563EB),
  };

  final _statuses = const [
    _MuscleStatus(name: 'Abs', daysAgo: 2, color: Color(0xFFF59E0B)),
    _MuscleStatus(name: 'Shoulders', daysAgo: 4, color: Color(0xFF2563EB)),
    _MuscleStatus(name: 'Chest', daysAgo: 5, color: Color(0xFF7C3AED)),
    _MuscleStatus(name: 'Quadriceps', daysAgo: 5, color: Color(0xFFEF4444)),
  ];

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(18);

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: cardRadius),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: cardRadius,
          border: Border.all(color: const Color(0x11000000)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header (tap to collapse/expand)
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Muscle Heat Map',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Track which muscles need attention',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: _expanded ? 0.5 : 0,
                        child: Icon(Icons.expand_more, color: Colors.black87, size: 22),
                      ),
                    ],
                  ),
                ),
              ),

              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _expanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Figures
                    Row(
                      children: [
                        Expanded(
                          child: _DynamicFigureCard(
                            asset: Assets.musclesFront,
                            colorsById: frontHighlights,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DynamicFigureCard(
                            asset: Assets.musclesBack,
                            colorsById: backHighlights,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _StatusPanel(statuses: _statuses),
                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: () {
                        setState(() {
                          // swap colors to show dynamic update
                          frontHighlights = {
                            'abs': const Color(0xFF10B981),
                            'chest': const Color(0xFFDC2626),
                            'quad_left': const Color(0xFF3B82F6),
                            'quad_right': const Color(0xFF3B82F6),
                          };
                          backHighlights = {
                            'deltoid_l': const Color(0xFF9333EA),
                            'deltoid_r': const Color(0xFF9333EA),
                          };
                        });
                      },
                      child: const Text('Randomize highlights'),
                    ),
                  ],
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DynamicFigureCard extends StatelessWidget {
  final String asset;
  final Map<String, Color> colorsById; // id -> color

  // Remove 'const' and add 'super.key'
  const _DynamicFigureCard({required this.asset, required this.colorsById});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x11000000)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _DynamicSvg(asset: asset, colorsById: colorsById),
        ),
      ),
    );
  }
}


class _DynamicSvg extends StatefulWidget {
  final String asset;
  final Map<String, Color> colorsById;

  const _DynamicSvg({required this.asset, required this.colorsById});

  @override
  State<_DynamicSvg> createState() => _DynamicSvgState();
}

class _DynamicSvgState extends State<_DynamicSvg> {
  late Future<String> _svgFuture;

  @override
  void initState() {
    super.initState();
    // Load the SVG asset once when the widget is first created.
    _svgFuture = rootBundle.loadString(widget.asset);
  }

  @override
  void didUpdateWidget(covariant _DynamicSvg oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the asset path itself changes, we need to load the new SVG.
    if (widget.asset != oldWidget.asset) {
      _svgFuture = rootBundle.loadString(widget.asset);
    }
    // When only colorsById changes, we don't need to do anything here.
    // The build method will be called automatically and will use the new
    // widget.colorsById to re-apply the colors.
  }

  @override
  Widget build(BuildContext context) {
    // Use the future from the state, which is not recreated on every build.
    return FutureBuilder<String>(
      future: _svgFuture,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        // The builder correctly uses the latest colors from the widget property
        // and applies them to the original SVG data.
        final updated = _applyColorsToSvg(snap.data!, widget.colorsById);
        return SvgPicture.string(updated, fit: BoxFit.contain);
      },
    );
  }

  String _applyColorsToSvg(String svg, Map<String, Color> colors) {
    final doc = xml.XmlDocument.parse(svg);

    void setFill(xml.XmlElement el, Color c) {
      final hex = _hexRgb(c);
      // Handle style="fill:#xxxxxx; ..." or add a fill attribute
      final styleAttr = el.getAttributeNode('style');
      if (styleAttr != null && styleAttr.value.contains('fill:')) {
        styleAttr.value = styleAttr.value.replaceAll(
          RegExp(r'fill\s*:\s*#[0-9a-fA-F]{3,8}'),
          'fill:$hex',
        );
      } else {
        final existing = el.getAttributeNode('fill');
        if (existing != null) {
          existing.value = hex;
        } else {
          el.attributes.add(xml.XmlAttribute(xml.XmlName('fill'), hex));
        }
      }

      // Respect alpha via fill-opacity if not fully opaque
      final opacity = (c.alpha / 255.0);
      final fo = el.getAttributeNode('fill-opacity');
      if (opacity < 1.0) {
        if (fo != null) {
          fo.value = opacity.toStringAsFixed(3);
        } else {
          el.attributes.add(
            xml.XmlAttribute(
              xml.XmlName('fill-opacity'),
              opacity.toStringAsFixed(3),
            ),
          );
        }
      } else {
        // Remove fill-opacity if present and not needed
        if (fo != null) el.attributes.remove(fo);
      }
    }

    // For each id -> color, locate that element and set fill (and its children)
    colors.forEach((id, color) {
      final matches = doc
          .findAllElements('*')
          .where((e) => e.getAttribute('id') == id)
          .toList();
      for (final node in matches) {
        setFill(node, color);
        // If it's a group, color all child paths unless they already override
        for (final child in node.findAllElements('path')) {
          setFill(child, color);
        }
      }
    });

    return doc.toXmlString(pretty: false);
  }

  // #RRGGBB (ignore alpha here; we push alpha into fill-opacity)
  String _hexRgb(Color c) =>
      '#${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}';
}


class _StatusPanel extends StatelessWidget {
  final List<_MuscleStatus> statuses;
  const _StatusPanel({required this.statuses});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Muscle Status',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            for (final s in statuses) _StatusTile(status: s),
          ],
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final _MuscleStatus status;
  const _StatusTile({required this.status});
  String _ago(int days) => '${days}d ago';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              status.name,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF111827),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            _ago(status.daysAgo),
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          const SizedBox(width: 8),
          _Dot(color: status.color),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class _MuscleStatus {
  final String name;
  final int daysAgo;
  final Color color;
  const _MuscleStatus({
    required this.name,
    required this.daysAgo,
    required this.color,
  });
}
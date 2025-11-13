import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




/// Suggestion item model
class LocationSuggestion {
  final String id; // Google place_id
  final String primaryText; // full description
  final String? secondaryText; // optional subtitle

  const LocationSuggestion({
    required this.id,
    required this.primaryText,
    this.secondaryText,
  });
}

class GooglePlacesService {
  GooglePlacesService({required this.apiKey, Dio? dio})
      : _dio =
      dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://maps.googleapis.com',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
            ),
          );

  final String apiKey;
  final Dio _dio;

  Future<List<LocationSuggestion>> autocomplete(
      String input, {
        String? language,
        String? countryBias,
      }) async {
    final res = await _dio.get(
      '/maps/api/place/autocomplete/json',
      queryParameters: <String, String?>{
        'input': input,
        if (language != null) 'language': language,
        if (countryBias != null) 'components': 'country:$countryBias',
        'types': 'geocode',
        'key': apiKey,
      },
    );

    final data = res.data is Map<String, dynamic>
        ? res.data as Map<String, dynamic>
        : (res.data is String
        ? json.decode(res.data as String) as Map<String, dynamic>
        : <String, dynamic>{});

    final status = data['status'] as String?;
    if (status != 'OK' && status != 'ZERO_RESULTS') {
      final errMsg = data['error_message'] ?? status ?? 'Unknown error';
      throw Exception('Places error: $errMsg');
    }
    final predictions = (data['predictions'] as List?) ?? const [];
    return predictions
        .map<LocationSuggestion>((p) {
      return LocationSuggestion(
        id: p['place_id'] as String,
        primaryText: p['description'] as String,
        secondaryText:
        (p['structured_formatting']?['secondary_text'] as String?) ??
            '',
      );
    })
        .toList(growable: false);
  }

  Future<PlaceDetails?> placeDetails(String placeId) async {
    final res = await _dio.get(
      '/maps/api/place/details/json',
      queryParameters: <String, String>{
        'place_id': placeId,
        'fields': 'geometry/location,name,formatted_address',
        'key': "AIzaSyAKyeZuBoMyWihoLPGe2VOAklRvLHaqQMs",
      },
    );

    final data = res.data is Map<String, dynamic>
        ? res.data as Map<String, dynamic>
        : (res.data is String
        ? json.decode(res.data as String) as Map<String, dynamic>
        : <String, dynamic>{});
    if (data['status'] != 'OK') return null;
    final result = data['result'] as Map<String, dynamic>;
    final loc = result['geometry']?['location'] as Map<String, dynamic>?;
    return PlaceDetails(
      name: result['name'] as String?,
      address: result['formatted_address'] as String?,
      lat: (loc?['lat'] as num?)?.toDouble(),
      lng: (loc?['lng'] as num?)?.toDouble(),
    );
  }
}

class PlaceDetails {
  final String? name;
  final String? address;
  final double? lat;
  final double? lng;
  const PlaceDetails({this.name, this.address, this.lat, this.lng});
}

class SearchableLocationDropdown extends StatefulWidget {
  const SearchableLocationDropdown({
    super.key,
    required this.fetchSuggestions,
    this.onChanged,
    this.hintText,
    this.decoration,
    this.initialValue,
    this.enabled = true,
    this.debounce = const Duration(milliseconds: 300),
    this.overlayMaxHeight = 280,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
  });

  final Future<List<LocationSuggestion>> Function(String query)
  fetchSuggestions;
  final void Function(LocationSuggestion? value)? onChanged;
  final String? hintText;
  final InputDecoration? decoration;
  final LocationSuggestion? initialValue;
  final bool enabled;
  final Duration debounce;
  final double overlayMaxHeight;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  @override
  State<SearchableLocationDropdown> createState() =>
      _SearchableLocationDropdownState();
}

class _SearchableLocationDropdownState
    extends State<SearchableLocationDropdown> {
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  Timer? _debounceTimer;

  List<LocationSuggestion> _items = const [];
  bool _isLoading = false;
  Object? _lastError;
  int _highlightIndex = -1; // for keyboard navigation

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!.primaryText;
    }
    _focusNode.addListener(_handleFocus);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _removeOverlay();
    _focusNode.removeListener(_handleFocus);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocus() {
    if (_focusNode.hasFocus) {
      _maybeShowOverlay();
      _runSearch(_controller.text);
    } else {
      _removeOverlay();
    }
    setState(() {});
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounce, () => _runSearch(value));
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
  }

  Future<void> _runSearch(String query) async {
    setState(() {
      _isLoading = true;
      _lastError = null;
    });
    try {
      final items = await widget.fetchSuggestions(query);
      setState(() {
        _items = items;
        _highlightIndex = items.isNotEmpty ? 0 : -1;
      });
    } catch (e) {
      setState(() {
        _lastError = e;
        _items = const [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      _rebuildOverlay();
    }
  }

  void _maybeShowOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = OverlayEntry(builder: (context) => _buildOverlay(context));
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _rebuildOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _select(LocationSuggestion? item) {
    if (item != null) {
      _controller.text = item.primaryText;
    }
    widget.onChanged?.call(item);
    _focusNode.unfocus();
  }

  void _onKeyDown(RawKeyEvent e) {
    if (e.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      setState(
            () =>
        _highlightIndex = (_highlightIndex + 1).clamp(0, _items.length - 1),
      );
      _rebuildOverlay();
    } else if (e.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      setState(
            () =>
        _highlightIndex = (_highlightIndex - 1).clamp(0, _items.length - 1),
      );
      _rebuildOverlay();
    } else if (e.isKeyPressed(LogicalKeyboardKey.enter)) {
      if (_items.isNotEmpty && _highlightIndex >= 0) {
        _select(_items[_highlightIndex]);
      }
    } else if (e.isKeyPressed(LogicalKeyboardKey.escape)) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = (widget.decoration ?? const InputDecoration())
        .copyWith(
      hintText: widget.hintText,
      suffixIcon: _controller.text.isEmpty
          ? const Icon(Icons.search)
          : IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _controller.clear();
          _onChanged('');
          _select(null);
        },
      ),
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: _onKeyDown,
        child: KeyedSubtree(
          key: _fieldKey,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            onChanged: _onChanged,
            decoration: inputDecoration,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    if (!_focusNode.hasFocus) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final double width =
        (_fieldKey.currentContext?.findRenderObject() as RenderBox?)
            ?.size
            .width ??
            360;

    Widget content;
    if (_isLoading) {
      content =
          widget.loadingBuilder?.call(context) ??
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
    } else if (_lastError != null) {
      content =
          widget.errorBuilder?.call(context, _lastError!) ??
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: $_lastError'),
              );
    } else if (_items.isEmpty) {
      content =
          widget.emptyBuilder?.call(context) ??
              const Padding(padding: EdgeInsets.all(16), child: Text('No results'));
    } else {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.overlayMaxHeight),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final item = _items[i];
            final selected = i == _highlightIndex;
            return Material(
              color: selected
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surface,
              child: InkWell(
                onTap: () => _select(item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.primaryText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      if ((item.secondaryText ?? '').isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            item.secondaryText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Stack(
          children: [
            // Dismiss when tapping outside
            GestureDetector(onTap: () => _focusNode.unfocus()),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 52),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(width: width, child: content),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

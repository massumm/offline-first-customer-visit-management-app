import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    required this.onInputChanged,
    this.suffixIcon = const SizedBox.shrink(),
  });

  final void Function(PhoneNumber) onInputChanged;
  final Widget suffixIcon;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late final PhoneController _controller;
  IsoCode? _defaultIso; // resolved from GPS → locale

  @override
  void initState() {
    super.initState();
    _controller = PhoneController();
    _initDefaultCountry();
  }

  Future<void> _initDefaultCountry() async {
    // start with device locale
    String iso = ui.PlatformDispatcher.instance.locale.countryCode ?? 'US';
    //
    try {
      // try GPS → reverse geocode to ISO
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm != LocationPermission.denied &&
          perm != LocationPermission.deniedForever) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );
        final placemarks = await placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
        );
        final locIso = placemarks.isNotEmpty
            ? placemarks.first.isoCountryCode
            : null;
        if (locIso != null && locIso.isNotEmpty) {
          iso = locIso.toUpperCase();
        }
      }
    } catch (e) {
      "Error getting locations data: $e".log();
    }

    final resolved = IsoCode.fromJson(iso);

    //  Seed the controller instead of using initialValue
    _controller.value = PhoneNumber(isoCode: resolved, nsn: '');

    // Rebuild so the flag/dial code shows immediately
    setState(() => _defaultIso = resolved);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_defaultIso == null) {
      return const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return PhoneFormField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'e.g. +${_controller.value.countryCode} 1234',
        suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      keyboardType: TextInputType.phone,
      isCountryButtonPersistent: true,
      countrySelectorNavigator: const CountrySelectorNavigator.bottomSheet(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: PhoneValidator.valid(context),
      onChanged: widget.onInputChanged,
    );
  }
}

import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';

import '../../../core/widgets/search_location_dropdown.dart';

class LocationService {
  static const String kGoogleApiKey = 'AIzaSyAKyeZuBoMyWihoLPGe2VOAklRvLHaqQMs';
  late final GooglePlacesService places = GooglePlacesService(
    apiKey: kGoogleApiKey,
  );

  TraineeOnboardingController? _controller;

  void attach(TraineeOnboardingController c) {
    _controller = c;
  }

  void detach() {
    _controller = null;
  }

  Future<List<LocationSuggestion>> placesAutocomplete(String query) async {
    if (query.trim().isEmpty) return [];
    return places.autocomplete(query, language: 'en');
  }
}

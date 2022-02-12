import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oxon_app/models/geocoded_location.dart';

class MapsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/geocode/json?';

  final Dio _dio;

  static const googleAPIKey = "AIzaSyCcywbZyeAkGWf3qkJ-Tc1e_58d7oQVvaE";

  MapsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<GeoCodedLocation?> convertLatLngToGeoCodedLoc(
    LatLng location,
  ) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'latlng': '${location.latitude},${location.longitude}',
        'key': googleAPIKey,
      },
    );

    if (response.statusCode == 200) {
      return GeoCodedLocation.fromMap(response.data);
    }
    return null;
  }
}

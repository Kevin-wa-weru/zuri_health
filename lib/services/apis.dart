import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:zuri_health/models/hospital.dart';
import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;

class ZuriApis {
  Future<Map<String, dynamic>> fetchNearbyHospitals({
    required double latitude,
    required double longitude,
    required int radius,
  }) async {
    const apiKey = 'AIzaSyBJ2v4ihgPsuKpvy54SAw5Yti8BrUz4Frg';

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=hospital&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final List<dynamic> results = data['results'];
        final List<Future<Hospital>> futures = [];
        for (var hospitalData in results) {
          final name = hospitalData['name'];
          final lat = hospitalData['geometry']['location']['lat'];
          final lng = hospitalData['geometry']['location']['lng'];
          final placeId = hospitalData['place_id'];

          futures.add(_fetchHospitalDetails(
              name, latitude, longitude, lat, lng, placeId));
        }

        final List<Hospital> fetchedHospitals = await Future.wait(futures);

        fetchedHospitals.sort((a, b) => a.distance.compareTo(b.distance));

        return {'message': 'ok', 'hospitals': fetchedHospitals};
      } else {
        return {'message': 'No hopitals found', 'hospitals': []};
      }
    } catch (e) {
      return {
        'message': 'Failed to get hospitals. Make sure your connection is okay',
        'hospitals': [],
      };
    }
  }

  Future<Map<String, dynamic>> filterService(
      {required double latitude,
      required double longitude,
      required int radius,
      required String serviceFilter}) async {
    const apiKey = 'AIzaSyBJ2v4ihgPsuKpvy54SAw5Yti8BrUz4Frg';

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&keyword=$serviceFilter&type=hospital&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final List<dynamic> results = data['results'];
        final List<Future<Hospital>> futures = [];
        for (var hospitalData in results) {
          final name = hospitalData['name'];
          final lat = hospitalData['geometry']['location']['lat'];
          final lng = hospitalData['geometry']['location']['lng'];
          final placeId = hospitalData['place_id'];

          futures.add(_fetchHospitalDetails(
              name, latitude, longitude, lat, lng, placeId));
        }

        final List<Hospital> fetchedHospitals = await Future.wait(futures);

        fetchedHospitals.sort((a, b) => a.distance.compareTo(b.distance));

        return {'message': 'ok', 'hospitals': fetchedHospitals};
      } else {
        return {
          'message': 'Error fetching hospitals ${data['error_message']} ',
          'hospitals': []
        };
      }
    } catch (e) {
      return {
        'message':
            ' Failed to get hospitals. Make sure your internet connection is okay',
        'hospitals': []
      };
    }
  }

  Future<Hospital> _fetchHospitalDetails(
      String name,
      double userLatitude,
      double userLongitude,
      double hospitallLaitude,
      double hospitalLongitude,
      String placeId) async {
    final distance = _calculateDistance(
        userLatitude, userLongitude, hospitallLaitude, hospitalLongitude);

    return Hospital(
      name: name,
      distance: distance,
      latitude: hospitallLaitude,
      longitude: hospitalLongitude,
      placeId: placeId,
    );
  }

  Future<Map<String, dynamic>> fetchMoreHospitalDetails(
      String placeId, double lat, double lng) async {
    const apiKey = 'AIzaSyBJ2v4ihgPsuKpvy54SAw5Yti8BrUz4Frg';
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_phone_number,website&key=$apiKey';

    try {
      final detailsResponse = await http.get(Uri.parse(detailsUrl));

      final detailsData = json.decode(detailsResponse.body);
      final phone = detailsData['result']['formatted_phone_number'] ?? '';
      final website = detailsData['result']['website'] ?? '';

      final address =
          (await placemarkFromCoordinates(lat, lng)).first.street ?? '';

      final distance = _calculateDistance(lat, lng, lat, lng);
      return {
        'message': 'ok',
        'hospital': Hospital(
          name: detailsData['result']['name'] ?? '',
          distance: distance,
          latitude: lat,
          longitude: lng,
          placeId: placeId,
          address: address,
          phone: phone,
          website: website,
        )
      };
    } catch (e) {
      return {
        'message': 'Failed to get hospital details',
        'hospital': '',
      };
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) * cos(_toRadians(lat1)) * cos(_toRadians(lat2));
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }
}

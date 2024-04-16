import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hospital {
  final String name;
  final List<String> services;
  final double distance; // Distance from the user in kilometers
  final double latitude;
  final double longitude;

  Hospital({
    required this.name,
    required this.services,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });
}

class HospitalServicesPage extends StatefulWidget {
  const HospitalServicesPage({super.key});

  @override
  _HospitalServicesPageState createState() => _HospitalServicesPageState();
}

class _HospitalServicesPageState extends State<HospitalServicesPage> {
  static const double userLatitude = 37.7749; // Example user's latitude
  static const double userLongitude = -122.4194; // Example user's longitude

  List<Hospital> hospitals = [];

  Future<void> fetchNearbyHospitals() async {
    const apiKey = 'AIzaSyBJ2v4ihgPsuKpvy54SAw5Yti8BrUz4Frg';
    const radius = 5000; // 5 kilometers
    const location = '$userLatitude,$userLongitude';

    const url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$location&radius=$radius&type=hospital&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final List<dynamic> results = data['results'];
      final List<Hospital> fetchedHospitals = results.map((hospitalData) {
        final name = hospitalData['name'];
        final services = hospitalData['types'].cast<String>();
        final lat = hospitalData['geometry']['location']['lat'];
        final lng = hospitalData['geometry']['location']['lng'];
        final distance =
            calculateDistance(userLatitude, userLongitude, lat, lng);
        return Hospital(
          name: name,
          services: services,
          distance: distance,
          latitude: lat,
          longitude: lng,
        );
      }).toList();

      // Sort hospitals based on distance
      fetchedHospitals.sort((a, b) => a.distance.compareTo(b.distance));

      setState(() {
        hospitals = fetchedHospitals;
      });
    } else {
      print('Error fetching hospitals: ${data['error_message']}');
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // in kilometers
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

  @override
  void initState() {
    super.initState();
    fetchNearbyHospitals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Hospitals'),
      ),
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          final hospital = hospitals[index];
          return ListTile(
            title: Text(hospital.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Services: ${hospital.services.join(", ")}'),
                Text('Distance: ${hospital.distance.toStringAsFixed(2)} km'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HospitalMapPage(hospital: hospital),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HospitalMapPage extends StatefulWidget {
  final Hospital hospital;

  const HospitalMapPage({required this.hospital});

  @override
  State<HospitalMapPage> createState() => _HospitalMapPageState();
}

class _HospitalMapPageState extends State<HospitalMapPage> {
  late GoogleMapController controller;
  void mapCreated(controller) {
    setState(() {
      controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hospital.name),
      ),
      body: SizedBox(
        height: 200,
        width: 200,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.hospital.latitude, widget.hospital.longitude),
            zoom: 15.0,
          ),
          mapType: MapType.satellite,
          onMapCreated: mapCreated,
          markers: {
            Marker(
              markerId: const MarkerId('hospital_marker'),
              position:
                  LatLng(widget.hospital.latitude, widget.hospital.longitude),
              infoWindow: InfoWindow(
                title: widget.hospital.name,
              ),
            ),
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zuri_health/features/hospital_list.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Position? _currentPosition;
  bool _locationPermissionDenied = false;
  bool _locationServiceEnabled = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationServiceEnabled = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationPermissionDenied = true;
      });
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationPermissionDenied = true;
        });
        return;
      }
    }

    setState(() {
      _locationPermissionDenied = false;
    });

    Position userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = userPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_locationServiceEnabled) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Hospitals'),
        ),
        body: const Center(
          child: Text(
            'Location services disabled. Please enable them to use this app.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_locationPermissionDenied) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Hospitals'),
        ),
        body: const Center(
          child: Text(
            'Location permission denied. Please enable it to use this app.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_currentPosition == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Hospitals'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return HospitalList(
      userPosition: _currentPosition!,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zuri_health/cubit/get_hospital_list_cubit.dart';

class ServiceSearch extends StatefulWidget {
  const ServiceSearch({super.key, required this.userPosition});
  final Position userPosition;
  @override
  State<ServiceSearch> createState() => _ServiceSearchState();
}

class _ServiceSearchState extends State<ServiceSearch> {
  double _distance = 200.0;
  TextEditingController searchController = TextEditingController();
  List<String> hospitalServices = [
    "Emergency room",
    "Primary care clinic",
    "Cardiology clinic",
    "Oncology clinic",
    "Neurology clinic",
    "Surgical center",
    "Imaging center",
    "Laboratory",
    "Maternity hospital",
    "Pediatric clinic",
    "Geriatric clinic",
    "Mental health clinic",
    "Rehabilitation center",
    "Pharmacy",
    "Nutritionist",
    "Pain management clinic",
    "Home health care service",
    "Hospice",
    "Telemedicine service",
    "Health education program",
    "Support group",
    "Medical social services",
    "Case management service",
    "Assistive technology service",
    "Respite care service",
    "Ambulance service",
    "Language interpretation service",
    "Medical equipment store",
    "Community outreach program",
    "Occupational health service",
    "Dental clinic",
    "Optometry clinic",
    "Cosmetic surgery center",
    "Orthopedic clinic",
    "Wellness program",
    "Chronic disease management program",
    "Fertility clinic",
    "Addiction treatment center",
    "Reproductive health clinic",
    "Endocrinology clinic",
    "Audiologist",
    "Allergy clinic",
    "Blood bank",
    "Wound care clinic",
    "Physical therapy clinic",
    "Occupational therapy clinic",
    "Speech therapy clinic",
    "Radiation therapy center",
    "Chemotherapy center",
    "Sports medicine clinic",
    "Sleep disorder clinic",
    "Dietitian",
    "Genetic counselor",
    "Plastic surgery clinic",
    "Urology clinic",
    "Gastroenterology clinic",
    "Dermatology clinic",
    "Pulmonology clinic",
    "Rheumatology clinic",
    "Nephrology clinic",
    "Ophthalmology clinic",
    "Otolaryngology clinic",
    "Vascular surgery clinic",
    "Infectious disease clinic",
    "Geriatric psychiatry clinic",
    "Neurosurgery clinic",
    "Palliative care service",
    "Geriatric dentistry",
    "Podiatry clinic",
    "Radiology center",
    "Sleep disorder center",
    "Neonatal intensive care unit",
    "Intensive care unit",
    "Coronary care unit",
  ];
  List<String> filteredServiceList = [];
  String _selectedService = '';
  bool _isServiceSelected = false;

  @override
  void initState() {
    super.initState();
    filteredServiceList.addAll(hospitalServices);
  }

  void _filterHospitals(String query) {
    filteredServiceList.clear();
    if (query.isEmpty) {
      filteredServiceList.addAll(hospitalServices);
    } else {
      for (var hospital in hospitalServices) {
        if (hospital.toLowerCase().contains(query.toLowerCase())) {
          filteredServiceList.add(hospital);
        }
      }
    }
    setState(() {});
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.055,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      autofocus: true,
                      controller: searchController,
                      onChanged: (value) {
                        _filterHospitals(value);
                        _isServiceSelected = false;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search services',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 25,
                      )),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Slider(
                      value: _distance,
                      min: 1.0,
                      max: 200,
                      divisions: 199,
                      label: '${_distance.round()} kms',
                      onChanged: (value) {
                        setState(() {
                          _distance = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  GestureDetector(
                    onTap: _isServiceSelected
                        ? () {
                            Navigator.pop(context);
                            context
                                .read<GetHospitalListCubit>()
                                .filterHospitals(
                                  radius: _distance.round() *
                                      1000, //convert to mtrs
                                  latitude: widget.userPosition.latitude,
                                  longitude: widget.userPosition.longitude,
                                  serviceFilter: _selectedService,
                                );
                          }
                        : () {
                            _showSnackBar('Please pick a service first');
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        color: _isServiceSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                'Selected Radius: ${_distance.round()} kms',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Selected Service: $_selectedService',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              filteredServiceList.isEmpty
                  ? const Center(
                      child: Text(
                        'No service was found',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Expanded(
                        child: ListView.builder(
                          itemCount: filteredServiceList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(filteredServiceList[index]),
                              onTap: () {
                                setState(() {
                                  _selectedService = filteredServiceList[index];
                                  _isServiceSelected = true;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

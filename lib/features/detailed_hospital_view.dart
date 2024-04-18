import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zuri_health/cubit/get_hospital_details_cubit.dart';
import 'package:zuri_health/models/hospital.dart';

class HospitalDetailedView extends StatefulWidget {
  const HospitalDetailedView({
    super.key,
    required this.hospital,
  });
  final Hospital hospital;

  @override
  State<HospitalDetailedView> createState() => _HospitalDetailedViewState();
}

class _HospitalDetailedViewState extends State<HospitalDetailedView> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      markers.add(Marker(
        markerId: const MarkerId('marker1'),
        position: LatLng(widget.hospital.latitude, widget.hospital.longitude),
        infoWindow: InfoWindow(title: widget.hospital.name),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    context
        .read<GetHospitalDetailsCubit>()
        .getHospitalDetails(hospital: widget.hospital);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  widget.hospital.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(widget.hospital.latitude, widget.hospital.longitude),
              zoom: 12,
            ),
            markers: markers,
          ),
        ),
        BlocBuilder<GetHospitalDetailsCubit, GetHospitalDetailsState>(
          builder: (context, state) {
            return state.when(initial: () {
              return const LinearProgressIndicator();
            }, loading: () {
              return const LinearProgressIndicator();
            }, loaded: (Hospital hospital) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, bottom: 5, top: 10),
                    child: Row(
                      children: [
                        Text(
                          'Distance from you',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          '${widget.hospital.distance.toStringAsFixed(2)} km',
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, bottom: 5),
                    child: Row(
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            hospital.address!,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, bottom: 10),
                    child: Text(
                      'This facility has not advertised its services on google maps.For more info,  call or visit their website',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, bottom: 5),
                    child: Row(
                      children: [
                        Text(
                          'Phone',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  hospital.website!.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(left: 10.0, bottom: 10),
                          child: Row(
                            children: [
                              Text('Phone not available'),
                            ],
                          ),
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                hospital.phone!,
                              ),
                            ],
                          ),
                        ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, bottom: 5),
                    child: Row(
                      children: [
                        Text(
                          'Website',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  hospital.website!.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(left: 10.0, bottom: 10),
                          child: Row(
                            children: [
                              Text('Website not available'),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, bottom: 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  hospital.website!,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              );
            }, error: (String errorMessage) {
              return Text(errorMessage);
            });
          },
        )
      ],
    );
  }
}

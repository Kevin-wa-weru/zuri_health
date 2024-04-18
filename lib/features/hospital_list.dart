import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zuri_health/cubit/get_hospital_list_cubit.dart';
import 'package:zuri_health/features/detailed_hospital_view.dart';
import 'package:zuri_health/features/hospital_filter.dart';
import 'package:zuri_health/models/hospital.dart';

class HospitalList extends StatefulWidget {
  const HospitalList({
    super.key,
    required this.userPosition,
  });
  final Position userPosition;

  @override
  State<HospitalList> createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
  showHospitalView(
    context,
    Hospital hospital,
  ) {
    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) => HospitalDetailedView(
              hospital: hospital,
            ));
  }

  @override
  void initState() {
    super.initState();
    context.read<GetHospitalListCubit>().getNearbyHospitals(
        radius: 10000, //10km
        latitude: widget.userPosition.latitude,
        longitude: widget.userPosition.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ServiceSearch(
                          userPosition: widget.userPosition,
                        )));
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(color: Colors.black54)),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8),
                        child: Icon(Icons.search),
                      ),
                      Text('Search by services/distance')
                    ],
                  ),
                ),
              ),
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
                  child: Text('Nearby hospitals '),
                ),
              ],
            ),
            BlocBuilder<GetHospitalListCubit, GetHospitalListState>(
              builder: (context, state) {
                return state.when(initial: () {
                  return const LinearProgressIndicator();
                }, loading: () {
                  return const LinearProgressIndicator();
                }, loaded: (List<Hospital> hospitals) {
                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: Expanded(
                        child: ListView(
                            children: hospitals
                                .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: ListTile(
                                      title: Text(e.name),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              'Distance from you: ${e.distance.toStringAsFixed(2)} km'),
                                          Text(
                                            'Tap for more info',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        showHospitalView(context, e);
                                      },
                                    )))
                                .toList())),
                  );
                }, error: (String errorMessage) {
                  return Text(errorMessage);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zuri_health/features/distance_filter.dart';
import 'package:zuri_health/features/hospital_view.dart';
import 'package:zuri_health/features/service_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final searchController = TextEditingController();
  AnimationController? bottomSheetcontroller;

  @override
  void initState() {
    bottomSheetcontroller = BottomSheet.createAnimationController(this);
    bottomSheetcontroller!.duration = const Duration(milliseconds: 600);
    bottomSheetcontroller!.reverseDuration = const Duration(milliseconds: 200);
    super.initState();
  }

  List dummyData = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    1,
    11,
    33,
    44,
    44,
    44,
    4,
    444,
    4,
    44,
    4,
    4,
    44,
    4,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    1,
    11,
    33,
    44,
    44,
    44,
    4,
    444,
    4,
    44,
    4,
    4,
    44,
    4
  ];

  showHospitalView(
    context,
  ) {
    showModalBottomSheet(
        transitionAnimationController: bottomSheetcontroller,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) => const HospitalView());
  }

  showDistanceFilter(
    context,
  ) {
    showModalBottomSheet(
        transitionAnimationController: bottomSheetcontroller,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) => const DistanceFilter());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ServiceSearch()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.055,
                    width: MediaQuery.of(context).size.width * 0.8,
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
                        Text('Search hospital services')
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: InkWell(
                    onTap: () => showDistanceFilter(context),
                    child: const Icon(Icons.sort_outlined)),
              ),
            ],
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 20, bottom: 20),
                child: Text(
                    'Your Locaion : Mwihoko.  Below are nearby hospitals '),
              ),
            ],
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
                child: ListView(
                    children: dummyData
                        .map((e) => InkWell(
                              onTap: () {
                                showHospitalView(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Amani children Hospitals'),
                                        Text('5 kms away'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList())),
          )
        ],
      ),
    );
  }
}

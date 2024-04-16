import 'package:flutter/material.dart';

class HospitalView extends StatefulWidget {
  const HospitalView({super.key});

  @override
  State<HospitalView> createState() => _HospitalViewState();
}

class _HospitalViewState extends State<HospitalView> {
  List dummyData = [0, 1, 2, 3, 5, 6, 7, 8, 9];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amani children Hospitals',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.cancel,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: Colors.grey,
        ),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
              child: Text(
                'Distance: 5 kms from your location',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10.0, bottom: 10),
          child: Row(
            children: [
              Text(
                'Address : Kahawa Sukari',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10.0, bottom: 10),
          child: Text(
            'Services offerred :',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: dummyData
                    .map(
                      (e) => const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(
                          'Service One.',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                    .toList()),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ServiceSearch extends StatefulWidget {
  const ServiceSearch({super.key});

  @override
  State<ServiceSearch> createState() => _ServiceSearchState();
}

class _ServiceSearchState extends State<ServiceSearch> {
  final searchController = TextEditingController();

  List dummyData = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    91,
    1,
    2,
    12,
    1,
    2,
    2,
    2,
    3,
    3,
    2,
    2,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.055,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: TextFormField(
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          controller: searchController,
                          onChanged: (value) {},
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Search services',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.transparent, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black54, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black54, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          )),
                    ),
                  ),
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.cancel,
                        size: 25,
                      )),
                ],
              ),
            ),
            Expanded(
                child: ListView(
                    children: dummyData
                        .map(
                          (e) => InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  left: 15.0, bottom: 10, top: 20),
                              child: Text(
                                'Amani children Hospitals',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        )
                        .toList()))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DistanceFilter extends StatefulWidget {
  const DistanceFilter({super.key});

  @override
  State<DistanceFilter> createState() => _DistanceFilterState();
}

class _DistanceFilterState extends State<DistanceFilter> {
  double _currentSliderValue = 100;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter distance   ${_currentSliderValue.round().toString()} km  ',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Slider(
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            thumbColor: Colors.blue,
            value: _currentSliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: '${_currentSliderValue.round().toString()} km',
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 50,
            color: Colors.blue,
            child: const Center(
              child: Text(
                'Apply filter',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

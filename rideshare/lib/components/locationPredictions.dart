import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/LocationListTile.dart';
import '../resources/AutocompletePrediction.dart';

class LocationPredictions extends StatelessWidget {
  final int itemcount;
  final List<AutoCompletePrediction> placePredictions;
  final Function()? onTap;

  const LocationPredictions({
    super.key,
    required this.itemcount,
    required this.placePredictions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: placePredictions.length,
        itemBuilder: (context, index) => LocationListTile(
          location: placePredictions.elementAt(index).description!,
          onTap: () {
            onTap!();
          },
        ),
      ),
    );
  }
}

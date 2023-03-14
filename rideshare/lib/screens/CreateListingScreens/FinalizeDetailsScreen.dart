import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../models/listing.dart';

class FinalizeDetailsPage extends StatefulWidget {
  final Listing listing;
  const FinalizeDetailsPage({super.key, required this.listing});

  @override
  State<FinalizeDetailsPage> createState() => _FinalizeDetailsPageState();
}

class _FinalizeDetailsPageState extends State<FinalizeDetailsPage> {
  late Listing listing;

  @override
  void initState() {
    super.initState();
    listing = widget.listing;
    print(listing.startLocation.latitude);
    print(listing.startLocation.longitude);
    print(listing.destination.latitude);
    print(listing.destination.longitude);
    print(listing.startLocationText);
    print(listing.destinationText);
    print(listing.departTime.toLocal());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finalize Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

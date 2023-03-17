import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/listing.dart';

class MyListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;
  const MyListingCard({super.key, required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                listing.startLocationText.length > 39
                    ? "From: " +
                        listing.startLocationText.substring(0, 35) +
                        "..."
                    : "From: " + listing.startLocationText,
              ),
              Text(
                listing.destinationText.length > 39
                    ? "To: " + listing.destinationText.substring(0, 35) + "..."
                    : "To: " + listing.destinationText,
              ),
              Text(
                listing.departTime.toLocal().toString(),
              ),
              Text(
                (listing.price.isEmpty || listing.price == "0")
                    ? "Free"
                    : listing.price,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

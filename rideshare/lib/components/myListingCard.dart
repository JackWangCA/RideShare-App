import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../models/listing.dart';

class MyListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;
  const MyListingCard({super.key, required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'From: ',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: listing.startLocationText,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'To: ',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: listing.destinationText,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Time: ',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: DateFormat('EEEE, d MMM, yyyy')
                                .format(listing.departTime.toLocal()),
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5.0),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: listing.price != "0" ? "\$" : "",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                          ),
                          TextSpan(
                            text: listing.price == "0" ? "Free" : listing.price,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: listing.listingType == "Offering"
                          ? Colors.blueAccent
                          : Colors.orangeAccent,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15))),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    listing.listingType,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                // Text(
                //   listing.startLocationText.length > 39
                //       ? "From: " +
                //           listing.startLocationText.substring(0, 35) +
                //           "..."
                //       : "From: " + listing.startLocationText,
                // ),
                // Text(
                //   listing.destinationText.length > 39
                //       ? "To: " + listing.destinationText.substring(0, 35) + "..."
                //       : "To: " + listing.destinationText,
                // ),
                // Text(
                //   listing.departTime.toLocal().toString(),
                // ),
                // Text(
                //   (listing.price.isEmpty || listing.price == "0")
                //       ? "Free"
                //       : listing.price,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

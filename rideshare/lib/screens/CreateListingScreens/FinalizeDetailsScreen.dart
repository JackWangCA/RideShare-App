import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rideshare/components/myButton.dart';
import 'package:rideshare/components/myTextField.dart';
import 'package:rideshare/resources/PostService.dart';
import 'package:rideshare/screens/CreateListingScreens/PublishPostSuccessScreen.dart';
import 'package:uuid/uuid.dart';

import '../../models/listing.dart';

class FinalizeDetailsPage extends StatefulWidget {
  final Listing listing;
  const FinalizeDetailsPage({super.key, required this.listing});

  @override
  State<FinalizeDetailsPage> createState() => _FinalizeDetailsPageState();
}

class _FinalizeDetailsPageState extends State<FinalizeDetailsPage> {
  List<String> listingTypeOptions = <String>['Requesting', 'Offering'];
  late Listing listing;
  String listingType = 'Requesting';
  late DateTime publishedDateTime;
  bool clicked = false;

  bool isLoading = false;
  bool priceValid = true;

  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    listing = widget.listing;
    publishedDateTime = listing.publishedTime;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showMessage(String title) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        });
  }

  DateTime latestTime() {
    if (publishedDateTime.toLocal().isBefore(DateTime.now())) {
      publishedDateTime = DateTime.now();
    }
    return publishedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Finalize Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              DropdownButton(
                  value: listingType,
                  items: listingTypeOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      listingType = value!;
                    });
                  }),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: MyTextField(
                  controller: priceController,
                  hintText: "Price (Leave blank if free)",
                  obscureText: false,
                  inputType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: TextField(
                    onChanged: (value) {
                      if (double.tryParse(value) == false &&
                          int.tryParse(value) == false &&
                          value.isNotEmpty) {
                        setState(() {
                          priceValid = false;
                        });
                      } else {
                        priceValid = true;
                      }
                    },
                    maxLines: 10,
                    maxLength: 500,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: "Anything else you want to add?",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            BorderSide(color: Theme.of(context).dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            BorderSide(color: Theme.of(context).focusColor),
                      ),
                      fillColor: Theme.of(context).dialogBackgroundColor,
                      filled: true,
                    ),
                  )),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: MyButton(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 4.0,
                          color: Colors.grey,
                        )
                      : Text(
                          "Confirm Details",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).canvasColor,
                                  fontSize: 15.0),
                        ),
                  onTap: () async {
                    if (!clicked) {
                      setState(() {
                        clicked = true;
                      });
                      if (priceValid) {
                        publishedDateTime = DateTime.now().toUtc();
                        listing.publishedTime = publishedDateTime;
                        if (priceController.text.trim().isEmpty) {
                          listing.price = "0";
                        } else {
                          listing.price = priceController.text.trim();
                        }
                        try {
                          await FirebaseAuth.instance.currentUser!.reload();
                          setState(() {
                            isLoading = true;
                          });
                          String result =
                              await PostService().publishPost(listing);
                          if (result != "success") {
                            showMessage(result);
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PublishPostSuccessPage(),
                                    maintainState: true),
                                (Route<dynamic> route) => false);
                          }
                        } catch (e) {}
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

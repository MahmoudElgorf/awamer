import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awamer/screens/user/map_picker_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class AddressPrompt {
  static void show(BuildContext context) {
    String? selectedAddress;
    LatLng? selectedLatLng;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Center(
                  child: Text(
                    'Choose Your Address',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapPickerScreen(),
                          ),
                        );

                        if (result != null) {
                          // Parse LatLng from string (e.g., "LatLng(30.1, 31.2)")
                          final latLngString = result.toString();
                          final regex = RegExp(r'LatLng\(([^,]+), ([^)]+)\)');
                          final match = regex.firstMatch(latLngString);

                          if (match != null) {
                            final latitude = double.parse(match.group(1)!);
                            final longitude = double.parse(match.group(2)!);
                            selectedLatLng = LatLng(latitude, longitude);

                            // Use geocoding to convert coordinates to address
                            List<Placemark> placemarks =
                            await placemarkFromCoordinates(latitude, longitude);

                            if (placemarks.isNotEmpty) {
                              final place = placemarks.first;
                              setState(() {
                                selectedAddress =
                                "${place.street}, ${place.locality}, ${place.administrativeArea}";
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Address selected"),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text(
                        'Select Address from Map',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (selectedAddress != null)
                      Text(
                        selectedAddress!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedAddress != null) {
                          final uid = FirebaseAuth.instance.currentUser!.uid;
                          final userDoc = FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid);

                          final snapshot = await userDoc.get();
                          final userData = snapshot.data() ?? {};

                          await userDoc.set({
                            ...userData,
                            'address': selectedAddress,
                            'location': {
                              'lat': selectedLatLng?.latitude,
                              'lng': selectedLatLng?.longitude,
                            },
                          });

                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select an address first"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C9581),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

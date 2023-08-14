import 'dart:io';

import 'package:favorite_places/models/place_model.dart';
import 'package:favorite_places/providers/favorite_places_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _placeTitle = '';
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    if (_formKey.currentState!.validate() ||
        _selectedImage != null ||
        _selectedLocation != null) {
      _formKey.currentState!.save();
      ref.read(favoritePlaceProvider.notifier).addFavoritePLace(
            Place(
              title: _placeTitle,
              image: _selectedImage!,
              location: _selectedLocation!,
            ),
            PlaceLocation(
              latitude: _selectedLocation!.latitude,
              longitude: _selectedLocation!.longitude,
              address: _selectedLocation!.address,
            ),
          );

      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                  decoration: InputDecoration(
                      label: Text(
                    'Title',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Place title cannot be empty!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _placeTitle = value!;
                  },
                ),
                const SizedBox(height: 10),
                ImageInput(
                  onPickedImage: (image) {
                    _selectedImage = image;
                  },
                ),
                const SizedBox(height: 10),
                LocationInput(
                  onSelectLocation: (location) {
                    _selectedLocation = location;
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _savePlace,
                  icon: const Icon(Icons.add),
                  label: const Text('Add item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

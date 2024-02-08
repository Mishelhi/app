import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

enum Repeat { daily, weekly, monthly, yearly }

class TaskFormScreen extends StatefulWidget {
  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _category;
  Repeat? _repeat = Repeat.daily;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('categories')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final docs = snapshot.data!.docs;
                  final items = docs
                      .map((doc) => DropdownMenuItem<String>(
                            value: doc.id,
                            child: Text(doc['name']),
                          ))
                      .toList();

                  items.insert(
                      0,
                      const DropdownMenuItem<String>(
                        value: 'No category',
                        child: Text('No category'),
                      ));

                  return Row(
                    children: <Widget>[
                      const Text('Category:  '),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('categories')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          final docs = snapshot.data!.docs;
                          final items = docs
                              .map((doc) => DropdownMenuItem<String>(
                                    value: doc.id,
                                    child: Text(doc['name']),
                                  ))
                              .toList();

                          items.insert(
                              0,
                              const DropdownMenuItem<String>(
                                value: 'No category',
                                child: Text('No category'),
                              ));

                          items.add(const DropdownMenuItem<String>(
                            value: 'Add category',
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.add),
                                Text('Add category'),
                              ],
                            ),
                          ));
                          return DropdownButton<String>(
                            value: _category ?? items[0].value,
                            onChanged: (String? newValue) async {
                              if (newValue == 'Add category') {
                                String? new_cat = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    final TextEditingController
                                        _categoryController =
                                        TextEditingController();
                                    return AlertDialog(
                                      title: const Text('Add Category'),
                                      content: TextField(
                                        controller: _categoryController,
                                        decoration: const InputDecoration(
                                            labelText: 'Category name'),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () async {
                                            var doc = await FirebaseFirestore
                                                .instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection('categories')
                                                .add({
                                              'name': _categoryController.text,
                                            });
                                            items.insert(
                                                1,
                                                DropdownMenuItem<String>(
                                                  value: doc.id,
                                                  child: Text(
                                                      _categoryController.text),
                                                ));
                                            Navigator.pop(context, doc.id);
                                          },
                                          child: const Text('Add'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                newValue = new_cat;
                              }
                              setState(() {
                                _category = newValue;
                              });
                            },
                            items: items,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != _date) {
                        setState(() {
                          _date = picked;
                        });
                      }
                    },
                  ),
                  Text(_date == null
                      ? 'Select date'
                      : 'Date: ${_date!.toIso8601String()}'),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null && picked != _startTime) {
                        setState(() {
                          _startTime = picked;
                        });
                      }
                    },
                  ),
                  Text(_startTime == null
                      ? 'Select start time'
                      : 'Start time: ${_startTime!.format(context)}'),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null && picked != _endTime) {
                        setState(() {
                          _endTime = picked;
                        });
                      }
                    },
                  ),
                  Text(_endTime == null
                      ? 'Select end time'
                      : 'End time: ${_endTime!.format(context)}'),
                ],
              ),
              /*TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                suggestionsCallback: (pattern) async {
                  await LocationService.getCurrentLocation();
                  return await LocationService.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.toString()),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  this._locationController.text = suggestion.toString();
                },
              ),*/
              ListTile(
                title: const Text('Repeat'),
                contentPadding: EdgeInsets.all(0),
                subtitle: Column(
                  children: Repeat.values.map((Repeat value) {
                    return RadioListTile<Repeat>(
                      title: Text(value.toString().split('.').last),
                      value: value,
                      groupValue: _repeat,
                      onChanged: (Repeat? newValue) {
                        setState(() {
                          _repeat = newValue;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('tasks')
                        .add({
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'date': _date,
                      'start_time': _startTime?.format(context),
                      'end_time': _endTime?.format(context),
                      'location': _locationController.text,
                      'category': _category,
                      'repeat': _repeat.toString().split('.').last,
                    });

                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, we cannot request permissions.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // get the current location.
    return await Geolocator.getCurrentPosition();
  }

  static Future<List<Location>> getSuggestions(String query) async {
    try {
      // Get location suggestions from the query
      List<Location> locations = await locationFromAddress(query);
      return locations;
    } catch (e) {
      // Handle any exceptions thrown
      print(e);
      return [];
    }
  }
}

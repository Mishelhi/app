import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class LocationService extends ChangeNotifier {
  String _userLocation = 'INDIA';
  double? latitude;
  double? longitude;

  Future<String> getLocation() async {
    //IMP PERMISSION LINE
    PermissionStatus permission = await Permission.location.status;
    if (permission.isDenied) {
      // The user denied location permission. Request permission again.
      permission = await Permission.location.request();
    }
    if (permission.isGranted) {
      try {
        LocationPermission permissionStatus;

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        var addresses = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        var first = addresses.first;

        var locality = first.locality;
        var subLocality = first.subLocality;

        _userLocation = subLocality! + ', ' + locality! + '.';
        _userLocation = _userLocation.toString();

        notifyListeners();
        return _userLocation;
      } catch (e) {
        print('$e       : occurred in LocationService.dart');

        notifyListeners();
        return _userLocation;
      }
    } else {
      throw Exception('Location permission not granted');
    }
  }

  Future<double> getLat() async {
    //IMP PERMISSION LINE
    LocationPermission geolocationStatus = await Geolocator.checkPermission();

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return position.latitude;
    } catch (e) {
      print(e);
      return 19.109906;
    }
  }

  Future<double> getLong() async {
    //IMP PERMISSION LINE
    LocationPermission geolocationStatus = await Geolocator.checkPermission();

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return position.longitude;
    } catch (e) {
      print(e);

      return 72.867671;
    }
  }
}

import 'dart:async';
import 'dart:collection';
import 'package:flutter_application_1/utilities/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

var latitude = 19.109906;
var longitude = 72.867671;

class MapContainer extends StatefulWidget {
  final double width;

  MapContainer({required this.width});

  @override
  _MapContainerState createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  Set<Marker> _currentLocationMarkerPin = HashSet<Marker>();
  Set<CircleMarker> _circularArea = HashSet<CircleMarker>();
  final MapController _controller = MapController();

  final LatLng _center = LatLng(latitude, longitude);
  final double _zoom = 14.0;
  late final FlutterMap map;

  Future getLocationData() async {
    LocationService locationService = LocationService();

    //Fetching _userLocation
    latitude = await locationService.getLat();
    longitude = await locationService.getLat();
    setState(() {});
  }

  void getCurrentLocationMarkerPin() {
    setState(() {
      _currentLocationMarkerPin.add(
        Marker(
            key: Key("0"),
            point: LatLng(latitude, longitude),
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40.0,
            )),
      );
    });
  }

  void getCircularArea() {
    _circularArea.add(
      CircleMarker(
        point: LatLng(latitude, longitude),
        radius: 1000,
        borderStrokeWidth: 2,
        borderColor: Colors.blueAccent,
        color: Colors.blueAccent.withOpacity(0.3),
      ),
    );
  }

  @override
  void initState() {
    getLocationData();
    super.initState();

    getCircularArea();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(432.0, 816.0), minTextAdapt: true);
    map = FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: _center,
        initialZoom: _zoom,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        )
      ],
    );
    return Container(
        width: widget.width.w,
        height: 271.0.h,
        margin: EdgeInsets.only(top: 5.0.h),
        child: FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: _zoom,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: _currentLocationMarkerPin.toList(),
            ),
            CircleLayer(circles: _circularArea.toList()),
          ],
        ));
  }
}

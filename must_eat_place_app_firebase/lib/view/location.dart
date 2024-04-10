import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  
//FUNCTIONS  
    late MapController mapController; 
    late double latData; 
    late double lngData; 

//INIT
    @override
  void initState() {
    super.initState();
    mapController = MapController();
    var value = Get.arguments; 
    latData = value[0];
    lngData = value[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: flutterMap(),
    );
  }

  Widget flutterMap(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: latlng.LatLng(latData, lngData),
          initialZoom: 14,
        ), 
        children: [
          TileLayer(
            urlTemplate:  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80,
                height: 80,
                point: latlng.LatLng(latData,lngData), 
                child: const Column(
                  children: [
                    Icon(
                      Icons.pin_drop,
                      size: 50,
                      color: Colors.red,
                    )
                  ],
                )
              )
            ]
          ),
        ]
      ),
    );
  }











}//END
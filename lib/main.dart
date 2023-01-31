import 'package:custom_tooltip_example_on_flutter_map/src/helpers/clipper_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tooltip example on map'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Marker> customMarker = [];
  final List<Marker> defaultMarker = [];
  String selectedMenu = 'Default';

  void addDefaultTooltipMarker(LatLng point) {
    defaultMarker.add(
      Marker(
        point: point,
        anchorPos: AnchorPos.align(AnchorAlign.top),
        builder: (context) => JustTheTooltip(
          tailLength: 16.0,
          tailBaseWidth: 16.0,
          offset: -3.0,
          isModal: true,
          preferredDirection: AxisDirection.up,
          barrierDismissible: false,
          content: Container(
            margin: const EdgeInsets.all(5.0),
            height: 50,
            child: Column(
              children: [
                Text(
                  'Latitude: ${point.latitude}',
                  style: const TextStyle(
                    fontFamily: 'Manrope Regular',
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Longitude: ${point.longitude}',
                  style: const TextStyle(
                    fontFamily: 'Manrope Regular',
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          child: const Icon(
            Icons.location_pin,
            size: 50.0,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }

  void addCustomTooltipMarker(LatLng point) {
    customMarker.add(
      Marker(
        point: point,
        width: 160.0,
        height: 100.0,
        anchorPos: AnchorPos.align(AnchorAlign.top),
        builder: (context) => ClipPath(
          clipper: ClipperStack(),
          child: Container(
            width: 160.0,
            height: 100.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.0),
                topRight: Radius.circular(6.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListView(
                children: [
                  Text(
                    'Latitude: ${point.latitude}',
                    style: const TextStyle(
                      fontFamily: 'Manrope Regular',
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Longitude: ${point.longitude}',
                    style: const TextStyle(
                      fontFamily: 'Manrope Regular',
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clearAllMarker() {
    customMarker.clear();
    defaultMarker.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.teal[100],
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(23.509364, 90.128928),
          zoom: 8.0,
          onTap: (tapPosition, point) {
            if (selectedMenu == 'Default') {
              addDefaultTooltipMarker(point);
            } else {
              addCustomTooltipMarker(point);
            }
          },
        ),
        nonRotatedChildren: [
          Container(
            height: 30,
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    selectedMenu = 'Default';
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: !(selectedMenu == 'Default')
                            ? Colors.teal[100]
                            : Colors.teal[300],
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                        child: Text(
                      'Default',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    selectedMenu = 'Custom';
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: (selectedMenu == 'Default')
                            ? Colors.teal[100]
                            : Colors.teal[300],
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                        child: Text(
                      'Custom',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                  ),
                ))
              ],
            ),
          )
          // AttributionWidget.defaultWidget(
          //   source: 'OpenStreetMap contributors',
          //   onSourceTapped: null,
          // ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: defaultMarker,
          ),
          MarkerLayer(
            markers: customMarker,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          clearAllMarker();
          setState(() {});
        },
        tooltip: 'Clear all marker',
        child: const Icon(Icons.clear),
      ),
    );
  }
}

import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(MaterialApp(home: ARViewScreen()));
}

class ARViewScreen extends StatefulWidget {
  const ARViewScreen({super.key});

  @override
  ARViewScreenState createState() => ARViewScreenState();
}

class ARViewScreenState extends State<ARViewScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ARView(
        onARViewCreated: onARViewCreated,
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      // customPlaneTexturePath: "images/triangle.png",
      showWorldOrigin: true,
    );

    arObjectManager.onInitialize();

    arSessionManager.onPlaneOrPointTap = onPlaneTapped;
  }

  Future<void> onPlaneTapped(List<ARHitTestResult> hits) async {
    final hit = hits.first;
    final transform = hit.worldTransform;

    // Extrair a posição do Matrix4
    final vector.Vector3 position = vector.Vector3(
      transform.entry(0, 3),
      transform.entry(1, 3),
      transform.entry(2, 3),
    );

    var newNode = ARNode(
      type: NodeType.localGLTF2,
      uri: "assets/models/ultimate_monsters_pack.glb",
      scale: vector.Vector3(0.5, 0.5, 0.5),
      position: position,
    );

    await arObjectManager.addNode(newNode);
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }
}

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:earthmodel/core/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class PlanetProvider extends ChangeNotifier {

  //*--------------------
  //*   PROPERTY FIELD  
  //*--------------------

  ArCoreController _arCoreController;
  ArCoreController get arCoreController => _arCoreController;

  ArCoreNode _node;
  ArCoreNode get node => _node;

  List<ArCoreNode> _nodeList = new List<ArCoreNode>();
  List<ArCoreNode> get nodeList => _nodeList;

  int _selectedPlanet;
  int get selectedPlanet => _selectedPlanet;

  List<Map<String, String>> _planetList;
  List<Map<String, String>> get planetList => _planetList;

  BuildContext _context;
  BuildContext get context => _context;

  //*--------------------
  //*   FUNCTION FIELD  
  //*--------------------

  //* Initialize context
  void initContext(BuildContext context) async {
    _context = await context;
    notifyListeners();
  }

  //* Initializing planet data
  void initPlanet() async {
    _planetList = await [
      {
        "name": "Venus",
        "asset": "assets/venus.jpg",
      },
      {
        "name": "Bumi",
        "asset": "assets/earth.jpg",
      },
      {
        "name": "Mars",
        "asset": "assets/mars.jpg",
      },
      {
        "name": "Jupiter",
        "asset": "assets/jupiter.jpg",
      },
      {
        "name": "Bulan",
        "asset": "assets/moon.jpg",
      },
      {
        "name": "Matahari",
        "asset": "assets/sun.jpg",
      },
    ];
    notifyListeners();
  }

  //* Function when ArCoreView created
  onArCoreViewCreated(ArCoreController _controller) {
    _arCoreController = _controller;
    
    arCoreController.onNodeTap = (name) => onTap(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
    notifyListeners();
  }

  //* Function to create new planet
  createPlanet(ArCoreHitTestResult plane) async {
    ByteData bytes = await rootBundle.load(planetList[selectedPlanet]["asset"]);
    final material = ArCoreMaterial(color: Colors.blue, textureBytes: bytes.buffer.asUint8List());
    final sphere = ArCoreSphere(materials: [material], radius: 0.2);
    
    _node = ArCoreNode(
      name: planetList[selectedPlanet]["name"],
      shape: sphere,
      position: plane.pose.translation + vector.Vector3(0, 0.7, 0),
      rotation: plane.pose.rotation
    );
    _nodeList.add(_node);
    _arCoreController.addArCoreNodeWithAnchor(_node);
    notifyListeners();
  }

  //* Function to handle selected Planet
  void selectPlanet(int index) {
    _selectedPlanet = index;
    notifyListeners();
  }

  //* Function to refresh all planet
  void refreshNode() {
    DialogUtils.instance.showDialog(context, "Berhasil menghapus semua planet", "OK");
    clearNodes(); 
  }

  void clearNodes() async {
    nodeList.forEach((node) {
      _arCoreController.removeNode(nodeName: node.name);
    });
    nodeList.clear();
    notifyListeners();
  }


  //* Function to handle when surface clicked
  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    if (selectedPlanet != null) {
      final hit = hits.first;
      createPlanet(hit);
    } else {
      DialogUtils.instance.showDialog(context, "Silahkan pilih planet terlebih dahulu", "OK");
    }
  }

  //* Function when planet clicked
  void onTap(name) {
    DialogUtils.instance.showDialog(context, "Sebuah objek dari planet ${name}", "OK");
  }
}
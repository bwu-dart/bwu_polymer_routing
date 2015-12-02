library bwu_polymer_routing_examples.web.example_03.main;

import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing/module.dart' as brt;
import 'package:bwu_polymer_routing_examples/example_03/components/app_element.dart';

/// Silence analyzer [AppElement]
dynamic main() async {
  // dummy to satisfy the di transformer
  brt.RouteCfg y;
  y;
  await initPolymer();
}

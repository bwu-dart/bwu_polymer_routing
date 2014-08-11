library bwu_polymer_router.example_01.app_element;

import 'package:polymer/polymer.dart';
import 'package:di/di.dart' show Module, ModuleInjector;
import 'package:bwu_polymer_routing/module.dart'
    show RoutingModule;
import 'package:bwu_polymer_routing/static_keys.dart';
import '../route_initializer.dart';
import 'package:bwu_polymer_routing/di.dart';

class AppModule extends Module {
  AppModule() : super() {
    install(new RoutingModule(usePushState: false));
    bindByKey(ROUTE_INITIALIZER_FN_KEY, toValue: new RouteInitializer());
  }
}

@CustomTag('app-element')
class AppElement extends PolymerElement with DiContext {
  AppElement.created() : super.created();

  @override
  void attached() {

    super.attached();

    initDiContext(this, new ModuleInjector([new AppModule()]));
  }
}

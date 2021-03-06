library bwu_polymer_routing_examples.example_03.components.app_element;

import 'dart:html' as dom;
import 'dart:js' as js;
import 'package:polymer/polymer.dart';
import 'package:di/di.dart' show Module, ModuleInjector;
import 'package:bwu_polymer_routing/module.dart' show RoutingModule;
import 'package:bwu_polymer_routing/static_keys.dart';
import '../route_initializer.dart';
import 'package:bwu_polymer_routing/di.dart' as di;

import 'package:core_elements/core_item.dart' show CoreItem;
import 'package:core_elements/core_menu.dart' show CoreMenu;

class AppModule extends Module {
  AppModule() : super() {
    install(new RoutingModule(usePushState: false));
    bindByKey(ROUTE_INITIALIZER_FN_KEY, toValue: new RouteInitializer());
  }
}

@CustomTag('app-element')
class AppElement extends PolymerElement with di.DiContext, di.DiConsumer {
  AppElement.created() : super.created();

  @override
  void attached() {
    super.attached();

    initDiContext(this, new ModuleInjector([new AppModule()]));
  }

  void overviewSelectHandler(dom.MouseEvent e) {
//    var item = (e.target as CoreItem);
    ($['main-menu'] as CoreMenu).selected = 0;
  }

  void menuSelectHandler(dom.CustomEvent e) {
    var detail = new js.JsObject.fromBrowserObject(e)['detail'];
    if (detail['isSelected']) {
      var item = (detail['item'] as CoreItem);
      selectedMenuLabel = item.label;
      goPathFromAttributes(item);
    }
  }

  @observable
  String selectedMenuLabel = "Overview";
}

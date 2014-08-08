library bwu_polymer_router.example.app_element;

import 'dart:html' as dom;
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart' as rt;
import 'package:di/di.dart' show Module, ModuleInjector, Injector, TypeReflector;
import 'package:di/src/reflector_dynamic.dart';
import 'package:bwu_polymer_routing/module.dart'
    show RouteInitializerFn, RoutingModule, NgRoutingHelper, RouteProvider;
import 'package:bwu_polymer_routing/static_keys.dart';
import 'route_initializer.dart';

class RootRouteProvider implements RouteProvider {
  rt.Router _router;

  RootRouteProvider(this._router);

  @override
  Map<String, String> get parameters => {};

  @override
  rt.Route get route => _router.root;

  @override
  String get routeName => route.name;
}

@CustomTag('app-element')
class AppElement extends PolymerElement {
  AppElement.created() : super.created();

  static Injector injector;

  @override
  void attached() {
    Module module = new Module.withReflector(new DynamicTypeFactories())
    ..bindByKey(ROUTE_INITIALIZER_FN_KEY, toValue: new RouteInitializer());

    injector = new ModuleInjector([
      new RoutingModule(usePushState: false)
      ..install(module)
      ])
    .createChild([]);

    super.attached();

    on['polymer-di'].listen((dom.CustomEvent e) {
      e.preventDefault();
      e.stopImmediatePropagation();
      try {
      e.detail.keys.where((k) => e.detail[k] == null).forEach((k) {
        e.detail[k] = injector.get(k);
      });
      } catch(e) {
        print(e);
      }
      e.detail[Injector] = injector;
    });
    (injector.get(NgRoutingHelper) as NgRoutingHelper).router.go('user.articleList', {'userId': 'Martin'});
  }

//  void editButtonClickHandler(dom.MouseEvent e) {
//    (injector.get(NgRoutingHelper) as NgRoutingHelper).router.go('user.article.edit', {
//        'userId': 'Martin', 'articleId': 'Knife'
//    });
//  }
}

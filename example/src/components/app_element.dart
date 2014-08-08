library bwu_polymer_router.example.app_element;

import 'dart:html' as dom;
import 'package:polymer/polymer.dart';
import 'package:di/di.dart' show Module, ModuleInjector, Injector, TypeReflector;
import 'package:bwu_polymer_routing/module.dart'
    show RouteInitializerFn, RoutingModule, RoutingHelper, RouteProvider;
import 'package:bwu_polymer_routing/static_keys.dart';
import 'route_initializer.dart';

class AppModule extends Module {
  AppModule() : super() {
    install(new RoutingModule(usePushState: false));
    bindByKey(ROUTE_INITIALIZER_FN_KEY, toValue: new RouteInitializer());
  }
}

@CustomTag('app-element')
class AppElement extends PolymerElement {
  AppElement.created() : super.created();

  static Injector injector;

  @override
  void attached() {
    injector = new ModuleInjector([new AppModule()]);

    super.attached();

    _serveDiRequests();
  }

  void _serveDiRequests() {
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
  }

//  void editButtonClickHandler(dom.MouseEvent e) {
//    (injector.get(NgRoutingHelper) as NgRoutingHelper).router.go('user.article.edit', {
//        'userId': 'Martin', 'articleId': 'Knife'
//    });
//  }
}

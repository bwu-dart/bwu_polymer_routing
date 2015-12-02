@HtmlImport('app_element.html')
library bwu_polymer_routing_examples.example_02.components.app_element;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:di/di.dart' show Module, ModuleInjector;
import 'package:bwu_polymer_routing/module.dart' show RoutingModule;
import 'package:bwu_polymer_routing/bind_view.dart';
import 'package:bwu_polymer_routing/static_keys.dart';
import 'package:bwu_polymer_routing_examples/shared/route_initializer.dart';

import 'package:bwu_polymer_routing_examples/shared/user_list.dart';
import 'package:bwu_polymer_routing_examples/shared/user_element.dart';
import 'package:bwu_polymer_routing_examples/shared/article_list.dart';
import 'package:bwu_polymer_routing_examples/shared/article_element.dart';

/// Silence analyzer [BindView], [UserList], [UserElement], [ArticleList],
/// [ArticleElement]
class AppModule extends Module {
  AppModule() : super() {
    install(new RoutingModule(usePushState: true));
    bindByKey(routeInitializerFnKey, toValue: new RouteInitializer());
  }
}

@PolymerRegister('app-element')
class AppElement extends PolymerElement with DiContext {
  AppElement.created() : super.created();

  @override
  void attached() {
    super.attached();

    initDiContext(this, new ModuleInjector(<Module>[new AppModule()]));
  }
}

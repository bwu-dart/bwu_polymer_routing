library bwu_polymer_routing_example.static_keys;

import 'dart:html' as dom;
import 'package:di/di.dart';
import 'bind_route.dart';
import 'bind_view.dart';
import 'module.dart';
//import 'package:angular/routing/module.dart';

//export 'package:angular/core_dom/static_keys.dart' show WINDOW_KEY, DIRECTIVE_MAP_KEY;

final Key WINDOW_KEY = new Key(dom.Window);

Key PM_BIND_ROUTE_KEY = new Key(BindRoute);
Key PM_ROUTING_USE_PUSH_STATE_KEY = new Key(NgRoutingUsePushState);
Key PM_VIEW_KEY = new Key(BindView);
Key ROUTE_PROVIDER_KEY = new Key(RouteProvider);
Key ROUTE_INITIALIZER_FN_KEY = new Key(RouteInitializerFn);
Key PM_ROUTING_HELPER_KEY = new Key(NgRoutingHelper);
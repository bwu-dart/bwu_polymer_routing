library bwu_polymer_routing.static_keys;

import 'dart:html' as dom;
import 'package:di/di.dart';
import 'bind_route.dart';
import 'bind_view.dart';
import 'module.dart';

final Key windowKey = new Key(dom.Window);

Key pmBindRouteKey = new Key(BindRoute);
Key pmRoutingUsePushStateKey = new Key(NgRoutingUsePushState);
Key pmViewKey = new Key(BindView);
Key routeProviderKey = new Key(RouteProvider);
Key routeInitializerFnKey = new Key(RouteInitializerFn);
Key pmRoutingHelperKey = new Key(RoutingHelper);

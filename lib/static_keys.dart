library bwu_polymer_routing.static_keys;

import 'dart:html' as dom;
import 'package:di/di.dart';
import 'bind_route.dart';
import 'bind_view.dart';
import 'module.dart';

final Key windowKey = new Key(dom.Window);
@Deprecated('see windowKey')
final Key WINDOW_KEY = windowKey;

Key pmBindRouteKey = new Key(BindRoute);
@Deprecated('see pmBindRouteKey')
Key PM_BIND_ROUTE_KEY = pmBindRouteKey;
Key pmRoutingUsePushStateKey = new Key(NgRoutingUsePushState);
@Deprecated('see pmRoutingUsePushStateKey')
Key PM_ROUTING_USE_PUSH_STATE_KEY = pmRoutingUsePushStateKey;
Key pmViewKey = new Key(BindView);
@Deprecated('see pmViewKey')
Key PM_VIEW_KEY = pmViewKey;
Key routeProviderKey = new Key(RouteProvider);
@Deprecated('see routeProviderKey')
Key ROUTE_PROVIDER_KEY = routeProviderKey;
Key routeInitializerFnKey = new Key(RouteInitializerFn);
@Deprecated('see routeInitializerFnKey')
Key ROUTE_INITIALIZER_FN_KEY = routeInitializerFnKey;
Key pmRoutingHelperKey = new Key(RoutingHelper);
@Deprecated('see pmRoutingHelperKey')
Key PM_ROUTING_HELPER_KEY = pmRoutingHelperKey;

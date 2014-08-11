library bwu_polymer_routing.di;

import 'dart:html' as dom;
import 'dart:async' as async;
import 'package:di/di.dart' as di;
import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing/module.dart' show RouteProvider;
import 'package:route_hierarchical/client.dart' as rt;

/**
 * Mixin to enable Polymer elements to serve DI requests.
 */
class DiContext {
  di.Injector _injector;

  void initDiContext(dom.Element host, di.Injector injector) {
    _injector = injector;

    host.on['bwu-polymer-di'].listen((dom.CustomEvent e) {
      e.preventDefault();
      e.stopImmediatePropagation();
      try {
      e.detail.keys.where((k) => e.detail[k] == null).forEach((k) {
        e.detail[k] = injector.get(k);
      });
      } catch(e) {
        print(e);
      }
      e.detail[di.Injector] = injector;
    });
  }
}

/**
 * Mixin with helper methods for DI requests in Polymer elements and
 * routing helper methods.
 */
class DiConsumer {
  // TODO(zoechi) DartDoc
  Map<Type,dynamic> inject(dom.Element host, [List<Type> types]) {
    var event = new dom.CustomEvent('bwu-polymer-di', detail: new Map.fromIterable(types, value: (t) => null));
    host.dispatchEvent(event);

    if(event.defaultPrevented) {
      return event.detail;
    } else {
      throw 'No di context served the request.';
    }
  }

  rt.Router _router;
  rt.Router get router => _router;

  RouteProvider _routeProvider;
  RouteProvider get routeProvider => _routeProvider;

// TODO(zoechi) DartDoc
  void _injectRouter(dom.Element host, [bool force = false]) {
    if(_router == null || force) {
      var di = inject(host, [RouteProvider, rt.Router]);
      _router = (di[rt.Router] as rt.Router);
      _routeProvider = (di[RouteProvider]) as RouteProvider;
    }
  }

// TODO(zoechi) DartDoc
  void parentRoute(dom.Event e) {
    e.preventDefault();
    _injectRouter(e.target);
    if(router == null)
      return;

    router.go(_routeToPath(routeProvider.route.parent), routeProvider.parameters);
  }

  String _routeToPath(rt.Route route) {
    String path = route.name;
    var parent = route.parent;
    while(parent != null && parent.name != null) {
      path = '${parent.name}.${path}';
      parent = parent.parent;
    }
    return path;
  }

// TODO(zoechi) DartDoc
  void routePath(dom.Event e) {
    e.preventDefault();
    _injectRouter(e.target);
    if(router == null)
      return;

    dom.Element target = e.target;
    var routePath = target.attributes['route-path'];
    Map additionalParameters = {};
    target.attributes.forEach((k, v) {
      if(k.startsWith('route-param-name')) {
        additionalParameters[v] = target.attributes['route-param-value${k.substring('route-param-name'.length)}'];
      }
    });

    if(additionalParameters == null) additionalParameters = {};
    router.go(routePath,
      routeProvider.parameters..addAll(additionalParameters));
  }

}
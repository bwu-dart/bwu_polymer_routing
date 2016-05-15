library bwu_polymer_routing.di;

import 'dart:html' as dom;
import 'dart:async' as async;
import 'package:di/di.dart' as di;
import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing/module.dart' show RouteProvider;
import 'package:route_hierarchical/client.dart' as rt;

import 'package:logging/logging.dart' show Logger;

final _log = new Logger('bwu_polymer_routing.di');

// Mixin to enable Polymer elements to serve DI requests.
@behavior
class DiContext {
  di.Injector _injector;

  /// Allows direct access to the injector for instances that have
  /// DiContext mixing applied, without using the event method of [DiConsumer].
  di.Injector get injector => _injector;

  /// Initializes the mixin.
  /// [host] is the element that processes injector request events (bwu-polymer-di).
  /// [injector] is the injector to use to resolve the requested instances.
  void initDiContext(dom.Element host, di.Injector injector) {
    _injector = injector;
    host.on['bwu-polymer-di'].listen((dom.CustomEvent e) {
      e.preventDefault();
      e.stopImmediatePropagation();
      try {
        (e.detail as Map<Type, dynamic>)
            .keys
            .where((k) => e.detail[k] == null)
            .forEach((k) {
          e.detail[k] = injector.get(k);
        });
      } catch (e) {
        print(e);
      }
      e.detail[di.Injector] = injector;
    });
  }
}

/// Mixin with helper methods for DI requests in Polymer elements and
/// routing helper methods.
@behavior
class DiConsumer {
  /// Fires an event which is processed by parent elements that act as
  /// DI provider (have the `DiContext` mixin applied and initialized).
  /// [host] is the element used to fire the DI request event.
  /// [types] is a list of requested types.
  /// It returns a map where the requested [Type] is associated with the value
  /// resolved resolved by DI.
  Map<Type, dynamic> inject(dom.Element host, [List<Type> types]) {
    var event = new dom.CustomEvent('bwu-polymer-di',
        detail: new Map.fromIterable(types, value: (t) => null));
    host.dispatchEvent(event);

    if (event.defaultPrevented) {
      return event.detail as Map<Type, dynamic>;
    } else {
      throw 'No DiContext served the request.';
    }
  }

  rt.Router _router;
  //rt.Router get router => _router;

  RouteProvider _routeProvider;
  //RouteProvider get routeProvider => _routeProvider;

  /// Requests a [rt.Router] instance from a DI provider.
  void _injectRouter(dom.Element host, [bool force = false]) {
    if (_router == null || force) {
      var di = inject(host, [RouteProvider, rt.Router]);
      _router = (di[rt.Router] as rt.Router);
      _routeProvider = (di[RouteProvider]) as RouteProvider;
      _log.finest(
          '_injectRouter got _router: ${_router}, _routeProvider: ${_routeProvider}.');
    }
  }

  /// Make the parent route of the current route the current route.
  /// [host] is the element used to fire the DI request event.
  /// The return value indicates whether the navigation was successful.
  async.Future<bool> goParentRoute(dom.Element host) {
    _injectRouter(host);

    // TODO(zoechi) appropriate error handling instead of just ignoring the missing router
    if (_router == null) {
      return new async.Future.value();
    }

    return _router.go(
        routeToPath(_routeProvider.route.parent), _routeProvider.parameters);
  }

  /// Similar to [goParentRoute] but has a method signature so it can
  /// be used as event handler for example in a Polymer binding.
  @reflectable
  void goParentRouteHandler(dom.Event e, [_]) {
    e.preventDefault();
    e.stopImmediatePropagation();
    goParentRoute(new PolymerEvent(e).rootTarget);
  }

  /// Navigate to the defined [routePath] and apply the passed [parameters].
  /// The return value indicates whether the navigation was successful.
  async.Future<bool> goPath(dom.Element host, String routePath,
      {Map<String, String> parameters: const {}}) {
    _injectRouter(host);
    _log.finest(
        'goPath(): routePath: ${routePath}, activePath.length: ${_router.activePath.length}');
    return _router.go(
        routePath,
        _router.activePath.isEmpty
            ? parameters
            : (_router.activePath[_router.activePath.length - 1].parameters
              ..addAll(parameters)));
  }

  /// Navigate to the path specified by element attributes and apply parameters specified
  /// by element attributes.
  /// [host] is the element used to fire the DI request event.
  /// The return value indicates whether the navigation was successful.
  /// The path is read from the attribute `route-path`.
  /// The route parameters are read from attributes starting with `route-param-name-` and
  /// `route-param-value-`
  async.Future<bool> goPathFromAttributes(dom.Element host) {
    _injectRouter(host);
    var routePath = host.attributes['route-path'];
    Map additionalParameters = {};
    host.attributes.forEach((k, v) {
      if (k.startsWith('route-param-name')) {
        additionalParameters[v] = host.attributes[
            'route-param-value${k.substring('route-param-name'.length)}'];
      }
    });

    if (additionalParameters == null) additionalParameters = {};
    return _router.go(
        routePath,
        _router.activePath[_router.activePath.length - 1].parameters
          ..addAll(additionalParameters));
  }

  /// Similar to [goPathFromAttributes] but has a method signature so it can
  /// be used as event handler for example in a Polymer binding.
  @reflectable
  void goPathHandler(dom.Event e, [_]) {
    e.preventDefault();
    e.stopImmediatePropagation();

    goPathFromAttributes(new PolymerEvent(e).rootTarget);
  }

  /// Returns the path of the passed [route].
  String routeToPath(rt.Route route) {
    String path = route.name;
    var parent = route.parent;
    while (parent != null && parent.name != null) {
      path = '${parent.name}.${path}';
      parent = parent.parent;
    }
    return path;
  }
}

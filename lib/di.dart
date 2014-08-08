library bwu_polymer_routing.di;

import 'package:di/di.dart' as di;
import 'dart:html' as dom;
import 'package:polymer/polymer.dart';

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
 * Mixin with helper methods for DI requests in Polymer elements.
 */
class DiConsumer {
  Map<Type,dynamic> inject(PolymerElement host, [List<Type> types]) {

    var event = host.fire('bwu-polymer-di', detail: new Map.fromIterable(types, value: (t) => null));

    if(event.defaultPrevented) {
      return event.detail;
    } else {
      throw 'No di context served the request.';
    }
  }
}
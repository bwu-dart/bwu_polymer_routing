@HtmlImport('bind_view.html')
library bwu_polymer_routing.bind_view;

import 'dart:html' as dom;
import 'dart:async' show Future, Stream, StreamController, StreamSubscription;
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/module.dart'
    show RouteProvider, RoutingHelper, View;
import 'package:polymer/polymer.dart';
import 'package:di/di.dart' show Injector, Module, ModuleInjector;
import 'package:bwu_polymer_routing/di.dart';

export 'package:bwu_polymer_routing/di.dart';

@PolymerRegister('bind-view')
class BindView extends PolymerElement
    with DiContext, DiConsumer
    implements RouteProvider {
  factory BindView() => new dom.Element.tag('bind-view') as BindView;

  BindView.created() : super.created();

  RoutingHelper _locationService;
  rt.RouteHandle routeHandle;
  Injector _appInjector;

  View _view;
  rt.Route _viewRoute;

  @override
  void attached() {
    super.attached();
    _init();
  }

  void _init() {
    new Future(() {
      // request from parent injector
      var di = inject(this, <Type>[rt.Router, RoutingHelper]);
      rt.Router router = di[rt.Router];
      _locationService = di[RoutingHelper];
      // add this as sub-module
      _appInjector = new ModuleInjector(
          <Module>[new Module()..bind(RouteProvider, toValue: this)],
          (di[Injector] as Injector));

      RouteProvider routeProvider =
          (di[Injector] as Injector).get(RouteProvider);

      routeHandle = routeProvider != null
          ? routeProvider.route.newHandle()
          : router.root.newHandle();
      _locationService.registerPortal(this);

      maybeReloadViews();

//      initDiContext($['content'], _appInjector);
      initDiContext(this, _appInjector);
    });
  }

  void maybeReloadViews() {
    if (routeHandle.isActive) {
      _locationService.reloadViews(startingFrom: routeHandle);
    }
  }

  @override
  void detached() {
    routeHandle.discard();
    _locationService.unregisterPortal(this);
    _cleanUp();
    super.detached();
  }

  dom.Element _viewElement;

  void show(View viewDef, rt.Route route, List<Module> modules) {
    assert(route.isActive);

    if (_viewRoute != null) {
      _destroyParameterBindings();
      _createParameterBindings(viewDef);
      return;
    }
    _viewRoute = route;

    StreamSubscription _leaveSubscription;
    _leaveSubscription = route.onLeave.listen((_) {
      _leaveSubscription.cancel();
      _leaveSubscription = null;
      _viewRoute = null;
      _cleanUp();
    });

    _cleanUp();
    _view = viewDef;

    _viewElement = new dom.Element.tag(viewDef.template);
    new PolymerDom(this).append(_viewElement);
    PolymerDom.flush();

    _createParameterBindings(viewDef);
  }

  List _dynamicBindings = [];

  void _createParameterBindings(View viewDef) {
    if (parameters != null) {
      try {
        if (viewDef.bindParameters != null) {
          viewDef.bindParameters.forEach((String k) {
            _dynamicBindings.add(_parameters.onChange.listen(
                (ValueChangeEvent e) =>
                    (_viewElement as PolymerElement).set(e.name, e.value)));
          });
        } else {
          parameters.keys.forEach((String k) {
            _dynamicBindings.add(_parameters.onChange.listen(
                (ValueChangeEvent e) =>
                    (_viewElement as PolymerElement).set(e.name, e.value)));
          });
        }
      } catch (e, s) {
        print('$e\n$s');
        print(
            'Use routeCfg "bindParameters" option to limit the parameters bound to the view element.');
      }
    }
  }

  void _destroyParameterBindings() {
    _dynamicBindings.forEach((StreamSubscription scr) => scr.cancel());
    _dynamicBindings.clear();
    _parameters = null;
  }

  void _cleanUp() {
    _destroyParameterBindings();

    if (_view == null) {
      return;
    }
    final PolymerDom self = new PolymerDom(this);
    for (dom.Element element in getEffectiveChildren()) {
      self.removeChild(element);
    }
    PolymerDom.flush();
    _view = null;
  }

  @override
  rt.Route get route => _viewRoute;

  @override
  String get routeName => _viewRoute.name;

  ObservableMap<String, String> _parameters;
  @override
  Map<String, String> get parameters {
    if (_parameters == null) {
      _parameters = new ObservableMap<String, String>();
      var p = _viewRoute;
      while (p != null) {
        if (p.parameters != null) {
          _parameters.addAll(p.parameters as Map<String, String>);
        }
        p = p.parent;
      }
    }
    return _parameters;
  }
}

class ValueChangeEvent<K, V> {
  final K name;
  final V value;
  final V oldValue;

  ValueChangeEvent(this.name, this.value, this.oldValue);
}

class ObservableMap<K, V> implements Map<K, V> {
  Map<K, V> _map = <K, V>{};
  StreamController<ValueChangeEvent> _changeEventsController =
      new StreamController<ValueChangeEvent>();
  Stream<ValueChangeEvent> _changeEvents;
  Stream<ValueChangeEvent> get onChange => _changeEvents;

  ObservableMap() {
    _changeEvents = _changeEventsController.stream.asBroadcastStream();
  }

  void _addAllEvents(List<ValueChangeEvent> events) {
    if (events.isNotEmpty) {
      for (final ValueChangeEvent event in events) {
        _changeEventsController.add(event);
      }
    }
  }

  @override
  String toString() => _map.toString();

  @override
  V operator [](Object key) => _map[key];

  @override
  void operator []=(K key, V value) {
    final V oldValue = _map[key];
    if (value != oldValue) {
      _map[key] = value;
      _changeEventsController.add(new ValueChangeEvent(key, value, oldValue));
    }
  }

  @override
  void addAll(Map<K, V> other) {
    final Map<K, V> oldValues = new Map<K, V>.fromIterable(other.keys,
        key: (K key) => key, value: (K key) => _map[key]);
    _map.addAll(other);

    List<ValueChangeEvent> events = <ValueChangeEvent>[];
    for (final K key in other.keys) {
      if (oldValues[key] != other[key]) {
        events.add(new ValueChangeEvent(key, other[key], oldValues[key]));
      }
      _addAllEvents(events);
    }
  }

  @override
  void clear() {
    List<ValueChangeEvent> events = <ValueChangeEvent>[];
    for (final K key in _map.keys) {
      events.add(new ValueChangeEvent(key, null, _map[key]));
      _map.clear();
      _addAllEvents(events);
    }
  }

  @override
  bool containsKey(Object key) => _map.containsKey(key);

  @override
  bool containsValue(Object value) => _map.containsValue(value);

  @override
  void forEach(void f(K key, V value)) => _map.forEach(f);

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  Iterable<K> get keys => _map.keys;

  @override
  int get length => _map.length;

  @override
  V putIfAbsent(K key, V ifAbsent()) {
    if (_map.containsKey(key)) {
      return _map[key];
    } else {
      final V result = _map.putIfAbsent(key, ifAbsent);
      _changeEventsController.add(new ValueChangeEvent(key, _map[key], null));
      return result;
    }
  }

  @override
  V remove(Object key) {
    V result;
    if (_map.containsKey(key)) {
      result = _map.remove(key);
      _changeEventsController.add(new ValueChangeEvent(key, null, result));
    }
    return result;
  }

  @override
  Iterable<V> get values => _map.values;
}

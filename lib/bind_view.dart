library bwu_polymer_routing.bind_view;

import 'dart:html' as dom;
import 'dart:async' as async;
import 'dart:collection' as coll;
import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/module.dart'
  show RouteProvider, RoutingHelper, View, RouteHandle;
import 'package:polymer/polymer.dart';
import 'package:di/di.dart' show Injector, Module, ModuleInjector;


@CustomTag('bind-view')
class BindView extends PolymerElement implements RouteProvider {
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
    new async.Future(() {
      var event = fire('polymer-di', detail: {
        rt.Router: null,
        RoutingHelper: null});

      if(event.defaultPrevented) {
        var di = event.detail;
        rt.Router router = di[rt.Router];
        _locationService = di[RoutingHelper];
        _appInjector = new ModuleInjector([new Module()
            ..bind(RouteProvider, toValue: this)], (di[Injector] as Injector));
        RouteProvider routeProvider = (di[Injector]as Injector).get(RouteProvider);

        routeHandle = routeProvider != null ?
            routeProvider.route.newHandle() :
              router.root.newHandle();
        _locationService.registerPortal(this);
        maybeReloadViews();
      } else {
        print('DI request was not handled.');
      }

      _serveDiRequests();
    });
  }

  void _serveDiRequests() {
    $['content'].on['polymer-di'].listen((dom.CustomEvent e) {
      e.preventDefault();
      e.stopImmediatePropagation();
      try {
      e.detail.keys.where((k) => e.detail[k] == null).forEach((k) {
        e.detail[k] = _appInjector.get(k);
      });
      } catch(e) {
        print(e);
      }
      e.detail[Injector] = _appInjector;
    });
  }

  void maybeReloadViews() {
     if (routeHandle.isActive) _locationService.reloadViews(startingFrom: routeHandle);
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

    async.StreamSubscription _leaveSubscription;
    _leaveSubscription = route.onLeave.listen((_) {
      _leaveSubscription.cancel();
      _leaveSubscription = null;
      _viewRoute = null;
      _cleanUp();
    });

    _cleanUp();
    _view = viewDef;

    //print('append: ${viewDef.template}');
    _viewElement = new dom.Element.tag(viewDef.template);
    append(_viewElement);

    _createParameterBindings(viewDef);
  }

  List _dynamicBindings = [];

  void _createParameterBindings(View viewDef) {
    if(parameters != null) {
      if(viewDef.bindParameters != null) {
        viewDef.bindParameters.forEach((k) {
          //print('bind-view id ${id} - view ${viewDef.template}, parameter: ${k}');
          _dynamicBindings.add((_viewElement as PolymerElement)
            .bindProperty(new Symbol(k), new PathObserver(this, 'parameters.${k}')));
        });
      } else {
        parameters.keys.forEach((k) {
          //print('bind-view id ${id} - view ${viewDef.template}, parameter: ${k}');
          _dynamicBindings.add((_viewElement as PolymerElement)
            .bindProperty(new Symbol(k), new PathObserver(this, 'parameters.${k}')));
        });
      }
    }
  }

  void _destroyParameterBindings() {
    _dynamicBindings.forEach((Bindable b) => b.close());
    _dynamicBindings.clear();
  }

  void _cleanUp() {
    _destroyParameterBindings();

    if (_view == null) return;
    children.clear();
    _view = null;
  }

  rt.Route get route => _viewRoute;

  String get routeName => _viewRoute.name;

  Map<String, String> get parameters {
    var res = new coll.HashMap<String, String>();
    var p = _viewRoute;
    while (p != null) {
      res.addAll(p.parameters);
      p = p.parent;
    }
    return res;
  }
}

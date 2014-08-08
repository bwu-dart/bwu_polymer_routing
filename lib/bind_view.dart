library bwu_polymer_routing.bind_view;

import 'dart:html' as dom;
import 'dart:async' as async;
import 'dart:collection' as coll;
import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/module.dart'
  show RouteProvider, NgRoutingHelper, View, RouteHandle;
import 'package:polymer/polymer.dart';
import 'package:di/di.dart' show Injector, Module;


@CustomTag('bind-view')
class BindView extends PolymerElement implements RouteProvider {
  BindView.created() : super.created();

  NgRoutingHelper _locationService;
  rt.RouteHandle routeHandle;
  Injector _appInjector;

  View _view;
  rt.Route _viewRoute;

  @override
  void attached() {
    super.attached();

    new async.Future(() {
      var event = fire('polymer-di', detail: {
        rt.Router: null,
        NgRoutingHelper: null});

      if(event.defaultPrevented) {
        var di = event.detail;
        rt.Router router = di[rt.Router];
        _locationService = di[NgRoutingHelper];
        _appInjector = (di[Injector] as Injector)
            .createChild([new Module()
            ..bind(RouteProvider, toValue: this)]);
        RouteProvider routeProvider = (di[Injector]as Injector).get(RouteProvider);

        routeHandle = routeProvider != null ?
            routeProvider.route.newHandle() :
              router.root.newHandle();
        _locationService.registerPortal(this);
        maybeReloadViews();
      } else {
        print('DI error');
      }

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

  void show(View viewDef, rt.Route route, List<Module> modules) {
    assert(route.isActive);

    if (_viewRoute != null) return;
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
    var viewElement = new dom.Element.tag(viewDef.template);
    append(viewElement);
    if(parameters != null) {
      bindingParameters.keys.forEach((k) {
        //print('bind-view id ${id} - view ${viewDef.template}, parameter: ${k}');
        dynamicBindings.add((viewElement as PolymerElement)
          .bindProperty(new Symbol(k), new PathObserver(this, 'bindingParameters.${k}')));
      });
    }
  }

  List dynamicBindings = [];
  Map<String, String> get bindingParameters => _viewRoute.parameters;

  void _cleanUp() {
    dynamicBindings.forEach((Bindable b) => b.close());
    dynamicBindings.clear();

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

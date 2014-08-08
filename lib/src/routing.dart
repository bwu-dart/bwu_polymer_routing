part of bwu_polymer_routing.module;

/**
 * A factory of route to template bindings.
 */
class RouteViewFactory {
  RoutingHelper locationService;

  RouteViewFactory(this.locationService);

  Function call(String templateUrl) =>
      (rt.RouteEnterEvent event) => _enterHandler(event, templateUrl);

  void _enterHandler(rt.RouteEnterEvent event, String templateUrl,
                     {List<di.Module> modules, List<String> bindParameters}) {
    locationService._route(event.route, templateUrl, fromEvent: true,
        modules: modules, bindParameters: bindParameters);
  }

  void configure(Map<String, RouteCfg> config) {
    _configure(locationService.router.root, config);
  }

  void _configure(rt.Route route, Map<String, RouteCfg> config) {
    config.forEach((name, cfg) {
      var modulesCalled = false;
      List<di.Module> newModules;
      route.addRoute(
          name: name,
          path: cfg.path,
          defaultRoute: cfg.defaultRoute,
          enter: (rt.RouteEnterEvent e) {
            if (cfg.view != null) {
              _enterHandler(e, cfg.view,
                  modules: newModules, bindParameters: cfg.bindParameters);
            }
            if (cfg.enter != null) {
              cfg.enter(e);
            }
          },
          preEnter: (rt.RoutePreEnterEvent e) {
            if (cfg.modules != null && !modulesCalled) {
              modulesCalled = true;
              var modules = cfg.modules();
              if (modules is async.Future) {
                e.allowEnter(modules.then((List<di.Module> m) {
                  newModules = m;
                  return true;
                }));
              } else {
                newModules = modules;
              }
            }
            if (cfg.preEnter != null) {
              cfg.preEnter(e);
            }
          },
          preLeave: (rt.RoutePreLeaveEvent e) {
            if (cfg.preLeave != null) {
              cfg.preLeave(e);
            }
          },
          leave: cfg.leave,
          mount: (rt.Route mountRoute) {
            if (cfg.mount != null) {
              _configure(mountRoute, cfg.mount);
            }
          });
    });
  }
}

RouteCfg routeCfg({String path, String view,
    Map<String, RouteCfg> mount, modules(), bool defaultRoute: false,
    rt.RoutePreEnterEventHandler preEnter, rt.RouteEnterEventHandler enter,
    rt.RoutePreLeaveEventHandler preLeave, rt.RouteLeaveEventHandler leave, List<String> bindParameters}) =>
        new RouteCfg(path: path, view: view, mount: mount,
            modules: modules, defaultRoute: defaultRoute, preEnter: preEnter,
            preLeave: preLeave, enter: enter, leave: leave, bindParameters: bindParameters);

class RouteCfg {
  final String path;
  final String view;
  final Map<String, RouteCfg> mount;
  final Function modules;
  final bool defaultRoute;
  final rt.RouteEnterEventHandler enter;
  final rt.RoutePreEnterEventHandler preEnter;
  final rt.RoutePreLeaveEventHandler preLeave;
  final rt.RouteLeaveEventHandler leave;
  final List<String> bindParameters;

  RouteCfg({this.view, this.path, this.mount, this.modules, this.defaultRoute,
      this.enter, this.preEnter, this.preLeave, this.leave, this.bindParameters});
}


/**
 * An typedef that must be implemented by the user of routing library and
 * should include the route initialization.
 *
 * The function will be called by the framework once the router is
 * instantiated but before [NgBindRouteDirective] and [NgViewDirective].
 */
typedef void RouteInitializerFn(rt.Router router, RouteViewFactory viewFactory);

/**
 * A singleton helper service that handles routing initialization, global
 * events and view registries.
 */
@Injectable()
class RoutingHelper {
  final rt.Router router;
  final _portals = <BindView>[];
  final _templates = <String, View>{};

  RoutingHelper(di.Injector injector, this.router /*,
                  this._ngApp*/) {
    // TODO: move this to constructor parameters when di issue is fixed:
    // https://github.com/angular/di.dart/issues/40
    RouteInitializerFn initializerFn = injector.getByKey(ROUTE_INITIALIZER_FN_KEY);
    if (initializerFn == null) {
      dom.window.console.error('No RouteInitializer implementation provided.');
      return;
    };

    if (initializerFn != null) {
      initializerFn(router, new RouteViewFactory(this));
    }
    router.onRouteStart.listen((rt.RouteStartEvent routeEvent) {
      routeEvent.completed.then((success) {
        if (success) {
          _portals.forEach((BindView p) => p.maybeReloadViews());
        }
      });
    });

    router.listen(appRoot: dom.document.body);
  }

  void reloadViews({rt.Route startingFrom}) {
    var alreadyActiveViews = [];
    var activePath = router.activePath;
    if (startingFrom != null) {
      activePath = activePath.skip(_routeDepth(startingFrom));
    }
    for (rt.Route route in activePath) {
      var viewDef = _templates[_routePath(route)];
      if (viewDef == null) continue;
      var templateUrl = viewDef.template;

      BindView view = _portals.lastWhere((BindView v) {
        return _routePath(route) != _routePath(v.routeHandle) &&
            _routePath(route).startsWith(_routePath(v.routeHandle));
      }, orElse: () => null);
      if (view != null && !alreadyActiveViews.contains(view)) {
        view.show(viewDef, route, viewDef.modules);
        alreadyActiveViews.add(view);
        break;
      }
    }
  }

  void _route(rt.Route route, String template, {bool fromEvent, List<di.Module> modules, List<String> bindParameters}) {
    _templates[_routePath(route)] = new View(template, modules, bindParameters);
  }

  void registerPortal(BindView ngView) {
    _portals.add(ngView);
  }

  void unregisterPortal(BindView ngView) {
    _portals.remove(ngView);
  }
}

class View {
  final String template;
  final List<di.Module> modules;
  final List<String> bindParameters;

  View(this.template, this.modules, this.bindParameters);
}

String _routePath(rt.Route route) {
  final path = [];
  var p = route;
  while (p.parent != null) {
    path.insert(0, p.name);
    p = p.parent;
  }
  return path.join('.');
}

int _routeDepth(rt.Route route) {
  var depth = 0;
  var p = route;
  while (p.parent != null) {
    depth++;
    p = p.parent;
  }
  return depth;
}
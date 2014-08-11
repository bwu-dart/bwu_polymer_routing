library bwu_polymer_routing.example_02.route_initializer;

import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/module.dart';

class RouteInitializer implements Function {
  void call(rt.Router router, RouteViewFactory views) {
    views.configure({

      'overview': routeCfg(
          path: '/overview',
          view: 'view-overview',
          defaultRoute: true,
          dontLeaveOnParamChanges: true,
          enter: (route) => router.go('overview', {})),
      'movies': routeCfg(
          path: '/movies', // /:userId',
          view: 'view-movies',
          dontLeaveOnParamChanges: true,
          mount: {
        'movie': routeCfg(
            path: '/movie/:movieId',
            view: 'view-movie',
            dontLeaveOnParamChanges: true
        )}),
      'people': routeCfg(
          path: '/people',
          view: 'view-people',
          dontLeaveOnParamChanges: true,
          mount: {
        'person': routeCfg(
            path: '/person/:personId',
            view: 'view-person',
            dontLeaveOnParamChanges: true
        )}
      )
    });
  }
}

library bwu_polymer_routing_examples.shared.route_initializer;

import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/module.dart';

class RouteInitializer implements Function {
  void call(rt.Router router, RouteViewFactory views) {
    views.configure({
      'usersList': routeCfg(
          path: '/users',
          view: 'user-list',
          defaultRoute: true,
          dontLeaveOnParamChanges: true,
          enter: (rt.RouteEnterEvent route) => router.go('usersList', {})),
      'user': routeCfg(
          path: '/user/:userId',
          view: 'user-element',
          dontLeaveOnParamChanges: true,
          mount: {
            'articleList': routeCfg(
                path: '/articles',
                view: 'article-list',
                defaultRoute: true,
                dontLeaveOnParamChanges: true,
                mount: {
                  'article': routeCfg(
                      path: '/article/:articleId',
                      view: 'article-element',
                      bindParameters: <String>['articleId', 'userId'],
                      dontLeaveOnParamChanges: true,
                      mount: {
                        'view': routeCfg(
                            path: '/view',
                            defaultRoute: true,
                            dontLeaveOnParamChanges: true),
                        'edit': routeCfg(
                            path: '/edit', dontLeaveOnParamChanges: true)
                      })
                })
          })
    });
  }
}

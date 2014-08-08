library bwu_polymer_routing_example.route_initializer;

import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/module.dart';

class RouteInitializer implements Function {
  void call(rt.Router router, RouteViewFactory views) {
    views.configure({

      'usersList': ngRoute(
          path: '/users',
          view: 'user-list' /*,
          defaultRoute: true*/),
      'user': ngRoute(
          path: '/user/:userId',
          view: 'user-element',
          mount:{
            'articleList': ngRoute(
                path: '/articles',
                view: 'article-list'/*,
                defaultRoute: true*/),
            'article': ngRoute(
                path: '/article/:articleId',
                view: 'article-element',
                mount: {
                  'view': ngRoute(
                      path: '/view' /*,
                      view: 'article-element',
                      defaultRoute: true*/),
                  'edit': ngRoute(
                      path: '/edit')
                }
            )
          }
      )
    });
  }
}

library bwu_polymer_routing_example.route_initializer;

import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/module.dart';

class RouteInitializer implements Function {
  void call(rt.Router router, RouteViewFactory views) {
    views.configure({

      'usersList': routeCfg(
          path: '/users',
          view: 'user-list',
          defaultRoute: true,
          enter: (route) => router.go('usersList', {})),
      'user': routeCfg(
          path: '/user/:userId',
          view: 'user-element',
          mount:{
            'articleList': routeCfg(
                path: '/articles',
                view: 'article-list',
                defaultRoute: true),
            'article': routeCfg(
                path: '/article/:articleId',
                view: 'article-element',
                //bindParameters: ['articleId'],
                mount: {
                  'view': routeCfg(
                      path: '/view',
                      defaultRoute: true /*,
                      enter: (e) {
                          if(!e.parameters.containsKey('isEditMode')) {
                            router.go('view', {'isEditMode': false}..addAll(e.route.parent.parameters), startingFrom: e.route.parent);
                          }
                        },*/
                      ),
                  'edit': routeCfg(
                      path: '/edit' /*,
                      bindParameters: ['articleId'],
                      enter: (e) {
                          if(!e.parameters.containsKey('isEditMode')) {
                            router.go('edit', {'isEditMode': true}..addAll(e.route.parent.parameters), startingFrom: e.route.parent);
                          }
                        }*/)
                }
            )
          }
      )
    });
  }
}

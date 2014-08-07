library bwu_polymer_routing_example.route_initializer;

import 'package:route_hierarchical/client.dart' as rt;
import '../routing/module.dart';

class RouteInitializer implements Function {
  void call(rt.Router router, RouteViewFactory views) {
    views.configure({
//      'library': ngRoute(
//          path: '/library',
//          view: 'library.html',
//          mount: {
//              'all': ngRoute(path: '/all', view: 'book_list.html'),
//              'book': ngRoute(
//                  path: '/:bookId',
//                  mount: {
//                      'overview': ngRoute(path: '/overview', view: 'book_overview.html',
//                                          defaultRoute: true),
//                      'read': ngRoute(path: '/read', view: 'book_read.html'),
//                      'admin': ngRoute(path: '/admin', view: 'admin.html'),
//                  })
//          }),
//      'alt': ngRoute(
//          path: '/alt',
//          view: 'alt.html'),

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

library bwu_polymer_router.example_01.article_element;

import 'dart:async' as async;
import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing/module.dart' show RouteProvider;
import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/di.dart' as di;

@CustomTag('article-element')
class ArticleElement extends PolymerElement with di.DiConsumer {
  ArticleElement.created() : super.created();

  @observable String articleId;
  @observable String userId;
  @observable bool isEditMode = false;

  rt.Router router;
  rt.Route route;

  @override
  void attached() {
    super.attached();
    _routeChange();
  }

  void articleIdChanged(old) {
    _routeChange();
  }

  void userIdChanged(old) {
    _routeChange();
  }

  void _routeChange() {
    router = null;
    route = null;
    new async.Future(() {
      if(router != null) {
        // prevent repeated execution when
        // attached, articleIdChanged, userIdChanged fire succinctly.
        return;
      }
      _requestDependencies();
      isEditMode = route.findRoute('edit').isActive;
    });
  }

  void _requestDependencies() {
    var di = inject(this, [RouteProvider, rt.Router]);
    route = (di[RouteProvider].route as rt.Route);
    router = (di[rt.Router] as rt.Router);
  }

  void toggleEdit(e) {
    if(router == null) {
      _requestDependencies();
    }
    if(route.findRoute('view').isActive) {
      router.go('${routeToPath(route)}.edit', route.parameters)
      .then((success) {
        if(success) isEditMode = true;
      });
    } else {
      router.go('${routeToPath(route)}.view', route.parameters)
      .then((success) => isEditMode = false);
    }
  }
}

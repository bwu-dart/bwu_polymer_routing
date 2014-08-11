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

  @override
  void attached() {
    super.attached();

    _requestDependencies()
    .then((_) {
      isEditMode = route.findRoute('edit').isActive;
    });
  }

  rt.Router router;
  rt.Route route;

  async.Future _requestDependencies() {
    return new async.Future(() {
      var di = inject(this, [RouteProvider, rt.Router]);
      //userId = (di[RouteProvider] as RouteProvider).parameters['userId'];
      route = (di[RouteProvider].route as rt.Route);
      router = (di[rt.Router] as rt.Router); //.go('view', {}, startingFrom: di[RouteProvider].route);
    });
  }

  void toggleEdit(e) {
    if(route.findRoute('view').isActive) {
      router.go('edit', {}, startingFrom: route);
    } else {
      router.go('view', {}, startingFrom: route);
    }
  }
}

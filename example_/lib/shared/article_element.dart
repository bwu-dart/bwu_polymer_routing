@HtmlImport('article_element.html')
library bwu_polymer_routing_examples.shared.article_element;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:bwu_polymer_routing/module.dart' show RouteProvider;
import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/di.dart' as di;

@PolymerRegister('article-element')
class ArticleElement extends PolymerElement with di.DiConsumer {
  ArticleElement.created() : super.created();

  @property String articleId;
  @property String userId;
  @property bool isEditMode = false;

  rt.Router router;
  rt.Route route;

  @reflectable
  String editModeString(bool isEditMode) => isEditMode ? 'view' : 'edit';

  @reflectable
  String isEditModeClass(bool isEditMode) => isEditMode ? 'isEditMode' : '';

  @override
  void attached() {
    super.attached();
    routeChange();
  }

  @reflectable
  void routeChange([rt.Route newValue, rt.Route oldValue]) {
    debounce('routeChange', () {
      _requestDependencies();
      set('isEditMode', route.findRoute('edit').isActive);
    });
  }

  void _requestDependencies() {
    final Map<Type,dynamic> di = inject(this, <Type>[RouteProvider, rt.Router]);
    route = (di[RouteProvider] as RouteProvider).route;
    router = di[rt.Router] as rt.Router;
  }

  @reflectable
  void toggleEdit([_, __]) {
    if (router == null) {
      _requestDependencies();
    }
    if (route.findRoute('view').isActive) {
      router.go('${routeToPath(route)}.edit', route.parameters).then((bool success) {
        if (success) set('isEditMode', true);
      });
    } else {
      router
          .go('${routeToPath(route)}.view', route.parameters)
          .then((bool success) => set('isEditMode', false));
    }
  }
}

/*if( playground == 'core_elements' ) <!-- copyright notice core-elements -->*/

library playground.article_element;

import 'dart:html' as dom;
import 'dart:async' as async;
import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing_example/routing/module.dart' show RouteProvider;

@CustomTag('article-element')
class ArticleElement extends PolymerElement {
  ArticleElement.created() : super.created();

  @published String articleId;
  @observable String userId;

  @override
  void attached() {
    super.attached();

    new async.Future(() {
      var event = fire('polymer-di', detail: {
        RouteProvider: null
      });

      if(event.defaultPrevented) {
        var di = event.detail;
        userId = (di[RouteProvider] as RouteProvider).parameters['userId'];
      }
    });
  }
}

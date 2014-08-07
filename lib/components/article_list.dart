/*if( playground == 'core_elements' ) <!-- copyright notice core-elements -->*/

library playground.article_list;

import 'dart:html' as dom;
import 'dart:async' as async;
import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing_example/routing/module.dart' show RouteProvider;

@CustomTag('article-list')
class ArticleList extends PolymerElement {
  ArticleList.created() : super.created();

  @observable String userId;

  var articles = ['Soap', 'Knife', 'The Dark Knight Blu-Ray', 'Wine Bordeau 0.7L'];

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

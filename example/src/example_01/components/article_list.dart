library bwu_polymer_router.example.article_list;

//import 'dart:async' as async;
import 'package:polymer/polymer.dart';
//import 'package:bwu_polymer_routing/module.dart' show RouteProvider;
import 'package:bwu_polymer_routing/di.dart';

@CustomTag('article-list')
class ArticleList extends PolymerElement with DiConsumer {
  ArticleList.created() : super.created();

  @observable String userId;

  var articles = ['Soap', 'Knife', 'The Dark Knight Blu-Ray', 'Wine Bordeau 0.7L'];

  @override
  void attached() {
    super.attached();

// the 'userId' route parameter value is automatically assigned to the 'userId'
// attribute when the view is created or when the parameter value changes.
//    new async.Future(() {
//      var di = inject(this, [RouteProvider]);
//      userId = (di[RouteProvider] as RouteProvider).parameters['userId'];
//    });
  }
}

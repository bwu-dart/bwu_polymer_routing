library bwu_polymer_router.example_01.article_list;

import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing/di.dart' as di;

@CustomTag('article-list')
class ArticleList extends PolymerElement with di.DiConsumer {
  ArticleList.created() : super.created();

  @observable String userId;

  var articles = ['Soap', 'Knife', 'The Dark Knight Blu-Ray', 'Wine Bordeau 0.7L'];
}

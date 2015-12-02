@HtmlImport('article_list.html')
library bwu_polymer_routing_examples.shared.article_list;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:bwu_polymer_routing/di.dart' as di;
import 'package:bwu_polymer_routing/bind_view.dart';

/// Silence analyzer [BindView]
@PolymerRegister('article-list')
class ArticleList extends PolymerElement with di.DiConsumer {
  ArticleList.created() : super.created();

//  @property
//  String userId;

  @property
  List<String> articles = <String>[
    'Soap',
    'Knife',
    'The Dark Knight Blu-Ray',
    'Wine Bordeau 0.7L'
  ];
}

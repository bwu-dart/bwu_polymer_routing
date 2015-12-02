@HtmlImport('user_list.html')
library bwu_polymer_routing_examples.shared.user_list;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:bwu_polymer_routing/di.dart' as di;

@PolymerRegister('user-list')
class UserList extends PolymerElement with di.DiConsumer {
  UserList.created() : super.created();

  @property
  List<String> users = <String>['Jan', 'Peter', 'Julia', 'Martin'];
}

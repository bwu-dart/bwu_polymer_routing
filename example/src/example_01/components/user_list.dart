library bwu_polymer_router.example_01.user_list;

import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing/di.dart' as di;

@CustomTag('user-list')
class UserList extends PolymerElement with di.DiConsumer {
  UserList.created() : super.created();

  var users = ['Jan', 'Peter', 'Julia', 'Martin'];

  @override
  void attached() {
    super.attached();
  }
}

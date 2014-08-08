library bwu_polymer_router.example.user_list;

import 'package:polymer/polymer.dart';

@CustomTag('user-list')
class UserList extends PolymerElement {
  UserList.created() : super.created();

  var users = ['Jan', 'Peter', 'Julia', 'Martin'];

  @override
  void attached() {
    super.attached();
  }
}
